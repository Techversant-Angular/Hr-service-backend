'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class reqServiceRequestsJobOpenings extends Model {
    static associate(models) {
      reqServiceRequestsJobOpenings.belongsTo(models.reqServiceRequest, {
        foreignKey: 'requisitionId',
        targetKey: 'requestId',
        as: 'requisition',
      });
      reqServiceRequestsJobOpenings.belongsTo(models.reqJobOpening, {
        foreignKey: 'jobOpeningId',
        targetKey: 'requestId',
        as: 'jobOpening',
      });
    }
  }

  reqServiceRequestsJobOpenings.init(
    {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: DataTypes.INTEGER,
      },
      requisitionId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: 'reqServiceRequests',
          key: 'requestId',
        },
      },
      jobOpeningId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: 'reqJobOpenings',
          key: 'requestId',
        },
      },
    },
    {
      sequelize,
      modelName: 'reqServiceRequestsJobOpenings',
      tableName: 'reqServiceRequestsJobOpenings',
      timestamps: true,
    }
  );

  return reqServiceRequestsJobOpenings;
};
