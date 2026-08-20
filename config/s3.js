require("dotenv").config();

const { S3Client } = require("@aws-sdk/client-s3");

const s3Config = {
  region: process.env.AWS_REGION || "us-east-2",
};

if (process.env.AWS_ACCESS_KEY_ID && process.env.AWS_SECRET_ACCESS_KEY) {
  s3Config.credentials = {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  };
}

module.exports = { s3Client: new S3Client(s3Config) };
