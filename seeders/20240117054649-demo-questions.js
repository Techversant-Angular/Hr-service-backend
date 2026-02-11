'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    // await queryInterface.bulkInsert("reqQuestions", [
    //   { questionName: 'fresher1', questionTotalMark:10},
    //   { questionName: 'fresher2', questionTotalMark:10},
    //   { questionName: 'fresher3', questionTotalMark:10},
    // ]);
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
