'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    const tableInfo = await queryInterface.describeTable('reqUsers');

    if (!tableInfo.tokenVersion) {
      await queryInterface.addColumn('reqUsers', 'tokenVersion', {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 1
      });
    }
  },

  async down(queryInterface, Sequelize) {
    const tableInfo = await queryInterface.describeTable('reqUsers');

    if (tableInfo.tokenVersion) {
      await queryInterface.removeColumn('reqUsers', 'tokenVersion');
    }
  }
};
