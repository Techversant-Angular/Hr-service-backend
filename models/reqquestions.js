'use strict';
const {Model} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqQuestions extends Model {
   
    static associate(models) {
    }
  }
  reqQuestions.init({
    questionId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    questionName: DataTypes.STRING,
    questionTotalMark: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'reqQuestions',
    timestamps:false
  });
  return reqQuestions;
};