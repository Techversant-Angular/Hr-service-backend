'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
  //   await queryInterface.sequelize.query(`
  //   CREATE OR REPLACE FUNCTION add_report()
  //   RETURNS TRIGGER 
  //   LANGUAGE PLPGSQL
  //   AS
  // $$
  // DECLARE
  //     table_exists BOOLEAN;
  //     current_date_value VARCHAR(5);
  //     table_prefix VARCHAR(20) := 'report_';
  //     table_to_create VARCHAR(50);
  // BEGIN
  // current_date_value:= EXTRACT(YEAR FROM NEW.date);
  //     table_to_create := table_prefix || current_date_value;
  //     -- Check if the table exists
  //     SELECT EXISTS (
  //         SELECT 1
  //         FROM information_schema.tables
  //         WHERE table_schema = 'reports'
  //         AND table_name = table_to_create
  //     ) INTO table_exists;
  //     -- Create the table if it does not exist
  //     IF NOT table_exists THEN
  //         EXECUTE 'CREATE TABLE IF NOT EXISTS reports.' || table_to_create || ' (
  //          id serial NOT NULL,
  //          recruiter integer,
  //         "position" integer,
  //         "recruiter" integer,
  //         "naukriResume" integer,
  //         "linkedinResume" integer,
  //         "sourcedScreened" integer,
  //         "candidateContacted" integer,
  //         "candidatesIntrested" integer,
  //         "interviewScheduled" integer,
  //         "offerReleased" integer,
  //         date timestamp with time zone NOT NULL,
  //         CONSTRAINT "'|| table_to_create ||'_pkey" PRIMARY KEY (id))';
  //         RAISE NOTICE 'Table created: %', table_to_create;
  //    ELSE
  //   	EXECUTE 'INSERT INTO reports.' || table_to_create || ' (recruiter,position,linkedinResume,sourcedScreened,candidateContacted,interviewScheduled,offerReleased,date) VALUES ($1, $2,$3,$4,$5,$6,$7,$8)' 
	// 	USING NEW.recruiter,NEW.position,NEW.linkedinResume,NEW.sourcedScreened,NEW.candidateContacted,NEW.interviewScheduled,NEW.offerReleased,NEW.date;
	//  END IF;
  //   return NULL;
  // END;
  // $$;`);
  },

  async down(queryInterface, Sequelize) {
    /**
     * Add reverting commands here.
     *
     * Example:
     * await queryInterface.dropTable('users');
     */
  }
};
