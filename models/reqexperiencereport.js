'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqExperienceReport extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      reqExperienceReport.belongsTo(models.reqServiceRequest,{foreignKey:"technology"})
    }
  }
  reqExperienceReport.init({
    technology: DataTypes.INTEGER,
    interviewStatusCount: DataTypes.INTEGER,
    rescheduleStatusCount: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'reqExperienceReport',
    timestamps:false
  });
  return reqExperienceReport;
};