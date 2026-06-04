'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.sequelize.query(
      `ALTER TABLE "reqCandidateRequestions" DROP CONSTRAINT IF EXISTS "unique_candidate_requestion";`
    );
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.sequelize.query(
      `ALTER TABLE "reqCandidateRequestions" ADD CONSTRAINT unique_candidate_requestion UNIQUE ("candidateId", "serviceRequest");`
    );
  }
};
