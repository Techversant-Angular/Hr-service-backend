require("dotenv").config();

const config = {
  username: process.env.DEV_DB_USER,
  password: process.env.DEV_DB_PASSWORD,
  database: process.env.DEV_DB_NAME,
  host: process.env.DEV_DB_HOST,
  dialect: "postgres",
  migrationStorageTableName: "SequelizeMeta",
};

module.exports = {
  development: config,
  test: config,
  qa: config,
  production: config,
};
