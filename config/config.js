require("dotenv").config();
const { S3Client } = require("@aws-sdk/client-s3");

let config = {
    username: process.env.DEV_DB_USER,
    password: process.env.DEV_DB_PASSWORD,
    database: process.env.DEV_DB_NAME,
    host: process.env.DEV_DB_HOST,
    dialect: 'postgres',
    migrationStorageTableName: "SequelizeMeta",
    // timezone: '+05:30', //timezone added on 20-09-2024
};

let s3Config={
    region:process.env.AWS_REGION || "us-east-2",
    
}
if (process.env.AWS_ACCESS_KEY_ID && process.env.AWS_SECRET_ACCESS_KEY) {
    s3Config.credentials= {
        accessKeyId: process.env.AWS_ACCESS_KEY_ID,
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
    }
}
const s3Client = new S3Client(s3Config);

module.exports = {
    development: config,
    test: config,
    qa: config,
    production: config,
    s3Client
}