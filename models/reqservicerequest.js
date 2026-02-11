'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqServiceRequest extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      reqServiceRequest.belongsTo(models.reqTeam, { foreignKey: 'requestTeam', as: 'team' });
      reqServiceRequest.belongsTo(models.reqUser, { foreignKey: 'requestManager', as: 'reporting' });
      reqServiceRequest.belongsTo(models.reqDesignation, { foreignKey: 'requestDesignation', as: 'designation' });
      reqServiceRequest.hasOne(models.reqServiceSequence, { foreignKey: 'serviceServiceRequst' });
      reqServiceRequest.hasMany(models.reqCandidateRequestion, { foreignKey: 'serviceRequest', as: 'candidates' });
    }
  }
  reqServiceRequest.init({
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
        console.log(salaryTypeValue,'salaryTypeValue');
        
        return salaryTypeValue == 1 ? 'month' : salaryTypeValue == 2 ? 'year' : salaryTypeValue;
      }
    }

  }, {
    sequelize,
    modelName: 'reqServiceRequest',
    timestamps: false
  });
  return reqServiceRequest;
};