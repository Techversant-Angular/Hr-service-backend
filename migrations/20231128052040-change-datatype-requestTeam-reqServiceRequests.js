'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqServiceRequests", "requestTeam");
    await queryInterface.addColumn("reqServiceRequests", "requestTeam", {
      type: Sequelize.INTEGER,
      references: {
        model: 'reqTeams',
        key: 'teamId'
      }
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqServiceRequests", "requestTeam");
    await queryInterface.addColumn("reqServiceRequests", "requestTeam", {
      type: Sequelize.STRING
    })

  }
};
