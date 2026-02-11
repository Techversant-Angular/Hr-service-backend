'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqServiceSequence extends Model {

    static associate(models) {
      // define association here
      reqServiceSequence.belongsTo(models.reqServiceRequest, { foreignKey: 'serviceServiceRequst', as: 'serviceRequest' });
      reqServiceSequence.belongsTo(models.reqCandidates, { foreignKey: 'serviceCandidate', as: 'candidate' });
      reqServiceSequence.hasOne(models.reqCandidateProgress, { foreignKey: 'progressServiceSequence', as: 'progress' });
      reqServiceSequence.belongsTo(models.reqServices, { foreignKey: 'serviceServiceId' });
      reqServiceSequence.belongsTo(models.reqUser, { foreignKey: 'serviceAssignee' });
      reqServiceSequence.belongsTo(models.reqServices, { foreignKey: 'serviceServiceId' });
      reqServiceSequence.hasOne(models.reqCandidateComments, { foreignKey: 'commentSeqenceId' });
      reqServiceSequence.belongsTo(models.reqStation, { foreignKey: 'serviceStation' });
      reqServiceSequence.hasOne(models.reqHrReview, { foreignKey: 'reviewedServiceId' });

    }
  }
  reqServiceSequence.init({
    serviceId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    serviceStation: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqStations',
        key: 'stationId'
      }
    },
    serviceServiceRequst: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqServiceRequests',
        key: 'requestId'
      }
    },
    serviceCandidate: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqCandidates',
        key: 'candidateId'
      },
    },
    serviceAssignee: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqUsers',
        key: 'userId'
      }
    },
    serviceDate: DataTypes.DATE,
    serviceStatus: { type: DataTypes.STRING, defaultValue: 'pending' },
    serviceServiceId: {
      type: DataTypes.INTEGER, references: {
        model: "reqServices",
        key: 'sericeId'
      }
    },
    serviceScheduledBy: {
      type: DataTypes.INTEGER
    },
    previousCurrentStation: {
      type: DataTypes.INTEGER
    },
    interviewCount: {
      type: DataTypes.INTEGER
    },
    interviewRescheduled: {
      type: DataTypes.BOOLEAN
    },
    interviewRescheduledCount: {
      type: DataTypes.INTEGER
    },
    interviewMode: {
      type: DataTypes.STRING
    },
    interviewLocation: {
      type: DataTypes.STRING
    },
    interviewMail: {
      type: DataTypes.BOOLEAN
    },
    interviewMailType: {
      type: DataTypes.STRING
    },
    insertOrUpdateDate: {
      type: DataTypes.DATE
    },
    serviceSourceDate: {
      type: DataTypes.DATE
    }
  }, {
    sequelize,
    modelName: 'reqServiceSequence',
    timestamps: false
  });
  return reqServiceSequence;
};