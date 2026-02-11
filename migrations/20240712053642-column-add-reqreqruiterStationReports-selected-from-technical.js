'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.addColumn('reqreqruiterStationReports', 'technicalTotalSelected', { type: Sequelize.INTEGER, defaultValue: 0 });
    await queryInterface.addColumn('reqreqruiterStationReports', 'totalSourced', { type: Sequelize.INTEGER, defaultValue: 0 });
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqreqruiterStationReports', 'technicalTotalSelected');
    await queryInterface.removeColumn('reqreqruiterStationReports', 'totalSourced');
  }
};
