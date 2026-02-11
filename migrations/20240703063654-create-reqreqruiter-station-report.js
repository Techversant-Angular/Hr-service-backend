'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqreqruiterStationReports', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      position: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqServiceRequests', key: 'requestId'
        }
      },
      station: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqStations', key: 'stationId'
        }
      },
      user: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqUsers', key: 'userId'
        }
      },
      screenRejected: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      writtenReject: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      techOneReject: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      techTwoReject: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      managementReject: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      hrReject: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      offerReleased: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      hired: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      date: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW
      }

    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqreqruiterStationReports');
  }
};