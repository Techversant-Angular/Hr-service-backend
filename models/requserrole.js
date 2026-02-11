'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqUserRole extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  reqUserRole.init({
    roleId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    roleName: DataTypes.STRING,
    roleUserId: {
      type: DataTypes.BIGINT,
      references: {
        model: 'reqUsers',
        key: 'userId'
      }
    }
  }, {
    sequelize,
    modelName: 'reqUserRole',
    timestamps: false
  });
  return reqUserRole;
};