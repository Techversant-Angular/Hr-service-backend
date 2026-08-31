'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('reqCandidates', 'candidateMiddleName', {
      type: Sequelize.STRING,
      allowNull: true,
      defaultValue: null,
    });

    await queryInterface.addColumn('reqCandidates', 'candidateSummary', {
      type: Sequelize.TEXT,
      allowNull: true,
      defaultValue: null,
    });

    await queryInterface.addColumn('reqCandidates', 'candidateLinkedinUrl', {
      type: Sequelize.STRING,
      allowNull: true,
      defaultValue: null,
    });

    await queryInterface.addColumn('reqCandidates', 'candidateGithubUrl', {
      type: Sequelize.STRING,
      allowNull: true,
      defaultValue: null,
    });

    await queryInterface.addColumn('reqCandidates', 'candidateMaritalStatus', {
      type: Sequelize.STRING,
      allowNull: true,
      defaultValue: null,
    });

    await queryInterface.changeColumn('reqCandidates', 'candidateAddress', {
      type: Sequelize.STRING,
      allowNull: true,
      defaultValue: null,
    });

    await queryInterface.addColumn('reqCandidates', 'candidateImmidiateJoiner', {
      type: Sequelize.STRING,
      allowNull: true,
      defaultValue: null,
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqCandidates', 'candidateImmidiateJoiner');
    await queryInterface.changeColumn('reqCandidates', 'candidateAddress', {
      type: Sequelize.STRING,
      allowNull: true,
      defaultValue: null,
    });
    await queryInterface.removeColumn('reqCandidates', 'candidateMaritalStatus');
    await queryInterface.removeColumn('reqCandidates', 'candidateGithubUrl');
    await queryInterface.removeColumn('reqCandidates', 'candidateLinkedinUrl');
    await queryInterface.removeColumn('reqCandidates', 'candidateSummary');
    await queryInterface.removeColumn('reqCandidates', 'candidateMiddleName');
  },
};
