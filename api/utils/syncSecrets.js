const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');

// Load environment variables from the existing .env file
dotenv.config();

const { SecretsManagerAdmin } = require('./secretManager');

async function syncSecrets() {
  const secretName = process.env.SECRET_NAME;
  if (!secretName) {
    console.log("[Secrets Sync] SECRET_NAME environment variable not set. Skipping AWS Secrets Manager sync.");
    process.exit(0);
  }

  console.log(`[Secrets Sync] Fetching secrets from AWS Secrets Manager for: "${secretName}"...`);

  try {
    const secrets = await SecretsManagerAdmin.getSecret(secretName);
    const dotenvPath = path.join(__dirname, '../../.env');

    let existingContent = '';
    if (fs.existsSync(dotenvPath)) {
      existingContent = fs.readFileSync(dotenvPath, 'utf-8');
    }

    const lines = existingContent.split(/\r?\n/);
    const outputLines = [];
    const processedKeys = new Set();

    // Iterate through current lines of the .env file to update existing values
    for (let line of lines) {
      const trimmed = line.trim();
      
      // Preserve comments and empty lines
      if (trimmed === '' || trimmed.startsWith('#')) {
        outputLines.push(line);
        continue;
      }
      
      const equalIndex = line.indexOf('=');
      if (equalIndex === -1) {
        outputLines.push(line);
        continue;
      }
      
      const key = line.substring(0, equalIndex).trim();
      
      if (secrets.hasOwnProperty(key)) {
        // Value fetched from AWS Secrets Manager replaces the local one
        outputLines.push(`${key}=${secrets[key]}`);
        processedKeys.add(key);
      } else {
        // Keep existing config (e.g. SECRET_NAME, AWS credentials, etc.)
        outputLines.push(line);
      }
    }

    // Append any new secret keys that were not originally present in the .env file
    for (const [key, value] of Object.entries(secrets)) {
      if (!processedKeys.has(key)) {
        outputLines.push(`${key}=${value}`);
      }
    }

    // Write back to the .env file
    fs.writeFileSync(dotenvPath, outputLines.join('\n'), 'utf-8');
    console.log(`[Secrets Sync] Successfully synchronized ${Object.keys(secrets).length} secrets to .env file.`);
    process.exit(0);
  } catch (error) {
    console.warn("[Secrets Sync] WARNING: Failed to synchronize secrets from AWS Secrets Manager:", error.message);
    console.warn("[Secrets Sync] Continuing with existing .env values. Ensure valid AWS credentials are set in production.");
    process.exit(0);
  }
}

syncSecrets();
