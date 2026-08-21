'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqCandidateRecords', {
      candidateRecordId: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },
      candidateFirstName: { type: Sequelize.TEXT, allowNull: false },
      candidateMiddleName: { type: Sequelize.TEXT },
      candidateLastName: { type: Sequelize.TEXT, allowNull: false },
      candidateDoB: { type: Sequelize.DATE },
      candidateGender: { type: Sequelize.STRING(10) },
      candidateMobileNo: { type: Sequelize.STRING },
      candidateEmail: { type: Sequelize.STRING, allowNull: false },
      candidateImmidiateJoiner: { type: Sequelize.STRING },
      candidateNoticePeriodByDays: { type: Sequelize.STRING },
      applicationSource: { type: Sequelize.STRING },
      preferredLocation: { type: Sequelize.STRING },
      candidateState: { type: Sequelize.STRING },
      candidateDistrict: { type: Sequelize.STRING },
      candidateCity: { type: Sequelize.STRING },
      candidateEducation: { type: Sequelize.TEXT },
      candidateAddress: { type: Sequelize.TEXT },
      candidateMaritalStatus: { type: Sequelize.STRING },
      candidateLinkedinUrl: { type: Sequelize.TEXT },
      candidateGithubUrl: { type: Sequelize.TEXT },
      candidateRevlentExperience: { type: Sequelize.STRING },
      candidateTotalExperience: { type: Sequelize.STRING },
      candidatePreviousOrg: { type: Sequelize.STRING },
      candidatePreviousDesignation: { type: Sequelize.STRING },
      candidateCurrentSalary: { type: Sequelize.STRING },
      candidateExpectedSalary: { type: Sequelize.STRING },
      candidateSummary: { type: Sequelize.TEXT },
      technicalSkills: { type: Sequelize.JSONB, defaultValue: [] },
      softSkills: { type: Sequelize.JSONB, defaultValue: [] },
      candidateResume: { type: Sequelize.STRING },
      candidateCreatedby: {
        type: Sequelize.BIGINT,
        references: { model: 'reqUsers', key: 'userId' },
        onUpdate: 'CASCADE',
        onDelete: 'SET NULL',
      },
      candidateStatus: { type: Sequelize.STRING, defaultValue: 'active' },
      createdAt: { allowNull: false, type: Sequelize.DATE },
      updatedAt: { allowNull: false, type: Sequelize.DATE },
    });
    await queryInterface.addIndex('reqCandidateRecords', ['candidateEmail']);
  },

  async down(queryInterface) {
    await queryInterface.dropTable('reqCandidateRecords');
  },
};
