'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqReport extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      reqReport.belongsTo(models.reqUser, { foreignKey: 'recruiter', as: 'recruiterName' });
      reqReport.belongsTo(models.reqServiceRequest, { foreignKey: 'position', as: 'positionName' });
    }
  }

  reqReport.init({
    recruiter: DataTypes.INTEGER,
    position: DataTypes.INTEGER,
    positionHc: DataTypes.INTEGER,
    naukriResume: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    candidateResume: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    indeedResume: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    inHouseResume: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    linkedinResume: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    sourcedScreened: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    candidateContacted: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    candidatesIntrested: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    interviewScheduled: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    offerReleased: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    interviewConducted: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    date: {
      allowNull: false,
      type: DataTypes.DATE
    }
  }, {
    sequelize,
    modelName: 'reqReport',
    timestamps: false
  });
  return reqReport;
};