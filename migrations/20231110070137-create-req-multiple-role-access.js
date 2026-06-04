'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqMultipleRoleAccesses', {
      roleAccessId: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      roleAccessRoleId: {
        type: Sequelize.BIGINT,
        references:{
          model: 'reqUserRoles',
          key: 'roleId'
        }
      },
      roleAccessUserId: {
        type: Sequelize.BIGINT,
        references:{
          model: 'reqUsers',
          key: 'userId'
        }
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqMultipleRoleAccesses');
  }
};