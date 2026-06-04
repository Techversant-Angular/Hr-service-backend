'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqServiceSequencesAcitve extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      reqServiceSequencesAcitve.belongsTo(models.reqServiceRequest, { foreignKey: 'serviceServiceRequst', as: 'serviceRequest' });
      reqServiceSequencesAcitve.belongsTo(models.reqCandidates, { foreignKey: 'serviceCandidate', as: 'candidate' });
      reqServiceSequencesAcitve.hasOne(models.reqCandidateProgress, { foreignKey: 'progressServiceSequence', as: 'progress' });
      reqServiceSequencesAcitve.belongsTo(models.reqServices, { foreignKey: 'serviceServiceId' });
      reqServiceSequencesAcitve.belongsTo(models.reqUser, { foreignKey: 'serviceAssignee' });
      reqServiceSequencesAcitve.belongsTo(models.reqUser, { foreignKey: 'serviceScheduledBy',as:"scheduledBy" });
      reqServiceSequencesAcitve.belongsTo(models.reqServices, { foreignKey: 'serviceServiceId' });
      reqServiceSequencesAcitve.hasOne(models.reqCandidateComments, { foreignKey: 'commentSeqenceId' });
      reqServiceSequencesAcitve.belongsTo(models.reqStation, { foreignKey: 'serviceStation' });
      reqServiceSequencesAcitve.hasOne(models.reqHrReview, { foreignKey: 'reviewedServiceId' });
    }
  }
  reqServiceSequencesAcitve.init({
    serviceActiveId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    serviceId: {
      type: DataTypes.INTEGER, references: {
        model: 'reqServiceSequences',
        key: 'serviceId'
      }
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
    serviceStatus: { type: DataTypes.STRING },
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
  }, {
    sequelize,
    modelName: 'reqServiceSequencesAcitve',
    timestamps: false
  });
  return reqServiceSequencesAcitve;
};