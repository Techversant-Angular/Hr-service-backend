'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.addColumn("reqServiceRequests", "requestAssignTo", {
      type: Sequelize.INTEGER,
    });
    await queryInterface.addColumn("reqServiceRequests", "requestPriority", {
      type: Sequelize.STRING,
    });
    await queryInterface.addColumn("reqServiceRequests", "requestMarketBudget", {
      type: Sequelize.STRING,
    });
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqServiceRequests", "requestAssignTo");
    await queryInterface.removeColumn("reqServiceRequests", "requestPriority");
    await queryInterface.removeColumn("reqServiceRequests", "requestMarketBudget");
  }
};
