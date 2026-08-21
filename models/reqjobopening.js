'use strict';
const {
  Model
} = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class reqJobOpening extends Model {
    static associate(models) {
      reqJobOpening.belongsTo(models.reqTeam, { foreignKey: 'requestTeam', as: 'team' });
      reqJobOpening.belongsTo(models.reqUser, { foreignKey: 'requestManager', as: 'reporting' });
      reqJobOpening.belongsTo(models.reqDesignation, { foreignKey: 'requestDesignation', as: 'designation' });
      reqJobOpening.hasOne(models.reqServiceSequence, { foreignKey: 'serviceServiceRequst' });
      reqJobOpening.hasMany(models.reqCandidateRequestion, { foreignKey: 'serviceRequest', as: 'candidates' });
      reqJobOpening.hasMany(models.reqJobApplicantsOpening, { foreignKey: 'reqJobOpeningId', as: 'jobApplicantsOpenings' });
      reqJobOpening.belongsToMany(models.reqJobApplicants, {
        through: models.reqJobApplicantsOpening,
        foreignKey: 'reqJobOpeningId',
        otherKey: 'reqJobApplicantsId',
        as: 'jobApplicantsList'
      });
      reqJobOpening.hasMany(models.reqServiceRequestsJobOpenings, {
        foreignKey: 'jobOpeningId',
        as: 'requisitionMappings',
      });
      reqJobOpening.belongsToMany(models.reqServiceRequest, {
        through: models.reqServiceRequestsJobOpenings,
        foreignKey: 'jobOpeningId',
        otherKey: 'requisitionId',
        as: 'linkedRequisitions',
      });

    }
  }

  reqJobOpening.init({
    requestId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    requestName: DataTypes.STRING,
    requestSkills: DataTypes.STRING,
    requestExperience: DataTypes.STRING,
    requestMinimumExperience: DataTypes.INTEGER,
    requestMaximumExperience: DataTypes.INTEGER,
    requestManager: DataTypes.INTEGER,
    requestBaseSalary: DataTypes.STRING,
    requestMaxSalary: DataTypes.STRING,
    requestStatus: DataTypes.STRING,
    requestTeam: DataTypes.INTEGER,
    requestServiceId: DataTypes.INTEGER,
    requestVacancy: DataTypes.INTEGER,
    requestCode: DataTypes.STRING,
    requestDesignation: DataTypes.STRING,
    requestDescription: DataTypes.TEXT,
    requestPostingDate: DataTypes.DATE,
    requestClosingDate: DataTypes.DATE,
    requestLocation: DataTypes.STRING,
    requestHiredCount: DataTypes.INTEGER,
    requestAssignTo: DataTypes.INTEGER,
    requestPriority: DataTypes.STRING,
    requestMarketBudget: DataTypes.STRING,
    requestRejectReason: DataTypes.STRING,
    requestSalaryType: {
      type: DataTypes.INTEGER,
      get() {
        const salaryTypeValue = this.getDataValue('requestSalaryType');

        return salaryTypeValue == 1 ? 'month' : salaryTypeValue == 2 ? 'year' : salaryTypeValue;
      }
    }
  }, {
    sequelize,
    modelName: 'reqJobOpening',
    timestamps: false
  });

  return reqJobOpening;
};
