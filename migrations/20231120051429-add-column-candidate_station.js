'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.addColumn("reqCandidates","candidateStation",{
      type:Sequelize.BIGINT,
      references:{
        model:'reqStations',
        key:'stationId'
      }
    });
  },

  async down (queryInterface, Sequelize) {
   await queryInterface.removeColumn("reqCandidates","candidateStation");
  }
};
