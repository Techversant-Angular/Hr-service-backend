'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqCandidateLogs', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      station: {
        type: Sequelize.INTEGER
      },
      candidateId: {
        type: Sequelize.INTEGER
      },
      actionBy: {
        type: Sequelize.INTEGER
      },
      action: {
        type: Sequelize.STRING
      },
      date: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue:Sequelize.NOW
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqCandidateLogs');
  }
};