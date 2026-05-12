'use strict';
const { string } = require('joi');
const {
  Model, STRING
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqCandidates extends Model {

    static associate(models) {
      // define association here
      reqCandidates.belongsTo(models.reqUser, { foreignKey: 'candidateCreatedby', as: 'createdBy' });
      reqCandidates.hasMany(models.reqCandidateSkill, { foreignKey: 'candidateId', as: 'candidateSkill' });
      reqCandidates.hasOne(models.reqServiceSequence, { foreignKey: 'serviceCandidate', as: 'serviceSequence' });
      reqCandidates.belongsTo(models.reqServiceRequest,{foreignKey:'candidatesAddingAgainst'})
      reqCandidates.hasMany(models.reqCandidateRequestion, { foreignKey: 'candidateId', as: 'candidateReqst' });

    }
  }
  reqCandidates.init({
    candidateId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    candidateFirstName: {
      type: DataTypes.TEXT,
      allowNull: false,
      validate: {
        notEmpty: {
          msg: 'First name required',
        },
        notNull: {
          msg: 'First name required',
        },
      },
    },
    candidateLastName: {
      type: DataTypes.TEXT,
      allowNull: false,
      validate: {
        notNull: {
          msg: 'Last name required',
        },
        notEmpty: {
          msg: 'Last name required',
        }
      },
    },
    candidateDoB: {
      type: DataTypes.DATE,
      validate: {
        isDate: {
          msg: 'Valid Date Format required'
        }
      }
    },
    candidateExperience: DataTypes.STRING,
    candidatePreviousOrg: DataTypes.STRING,
    candidatePreviousDesignation: DataTypes.STRING,
    candidateEducation: DataTypes.STRING,
    candidateCurrentSalary: DataTypes.STRING,
    candidateExpectedSalary: DataTypes.STRING,
    candidateStation: {
      type: DataTypes.BIGINT,
      references: {
        model: 'reqStations',
        key: 'stationId'
      },
    },
    candidateAddress: DataTypes.STRING,
    candidateCreatedby: {
      type: DataTypes.BIGINT,
      references: {
        model: 'reqUsers',
        key: 'userId'
      }
    },
    candidateStatus: {
      type: DataTypes.STRING,
      defaultValue: 'active'
    },
    candidateEmail: {
      type: DataTypes.STRING,
      allowNull: false
    },
    candidateMobileNo: DataTypes.STRING,
    candidateHireRole: DataTypes.STRING,
    candidateResume: DataTypes.STRING,
    candidateNoticePeriodByDays: DataTypes.STRING,
    resumeSourceId: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqUsers',
        key: 'userId'
      }
    },
    candidateGender: DataTypes.STRING(10),
    candidatesAddingAgainst: {
      type: DataTypes.INTEGER, references: {
        model: 'reqServiceRequest',
        key: 'requestId'
      }
    },
    candidateInterviewStatus: {
      type: DataTypes.STRING,
      defaultValue: 'inprogress'
    },
    candidateCity: DataTypes.STRING,
    candidateDistrict: DataTypes.STRING,
    candidateState: DataTypes.STRING,
    candidatePreferlocation: DataTypes.STRING,
    candidateRevlentExperience: DataTypes.STRING,
    candidateTotalExperience: DataTypes.STRING,
    candidateCoverLetter: DataTypes.TEXT

  }, {
    sequelize,
    modelName: 'reqCandidates',
  });
  return reqCandidates;
};