'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("reqCandidates", "candidateCity", {
      type: Sequelize.STRING
    });
    await queryInterface.addColumn("reqCandidates", "candidateDistrict", {
      type: Sequelize.STRING
    });
    await queryInterface.addColumn("reqCandidates", "candidateState", {
      type: Sequelize.STRING
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqCandidates", "candidateCity");
    await queryInterface.removeColumn("reqCandidates", "candidateDistrict");
    await queryInterface.removeColumn("reqCandidates", "candidateState");
  }
};
