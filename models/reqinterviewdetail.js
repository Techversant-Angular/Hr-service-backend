'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqinterviewDetail extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  reqinterviewDetail.init({
    serviceId: DataTypes.NUMBER,
    interviewLocation: DataTypes.STRING,
    interviewMode: DataTypes.STRING,
    interviewStatus: DataTypes.STRING,
    candidateStatus: DataTypes.STRING,
    rescheduleStatus: DataTypes.STRING,
    preferMode: DataTypes.INTEGER,
    revlentExperience: DataTypes.STRING,
    totalExperience: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'reqinterviewDetail',
  });
  return reqinterviewDetail;
};
