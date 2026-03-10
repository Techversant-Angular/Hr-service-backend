'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable('reqAuditLogs', {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER
            },
            actionBy: {
                type: Sequelize.INTEGER
            },
            action: {
                type: Sequelize.STRING
            },
            endpoint: {
                type: Sequelize.STRING
            },
            changes: {
                type: Sequelize.TEXT
            },
            createdAt: {
                allowNull: false,
                type: Sequelize.DATE,
                defaultValue: Sequelize.fn('now')
            }
        });
    },
    async down(queryInterface, Sequelize) {
        await queryInterface.dropTable('reqAuditLogs');
    }
};
