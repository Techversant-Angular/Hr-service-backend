'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqQuestionBox extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  reqQuestionBox.init({
    requstId: DataTypes.NUMBER
  }, {
    sequelize,
    modelName: 'reqQuestionBox',
    timestamps:false
  });
  return reqQuestionBox;
};