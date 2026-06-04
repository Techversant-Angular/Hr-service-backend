'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("reqCandidates", "candidatesAddingAgainst", {
      type: Sequelize.INTEGER,
      references: {
        model: 'reqServiceRequests',
        key:'requestId'
      }
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqCandidates", "candidatesAddingAgainst");
  }
};
