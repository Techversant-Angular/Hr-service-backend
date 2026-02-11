'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqReports', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      recruiter: {
        type: Sequelize.INTEGER
      },
      position: {
        type: Sequelize.INTEGER
      },
      positionHc: {
        type: Sequelize.INTEGER
      },
      naukriResume: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      linkedinResume: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      sourcedScreened: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      candidateContacted: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      candidatesIntrested: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      interviewScheduled: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      offerReleased: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      date: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqReports');
  }
};