"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface) {
    await queryInterface.sequelize.query(`
      CREATE UNIQUE INDEX IF NOT EXISTS "uq_reqSkills_skillName_typeId"
      ON public."reqSkills" (LOWER("skillName"), "typeId");
    `);
  },

  async down(queryInterface) {
    await queryInterface.sequelize.query(`
      DROP INDEX IF EXISTS public."uq_reqSkills_skillName_typeId";
    `);
  },
};
