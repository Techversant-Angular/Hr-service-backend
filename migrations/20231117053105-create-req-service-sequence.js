'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqServiceSequences', {
      serviceId: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      serviceStation: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqStations',
          key: 'stationId'
        }
      },
      serviceServiceRequst: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqServiceRequests',
          key: 'requestId'
        }

      },
      serviceCandidate: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqCandidates',
          key: 'candidateId'
        }
      },
      serviceAssignee: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqUsers',
          key: 'userId'
        }
      },
      serviceDate: { type: Sequelize.DATE },
      serviceStatus: {
        type: Sequelize.STRING,
        defaultValue: 'pending'
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqServiceSequences');
  }
};