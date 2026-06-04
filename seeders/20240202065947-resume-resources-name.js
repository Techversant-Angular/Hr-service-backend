'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("reqCandidateResumeSources",[
      {sourceName:"Naukri"},
      {sourceName:"Linkedin"},
      {sourceName:"Indeed"},
      {sourceName:"Candidate"},
      {sourceName:"Reference"}
    ]);
  },

  async down(queryInterface, Sequelize) {
   
  }
};
