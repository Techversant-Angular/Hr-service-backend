'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("reqCandidates", "candidateEmail", {
      type: Sequelize.STRING,
      allowNull: false
    });

    await queryInterface.addColumn("reqCandidates", "candidateMobileNo", {
      type: Sequelize.STRING,
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqCandidates", "candidateEmail");

    await queryInterface.removeColumn("reqCandidates", "candidateMobileNo");
  }
};
