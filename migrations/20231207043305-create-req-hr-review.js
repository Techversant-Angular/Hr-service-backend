'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqHrReviews', {
      reviewedId: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      reviewedServiceId: {
        type: Sequelize.INTEGER,
        references:{
          model:'reqServiceSequences',
          key:'serviceId'
        }
      },
      reviewedSalary: {
        type: Sequelize.INTEGER
      },
      reviewedDescription: {
        type: Sequelize.STRING
      },
      reviewedStatus: {
        type: Sequelize.STRING,
        defaultValue:'pending'
      },
      reviewedJoiningDate: {
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqHrReviews');
  }
};