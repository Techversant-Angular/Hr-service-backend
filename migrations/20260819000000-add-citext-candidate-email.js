"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    // Enable citext extension (safe if already exists)
    await queryInterface.sequelize.query(`CREATE EXTENSION IF NOT EXISTS citext;`);

    // Alter the candidateEmail column to citext for case-insensitive comparisons
    await queryInterface.sequelize.query(
      `ALTER TABLE "reqCandidates" ALTER COLUMN "candidateEmail" TYPE citext USING "candidateEmail"::citext;`
    );
  },

  async down(queryInterface, Sequelize) {
    // Revert the candidateEmail column back to varchar(255)
    await queryInterface.sequelize.query(
      `ALTER TABLE "reqCandidates" ALTER COLUMN "candidateEmail" TYPE varchar(255);`
    );
    // Note: we intentionally do not DROP the extension because other code may rely on it.
  },
};
