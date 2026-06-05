'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqCandidates', 'candidateCoverLetter');
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.addColumn('reqCandidates', 'candidateCoverLetter', {
      type: Sequelize.TEXT,
      allowNull: true,
    });
  }
};
