'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.addColumn('reqinterviewDetails', 'preferMode', { type: Sequelize.INTEGER ,references:{key:'id',model:'reqworkModes'}});
    await queryInterface.addColumn('reqinterviewDetails', 'revlentExperience', { type: Sequelize.STRING });
    await queryInterface.addColumn('reqinterviewDetails', 'totalExperience', { type: Sequelize.STRING });
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqinterviewDetails', 'preferMode');
    await queryInterface.removeColumn('reqinterviewDetails', 'revlentExperience');
    await queryInterface.removeColumn('reqinterviewDetails', 'totalExperience');
  }
};
