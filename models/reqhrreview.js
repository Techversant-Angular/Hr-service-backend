'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqHrReview extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  reqHrReview.init({
    reviewedId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    reviewedServiceId: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqServiceSequences',
        key: 'serviceId'
      }
    },
    reviewedSalary: DataTypes.INTEGER,
    reviewedDescription: DataTypes.STRING,
    reviewedStatus: { type: DataTypes.STRING, defaultValue: 'pending' },
    reviewedJoiningDate: DataTypes.DATE
  }, {
    sequelize,
    modelName: 'reqHrReview',
    timestamps: false
  });
  return reqHrReview;
};