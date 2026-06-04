'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("reqCandidateComments", "commentUserId", {
      type: Sequelize.INTEGER
    });
    await queryInterface.addColumn("reqCandidateComments", "commentDate", {
      type: Sequelize.DATE
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqCandidateComments", "commentUserId");
    await queryInterface.removeColumn("reqCandidateComments", "commentDate");
  }

};
