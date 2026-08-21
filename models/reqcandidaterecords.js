'use strict';

const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class reqCandidateRecords extends Model {
    static associate(models) {
      reqCandidateRecords.belongsTo(models.reqUser, {
        foreignKey: 'candidateCreatedby',
        as: 'createdBy',
      });
    }
  }

  reqCandidateRecords.init({
    candidateRecordId: { type: DataTypes.INTEGER, allowNull: false, autoIncrement: true, primaryKey: true },
    candidateFirstName: { type: DataTypes.TEXT, allowNull: false },
    candidateMiddleName: DataTypes.TEXT,
    candidateLastName: { type: DataTypes.TEXT, allowNull: false },
    candidateDoB: DataTypes.DATE,
    candidateExperience: DataTypes.STRING,
    candidateStation: DataTypes.BIGINT,
    candidateGender: DataTypes.STRING(10),
    candidateMobileNo: DataTypes.STRING,
    candidateEmail: { type: DataTypes.STRING, allowNull: false },
    candidateImmidiateJoiner: DataTypes.STRING,
    candidateNoticePeriodByDays: DataTypes.STRING,
    applicationSource: DataTypes.STRING,
    preferredLocation: DataTypes.STRING,
    candidateState: DataTypes.STRING,
    candidateDistrict: DataTypes.STRING,
    candidateCity: DataTypes.STRING,
    candidateEducation: DataTypes.TEXT,
    candidateAddress: DataTypes.TEXT,
    candidateMaritalStatus: DataTypes.STRING,
    candidateLinkedinUrl: DataTypes.TEXT,
    candidateGithubUrl: DataTypes.TEXT,
    candidateRevlentExperience: DataTypes.STRING,
    candidateTotalExperience: DataTypes.STRING,
    candidatePreviousOrg: DataTypes.STRING,
    candidatePreviousDesignation: DataTypes.STRING,
    candidateCurrentSalary: DataTypes.STRING,
    candidateExpectedSalary: DataTypes.STRING,
    candidateSummary: DataTypes.TEXT,
    technicalSkills: { type: DataTypes.JSONB, defaultValue: [] },
    softSkills: { type: DataTypes.JSONB, defaultValue: [] },
    candidateResume: DataTypes.STRING,
    candidateHireRole: DataTypes.STRING,
    resumeSourceId: DataTypes.INTEGER,
    candidatesAddingAgainst: DataTypes.INTEGER,
    candidateInterviewStatus: { type: DataTypes.STRING, defaultValue: 'inprogress' },
    candidatePreferlocation: DataTypes.STRING,
    candidateCreatedby: { type: DataTypes.BIGINT, allowNull: true },
    candidateStatus: { type: DataTypes.STRING, defaultValue: 'active' },
  }, {
    sequelize,
    modelName: 'reqCandidateRecords',
    tableName: 'reqCandidateRecords',
  });

  return reqCandidateRecords;
};
