const admin = require("firebase-admin");
const path = require("path");

// TODO: Add your serviceAccountKey.json file to this backend folder to securely verify Firebase tokens
try {
    // const serviceAccount = require(path.join(__dirname, "serviceAccountKey.json"));
    const serviceAccount = require("./deployement-ca1e2-firebase-adminsdk-fbsvc-bd5ce8e28f.json");


    // if (!admin.apps.length) {
    //     admin.initializeApp({
    //         credential: admin.credential.cert(serviceAccount)
    //     });
    // }
    admin.initializeApp({
  credential:
    admin.credential.cert(serviceAccount)
});
} catch (error) {
    console.warn("⚠️ Firebase Admin initialization failed. Make sure you placed your 'serviceAccountKey.json' in the same folder as this file.", error.message);
}

module.exports = admin;
