'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqProgressSkill extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      reqProgressSkill.belongsTo(models.reqSkill, { foreignKey: 'skillId' });
    }
  }
  reqProgressSkill.init({
    skillId: DataTypes.NUMBER,
    score: DataTypes.NUMBER,
    serviceSeqId: {
      type: DataTypes.INTEGER
    },
    description:DataTypes.STRING
  }, {
    sequelize,
    modelName: 'reqProgressSkill',
    timestamps: false
  });
  return reqProgressSkill;
};