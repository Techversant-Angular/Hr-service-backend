'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqCandidateRequestions', {
      candidateRequestId: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      candidateId: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqCandidates',
          key: 'candidateId'
        },
      },
      serviceRequest: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqServiceRequests',
          key: 'requestId'
        },
      }
    });
    await queryInterface.sequelize.query(`ALTER TABLE "reqCandidateRequestions"
  ADD CONSTRAINT unique_candidate_requestion UNIQUE ("candidateId", "serviceRequest");
    `);
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqCandidateRequestions');
  }
};

//this query is used to insert data into the reqCandidateRequestions table from candidate table

// INSERT INTO "reqCandidateRequestions" ("candidateId", "serviceRequest")
// SELECT DISTINCT "candidateId", "candidatesAddingAgainst"
// FROM "reqCandidates"
// WHERE "candidatesAddingAgainst" IS NOT NULL;