'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqExperienceReports', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      technology: {
        type: Sequelize.INTEGER
      },
      interviewStatusCount: {
        type: Sequelize.INTEGER
      },
      rescheduleStatusCount: {
        type: Sequelize.INTEGER
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqExperienceReports');
  }
};