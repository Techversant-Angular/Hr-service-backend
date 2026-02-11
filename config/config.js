const dotenv = (require("dotenv").config()).parsed

let config = {
    username: dotenv.DEV_DB_USER,
    password: dotenv.DEV_DB_PASSWORD,
    database: dotenv.DEV_DB_NAME,
    host: dotenv.DEV_DB_HOST,
    dialect: 'postgres',
    migrationStorageTableName: "SequelizeMeta",
    // timezone: '+05:30', //timezone added on 20-09-2024
};

module.exports = {
    development: config,
    test: config,
    production: config
}