'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqServiceRequests', {
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
        type: Sequelize.DECIMAL
      },
      requestBaseSalary: {
        type: Sequelize.STRING
      },
      requestMaxSalary: {
        type: Sequelize.STRING
      },
      requestTeam: {
        type: Sequelize.STRING
      },
      requestStatus: {
        type: Sequelize.STRING,
        defaultValue: 'pending'
      },

    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqServiceRequests');
  }
};