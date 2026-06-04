'use strict';

const { INTEGER } = require('sequelize');

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.removeColumn("reqServiceRequests","requestDesignation");
    await queryInterface.addColumn("reqServiceRequests","requestDesignation",{
      type: Sequelize.INTEGER,
    });
  },

  async down (queryInterface, Sequelize) {
  
  }
};
