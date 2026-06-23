'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqJobOpenings', {
      candidateId: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      candidateFirstName: {
        type: Sequelize.TEXT,
        allowNull: false
      },
      candidateLastName: {
        type: Sequelize.TEXT,
        allowNull: false
      },
      candidateDoB: {
        type: Sequelize.DATE
      },
      candidateExperience: {
        type: Sequelize.STRING
      },
      candidatePreviousOrg: {
        type: Sequelize.STRING
      },
      candidatePreviousDesignation: {
        type: Sequelize.STRING
      },
      candidateEducation: {
        type: Sequelize.STRING
      },
      candidateCurrentSalary: {
        type: Sequelize.STRING
      },
      candidateExpectedSalary: {
        type: Sequelize.STRING
      },
      candidateStation: {
        type: Sequelize.BIGINT,
        references: {
          model: 'reqStations',
          key: 'stationId'
        }
      },
      candidateAddress: {
        type: Sequelize.STRING
      },
      candidateCreatedby: {
        type: Sequelize.BIGINT,
        references: {
          model: 'reqUsers',
          key: 'userId'
        }
      },
      candidateStatus: {
        type: Sequelize.STRING,
        defaultValue: 'active'
      },
      candidateEmail: {
        type: Sequelize.STRING,
        allowNull: false
      },
      candidateMobileNo: {
        type: Sequelize.STRING
      },
      candidateHireRole: {
        type: Sequelize.STRING
      },
      candidateResume: {
        type: Sequelize.STRING
      },
      candidateNoticePeriodByDays: {
        type: Sequelize.STRING
      },
      resumeSourceId: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqUsers',
          key: 'userId'
        }
      },
      candidateGender: {
        type: Sequelize.STRING(10)
      },
      candidatesAddingAgainst: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqServiceRequests',
          key: 'requestId'
        }
      },
      candidateInterviewStatus: {
        type: Sequelize.STRING,
        defaultValue: 'inprogress'
      },
      candidateCity: {
        type: Sequelize.STRING
      },
      candidateDistrict: {
        type: Sequelize.STRING
      },
      candidateState: {
        type: Sequelize.STRING
      },
      candidatePreferlocation: {
        type: Sequelize.STRING
      },
      candidateRevlentExperience: {
        type: Sequelize.STRING
      },
      candidateTotalExperience: {
        type: Sequelize.STRING
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqJobOpenings');
  }
};
