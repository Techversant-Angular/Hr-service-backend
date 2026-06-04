'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.addColumn("reqServiceRequests", "requestCode", {
      type: Sequelize.STRING
    });
    await queryInterface.addColumn("reqServiceRequests", "requestDesignation", {
      type: Sequelize.STRING
    });
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqServiceRequests", "requestCode");
    await queryInterface.removeColumn("reqServiceRequests", "requestDesignation");
  }
};
