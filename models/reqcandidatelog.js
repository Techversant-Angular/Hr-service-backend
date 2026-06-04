'use strict';
const {
  Model, Sequelize
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqCandidateLog extends Model {
    static associate(models) {
    }
  }
  reqCandidateLog.init({
    station: DataTypes.INTEGER,
    actionBy: DataTypes.INTEGER,
    candidateId: {
      type: DataTypes.INTEGER
    },
    action: DataTypes.STRING,
    requestId: DataTypes.INTEGER,
    date: {
      type: DataTypes.DATE,
      defaultValue: Sequelize.fn('now')
    }
  }, {
    sequelize,
    modelName: 'reqCandidateLog',
    timestamps: false
  });
  return reqCandidateLog;
};