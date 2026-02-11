'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqCandidateSkill extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      reqCandidateSkill.belongsTo(models.reqSkill, { foreignKey: 'candidateSkillId', as: 'skills' });

    }
  }
  reqCandidateSkill.init({
    candidateId: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqCandidates',
        key: 'candidateId'
      }
    },
    candidateSno: DataTypes.STRING,
    candidateSkillType: DataTypes.STRING,
    candidateSkillId: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqSkills',
        key: 'id'
      }
    }
  }, {
    sequelize,
    modelName: 'reqCandidateSkill',
    timestamps: false
  });
  return reqCandidateSkill;
};