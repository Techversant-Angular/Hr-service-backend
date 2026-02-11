'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    // await queryInterface.sequelize.query(`
    // CREATE OR REPLACE TRIGGER add_report_trigger
    // AFTER INSERT OR UPDATE
    // ON public."reqReports"
    // FOR EACH ROW
    // EXECUTE PROCEDURE add_report();`);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.sequelize.query(`
      DROP TRIGGER add_report_trigger
      ON public."reqReports"`)
  }
};
