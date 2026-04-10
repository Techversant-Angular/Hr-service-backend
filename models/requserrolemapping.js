'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqUserRoleMapping extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // Association with reqUserRoles
      reqUserRoleMapping.belongsTo(models.reqUserRole, {
        foreignKey: 'roleId',      // rurm.roleId
        targetKey: 'roleUserId',   // rur.roleUserId
        as: 'role'
      });
    }
  }
  reqUserRoleMapping.init({
    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    userId: DataTypes.INTEGER,
    roleId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'reqUserRoleMapping',
    tableName: 'reqUserRoleMapping',
    timestamps: false
  });
  return reqUserRoleMapping;
};