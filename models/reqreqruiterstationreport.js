'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqreqruiterStationReport extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  reqreqruiterStationReport.init({
    position: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqServiceRequests', key: 'requestId'
      }
    },
    station: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqStations', key: 'stationId'
      }
    },
    user: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqUsers', key: 'userId'
      }
    },
    screenRejected: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    writtenReject: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    techOneReject: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    techTwoReject: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    managementReject: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    hrReject: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    offerReleased: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    hired: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    date: {
      allowNull: false,
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW
    }
  }, {
    sequelize,
    modelName: 'reqreqruiterStationReport',
    timestamps: false
  });
  return reqreqruiterStationReport;
};