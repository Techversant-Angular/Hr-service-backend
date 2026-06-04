'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("reqCandidates", "resumeSourceId", {
      type: Sequelize.INTEGER, references: {
        model: 'reqCandidateResumeSources',
        key: 'sourceId'
      }
    })
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqServiceRequests", "requestServiceId");
  }
};
