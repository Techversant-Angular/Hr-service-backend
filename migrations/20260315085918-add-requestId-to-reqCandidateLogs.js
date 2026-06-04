'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('reqCandidateLogs', 'requestId', {
      type: Sequelize.INTEGER,
      allowNull: true,
      references: {
        model: 'reqServiceRequests',
        key: 'requestId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'CASCADE',
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqCandidateLogs', 'requestId');
  }
};
