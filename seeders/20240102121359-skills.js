'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("reqSkills", [
      {skillName:'nodejs'},
      {skillName:'angular'},
      {skillName:'reactjs'},
      {skillName:'react native'},
      {skillName:'postgresql'},
      {skillName:'mongoDb'},
      {skillName:'python'},
      {skillName:'socketio'},
      {skillName:'nextjs'},
      {skillName:'php'},
      {skillName:'golang'},
      {skillName:'mongoDb'},
      {skillName:'angularjs'},
      {skillName:'expressjs'},
      {skillName:'ruby and rails'},
      {skillName:'django'},
      {skillName:'java'},
    ]);
  },

  async down(queryInterface, Sequelize) {

  }
};
