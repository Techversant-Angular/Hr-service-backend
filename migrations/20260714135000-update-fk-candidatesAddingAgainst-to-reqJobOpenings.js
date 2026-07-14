'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    // Drop the old FK constraint that referenced reqServiceRequests
    // (constraint name may vary; we use a try/catch to handle if it doesn't exist)
    try {
      await queryInterface.removeConstraint(
        'reqjobapplicants',
        'reqjobapplicants_candidatesAddingAgainst_fkey'
      );
    } catch (err) {
      console.log('Old FK constraint not found, skipping removal:', err.message);
    }

    // Add new FK constraint pointing to reqJobOpenings.requestId
    await queryInterface.addConstraint('reqjobapplicants', {
      fields: ['candidatesAddingAgainst'],
      type: 'foreign key',
      name: 'reqJobOpenings_candidatesAddingAgainst_fkey',
      references: {
        table: 'reqJobOpenings',
        field: 'requestId',
      },
      onDelete: 'SET NULL',
      onUpdate: 'CASCADE',
    });
  },

  async down(queryInterface, Sequelize) {
    // Remove the new FK constraint
    try {
      await queryInterface.removeConstraint(
        'reqjobapplicants',
        'reqJobOpenings_candidatesAddingAgainst_fkey'
      );
    } catch (err) {
      console.log('FK constraint not found during rollback:', err.message);
    }

    // Restore the old FK constraint pointing back to reqServiceRequests
    await queryInterface.addConstraint('reqjobapplicants', {
      fields: ['candidatesAddingAgainst'],
      type: 'foreign key',
      name: 'reqjobapplicants_candidatesAddingAgainst_fkey',
      references: {
        table: 'reqServiceRequests',
        field: 'requestId',
      },
      onDelete: 'SET NULL',
      onUpdate: 'CASCADE',
    });
  },
};
