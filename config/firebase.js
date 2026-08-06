const admin = require("firebase-admin");
const path = require("path");
const fs = require("fs");

function formatPrivateKey(key) {
  if (!key) return undefined;
  let formatted = String(key).trim();

  // Strip any surrounding double or single quotes added by env/Secrets Manager
  while (
    (formatted.startsWith('"') && formatted.endsWith('"')) ||
    (formatted.startsWith("'") && formatted.endsWith("'"))
  ) {
    formatted = formatted.slice(1, -1).trim();
  }

  // Convert escaped newlines (\n or \\n) to actual newline characters
  formatted = formatted.replace(/\\n/g, '\n');
  return formatted;
}

function getFirebaseCredential() {
  // 1. Check if full FIREBASE_SERVICE_ACCOUNT (JSON string or object) is provided
  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    try {
      const sa = typeof process.env.FIREBASE_SERVICE_ACCOUNT === 'string'
        ? JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT)
        : process.env.FIREBASE_SERVICE_ACCOUNT;

      if (sa.private_key) {
        sa.private_key = formatPrivateKey(sa.private_key);
      }
      return admin.credential.cert(sa);
    } catch (e) {
      console.warn("⚠️ Failed to parse FIREBASE_SERVICE_ACCOUNT JSON from environment:", e.message);
    }
  }

  // 2. Check individual environment variables (FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL, FIREBASE_PRIVATE_KEY)
  const projectId = process.env.FIREBASE_PROJECT_ID;
  const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
  const privateKey = formatPrivateKey(process.env.FIREBASE_PRIVATE_KEY);
  // console.log("Firebase projectId:", projectId);
  // console.log("Firebase clientEmail:", clientEmail);
  // console.log("Firebase privateKey:", privateKey);


  if (projectId && clientEmail && privateKey) {
    return admin.credential.cert({
      projectId,
      clientEmail,
      privateKey,
    });
  }

  // 3. Fallback to local serviceAccountKey.json if present
  const localKeyPath = path.join(__dirname, "serviceAccountKey.json");
  const rootKeyPath = path.join(__dirname, "..", "serviceAccountKey.json");
  const targetPath = fs.existsSync(localKeyPath) ? localKeyPath : (fs.existsSync(rootKeyPath) ? rootKeyPath : null);

  if (targetPath) {
    try {
      const serviceAccount = require(targetPath);
      return admin.credential.cert(serviceAccount);
    } catch (e) {
      console.warn("⚠️ Failed to load serviceAccountKey.json:", e.message);
    }
  }

  return null;
}

try {
  if (!admin.apps.length) {
    const credential = getFirebaseCredential();
    if (credential) {
      admin.initializeApp({ credential });
    } else {
      console.warn("⚠️ Firebase Admin credentials not found in environment variables or serviceAccountKey.json.");
    }
  }
} catch (error) {
  console.warn("⚠️ Firebase Admin initialization failed:", error.message);
}

module.exports = admin;

