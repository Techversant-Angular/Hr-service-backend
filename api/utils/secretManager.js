const {
  SecretsManagerClient,
  CreateSecretCommand,
  GetSecretValueCommand,
  PutSecretValueCommand,
} = require("@aws-sdk/client-secrets-manager");

const { NodeHttpHandler } = require("@smithy/node-http-handler");
const { Agent: HttpsAgent } = require("https");

let cachedClient = null;

// Returns a SecretsManagerClient using the EC2 IAM instance profile (no explicit keys needed).
// The AWS SDK automatically resolves credentials from the instance metadata service (IMDS)
// when running on EC2, ECS, or any other AWS compute with an attached IAM role.
function getSecretsManagerClient() {
  if (!cachedClient) {
    const region = process.env.AWS_REGION || "us-east-1";
    console.log(`[Secrets Manager] Initializing client in region: ${region}`);

    cachedClient = new SecretsManagerClient({
      region,
      requestHandler: new NodeHttpHandler({
        httpsAgent: new HttpsAgent({ family: 4 }),
      }),
    });
  }

  return cachedClient;
}

// ---- In-memory cache with TTL ----
const secretCache = new Map();
const CACHE_TTL_MS = 60 * 1000; // 1 minute

function setCache(secretId, value) {
  secretCache.set(secretId, {
    value,
    expiresAt: Date.now() + CACHE_TTL_MS,
  });
}

function getCache(secretId) {
  const cached = secretCache.get(secretId);

  if (cached && cached.expiresAt > Date.now()) {
    return cached.value;
  }

  return null;
}

function invalidateCache(secretId) {
  secretCache.delete(secretId);
}

class SecretsManagerAdmin {
  // Create a new secret
  static async createNewSecret(secretId, secretValue) {
    try {
      const command = new CreateSecretCommand({
        Name: secretId,
        SecretString: JSON.stringify(secretValue),
      });

      await getSecretsManagerClient().send(command);

      invalidateCache(secretId);

      console.log(`Secret ${secretId} created successfully.`);
    } catch (error) {
      if (error.name === "ResourceExistsException") {
        throw new Error(`Secret ${secretId} already exists.`);
      }

      throw new Error(`Error creating secret: ${error.message || error}`);
    }
  }

  // Get secret
  static async getSecret(secretId) {
    try {
      const cached = getCache(secretId);

      if (cached) {
        if (process.env.DEBUG === "true" || process.env.LOG_SECRETS_DEBUG === "true") {
          console.log(`Cache hit for ${secretId}`);
        }
        return cached;
      }

      const command = new GetSecretValueCommand({
        SecretId: secretId,
      });

      const response = await getSecretsManagerClient().send(command);

      let secret;

      if (response.SecretString) {
        secret = JSON.parse(response.SecretString);
      } else if (response.SecretBinary) {
        const decoded = Buffer.from(
          response.SecretBinary,
          "base64"
        ).toString("utf-8");

        secret = JSON.parse(decoded);
      } else {
        throw new Error("Secret has no SecretString or SecretBinary.");
      }

      setCache(secretId, secret);

      return secret;
    } catch (error) {
      if (error.name === "ResourceNotFoundException") {
        throw new Error(`Secret ${secretId} not found.`);
      }

      throw new Error(`Error retrieving secret: ${error.message || error}`);
    }
  }

  // Update secret
  static async updateSecretValue(secretId, secretValue) {
    try {
      const command = new PutSecretValueCommand({
        SecretId: secretId,
        SecretString: JSON.stringify(secretValue),
      });

      await getSecretsManagerClient().send(command);

      invalidateCache(secretId);

      console.log(`Secret ${secretId} updated successfully.`);
    } catch (error) {
      throw new Error(`Error updating secret: ${error.message || error}`);
    }
  }
}

// Load secret values into process.env
async function loadSecretToEnv(secretId) {
  try {
    const secretName = secretId || process.env.SECRET_NAME;

    if (!secretName) {
      throw new Error(
        "SECRET_NAME environment variable is not set and no secretId provided"
      );
    }

    console.log(`Loading secret: ${secretName}`);

    const secret = await SecretsManagerAdmin.getSecret(secretName);

    console.log(
      `Successfully fetched secret keys: [${Object.keys(secret).join(", ")}]`
    );

    let loadedCount = 0;
    let overriddenCount = 0;

    Object.entries(secret).forEach(([key, value]) => {
      const stringValue = String(value);
      const hadExistingValue = !!process.env[key];

      process.env[key] = stringValue;

      if (process.env.LOG_SECRETS_DEBUG === "true") {
        if (hadExistingValue) {
          console.log(`Overridden ${key} with value from secrets`);
        } else {
          console.log(`Loaded ${key} into process.env`);
        }
      }

      if (hadExistingValue) {
        overriddenCount++;
      } else {
        loadedCount++;
      }
    });

    console.log(
      `Successfully loaded ${
        Object.keys(secret).length
      } secrets from AWS Secrets Manager: ${loadedCount} new variables loaded, ${overriddenCount} existing variables overridden.`
    );
  } catch (error) {
    console.error(`Failed to load secret into env: ${error.message}`);
    throw error;
  }
}

// Initialize secrets
async function initializeSecrets() {
  try {
    if (process.env.SECRET_NAME) {
      console.log(
        "🔧 SECRET_NAME found, will load from AWS Secrets Manager"
      );
      await loadSecretToEnv();
    } else {
      console.log(
        "🔧 SECRET_NAME not found, using environment variables from .env file"
      );
    }
  } catch (error) {
    console.error("Failed to initialize secrets:", error.message);
    // Don't throw to allow local development
  }
}

module.exports = {
  SecretsManagerAdmin,
  loadSecretToEnv,
  initializeSecrets,
};