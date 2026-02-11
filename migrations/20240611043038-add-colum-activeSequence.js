'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('reqServiceSequencesAcitves', 'interviewCount', { type: Sequelize.INTEGER, defaultValue: 0 });
    await queryInterface.addColumn('reqServiceSequencesAcitves', 'interviewRescheduled', { type: Sequelize.BOOLEAN });
    await queryInterface.addColumn('reqServiceSequencesAcitves', 'interviewRescheduledCount', { type: Sequelize.INTEGER, defaultValue: 0 });
    await queryInterface.addColumn('reqServiceSequencesAcitves', 'interviewMode', { type: Sequelize.STRING });
    await queryInterface.addColumn('reqServiceSequencesAcitves', 'interviewLocation', { type: Sequelize.STRING });
    await queryInterface.addColumn('reqServiceSequencesAcitves', 'interviewMail', { type: Sequelize.BOOLEAN });
    await queryInterface.addColumn('reqServiceSequencesAcitves', 'interviewMailType', { type: Sequelize.STRING });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('reqServiceSequencesAcitves', 'interviewCount');
    await queryInterface.removeColumn('reqServiceSequencesAcitves', 'interviewRescheduled');
    await queryInterface.removeColumn('reqServiceSequencesAcitves', 'interviewRescheduledCount');
    await queryInterface.removeColumn('reqServiceSequencesAcitves', 'interviewMode');
    await queryInterface.removeColumn('reqServiceSequencesAcitves', 'interviewLocation');
    await queryInterface.removeColumn('reqServiceSequencesAcitves', 'interviewMail');
    await queryInterface.removeColumn('reqServiceSequencesAcitves', 'interviewMailType');
  }
};
