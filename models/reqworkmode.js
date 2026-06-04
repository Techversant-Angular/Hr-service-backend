'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqworkMode extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      reqworkMode.hasOne(models.reqinterviewDetail, { foreignKey: 'preferMode' });
    }
  }
  reqworkMode.init({
    modeName: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'reqworkMode',
    timestamps: false
  });
  return reqworkMode;
};