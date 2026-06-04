'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqLogs', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      userId: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqUsers',
          key: 'userId'
        }
      }, serviceRequest: {
        type: Sequelize.INTEGER,
        references:{
          model:'reqServiceRequests',
          key:'requestId'
        }
      },
      fromStation: {
        type: Sequelize.INTEGER,
        references:{
          model:'reqStations',
          key:'stationId'
        }
      },
      toStation: {
        type: Sequelize.INTEGER,
        references:{
          model:'reqStations',
          key:'stationId'
        }
      },
      mail: {
        type: Sequelize.BOOLEAN
      },
      mailType: {
        type: Sequelize.STRING
      },
      status: {
        type: Sequelize.STRING
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqLogs');
  }
};