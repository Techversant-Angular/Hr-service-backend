'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('reqServiceSequences', 'interviewCount', { type: Sequelize.INTEGER, defaultValue: 0 });
    await queryInterface.addColumn('reqServiceSequences', 'interviewRescheduled', { type: Sequelize.BOOLEAN });
    await queryInterface.addColumn('reqServiceSequences', 'interviewRescheduledCount', { type: Sequelize.INTEGER, defaultValue: 0 });
    await queryInterface.addColumn('reqServiceSequences', 'interviewMode', { type: Sequelize.STRING });
    await queryInterface.addColumn('reqServiceSequences', 'interviewLocation', { type: Sequelize.STRING });
    await queryInterface.addColumn('reqServiceSequences', 'interviewMail', { type: Sequelize.BOOLEAN });
    await queryInterface.addColumn('reqServiceSequences', 'interviewMailType', { type: Sequelize.STRING });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqServiceSequences', 'interviewCount');
    await queryInterface.removeColumn('reqServiceSequences', 'interviewRescheduled');
    await queryInterface.removeColumn('reqServiceSequences', 'interviewRescheduledCount');
    await queryInterface.removeColumn('reqServiceSequences', 'interviewMode');
    await queryInterface.removeColumn('reqServiceSequences', 'interviewLocation');
    await queryInterface.removeColumn('reqServiceSequences', 'interviewMail');
    await queryInterface.removeColumn('reqServiceSequences', 'interviewMailType');
  }
};
