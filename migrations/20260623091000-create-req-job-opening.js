'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqJobOpenings', {
      requestId: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      requestName: {
        type: Sequelize.STRING
      },
      requestSkills: {
        type: Sequelize.STRING
      },
      requestExperience: {
        type: Sequelize.STRING
      },
      requestMinimumExperience: {
        type: Sequelize.INTEGER
      },
      requestMaximumExperience: {
        type: Sequelize.INTEGER
      },
      requestManager: {
        type: Sequelize.INTEGER
      },
      requestBaseSalary: {
        type: Sequelize.STRING
      },
      requestMaxSalary: {
        type: Sequelize.STRING
      },
      requestStatus: {
        type: Sequelize.STRING
      },
      requestTeam: {
        type: Sequelize.INTEGER
      },
      requestServiceId: {
        type: Sequelize.INTEGER
      },
      requestVacancy: {
        type: Sequelize.INTEGER
      },
      requestCode: {
        type: Sequelize.STRING
      },
      requestDesignation: {
        type: Sequelize.STRING
      },
      requestDescription: {
        type: Sequelize.TEXT
      },
      requestPostingDate: {
        type: Sequelize.DATE
      },
      requestClosingDate: {
        type: Sequelize.DATE
      },
      requestLocation: {
        type: Sequelize.STRING
      },
      requestHiredCount: {
        type: Sequelize.INTEGER
      },
      requestAssignTo: {
        type: Sequelize.INTEGER
      },
      requestPriority: {
        type: Sequelize.STRING
      },
      requestMarketBudget: {
        type: Sequelize.STRING
      },
      requestRejectReason: {
        type: Sequelize.STRING
      },
      requestSalaryType: {
        type: Sequelize.INTEGER
      }
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqJobOpenings');
  }
};
