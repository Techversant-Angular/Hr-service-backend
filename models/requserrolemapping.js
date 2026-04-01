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

      // Each mapping belongs to a user
      reqUserRoleMapping.belongsTo(models.reqUser, {
        foreignKey: 'userId',
        as: 'user'
      });

      // Each mapping belongs to a role
      reqUserRoleMapping.belongsTo(models.reqUserRole, {
        foreignKey: 'roleId',
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

    userId: {
      type: DataTypes.INTEGER,
      allowNull: false
    },

    roleId: {
      type: DataTypes.INTEGER,
      allowNull: false
    }

  }, {
    sequelize,
    modelName: 'reqUserRoleMapping',
    tableName: 'reqUserRoleMapping',
    timestamps: false
  });
  return reqUserRoleMapping;
};