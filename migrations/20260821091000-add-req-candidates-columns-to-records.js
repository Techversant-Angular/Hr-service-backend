'use strict';

/** Keeps reqCandidateRecords compatible with the existing reqCandidates schema. */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('reqCandidateRecords', 'candidateExperience', { type: Sequelize.STRING });
    await queryInterface.addColumn('reqCandidateRecords', 'candidateStation', {
      type: Sequelize.BIGINT,
      references: { model: 'reqStations', key: 'stationId' },
    });
    await queryInterface.addColumn('reqCandidateRecords', 'candidateHireRole', { type: Sequelize.STRING });
    await queryInterface.addColumn('reqCandidateRecords', 'resumeSourceId', { type: Sequelize.INTEGER });
    await queryInterface.addColumn('reqCandidateRecords', 'candidatesAddingAgainst', {
      type: Sequelize.INTEGER,
      references: { model: 'reqServiceRequests', key: 'requestId' },
    });
    await queryInterface.addColumn('reqCandidateRecords', 'candidateInterviewStatus', {
      type: Sequelize.STRING,
      defaultValue: 'inprogress',
    });
    await queryInterface.addColumn('reqCandidateRecords', 'candidatePreferlocation', { type: Sequelize.STRING });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('reqCandidateRecords', 'candidatePreferlocation');
    await queryInterface.removeColumn('reqCandidateRecords', 'candidateInterviewStatus');
    await queryInterface.removeColumn('reqCandidateRecords', 'candidatesAddingAgainst');
    await queryInterface.removeColumn('reqCandidateRecords', 'resumeSourceId');
    await queryInterface.removeColumn('reqCandidateRecords', 'candidateHireRole');
    await queryInterface.removeColumn('reqCandidateRecords', 'candidateStation');
    await queryInterface.removeColumn('reqCandidateRecords', 'candidateExperience');
  },
};
