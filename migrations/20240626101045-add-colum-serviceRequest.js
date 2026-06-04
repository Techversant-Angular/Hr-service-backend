'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('reqServiceRequests', 'requestMinimumExperience', { type: Sequelize.INTEGER, defaultValue: 0 });
    await queryInterface.addColumn('reqServiceRequests', 'requestMaximumExperience', { type: Sequelize.INTEGER, defaultValue: 0 });
    await queryInterface.addColumn('reqServiceRequests', 'requestManager', { type: Sequelize.INTEGER });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqServiceRequests', 'requestMinimumExperience');
    await queryInterface.removeColumn('reqServiceRequests', 'requestMaximumExperience');
    await queryInterface.removeColumn('reqServiceRequests', 'requestManager');
  }
};
