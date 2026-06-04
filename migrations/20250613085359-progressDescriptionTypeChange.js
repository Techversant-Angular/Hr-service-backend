'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.changeColumn('reqCandidateProgresses', 'progressDescription', {
      type: Sequelize.TEXT,
      allowNull: true
    });
    await queryInterface.changeColumn('reqCandidateComments', 'commentComment', {
      type: Sequelize.TEXT,
      allowNull: true
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.changeColumn('reqCandidateProgresses', 'progressDescription', {
      type: Sequelize.STRING,
      allowNull: true
    });
    await queryInterface.changeColumn('reqCandidateComments', 'commentComment', {
      type: Sequelize.STRING,
      allowNull: true
    });
  }
};
