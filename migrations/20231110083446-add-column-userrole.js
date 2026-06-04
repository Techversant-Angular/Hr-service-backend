'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("reqUserRoles", "roleUserId", {
      type: Sequelize.BIGINT,
      references: {
        model: 'reqUsers',
        key: 'userId'
      }
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqUserRoles", "roleUserId");
  }
};
