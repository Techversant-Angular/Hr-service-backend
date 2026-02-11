'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqMultipleRoleAccess extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  reqMultipleRoleAccess.init({
    roleId: DataTypes.BIGINT,
    userId: DataTypes.BIGINT
  }, {
    sequelize,
    modelName: 'reqMultipleRoleAccess',
  });
  return reqMultipleRoleAccess;
};