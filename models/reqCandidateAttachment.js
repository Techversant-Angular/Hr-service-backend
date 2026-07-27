'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class reqCandidateAttachment extends Model {
    static associate(models) {
      reqCandidateAttachment.belongsTo(models.reqCandidates, {
        foreignKey: 'candidateId',
        as: 'candidate'
      });
      reqCandidateAttachment.belongsTo(models.reqUser, {
        foreignKey: 'createdBy',
        as: 'creator'
      });
      reqCandidateAttachment.belongsTo(models.reqUser, {
        foreignKey: 'updatedBy',
        as: 'updater'
      });
    }
  }

  reqCandidateAttachment.init(
    {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: DataTypes.INTEGER
      },
      candidateId: {
        type: DataTypes.INTEGER,
        allowNull: false
      },
      attachmentType: {
        type: DataTypes.STRING(50),
        allowNull: false
      },
      fileName: {
        type: DataTypes.STRING(255),
        allowNull: false
      },
      originalFileName: {
        type: DataTypes.STRING(255),
        allowNull: false
      },
      filePath: {
        type: DataTypes.STRING(500),
        allowNull: false
      },
      mimeType: {
        type: DataTypes.STRING(100),
        allowNull: false
      },
      fileSize: {
        type: DataTypes.INTEGER,
        allowNull: false
      },
      notes: DataTypes.TEXT,
      createdBy: DataTypes.INTEGER,
      updatedBy: DataTypes.INTEGER,
      status: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: true
      }
    },
    {
      sequelize,
      modelName: 'reqCandidateAttachment',
      tableName: 'reqCandidateAttachments'
    }
  );

  return reqCandidateAttachment;
};