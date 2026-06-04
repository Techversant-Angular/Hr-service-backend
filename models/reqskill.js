'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqSkill extends Model {

    static associate(models) {
    }
  }
  reqSkill.init({
    skillName: DataTypes.STRING,
    typeId: DataTypes.INTEGER,
    type:DataTypes.STRING

  }, {
    sequelize,
    modelName: 'reqSkill',
    timestamps: false
  });
  return reqSkill;
};