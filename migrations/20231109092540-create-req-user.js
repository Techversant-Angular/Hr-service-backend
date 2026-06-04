'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqUsers', {
      userId: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      userfirstName: {
        type: Sequelize.STRING,
        allowNull: false
      },
      userlastName: {
        type: Sequelize.STRING,
        allowNull: false
      },
      userEmail: {
        type: Sequelize.STRING,
        allowNull: false
      },
      userDOB: {
        type: Sequelize.DATE
      },
      userPassword: {
        type: Sequelize.STRING,
        allowNull: false
      },
      userWorkStation: {
        type: Sequelize.INTEGER,
        allowNull: false
      },
      userRole: {
        type: Sequelize.STRING,
        allowNull: false
      },
      userType: {
        type: Sequelize.STRING
      },
      userStatus: {
        type: Sequelize.STRING,
        allowNull: false
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqUsers');
  }
};