const dotenv = (require("dotenv").config()).parsed
const { S3Client } = require("@aws-sdk/client-s3");

let config = {
    username: dotenv.DEV_DB_USER,
    password: dotenv.DEV_DB_PASSWORD,
    database: dotenv.DEV_DB_NAME,
    host: dotenv.DEV_DB_HOST,
    dialect: 'postgres',
    migrationStorageTableName: "SequelizeMeta",
    // timezone: '+05:30', //timezone added on 20-09-2024
};

const s3Client = new S3Client({
    region: process.env.AWS_REGION || "ap-south-1",
    credentials: {
        accessKeyId: process.env.AWS_ACCESS_KEY,
        secretAccessKey: process.env.AWS_SECRET_KEY
    }
}); 

module.exports = {
    development: config,
    test: config,
    production: config,
    s3Client
}