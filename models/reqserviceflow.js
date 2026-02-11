'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqServiceFlow extends Model {
    
    static associate(models) {
      // define association here
    }
  }
  reqServiceFlow.init({
    flowId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    flowServiceId: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqServices',
        key: 'sericeId'
      }
    },
    flowStationId: {
      type: DataTypes.INTEGER, references: {
        model: 'reqStations',
        key: 'stationId'
      }
    },
    flowStationName: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'reqServiceFlow',
    timestamps: false
  });
  return reqServiceFlow;
};