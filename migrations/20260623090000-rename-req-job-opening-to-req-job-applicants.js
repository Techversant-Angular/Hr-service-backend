'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const tables = await queryInterface.showAllTables();

    if (tables.includes('reqJobOpenings') && !tables.includes('reqjobapplicants')) {
      await queryInterface.renameTable('reqJobOpenings', 'reqjobapplicants');
    }
  },

  async down(queryInterface, Sequelize) {
    const tables = await queryInterface.showAllTables();

    if (tables.includes('reqjobapplicants') && !tables.includes('reqJobOpenings')) {
      await queryInterface.renameTable('reqjobapplicants', 'reqJobOpenings');
    }
  }
};
