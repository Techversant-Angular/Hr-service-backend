"use strict";
const { Op } = require("sequelize");

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    // await queryInterface.bulkInsert("reqServices", [
    //   { sericeName: "Associate Software Engineer Trainee" },
    //   { sericeName: "Associate Software Engineer" },
    //   { sericeName: "Software Engineer" },
    //   { sericeName: "Senior Software Engineer" },
    // ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("reqServices", {
      sericeName: {
        [Op.in]: [
          "Associate Software Engineer Trainee",
          "Associate Software Engineer",
          "Software Engineer",
          "Senior Software Engineer",
        ],
      },
    });
  },
};
