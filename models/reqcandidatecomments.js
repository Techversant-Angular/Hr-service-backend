'use strict';
const {
  Model
} = require('sequelize');
const { Sequelize } = require('.');
module.exports = (sequelize, DataTypes) => {
  class reqCandidateComments extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      reqCandidateComments.belongsTo(models.reqUser, { foreignKey: 'commentUserId' });
      reqCandidateComments.belongsTo(models.reqServiceSequence, { foreignKey: 'commentSeqenceId' })
    }
  }
  reqCandidateComments.init({
    commentId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    commentSeqenceId: {
      type: DataTypes.INTEGER,
      references: {
        model: 'reqServiceSequences',
        key: 'serviceId'
      }
    },
    commentComment: DataTypes.STRING,
    commentUserId: DataTypes.INTEGER,
    offerReleaseReject: DataTypes.INTEGER,
    commentDate: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    }
  }, {
    sequelize,
    modelName: 'reqCandidateComments',
    timestamps: false
  });
  return reqCandidateComments;
};