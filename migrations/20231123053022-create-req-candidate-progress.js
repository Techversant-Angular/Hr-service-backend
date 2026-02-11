'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqCandidateProgresses', {
      progressId: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      progressScore: {
        type: Sequelize.INTEGER
      },
      progressStation: {
        type: Sequelize.INTEGER
      },
      progressVerifiedBy: {
        type: Sequelize.INTEGER
      },
      progressQuestion: {
        type: Sequelize.INTEGER
      },
      progressDescription: {
        type: Sequelize.STRING
      },
      progressServiceSequence: {
        type: Sequelize.INTEGER
      },
      progressCreatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqCandidateProgresses');
  }
};