'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
  await queryInterface.addColumn("reqServiceSequences", "serviceScheduledBy", {
    type: Sequelize.INTEGER, references: {
      model: "reqUsers",
      key: 'userId'
    }
  })
  },

  async down (queryInterface, Sequelize) {
 await queryInterface.removeColumn("reqServiceSequences", "serviceScheduledBy");
  }
};
