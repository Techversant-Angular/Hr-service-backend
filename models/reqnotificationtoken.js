'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqNotificationToken extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      reqNotificationToken.belongsTo(models.reqUser, { foreignKey: 'userId', as: 'user' });
    }
  }
  reqNotificationToken.init({
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
    token: {
      type: DataTypes.TEXT,
      allowNull: false
    },
    deviceType: {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: 'web'
    }
  }, {
    sequelize,
    modelName: 'reqNotificationToken',
  });
  return reqNotificationToken;
};
