'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("reqServiceRequests", "requestServiceId", {
      type: Sequelize.INTEGER, references: {
        model: 'reqServices',
        key: 'sericeId'
      }
    })
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqServiceRequests", "requestServiceId");
  }
};
