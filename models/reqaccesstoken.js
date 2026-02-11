'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqAccessToken extends Model {
  
    static associate(models) {
      // define association here
    }
  }
  reqAccessToken.init({
    accessId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    accessToken: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'reqAccessToken',
  });
  return reqAccessToken;
};