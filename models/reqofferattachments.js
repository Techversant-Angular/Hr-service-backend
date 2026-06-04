'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class reqOfferAttachments extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  reqOfferAttachments.init({
    candidateId: DataTypes.INTEGER,
    updatedBy: DataTypes.INTEGER,
    station: DataTypes.INTEGER,
    attachmentPath: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'reqOfferAttachments',
  });
  return reqOfferAttachments;
};