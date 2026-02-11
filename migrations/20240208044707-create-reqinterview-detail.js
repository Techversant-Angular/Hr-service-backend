'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqinterviewDetails', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      serviceId: {
        type: Sequelize.INTEGER
      },
      interviewLocation: {
        type: Sequelize.STRING
      },
      interviewMode: {
        type: Sequelize.STRING
      },
      interviewStatus: {
        type: Sequelize.STRING
      },
      candidateStatus: {
        type: Sequelize.STRING
      },
      rescheduleStatus: {
        type: Sequelize.STRING
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqinterviewDetails');
  }
};