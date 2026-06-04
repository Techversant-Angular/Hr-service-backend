'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqCandidateComments', {
      commentId: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      commentSeqenceId: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqServiceSequences',
          key: 'serviceId'
        }
      },
      commentComment: {
        type: Sequelize.STRING
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqCandidateComments');
  }
};