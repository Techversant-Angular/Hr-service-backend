'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class reqJobApplicantsOpening extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      reqJobApplicantsOpening.belongsTo(models.reqJobApplicants, {
        foreignKey: 'reqJobApplicantsId',
        targetKey: 'candidateId',
        as: 'jobApplicant'
      });
      reqJobApplicantsOpening.belongsTo(models.reqJobOpening, {
        foreignKey: 'reqJobOpeningId',
        targetKey: 'requestId',
        as: 'jobOpening'
      });
    }
  }

  reqJobApplicantsOpening.init({
    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    reqJobApplicantsId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'reqjobapplicants',
        key: 'candidateId'
      }
    },
    reqJobOpeningId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'reqJobOpenings',
        key: 'requestId'
      }
    }
  }, {
    sequelize,
    modelName: 'reqJobApplicantsOpening',
    tableName: 'reqJobApplicantsOpenings',
    timestamps: true
  });

  return reqJobApplicantsOpening;
};
