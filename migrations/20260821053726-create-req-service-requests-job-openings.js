'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reqServiceRequestsJobOpenings', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },

      requisitionId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'reqServiceRequests',
          key: 'requestId',
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE',
      },

      jobOpeningId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'reqJobOpenings',
          key: 'requestId',
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE',
      },

      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
      },

      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
      },
    });

    await queryInterface.addConstraint(
      'reqServiceRequestsJobOpenings',
      {
        fields: ['requisitionId', 'jobOpeningId'],
        type: 'unique',
        name: 'unique_requisition_job_opening',
      }
    );
  },

  async down(queryInterface) {
    await queryInterface.dropTable('reqServiceRequestsJobOpenings');
  },
};