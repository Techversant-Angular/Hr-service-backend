'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("reqTasks", "taskStatus", {
      type: Sequelize.STRING,
      defaultValue: 'pending'
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqTasks", "taskStatus");

  }
};
