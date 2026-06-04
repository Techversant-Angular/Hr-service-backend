'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqProgressSkills', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      skillId: {
        type: Sequelize.INTEGER,
        references: {
          model: 'reqSkills',
          key: 'id'
        }
      },
      score: {
        type: Sequelize.INTEGER
      },
      serviceSeqId: {
        type: Sequelize.INTEGER
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqProgressSkills');
  }
};