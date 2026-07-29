'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('reqReports', 'candidateId', {
      type: Sequelize.INTEGER,
      allowNull: true,
      references: {
        model: 'reqCandidates',
        key: 'candidateId'
      },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL'
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqReports', 'candidateId');
  }
};
