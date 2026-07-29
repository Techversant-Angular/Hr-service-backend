"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("reqCandidateAttachments", {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },
      candidateId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: "reqCandidates", key: "candidateId" },
        onUpdate: "CASCADE",
        onDelete: "CASCADE",
      },
      attachmentType: { type: Sequelize.STRING(50), allowNull: false },
      fileName: { type: Sequelize.STRING(255), allowNull: false },
      originalFileName: { type: Sequelize.STRING(255), allowNull: false },
      filePath: { type: Sequelize.STRING(500), allowNull: false },
      mimeType: { type: Sequelize.STRING(100), allowNull: false },
      fileSize: { type: Sequelize.INTEGER, allowNull: false },
      notes: { type: Sequelize.TEXT, allowNull: true },
      createdBy: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: { model: "reqUsers", key: "userId" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL",
      },
      updatedBy: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: { model: "reqUsers", key: "userId" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL",
      },
      status: { type: Sequelize.BOOLEAN, allowNull: false, defaultValue: true },
      createdAt: { allowNull: false, type: Sequelize.DATE },
      updatedAt: { allowNull: false, type: Sequelize.DATE },
    }); 
    // Index on candidateId for fast lookup
    await queryInterface.addIndex('reqCandidateAttachments', ['candidateId']);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reqCandidateAttachments');
  },
};
