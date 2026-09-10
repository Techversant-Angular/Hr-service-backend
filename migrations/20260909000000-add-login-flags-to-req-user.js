'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    const tableInfo = await queryInterface.describeTable('reqUsers');

    if (!tableInfo.autologout) {
      await queryInterface.addColumn('reqUsers', 'autologout', {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 0
      });
    }

    if (!tableInfo.passwordchanged) {
      await queryInterface.addColumn('reqUsers', 'passwordchanged', {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 0
      });
    }
  },

  async down(queryInterface) {
    const tableInfo = await queryInterface.describeTable('reqUsers');

    if (tableInfo.passwordchanged) {
      await queryInterface.removeColumn('reqUsers', 'passwordchanged');
    }

    if (tableInfo.autologout) {
      await queryInterface.removeColumn('reqUsers', 'autologout');
    }
  }
};