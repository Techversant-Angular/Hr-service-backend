'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("reqworkModes", 
      [
      { modeName: "Online" },
      { modeName: "Remote" },
      { modeName: "Hybrid" }
    ]
    );
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("reqworkModes");
  }
};
