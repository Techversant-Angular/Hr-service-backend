'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('reqCandidates', 'candidatePreferlocation', { type: Sequelize.STRING });
    await queryInterface.addColumn('reqCandidates', 'candidateRevlentExperience', { type: Sequelize.STRING });
    await queryInterface.addColumn('reqCandidates', 'candidateTotalExperience', { type: Sequelize.STRING });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqCandidates', 'candidatePreferlocation');
    await queryInterface.removeColumn('reqCandidates', 'candidateRevlentExperience');
    await queryInterface.removeColumn('reqCandidates', 'candidateTotalExperience');
  }
};
