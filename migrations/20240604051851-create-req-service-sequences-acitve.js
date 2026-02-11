'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqServiceSequencesAcitves', {
      serviceActiveId	: {
        type: Sequelize.INTEGER,
        allowNull: false,
        primaryKey: true,
        autoIncrement: true,
      },serviceId:{type: Sequelize.INTEGER, references: {
        model: 'reqServiceSequences',
        key: 'serviceId'
      }},
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
      serviceDate	: {
        type: Sequelize.DATE,
        allowNull: true,
        defaultValue: Sequelize.NOW, 
      },
      serviceStatus	: {
        type: Sequelize.STRING(255),
        allowNull: true,
        defaultValue: 'pending',
      },
      serviceServiceId	: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqServices',
          key: 'sericeId'
        },
      },
      serviceScheduledBy	: {
        type: Sequelize.INTEGER,
        allowNull: true,
      },
      previousCurrentStation	: {
        type: Sequelize.INTEGER,
        allowNull: true,
      },
      resonSwitchStation	: {
        type: Sequelize.STRING(255),
        allowNull: true,
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqServiceSequencesAcitves');
  }
};