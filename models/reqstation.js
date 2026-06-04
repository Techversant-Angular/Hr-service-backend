'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqStation extends Model {
   
    static associate(models) {
      // define association here
    }
  }
  reqStation.init({
    stationId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    stationName: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'reqStation',
    timestamps: false
  });
  return reqStation;
};