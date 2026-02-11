'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqCandidates", "candidateHiringFor", { cascade: true });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.addColumn("reqCandidates", "candidateHiringFor", {
      type: Sequelize.INTEGER,
      references: {
        model: 'reqServiceRequests',
        key: 'requestId'
      }
    })
  }
};
