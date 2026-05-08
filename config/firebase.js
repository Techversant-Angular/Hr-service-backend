const admin = require("firebase-admin");
const path = require("path");

// TODO: Add your serviceAccountKey.json file to this backend folder to securely verify Firebase tokens
try {
    // const serviceAccount = require(path.join(__dirname, "serviceAccountKey.json"));
        const firebaseConfig = {
        projectId: process.env.FIREBASE_PROJECT_ID,
        clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        // Replace literal \n with actual newlines
        privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
    };


    // if (!admin.apps.length) {
    //     admin.initializeApp({
    //         credential: admin.credential.cert(serviceAccount)
    //     });
    // }
    admin.initializeApp({
  credential:
    admin.credential.cert(firebaseConfig)
});
} catch (error) {
    console.warn("⚠️ Firebase Admin initialization failed. Make sure you placed your 'serviceAccountKey.json' in the same folder as this file.", error.message);
}

module.exports = admin;
