'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("reqReports", "indeedResume", { type: Sequelize.INTEGER, defaultValue: 0 });
    await queryInterface.addColumn("reqReports", "candidateResume", { type: Sequelize.INTEGER, defaultValue: 0 });
    await queryInterface.addColumn("reqReports", "inHouseResume", { type: Sequelize.INTEGER, defaultValue: 0 });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqReports", "indeedResume");
    await queryInterface.removeColumn("reqReports", "candidateResume");
    await queryInterface.removeColumn("reqReports", "inHouseResume");
  }
};
