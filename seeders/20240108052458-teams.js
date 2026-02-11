'use strict';

/* @type {import('sequelize-cli').Migration} /
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("reqTeams", [
      { "teamName": "Accounts" },
      { "teamName": ".Net" },
      { "teamName": "Administration" },
      { "teamName": "Business" },
      { "teamName": "Cloud" },
      { "teamName": "Coldfusion" },
      { "teamName": "Java" },
      { "teamName": "Javascript" },
      { "teamName": "Mobile" },
      { "teamName": "Testing" },
      { "teamName": "Python" },
      { "teamName": "UI/UX" },
      { "teamName": "Ruby & Rails" },
      { "teamName": "Odoo" },
      { "teamName": "PHP" },
      { "teamName": "Golang" },
      { "teamName": "HR" }
    ]);
  },

  async down(queryInterface, Sequelize) {
    /**
     * Add commands to revert seed here.
     *
     * Example:
     * await queryInterface.bulkDelete('People', null, {});
     */
  }
};
