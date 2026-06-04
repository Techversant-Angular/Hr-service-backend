'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('reqServiceRequests', 'requestDescription', { type: Sequelize.TEXT });
    await queryInterface.addColumn('reqServiceRequests', 'requestPostingDate', { type: Sequelize.DATE });
    await queryInterface.addColumn('reqServiceRequests', 'requestClosingDate', { type: Sequelize.DATE });


  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqServiceRequests', 'requestDescription');
    await queryInterface.removeColumn('reqServiceRequests', 'requestPostingDate');
    await queryInterface.removeColumn('reqServiceRequests', 'requestClosingDate');
  }
};
