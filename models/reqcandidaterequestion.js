'use strict';
const { ref } = require('joi');
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqCandidateRequestion extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      reqCandidateRequestion.belongsTo(models.reqCandidates, { foreignKey: 'candidateId', as: 'candidateRequestion' });
      reqCandidateRequestion.belongsTo(models.reqServiceRequest, { foreignKey: 'serviceRequest', as: 'serviceRequestion' });
    }
  }
  reqCandidateRequestion.init({
    candidateRequestId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    candidateId: {
      references: {
        model: 'reqCandidates',
        key: 'candidateId'
      },
      type: DataTypes.INTEGER
    },
    serviceRequest: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqServiceRequests',
        key: 'requestId'
      }
    },
    interviewStatus: {
      type: DataTypes.STRING
    }
  }, {
    sequelize,
    modelName: 'reqCandidateRequestion',
    timestamps: false
  });
  return reqCandidateRequestion;
};