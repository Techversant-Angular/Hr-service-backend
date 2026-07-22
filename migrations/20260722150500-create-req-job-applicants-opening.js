'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqJobApplicantsOpenings', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      reqJobApplicantsId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'reqjobapplicants',
          key: 'candidateId'
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      reqJobOpeningId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'reqJobOpenings',
          key: 'requestId'
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqJobApplicantsOpenings');
  }
};
