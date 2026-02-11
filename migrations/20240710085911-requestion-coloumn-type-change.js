'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqServiceRequests', 'requestMaxSalary');
    await queryInterface.removeColumn('reqServiceRequests', 'requestBaseSalary');
    await queryInterface.addColumn('reqServiceRequests', 'requestMaxSalary', { type: Sequelize.STRING });
    await queryInterface.addColumn('reqServiceRequests', 'requestBaseSalary', { type: Sequelize.STRING });

  },

  async down (queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqServiceRequests', 'requestMaxSalary');
    await queryInterface.removeColumn('reqServiceRequests', 'requestBaseSalary');
  }
};
