'use strict';
const {
    Model, Sequelize
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class reqAuditLog extends Model {
        static associate(models) {
            // define association here
        }
    }
    reqAuditLog.init({
        actionBy: DataTypes.INTEGER,
        action: DataTypes.STRING,
        endpoint: DataTypes.STRING,
        changes: DataTypes.TEXT,
        createdAt: {
            type: DataTypes.DATE,
            defaultValue: Sequelize.fn('now')
        }
    }, {
        sequelize,
        modelName: 'reqAuditLog',
        timestamps: false
    });
    return reqAuditLog;
};
