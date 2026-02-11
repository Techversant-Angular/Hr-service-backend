'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqCandidates', {
      candidateId: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      candidateFirstName: {
        type: Sequelize.STRING,
        allowNull: false
      },
      candidateLastName: {
        type: Sequelize.STRING,
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
      candidateHiringFor: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqServiceRequests',
          key: 'requestId'
        }
      },
      candidatePreviousDesignation: {
        type: Sequelize.STRING
      },
      candidateGender: {
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
      candidateHireRole: { type: Sequelize.STRING },
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
    await queryInterface.dropTable('reqCandidates');
  }
};