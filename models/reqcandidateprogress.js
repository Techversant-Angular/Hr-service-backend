'use strict';
const {
  Model, Sequelize
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqCandidateProgress extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      reqCandidateProgress.belongsTo(models.reqServiceSequence, {
        foreignKey:'progressServiceSequence'
      });
    }
  }
  reqCandidateProgress.init({
    progressId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    progressScore: DataTypes.INTEGER,
    progressStation: DataTypes.INTEGER,
    progressVerifiedBy: DataTypes.INTEGER,
    progressQuestion: DataTypes.INTEGER,
    progressDescription: DataTypes.STRING,
    progressServiceSequence: {
      type: Sequelize.INTEGER
    },
    progressCreatedAt: {
      allowNull: false,
      type: DataTypes.DATE,
      defaultValue: Sequelize.fn('now')
    },
    progressFile:DataTypes.STRING,
    progressSkills:DataTypes.TEXT,
    progressAverageScore:DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'reqCandidateProgress',
    timestamps: false
  });
  return reqCandidateProgress;
};