'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("reqCandidateComments","offerReleaseReject",{
      type:Sequelize.INTEGER,
      defaultValue:0
    });
  },

  async down(queryInterface, Sequelize) {

  }
};
