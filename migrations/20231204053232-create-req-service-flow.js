'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqServiceFlows', {
      flowId: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      flowServiceId: {
        type: Sequelize.INTEGER,
        references:{
          model:'reqServices',
          key:'sericeId'
        }
      },
      flowStationId: {
        type: Sequelize.INTEGER,
          references:{
            model:'reqStations',
            key:'stationId'
          }
        
      },
      flowStationName: {
        type: Sequelize.STRING
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqServiceFlows');
  }
};