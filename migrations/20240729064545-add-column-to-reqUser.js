'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("reqUsers", "userOtp", { type: Sequelize.STRING });
    await queryInterface.addColumn("reqUsers", "useOtpExpire", { type: Sequelize.DATE });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqUsers", "userOtp");
    await queryInterface.removeColumn("reqUsers", "useOtpExpire");
  }
};
