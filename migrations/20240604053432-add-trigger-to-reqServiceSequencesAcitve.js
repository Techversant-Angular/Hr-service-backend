'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.sequelize.query(`
    CREATE OR REPLACE FUNCTION handle_req_service_sequences()
    RETURNS TRIGGER AS $$
    BEGIN
          IF EXISTS (
              SELECT 1 
              FROM "public"."reqServiceSequencesAcitves" 
              WHERE "serviceServiceRequst" = NEW."serviceServiceRequst"
              AND "serviceCandidate" = NEW."serviceCandidate" AND ("serviceStation"=NEW."serviceStation" OR "serviceStation" IS   NULL )
          ) THEN
              -- Update the existing record in the second table
              UPDATE "public"."reqServiceSequencesAcitves"
              SET "serviceId"=NEW."serviceId",
                  "serviceStation" = NEW."serviceStation",
                  "serviceServiceRequst" = NEW."serviceServiceRequst",
                  "serviceCandidate" = NEW."serviceCandidate",
                  "serviceAssignee" = NEW."serviceAssignee",
                  "serviceDate" = NEW."serviceDate",
                  "serviceStatus" = NEW."serviceStatus",
                  "serviceServiceId" = NEW."serviceServiceId",
                  "serviceScheduledBy" = NEW."serviceScheduledBy",
                  "previousCurrentStation" = NEW."previousCurrentStation",
                  "resonSwitchStation" = NEW."resonSwitchStation",
                  "interviewCount"=NEW."interviewCount",
                  "interviewRescheduled"=NEW."interviewRescheduled",
                  "interviewRescheduledCount"=NEW."interviewRescheduledCount",
                  "interviewMode"=NEW."interviewMode",
                  "interviewLocation"=NEW."interviewLocation",
                  "interviewMailType"=NEW."interviewMailType",
                  "interviewMail"=NEW."interviewMail"
              WHERE 
                  "serviceServiceRequst" = NEW."serviceServiceRequst"
                  AND "serviceCandidate" = NEW."serviceCandidate" AND ("serviceStation"=NEW."serviceStation" OR "serviceStation" IS   NULL );
          ELSE
              -- Insert the new record into the second table
              INSERT INTO "public"."reqServiceSequencesAcitves"(
                  "serviceId",
                  "serviceStation",
                  "serviceServiceRequst",
                  "serviceCandidate",
                  "serviceAssignee",
                  "serviceDate",
                  "serviceStatus",
                  "serviceServiceId",
                  "serviceScheduledBy",
                  "previousCurrentStation",
                  "resonSwitchStation",
                  "interviewCount",
                  "interviewRescheduled",
                  "interviewRescheduledCount",
                  "interviewMode",
                  "interviewLocation",
                  "interviewMailType",
                  "interviewMail"
              ) VALUES (
                  NEW."serviceId",
                  NEW."serviceStation",
                  NEW."serviceServiceRequst",
                  NEW."serviceCandidate",
                  NEW."serviceAssignee",
                  NEW."serviceDate",
                  NEW."serviceStatus",
                  NEW."serviceServiceId",
                  NEW."serviceScheduledBy",
                  NEW."previousCurrentStation",
                  NEW."resonSwitchStation",
                  NEW."interviewCount",
                  NEW."interviewRescheduled",
                  NEW."interviewRescheduledCount",
                  NEW."interviewMode",
                  NEW."interviewLocation",
                  NEW."interviewMailType",
                  NEW."interviewMail"
              );
          END IF;
          RETURN NEW;
      END;
    $$ LANGUAGE plpgsql;
  `);

    // Create the trigger
    await queryInterface.sequelize.query(`
    CREATE TRIGGER after_insert_req_service_sequences
    AFTER INSERT ON "public"."reqServiceSequences"
    FOR EACH ROW
    EXECUTE FUNCTION handle_req_service_sequences();
  `);
    await queryInterface.sequelize.query(`
  CREATE TRIGGER after_update_req_service_sequences
  AFTER UPDATE
  ON "public"."reqServiceSequences"
  FOR EACH ROW
  EXECUTE FUNCTION handle_req_service_sequences();
  `);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.sequelize.query(`
      DROP TRIGGER IF EXISTS after_insert_req_service_sequences ON reqServiceSequencesAcitve;
    `);

    // Remove the trigger function
    await queryInterface.sequelize.query(`
      DROP FUNCTION IF EXISTS handle_req_service_sequences;
    `);
  }
};
