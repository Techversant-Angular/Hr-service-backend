'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqLogs extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  reqLogs.init({
    userId: {
      type: DataTypes.INTEGER, references: {
        model: 'reqUsers',
        key: 'userId'
      }
    },
    serviceRequest: {
      type: DataTypes.INTEGER, references: {
        model: 'reqServiceRequests',
        key: 'requestId'
      }
    },
    fromStation: {
      type: DataTypes.INTEGER, references: {
        model: 'reqStations',
        key: 'stationId'
      }
    },
    toStation: {
      type: DataTypes.INTEGER, references: {
        model: 'reqStations',
        key: 'stationId'
      }
    },
    mail: {
      type: DataTypes.BOOLEAN
    },
    mailType: DataTypes.STRING,
    status: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'reqLogs',
    timestamps: false
  });
  return reqLogs;
};