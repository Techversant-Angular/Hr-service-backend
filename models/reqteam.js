'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqTeam extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      reqTeam.hasOne(models.reqServiceRequest, { foreignKey: 'requestTeam', as: 'team' });
      // define association here
    }
  }
  reqTeam.init({
    teamId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    teamName: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'reqTeam',
    timestamps:false
  });
  return reqTeam;
};