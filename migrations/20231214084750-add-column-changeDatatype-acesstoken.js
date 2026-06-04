'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqAccessTokens", "accessToken");
    await queryInterface.addColumn("reqAccessTokens", "accessToken", { type: Sequelize.TEXT })
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqAccessTokens", "accessToken");
    await queryInterface.addColumn("reqAccessTokens", "accessToken", { type: Sequelize.STRING })
  }
};
