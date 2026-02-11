'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqTask extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      reqTask.belongsTo(models.reqUser, { foreignKey: 'taskUserId' });
      reqTask.belongsTo(models.reqServiceSequence, { foreignKey: 'taskServiceId', as: 'serviceSeq' });
    }
  }
  reqTask.init({
    taskId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    taskName: DataTypes.STRING,
    taskServiceId: DataTypes.INTEGER,
    taskUserId: {
      type: DataTypes.INTEGER, references: {
        model: 'reqUsers',
        key: 'userId'
      }
    },
    taskDate: DataTypes.DATE
  }, {
    sequelize,
    modelName: 'reqTask',
  });
  return reqTask;
};