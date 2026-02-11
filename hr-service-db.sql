--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Ubuntu 17.2-1.pgdg24.04+1)
-- Dumped by pg_dump version 17.2 (Ubuntu 17.2-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: handle_req_service_sequences(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_req_service_sequences() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
    $$;


ALTER FUNCTION public.handle_req_service_sequences() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: SequelizeMeta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE public."SequelizeMeta" OWNER TO postgres;

--
-- Name: reqAccessTokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqAccessTokens" (
    "accessId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "accessToken" text
);


ALTER TABLE public."reqAccessTokens" OWNER TO postgres;

--
-- Name: reqAccessTokens_accessId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqAccessTokens_accessId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqAccessTokens_accessId_seq" OWNER TO postgres;

--
-- Name: reqAccessTokens_accessId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqAccessTokens_accessId_seq" OWNED BY public."reqAccessTokens"."accessId";


--
-- Name: reqCandidateComments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqCandidateComments" (
    "commentId" integer NOT NULL,
    "commentSeqenceId" integer,
    "commentComment" character varying(255),
    "commentUserId" integer,
    "commentDate" timestamp with time zone,
    "offerReleaseReject" integer DEFAULT 0
);


ALTER TABLE public."reqCandidateComments" OWNER TO postgres;

--
-- Name: reqCandidateComments_commentId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqCandidateComments_commentId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqCandidateComments_commentId_seq" OWNER TO postgres;

--
-- Name: reqCandidateComments_commentId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqCandidateComments_commentId_seq" OWNED BY public."reqCandidateComments"."commentId";


--
-- Name: reqCandidateLogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqCandidateLogs" (
    id integer NOT NULL,
    station integer,
    "candidateId" integer,
    "actionBy" integer,
    action character varying(255),
    date timestamp with time zone NOT NULL,
    "position" integer
);


ALTER TABLE public."reqCandidateLogs" OWNER TO postgres;

--
-- Name: reqCandidateLogs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqCandidateLogs_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqCandidateLogs_id_seq" OWNER TO postgres;

--
-- Name: reqCandidateLogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqCandidateLogs_id_seq" OWNED BY public."reqCandidateLogs".id;


--
-- Name: reqCandidateProgresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqCandidateProgresses" (
    "progressId" integer NOT NULL,
    "progressScore" integer,
    "progressStation" integer,
    "progressVerifiedBy" integer,
    "progressQuestion" integer,
    "progressDescription" character varying(255),
    "progressServiceSequence" integer,
    "progressCreatedAt" timestamp with time zone NOT NULL,
    "progressAverageScore" integer,
    "progressSkills" character varying(255),
    "progressFile" character varying(255),
    "questionBox" integer
);


ALTER TABLE public."reqCandidateProgresses" OWNER TO postgres;

--
-- Name: reqCandidateProgresses_progressId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqCandidateProgresses_progressId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqCandidateProgresses_progressId_seq" OWNER TO postgres;

--
-- Name: reqCandidateProgresses_progressId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqCandidateProgresses_progressId_seq" OWNED BY public."reqCandidateProgresses"."progressId";


--
-- Name: reqCandidateResumeSources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqCandidateResumeSources" (
    "sourceId" integer NOT NULL,
    "sourceName" character varying(255)
);


ALTER TABLE public."reqCandidateResumeSources" OWNER TO postgres;

--
-- Name: reqCandidateResumeSources_sourceId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqCandidateResumeSources_sourceId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqCandidateResumeSources_sourceId_seq" OWNER TO postgres;

--
-- Name: reqCandidateResumeSources_sourceId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqCandidateResumeSources_sourceId_seq" OWNED BY public."reqCandidateResumeSources"."sourceId";


--
-- Name: reqCandidateSkills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqCandidateSkills" (
    id integer NOT NULL,
    "candidateId" integer,
    "candidateSno" character varying(255),
    "candidateSkillType" character varying(255),
    "candidateSkillId" integer
);


ALTER TABLE public."reqCandidateSkills" OWNER TO postgres;

--
-- Name: reqCandidateSkills_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqCandidateSkills_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqCandidateSkills_id_seq" OWNER TO postgres;

--
-- Name: reqCandidateSkills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqCandidateSkills_id_seq" OWNED BY public."reqCandidateSkills".id;


--
-- Name: reqCandidates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqCandidates" (
    "candidateId" integer NOT NULL,
    "candidateFirstName" character varying(255) NOT NULL,
    "candidateLastName" character varying(255) NOT NULL,
    "candidateDoB" timestamp with time zone,
    "candidateExperience" character varying(255),
    "candidatePreviousOrg" character varying(255),
    "candidatePreviousDesignation" character varying(255),
    "candidateEducation" character varying(255),
    "candidateCurrentSalary" character varying(255),
    "candidateExpectedSalary" character varying(255),
    "candidateAddress" character varying(255),
    "candidateStatus" character varying(255) DEFAULT 'active'::character varying,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "candidateEmail" character varying(255) NOT NULL,
    "candidateMobileNo" character varying(255),
    "candidateStation" bigint,
    "candidateHireRole" character varying(255),
    "candidateResume" character varying(255),
    "resumeSourceId" integer,
    "candidateNoticePeriodByDays" character varying(255),
    "candidatesAddingAgainst" integer,
    "candidateInterviewStatus" character varying(255) DEFAULT 'inprogress'::character varying,
    "candidateCreatedby" bigint,
    "candidateGender" character varying(10),
    "candidateCity" character varying(255),
    "candidateDistrict" character varying(255),
    "candidateState" character varying(255),
    "candidatePreferlocation" character varying(255),
    "candidateRevlentExperience" character varying(255),
    "candidateTotalExperience" character varying(255),
    "workMode" character varying(255)
);


ALTER TABLE public."reqCandidates" OWNER TO postgres;

--
-- Name: reqCandidates_candidateId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqCandidates_candidateId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqCandidates_candidateId_seq" OWNER TO postgres;

--
-- Name: reqCandidates_candidateId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqCandidates_candidateId_seq" OWNED BY public."reqCandidates"."candidateId";


--
-- Name: reqDesignations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqDesignations" (
    "designationId" integer NOT NULL,
    "designationName" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."reqDesignations" OWNER TO postgres;

--
-- Name: reqDesignations_designationId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqDesignations_designationId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqDesignations_designationId_seq" OWNER TO postgres;

--
-- Name: reqDesignations_designationId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqDesignations_designationId_seq" OWNED BY public."reqDesignations"."designationId";


--
-- Name: reqExperienceReports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqExperienceReports" (
    id integer NOT NULL,
    technology integer,
    "interviewStatusCount" integer,
    "rescheduleStatusCount" integer
);


ALTER TABLE public."reqExperienceReports" OWNER TO postgres;

--
-- Name: reqExperienceReports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqExperienceReports_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqExperienceReports_id_seq" OWNER TO postgres;

--
-- Name: reqExperienceReports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqExperienceReports_id_seq" OWNED BY public."reqExperienceReports".id;


--
-- Name: reqFeedbacks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqFeedbacks" (
    id integer NOT NULL,
    value character varying(255)
);


ALTER TABLE public."reqFeedbacks" OWNER TO postgres;

--
-- Name: reqFeedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqFeedbacks_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqFeedbacks_id_seq" OWNER TO postgres;

--
-- Name: reqFeedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqFeedbacks_id_seq" OWNED BY public."reqFeedbacks".id;


--
-- Name: reqHrReviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqHrReviews" (
    "reviewedId" integer NOT NULL,
    "reviewedServiceId" integer,
    "reviewedSalary" integer,
    "reviewedDescription" character varying(255),
    "reviewedStatus" character varying(255) DEFAULT 'pending'::character varying,
    "reviewedJoiningDate" timestamp with time zone
);


ALTER TABLE public."reqHrReviews" OWNER TO postgres;

--
-- Name: reqHrReviews_reviewedId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqHrReviews_reviewedId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqHrReviews_reviewedId_seq" OWNER TO postgres;

--
-- Name: reqHrReviews_reviewedId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqHrReviews_reviewedId_seq" OWNED BY public."reqHrReviews"."reviewedId";


--
-- Name: reqIntervieModes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqIntervieModes" (
    id integer NOT NULL,
    "modeName" character varying(255)
);


ALTER TABLE public."reqIntervieModes" OWNER TO postgres;

--
-- Name: reqIntervieModes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqIntervieModes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqIntervieModes_id_seq" OWNER TO postgres;

--
-- Name: reqIntervieModes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqIntervieModes_id_seq" OWNED BY public."reqIntervieModes".id;


--
-- Name: reqLogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqLogs" (
    id integer NOT NULL,
    "userId" integer,
    "serviceRequest" integer,
    "fromStation" integer,
    "toStation" integer,
    mail boolean,
    "mailType" character varying(255),
    status character varying(255)
);


ALTER TABLE public."reqLogs" OWNER TO postgres;

--
-- Name: reqLogs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqLogs_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqLogs_id_seq" OWNER TO postgres;

--
-- Name: reqLogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqLogs_id_seq" OWNED BY public."reqLogs".id;


--
-- Name: reqMultipleRoleAccesses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqMultipleRoleAccesses" (
    "roleAccessId" integer NOT NULL,
    "roleAccessRoleId" bigint,
    "roleAccessUserId" bigint
);


ALTER TABLE public."reqMultipleRoleAccesses" OWNER TO postgres;

--
-- Name: reqMultipleRoleAccesses_roleAccessId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqMultipleRoleAccesses_roleAccessId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqMultipleRoleAccesses_roleAccessId_seq" OWNER TO postgres;

--
-- Name: reqMultipleRoleAccesses_roleAccessId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqMultipleRoleAccesses_roleAccessId_seq" OWNED BY public."reqMultipleRoleAccesses"."roleAccessId";


--
-- Name: reqOfferAttachments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqOfferAttachments" (
    id integer NOT NULL,
    "candidateId" integer,
    "updatedBy" integer,
    station integer,
    "attachmentPath" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."reqOfferAttachments" OWNER TO postgres;

--
-- Name: reqOfferAttachments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqOfferAttachments_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqOfferAttachments_id_seq" OWNER TO postgres;

--
-- Name: reqOfferAttachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqOfferAttachments_id_seq" OWNED BY public."reqOfferAttachments".id;


--
-- Name: reqProgressSkills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqProgressSkills" (
    id integer NOT NULL,
    "skillId" integer,
    score integer,
    "serviceSeqId" integer
);


ALTER TABLE public."reqProgressSkills" OWNER TO postgres;

--
-- Name: reqProgressSkills_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqProgressSkills_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqProgressSkills_id_seq" OWNER TO postgres;

--
-- Name: reqProgressSkills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqProgressSkills_id_seq" OWNED BY public."reqProgressSkills".id;


--
-- Name: reqQuestionBoxes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqQuestionBoxes" (
    id integer NOT NULL,
    "requstId" integer
);


ALTER TABLE public."reqQuestionBoxes" OWNER TO postgres;

--
-- Name: reqQuestionBoxes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqQuestionBoxes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqQuestionBoxes_id_seq" OWNER TO postgres;

--
-- Name: reqQuestionBoxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqQuestionBoxes_id_seq" OWNED BY public."reqQuestionBoxes".id;


--
-- Name: reqQuestions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqQuestions" (
    "questionId" integer NOT NULL,
    "questionName" character varying(255),
    "questionTotalMark" integer
);


ALTER TABLE public."reqQuestions" OWNER TO postgres;

--
-- Name: reqQuestions_questionId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqQuestions_questionId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqQuestions_questionId_seq" OWNER TO postgres;

--
-- Name: reqQuestions_questionId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqQuestions_questionId_seq" OWNED BY public."reqQuestions"."questionId";


--
-- Name: reqRejectReasons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqRejectReasons" (
    id integer NOT NULL,
    value character varying(255)
);


ALTER TABLE public."reqRejectReasons" OWNER TO postgres;

--
-- Name: reqRejectReasons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqRejectReasons_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqRejectReasons_id_seq" OWNER TO postgres;

--
-- Name: reqRejectReasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqRejectReasons_id_seq" OWNED BY public."reqRejectReasons".id;


--
-- Name: reqReports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqReports" (
    id integer NOT NULL,
    recruiter integer,
    "position" integer,
    "positionHc" integer,
    "naukriResume" integer DEFAULT 0,
    "linkedinResume" integer DEFAULT 0,
    "sourcedScreened" integer DEFAULT 0,
    "candidateContacted" integer DEFAULT 0,
    "candidatesIntrested" integer DEFAULT 0,
    "interviewScheduled" integer DEFAULT 0,
    "offerReleased" integer DEFAULT 0,
    date timestamp with time zone NOT NULL,
    "interviewConducted" integer,
    "interviewReScheduled" integer DEFAULT 0,
    "offerAccepeted" integer DEFAULT 0,
    "indeedResume" integer DEFAULT 0,
    "candidateResume" integer DEFAULT 0,
    "inHouseResume" integer DEFAULT 0
);


ALTER TABLE public."reqReports" OWNER TO postgres;

--
-- Name: reqReports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqReports_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqReports_id_seq" OWNER TO postgres;

--
-- Name: reqReports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqReports_id_seq" OWNED BY public."reqReports".id;


--
-- Name: reqServiceFlows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqServiceFlows" (
    "flowId" integer NOT NULL,
    "flowServiceId" integer,
    "flowStationId" integer,
    "flowStationName" character varying(255)
);


ALTER TABLE public."reqServiceFlows" OWNER TO postgres;

--
-- Name: reqServiceFlows_flowId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqServiceFlows_flowId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqServiceFlows_flowId_seq" OWNER TO postgres;

--
-- Name: reqServiceFlows_flowId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqServiceFlows_flowId_seq" OWNED BY public."reqServiceFlows"."flowId";


--
-- Name: reqServiceRequests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqServiceRequests" (
    "requestId" integer NOT NULL,
    "requestName" character varying(255),
    "requestSkills" character varying(255),
    "requestExperience" numeric,
    "requestStatus" character varying(255) DEFAULT 'active'::character varying,
    "requestTeam" integer,
    "requestServiceId" integer,
    "requestDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "requestVacancy" integer,
    "requestCode" character varying(255),
    "requestDesignation" integer,
    "requestDescription" text,
    "requestPostingDate" timestamp with time zone,
    "requestClosingDate" timestamp with time zone,
    "requestMinimumExperience" integer DEFAULT 0,
    "requestMaximumExperience" integer DEFAULT 0,
    "requestManager" integer,
    "requestMaxSalary" character varying(255),
    "requestBaseSalary" character varying(255),
    "requestHiredCount" integer DEFAULT 0,
    "requestLocation" character varying(255),
    "requestSalaryType" integer
);


ALTER TABLE public."reqServiceRequests" OWNER TO postgres;

--
-- Name: reqServiceRequests_requestId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqServiceRequests_requestId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqServiceRequests_requestId_seq" OWNER TO postgres;

--
-- Name: reqServiceRequests_requestId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqServiceRequests_requestId_seq" OWNED BY public."reqServiceRequests"."requestId";


--
-- Name: reqServiceSequences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqServiceSequences" (
    "serviceId" integer NOT NULL,
    "serviceStation" integer,
    "serviceServiceRequst" integer,
    "serviceCandidate" integer,
    "serviceAssignee" integer,
    "serviceDate" timestamp with time zone,
    "serviceStatus" character varying(255) DEFAULT 'pending'::character varying,
    "serviceServiceId" integer,
    "serviceScheduledBy" integer,
    "previousCurrentStation" integer,
    "resonSwitchStation" character varying(255),
    "interviewCount" integer DEFAULT 0,
    "interviewRescheduled" boolean,
    "interviewRescheduledCount" integer DEFAULT 0,
    "interviewMode" character varying(255),
    "interviewLocation" character varying(255),
    "interviewMail" boolean,
    "interviewMailType" character varying(255),
    "insertOrUpdateDate" timestamp with time zone,
    "serviceSourceDate" time without time zone
);


ALTER TABLE public."reqServiceSequences" OWNER TO postgres;

--
-- Name: reqServiceSequencesAcitves; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqServiceSequencesAcitves" (
    "serviceActiveId" integer NOT NULL,
    "serviceId" integer,
    "serviceStation" integer,
    "serviceServiceRequst" integer,
    "serviceCandidate" integer,
    "serviceAssignee" integer,
    "serviceDate" timestamp with time zone,
    "serviceStatus" character varying(255) DEFAULT 'pending'::character varying,
    "serviceServiceId" integer,
    "serviceScheduledBy" integer,
    "previousCurrentStation" integer,
    "resonSwitchStation" character varying(255),
    "interviewCount" integer DEFAULT 0,
    "interviewRescheduled" boolean,
    "interviewRescheduledCount" integer DEFAULT 0,
    "interviewMode" character varying(255),
    "interviewLocation" character varying(255),
    "interviewMail" boolean,
    "interviewMailType" character varying(255)
);


ALTER TABLE public."reqServiceSequencesAcitves" OWNER TO postgres;

--
-- Name: reqServiceSequencesAcitves_serviceActiveId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqServiceSequencesAcitves_serviceActiveId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqServiceSequencesAcitves_serviceActiveId_seq" OWNER TO postgres;

--
-- Name: reqServiceSequencesAcitves_serviceActiveId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqServiceSequencesAcitves_serviceActiveId_seq" OWNED BY public."reqServiceSequencesAcitves"."serviceActiveId";


--
-- Name: reqServiceSequences_serviceId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqServiceSequences_serviceId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqServiceSequences_serviceId_seq" OWNER TO postgres;

--
-- Name: reqServiceSequences_serviceId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqServiceSequences_serviceId_seq" OWNED BY public."reqServiceSequences"."serviceId";


--
-- Name: reqServices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqServices" (
    "sericeId" integer NOT NULL,
    "sericeName" character varying(255)
);


ALTER TABLE public."reqServices" OWNER TO postgres;

--
-- Name: reqServices_sericeId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqServices_sericeId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqServices_sericeId_seq" OWNER TO postgres;

--
-- Name: reqServices_sericeId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqServices_sericeId_seq" OWNED BY public."reqServices"."sericeId";


--
-- Name: reqSkills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqSkills" (
    id integer NOT NULL,
    "skillName" character varying(255),
    "typeId" integer,
    type character varying(255)
);


ALTER TABLE public."reqSkills" OWNER TO postgres;

--
-- Name: reqSkills_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqSkills_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqSkills_id_seq" OWNER TO postgres;

--
-- Name: reqSkills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqSkills_id_seq" OWNED BY public."reqSkills".id;


--
-- Name: reqStations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqStations" (
    "stationId" integer NOT NULL,
    "stationName" character varying(255)
);


ALTER TABLE public."reqStations" OWNER TO postgres;

--
-- Name: reqStations_stationId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqStations_stationId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqStations_stationId_seq" OWNER TO postgres;

--
-- Name: reqStations_stationId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqStations_stationId_seq" OWNED BY public."reqStations"."stationId";


--
-- Name: reqTasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqTasks" (
    "taskId" integer NOT NULL,
    "taskName" character varying(255),
    "taskServiceId" integer,
    "taskUserId" integer,
    "taskDate" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "taskStatus" character varying(255) DEFAULT 'pending'::character varying
);


ALTER TABLE public."reqTasks" OWNER TO postgres;

--
-- Name: reqTasks_taskId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqTasks_taskId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqTasks_taskId_seq" OWNER TO postgres;

--
-- Name: reqTasks_taskId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqTasks_taskId_seq" OWNED BY public."reqTasks"."taskId";


--
-- Name: reqTeams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqTeams" (
    "teamId" integer NOT NULL,
    "teamName" character varying(255)
);


ALTER TABLE public."reqTeams" OWNER TO postgres;

--
-- Name: reqTeams_teamId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqTeams_teamId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqTeams_teamId_seq" OWNER TO postgres;

--
-- Name: reqTeams_teamId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqTeams_teamId_seq" OWNED BY public."reqTeams"."teamId";


--
-- Name: reqUserRoles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqUserRoles" (
    "roleId" integer NOT NULL,
    "roleName" character varying(255),
    "roleUserId" bigint
);


ALTER TABLE public."reqUserRoles" OWNER TO postgres;

--
-- Name: reqUserRoles_roleId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqUserRoles_roleId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqUserRoles_roleId_seq" OWNER TO postgres;

--
-- Name: reqUserRoles_roleId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqUserRoles_roleId_seq" OWNED BY public."reqUserRoles"."roleId";


--
-- Name: reqUsers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqUsers" (
    "userId" integer NOT NULL,
    "userfirstName" character varying(255) NOT NULL,
    "userlastName" character varying(255) NOT NULL,
    "userEmail" character varying(255) NOT NULL,
    "userDOB" timestamp with time zone,
    "userPassword" character varying(255) NOT NULL,
    "userWorkStation" integer NOT NULL,
    "userRole" character varying(255) NOT NULL,
    "userType" character varying(255),
    "userStatus" character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "userOtp" character varying(255),
    "useOtpExpire" timestamp with time zone
);


ALTER TABLE public."reqUsers" OWNER TO postgres;

--
-- Name: reqUsers_userId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqUsers_userId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqUsers_userId_seq" OWNER TO postgres;

--
-- Name: reqUsers_userId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqUsers_userId_seq" OWNED BY public."reqUsers"."userId";


--
-- Name: reqinterviewDetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqinterviewDetails" (
    id integer NOT NULL,
    "serviceId" integer,
    "interviewLocation" character varying(255),
    "interviewMode" character varying(255),
    "interviewStatus" character varying(255),
    "candidateStatus" character varying(255),
    "rescheduleStatus" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "preferMode" integer,
    "revlentExperience" character varying(255),
    "totalExperience" character varying(255)
);


ALTER TABLE public."reqinterviewDetails" OWNER TO postgres;

--
-- Name: reqinterviewDetails_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqinterviewDetails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqinterviewDetails_id_seq" OWNER TO postgres;

--
-- Name: reqinterviewDetails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqinterviewDetails_id_seq" OWNED BY public."reqinterviewDetails".id;


--
-- Name: reqreqruiterStationReports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqreqruiterStationReports" (
    id integer NOT NULL,
    "position" integer,
    station integer,
    "user" integer,
    "screenRejected" integer DEFAULT 0,
    "writtenReject" integer DEFAULT 0,
    "techOneReject" integer DEFAULT 0,
    "techTwoReject" integer DEFAULT 0,
    "managementReject" integer DEFAULT 0,
    "hrReject" integer DEFAULT 0,
    "offerReleased" integer DEFAULT 0,
    hired integer DEFAULT 0,
    date timestamp with time zone NOT NULL,
    "technicalTotalSelected" integer DEFAULT 0,
    "totalSourced" integer DEFAULT 0
);


ALTER TABLE public."reqreqruiterStationReports" OWNER TO postgres;

--
-- Name: reqreqruiterStationReports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqreqruiterStationReports_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqreqruiterStationReports_id_seq" OWNER TO postgres;

--
-- Name: reqreqruiterStationReports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqreqruiterStationReports_id_seq" OWNED BY public."reqreqruiterStationReports".id;


--
-- Name: reqworkModes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reqworkModes" (
    id integer NOT NULL,
    "modeName" character varying(255)
);


ALTER TABLE public."reqworkModes" OWNER TO postgres;

--
-- Name: reqworkModes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reqworkModes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reqworkModes_id_seq" OWNER TO postgres;

--
-- Name: reqworkModes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reqworkModes_id_seq" OWNED BY public."reqworkModes".id;


--
-- Name: reqAccessTokens accessId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqAccessTokens" ALTER COLUMN "accessId" SET DEFAULT nextval('public."reqAccessTokens_accessId_seq"'::regclass);


--
-- Name: reqCandidateComments commentId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidateComments" ALTER COLUMN "commentId" SET DEFAULT nextval('public."reqCandidateComments_commentId_seq"'::regclass);


--
-- Name: reqCandidateLogs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidateLogs" ALTER COLUMN id SET DEFAULT nextval('public."reqCandidateLogs_id_seq"'::regclass);


--
-- Name: reqCandidateProgresses progressId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidateProgresses" ALTER COLUMN "progressId" SET DEFAULT nextval('public."reqCandidateProgresses_progressId_seq"'::regclass);


--
-- Name: reqCandidateResumeSources sourceId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidateResumeSources" ALTER COLUMN "sourceId" SET DEFAULT nextval('public."reqCandidateResumeSources_sourceId_seq"'::regclass);


--
-- Name: reqCandidateSkills id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidateSkills" ALTER COLUMN id SET DEFAULT nextval('public."reqCandidateSkills_id_seq"'::regclass);


--
-- Name: reqCandidates candidateId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidates" ALTER COLUMN "candidateId" SET DEFAULT nextval('public."reqCandidates_candidateId_seq"'::regclass);


--
-- Name: reqDesignations designationId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqDesignations" ALTER COLUMN "designationId" SET DEFAULT nextval('public."reqDesignations_designationId_seq"'::regclass);


--
-- Name: reqExperienceReports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqExperienceReports" ALTER COLUMN id SET DEFAULT nextval('public."reqExperienceReports_id_seq"'::regclass);


--
-- Name: reqFeedbacks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqFeedbacks" ALTER COLUMN id SET DEFAULT nextval('public."reqFeedbacks_id_seq"'::regclass);


--
-- Name: reqHrReviews reviewedId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqHrReviews" ALTER COLUMN "reviewedId" SET DEFAULT nextval('public."reqHrReviews_reviewedId_seq"'::regclass);


--
-- Name: reqIntervieModes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqIntervieModes" ALTER COLUMN id SET DEFAULT nextval('public."reqIntervieModes_id_seq"'::regclass);


--
-- Name: reqLogs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqLogs" ALTER COLUMN id SET DEFAULT nextval('public."reqLogs_id_seq"'::regclass);


--
-- Name: reqMultipleRoleAccesses roleAccessId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqMultipleRoleAccesses" ALTER COLUMN "roleAccessId" SET DEFAULT nextval('public."reqMultipleRoleAccesses_roleAccessId_seq"'::regclass);


--
-- Name: reqOfferAttachments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqOfferAttachments" ALTER COLUMN id SET DEFAULT nextval('public."reqOfferAttachments_id_seq"'::regclass);


--
-- Name: reqProgressSkills id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqProgressSkills" ALTER COLUMN id SET DEFAULT nextval('public."reqProgressSkills_id_seq"'::regclass);


--
-- Name: reqQuestionBoxes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqQuestionBoxes" ALTER COLUMN id SET DEFAULT nextval('public."reqQuestionBoxes_id_seq"'::regclass);


--
-- Name: reqQuestions questionId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqQuestions" ALTER COLUMN "questionId" SET DEFAULT nextval('public."reqQuestions_questionId_seq"'::regclass);


--
-- Name: reqRejectReasons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqRejectReasons" ALTER COLUMN id SET DEFAULT nextval('public."reqRejectReasons_id_seq"'::regclass);


--
-- Name: reqReports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqReports" ALTER COLUMN id SET DEFAULT nextval('public."reqReports_id_seq"'::regclass);


--
-- Name: reqServiceFlows flowId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceFlows" ALTER COLUMN "flowId" SET DEFAULT nextval('public."reqServiceFlows_flowId_seq"'::regclass);


--
-- Name: reqServiceRequests requestId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceRequests" ALTER COLUMN "requestId" SET DEFAULT nextval('public."reqServiceRequests_requestId_seq"'::regclass);


--
-- Name: reqServiceSequences serviceId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceSequences" ALTER COLUMN "serviceId" SET DEFAULT nextval('public."reqServiceSequences_serviceId_seq"'::regclass);


--
-- Name: reqServiceSequencesAcitves serviceActiveId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceSequencesAcitves" ALTER COLUMN "serviceActiveId" SET DEFAULT nextval('public."reqServiceSequencesAcitves_serviceActiveId_seq"'::regclass);


--
-- Name: reqServices sericeId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServices" ALTER COLUMN "sericeId" SET DEFAULT nextval('public."reqServices_sericeId_seq"'::regclass);


--
-- Name: reqSkills id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqSkills" ALTER COLUMN id SET DEFAULT nextval('public."reqSkills_id_seq"'::regclass);


--
-- Name: reqStations stationId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqStations" ALTER COLUMN "stationId" SET DEFAULT nextval('public."reqStations_stationId_seq"'::regclass);


--
-- Name: reqTasks taskId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqTasks" ALTER COLUMN "taskId" SET DEFAULT nextval('public."reqTasks_taskId_seq"'::regclass);


--
-- Name: reqTeams teamId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqTeams" ALTER COLUMN "teamId" SET DEFAULT nextval('public."reqTeams_teamId_seq"'::regclass);


--
-- Name: reqUserRoles roleId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqUserRoles" ALTER COLUMN "roleId" SET DEFAULT nextval('public."reqUserRoles_roleId_seq"'::regclass);


--
-- Name: reqUsers userId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqUsers" ALTER COLUMN "userId" SET DEFAULT nextval('public."reqUsers_userId_seq"'::regclass);


--
-- Name: reqinterviewDetails id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqinterviewDetails" ALTER COLUMN id SET DEFAULT nextval('public."reqinterviewDetails_id_seq"'::regclass);


--
-- Name: reqreqruiterStationReports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqreqruiterStationReports" ALTER COLUMN id SET DEFAULT nextval('public."reqreqruiterStationReports_id_seq"'::regclass);


--
-- Name: reqworkModes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqworkModes" ALTER COLUMN id SET DEFAULT nextval('public."reqworkModes_id_seq"'::regclass);


--
-- Data for Name: SequelizeMeta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."SequelizeMeta" (name) FROM stdin;
20231109092540-create-req-user.js
20231109100901-create-req-access-token.js
20231110065604-create-req-user-role.js
20231110070137-create-req-multiple-role-access.js
20231110083446-add-column-userrole.js
20231114054246-create-req-service-request.js
20231114054248-create-req-candidates.js
20231114070917-create-req-team.js
20231114073152-add_column-req-candidate.js
20231117050221-create-req-station.js
20231117053105-create-req-service-sequence.js
20231120051429-add-column-candidate_station.js
20231123053022-create-req-candidate-progress.js
20231127054350-remove-column-candidateHiringFor-in-candidateTable.js
20231128052040-change-datatype-requestTeam-reqServiceRequests.js
20231128065523-create-req-task.js
20231128120712-add-column-taskStatus-in-task.js
20231204052010-create-req-services.js
20231204053232-create-req-service-flow.js
20231204115605-add-column-in-serviceSequence-as-ServiceId.js
20231207043305-create-req-hr-review.js
20231207064918-add-column-requestServiceId-in-serviceRequest.js
20231207114642-add-column-candidateResume-reqCandidates.js
20231208100214-add-column-serviceRequestDate-serviceRequest.js
20231214084750-add-column-changeDatatype-acesstoken.js
20240102120646-create-req-skill.js
20240103080727-create-req-candidate-skill.js
20240117051439-create-req-questions.js
20240202051937-create-req-candidate-comments.js
20240202064035-create-req-candidate-resume-source.js
20240202065220-add-column-resumeSourceId.js
20240208044707-create-reqinterview-detail.js
20240208053400-add-column-in-reqcandidate.js
20240209091708-create-req-report.js
20240212042649-add-column-in-service.js
20240212045200-add-column-in-reqcandidate.js
20240212094108-create-trigger-reports.js
20240212094714-bind-add_reports-function-with-reqreports.js
20240213051920-add-column-seqInterviewScheuledBy.js
20240215084458-add-column-interviewCOnducted-report.js
20240220042441-create-req-experience-report.js
20240222071009-add-column-Candidate-interviewStatus.js
20240226101839-add-column-userid-date-reqcomments.js
20240229073549-create-req-intervie-mode.js
20240304111534-add-column-reqcandidates.js
20240403120528-addColumn_progress.js
20240408053038-add-column-interviewReschedule.js
20240408123707-add-column-offerAccept.js
20240415055252-add-colum-progressskills.js
20240416065827-add-colum-serviceRequest.js
20240416073822-create-req-designation.js
20240418092130-add-column-progress.js
20240423104507-add-column-station-from-sequence.js
20240429052705-add-column-comments-sequelize.js
20240502092942-create-req-question-box.js
20240502094816-add-column-QUESTIONBOX-reqCandidateProgresses.js
20240522042327-add-column-dataType-service-request.js
20240530093401-create-req-logs.js
20240604051851-create-req-service-sequences-acitve.js
20240604053432-add-trigger-to-reqServiceSequencesAcitve.js
20240604121134-add-column-candidates.js
20240605052334-create-reqwork-mode.js
20240605052335-add-colum-interviewDetails.js
20240605072908-add-colum-serviceRequirement.js
20240607054712-add-colum-serviceSequence.js
20240611043038-add-colum-activeSequence.js
20240611092621-add-column-candidate.js
20240626051807-create-req-candidate-log.js
20240626101045-add-colum-serviceRequest.js
20240703063654-create-reqreqruiter-station-report.js
20240710085911-requestion-coloumn-type-change.js
20240712053642-column-add-reqreqruiterStationReports-selected-from-technical.js
20240725054758-add-column-to-reqServiceSequences.js
20240729064545-add-column-to-reqUser.js
20240731050739-add-column-to-reqServiceRequests.js
20240814091924-add-column-to-reqReports.js
20240911060325-add-column-to-req-sequence-sourcedate.js
20241023052547-add-column-reqskill.js
20241023060326-create-req-feedbacks.js
20241023060532-create-req-reject-reason.js
20241023084802-add-column-requsationlocation.js
20241028044617-add-column-salarytype-requestion.js
20241028100305-create-req-progress-skill.js
20241105064329-create-req-offer-attachments.js
20241106104022-add-column-comment-reject-approve.js
20241106120320-add-column-candidateLog-requestion.js
20241119085348-add-column-locationandsalrytpe.js
\.


--
-- Data for Name: reqAccessTokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqAccessTokens" ("accessId", "createdAt", "updatedAt", "accessToken") FROM stdin;
\.


--
-- Data for Name: reqCandidateComments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqCandidateComments" ("commentId", "commentSeqenceId", "commentComment", "commentUserId", "commentDate", "offerReleaseReject") FROM stdin;
\.


--
-- Data for Name: reqCandidateLogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqCandidateLogs" (id, station, "candidateId", "actionBy", action, date, "position") FROM stdin;
1	\N	\N	\N	\N	2024-12-02 11:43:11.591276+00	\N
2	\N	\N	\N	\N	2024-12-02 11:43:14.311897+00	\N
3	1	1423	6	Candidate Sourced From Candidate	2024-12-10 05:37:16.096396+00	\N
4	1	1424	6	Candidate Sourced From Candidate	2024-12-10 05:43:01.160471+00	\N
\.


--
-- Data for Name: reqCandidateProgresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqCandidateProgresses" ("progressId", "progressScore", "progressStation", "progressVerifiedBy", "progressQuestion", "progressDescription", "progressServiceSequence", "progressCreatedAt", "progressAverageScore", "progressSkills", "progressFile", "questionBox") FROM stdin;
\.


--
-- Data for Name: reqCandidateResumeSources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqCandidateResumeSources" ("sourceId", "sourceName") FROM stdin;
1	Naukri
2	Linkedin
3	Indeed
4	Reference
5	In House
\.


--
-- Data for Name: reqCandidateSkills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqCandidateSkills" (id, "candidateId", "candidateSno", "candidateSkillType", "candidateSkillId") FROM stdin;
\.


--
-- Data for Name: reqCandidates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqCandidates" ("candidateId", "candidateFirstName", "candidateLastName", "candidateDoB", "candidateExperience", "candidatePreviousOrg", "candidatePreviousDesignation", "candidateEducation", "candidateCurrentSalary", "candidateExpectedSalary", "candidateAddress", "candidateStatus", "createdAt", "updatedAt", "candidateEmail", "candidateMobileNo", "candidateStation", "candidateHireRole", "candidateResume", "resumeSourceId", "candidateNoticePeriodByDays", "candidatesAddingAgainst", "candidateInterviewStatus", "candidateCreatedby", "candidateGender", "candidateCity", "candidateDistrict", "candidateState", "candidatePreferlocation", "candidateRevlentExperience", "candidateTotalExperience", "workMode") FROM stdin;
1423	Shejnamol	S	\N	\N	NIC	Senior Software Engineer	MCA	480000	700000	\N	active	2024-12-10 05:37:16.071+00	2024-12-10 05:38:14.269+00	sheju31@gmail.com	9400377876	\N	\N	Shejnamol S_PHP.pdf	4	\N	\N	inprogress	6	Female	Trivandrum	Kottayam	Kerala	Trivandrum	6	6	\N
1424	Anisha	Mathew	\N	\N	WebAndCrafts	Quality Assurance Engineer	B Tech	360000	0	\N	active	2024-12-10 05:43:01.147+00	2024-12-10 05:43:01.147+00	anishamathew669@gmail.com	9446113093	\N	\N	Anisha Mathew_QA.pdf	4	\N	\N	inprogress	6	Female	Trivandrum	Kottayam	Kerala	Trivandrum	2.10	2.10	\N
1	Mahesh R	 	\N	10Yrs	Orion Innovation	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	maheshr@mail.com	1111111111	\N	\N	\N	5	90 days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
2	Sneha P Jaykumar	 	\N	4.5Yrs	H&R Block	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	snehapjaykumar@mail.com	1111111111	\N	\N	\N	5	90 days	24	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
3	Subbalekshmi	 	\N	3.2Yrs	Centizen	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	subbalekshmi@mail.com	1111111111	\N	\N	\N	5	90 Days nego 60	25	inprogress	\N	\N	Thirunelveli	\N	\N	Trivandrum	\N	\N	\N
4	Sreereshmi	 	\N	7 Yrs	Infosys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreereshmi@mail.com	1111111111	\N	\N	\N	5	60 Days	21	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
5	Madhi Madhan	 	\N	4.5 Yrs	Blue Chip Technologies,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	madhimadhan@mail.com	1111111111	\N	\N	\N	5	30 Days	2	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
6	Dinesh E	 	\N	5.4 Yrs	Capestart	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dineshe@mail.com	1111111111	\N	\N	\N	5	90 Days	10	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
7	Akshay Kumar	 	\N	2 Yrs	Cordova Educational Services	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akshaykumar@mail.com	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
8	Arun Raj KV	 	\N	5.6 Yrs	Webmate Business Solution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunrajkv@mail.com	1111111111	\N	\N	\N	5	Immediate	13	inprogress	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
9	Geethu A G	 	\N	7 Yrs	Acutis Digital	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	geethuag@mail.com	1111111111	\N	\N	\N	5	30 Days	13	inprogress	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
10	ANGELIN JEBA Y	 	\N	1.10 Yrs	Pit Solution Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	angelinjebay@mail.com	1111111111	\N	\N	\N	5	60 Days	46	rejected	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
11	Suchitha Menon	 	\N	7 Yrs	Trenser Technologies Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	suchithamenon@mail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
12	AKHILA.A	 	\N	8.6 Yrs	Trenser Technologies Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhilaa@mail.com	1111111111	\N	\N	\N	5	Immediate (Dec 2022)	21	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
13	Sujitha S	 	\N	4.5Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sujithas@mail.com	1111111111	\N	\N	\N	5	60 Days	24	back-off	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
14	Vijay .P.S	 	\N	12.10 Yrs	TCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vijayps@mail.com	1111111111	\N	\N	\N	5	90 Days	38	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
15	Yamuna Rani	 	\N	5 Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	yamunarani@mail.com	1111111111	\N	\N	\N	5	60 Days	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
16	Sathishkumar.J	 	\N	10 Yrs	KPR Info Solution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sathishkumarj@mail.com	1111111111	\N	\N	\N	5	30 Days	6	inprogress	\N	\N	Tiruppur	\N	\N	Trivandrum	\N	\N	\N
17	ADARSH S	 	\N	3 Yrs	Insibe Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	adarshs@mail.com	1111111111	\N	\N	\N	5	Immediate	13	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
18	DEVARAJ PD	 	\N	8 Yrs	BrandFell Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	devarajpd@mail.com	1111111111	\N	\N	\N	5	15 Days	13	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
19	P.D. Pradeesh	 	\N	16 Yrs	Emirates Business Management	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	pdpradeesh@mail.com	1111111111	\N	\N	\N	5	Immediate	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
20	VIPINDAS V G	 	\N	4 Yrs	Tata Elxsi	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vipindasvg@mail.com	1111111111	\N	\N	\N	5	90 Days	8	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
21	Sreeja Lin	 	\N	5 Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreejalin@mail.com	1111111111	\N	\N	\N	5	60 Days	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
22	Mohammed Siraj	 	\N	3 Yrs	Tridz	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mohammedsiraj@mail.com	1111111111	\N	\N	\N	5	Immediate	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
23	Sangeeth	 	\N	3 Yrs	Fingent	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sangeeth@mail.com	1111111111	\N	\N	\N	5	30 Days	19	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
24	Anlit James	 	\N	1.2 Yrs	AppRocker Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anlitjames@mail.com	1111111111	\N	\N	\N	5	60 Days	19	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
25	Amala	 	\N	3.2 Yrs	Nest Digital	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amala@mail.com	1111111111	\N	\N	\N	5	60 Days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
26	Seethal	 	\N	8Yrs	CTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	seethal@mail.com	1111111111	\N	\N	\N	5	90 days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
27	Anju Mohan	 	\N	3.10Yrs	Travancore Analytics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjumohan@mail.com	1111111111	\N	\N	\N	5	90 days	24	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
28	Sreeja Pillai	 	\N	15Yrs	Techninz	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreejapillai@mail.com	1111111111	\N	\N	\N	5	30 days	38	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
29	Greeshma	 	\N	4Yrs	Acsia	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	greeshma@mail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
30	Soundariya	 	\N	5.9 Yrs	Spericorn Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	soundariya@mail.com	1111111111	\N	\N	\N	5	60 Days	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
31	Muhammed Ali Asif	 	\N	7.5	Cinch Business Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammedaliasif@mail.com	1111111111	\N	\N	\N	5	Dec 30 lwd	10	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
32	Janisan	 	\N	2 yrs	Gspark Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	janisan@mail.com	1111111111	\N	\N	\N	5	30 Days	19	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
33	Anup C	 	\N	7 + yrs	Pits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anupc@mail.com	1111111111	\N	\N	\N	5	90 Days	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
34	Anjali Raj	 	\N	8Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjaliraj@mail.com	1111111111	\N	\N	\N	5	90 days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
35	Rakesh Pillai	 	\N	3.10Yrs	Speridian	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rakeshpillai@mail.com	1111111111	\N	\N	\N	5	90 days	24	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
36	Sarika S	 	\N	15Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sarikas@mail.com	1111111111	\N	\N	\N	5	30 days	38	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
37	Anoop	 	\N	4Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anoop@mail.com	1111111111	\N	\N	\N	5	60 Days	2	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
38	Deepa Merlin Dixon K	 	\N	4.8 Yrs	Quantiphi Analytics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	deepamerlindixonk@mail.com	1111111111	\N	\N	\N	5	60 Days	2	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
39	Vinu Abraham Samuel	 	\N	3.8 Yrs	INNOVATION INCUBATOR ADVISORY	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vinuabrahamsamuel@mail.com	1111111111	\N	\N	\N	5	60 Days	2	inprogress	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
40	Akhil KK	 	\N	3 Yrs	Navalt Solar and Electric Boats,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhilkk@mail.com	1111111111	\N	\N	\N	5	90 Days	2	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
41	JAYASHREE N	 	\N	5 Yrs	BOUNTEOUS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jayashreen@mail.com	1111111111	\N	\N	\N	5	Immediate	46	inprogress	\N	\N	Chennai	\N	\N	Cochin	\N	\N	\N
42	ANAMIKA V NAIR	 	\N	1.4 Yrs	Trydan Tech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anamikavnair@mail.com	1111111111	\N	\N	\N	5	Immediate	9	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
43	Devika S	 	\N	1 Yr	Future Mug	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	devikas@mail.com	1111111111	\N	\N	\N	5	30 Days	9	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
44	Jithesh	 	\N	8Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jithesh@mail.com	1111111111	\N	\N	\N	5	90 days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
45	Sreedhu	 	\N	3.10Yrs	Speridian	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreedhu@mail.com	1111111111	\N	\N	\N	5	90 days	24	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
46	Rekha	 	\N	15Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rekha@mail.com	1111111111	\N	\N	\N	5	30 days	38	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
47	Ananth N	 	\N	3 yrr	canvendor software solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ananthn@mail.com	1111111111	\N	\N	\N	5	60 Days	2	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
48	Sarath	 	\N	3 yrr	Zonduo Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sarath@mail.com	1111111111	\N	\N	\N	5	60 Days	2	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
49	Basker	 	\N	7 yrs	Perfectz Digital	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	basker@mail.com	1111111111	\N	\N	\N	5	Immediate	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
50	Christeena Saju	 	\N	1.1 Yr	DIVERGENT CATALIST PRIVATE LIMITED	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	christeenasaju@mail.com	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
51	Anupama	 	\N	6.6 yrs	Doot internet	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anupama@mail.com	1111111111	\N	\N	\N	5	60 days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
52	Reshma	 	\N	4 Yrs	Ainsurtech Pvt. Ltd.,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshma@mail.com	1111111111	\N	\N	\N	5	30 Days	2	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
53	SREENISH CP	 	\N	8 Yts	Protracked	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreenishcp@mail.com	1111111111	\N	\N	\N	5	30 Days	13	inprogress	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
54	Jeyakumar M	 	\N	4.11 Yrs	Innovatise Technology Private limited	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jeyakumarm@mail.com	1111111111	\N	\N	\N	5	30 Days	10	inprogress	\N	\N	Tenkasi	\N	\N	Trivandrum	\N	\N	\N
55	Nibu Chandy Varghese	 	\N	5.9 Yrs	TCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nibuchandyvarghese@mail.com	1111111111	\N	\N	\N	5	Immediate	10	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
56	MANJU K	 	\N	Fresher	NA	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	manjuk@mail.com	1111111111	\N	\N	\N	5	Immediate	9	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
57	Reshma R	 	\N	8Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmar@mail.com	1111111111	\N	\N	\N	5	90 days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
58	Jaydeep S	 	\N	5Yrs	Mariapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jaydeeps@mail.com	1111111111	\N	\N	\N	5	90 days	24	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
59	Sijesh	 	\N	4.7Yrs	Thoughtline	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sijesh@mail.com	1111111111	\N	\N	\N	5	90 days Nego 30`	25	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
60	Midhun K R	 	\N	2.5 Yrs	Align mind	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	midhunkr@mail.com	1111111111	\N	\N	\N	5	30 Days	22	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
61	Sinu George	 	\N	4 Yrs	Opentrends	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sinugeorge@mail.com	1111111111	\N	\N	\N	5	60 Days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
62	Arun	 	\N	5 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arun@mail.com	1111111111	\N	\N	\N	5	60 Days	23	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
63	RINKU JULI GEORGE	 	\N	10 Yrs	Thoughtline Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rinkujuligeorge@mail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
64	Laiju Khan	 	\N	6 Yrs	Standout IT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	laijukhan@mail.com	1111111111	\N	\N	\N	5	Immediate	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
65	GOPIKA PG	 	\N	5 Yrs	DRD Communication	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gopikapg@mail.com	1111111111	\N	\N	\N	5	LWD April 29 	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
66	FEMEENA P. H	 	\N	3.5 Yrs	Wariyum Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	femeenaph@mail.com	1111111111	\N	\N	\N	5	90 Days	21	rejected	\N	\N	Remote	\N	\N	Remote	\N	\N	\N
67	Ananth Sanjeev	 	\N	15 Yrs	Techwarelab Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ananthsanjeev@mail.com	1111111111	\N	\N	\N	5	Serving NP(#1st March , 2024)	6	rejected	\N	\N	Madurai	\N	\N	Trivandrum	\N	\N	\N
68	Shehanaz Sheik Naushad	 	\N	3 Yrs	SayOne Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shehanazsheiknaushad@mail.com	1111111111	\N	\N	\N	5	60 Days	6	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
69	Rajeesh	 	\N	4.5Yrs	Pit Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rajeesh@mail.com	1111111111	\N	\N	\N	5	LWD May 29th	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
70	Rahul	 	\N	4.3Yrs	Pit Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahul@mail.com	1111111111	\N	\N	\N	5	90 Days	18	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
71	JayakumarCS	 	\N	5Yrs	Orion Innovations	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jayakumarcs@mail.com	1111111111	\N	\N	\N	5	90 days	24	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
72	Jaymohan	 	\N	4.7Yrs	Thoughtline	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jaymohan@mail.com	1111111111	\N	\N	\N	5	90 days Nego 30`	25	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
73	Vishnu Mohan	 	\N	4 Yrs	Acsia	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnumohan@mail.com	1111111111	\N	\N	\N	5	Serving Lwd July 16	2	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
74	Muhammed Arshid	 	\N	5 Yrs	Quantify	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammedarshid@mail.com	1111111111	\N	\N	\N	5	90 Days	2	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
75	Saranya	 	\N	7 Yrs	Testhouse	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	saranya@mail.com	1111111111	\N	\N	\N	5	60 Days	10	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
76	Athira s	 	\N	3 Yrs	Palnar Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athiras@mail.com	1111111111	\N	\N	\N	5	60 Days	22	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
77	Sreerag V S	 	\N	5 Yrs	NOA Infosolutions LLP	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreeragvs@mail.com	1111111111	\N	\N	\N	5	15 Days	13	rejected	\N	\N	Kasargod	\N	\N	Cochin	\N	\N	\N
78	ANJANA VIJAYAKUMAR	 	\N	5.4 Yrs	Cognizant technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjanavijayakumar@mail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Wayanad	\N	\N	Cochin	\N	\N	\N
79	Faheema Abdul Raheem	 	\N	2.5 Yrs	Tecfuge Business Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	faheemaabdulraheem@mail.com	1111111111	\N	\N	\N	5	60 Days	23	rejected	\N	\N	Malappuram	\N	\N	Cochin	\N	\N	\N
80	Prabhleen Kaur	 	\N	10 Yrs	TCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	prabhleenkaur@mail.com	1111111111	\N	\N	\N	5	90 Days	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
81	Gireeh S	 	\N	6Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gireehs@mail.com	1111111111	\N	\N	\N	5	60 days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
82	Sharika AS	 	\N	5Yrs	H&R	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sharikaas@mail.com	1111111111	\N	\N	\N	5	90 days	24	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
83	Jayadeep	 	\N	4.7Yrs	Thoughtline	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jayadeep@mail.com	1111111111	\N	\N	\N	5	90 Days	25	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
84	Nithin Mathew	 	\N	9 Yrs	Aspire systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nithinmathew@mail.com	1111111111	\N	\N	\N	5	90 Days	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
85	Ajo A. Mundackal	 	\N	15 Yrs	Cognizant	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajoamundackal@mail.com	1111111111	\N	\N	\N	5	60 Days	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
86	Arun T R	 	\N	3 Yrs	Adobe	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aruntr@mail.com	1111111111	\N	\N	\N	5	60 Days	46	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
87	Jimin Jacob	 	\N	3.9 Yrs	Simplogics Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jiminjacob@mail.com	1111111111	\N	\N	\N	5	60 Days	24	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
88	Resmi	 	\N	7 yrs	Freelance	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	resmi@mail.com	1111111111	\N	\N	\N	5	Immediate	2	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
89	Sandhya C S	 	\N	4 Yrs	Orell Software Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sandhyacs@mail.com	1111111111	\N	\N	\N	5	45 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
90	Amalaraj s	 	\N	2 Yrs	Craysol Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amalarajs@mail.com	1111111111	\N	\N	\N	5	Immediate	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
91	Rakesh K A	 	\N	12 + Yrs	Clockhash Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rakeshka@mail.com	1111111111	\N	\N	\N	5	30 Days	14	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
92	NIJIL P GEORGE	 	\N	10.2 Yrs	INFOSYS Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nijilpgeorge@mail.com	1111111111	\N	\N	\N	5	Immediate	10	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
93	Ancy Thomas	 	\N	11 Yrs	Pits Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ancythomas@mail.com	1111111111	\N	\N	\N	5	60 Days	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
94	Harish P N	 	\N	11 Yrs	UVJ Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	harishpn@mail.com	1111111111	\N	\N	\N	5	60 Days	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
95	Krishnendhu	 	\N	4.5 Yrs	SLK Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	krishnendhu@mail.com	1111111111	\N	\N	\N	5	Immediate	2	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
96	Jerin Sebastain	 	\N	4.2 Yrs	Bency Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jerinsebastain@mail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
97	Raichel Mariyam	 	\N	11 Yrs	IBS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	raichelmariyam@mail.com	1111111111	\N	\N	\N	5	60 Days	38	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
98	ANZAL M.A	 	\N	5.2 Yrs	ARS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anzalma@mail.com	1111111111	\N	\N	\N	5	Immediate	18	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
99	Susmitha.Nair.S	 	\N	10 Yrs	ARS T & TT	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	susmithanairs@mail.com	1111111111	\N	\N	\N	5	90 Day	35	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
100	Seethal C Sudheer	 	\N	16 Yrs	UST Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	seethalcsudheer@mail.com	1111111111	\N	\N	\N	5	60 Days	32	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
101	Reshmy Rajan	 	\N	11 Yrs	TechTaliya	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmyrajan@mail.com	1111111111	\N	\N	\N	5	60 Days	39	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
102	Neethu KS	 	\N	6Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethuks@mail.com	1111111111	\N	\N	\N	5	60 days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
103	Ramesh Ravi	 	\N	10Yrs	Suyati Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rameshravi@mail.com	1111111111	\N	\N	\N	5	30 days	38	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
104	Ansu M	 	\N	5Yrs	Socius 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ansum@mail.com	1111111111	\N	\N	\N	5	90 Days	23	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
105	Rahul Anand C	 	\N	2.6 Yrs	Iroid 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahulanandc@mail.com	1111111111	\N	\N	\N	5	Serving(LWD- 30th April)	25	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
106	Simi Joseph	 	\N	9 Yrs	PITS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	simijoseph@mail.com	1111111111	\N	\N	\N	5	90 Days	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
107	Sankar Raja	 	\N	12 Yrs	Distinct Infotech Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sankarraja@mail.com	1111111111	\N	\N	\N	5	Serving(LWD- 22ndApril)	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
108	Vanitha	 	\N	2 Yrs	Invisor	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vanitha@mail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
109	Jis Francis	 	\N	6.5 Yrs	LTIMindtree	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jisfrancis@mail.com	1111111111	\N	\N	\N	5	60 Days	38	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
110	Imran Khan	 	\N	4.9 Yrs	Accubits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	imrankhan@mail.com	1111111111	\N	\N	\N	5	90 Days	28	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
111	Sravan	 	\N	1.1 Yrs	Elsys Intelligent	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sravan@mail.com	1111111111	\N	\N	\N	5	15 days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
112	Anupa Kuriakose	 	\N	4 Yrs	LO Technology 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anupakuriakose@mail.com	1111111111	\N	\N	\N	5	30 Days(Neg)	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
113	Archana Rajan I	 	\N	4 Yrs	KERALA KAUMUDI	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	archanarajani@mail.com	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
114	Sangeeth Prakash	 	\N	4.2 Yrs	Accubits Texhnologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sangeethprakash@mail.com	1111111111	\N	\N	\N	5	Immediate(LWD - March 31, 2024)	19	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
115	SOUMYA T	 	\N	6 Yrs	RAK INTERIORS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	soumyat@mail.com	1111111111	\N	\N	\N	5	Immediate	13	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
116	Sourav Santhosh	 	\N	4 Yrs	Divergent Catalyst	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	souravsanthosh@mail.com	1111111111	\N	\N	\N	5	45 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
117	DEEPA P.N	 	\N	14 Yrs	Vione Technologies Pvt	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	deepapn@mail.com	1111111111	\N	\N	\N	5	30 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
118	Praveen Kumar	 	\N	9 Yrs	McLaren Strategic Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	praveenkumar@mail.com	1111111111	\N	\N	\N	5	Immediate	38	inprogress	\N	\N	Bangalore	\N	\N	Cochin	\N	\N	\N
119	Naveen	 	\N	4.9Yrs	Marlabs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	naveen@mail.com	1111111111	\N	\N	\N	5	Immediate	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
120	George Antony	 	\N	4Yrs	Pit Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	georgeantony@mail.com	1111111111	\N	\N	\N	5	LWD April 29th	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
121	Lekshmi	 	\N	5.8Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lekshmi@mail.com	1111111111	\N	\N	\N	5	LWD 30April	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
122	Vineesh AK	 	\N	5.3Yrs	Photon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vineeshak@mail.com	1111111111	\N	\N	\N	5	90 Days	25	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
123	Sivagurunathan.S	 	\N	14 Yrs	OSS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sivagurunathans@mail.com	1111111111	\N	\N	\N	5	60 Days	35	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
124	Rajesh M P	 	\N	13 Yrs	Mava Business Consulting	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rajeshmp@mail.com	1111111111	\N	\N	\N	5	30 Days	37	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
125	Arun Dev G S	 	\N	7 Yrs	Kran Consulting	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arundevgs@mail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
126	Akhilesh P	 	\N	7.9 Yrs	Chris Johnson	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhileshp@mail.com	1111111111	\N	\N	\N	5	Immediate	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
127	Salmanual Faris	 	\N	3 Yrs	 Winds Business Solutions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	salmanualfaris@mail.com	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
128	Greeshma T Sabu	 	\N	4.6 Yrs	SISL Infotech PVT	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	greeshmatsabu@mail.com	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
129	K Nitya Prakash	 	\N	1.3 Yrs	Ekatra Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	knityaprakash@mail.com	1111111111	\N	\N	\N	5	30 Days	13	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
130	R S RAMA PRATHEEBA	 	\N	12 Yrs	iDynamics Software Pvt. Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rsramapratheeba@mail.com	1111111111	\N	\N	\N	5	30 Days	35	rejected	\N	\N	Marthandam	\N	\N	Trivandrum	\N	\N	\N
131	RESHMI S	 	\N	11 Yrs	OrthoFX PVT LTD	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmis@mail.com	1111111111	\N	\N	\N	5	60 Days	10	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
132	Sandhun	 	\N	5.5Yrs	Art Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sandhun@mail.com	1111111111	\N	\N	\N	5	60 days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
133	Rinimol	 	\N	5Yrs	Bourntech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rinimol@mail.com	1111111111	\N	\N	\N	5	60 days	21	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
134	Arjun	 	\N	3.4Yrs	TCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arjun@mail.com	1111111111	\N	\N	\N	5	LWD 14Jun	18	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
135	Anjitha	 	\N	3Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjitha@mail.com	1111111111	\N	\N	\N	5	60 days	28	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
136	Christa Sara	 	\N	4Yrs	BEO Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	christasara@mail.com	1111111111	\N	\N	\N	5	60 days	23	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
137	Abhijith S	 	\N	8 Yrs	Jasper Micron	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abhijiths@mail.com	1111111111	\N	\N	\N	5	60 Days	14	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
274	Aswathy A	 	\N	10 yrs	 Exza	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswathya@mail.com	1111111111	\N	\N	\N	5	30 Days	14	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
138	Shahir Shan	 	\N	7 Yrs	Acelrtech 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shahirshan@mail.com	1111111111	\N	\N	\N	5	30 Days	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
139	Sutha Pakiya Grace	 	\N	2 Yrs	Vcinch Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	suthapakiyagrace@mail.com	1111111111	\N	\N	\N	5	30 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
140	Manoj.N.B	 	\N	11 Yrs	 Xerox Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	manojnb@mail.com	1111111111	\N	\N	\N	5	30 Days	35	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
141	Sharuk Nazeer	 	\N	4 Yrs	Indium Softwares	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sharuknazeer@mail.com	1111111111	\N	\N	\N	5	30 Days	6	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
142	Abhirami Mahesh	 	\N	1.8 Yrs	Indium Softwares	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abhiramimahesh@mail.com	1111111111	\N	\N	\N	5	30 Days	6	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
143	Amrut C N	 	\N	2.6 Yrs	ZESTYBEANZ TECHNOLOGIES PVT LTD	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amrutcn@mail.com	1111111111	\N	\N	\N	5	Serving (LWD June 15th)	23	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
144	Muhammed Ashiq	 	\N	2.5 YRs	Zoondia	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammedashiq@mail.com	1111111111	\N	\N	\N	5	90 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
145	SMIDHUN N MOHANAN	 	\N	8 Yrs	Abacies Logiciels	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	smidhunnmohanan@mail.com	1111111111	\N	\N	\N	5	90 Days	14	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
146	Saranya Kumar G	 	\N	6 Yrs 	Accubits Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	saranyakumarg@mail.com	1111111111	\N	\N	\N	5	30 Days	13	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
147	SUSMITHA SURESH	 	\N	4 Yrs	Spericorn Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	susmithasuresh@mail.com	1111111111	\N	\N	\N	5	60 Days	19	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
148	ARUN M.V	 	\N	8.5 Yrs	Aspire Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunmv@mail.com	1111111111	\N	\N	\N	5	90 Days	43	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
149	Muhammed Shameel	 	\N	5Yrs	Muraco Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammedshameel@mail.com	1111111111	\N	\N	\N	5	30 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
150	Hari Shankar	 	\N	6Yrs	Orion Innovation	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	harishankar@mail.com	1111111111	\N	\N	\N	5	90 days	21	back-off	\N	\N	Cherthala	\N	\N	Cochin	\N	\N	\N
151	Jeena Thomas	 	\N	3.4Yrs	Neoito	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jeenathomas@mail.com	1111111111	\N	\N	\N	5	30 days	24	back-off	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
152	Akhiljith A	 	\N	9Yrs	UST 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhiljitha@mail.com	1111111111	\N	\N	\N	5	60 days	35	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
153	Nidhish	 	\N	10Yrs	IQVIA	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nidhish@mail.com	1111111111	\N	\N	\N	5	60 days	2	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
154	Akshay Rajagopal	 	\N	7 Yrs	QBurst	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akshayrajagopal@mail.com	1111111111	\N	\N	\N	5	60 Days	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
155	Sreyas Santhosh. P.P	 	\N	6 Yrs	jazp.com	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreyassanthoshpp@mail.com	1111111111	\N	\N	\N	5	30 Days	14	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
156	Rishinath.R	 	\N	7 Yrs	POLUS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rishinathr@mail.com	1111111111	\N	\N	\N	5	30 Days	10	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
157	Khajina P K	 	\N	3 Yrs	Gritstone	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	khajinapk@mail.com	1111111111	\N	\N	\N	5	30 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
158	Vishnu P	 	\N	6 Yrs	Solution Analysts	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnup@mail.com	1111111111	\N	\N	\N	5	60 days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
159	Karthik Sugu	 	\N	2 Yrs	Iroid	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	karthiksugu@mail.com	1111111111	\N	\N	\N	5	30 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
160	Binsha Thomas	 	\N	3 yrs	WEbykart	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	binshathomas@mail.com	1111111111	\N	\N	\N	5	30 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
161	Anuja R Kumar	 	\N	6.5 Yrs	Saasvaap Techies Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anujarkumar@mail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
162	ABHIJITH T	 	\N	7 Yrs	Incredible Visibility Solution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abhijitht@mail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
163	Ansil TM	 	\N	3.2 Yrs	TechWyse IT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ansiltm@mail.com	1111111111	\N	\N	\N	5	LWD _ Dec 26	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
164	ANU K PULIYEDOM	 	\N	8 yrs	Vofox Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anukpuliyedom@mail.com	1111111111	\N	\N	\N	5	45 days	24	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
165	JOMAT THOMAS	 	\N	7 Yrs	Kameda Infologics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jomatthomas@mail.com	1111111111	\N	\N	\N	5	90 Days	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
166	Appu Vinayak	 	\N	7 Yrs	Zafin Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	appuvinayak@mail.com	1111111111	\N	\N	\N	5	Serving(LWD-15th May)	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
167	ASHIR P K	 	\N	6.5 Yrs	SPERIDIAN 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ashirpk@mail.com	1111111111	\N	\N	\N	5	Serving(LWD- 24th April)	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
168	Jashir K A	 	\N	5.3 Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jashirka@mail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
169	Sudheesh P S	 	\N	6.8 Yrs	mDrift Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sudheeshps@mail.com	1111111111	\N	\N	\N	5	60 Days	42	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
170	Mohammed Riyas	 	\N	7Yrs	Allianz	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mohammedriyas@mail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
171	Midhun Lal	 	\N	3.5 Yrs	Rapid Techs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	midhunlal@mail.com	1111111111	\N	\N	\N	5	30 Days	2	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
172	Jithin 	 	\N	12Yrs	Gradient	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jithin@mail.com	1111111111	\N	\N	\N	5	LWD May 1	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
173	Arun Mathew	 	\N	3.6 Yrs	Reflections Info Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunmathew@mail.com	1111111111	\N	\N	\N	5	60 Days	2	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
174	Mansoor CP	 	\N	9.5 Yrs	Abana Technologoies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mansoorcp@mail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
175	Jisha K N	 	\N	8.5 Yrs	Sutherland Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jishakn@mail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
176	ASWIN SAJITH	 	\N	3.6 Yrs	HEU TECHNOLOGIES	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswinsajith@mail.com	1111111111	\N	\N	\N	5	60 Days	2	back-off	\N	\N	Alapuzha	\N	\N	Cochin	\N	\N	\N
177	Dileep K	 	\N	4.7 Yrs	Epixel Solutions Pvt. Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dileepk@mail.com	1111111111	\N	\N	\N	5	60 Days	8	rejected	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
178	MIJI K MENON	 	\N	9 + Yrs	Teranet Inc	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mijikmenon@mail.com	1111111111	\N	\N	\N	5	60 Days	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
179	Sarath AJ	 	\N	7 Yrs	SinuousTech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sarathaj@mail.com	1111111111	\N	\N	\N	5	60 Days	3	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
180	Nino C Philip	 	\N	3 Yrs	TechMaven It Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ninocphilip@mail.com	1111111111	\N	\N	\N	5	Immediate	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
181	Adarsh Sudhakar	 	\N	3 Yrs	Iquad Innovations	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	adarshsudhakar@mail.com	1111111111	\N	\N	\N	5	30 Day	8	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
182	Dennis VC 	 	\N	12 Yrs	Notech Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dennisvc@mail.com	1111111111	\N	\N	\N	5	30 Days	35	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
183	NajinShah N	 	\N	7.5 Yrs	RMESI	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	najinshahn@mail.com	1111111111	\N	\N	\N	5	LWD 13th May 2024	24	inprogress	\N	\N	Trivandeum	\N	\N	Trivandrum	\N	\N	\N
184	Akshay Sudhakaran	 	\N	4 Yrs	LO Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akshaysudhakaran@mail.com	1111111111	\N	\N	\N	5	30 days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
185	Aravindkumar Ganesan	 	\N	4.9 Yrs	Azentio	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aravindkumarganesan@mail.com	1111111111	\N	\N	\N	5	90 Days	19	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
186	Bilal Ahamed	 	\N	5.2 Yrs	Trensar Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bilalahamed@mail.com	1111111111	\N	\N	\N	5	90 days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
187	John Jacob	 	\N	4.5 Yrs	FIRMINIQ SYSTEMS PVT LTD	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	johnjacob@mail.com	1111111111	\N	\N	\N	5	60 Days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
188	Sreerekha S	 	\N	4Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreerekhas@mail.com	1111111111	\N	\N	\N	5	LWD June 10th	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
189	Suraj K	 	\N	7.10Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	surajk@mail.com	1111111111	\N	\N	\N	5	30 days	25	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
190	Akshay Krishnan	 	\N	5.6Yrs	Socius	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akshaykrishnan@mail.com	1111111111	\N	\N	\N	5	LWD May 4th	23	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
191	Abhima C	 	\N	6 Yrs	NeST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abhimac@mail.com	1111111111	\N	\N	\N	5	60 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
192	Anjana S Babu	 	\N	7 Yrs	 cinque tech 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjanasbabu@mail.com	1111111111	\N	\N	\N	5	60 Days	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
193	Ananthu Pradeep	 	\N	5 Yrs	Alokin	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ananthupradeep@mail.com	1111111111	\N	\N	\N	5	30 Days	8	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
194	Ajitha A	 	\N	6.4 Yrs	 Flytxt	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajithaa@mail.com	1111111111	\N	\N	\N	5	60 Days	21	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
195	Veena roy	 	\N	9Yrs	Aspire Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	veenaroy@mail.com	1111111111	\N	\N	\N	5	LWD May 17th	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
196	Rahul M	 	\N	5Yrs	Zensar	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahulm@mail.com	1111111111	\N	\N	\N	5	90 days	24	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
197	Aashik	 	\N	3.10Yrs	Neoito	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aashik@mail.com	1111111111	\N	\N	\N	5	60 days	28	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
198	Aneesh S	 	\N	6Yrs	Daiviksoft technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aneeshs@mail.com	1111111111	\N	\N	\N	5	30 days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
199	Austin	 	\N	4Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	austin@mail.com	1111111111	\N	\N	\N	5	LWD May2nd 	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
200	Muhammed Aslam	 	\N	3.5Yrs	Fakeeh Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammedaslam@mail.com	1111111111	\N	\N	\N	5	90 days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
201	Amrutha G Nath	 	\N	5.8Yrs	Neural rays	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amruthagnath@mail.com	1111111111	\N	\N	\N	5	30 days	23	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
202	Muhammed Sarthaj	 	\N	4Yrs	Accubits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammedsarthaj@mail.com	1111111111	\N	\N	\N	5	30 days	6	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
203	Vishak C	 	\N	3 Yrs	Stallion One Byte solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishakc@mail.com	1111111111	\N	\N	\N	5	60 Days	13	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
204	NEETHU P	 	\N	2 Yrs	XINFOZ TECHNOLOGIES	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethup@mail.com	1111111111	\N	\N	\N	5	Immediate	18	rejected	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
205	JEMY ANN JOSEPH	 	\N	4.11 Yrs	PIT SOLUTIONS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jemyannjoseph@mail.com	1111111111	\N	\N	\N	5	90 Days	23	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
206	Louis Paul Pynadath	 	\N	6 Yrs	L&t technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	louispaulpynadath@mail.com	1111111111	\N	\N	\N	5	Immediate	37	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
207	VANDANAS	 	\N	4 Yrs	LeadiconTechnologie	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vandanas@mail.com	1111111111	\N	\N	\N	5	45 Days	25	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
208	Karthikeyan	 	\N	3.8Yrs	Vagus Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	karthikeyan@mail.com	1111111111	\N	\N	\N	5	30th April	18	rejected	\N	\N	Trichy	\N	\N	Trivandrum	\N	\N	\N
209	Rosmy Antony	 	\N	6Yrs	Orion Innovation	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rosmyantony@mail.com	1111111111	\N	\N	\N	5	90 days	21	back-off	\N	\N	Cherthala	\N	\N	Cochin	\N	\N	\N
210	Jibin R	 	\N	5.8Yrs	Neural rays	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jibinr@mail.com	1111111111	\N	\N	\N	5	30 days	23	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
211	Naveen Mohan	 	\N	10Yrs	Finastra	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	naveenmohan@mail.com	1111111111	\N	\N	\N	5	60 Days	\N	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
212	Naganandhini	 	\N	2.5 Yrs	Trioangle Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	naganandhini@mail.com	1111111111	\N	\N	\N	5	Serving Lwd April 30th	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
213	Faris K P	 	\N	8 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	fariskp@mail.com	1111111111	\N	\N	\N	5	30 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
214	Shilpa Reji	 	\N	2.8 Yrs	Marriapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shilpareji@mail.com	1111111111	\N	\N	\N	5	30 Days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
215	Vishnu M Das	 	\N	4.9 Yrs	Tredence Analytics Solutions Pvt. Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnumdas@mail.com	1111111111	\N	\N	\N	5	60 Days	47	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
216	BINEESH VADAKKEPURAKKAL	 	\N	8 Yrs	Gritstone Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bineeshvadakkepurakkal@mail.com	1111111111	\N	\N	\N	5	Immediate	35	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
217	SOBIN VARGHESE	 	\N	7 Yrs	HINTT	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sobinvarghese@mail.com	1111111111	\N	\N	\N	5	30 Days	19	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
218	Avinash T S	 	\N	2.3 Yrs	TechWyse IT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	avinashts@mail.com	1111111111	\N	\N	\N	5	Serving NP	22	rejected	\N	\N	Wayanad	\N	\N	Cochin	\N	\N	\N
219	JASIM RAHMAN  	 	\N	5.2 Yrs	HP (Joined on March 2024)	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jasimrahman@mail.com	1111111111	\N	\N	\N	5	60 Days	\N	rejected	\N	\N	Thalassery	\N	\N	Cochin	\N	\N	\N
220	William	 	\N	6 Yrs	Canopus Infosystems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	william@mail.com	1111111111	\N	\N	\N	5	60 Days	\N	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
221	Aravind Soman	 	\N	5Yrs	Vagus Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aravindsoman@mail.com	1111111111	\N	\N	\N	5	60 days	18	rejected	\N	\N	Trichy	\N	\N	Trivandrum	\N	\N	\N
222	Shamshad	 	\N	2.5Yrs	Cybrosis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shamshad@mail.com	1111111111	\N	\N	\N	5	90 days	23	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
223	Neethu Mohan	 	\N	10Yrs	Finastra	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethumohan@mail.com	1111111111	\N	\N	\N	5	60 Days	38	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
224	Arjun P Prakash	 	\N	5.6 Yrs	NOMD Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arjunpprakash@mail.com	1111111111	\N	\N	\N	5	30 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
225	Riney Augestine	 	\N	3.7 Yrs	Admaren Tech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rineyaugestine@mail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
226	Visakh Murali	 	\N	4.3 Yrs	Xtravision.ai	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	visakhmurali@mail.com	1111111111	\N	\N	\N	5	Serving May 15 LWD	2	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
227	Rinnu Raj P	 	\N	6.5 Yrs	Aspire Sysytems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rinnurajp@mail.com	1111111111	\N	\N	\N	5	Immediate	10	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
228	Navya Jose	 	\N	3.1 Yrs	Bluo Software India	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	navyajose@mail.com	1111111111	\N	\N	\N	5	Immediate	47	rejected	\N	\N	Remote	\N	\N	Remote	\N	\N	\N
229	ALKA S	 	\N	2.2 Yrs	NDimensionZ Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alkas@mail.com	1111111111	\N	\N	\N	5	60 Days	21	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
230	VISHNU PP	 	\N	3.5 Yrs	RapidValue Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnupp@mail.com	1111111111	\N	\N	\N	5	60 Days	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
231	ARJUN K CHANDRAN	 	\N	10.3 Yrs	Simelabs Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arjunkchandran@mail.com	1111111111	\N	\N	\N	5	15 Days	38	back-off	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
232	Vishnu R	 	\N	2 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnur@mail.com	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
233	Jithin Mohan	 	\N	5Yrs	Vagus Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jithinmohan@mail.com	1111111111	\N	\N	\N	5	60 days	18	rejected	\N	\N	Trichy	\N	\N	Trivandrum	\N	\N	\N
234	Karthika R	 	\N	6Yrs	Orion Innovation	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	karthikar@mail.com	1111111111	\N	\N	\N	5	90 days	21	rejected	\N	\N	Cherthala	\N	\N	Cochin	\N	\N	\N
235	Meenu Shankar	 	\N	10Yrs	Finastra	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	meenushankar@mail.com	1111111111	\N	\N	\N	5	60 Days	38	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
236	Anjali A J	 	\N	8 Yrs	Millenium EBS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjaliaj@mail.com	1111111111	\N	\N	\N	5	60 Days	38	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
237	Martin	 	\N	1.4 Yrs	GLAREAL SOFTWARE SOLUTIONS Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	martin@mail.com	1111111111	\N	\N	\N	5	Serving LWD 30th April	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
238	Shuhaira K A	 	\N	5 Yrs	Orison technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shuhairaka@mail.com	1111111111	\N	\N	\N	5	60 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
239	Suraj C S	 	\N	5.6 Yrs	 SEQATO 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	surajcs@mail.com	1111111111	\N	\N	\N	5	60 Days	21	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
240	Anandhu Sajeev	 	\N	4.5 Yrs	Toobler	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anandhusajeev@mail.com	1111111111	\N	\N	\N	5	60 Days	25	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
241	Srudeep PA	 	\N	5 Yrs	Tata Elxsi	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	srudeeppa@mail.com	1111111111	\N	\N	\N	5	30 Days	2	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
242	Ajay G	 	\N	6.5 Yrs	Sinelabs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajayg@mail.com	1111111111	\N	\N	\N	5	15 Days	25	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
243	ANANDU DAS	 	\N	6.7 Yrs	Iris Medical Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anandudas@mail.com	1111111111	\N	\N	\N	5	60 Days	10	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
244	Arsha C S	 	\N	3 Yrs	Focaloid Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arshacs@mail.com	1111111111	\N	\N	\N	5	60 Days	6	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
245	GOKUL S	 	\N	5.5 Yrs	Mindlogue Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gokuls@mail.com	1111111111	\N	\N	\N	5	Immediate	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
246	RAKESH.K	 	\N	6 Yrs	NEW QUANTUM TECH	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rakeshk@mail.com	1111111111	\N	\N	\N	5	Immediate	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
247	Nishad K S	 	\N	2 Yrs	FeatherSoft	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nishadks@mail.com	1111111111	\N	\N	\N	5	90 Days	24	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
248	Sreehari M S	 	\N	1.5 Yrs	Techbyheart India	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreeharims@mail.com	1111111111	\N	\N	\N	5	60 Days	24	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
249	Vishnu S	 	\N	5Yrs	Vagus Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnus@mail.com	1111111111	\N	\N	\N	5	60 days	18	back-off	\N	\N	Trichy	\N	\N	Trivandrum	\N	\N	\N
250	Akhil Rajan	 	\N	6Yrs	Orion Innovation	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhilrajan@mail.com	1111111111	\N	\N	\N	5	90 days	21	back-off	\N	\N	Cherthala	\N	\N	Cochin	\N	\N	\N
251	Sabith A	 	\N	4Yrs	Socious	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sabitha@mail.com	1111111111	\N	\N	\N	5	90 days	23	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
252	Gayathri S	 	\N	10Yrs	Finastra	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gayathris@mail.com	1111111111	\N	\N	\N	5	60 Days	38	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
253	Divya Joseph	 	\N	9Yrs	Bigspark	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	divyajoseph@mail.com	1111111111	\N	\N	\N	5	Immediate	\N	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
254	Reshma Jayan	 	\N	11.5 Yrs	Alokin	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmajayan@mail.com	1111111111	\N	\N	\N	5	30 Days	3	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
255	Seetharaman	 	\N	9 Yrs	Sierra ODC Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	seetharaman@mail.com	1111111111	\N	\N	\N	5	Immediate	47	rejected	\N	\N	Remote	\N	\N	Remote	\N	\N	\N
256	Vikram R	 	\N	4.5 Yrs	Point Perfect Technology Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vikramr@mail.com	1111111111	\N	\N	\N	5	Immediate	47	rejected	\N	\N	Remote	\N	\N	Remote	\N	\N	\N
257	Wasim Akram K	 	\N	6.4 Yrs	SKAD IT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	wasimakramk@mail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
258	Sabreena K P	 	\N	8 Yrs	FutureRx LLC	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sabreenakp@mail.com	1111111111	\N	\N	\N	5	Immediate	37	back-off	\N	\N	Remote	\N	\N	Remote	\N	\N	\N
259	Akash Antony	 	\N	8 Yrs	Cognizant 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akashantony@mail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
260	Naveena P K	 	\N	7.8 Yrs	 Foxfennecs Technologies 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	naveenapk@mail.com	1111111111	\N	\N	\N	5	30 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
261	Parvathy unnikrishnan	 	\N	3.9Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	parvathyunnikrishnan@mail.com	1111111111	\N	\N	\N	5	90 days	18	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
262	Alen Mathew	 	\N	5.6Yrs	Mariapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alenmathew@mail.com	1111111111	\N	\N	\N	5	90 days	18	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
263	Nikhil	 	\N	5Yrs	GBS Plus	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nikhil@mail.com	1111111111	\N	\N	\N	5	60 days Nego 45 days	38	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
264	Ashley	 	\N	3.2Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ashley@mail.com	1111111111	\N	\N	\N	5	Immediate	22	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
265	Sreejith	 	\N	5 Yrs	Xminds	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreejith@mail.com	1111111111	\N	\N	\N	5	90 Days	19	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
266	Vibin	 	\N	8 Yrs	Capestart	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vibin@mail.com	1111111111	\N	\N	\N	5	90 Days	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
267	Ismail T K 	 	\N	6.5 Yrs	Hash Connect 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ismailtk@mail.com	1111111111	\N	\N	\N	5	Immediate	28	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
268	Shijin Bhaskar	 	\N	9 Yrs	Quest	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shijinbhaskar@mail.com	1111111111	\N	\N	\N	5	Serving(LWD - 12th July)	38	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
269	Aswin Krishna	 	\N	8 Yrs	2Hats Logic	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswinkrishna@mail.com	1111111111	\N	\N	\N	5	60 Days	14	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
270	Sunil Chakravarthi K	 	\N	8 Yrs	LetMeDoIt	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sunilchakravarthik@mail.com	1111111111	\N	\N	\N	5	60 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
271	Reshma K R	 	\N	3 Yrs	Iroid	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmakr@mail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
272	Jyothish S	 	\N	\N	\N	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jyothishs@mail.com	1111111111	\N	\N	\N	5	\N	19	inprogress	\N	\N	\N	\N	\N	\N	\N	\N	\N
273	Muhammed Ali H	 	\N	6.2 Yrs	InApp	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammedalih@mail.com	1111111111	\N	\N	\N	5	Immediate	18	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
275	Mathew John	 	\N	5Yrs	GBS Plus	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mathewjohn@mail.com	1111111111	\N	\N	\N	5	60 days Nego 45 days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
276	Rohith R	 	\N	3.2Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rohithr@mail.com	1111111111	\N	\N	\N	5	Immediate	22	back-off	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
277	Jaison M	 	\N	3Yrs	Micro Objects	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jaisonm@mail.com	1111111111	\N	\N	\N	5	30 Days	25	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
278	Harisanth	 	\N	3.6 Yrs	Claysys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	harisanth@mail.com	1111111111	\N	\N	\N	5	90 Days	19	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
279	Sreya	 	\N	2 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreya@mail.com	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
280	Deepa	 	\N	4.8 Yrs	Quantifi	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	deepa@mail.com	1111111111	\N	\N	\N	5	30 Days	2	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
281	Lilly Steny	 	\N	3 Yrs	Techxers Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lillysteny@mail.com	1111111111	\N	\N	\N	5	90 Days	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
282	Ahamed Nabeen	 	\N	3.6 Yrs	Inavan India Technologies Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ahamednabeen@mail.com	1111111111	\N	\N	\N	5	Serving July 31st	2	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
283	Divya Mary Kuruvila	 	\N	9.6 Yrs	Vanilla Networks	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	divyamarykuruvila@mail.com	1111111111	\N	\N	\N	5	ServingMay 22nd	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
284	Junaidh	 	\N	5Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	junaidh@mail.com	1111111111	\N	\N	\N	5	60 days	18	back-off	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
285	Sidharth	 	\N	5Yrs	Citius Tech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sidharth@mail.com	1111111111	\N	\N	\N	5	60 days	21	back-off	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
286	Manju	 	\N	4.7Yrs	Attinadu Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	manju@mail.com	1111111111	\N	\N	\N	5	60 days	24	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
287	Avinash	 	\N	2.7Yrs	Digital Mesh	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	avinash@mail.com	1111111111	\N	\N	\N	5	45 Days	8	back-off	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
288	Vishnu Sankar	 	\N	5 Yrs	SCG 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnusankar@mail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
289	Arjun V	 	\N	5 Yrs	HCL 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arjunv@mail.com	1111111111	\N	\N	\N	5	Immediate	8	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
290	Rethish C R	 	\N	14 Yrs	Onesoft technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rethishcr@mail.com	1111111111	\N	\N	\N	5	60 Days	35	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
291	Prathyush Lal K J	 	\N	12 Yrs	Rtechsols 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	prathyushlalkj@mail.com	1111111111	\N	\N	\N	5	60 Days	14	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
292	Akshay VJ	 	\N	4 Yrs	Inavan India Technologies Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akshayvj@mail.com	1111111111	\N	\N	\N	5	Immediate	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
293	Remyamol	 	\N	8.9 Yrs	Pinmicro	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	remyamol@mail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
294	Anto Abraham	 	\N	5 YRs	Cubet	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	antoabraham@mail.com	1111111111	\N	\N	\N	5	60 Days	22	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
295	Anjana	 	\N	7 Yrs	Marriapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjana@mail.com	1111111111	\N	\N	\N	5	90 Days	21	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
296	Nishad M	 	\N	5Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nishadm@mail.com	1111111111	\N	\N	\N	5	60 days	18	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
297	Keerthana S	 	\N	5Yrs	Citius Tech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	keerthanas@mail.com	1111111111	\N	\N	\N	5	60 days	22	rejected	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
298	Anu AG	 	\N	7Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anuag@mail.com	1111111111	\N	\N	\N	5	30 days	42	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
299	Rahul R	 	\N	5Yrs	Zellis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahulr@mail.com	1111111111	\N	\N	\N	5	60 Days	24	back-off	\N	\N	Kozhikode	\N	\N	Cochin	\N	\N	\N
300	Abdul Adhar P K	 	\N	12 Yrs	 Stellosys 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abduladharpk@mail.com	1111111111	\N	\N	\N	5	30 Days	35	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
301	Afsal Rahman	 	\N	5.2 Yrs	PALNAR	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	afsalrahman@mail.com	1111111111	\N	\N	\N	5	30 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
302	Muhammed Asif P	 	\N	5.6 Yrs	HubSpire	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammedasifp@mail.com	1111111111	\N	\N	\N	5	30 Days	22	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
303	Vishakh K M	 	\N	7.1 Yrs	IBS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishakhkm@mail.com	1111111111	\N	\N	\N	5	60 Days	21	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
304	Amal Asok	 	\N	4.8 Yrs	App Station	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amalasok@mail.com	1111111111	\N	\N	\N	5	90 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
305	Firoz G G	 	\N	6 Yrs	SayOne	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	firozgg@mail.com	1111111111	\N	\N	\N	5	60 Days	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
306	Athira A	 	\N	7 Yrs	Scalgo	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athiraa@mail.com	1111111111	\N	\N	\N	5	60 Days	19	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
307	Priyanka CK	 	\N	5Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	priyankack@mail.com	1111111111	\N	\N	\N	5	60 days	18	back-off	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
308	Ajmal S	 	\N	5Yrs	Citius Tech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajmals@mail.com	1111111111	\N	\N	\N	5	60 days	21	rejected	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
309	Keerthana M	 	\N	7Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	keerthanam@mail.com	1111111111	\N	\N	\N	5	30 days	42	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
310	Sajeesh	 	\N	5Yrs	Accubits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sajeesh@mail.com	1111111111	\N	\N	\N	5	30 days	23	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
311	Sivakumar Balaji	 	\N	9.5 Yrs	Info Vision	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sivakumarbalaji@mail.com	1111111111	\N	\N	\N	5	Serving Lwd May 31st	37	back-off	\N	\N	Remote	\N	\N	Remote	\N	\N	\N
312	Devika	 	\N	7 Yrs	RM 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	devika@mail.com	1111111111	\N	\N	\N	5	90 Days(Neg)	18	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
313	Rashid K P	 	\N	5 Yrs	SRS Global 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rashidkp@mail.com	1111111111	\N	\N	\N	5	60 Days	13	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
314	Dhanesh S	 	\N	9.5 Yrs	Panasa Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dhaneshs@mail.com	1111111111	\N	\N	\N	5	Immediate	11	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
315	Suma K K	 	\N	3 Yrs	NIC	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sumakk@mail.com	1111111111	\N	\N	\N	5	30 Days	13	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
316	Anjana K B	 	\N	2.6 Yrs	Prudent Technilogies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjanakb@mail.com	1111111111	\N	\N	\N	5	Serving Lwd Aug 4th	28	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
317	Lakshmi B	 	\N	8 Yrs	Alokin	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lakshmib@mail.com	1111111111	\N	\N	\N	5	90 Days	10	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
318	Vigneswaran R	 	\N	7.8 Yrs	Travancore Analytics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vigneswaranr@mail.com	1111111111	\N	\N	\N	5	60 Days	11	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
319	Krishna U	 	\N	9.3 Yrs	Caxita Tech Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	krishnau@mail.com	1111111111	\N	\N	\N	5	60 Days	11	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
320	Arun Rajeev	 	\N	5Yrs	Allianz Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunrajeev@mail.com	1111111111	\N	\N	\N	5	90 days	21	back-off	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
321	Vishnu Namboothiri	 	\N	8Yrs	ISPG Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnunamboothiri@mail.com	1111111111	\N	\N	\N	5	30 days	25	back-off	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
322	Shalin Thomas	 	\N	4.3Yrs	PIT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shalinthomas@mail.com	1111111111	\N	\N	\N	5	LWD 3rd June	23	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
323	Sugesh S	 	\N	6 Yrs	Xilligence	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sugeshs@mail.com	1111111111	\N	\N	\N	5	30 Days	6	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
324	Vishnu Radhakrishnan	 	\N	2.5 Yrs	Fakeeh Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnuradhakrishnan@mail.com	1111111111	\N	\N	\N	5	Immediate	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
325	Shajeeb Basheer	 	\N	10 Yrs	Synonix	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shajeebbasheer@mail.com	1111111111	\N	\N	\N	5	60 Days	11	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
326	Sajan S	 	\N	15 Yrs	Tricta Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sajans@mail.com	1111111111	\N	\N	\N	5	Immediate	11	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
327	Bibin Baby	 	\N	5Yrs	Web Tech Ads	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bibinbaby@mail.com	1111111111	\N	\N	\N	5	30 Days	2	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
328	Anjali	 	\N	7.8 Yrs	Travancore Analytics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjali@mail.com	1111111111	\N	\N	\N	5	60 Days	38	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
329	Harikrishnan	 	\N	9.3 Yrs	Caxita Tech Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	harikrishnan@mail.com	1111111111	\N	\N	\N	5	60 Days	38	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
330	Abhilash K P	 	\N	3 Yrs	Ndimensions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abhilashkp@mail.com	1111111111	\N	\N	\N	5	60 Days	2	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
331	Nithin K P	 	\N	10.2 Yrs	Bourntec Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nithinkp@mail.com	1111111111	\N	\N	\N	5	Serving May 24th LWD	19	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
332	Biju Kumar Narayanan	 	\N	7 Yrs	Marryapp	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bijukumarnarayanan@mail.com	1111111111	\N	\N	\N	5	Serving Lwd May 31st	8	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
333	Hafis Muhammed	 	\N	2 Yrs	Ceroen Software Solutions Pvt. Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	hafismuhammed@mail.com	1111111111	\N	\N	\N	5	60 Days	8	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
334	Athul Joe	 	\N	3Yrs	Infosys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athuljoe@mail.com	1111111111	\N	\N	\N	5	90 days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
335	Ashik	 	\N	5.7Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ashik@mail.com	1111111111	\N	\N	\N	5	60 days	21	back-off	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
336	Abin	 	\N	7.9Yrs	Amvigo	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abin@mail.com	1111111111	\N	\N	\N	5	90 days	22	rejected	\N	\N	KOchi	\N	\N	Cochin	\N	\N	\N
337	Renjith V S	 	\N	10 Yrs	 ThinkPalm	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	renjithvs@mail.com	1111111111	\N	\N	\N	5	30 Days(Neg)	35	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
338	Shejnamol	 	\N	5.3 Yrs	NIC	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shejnamol@mail.com	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
339	Nisha S Nair	 	\N	6 Yrs	bourntec	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nishasnair@mail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
340	Minnu Merlin Joy	 	\N	5 Yrs	Blueripples	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	minnumerlinjoy@mail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
341	Basim	 	\N	4.3Yrs	3i Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	basim@mail.com	1111111111	\N	\N	\N	5	30 days	18	back-off	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
342	Ajay T	 	\N	3.8Yrs	Epixel	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajayt@mail.com	1111111111	\N	\N	\N	5	60 days	8	rejected	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
343	David	 	\N	2.5Yrs	Point Perfect	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	david@mail.com	1111111111	\N	\N	\N	5	30 days	23	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
344	Jaison	 	\N	6Yrs	Comorin Consulting	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jaison@mail.com	1111111111	\N	\N	\N	5	LWD June 15	22	back-off	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
345	FeminaThayyil	 	\N	9 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	feminathayyil@mail.com	1111111111	\N	\N	\N	5	30 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
346	 raj	 	\N	7 Yrs	 Flexi Ventures	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	raj@mail.com	1111111111	\N	\N	\N	5	30 Days	14	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
347	Anisha A	 	\N	7 Yrs	Daiviksoft 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anishaa@mail.com	1111111111	\N	\N	\N	5	30 Days	19	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
348	Vinil	 	\N	6.6 Yrs	Neoito Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vinil@mail.com	1111111111	\N	\N	\N	5	30 Days	8	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
349	Fazil P A	 	\N	6.5 YRs	Marriapps Marine Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	fazilpa@mail.com	1111111111	\N	\N	\N	5	30 Days	11	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
350	Sibin T	 	\N	11 Yrs	Art Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sibint@mail.com	1111111111	\N	\N	\N	5	90 Days	18	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
351	Shavad C V	 	\N	9.2 yRs	Marlabs Innovations	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shavadcv@mail.com	1111111111	\N	\N	\N	5	Immediate	28	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
352	Shijila K P	 	\N	2.6 Yrs	Epixel Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shijilakp@mail.com	1111111111	\N	\N	\N	5	90 Days	8	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
353	Alen Antony	 	\N	4 Yrs	Alokin Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alenantony@mail.com	1111111111	\N	\N	\N	5	Serving(LWD-31st May)	8	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
354	Lavish T V	 	\N	6.10 Yrs	InApp	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lavishtv@mail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
355	Aswathy Sivan	 	\N	4 Yrs	Overbrook	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswathysivan@mail.com	1111111111	\N	\N	\N	5	30 Days	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
356	Benjamin Joy D	 	\N	7 Yrs	PITS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	benjaminjoyd@mail.com	1111111111	\N	\N	\N	5	90 Days	39	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
357	Sajishna	 	\N	3.5 Yrs	Opentrends	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sajishna@mail.com	1111111111	\N	\N	\N	5	90 Days	25	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
358	Jishitha	 	\N	10 Yrs	Sang Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jishitha@mail.com	1111111111	\N	\N	\N	5	Immediate	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
359	Sino Alex	 	\N	4 rs	Nesote Technologies (P) Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sinoalex@mail.com	1111111111	\N	\N	\N	5	Immediate	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
360	Savin Sabu	 	\N	5.3Yrs	Muthoot Microfinance	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	savinsabu@mail.com	1111111111	\N	\N	\N	5	90 days	18	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
361	Rameez Roshan	 	\N	4Yrs	Louring private	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rameezroshan@mail.com	1111111111	\N	\N	\N	5	90 Days	8	back-off	\N	\N	Kozhikode	\N	\N	Cochin	\N	\N	\N
362	Harish	 	\N	3Yrs	Yubi Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	harish@mail.com	1111111111	\N	\N	\N	5	60 days	25	rejected	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
363	Gokul Raja	 	\N	6.6Yrs	Spangles Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gokulraja@mail.com	1111111111	\N	\N	\N	5	30 days	11	back-off	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
364	Muhammed Insaf	 	\N	4.6Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammedinsaf@mail.com	1111111111	\N	\N	\N	5	30 Days	22	inprogress	\N	\N	Aluva	\N	\N	Cochin	\N	\N	\N
365	Hareesh P H	 	\N	3.4 Yrs	Wai Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	hareeshph@mail.com	1111111111	\N	\N	\N	5	60 Days	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
366	Amrutha S	 	\N	6 Yrs	Gadgeon Smart Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amruthas@mail.com	1111111111	\N	\N	\N	5	60 Days	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
367	Anoop K Vijayan	 	\N	6 Yrs	 YesYemtee Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anoopkvijayan@mail.com	1111111111	\N	\N	\N	5	Serving(LWD-15th June)	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
368	Abdul Sathar	 	\N	11 Yrs	Baselinet 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abdulsathar@mail.com	1111111111	\N	\N	\N	5	30 Days	37	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
369	Harikrishnan V	 	\N	3.8 Yrs	Fingent	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	harikrishnanv@mail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
370	Sreeraj	 	\N	10 Yrs	Kanexy pvt ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreeraj@mail.com	1111111111	\N	\N	\N	5	Immediate	42	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
371	Anjitha R	 	\N	7 .2 Yrs	Pits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjithar@mail.com	1111111111	\N	\N	\N	5	90 Days	35	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
372	Jeffin S Abraham	 	\N	6 Yrs	Geojit	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jeffinsabraham@mail.com	1111111111	\N	\N	\N	5	Serving Lwd July 7th	19	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
373	Joel Trulin	 	\N	3 Yrs	Capestart	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	joeltrulin@mail.com	1111111111	\N	\N	\N	5	90 Days	2	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
374	Arun Jojo	 	\N	4.4Yrs	Inlux	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunjojo@mail.com	1111111111	\N	\N	\N	5	30 Days	24	back-off	\N	\N	Paravoor	\N	\N	Cochin	\N	\N	\N
375	Arju As	 	\N	3.9Yrs	Seqato	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arjuas@mail.com	1111111111	\N	\N	\N	5	60 Days	24	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
376	Arun Raj	 	\N	5.7Yrs	Polus Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunraj@mail.com	1111111111	\N	\N	\N	5	60 days	19	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
377	Eldo Alias	 	\N	6.7Yrs	Krant Consulting	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	eldoalias@mail.com	1111111111	\N	\N	\N	5	60 Days	38	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
378	Rakhi S	 	\N	13Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rakhis@mail.com	1111111111	\N	\N	\N	5	90 days Nego 60	38	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
379	Neenu	 	\N	9Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neenu@mail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
380	Vishnu V Balachander	 	\N	3.2 Yrs	Web and crafts	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnuvbalachander@mail.com	1111111111	\N	\N	\N	5	Immediate	25	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
381	Ajayan	 	\N	3.8 Yrs	Epixel	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajayan@mail.com	1111111111	\N	\N	\N	5	90 Days	8	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
382	Reshma R Gopal	 	\N	5 Yrs	Teranet	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmargopal@mail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
383	Nikhil N	 	\N	5 Yrs	OrderStack	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nikhiln@mail.com	1111111111	\N	\N	\N	5	90 Days	18	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
384	Sugil A	 	\N	5 Yrs	Estrrado Technology 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sugila@mail.com	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
385	Anju John	 	\N	7 Yrs	MariApps 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjujohn@mail.com	1111111111	\N	\N	\N	5	90 Days	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
386	Liju VK	 	\N	5.3Yrs	Thomas Infocare	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lijuvk@mail.com	1111111111	\N	\N	\N	5	30 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
387	Farisa	 	\N	5Yrs	Safecare Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	farisa@mail.com	1111111111	\N	\N	\N	5	30 Days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
388	Ashwanth	 	\N	2.8Yrs	Techvantage	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ashwanth@mail.com	1111111111	\N	\N	\N	5	60 Days Nego 40	2	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
389	Riyas	 	\N	2.8Yrs	Cybrosis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	riyas@mail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
390	Neethu K Saju	 	\N	8 Yrs	Coylinks	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethuksaju@mail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
391	Gokul	 	\N	7 Yrs	Azentio	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gokul@mail.com	1111111111	\N	\N	\N	5	90 Days	38	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
392	Nambi Rajan	 	\N	2.3 Yrs	Glbal Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nambirajan@mail.com	1111111111	\N	\N	\N	5	Immediate	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
393	Mohammed Ridwan	 	\N	4 Yrs	Webandcrafts	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mohammedridwan@mail.com	1111111111	\N	\N	\N	5	60 Days	24	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
394	Vishnu Raj	 	\N	4Yrs	Neoito	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnuraj@mail.com	1111111111	\N	\N	\N	5	30 Days	22	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
395	Sree Ram N	 	\N	3.8 Yrs	Poorvika Mobiles	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreeramn@mail.com	1111111111	\N	\N	\N	5	30 Days	8	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
396	Aswin	 	\N	5.3Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswin@mail.com	1111111111	\N	\N	\N	5	30 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
397	Ankitha	 	\N	2Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ankitha@mail.com	1111111111	\N	\N	\N	5	Immediate	2	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
398	Reena	 	\N	2+Yrs	Forlyft	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reena@mail.com	1111111111	\N	\N	\N	5	15 Days	23	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
399	Shefi	 	\N	7 YRs	Patient MD	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shefi@mail.com	1111111111	\N	\N	\N	5	30 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
400	Riju Roy	 	\N	3.4 Yrs	Featherdyn Pvt. Ltd.	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rijuroy@mail.com	1111111111	\N	\N	\N	5	30 Days	2	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
401	Paul Cheriyan	 	\N	7 Yrs	Viewway Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	paulcheriyan@mail.com	1111111111	\N	\N	\N	5	30 Days	21	back-off	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
402	Dinny Rose	 	\N	6 Yrs	Quest	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dinnyrose@mail.com	1111111111	\N	\N	\N	5	90 Days	8	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
403	Sibin Thomas K	 	\N	14 Yrs	Cyberz Soft Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sibinthomask@mail.com	1111111111	\N	\N	\N	5	Immediate	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
404	Tony Thomas	 	\N	7.9 Yrs	Onesoft	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	tonythomas@mail.com	1111111111	\N	\N	\N	5	60 Days	13	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
405	Arathy Francis	 	\N	7 Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arathyfrancis@mail.com	1111111111	\N	\N	\N	5	Serving(LWD-28th June)	10	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
406	Sanjoo Thomas	 	\N	3Yrs	Micro Objects	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sanjoothomas@mail.com	1111111111	\N	\N	\N	5	30 Days	25	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
407	Saranjith	 	\N	3 Yrs	Metric Tree Labs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	saranjith@mail.com	1111111111	\N	\N	\N	5	60 Days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
408	Alan Devasiya	 	\N	4.10 Yrs	Loremine Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alandevasiya@mail.com	1111111111	\N	\N	\N	5	Serving May 31st LWD	22	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
409	Safeer Ismail	 	\N	5.8 rs	Aitrich Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	safeerismail@mail.com	1111111111	\N	\N	\N	5	40 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
410	Vinoth N	 	\N	10.5 Yrs	Capestart	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vinothn@mail.com	1111111111	\N	\N	\N	5	90 Days	21	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
411	Sreeraj S	 	\N	3 Yrs	CGI	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreerajs@mail.com	1111111111	\N	\N	\N	5	60 Days	23	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
412	Abin Micheal	 	\N	3.5 Yrs	Dcubeai	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abinmicheal@mail.com	1111111111	\N	\N	\N	5	Serving June 7th LWD	2	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
413	Jisi Rajan	 	\N	5.8 rs	Aitrich Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jisirajan@mail.com	1111111111	\N	\N	\N	5	40 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
414	Sangeetha AS	 	\N	6Yrs	Aspire systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sangeethaas@mail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
415	Sumeena S	 	\N	3.6 yrs	Alokin	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sumeenas@mail.com	1111111111	\N	\N	\N	5	60 days	8	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
416	Arun R	 	\N	6 Yrs	SayOne Technologies 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunr@mail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
417	Keerthi Gireesh	 	\N	6 Yrs	Poornam Infovision	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	keerthigireesh@mail.com	1111111111	\N	\N	\N	5	30 Days	13	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
418	Sreemurali U	 	\N	11 Yrs	Speridian	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreemuraliu@mail.com	1111111111	\N	\N	\N	5	60 Days	35	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
419	Reshma AR	 	\N	6Yrs	Aspire systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmaar@mail.com	1111111111	\N	\N	\N	5	90 Days	18	back-off	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
420	Deepthi	 	\N	7Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	deepthi@mail.com	1111111111	\N	\N	\N	5	60 Days	38	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
421	Aswin Prasanth	 	\N	2.5Yrs	HTIC Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswinprasanth@mail.com	1111111111	\N	\N	\N	5	60 Days	23	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
422	Akram Muhammed	 	\N	5Yrs	Coddle Tech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akrammuhammed@mail.com	1111111111	\N	\N	\N	5	60 Days	29	back-off	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
423	Sneha Aruldas	 	\N	6 Yrs	Cognizant	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	snehaaruldas@mail.com	1111111111	\N	\N	\N	5	60 Days(Neg)	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
424	Neethu Soman	 	\N	8 Yrs	Techmaven	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethusoman@mail.com	1111111111	\N	\N	\N	5	30 Days	14	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
425	Lintu Antony	 	\N	6 Yrs	Grapelime	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lintuantony@mail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
426	Ashik Bahseer	 	\N	5 Yrs	Scalgo Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ashikbahseer@mail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
427	Anoob V M	 	\N	12 Yrs	Mava Partners	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anoobvm@mail.com	1111111111	\N	\N	\N	5	60 Days	44	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
428	Arjun T V	 	\N	7.5 Yrs	Turbolab	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arjuntv@mail.com	1111111111	\N	\N	\N	5	30 Days	44	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
429	Athulya K	 	\N	7 Yrs	ZERONE CONSULTING	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athulyak@mail.com	1111111111	\N	\N	\N	5	60 Days	14	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
430	Athira J	 	\N	4 Yrs	MicroObjects	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athiraj@mail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
431	Akhila S	 	\N	6Yrs	Aspire systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhilas@mail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
432	Vinitha	 	\N	2.5Yrs	HTIC Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vinitha@mail.com	1111111111	\N	\N	\N	5	60 Days	23	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
433	Shiyas M	 	\N	5Yrs	Coddle Tech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shiyasm@mail.com	1111111111	\N	\N	\N	5	60 Days	8	back-off	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
434	Neetha Mohan	 	\N	4.5Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethamohan@mail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
435	Vasanth	 	\N	1.8 Yrs	Zasta Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vasanth@mail.com	1111111111	\N	\N	\N	5	15 Days	19	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
436	Bibin John	 	\N	3.2 Yrs	Veuz Concepts	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bibinjohn@mail.com	1111111111	\N	\N	\N	5	90 Days	23	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
437	Krishna Priya	 	\N	5 Yrs	RM Education	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	krishnapriya@mail.com	1111111111	\N	\N	\N	5	90 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
438	Tijo Joseph	 	\N	6Yrs	Aspire systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	tijojoseph@mail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
439	Vineetha Saju	 	\N	7Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vineethasaju@mail.com	1111111111	\N	\N	\N	5	LWD June 5th	24	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
440	Rahul J	 	\N	4Yrs	Mariapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahulj@mail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
441	Rajeesh R	 	\N	5Yrs	Coddle Tech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rajeeshr@mail.com	1111111111	\N	\N	\N	5	60 Days	8	back-off	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
442	Arif Khan	 	\N	7 Yrs	Sparksupport	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arifkhan@mail.com	1111111111	\N	\N	\N	5	90 Days	28	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
443	Sachin	 	\N	3.2 Yrs	Practice Suite	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sachin@mail.com	1111111111	\N	\N	\N	5	90 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
444	Jithin KM	 	\N	5 Yrs	Letmedoit	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jithinkm@mail.com	1111111111	\N	\N	\N	5	90 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
445	Dinny Elsa	 	\N	6 Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dinnyelsa@mail.com	1111111111	\N	\N	\N	5	60 Days	8	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
446	Dwithgeeth	 	\N	7Yrs	Newagesys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dwithgeeth@mail.com	1111111111	\N	\N	\N	5	60 days	22	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
447	Frebin	 	\N	5.3Yrs	Nuvento	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	frebin@mail.com	1111111111	\N	\N	\N	5	30 Days	29	back-off	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
448	Jasmal	 	\N	4.8Yrs	Metric Tree	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jasmal@mail.com	1111111111	\N	\N	\N	5	30 Days	24	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
449	Arunima	 	\N	3.5Yrs	Cybrosis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunima@mail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
450	Rekha S	 	\N	3.5Yrs	Socius	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rekhas@mail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
451	Allen James	 	\N	4 Yrs	Alokin	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	allenjames@mail.com	1111111111	\N	\N	\N	5	Serving NP Lwd june 28th	8	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
452	Akhil Raj	 	\N	3.6 Yrs	DataKlout AI Solutions Pvt. Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhilraj@mail.com	1111111111	\N	\N	\N	5	Sering NP Lwd June 15th	2	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
453	Aswathy A Naik	 	\N	5 Yrs	CUBET TECHNO LABS PVT. LTD.	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswathyanaik@mail.com	1111111111	\N	\N	\N	5	30 Days	2	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
454	Sibin Xavier	 	\N	6 Yrs	Aspire Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sibinxavier@mail.com	1111111111	\N	\N	\N	5	Immediate	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
455	Vrinda Das	 	\N	5 Yrs	Cognizant	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vrindadas@mail.com	1111111111	\N	\N	\N	5	60 days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
456	Jayagovind. E  	 	\N	6.8 Yrs	Reﬂections Info Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jayagovinde@mail.com	1111111111	\N	\N	\N	5	60 days	37	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
457	Nikhil M U	 	\N	5.6 Yrs	ExcelSoft Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nikhilmu@mail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
458	Habeeb Rahman	 	\N	7 Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	habeebrahman@mail.com	1111111111	\N	\N	\N	5	60 Days	42	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
459	Baiju Sivadasan	 	\N	4.6Yrs	Speechlogix	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	baijusivadasan@mail.com	1111111111	\N	\N	\N	5	30 Days	22	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
460	Muhammed Nabas	 	\N	5Yrs	Zellis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammednabas@mail.com	1111111111	\N	\N	\N	5	60 Days	24	rejected	\N	\N	Kozhikode	\N	\N	Cochin	\N	\N	\N
461	Shahulul Faris	 	\N	4.9Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shahululfaris@mail.com	1111111111	\N	\N	\N	5	60 Days	22	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
462	keerthana	 	\N	4.6Yrs	Speechlogix	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	keerthana@mail.com	1111111111	\N	\N	\N	5	30 Days	22	back-off	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
463	Nithin Bhadran	 	\N	3.5Yrs	Socius	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nithinbhadran@mail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
464	Meenu S	 	\N	4.9Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	meenus@mail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
465	Anju Jose	 	\N	6 Yrs	Mantle Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjujose@mail.com	1111111111	\N	\N	\N	5	60 days	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
466	Rajeesha Raveendran	 	\N	4.2 yrs	Tegain	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rajeesharaveendran@mail.com	1111111111	\N	\N	\N	5	60 days	25	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
467	Selvakumar V	 	\N	13 Yrs	UVJ Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	selvakumarv@mail.com	1111111111	\N	\N	\N	5	30 Days	38	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
468	Athish P	 	\N	5 yrs	Orion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athishp@mail.com	1111111111	\N	\N	\N	5	60 days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
469	Lenin Francis	 	\N	10 Yrs	Soft Reflex 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	leninfrancis@mail.com	1111111111	\N	\N	\N	5	Serving(LWD-15th June)	21	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
470	Bipin John	 	\N	3.2 Yrs	Veuz Concepts	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bipinjohn@mail.com	1111111111	\N	\N	\N	5	90 Days	23	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
471	Archana	 	\N	4 Yrs	Spartsupport	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	archana@mail.com	1111111111	\N	\N	\N	5	60 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
472	Akhil	 	\N	5 Yrs	Xpetise	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhil@mail.com	1111111111	\N	\N	\N	5	30 Days	2	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
473	Jinto Varghese	 	\N	7 Yrs	Bourntec	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jintovarghese@mail.com	1111111111	\N	\N	\N	5	60 Days	38	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
474	Allen James	 	\N	4 Yrs	Alokin	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	allen.jamesvaranam@gmail.com	1111111111	\N	\N	\N	5	Serving NP Lwd june 28th	8	inprogress	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
475	Rudrash	 	\N	4 Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	acrudresh967@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
476	Alan Devasiya	 	\N	4.10 Yrs	Loremine Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alandev123@gmail.com	1111111111	\N	\N	\N	5	Serving May 31st LWD	22	inprogress	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
477	Abdull Lathif	 	\N	4.6Yrs	Orion innovation	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abdullikes@gmail.com	1111111111	\N	\N	\N	5	30 Days	22	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
478	Ajimsha	 	\N	5.9Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajimsha.ipsr@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
479	Abhinand	 	\N	5Yrs	Mariapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abi007in@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	back-off	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
480	Sreekanth KS	 	\N	4.6Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreekanthsr@gmail.com	1111111111	\N	\N	\N	5	30 Days	22	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
481	Jayamohan	 	\N	18Yrs	Onetrust	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jayamohan.mp@gmail.com	1111111111	\N	\N	\N	5	Immediately	32	back-off	\N	\N	Wayannad	\N	\N	Cochin	\N	\N	\N
482	Amritha Prasad	 	\N	12 Yrs	Infosys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rohinprasad@gmail.com	1111111111	\N	\N	\N	5	Immediate	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
483	Sharooq N E	 	\N	3 Yrs	ThoughtBox	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sharooqne786@gmail.com	1111111111	\N	\N	\N	5	60 days	8	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
484	Gopika G S	 	\N	2 Yrs	Sniqsys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	1998gopikagokulan@gmail.com	1111111111	\N	\N	\N	5	30 Days	13	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
485	Jala Stin	 	\N	4 Yrs	Centre Source	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjuyohannan16@gmail.com	1111111111	\N	\N	\N	5	Immediate	13	back-off	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
486	Sajila S	 	\N	4 Yrs	TRANQUILITY IOT	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sajilas17@gmail.com 	1111111111	\N	\N	\N	5	Immediate	22	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
487	Karthik B S	 	\N	5 Yrs	Xminds	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	karthikbs.career@gmail.com	1111111111	\N	\N	\N	5	30 Days	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
488	Shinu Shareef	 	\N	3 Yrs	Alokin	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shinushareef777@gmail.com	1111111111	\N	\N	\N	5	30 Days	8	rejected	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
489	Akhil Raj	 	\N	3.6 Yrs	DataKlout AI Solutions Pvt. Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhilraj7000@gmail.com	1111111111	\N	\N	\N	5	Sering NP Lwd June 15th	2	rejected	\N	\N	Wayanad	\N	\N	Cochin	\N	\N	\N
490	Sajishna	 	\N	3.5 Yrs	Opentrends	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sajishnakvinod@gmail.com	1111111111	\N	\N	\N	5	90 Days	25	inprogress	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
491	Vishnu V K	 	\N	3 Yrs	JTSI	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnuvk80866@gmail.com	1111111111	\N	\N	\N	5	90 Days	19	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
492	Joseph Deen	 	\N	3.2 Yrs	Focaloid	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	josephdeenp.f@gmail.com	1111111111	\N	\N	\N	5	60 Days	28	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
493	Sarath	 	\N	5 Yrs	Information Kerala Mission	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sarathsasankan93@gmail.com	1111111111	\N	\N	\N	5	45 Days	21	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
494	Steffi	 	\N	3 Yrs	WebSignX Technologies | Nagercoil, India	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	steffi25.dev@gmail.com	1111111111	\N	\N	\N	5	Immediate	13	rejected	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
495	Bipin John	 	\N	3.2 Yrs	Veuz Concepts	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bbnjonp@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
496	Anand T	 	\N	7Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anandprince100@gmail.com	1111111111	\N	\N	\N	5	Immediate	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
497	Kiran PS	 	\N	11Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kiranps007@gmail.com	1111111111	\N	\N	\N	5	90 Days	38	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
498	Victor	 	\N	4Yrs	Zayone	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	victorvarghese@hotmail.com	1111111111	\N	\N	\N	5	90 Days	25	back-off	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
499	Anoop Anil	 	\N	9+Yrs	Bten	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anoopsvanil@gmail.com	1111111111	\N	\N	\N	5	15 Days	29	back-off	\N	\N	Pathanamthitta	\N	\N	Cochin	\N	\N	\N
500	 Keerthana N C 	 	\N	5 Yrs	  DAIVIKSOFT	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	Keerthanahasan232@gmail.com	1111111111	\N	\N	\N	5	30 Days	6	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
501	RESHMA M	 	\N	3 Yrs	Wetzel Barron Infosystem	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmarehna16@gmail.com	1111111111	\N	\N	\N	5	30 Days	6	rejected	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
502	Steve Chirakkekkaran	 	\N	2.5 Yrs	MACOM	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	stevechirakkekkaran@gmail.com	1111111111	\N	\N	\N	5	Immediate	18	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
503	Athul M	 	\N	4.10 Yrs	Pumex InfoTech 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athul4040@gmail.com	1111111111	\N	\N	\N	5	30 Days	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
504	Mishal P K	 	\N	3 Yrs	Utah Tech Labs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mishalpk02@gmail.com	1111111111	\N	\N	\N	5	Immediate	22	inprogress	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
505	Shalabha Mary	 	\N	7 Yrs	Sparksupport	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shalabhasunny@gmail.com	1111111111	\N	\N	\N	5	60 Days	28	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
506	Enza Varghese	 	\N	6 Yrs	Camarine	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	enzavarghese@gmail.com	1111111111	\N	\N	\N	5	Immediate	21	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
507	Vineesh V	 	\N	3.2 Yrs	Admarine	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vineeshv916@gmail.com	1111111111	\N	\N	\N	5	Immediate	21	inprogress	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
508	Aswathy A Naik	 	\N	5 Yrs	CUBET TECHNO LABS PVT. LTD.	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswathya2012@gmail.com	1111111111	\N	\N	\N	5	30 Days	2	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
509	Aswathu Venu	 	\N	10Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswathy.venu022@gmail.com	1111111111	\N	\N	\N	5	60 Days	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
510	Serin Mariam	 	\N	4Yrs	Zayone	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jishnuvnair711@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
511	KeerthanaS	 	\N	5Yrs	Orion Innovations	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	keerthanasv@gmail.com	1111111111	\N	\N	\N	5	90 Days	28	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
512	Sunil Chakravarthi K	 	\N	8 Yrs	LetMeDoIt	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sunildhony@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
513	Sreeram K	 	\N	3 Yrs	 Infolks	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	 sreeramk12@gmail.com	1111111111	\N	\N	\N	5	15 Days	6	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
514	Sujith B Narayanan	 	\N	3.6 Yrs	FAIRCODE TECHNOLOGIES	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sajith.narayanan97@gmail.com	1111111111	\N	\N	\N	5	Immediate	25	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
515	Basil Babu	 	\N	3 Yrs	Wetzel Barron Infosystem	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	basil7here@gmail.com	1111111111	\N	\N	\N	5	30 Days	8	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
516	Habeeb Rahman	 	\N	7 Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	habeebrahmanptnkt@gmail.com	1111111111	\N	\N	\N	5	60 Days	42	inprogress	\N	\N	Malappuram	\N	\N	Cochin	\N	\N	\N
517	Jerin	 	\N	2.4 Yrs	SparkSupport	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jeringjohnson@gmail.com	1111111111	\N	\N	\N	5	45 Days	23	rejected	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
518	Jothis Babu	 	\N	6 Yrs	Camorin	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jothishwp8@outlook.com	1111111111	\N	\N	\N	5	60 Days	8	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
519	Akbar EK	 	\N	4 Yrs	Fingent	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akbar72987@gmail.com	1111111111	\N	\N	\N	5	60 Days	8	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
520	Nicy Jose 	 	\N	5.3 Yrs	Teknowmics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nicyjose12@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
521	Reshma Venugopal	 	\N	5.11 Yrs	Teknowmics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshumanu15@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
522	Navaneeth Sreekumar	 	\N	3.6 Yrs	Assuretech Business Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	navneeth.1997@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
523	Jinto Antony	 	\N	2.4 Yrs	Pragmatic Techsoft	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jintoantony95@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
524	Sreelekshmi M V	 	\N	8 Yrs	Allianz	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mv.sreelekshmi56@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-15th July)	35	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
525	Anju Jose	 	\N	6 Yrs	Mantle Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjujose995@gmail.com	1111111111	\N	\N	\N	5	60 days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
526	Sruthi Jayaraj	 	\N	10Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sruthijayaraj91@gmail.com	1111111111	\N	\N	\N	5	60 Days	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
527	Dolsy Santy	 	\N	8Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dolsysanty@gmail.com	1111111111	\N	\N	\N	5	60 Days	38	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
528	Shafana S	 	\N	4.11Yrs	Dev Information	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shafa.asharaf@gmail.com	1111111111	\N	\N	\N	5	60 Days 45 	24	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
529	Eveena Rose	 	\N	1.4 Yrs	Contract IO India	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	eveenarose251095@gmail.com	1111111111	\N	\N	\N	5	90 Days	2	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
530	Anand Ayyappan	 	\N	4.2 Yrs	EY	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anandayyappan007@gmail.com	1111111111	\N	\N	\N	5	Serving LWD Aug 2nd	20	inprogress	\N	\N	Sivakasi	\N	\N	Trivandrum	\N	\N	\N
531	Feba S Zakharia	 	\N	9 Yrs	Thinkpalm	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	febazachariahnew@gmail.com	1111111111	\N	\N	\N	5	Immediate	11	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
532	Vigneswaran R	 	\N	7.8 Yrs	Travancore Analytics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rvigneshwaranr9390@gmail.com	1111111111	\N	\N	\N	5	60 Days	11	rejected	\N	\N	Marthandam	\N	\N	Trivandrum	\N	\N	\N
533	Rithu Venu	 	\N	5.8Yrs	In APP	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rithu2493@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
534	Nirmal Abraham	 	\N	6.6Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nirmalabraham93@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
535	Sujith S Babu	 	\N	4.11Yrs	Dev Information	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	chnuvlsn@gmail.com	1111111111	\N	\N	\N	5	60 Days 45 	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
536	Aravind Anil	 	\N	5.5Yrs	Valoriz Digital	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aravindanil000@gmail.com	1111111111	\N	\N	\N	5	LWD June 28th	2	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
537	Ambiha Harikrishnan	 	\N	8 Yrs	Siam Computing 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ambihah1994@gmail.com	1111111111	\N	\N	\N	5	30 Days	11	rejected	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
538	Joel Johny	 	\N	8 Yrs	Valoriz Digital 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mejoeljohny12@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-28th June)	11	back-off	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
539	Aravind Jayakumar 	 	\N	10 Yrs	Azentio Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aravindmdkm@gmail.com	1111111111	\N	\N	\N	5	90 Days	11	rejected	\N	\N	Kottayam	\N	\N	Trivandrum	\N	\N	\N
540	Shyamili V	 	\N	10.6 Yrs	WOLFDALE SOFTWARE	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shyamilivgupta@gmail.com	1111111111	\N	\N	\N	5	Immediate	28	inprogress	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
541	Nihal K P	 	\N	3.2 Yrs	TNM Online Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nihal44.kp@gmail.com	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Kannur	\N	\N	Trivandrum	\N	\N	\N
542	Shiju V	 	\N	2.1 Yrs	GLOBAL ALLIES TECHNOLOGIES	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shijuv18@gmail.com	1111111111	\N	\N	\N	5	Immediate	2	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
543	Navin N	 	\N	2.8 rs	Objectways Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	navin.datascientist@gmail.com	1111111111	\N	\N	\N	5	Immediate	2	rejected	\N	\N	Karur	\N	\N	Cochin	\N	\N	\N
544	Anusree Mohan	 	\N	12 Yrs	Expressare Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anusree.mohan@gmail.com	1111111111	\N	\N	\N	5	60 Days	43	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
545	Jeslinmon V T	 	\N	5.5 Yrs	Trenser Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mynameisjeslin@protonmail.com	1111111111	\N	\N	\N	5	Serving Lwd June 14	29	rejected	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
546	Sajith K	 	\N	9 Yrs	RM Education	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sajithck26@gmail.com	1111111111	\N	\N	\N	5	Serving LWD July 26th	11	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
547	Siya Elsa Sabu	 	\N	4 Yrs	Sayone Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	siyaelsa13@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	inprogress	\N	\N	Pathanamthitta	\N	\N	Cochin	\N	\N	\N
548	Swathy	 	\N	12 Yrs	Ihits Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	swat.uce@gmail.com	1111111111	\N	\N	\N	5	Immediate	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
549	AJINSHAD.C	 	\N	3 Yrs	Isportz	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajinshadwdr@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	inprogress	\N	\N	Malappuram	\N	\N	Cochin	\N	\N	\N
550	Hiba Fathima	 	\N	9 Yrs	Allianz	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	hibafathima19@gmail.com	1111111111	\N	\N	\N	5	60 Days	11	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
551	JOHN POOKOTTU	 	\N	3 Yrs	PITS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	johnpookottu98@gmail.com	1111111111	\N	\N	\N	5	60 Days	23	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
552	Jins Mathew	 	\N	7.6Yrs	Qburst	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jinsmathew1414@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
553	Aleena Augustine	 	\N	7.4Yrs	Zemoso	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aleena.au@gmail.com	1111111111	\N	\N	\N	5	60 Days	38	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
554	Muhammed Faris	 	\N	4.7Yrs	Harbinger	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammedfariskh@gmail.com	1111111111	\N	\N	\N	5	60 Days	22	back-off	\N	\N	Wayanad	\N	\N	Cochin	\N	\N	\N
555	Vaishnav S babu	 	\N	2.6Yrs	HTIC Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vaishnavsb96@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
556	Hanoy S	 	\N	4 Yrs	Beo Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	hanoyn007@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
557	Muhammed Ali	 	\N	4.8 Yrs	Pragmatic Techsoft Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammedalimvr@gmail.com	1111111111	\N	\N	\N	5	60 Days	23	inprogress	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
558	Athira K R	 	\N	5 Yrs	Seeroo IT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athirakr325@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
559	Dhanesh S	 	\N	9.5 Yrs	Panasa Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dhaneshsk007@gmail.com	1111111111	\N	\N	\N	5	Immediate	11	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
560	Sujitha N P	 	\N	2.5 Yrs	NeoITO	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sujithakrishna666@gmail.com	1111111111	\N	\N	\N	5	30 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
561	Sajeena L	 	\N	3 Yrs	CapeStart	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sajeenaleon86@gmail.com	1111111111	\N	\N	\N	5	30 Days	21	inprogress	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
562	Vishnu S	 	\N	3.2 yrs	Millennium Pay	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishh1997@gmail.com	1111111111	\N	\N	\N	5	Immediate	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
563	Abhilash	 	\N	4Yrs	Pit Solution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	j.abhilash374@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
564	Muhammed Rafi	 	\N	7Yrs	Fakeeh Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mohammedrafi442@gmail.com	1111111111	\N	\N	\N	5	90 days	18	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
565	Pournami Gopinath	 	\N	8Yrs	HTC Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	swarnampournami12@gmail.com	1111111111	\N	\N	\N	5	LWD June 28	21	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
566	Sreejith	 	\N	4.8Yrs	Pinacle software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreejithh2005@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
567	Albin Vj	 	\N	4.5yrs	Bounteous	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	albinvjalthara@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Kanyakumari	\N	\N	Cochin	\N	\N	\N
568	Shameer Muhammed	 	\N	4Yrs	Cybrosys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bilalmohammed506@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
569	Godlin Lijo	 	\N	3.6 Yrs	Core Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	godlinlijo27@gmail.com	1111111111	\N	\N	\N	5	30 Days	18	rejected	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
570	Shilpa Davis	 	\N	7.5 Yrs	Microobjects	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	silpadavis08@gmail.com	1111111111	\N	\N	\N	5	60 Days	8	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
571	Shahinsha Ummar	 	\N	4 Yrs	Pragmatic Techsoft	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shahinshahummer@gmail.com	1111111111	\N	\N	\N	5	Immediate	23	back-off	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
572	krishna U	 	\N	9.9 Yrs	Caxita Tech Solutions,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	krishnau93@gmail.com	1111111111	\N	\N	\N	5	60 Days	11	inprogress	\N	\N	Alappuzha 	\N	\N	Cochin	\N	\N	\N
573	Sreela	 	\N	7 Yrs	CMS Computres	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	l.sreela2014@gmail.com	1111111111	\N	\N	\N	5	Immediate	21	rejected	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
574	Sreelekshmi Raj	 	\N	4Yrs	Pit Solution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreelekshmi.raj.se@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
575	Vidhya Sadasivan	 	\N	8Yrs	HTC Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vidhya.kr4@gmail.com	1111111111	\N	\N	\N	5	LWD June 28	21	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
576	Jenish	 	\N	4.5yrs	Bounteous	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	joyjen777@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Kanyakumari	\N	\N	Cochin	\N	\N	\N
577	Sreeshma S	 	\N	4Yrs	Cybrosys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreeshmasr@gmail.com	1111111111	\N	\N	\N	5	30 Days	24	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
578	Shajeeb Basheer	 	\N	10 Yrs	Synonix	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shajeeb327@gmail.com	1111111111	\N	\N	\N	5	60 Days	11	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
579	Sajan S	 	\N	15 Yrs	Tricta Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	isajan.s@gmail.com 	1111111111	\N	\N	\N	5	Immediate	11	rejected	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
580	Nayana.A.S	 	\N	13 Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nayana4me@gmail.com	1111111111	\N	\N	\N	5	60 Days	32	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
581	Sujith Lal K C	 	\N	12 Yrs	Bourntec	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sujithlalkc@gmail.com	1111111111	\N	\N	\N	5	60 Days	32	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
582	Prajith Chandrasekharan	 	\N	5 Yrs	ECS Business Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	prajithcsmenon1012@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-4th Sep)	21	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
583	Sukanya A	 	\N	3 Yrs	Chillar Payment solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sukanya.a508@gmail.com	1111111111	\N	\N	\N	5	Immediate	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
584	Rajasekhar Rajagopal	 	\N	16  Yrs	ARS T & T Technology 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rajasekhar.rr@gmail.com	1111111111	\N	\N	\N	5	Immediate	3	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
585	Arnol P S	 	\N	4.2 Yrs	CDIPD-Digital University Kerala Thiruvananthapuram	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arnolps172@gmail.com	1111111111	\N	\N	\N	5	Serving Lwd June 21st	2	inprogress	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
586	Mohammed Harshad	 	\N	3 Yrs	ExcelSoft Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	harshadbs555@gmail.com	1111111111	\N	\N	\N	5	45 Days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
587	Ponnu Devassy kutty	 	\N	4Yrs	Pit Solution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ponnudevassykutty@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
588	Arun Rajan	 	\N	12Yrs	Fingent Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunrajan49@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
589	Rajesh sasidharan	 	\N	8Yrs	HTC Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rajeshsasisrv3@gmail.com	1111111111	\N	\N	\N	5	LWD June 28	28	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
590	Sahaya Bibin	 	\N	4.8Yrs	Pinacle software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bibinmsr@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
591	Rahul Jeevan	 	\N	4.5yrs	Bounteous	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahulje9@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	inprogress	\N	\N	Kanyakumari	\N	\N	Cochin	\N	\N	\N
592	Anjana Mohan	 	\N	4Yrs	Cybrosys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	Chinchu Mathew	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
593	Nisha K V	 	\N	16 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nishakv@gmail.com	1111111111	\N	\N	\N	5	30 Days	32	inprogress	\N	\N	Kannur	\N	\N	Remote	\N	\N	\N
594	Monish K	 	\N	7.5 Yrs	Neoito	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	monishkodambattil@gmail.com	1111111111	\N	\N	\N	5	90 Days ( neg 30 Days)	31	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
595	Anish J	 	\N	10 Yrs	Neoito	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anishjdhas@gmail.com	1111111111	\N	\N	\N	5	Serving Lwd June 28th	43	rejected	\N	\N	Kanyakumari	\N	\N	Cochin	\N	\N	\N
596	Abhijith	 	\N	4 Yrs	Neoito	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abhijithyess@gmail.com	1111111111	\N	\N	\N	5	June 30th Lwd	2	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
597	Anson	 	\N	3.5 YRS	Neoito	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	davidanson0721@gmail.com	1111111111	\N	\N	\N	5	Immediate	11	rejected	\N	\N	Tirunelveli	\N	\N	Trivandrum	\N	\N	\N
598	Adithyan K P	 	\N	3 Yrs	NeoITO	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	adithyan.k.p777@gmail.com 	1111111111	\N	\N	\N	5	60 Days	29	rejected	\N	\N	Kasargod	\N	\N	Cochin	\N	\N	\N
599	Muhammad T S	 	\N	5 Yrs	NeoITO	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muhammadthahir6@gmail.com	1111111111	\N	\N	\N	5	60 Days	28	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
600	Sreya K	 	\N	2 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ksreya2000@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
601	Bini J	 	\N	12.6  Yrs	Servion Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	binijan@gmail.com	1111111111	\N	\N	\N	5	Immediate	26	inprogress	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
602	Saravanan M	 	\N	10 Yrs	Sumeru Software Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	msaravanan267@gmail.com	1111111111	\N	\N	\N	5	Immediate	26	inprogress	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
603	Aashitha Jaji	 	\N	4Yrs	Pit Solution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aashithajaiji96@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
604	Mujeeb Rahman	 	\N	4Yrs	HTC Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mujeeb.6727@gmail.com	1111111111	\N	\N	\N	5	LWD June 28	22	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
605	Sony MS	 	\N	17Yrs	Ospyn Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sonyms@gmail.com	1111111111	\N	\N	\N	5	90 Days	32	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
606	Rosmi Thomas	 	\N	4Yrs	Cybrosys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rosmithomas212@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
607	Midhun M	 	\N	3.4Yrs	Neoito	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	midhunem42@gmail.com	1111111111	\N	\N	\N	5	30 Days	22	inprogress	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
608	Krishnaprasad R	 	\N	2 Yrs	NeoITO	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rkprasad.info@gmail.com	1111111111	\N	\N	\N	5	60 Days	24	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
609	Arjun Sasi	 	\N	3 Yrs	NeoITO	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arjunsasi301@gmail.com	1111111111	\N	\N	\N	5	Immediate	29	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
610	Gilesh George	 	\N	19.8 Yrs	TCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ggileshgeorge@gmail.com	1111111111	\N	\N	\N	5	90 Days	32	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
611	Surej Kulangara Abraham	 	\N	4 yrs	Neoito	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	surej12abraham@gmail.com	1111111111	\N	\N	\N	5	30 days	2	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
612	Ajay OP	 	\N	6 Yrs	Design Direct	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajayrajop8_y2h@indeedemail.com	1111111111	\N	\N	\N	5	60 Days	25	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
613	Srelekshmi	 	\N	4.8 Yr	Neoito	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	srilakshmi.sivan2091@gmail.com	1111111111	\N	\N	\N	5	30 Days	33	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
614	Jalin Mani	 	\N	8.9 Yrs	Flytxt	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jalinmh@gmail.com	1111111111	\N	\N	\N	5	60 Days	11	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
615	Sindhukumar Rajakumaran	 	\N	16.3 Yrs	Capestart	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	macroend@gmail.com	1111111111	\N	\N	\N	5	90 Days	32	rejected	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
616	Hari G S	 	\N	16 Yrs	Innapp	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	meetgshari@gmail.com	1111111111	\N	\N	\N	5	Serving Lwd Aug 13th	32	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
617	D S Gowri Sankar	 	\N	4 Yrs	NeoITO	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gwrisnkr17@gmail.com	1111111111	\N	\N	\N	5	30 Days	29	inprogress	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
618	Harsha Mol A S	 	\N	5 Yrs	Atheer Global Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	harshareju@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Oman	\N	\N	Cochin	\N	\N	\N
619	Selvakumar V	 	\N	14 Yrs	UVJ Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	selvakumarbtech@gmail.com	1111111111	\N	\N	\N	5	60 Days	32	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
620	Ajish Mathew	 	\N	13Yrs	Quest	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajishmathew@gmail.com	1111111111	\N	\N	\N	5	60 Days	38	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
621	Veernandan	 	\N	4Yrs	Pit Solution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vjveeranandhan@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
622	Abees 	 	\N	16Yrs	Ciklum	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abees.pm@gmail.com	1111111111	\N	\N	\N	5	60 Days Nego 15	21	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
623	Gibi Chandra	 	\N	8.3Yrs	SE Mentor	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gchandranb@gmail.com	1111111111	\N	\N	\N	5	Immediate	11	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
624	Aby philip	 	\N	1.7Yrs	Codelayer	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aby071997@gmail.com	1111111111	\N	\N	\N	5	15-30 Days	23	rejected	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
625	Dinesh Babu V	 	\N	9 Yrs	Happiest Minds	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dineshsivagangai@gmail.com	1111111111	\N	\N	\N	5	30 Days	26	inprogress	\N	\N	Madurai	\N	\N	Remote	\N	\N	\N
626	Nirmala A B	 	\N	13 Yrs	 HeyMath	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nirmala.official19@gmail.com	1111111111	\N	\N	\N	5	Immediate	26	inprogress	\N	\N	Chennai	\N	\N	Remote	\N	\N	\N
627	Lakshmi N Menon	 	\N	7 Yrs	StratAgile	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	 vish.lakshmi@gmail.com	1111111111	\N	\N	\N	5	Immediate	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
628	Nayana Pradeep	 	\N	7.11Yrs	Protean Gov	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nayanapradeep92@gmail.com	1111111111	\N	\N	\N	5	60 Days	2	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
629	Prakash Jayaraman	 	\N	5.7 Yrs	Raster Images	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	prakashjayaraman@gmail.com	1111111111	\N	\N	\N	5	30 Days	32	inprogress	\N	\N	Erode	\N	\N	Cochin	\N	\N	\N
630	Ram Sujin R S	 	\N	4.3 Yrs	PITS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rssujin123@gmail.com	1111111111	\N	\N	\N	5	90 Days(Neg)	11	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
631	Lijomon Jose	 	\N	17 Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lijomonjose@yahoo.co.in	1111111111	\N	\N	\N	5	Immediate	32	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
632	Anoop Vijay	 	\N	6Yrs	Aspire Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	savanoop@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
633	Reshma Jose	 	\N	7Yrs	IBS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmajose94@gmail.com	1111111111	\N	\N	\N	5	60 Days	38	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
634	Sandeep Ravindranath	 	\N	18 Yrs	Inspired Software Development (India) LLP	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	poduvalsr@gmail.com	1111111111	\N	\N	\N	5	90 Days	32	back-off	\N	\N	Cochin/Hybrid	\N	\N	Cochin	\N	\N	\N
635	Aswin Raj	 	\N	4.8Yrs	Appsure	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswinrajs123@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
636	Varun Rajeev	 	\N	10Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mr.varunrajeevan@gmail.com	1111111111	\N	\N	\N	5	90 days 45days	11	inprogress	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
637	Ajmal Khan	 	\N	9Yrs	Pit Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bsajmalkhan@gmail.com	1111111111	\N	\N	\N	5	LWD 26 Jully	11	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
638	Regil T	 	\N	7.5Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	regiltrgl@gmail.com	1111111111	\N	\N	\N	5	90 Days	2	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
639	Liyamol Jacob	 	\N	6 Yrs	Zaeem Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	liyamol06@gmail.com	1111111111	\N	\N	\N	5	Serving Lwd June 28th	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
640	Vineetha Vijayakumar	 	\N	10 Yrs	RCKR	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vineethavijayakumar18@gmail.com	1111111111	\N	\N	\N	5	30 Days (Negotiable)	11	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
641	Vishnu Priya	 	\N	12 Yrs	Spritile Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	visnupriya.be@gmail.com	1111111111	\N	\N	\N	5	60 Days	26	inprogress	\N	\N	Chennai	\N	\N	Remote	\N	\N	\N
642	Gigi Susan Varghese	 	\N	12 Yrs	CORRA	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gigisusanvarghese@gmail.com	1111111111	\N	\N	\N	5	30 Days	11	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
643	Priyadarsini Subramaniam	 	\N	12 Yrs	 Redfox Global 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	priyajsn15@gmail.com	1111111111	\N	\N	\N	5	30 Days	26	inprogress	\N	\N	Chennai	\N	\N	Remote	\N	\N	\N
644	Ram Kumar	 	\N	7 Yrs	ECESIS Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	samrajakumarmdr@gmail.com	1111111111	\N	\N	\N	5	30 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
645	Jithin Raghavan	 	\N	16 Yrs	Acentra Health	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jiraghavan@gmail.com	1111111111	\N	\N	\N	5	90 Days	32	inprogress	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
646	Athira Vinod	 	\N	5.6 Yrs	2Base Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athiravinod1911@gmail.com	1111111111	\N	\N	\N	5	Serving Lwd July 31st	4	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
647	Aiswarya	 	\N	5.8 Yrs	C-Square Info Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aiswaryaplus@gmail.com	1111111111	\N	\N	\N	5	Serving Lwd July 29th	30	inprogress	\N	\N	Malappuram	\N	\N	Cochin	\N	\N	\N
648	Vaisakh P V	 	\N	4.6 Yrs	Tactus Ventures pvt.Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vaisakhpviju5@gmail.com	1111111111	\N	\N	\N	5	Immediate	30	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
649	Nithin K P	 	\N	9 Yrs	Bourntec Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nithin771@yahoo.com	1111111111	\N	\N	\N	5	Immediate	11	rejected	\N	\N	Thrissur	\N	\N	Trivandrum	\N	\N	\N
650	Ashis S	 	\N	6 Yrs	Mariapps Marine solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ashish1993.nandu@gmail.com	1111111111	\N	\N	\N	5	90 Days	4	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
651	Faris Salim	 	\N	12 Yrs	Meisterverse 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mfarissalim@gmail.com	1111111111	\N	\N	\N	5	60 Days	3	rejected	\N	\N	Trivandrum	\N	\N	Cochin	\N	\N	\N
652	Nibisha C	 	\N	5.2 Yrs	Orison 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	.nibisha@gmail.com	1111111111	\N	\N	\N	5	30 Days	18	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
653	Parvathi Nair	 	\N	4.10Yrs	CTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	parvathi1771997@gmail.com	1111111111	\N	\N	\N	5	TBS	4	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
654	Ebin Joseph	 	\N	3 Yrs	Pennon Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ebinjoseph.js@gmail.com	1111111111	\N	\N	\N	5	60 days	29	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
655	Aswini Ashok	 	\N	7 Yrs	Bridge Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswiniashok06@gmail.com	1111111111	\N	\N	\N	5	30 days	30	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
656	Radha R Krishnana	 	\N	14.4 Yrs	Wipro	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mail.radharkrishnan@gmail.com	1111111111	\N	\N	\N	5	90 Days	3	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
657	Devan Dileep	 	\N	11Yrs	Techgentia	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	devandileepkumar91@gmail.com	1111111111	\N	\N	\N	5	TBS	3	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
658	Ann S	 	\N	3Yrs	TCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ann.vettoor@gmail.com	1111111111	\N	\N	\N	5	90 Daya	2	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
659	Ajmal Khan	 	\N	9Yrs	Pit Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bsajmalkha	1111111111	\N	\N	\N	5	LWD 26 Jully	11	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
660	Sumitha Gireesh	 	\N	14Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sumithagsh05@gmail.com	1111111111	\N	\N	\N	5	30 Days	38	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
661	Figi Geo	 	\N	16 Yrs	Aitrich Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	figigeo@gmail.com	1111111111	\N	\N	\N	5	15 Days	3	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
662	    SHIBILRAJ K K	 	\N	4.5 Yrs	 DecaSync Innovations	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	  sr4shibilraj@gmail.com	1111111111	\N	\N	\N	5	Immediate	30	rejected	\N	\N	Malappuram	\N	\N	Cochin	\N	\N	\N
663	Varsha G	 	\N	7 Yrs	Capgemini	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	varsha.g.venukumar@gmail.com	1111111111	\N	\N	\N	5	90 Days	25	inprogress	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
664	Shibila Mohan	 	\N	4.6 Yrs	Techspine Systems 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shibilamohan@gmail.com	1111111111	\N	\N	\N	5	Immediate	28	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
665	Hani Issac Mathew	 	\N	7 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	hani7016@gmail.com	1111111111	\N	\N	\N	5	30 Days	28	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
666	DHARMADURAI. P	 	\N	5.5 Yrs	Asir Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dharmaissava@gmail.com	1111111111	\N	\N	\N	5	30 Days	21	inprogress	\N	\N	Tirunelveli	\N	\N	Trivandrum	\N	\N	\N
667	Sreekumar Chathambil	 	\N	20 Yrs	Inspired India 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	schathambil@gmail.com	1111111111	\N	\N	\N	5	30 Days	32	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
668	Nandakumar	 	\N	5Yrs	Mariapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nandakumar.ms.nkr@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
669	Vidhya CS	 	\N	14Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vidhyachiramel@gmail.com	1111111111	\N	\N	\N	5	TBS	38	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
670	Sony P J	 	\N	5 yrs	Emvigo Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sonypj555@gmail.com	1111111111	\N	\N	\N	5	90 Days	28	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
671	Haritha Mohan	 	\N	2.9 Yrs	Spericorn Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	harithamohan3@gmail.com	1111111111	\N	\N	\N	5	60 Days	24	rejected	\N	\N	Kollam	\N	\N	Cochin	\N	\N	\N
672	Revathy Ravi	 	\N	10 yrs	Leader IT Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ravirevathireva@gmail.com	1111111111	\N	\N	\N	5	60 Days	4	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
673	Tismon Varghese	 	\N	12 Yrs	Accel IT	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	tismon.varghese@gmail.com	1111111111	\N	\N	\N	5	30 days	3	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
674	Nithin B N	 	\N	8 yr	Ekatra infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nithinpattazhy@gmail.com	1111111111	\N	\N	\N	5	Serving NP Aug 20th LWD	3	inprogress	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
675	Nithu L	 	\N	1.8 Yrs	JAD Cloud Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nithunithin2000@gmail.com	1111111111	\N	\N	\N	5	15 Days	8	rejected	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
676	Resmy T D	 	\N	9.6 Yrs	Micro Objects	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	resmydayan@gmail.com	1111111111	\N	\N	\N	5	60 Days	4	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
677	Ahamad Sirajuddeen N M	 	\N	10 Yrs	Excelledia Digital Innovation	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sijjunm@hotmail.com	1111111111	\N	\N	\N	5	Immediate	3	rejected	\N	\N	Kasargod	\N	\N	Cochin	\N	\N	\N
678	Sarath Kumar S	 	\N	12 Yrs	OGES INFOTECH	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kumarssarathm@gmail.com	1111111111	\N	\N	\N	5	30 Days	3	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
679	Sajith S	 	\N	5.6 Yrs	 Cloudin Labs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sajith.96ks@gmail.com	1111111111	\N	\N	\N	5	30 Days	4	rejected	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
680	Thasni M	 	\N	10 Yrs	NeST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mm.thasni@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-30th July)	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
681	Dipin Mathew	 	\N	4.5Yrs	Aspire Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dipinmathew68@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
682	Anil R Pai	 	\N	7 Yrs	Caxita Tech Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anilpai557@gmail.com	1111111111	\N	\N	\N	5	serving Lwd - Oct 31st	4	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
683	Divya TA	 	\N	5Yrs	Simelabs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	divyaayappan370@gmail.com	1111111111	\N	\N	\N	5	60 Days	4	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
684	Karthik Vasudevan	 	\N	2.6 Yrs	IVBM	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vasudevankarthik15@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	rejected	\N	\N	Pathanamthitta	\N	\N	Cochin	\N	\N	\N
685	Muhammed Shahad	 	\N	5.6 Yrs	Techsiera Pvt. Ltd.	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shahadpv99@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	inprogress	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
686	Swapna	 	\N	4.3 Yrs	Cybrosis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	swapnanair299@gmail.com	1111111111	\N	\N	\N	5	Serving Lwd Aug 8th	23	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
687	Lakshmi	 	\N	1.10 Yrs	Muble Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lakshmipmalaya@gmail.com	1111111111	\N	\N	\N	5	Immediate	13	rejected	\N	\N	Kottayam	\N	\N	Trivandrum	\N	\N	\N
688	Reshma R Ramesh	 	\N	4 Yrs	brahmanet it solutions,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmasramesh006@gmail.com	1111111111	\N	\N	\N	5	One Week	13	rejected	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
689	Ajay M Joseph	 	\N	13.1 Yrs	Freelance	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajay2100000@yahoo.com	1111111111	\N	\N	\N	5	Immediate	3	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
690	Vidhya Sadasivan	 	\N	4 Yrs	Lean Transition Solutions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vidhyasadasivan93@gmail.com	1111111111	\N	\N	\N	5	90 Days	13	rejected	\N	\N	Alleppy	\N	\N	Trivandrum	\N	\N	\N
691	Irfana K V	 	\N	2.5 Yrs	Yarddiant weblounge	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	irfanakhalid007@gmail.com	1111111111	\N	\N	\N	5	45 Days	13	rejected	\N	\N	Malappuram	\N	\N	Trivandrum	\N	\N	\N
692	Lekshmi M S	 	\N	9 Yrs	Trenser Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mslekshmi09@gmail.com	1111111111	\N	\N	\N	5	Immediate	11	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
693	Aswathy S	 	\N	5.4 Yrs	Orion Innovation	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswathysivakumar4@gmail.com	1111111111	\N	\N	\N	5	30 Days	4	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
694	Mohammed Jeseem M	 	\N	6 Yrs	Touchcast	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mohammedjezeem786@gmail.com	1111111111	\N	\N	\N	5	30 Days	30	back-off	\N	\N	Kanyakumari	\N	\N	Trivandrum	\N	\N	\N
695	Kiran Kumar	 	\N	6Yrs	Aspire Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kirankumars129@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
696	Neenu	 	\N	3Yrs	Muthoot Microfin	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neenumurukesh@gmail.com	1111111111	\N	\N	\N	5	90 Days	30	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
697	Rahul	 	\N	3.5Yrs	Iroid Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahulkvk7559@gmail.com	1111111111	\N	\N	\N	5	Immediate	30	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
698	Mahesh Varkala	 	\N	5Yrs	SE Mentor	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	maheshv.varkala@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
699	Archana S Pillai	 	\N	10 Yrs	Speridian	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	archana8616@gmail.com	1111111111	\N	\N	\N	5	60 Days	11	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
700	Alwin Pius	 	\N	3 Yrs	Manappuram Comptech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alwinpius777@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-11th August)	30	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
701	Subathra V	 	\N	4.5Yrs	Tactus Ventures	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	subathravelu98@gmail.com	1111111111	\N	\N	\N	5	Immediate	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
702	Raj Kiran S S	 	\N	16 Yrs	Appfabs Innovations	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rajrevathy@gmail.com	1111111111	\N	\N	\N	5	15 Days	3	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
703	Anoop SS	 	\N	3.1 Yrs	Valoriz Digital	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anoopsunitha007@gmail.com	1111111111	\N	\N	\N	5	60 Days	29	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
704	Anila K das	 	\N	6Yrs	Aspire Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aniladask@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
705	Shyam Sunder Sasidharan	 	\N	13Yrs	MSG Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shyamsps83@gmail.com	1111111111	\N	\N	\N	5	60 Days	32	rejected	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
706	Prajeesh KV	 	\N	12Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kvprajeesh@gmail.com	1111111111	\N	\N	\N	5	60 Days	32	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
707	Abhinand	 	\N	3Yrs	Wef Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abhinandazok125@gmail.com	1111111111	\N	\N	\N	5	90 Days	25	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
708	Unnikrishnan TS	 	\N	5Yrs	Accubits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	unniduva@gmail.com	1111111111	\N	\N	\N	5	Immediate	29	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
709	Muhamed Shijas	 	\N	4 Yrs	Sensei Technologies (P) Ltd.	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shijasmadala9446@gmail.com	1111111111	\N	\N	\N	5	90 Days	30	inprogress	\N	\N	Malappuram	\N	\N	Trivandrum	\N	\N	\N
710	R Divya	 	\N	7.4 Yrs	Inspirisys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	divyasaroja50@gmail.com	1111111111	\N	\N	\N	5	Immediate	4	inprogress	\N	\N	Wayanad	\N	\N	Remote	\N	\N	\N
711	Shidhin Devadas	 	\N	5.5 Yrs	IBS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shidin@buffalo.edu	1111111111	\N	\N	\N	5	60 Days	23	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
712	Ifthikhanudeen	 	\N	14 Yrs	Caxita Tech Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ptifthikhan@gmail.com	1111111111	\N	\N	\N	5	90 Days	3	inprogress	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
713	Krishnakumar R	 	\N	18 Yrs	Overbrook Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kkr.mailbox@gmail.com	1111111111	\N	\N	\N	5	30 Days	3	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
714	Hiba Sherin	 	\N	2 Yrs	Codesap Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	hibasherincholappurath@gmail.com	1111111111	\N	\N	\N	5	Immediate	27	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
715	Drisya P 	 	\N	2.6 Yrs	Infolks 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	drisyapmohan1996@gmail.com	1111111111	\N	\N	\N	5	30 Days	27	inprogress	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
716	Mareena.K	 	\N	3 Yrs	National informatics centre	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mareenaksc@gmail.com	1111111111	\N	\N	\N	5	45 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
717	Fonso George	 	\N	2.4 Yrs	 Thoughtline Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	fonsogeorge@gmail.com	1111111111	\N	\N	\N	5	30 Days	25	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
718	MEERA B. SUNIL	 	\N	3 Yrs	Innovation Incubator	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	meerabsunil20@gmail.com	1111111111	\N	\N	\N	5	90 Days	34	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
719	Delna P Varghese	 	\N	5.10 Yrs	charisma infotainment	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	delna9961@gmail.com	1111111111	\N	\N	\N	5	30 Days	30	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
720	Nandana S	 	\N	6 Yrs	Vensure HCM	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	snandana34@gmail.com	1111111111	\N	\N	\N	5	60 Days	4	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
721	Beema B	 	\N	2 Yrs	Moonhive	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	masalam0000@gmail.com	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
722	Able roy	 	\N	6Yrs	Aspire Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	able@ableroy.co.in	1111111111	\N	\N	\N	5	60 Days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
723	Kannan Gopakumar	 	\N	6.6Yrs	Linways	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kannan.gopan360@gmail.com	1111111111	\N	\N	\N	5	15 Days	6	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
724	Athira	 	\N	6Yrs	Ceymox Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athiramenon.rnath94@gmail.com	1111111111	\N	\N	\N	5	Immediate	5	back-off	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
725	Shiny VR	 	\N	6.6Yrs	Emsyne Muthoot	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vrshini8@gmail.com	1111111111	\N	\N	\N	5	30 Days	4	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
726	Amal C R	 	\N	5 Yrs	QBurst	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	cr.gaganan@gmail.com	1111111111	\N	\N	\N	5	Immediate	33	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
727	Rizwav V K	 	\N	3.8 YRS	Jio Platforms Limited	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rizwanvk98@gmail.com	1111111111	\N	\N	\N	5	Immediate	22	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
728	Keerthi C P	 	\N	4 Yrs	Infosys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	keerthicprasannan@gmail.com	1111111111	\N	\N	\N	5	90 Days	12	rejected	\N	\N	Kottayam	\N	\N	Trivandrum	\N	\N	\N
729	Chithra P Mohan	 	\N	10 Yrs	Shell Square	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	chithra045@gmail.com	1111111111	\N	\N	\N	5	90 Days	16	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
730	Linsa Sosa Sam	 	\N	10.5 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	linsasosasam@gmail.com	1111111111	\N	\N	\N	5	Immediate	4	inprogress	\N	\N	Pathanamthitta	\N	\N	Cochin	\N	\N	\N
731	Mukesh M	 	\N	7 Yrs	Neoito	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mukeshm1989@gmail.com	1111111111	\N	\N	\N	5	Immediate	29	rejected	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
732	Sarath Krishna	 	\N	6Yrs	Accubits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sarathkrishna1729@gmail.com	1111111111	\N	\N	\N	5	60 Days	22	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
733	Binil Viswam	 	\N	10Yrs	Elicir Labs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	binilviswam@gmail.com	1111111111	\N	\N	\N	5	Immediate	11	rejected	\N	\N	Erode	\N	\N	Cochin	\N	\N	\N
734	Divya	 	\N	9Yrs	Inspirisis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	divyaaj91@gmail.com	1111111111	\N	\N	\N	5	Immediate	3	rejected	\N	\N	Wayanad	\N	\N	Cochin	\N	\N	\N
735	Aneesha Shibu	 	\N	6 Yrs	Transight Systems Pvt	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aneeshashibu7@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
736	Praveen PC	 	\N	12Yrs	Tecnoveda	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	click2praveen@gmail.com	1111111111	\N	\N	\N	5	Immediate	38	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
737	J.JERIN JEYSH	 	\N	5.8 Yrs	Neo ITO	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jerinjeysh@gmail.com	1111111111	\N	\N	\N	5	15 Days	12	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
738	Vignesh Kottilil	 	\N	5 Yrs	Experion 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vkn047@gmail.com	1111111111	\N	\N	\N	5	60 Days	4	rejected	\N	\N	Malappuram	\N	\N	Cochin	\N	\N	\N
739	Dinny Kuruvilla Zachariah	 	\N	15.5 Yrs	Gemini Software Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	 dinny.zac@gmail.com	1111111111	\N	\N	\N	5	90 Days	3	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
740	Suman Dev	 	\N	7 Yrs	Emviho Tecjnologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sumandev.p@gmail.com	1111111111	\N	\N	\N	5	Serving LWD July 15th	22	rejected	\N	\N	Idukki	\N	\N	Cochin	\N	\N	\N
741	Rijo N J	 	\N	5.6 Yrs	Speridian Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	johnrijo980@gmail.com	1111111111	\N	\N	\N	5	60 Days	30	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
742	Anu Mary Varghese	 	\N	5 Yrs	Zerone Consulting PVt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	annmarykalapurackal@gmail.com	1111111111	\N	\N	\N	5	Immediate	30	rejected	\N	\N	Idukki	\N	\N	Cochin	\N	\N	\N
743	Sinoy Geroge	 	\N	16 Yrs	LSG	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sgzmail777@gmail.com	1111111111	\N	\N	\N	5	Immediate	11	rejected	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
744	Robin Roy	 	\N	7.7 yrs	Camet IT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	robyroyrock@gmail.com	1111111111	\N	\N	\N	5	Immediate	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
745	Sreelakshmi M Nair	 	\N	2.2 Yrs	Lanware Solutions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreelakshmimaninair@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
746	Mahesh M T	 	\N	12 Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	maheshmt2007@gmail.com	1111111111	\N	\N	\N	5	60 Days	11	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
747	Linda Varghese	 	\N	10 Yrs	Covalense Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lindamonicav3@gmail.com	1111111111	\N	\N	\N	5	30 Days	41	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
748	Fathimathul Nooha N	 	\N	4.9 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	fathimathulnooha17@gmail.com	1111111111	\N	\N	\N	5	30 Days	4	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
749	Shivhari Bargaje	 	\N	4.5 Yrs	Tactus Ventures	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shivharibargaje@gmail.com	1111111111	\N	\N	\N	5	30 Days	2	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
750	Feroz Saiyed	 	\N	19 Yrs	Speehive 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ferozsaiyed2019@gmail.com	1111111111	\N	\N	\N	5	Immediate	3	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
751	Reshma Sankar	 	\N	6Yrs	Pits Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmasankar96@gmail.com	1111111111	\N	\N	\N	5	LWD Oct 1st	18	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
752	Archana BN	 	\N	10+Yrs	Yethi Consulting	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bnarchana1011@gmail.com	1111111111	\N	\N	\N	5	90 days Nego to 60	11	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
753	Sajan	 	\N	12Yrs	Thinkpalm	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sajan.sunny@outlook.com	1111111111	\N	\N	\N	5	90 Days	11	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
754	Bala Palamurugan	 	\N	13yrs	Thinkpalm	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	palmurugan.c@gmail.com	1111111111	\N	\N	\N	5	90 days Nego to 60	32	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
755	Akshay	 	\N	5Yrs	Yes Yem Tee Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akshayas6991@gmail.com	1111111111	\N	\N	\N	5	15 days	30	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
756	Shini Parameshwaran	 	\N	3 Yrs	AITRICH TECHNOLOGIES PVT LTD,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shiniupparameswaran@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
757	Vani Vasukuttan	 	\N	5 Yrs	Refelctions Info Sys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vanivasukuttan2909@gmail.com	1111111111	\N	\N	\N	5	Immediate	33	rejected	\N	\N	Alleppy	\N	\N	Trivandrum	\N	\N	\N
758	Susmitha	 	\N	12 Yrs	Thoughtline	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	susmithanairs@gmail.com	1111111111	\N	\N	\N	5	90 Days	35	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
759	Amalraj K D	 	\N	5 Yrs	KENLAND IT SOLUTIONS PVT. LTD	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amalraj2662@gmail.com	1111111111	\N	\N	\N	5	15 Days	27	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
760	Seethal thomas	 	\N	6Yrs	Pits Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	seethalthomas16@gmail.com	1111111111	\N	\N	\N	5	LWD Oct 1st	18	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
761	Abhijith KJ	 	\N	10+Yrs	Yethi Consulting	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kj.abhijith22@gmail.com	1111111111	\N	\N	\N	5	90 days Nego to 60	11	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
762	Anandu Viswan	 	\N	5Yrs	Newagysys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anandhuviswan@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
763	Shamseena Thasnim K A	 	\N	3.9 Yrs	Acsia Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shamseenaka@gmail.com	1111111111	\N	\N	\N	5	Immediate	17	inprogress	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
764	Joseph Kandathil	 	\N	6Yrs	Ateam Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mathewjoseph327@gmail.com	1111111111	\N	\N	\N	5	Lwd August 9th	22	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
765	Musthafa T M	 	\N	7 Yrs	 Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	musthafatm3786@gmail.com	1111111111	\N	\N	\N	5	60 Days	4	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
766	Manoj Kumar	 	\N	19 Yrs	Gisfy PVT Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rvmanojkumar@gmail.com	1111111111	\N	\N	\N	5	30 Days	3	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
767	Jigine Oommen George	 	\N	15 Yrs	Yuvantech Solution (Freelance)	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jigine.george.official@gmail.com	1111111111	\N	\N	\N	5	Immediate	38	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
768	Arjun C	 	\N	2.7 Yrs	Davean Enterprises Pvt Lt	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arjunchandrakumar2017@gmail.com	1111111111	\N	\N	\N	5	30 Days	27	rejected	\N	\N	Pathanamthitta	\N	\N	Cochin	\N	\N	\N
769	Syamdev AJ	 	\N	3.7 Yrs	MAFIL	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	syamdev.a.j@gmail.com	1111111111	\N	\N	\N	5	30 days	30	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
770	Vimal Menon	 	\N	3 Yrs	Art technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vimalmenonk6547@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
771	Nijamudeen	 	\N	2.5 Yrs	Raqeeb Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nijamudeen.web@gmail.com	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
772	Jayakrishnan D	 	\N	7 Yrs	Kriti Microsystems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dajayakrishnan@gmail.com	1111111111	\N	\N	\N	5	30 Days	28	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
773	Nikhila A T	 	\N	8 Yrs	Flexm	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nikhilaat610@gmail.com	1111111111	\N	\N	\N	5	30 Days	19	back-off	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
774	Dona Jose	 	\N	5.6Yrs	Vrize	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	donakulangara@gmail.com	1111111111	\N	\N	\N	5	LWD August 9th	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
775	Anju KU	 	\N	10+Yrs	Qburst	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjukunni@gmail.com	1111111111	\N	\N	\N	5	90 Days	11	back-off	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
776	Subin KS	 	\N	4.7Yrs	Accubits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	subizubin98@gmail.com	1111111111	\N	\N	\N	5	60 Days	29	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
777	Davis Mathew	 	\N	6Yrs	Ateam Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	davismathew7s@gmail.com	1111111111	\N	\N	\N	5	Lwd August 9th	22	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
778	Suraj Vasant	 	\N	11 Yrs	 Metadata Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	surajv8448@gmail.com	1111111111	\N	\N	\N	5	Immediate	11	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
779	Rajesh G	 	\N	4.5 Yrs	Abzer Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	 rajesh.grst@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
780	Meera Pradeep	 	\N	8 Yrs	Freston Analytics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	meerapradeep14@icloud.com	1111111111	\N	\N	\N	5	30 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
781	Afseena	 	\N	2 Yrs	Elkanio	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	epafseena@gmail.com	1111111111	\N	\N	\N	5	30 Days	27	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
782	Neenu Ann Mathew	 	\N	7 Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neenuann8@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
783	Navaneeth	 	\N	10 Yrs	Creditmantri Finserve	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mailmenavaneeth@gmail.com	1111111111	\N	\N	\N	5	45 Days	37	back-off	\N	\N	Thirunelveli	\N	\N	Cochin	\N	\N	\N
784	Linu Varghese	 	\N	12 Yrs	Micro Objects	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	linu4varghese@gmail.com	1111111111	\N	\N	\N	5	60 days	39	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
785	Anu Bahseer	 	\N	14 yrs	Simelabs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	a.anubasheer@gmail.com	1111111111	\N	\N	\N	5	30 Days	3	rejected	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
786	Simi John	 	\N	4.7Yrs	Cybrosis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	varsharadhakrishnan12@gmail.com	1111111111	\N	\N	\N	5	60 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
787	Archana Raju	 	\N	5Yrs	Acsia	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	archanaraju@gmail.com	1111111111	\N	\N	\N	5	90 days	29	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
788	Aswin Ravindran	 	\N	3 Yrs	Bassam InfoTech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswinmvpnr@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
789	Alan Thomas	 	\N	5 Yrs	VIEWY DIGITAL	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alanthomas992@gmail.com	1111111111	\N	\N	\N	5	60 Days	6	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
790	Anitha M	 	\N	6 Yrs	BRAHMANET	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anu7august@gmail.com	1111111111	\N	\N	\N	5	60 Days	13	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
791	Jobi K John	 	\N	8 Yrs	 Gadgeon 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jobikjohn@gmail.com	1111111111	\N	\N	\N	5	60 Days	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
792	Serin Joseph	 	\N	4.7Yrs	Keyvalue Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	serinjospgh34@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
793	Santhosh Asokan	 	\N	15Yrs	Suntech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	santhoshasokan1985@yahoo.com	1111111111	\N	\N	\N	5	90 Days	32	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
794	Roshi Kurian	 	\N	13 Yrs	RJ Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	roshikurianalpy@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-24th July)	32	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
795	PRAVEEN VIJAYAN	 	\N	7 Yrs	HASPACES IT	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	praveenpankad@gmail.com	1111111111	\N	\N	\N	5	30 Days	12	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
796	Rajeev Kumar K R	 	\N	12.5 Yrs	BEO Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bil.rajeev@gmail.com	1111111111	\N	\N	\N	5	30 Days	11	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
797	Ayisha Julka 	 	\N	4 Yrs	Tathkarah	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ayishajulkapp@gmail.com	1111111111	\N	\N	\N	5	30 Days	8	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
798	Albert T J	 	\N	6 Yrs	Thomsun infocare	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	albertjoseph45@gmail.com	1111111111	\N	\N	\N	5	30 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
799	Naveen joy	 	\N	5.1Yrs	Speridian Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	naveenjoy4@gmail.com	1111111111	\N	\N	\N	5	60 days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
800	Jijesh S	 	\N	6Yrs	Mariapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jijeshfrs32@gmail.com	1111111111	\N	\N	\N	5	90 Days	22	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
801	Basil T	 	\N	10.5Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	basiltj07@gmail.com	1111111111	\N	\N	\N	5	90 Days	29	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
802	Vipin Kumar	 	\N	12 Yrs	6D Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vipinkumarkp.kp@gmail.com	1111111111	\N	\N	\N	5	Immediate	43	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
803	Vidhya Kunjupillai	 	\N	9 Yrs	Pits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vid12312@gmail.com	1111111111	\N	\N	\N	5	90 Days (Neg 30 Days)	24	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
804	Subash Chandrabose	 	\N	9 Yrs	Nest	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	subashchandran1267@gmail.com	1111111111	\N	\N	\N	5	60 Days	35	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
805	PRASANTH P S	 	\N	13 Yrs	Thoughtline Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	prasanthps007@gmail.com	1111111111	\N	\N	\N	5	TBS	11	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
806	Faisal Salim	 	\N	9 Yrs	Accubits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	faisal0325@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-Last week of August)	40	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
807	Shimna R	 	\N	6Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shimnasr@gmail.com	1111111111	\N	\N	\N	5	90 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
808	Praveen	 	\N	15Yrs	Neudesic	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	praveenpdr@gmail.com	1111111111	\N	\N	\N	5	90 Days	16	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
809	Aswin Raj	 	\N	6Yrs	Accubits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswinrajcr@gmail.com	1111111111	\N	\N	\N	5	Immediate	29	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
810	Arathi OK	 	\N	5.7Yrs	Accubits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arathiok@gmail.com	1111111111	\N	\N	\N	5	LWD Aug 11th	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
811	Jusha Joseph	 	\N	15Yrs	G10X	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jushajoseph@gmail.com	1111111111	\N	\N	\N	5	90 Days	16	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
812	Deepa Jaykumar	 	\N	6Yrs	Accubits	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	deepajaykumar45@gmail.com	1111111111	\N	\N	\N	5	Immediate	29	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
813	PPreejith Puthukulangara 	 	\N	16+ 	IQVIA	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ppreejithputhukulangara@mail.com	1111111111	\N	\N	\N	5	Immediate	16	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
814	Aswathy Reghunathan	 	\N	2 Yrs	Techanise Solution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswathyvishal2@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
815	Aravind Ravi	 	\N	15 Yrs	Cubet Technolabs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aravind.dharan@gmail.com	1111111111	\N	\N	\N	5	60 Days	16	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
816	Anju P Rajan	 	\N	5 Yrs	Kawika Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjuprajan30@gmail.com	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
817	AKHIL K	 	\N	8 Yrs	Press Ganey Associates	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhilk1992@gmail.com	1111111111	\N	\N	\N	5	60 Days(NEg to 45 Days)	4	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
818	Pranav S Bhasi 	 	\N	5.3 Yrs	Future Focus Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	paranvbhasi@gmail.com	1111111111	\N	\N	\N	5	Immediate	21	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
819	Vinitha K	 	\N	12 Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	krish.mylord@gmail.com	1111111111	\N	\N	\N	5	60 Days	16	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
820	SasnaSaifudhin	 	\N	8 Yrs	PITS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sasnasaif91@gmail.com	1111111111	\N	\N	\N	5	90 Days	4	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
821	Athul Babu M 	 	\N	4.9Yrs 	EY 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athulbabu.m@gmail.com	1111111111	\N	\N	\N	5	60 Days 	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
822	Akhila S	 	\N	3 Yrs	 uviqo technologies 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhilasasikumar47@gmail.com	1111111111	\N	\N	\N	5	Immediate	13	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
823	Prathap Kumar M	 	\N	10 yrs	Vtrio	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	prathapkumar240@gmail.com	1111111111	\N	\N	\N	5	60 Days	43	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
824	Sreedev R	 	\N	15 Yrs	Wipro	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reachme@sreedevr.com	1111111111	\N	\N	\N	5	Serving NP Lwd Oct 6th	3	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
825	Jerin	 	\N	3 Yrs	Infospacia	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jerinnakkarethu@gmail.com	1111111111	\N	\N	\N	5	60 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
826	Anuj Purushotham	 	\N	13.8Yrs	LTI Mindtree	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anooj896@gmail.com	1111111111	\N	\N	\N	5	90 Days	16	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
827	Simi sara	 	\N	8Yrs	Nuventure	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	simisara005@gmail.com	1111111111	\N	\N	\N	5	90 Days	4	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
828	Anantha narayannan	 	\N	6Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ananthanarayananrs@gmail.com	1111111111	\N	\N	\N	5	90 Days	25	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
829	Anoop S Babu	 	\N	13Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anoopbabutvm@gmail.com	1111111111	\N	\N	\N	5	60 Days	16	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
830	Fijo Francis	 	\N	6Yrs	Techjays	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	fijo1011@gmail.com	1111111111	\N	\N	\N	5	60 days	4	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
831	Arun Jose	 	\N	10Yrs	Allianz	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	Arunjosesr@gmail.com	1111111111	\N	\N	\N	5	90 Days	43	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
832	Sooraj N R	 	\N	8 Yrs	Nest	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	soorajnr4@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
833	Priya Darshini S	 	\N	12 Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	Darshini.kh@gmail.com	1111111111	\N	\N	\N	5	60 Days	11	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
834	Neethu Hareendranath	 	\N	9 Yrs	ZineMind Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethuhareendranath@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-5th August)	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
835	Nithin T M	 	\N	14 Yrs	Guide House	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	tmnithin1986@gmail.com	1111111111	\N	\N	\N	5	60 Days	16	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
836	Gokul	 	\N	3 Yrs	VVDN	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gokul44krishna@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
837	Shibina P	 	\N	4.10 Yrs	Kott Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shibinaponakkal@gmail.com	1111111111	\N	\N	\N	5	Immediate	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
838	Nancy Alfred	 	\N	7 Yrs	Edstem Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nancy.jlu11@gmail.com	1111111111	\N	\N	\N	5	30 Days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
839	Ananad M C	 	\N	3 Yrs	XIME INFOSOLUTIONS PVT LTD	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anand.mc.ofcl@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
840	Firoz PP	 	\N	15 yrs	ANJ	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	firozkannur@gmail.com	1111111111	\N	\N	\N	5	30 Days	16	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
841	Abhitha Anil	 	\N	5 Yrs	Blueripples	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abithaanil3198@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
842	Sreeja V Nair	 	\N	7 Yrs	Thakral One Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreejavnair135@gmail.com	1111111111	\N	\N	\N	5	30 Days	21	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
843	Simi S	 	\N	8 Yrs	Tata Elxi	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	simi.shivam@gmail.com	1111111111	\N	\N	\N	5	90 Days	38	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
844	Ananthu Sidharthan	 	\N	8 Yrs	SCG Digital Private Limited	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	iananthuhere@gmail.com	1111111111	\N	\N	\N	5	45 Days	21	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
845	Maheshwaran	 	\N	4Yrs	Cybrosis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mahi71544@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
846	Amal Chand	 	\N	8.7Yrs	Qburst	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amalchand.o@gmail.com	1111111111	\N	\N	\N	5	60 days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
847	Stejith Stephen	 	\N	8Yrs	Equifax	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	stejithstephen93@gmail.com	1111111111	\N	\N	\N	5	90 Days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
848	Amal Raj	 	\N	6Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amalrajacl@gmail.com	1111111111	\N	\N	\N	5	90 Days	25	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
849	Priyesh Sreekumar	 	\N	6Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	priyeshsreekumarsr@gmail.com	1111111111	\N	\N	\N	5	60 days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
850	Ashok V	 	\N	8Yrs	Pumex 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	Ashoksdr@gmail.com	1111111111	\N	\N	\N	5	30 Days	22	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
851	Rinsha A.K	 	\N	8 Yrs	Quest	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rinz.nzrn@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-20th Sep)	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
852	Joxin Johny	 	\N	9 Yrs	 Intellioak Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jox.johny@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-10th August)	41	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
853	Jafarali P V	 	\N	13 Yrs	TCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jaffaralipv@gmail.com	1111111111	\N	\N	\N	5	90 Days	38	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
854	Midhun P M	 	\N	3 Yrs	Webandcrafts	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mithunpm67@gmail.com	1111111111	\N	\N	\N	5	30 Days	13	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
855	Anand Vishnu	 	\N	15Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anandvishnukumar@gmail.com	1111111111	\N	\N	\N	5	60 Days	16	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
856	Kailas S	 	\N	7Yrs	Teranet	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	KailasParippally@gmail.com	1111111111	\N	\N	\N	5	60 days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
857	Remya Shibu	 	\N	6Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	remyashibu23@gmail.com	1111111111	\N	\N	\N	5	90 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
858	Sreerekha S	 	\N	6Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreerekha34@gmail.com	1111111111	\N	\N	\N	5	60 days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
859	Janaki Kumar	 	\N	8Yrs	Pumex 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	janakisrtv@gmail.com	1111111111	\N	\N	\N	5	30 Days	29	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
860	Abdul Shahid	 	\N	7.8 Yrs	Infosmart Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	a.shahid.b@gmail.com	1111111111	\N	\N	\N	5	90 Days	38	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
861	Saranya M M	 	\N	3.5 Yrs	Blueripples	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mmsaranya964@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
862	Athul A	 	\N	5 Yrs	IMMCO	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athulbabu.a@gmail.com	1111111111	\N	\N	\N	5	90 Days	27	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
863	Sendeavu E S  	 	\N	12 Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sendeavu@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-5th August)	16	inprogress	\N	\N	Calicut	\N	\N	Trivandrum	\N	\N	\N
864	Amrutha Sandhya	 	\N	9.5 Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amruthasandhya@gmail.com	1111111111	\N	\N	\N	5	60 Days	41	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
865	Sam Jimmy	 	\N	13Yrs	CTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jimmysam23@gmail.com	1111111111	\N	\N	\N	5	Immediate	38	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
866	Shyma S	 	\N	6Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shymatceh2@gmail.com	1111111111	\N	\N	\N	5	90 Days	25	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
867	Theertha Mohan	 	\N	8Yrs	Pumex 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	theerthammohansr@gmail.com	1111111111	\N	\N	\N	5	30 Days	29	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
868	Anuj Purushotham	 	\N	13.8Yrs	LTI Mindtree	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ANOOJ896@GMAIL.COM	1111111111	\N	\N	\N	5	90 Days	16	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
869	Jins Varghese	 	\N	9.5 Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jinsndkm@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
870	Rilu Grace Varghese	 	\N	6.6 Yrs	Fingent	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rilugrace95@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
871	Nadeem Rizwan	 	\N	4 Yrs	Forefront Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nadeembk4@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
872	Dharani	 	\N	5.2 Yr	Blueripples	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mdharanitmuthukrishnan@gmail.com	1111111111	\N	\N	\N	5	30 Days	24	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
873	Sagar Surendhrababu	 	\N	13 Yrs	Willams Lea	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sagarts@live.com	1111111111	\N	\N	\N	5	Serving LWD 10th Aug	24	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
874	Beena Pandikashala	 	\N	14 Yrs	Saranyu Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	beenap013@gmail.com	1111111111	\N	\N	\N	5	90 Days	16	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
875	Aparna B Nair	 	\N	4Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aparnaunni90@gmail.com	1111111111	\N	\N	\N	5	60 Days	29	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
876	Ligin Joseph	 	\N	13Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ligin.joseph@gmail.com	1111111111	\N	\N	\N	5	61 Days	32	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
877	Allwin	 	\N	7Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	allwin.vmohan@gmail.com	1111111111	\N	\N	\N	5	30 Days	4	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
878	Samarasan	 	\N	4 Yrs	RIVERSTONE INFOTECH	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	santhoshsam35@gmail.com	1111111111	\N	\N	\N	5	Immediate	24	inprogress	\N	\N	Tirunelveli	\N	\N	Trivandrum	\N	\N	\N
879	Harsha Prabhakaran	 	\N	5.6 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	harshaprabhakaranmtk@gmai	1111111111	\N	\N	\N	5	30 Days	28	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
880	Muhammed Arshad	 	\N	5 Yrs	MWT Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mohamedarshadcholasseri5050@gmail.com	1111111111	\N	\N	\N	5	Aug 7th LWD	29	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
881	Ginesh Thomas	 	\N	15 Yrs	Suncorp	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gineshthomas@gmail.com	1111111111	\N	\N	\N	5	30 Days	16	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
882	Noel Philip	 	\N	7 Yrs	Acoup	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	adam.noel.philip@gmail.com	1111111111	\N	\N	\N	5	Immediate	28	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
883	Aswanth Mohan PP	 	\N	3 Yrs	 Edstem Technologies 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswanthmohan97@gmail.com\n	1111111111	\N	\N	\N	5	30 Days	24	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
884	Nipin Raj O	 	\N	4 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nipinrajcalicut@gmail.com	1111111111	\N	\N	\N	5	60 Days	23	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
885	Gayathri K	 	\N	4 Yrs	BeekaTechnologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gaayaak3@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
886	Nithin Sam	 	\N	5 Yrs	RM Education	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nithin.sam13@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
887	Priyanka Sivapraksh	 	\N	3 Yrs	Grapelime Innovations	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	priyankashivaprakash24@gmail.com	1111111111	\N	\N	\N	5	30 Days	28	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
888	Muhammed Hamir	 	\N	2 Yrs	Nest	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amirnalappad@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
889	Boobalan	 	\N	6 Yrs	Mahathi Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	boobaldeno21@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
890	Anoop K Vijayan	 	\N	6 Yrs	Yes Yem Tee Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anoopvijayank@yahoo.com	1111111111	\N	\N	\N	5	30 Days	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
891	Cyriac K. Abraham	 	\N	6 Yrs	Mariapps Marine Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	cyriacabrahamkuttiyani@gmail.com	1111111111	\N	\N	\N	5	60 Days	33	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
892	Maneesha	 	\N	8Yrs	Cubet Tech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	maneesha.s2002@gmail.com	1111111111	\N	\N	\N	5	30 Days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
893	Dennies Augustine	 	\N	7 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	denniesaugustine@gmail.com	1111111111	\N	\N	\N	5	30 Days	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
894	Vimal V	 	\N	7.5 Yrs	ZemosoTechnologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vimalmanikandan.v@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-29th August)	21	inprogress	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
895	Melvin Renil D	 	\N	6.6 Yrs	Versasoft solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mrenil.deva@gmail.com	1111111111	\N	\N	\N	5	30 Days	13	inprogress	\N	\N	Kanyakumari	\N	\N	Trivandrum	\N	\N	\N
896	Varsha Babu	 	\N	4.10 Yrs	Zerone Consulting	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	1dec2014varsha@gmail.com	1111111111	\N	\N	\N	5	30 Days	19	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
897	Nijeesh Sp	 	\N	7 Yrs	QWY Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nijeeshsp91@gmail.com	1111111111	\N	\N	\N	5	30 Days	33	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
898	Jaison Joseph	 	\N	10Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jaison.josephit@gmail.com	1111111111	\N	\N	\N	5	60 Days	38	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
899	Hareesh Balakrishnan	 	\N	9.6Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	hareesh.balakrishnan.89@gmail.com	1111111111	\N	\N	\N	5	60 Days	38	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
900	Ramshad PS	 	\N	5Yrs	Citrus Informatics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	psramshad99@gmail.com	1111111111	\N	\N	\N	5	60 Days	28	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
901	Antos Maman	 	\N	8Yrs	Born Group	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	antosmamanktr@gmail.com	1111111111	\N	\N	\N	5	60 Days	42	back-off	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
902	Jibin Bose	 	\N	7.5Yrs	Litmus 7 Consulting	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jibin362@gmail.com	1111111111	\N	\N	\N	5	60 Days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
903	Vimal N	 	\N	7.6 Yrs	Simelabs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vimal2009n@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	inprogress	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
904	Teertha Mohan P	 	\N	6 Yrs	Simelabs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	theerthapmohan54@gmail.com	1111111111	\N	\N	\N	5	30 Days	33	inprogress	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
905	Aruna A	 	\N	5+ Yrs	Bridge Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	chitraaruna09@gmail.com	1111111111	\N	\N	\N	5	60 Days	33	inprogress	\N	\N	Pathanamthitta	\N	\N	Cochin	\N	\N	\N
906	Linu Sunny	 	\N	5Yrs	Allianz	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	linuelizabathsunny@gmail.com	1111111111	\N	\N	\N	5	90 Days	19	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
907	Vivek Joy	 	\N	6.6Yrs	Neudesic	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	joyvivek93@gmail.com	1111111111	\N	\N	\N	5	90 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
908	Anand KS	 	\N	6Yrs	Cabot Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anandksanthosh50@gmail.com	1111111111	\N	\N	\N	5	Immediate	22	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
909	Anjali AV	 	\N	7.5Yrs	Millenium EBS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjalijayan@hotmail.com	1111111111	\N	\N	\N	5	LWD August 16th	38	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
910	Rakesh J	 	\N	2 Yrs	Neoito	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rakheshsjayakumar@gmail.com	1111111111	\N	\N	\N	5	30 Days	24	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
911	Karthikeyan	 	\N	3 Yrs	UT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	karthick2622@gmail.com	1111111111	\N	\N	\N	5	serving LWD aug 16th	27	rejected	\N	\N	Tirunelveli	\N	\N	Trivandrum	\N	\N	\N
912	Soumya K M	 	\N	17 Yrs	 Toobler 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	soumyakm8285@gmail.com	1111111111	\N	\N	\N	5	60 Days	16	rejected	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
913	Varun Raj V 	 	\N	7 Yrs	Hyreo 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	varunparavur@gmail.com	1111111111	\N	\N	\N	5	60 Days	41	rejected	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
914	Dinu Lal	 	\N	6.3Yrs	Toadfly Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dinus175@gmail.com	1111111111	\N	\N	\N	5	Immediate	18	rejected	\N	\N	Calicut	\N	\N	Trivandrum	\N	\N	\N
915	Renjith A	 	\N	6Yrs	Techspawn solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ranjithit76@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	back-off	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
916	Anshad Hasan	 	\N	6Yrs	Air payment 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anshadmld@gmail.com	1111111111	\N	\N	\N	5	90 Days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
917	Ahamed Bashar	 	\N	6Yrs	webandcrafts	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ahammed.bashar9@gmail.com	1111111111	\N	\N	\N	5	60 Days	24	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
918	Vivek P 	 	\N	4Yrs 	Ndiensions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	pvivek@gmail.com	1111111111	\N	\N	\N	5	60 Days 	23	back-off	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
919	Yethin S	 	\N	4 Yrs	iLearningEngines 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	s.yethin@gmail.com	1111111111	\N	\N	\N	5	30 Days	24	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
920	Nidhin Mathew	 	\N	7.5 Yrs	Quantiphi	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nidhin63@gmail.com	1111111111	\N	\N	\N	5	60 Days	38	inprogress	\N	\N	Alleppy	\N	\N	Trivandrum	\N	\N	\N
921	Lithin Prakash	 	\N	9 Yrs	Thoughtline Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lithinempire4@gmail.com	1111111111	\N	\N	\N	5	60 Days	4	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
922	Gigi Sadanandan	 	\N	8 Yrs	SHELLSQUARE	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sadanandangigi@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-30th Sep)	3	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
923	Arun Mohan	 	\N	11 Yrs	Cleareye.ai	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mohan.arunrevathy.arun324@  gmail.com 	1111111111	\N	\N	\N	5	Serving(LWD-9th Sep)	3	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
924	Alwin P J	 	\N	8 Yrs	 Inspir ed	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alwinputhur1234@gmail.c om 	1111111111	\N	\N	\N	5	90 Days	21	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
925	Nikhil Baby	 	\N	6.6 Yrs	Beinex Consulting	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nikhilkumily@gmail.com	1111111111	\N	\N	\N	5	Immediate	27	inprogress	\N	\N	Idukki	\N	\N	Cochin	\N	\N	\N
926	Soorya S	 	\N	6 Yrs	TCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sooryasnair10@gmail.com	1111111111	\N	\N	\N	5	Immediate	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
927	Anton Boban	 	\N	7 Yrs	Feathersoft	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anton.bobanthengummoottil@gmail.com	1111111111	\N	\N	\N	5	90 Days	4	inprogress	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
928	Akshay Kumar	 	\N	4.3 Yrs	eMatrix Software solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akshayk145@gmail.com	1111111111	\N	\N	\N	5	Immediate	28	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
929	Najilath P	 	\N	5 Yrs	Al Tomuh IT LLC	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	najilathktply@gmail.com	1111111111	\N	\N	\N	5	Serving - LWD Oct 31st	19	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
930	Vidhya Rajesh	 	\N	4.2 Yrs	Thomsun Infocare	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vidhyarajesh0809@gmail.com	1111111111	\N	\N	\N	5	Serving Lwd Sep 30th	19	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
931	Athira K 	 	\N	5 Yrs 	Ndimensions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athirak34@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
932	Anurag R Nair 	 	\N	4Yrs 	Ndimensions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anuragrnair56@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
933	Afna K	 	\N	5Yrs 	ISPG Technologies 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kafna78@gmail.com	1111111111	\N	\N	\N	5	60 Days 	23	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
934	Rishin 	 	\N	2years, 	TIC Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rishink@gmail.com 	1111111111	\N	\N	\N	5	30Days 	13	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
935	Muhammed Naseef 	 	\N	4.8Yrs 	Aceware Fintech Services Pvt. Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	naseefm@gmail.com	1111111111	\N	\N	\N	5	60 Days 	17	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
936	Amith Raj M	 	\N	4 Yrs	Syntrio Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amithrm7@gmail.com	1111111111	\N	\N	\N	5	45 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
937	Vijay Venugopal	 	\N	14 Yrs	Hitachi	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vijayvenu29@gmail.com	1111111111	\N	\N	\N	5	90 Days	32	inprogress	\N	\N	Palakkad	\N	\N	Trivandrum	\N	\N	\N
938	Ganesh R	 	\N	4 Yrs	RSGP	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ganeshram812@gmail.com	1111111111	\N	\N	\N	5	Immediate	24	rejected	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
939	Ratheesh kumar	 	\N	6 Yrs	Cape Start	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ratheeshskic@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
940	Jerin Mathai	 	\N	3.4 Yrs	 Infospica	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	 jerinnakkarethu@gmail.com	1111111111	\N	\N	\N	5	60 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
941	Siva	 	\N	3Yrs 	Aspire Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sivareddyp160@gmail.com,	1111111111	\N	\N	\N	5	60 Days 	27	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
942	Shabareesh 	 	\N	2Yrs 	Throughapps 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sabareeshps1998@gmail.com	1111111111	\N	\N	\N	5	60 Days 	27	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
943	Mohammed Rafiq 	 	\N	4Yrs 	Think Winning 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mohammedrafiqa825@gmail.com	1111111111	\N	\N	\N	5	60 Days 	18	rejected	\N	\N	Chennai	\N	\N	Trivandrum	\N	\N	\N
944	Bijo Babu	 	\N	10 Yrs	Bridge Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bijob89@gmail.com	1111111111	\N	\N	\N	5	Immediate	29	inprogress	\N	\N	Bangaluru	\N	\N	Cochin	\N	\N	\N
945	Ashin Das	 	\N	5.5 Yrs	Aceware Fintech Services Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ashindaschandroth97@gmail.com	1111111111	\N	\N	\N	5	Immediate	30	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
946	Abhishek R	 	\N	4 Yrs	Naico ITS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	raviabhishek445@gmail.com	1111111111	\N	\N	\N	5	45 Days	27	inprogress	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
947	Mathanraj 	 	\N	4Yrs 	Zio Fintech 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rajamathan76@gmail.com	1111111111	\N	\N	\N	5	60 Days 	18	back-off	\N	\N	Chennai 	\N	\N	Trivandrum	\N	\N	\N
948	Aiswarya 	 	\N	3.5Yrs 	Cybrosys Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aiswarya@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	23	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
949	Meera Krishan	 	\N	3 Yrs	Gewan Infotech Solutions Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	meerakrishna5329@gmail.com	1111111111	\N	\N	\N	5	30 Days	4	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
950	Muhammed Sinas	 	\N	5.4 Yrs	zerone Consulting Services	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sinasmohmmz@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
951	Prashob Sasidharan	 	\N	5.7 Yrs	Integris Education India Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	prashob.sasi@gmail.com	1111111111	\N	\N	\N	5	90 Days	21	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
952	T V Anandhu Nair	 	\N	3.5 Yrs	Reflections Infosystems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anandhunairtv@gmail.com	1111111111	\N	\N	\N	5	60 Days	24	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
953	Athira Joseph	 	\N	2.7 Yrs	Yourvision software solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athirajoseph1999@gmail.com	1111111111	\N	\N	\N	5	30 Days	29	rejected	\N	\N	Kottayam	\N	\N	Trivandrum	\N	\N	\N
954	Nithindas P	 	\N	15.7 Yrs	Wipro	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	p.nithindas@gmail.com	1111111111	\N	\N	\N	5	Serving Lwd Nov 9th	32	inprogress	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
955	Chrishtapher	 	\N	3Yrs	Foxiom Leads	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	christapherct02@gmail.com	1111111111	\N	\N	\N	5	30 days	23	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
956	Aiswarya 	 	\N	3.5Yrs	Cybrosys Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aiswrya67@gmail.com 	1111111111	\N	\N	\N	5	60 Days	23	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
957	Rahul Chacko	 	\N	4 Yrs	Brandcart	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahulchacko7796@gmail.com	1111111111	\N	\N	\N	5	Immediate	8	inprogress	\N	\N	Kottayam	\N	\N	Trivandrum	\N	\N	\N
958	Vishnu Vijayan M	 	\N	4 Yrs	Manvish Info Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnumv994@gmail.com	1111111111	\N	\N	\N	5	30 Days	17	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
959	Ashli V P	 	\N	6 Yrs	 GJ Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ashilivp@gmail.com	1111111111	\N	\N	\N	5	30 days	21	inprogress	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
960	Neena Thomas 	 	\N	3.5Yrs 	Cybrosys Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neenuthomas98@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	23	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
961	Rejil K 	 	\N	2.5Yrs 	ULTS 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rejilk768@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	23	back-off	\N	\N	Calicut	\N	\N	Trivandrum	\N	\N	\N
962	Justin Joseph	 	\N	8 Yrs	BrandOptics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	justinjoseph33@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
963	Hari Krishnan	 	\N	13 Yrs	Onetikk Consultants	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	hkstvm@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
964	Ramya M	 	\N	4.5 Yrs	Groware Educational 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	  remyasreenu@gmail.com 	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
965	Akshay A B	 	\N	7 Yrs	Trensar Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akshayaravindab@gmail.com	1111111111	\N	\N	\N	5	Imeediate	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
966	Sherin M K	 	\N	17 Yrs	H&R Block	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sherinmk84@gmail.com	1111111111	\N	\N	\N	5	Immediate	39	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
967	Sandhya Rajan	 	\N	3.5 Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sand867@gmail.com	1111111111	\N	\N	\N	5	90 Days	32	inprogress	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
968	Naima 	 	\N	4Yrs 	CAMS Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	naimas98@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	13	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
969	Rahul RV 	 	\N	5Yrs 	Inapp Solutions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahulrv001@gmail.com	1111111111	\N	\N	\N	5	60 Days 	29	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
970	Sneha K 	 	\N	5Yrs 	ISPG Technologies 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	snehamenon96@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
971	Shijesh Lakshmanan	 	\N	5 Yrs	zerone Consulting Services	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shijeshlakshman@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
972	Albin Sjan	 	\N	3 Yrs	Bluepex	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	albinsojan@gmail.com	1111111111	\N	\N	\N	5	15 Days	17	inprogress	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
973	Midhun Joseph	 	\N	4 Yrs	UVJ	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	midhunjoseph.joseph000@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
974	Sibin Raj C S	 	\N	11 Yrs	Global Media Insight	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sibi.sibinraj@gmail.com	1111111111	\N	\N	\N	5	30 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
975	Shanila Rejin	 	\N	8 Yrs	McAfee Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shanilarejin44@gmail.com	1111111111	\N	\N	\N	5	30 Days	7	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
976	Jyothish Mohan	 	\N	10 Yrs	NT Global Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jyothishntg@gmail.com	1111111111	\N	\N	\N	5	45 Days	7	inprogress	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
977	Shafina M	 	\N	3.6 Yrs	Hash Include Innovations	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shafina.m90@gmail.com	1111111111	\N	\N	\N	5	Immediate	8	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
978	Amitha Mathew	 	\N	4.5 Yrs	RMESI	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amithakakkanattu@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Idukki	\N	\N	Cochin	\N	\N	\N
979	Nishamol P S	 	\N	12 Yrs	Equifax	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nishapramodkumar@gmail.com	1111111111	\N	\N	\N	5	90 Days	38	rejected	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
980	Riya Ann	 	\N	3 Yrs	UVJ	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	riyaas9883@gmail.com	1111111111	\N	\N	\N	5	Immediate	19	rejected	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
981	Sudeesh	 	\N	5.5 Yrs	Trensar Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	Cksudeesh1998@gmail.com	1111111111	\N	\N	\N	5	30 Days	19	back-off	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
982	Smrithi KS 	 	\N	5Years 	Bluesky Technologies 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	smrithyks357@gmail.com	1111111111	\N	\N	\N	5	Immediate 	13	rejected	\N	\N	Thrissur 	\N	\N	Trivandrum	\N	\N	\N
983	Tarun S 	 	\N	4Yrs	Ndimensios 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	taruns@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	23	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
984	Sneha Shaji 	 	\N	1Yrs 	Softnotions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	snehacshaji202@gmail.com	1111111111	\N	\N	\N	5	60 Days 	5	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
985	Mridul K Suresh 	 	\N	1Yr	SayOne Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mridulksuresh23@gmail.com	1111111111	\N	\N	\N	5	14 days 	5	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
986	Afsal Rahman	 	\N	5 Yrs	Palnar Transmedia 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	afsalrahman52@gmail.com	1111111111	\N	\N	\N	5	90 Days	19	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
987	Mohammed Shabeeb	 	\N	7 Yrs	 Dreamguys Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	m.shabeeb.at@gmail.com	1111111111	\N	\N	\N	5	30 Days	25	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
988	Vineeth E S	 	\N	2.8 Yrs	Datamate Infosolution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vineethes800@gmail.com	1111111111	\N	\N	\N	5	Immediate	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
989	Reeba	 	\N	5Yrs	RCG	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rreebatthomas@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Thiruvalla	\N	\N	Cochin	\N	\N	\N
990	Ajith P	 	\N	6Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajithp7560@gmail.com	1111111111	\N	\N	\N	5	Immediate	22	back-off	\N	\N	Pathanamthitta	\N	\N	Cochin	\N	\N	\N
991	Irsana	 	\N	6.4Yrs	Niira Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	irsananazeer@outlook.com	1111111111	\N	\N	\N	5	60 Days	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
992	Theertha 	 	\N	2.5Yrs 	ULTS 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	theertha98@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	23	back-off	\N	\N	Calicut	\N	\N	Trivandrum	\N	\N	\N
993	Vishak 	 	\N	4.3YEARS	Mariapps 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishakhkochiyil@gmail.com	1111111111	\N	\N	\N	5	60DAYS 	18	rejected	\N	\N	Malappuram	\N	\N	Trivandrum	\N	\N	\N
994	Akshaya A 	 	\N	5Years 	Sinergia 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akshaya010@gmail.com	1111111111	\N	\N	\N	5	15 Days 	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
995	Amal B 	 	\N	3.5yrs 	zlink 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amalnarippatta@gmail.com	1111111111	\N	\N	\N	5	1month 	29	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
996	Athira Gopi	 	\N	2.9 Yrs	Feathersoft	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athiragopi777@gmail.com	1111111111	\N	\N	\N	5	90 Days	28	rejected	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
997	Raju R Chandran	 	\N	20+ Yrs	Sorice Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	raju.r.chandran@gmail.com	1111111111	\N	\N	\N	5	15 Days	38	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
998	Adarsh Raghuvaran	 	\N	5.6 Yrs	Trensar Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	adarsh.reghuvaran@gmail.com	1111111111	\N	\N	\N	5	60 Days	2	inprogress	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
999	Anu Elizabath Shibu	 	\N	4.4 Yrs	Reflections Infosystems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anuelizabathshibu@gmail.com	1111111111	\N	\N	\N	5	60 Days	2	inprogress	\N	\N	Kottayam	\N	\N	Trivandrum	\N	\N	\N
1000	Faizal H	 	\N	2.8years 	Paranoia Systems International	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	faizalfaizyh@gmail.com	1111111111	\N	\N	\N	5	75 days 	21	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1001	Sreelakshmi 	 	\N	4.7YEARS	MUTHOOT MICROFIN 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreelakshmims3798@gmail.com	1111111111	\N	\N	\N	5	60 DAYS 	17	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1002	Sooraj VS 	 	\N	8Years 	PWC	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	soorajvs37@gmail.com	1111111111	\N	\N	\N	5	90 Days 	45	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1003	Teenu P	 	\N	6 Yrs	CGI	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	teenu.p7@gmail.com	1111111111	\N	\N	\N	5	Immediate	21	rejected	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
1004	Dhanesh K	 	\N	4 Yrs	XTG Technologies Pvt	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dhaneshkrd1998@gmail.com	1111111111	\N	\N	\N	5	60 Days	24	inprogress	\N	\N	Palakkad	\N	\N	Trivandrum	\N	\N	\N
1005	Lincy Devassy K	 	\N	4.8 Yrs	TCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	incydk7@gmail.com	1111111111	\N	\N	\N	5	Immediate	28	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1006	Mathews P Shaji	 	\N	4.5 Yrs	IDC	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	1995mathews@gmail.com	1111111111	\N	\N	\N	5	30 Days	7	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1007	Akhil Kumar K G	 	\N	11 Yrs	Emorass Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhilkumarkg@gmail.com	1111111111	\N	\N	\N	5	60 Days	45	inprogress	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
1008	Sooraj S	 	\N	4.10 Yrs	i n c r e d i b l e v i s i b i l i t y s o l u t i o n s	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	soorejsundar@gmail.com	1111111111	\N	\N	\N	5	30 Days	45	inprogress	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
1009	Aksa Cheriyan	 	\N	5 Yrs	Altaire Insights Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aksacherian29@gmail.com	1111111111	\N	\N	\N	5	60 Days	45	inprogress	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
1010	Anoop R Nair	 	\N	10 Yrs	2BASE TECHNOLOGIES	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anoopraveendran4@gmail.com	1111111111	\N	\N	\N	5	60 Days	14	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1011	SAYED  MUHAMMED  AAMIR 	 	\N	4 Yrs	Ruppells Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	pmaamirit@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1012	Sreedevi  S M	 	\N	7 Yrs	Stealth Guard	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreeammu94@gmail.com	1111111111	\N	\N	\N	5	30 Days	13	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1013	Benjamin Joy D  	 	\N	7 Yrs	PITS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	benjaminjoy1992@gmail.com	1111111111	\N	\N	\N	5	30 Days	39	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1014	Shanthi C	 	\N	7 Yrs	Agriculture Department 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shanthinambiar@gmail.com 	1111111111	\N	\N	\N	5	Immediate	21	inprogress	\N	\N	Malappuram	\N	\N	Cochin	\N	\N	\N
1015	Arun Paul	 	\N	3 Yrs	Navalt Soloar and Electric Boats Pvt. Ltd.	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	apaul7445@gmail.com	1111111111	\N	\N	\N	5	Serving Oct 19th Lwd	24	inprogress	\N	\N	Idukki	\N	\N	Cochin	\N	\N	\N
1016	Joy S	 	\N	3 Yrs	Techgencia Pvt ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	joysundaran15@gmail.com	1111111111	\N	\N	\N	5	Serving Lwd Nov 10th	19	rejected	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
1017	Midhun K S	 	\N	3 Yrs	Globeco Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	midhunks6666@gmail.com	1111111111	\N	\N	\N	5	60 Days	17	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1018	Muhammed Harshaqe	 	\N	2 Yrs	TECHNOWAVE ID SYSTEMS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arshakmuhammed1996@gmail.com	1111111111	\N	\N	\N	5	60 Days	17	inprogress	\N	\N	Malappuram	\N	\N	Cochin	\N	\N	\N
1019	RugmaK Manas	 	\N	11 Yrs	ELIXR LABS Technologies Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rugma83@gmail.com	1111111111	\N	\N	\N	5	60 Days	28	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1020	Anandhu M S	 	\N	3.8 Yrs	Trans Asia	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anandhums635@gmail.com	1111111111	\N	\N	\N	5	90 Days	28	rejected	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
1021	Anjana Anil	 	\N	2 yrs	CCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjanalachu2000@gmail.com	1111111111	\N	\N	\N	5	30 Days	28	rejected	\N	\N	Kollam	\N	\N	Cochin	\N	\N	\N
1022	Hareesh M	 	\N	9Yrs	Allianz	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	hareeshmgk@gmail.com	1111111111	\N	\N	\N	5	90 days	41	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1023	Latha P	 	\N	4Yrs	Cybrosis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lathatech23@gmailcom	1111111111	\N	\N	\N	5	90 days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1024	Sarath Sivadasan	 	\N	6Yrs	IBS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sarathsivadasanjr@gmail.com	1111111111	\N	\N	\N	5	90 days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1025	Revathy M	 	\N	4.5	Fingent	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	revathymohan3@gmail.com	1111111111	\N	\N	\N	5	90 days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1026	Sruthi Rajendra Babu	 	\N	2.4 Yrs	Techmaven IT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sruthiur1306@gmail.com	1111111111	\N	\N	\N	5	60 Days	17	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1027	Arun Alex	 	\N	7.7 Yrs	Logically Technology Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunalexkk@outlook.com	1111111111	\N	\N	\N	5	Serving Lwd Oct 15th	25	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1028	Bahar K V	 	\N	4.8 Yrs	Metric Tree Labs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bahar.cetmca@gmail.com	1111111111	\N	\N	\N	5	Immediate	25	inprogress	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1029	Vishal 	 	\N	5 Yrs 	Ndimensions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishalnair56@gmail.com	1111111111	\N	\N	\N	5	60 Days 	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1030	Ankitha 	 	\N	4Yrs 	Ndimensions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ankithas99@gmail.com	1111111111	\N	\N	\N	5	60 Days 	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1031	Karthik H 	 	\N	2.5Yrs 	ULTS 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	karthik9@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	23	back-off	\N	\N	Calicut	\N	\N	Trivandrum	\N	\N	\N
1032	Sruthi P 	 	\N	4Yrs 	CAMS Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sruthip89@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1033	Nithin Raghunathan	 	\N	12 Yrs	ELIXR LABS Technologies Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nithin011@gmail.com	1111111111	\N	\N	\N	5	30 Days	1	inprogress	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
1034	T V Anandhu Nair	 	\N	3.5 Yrs	Reflections Infosystems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	7025450378, 9074806385	1111111111	\N	\N	\N	5	60 Days	24	inprogress	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
1035	Rijas Raju	 	\N	2 Yrs	Loyal IT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rijassaju8089@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1036	S. Nallakannu	 	\N	11 Yrs	 STG infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nallait31@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	inprogress	\N	\N	Tirunelveli	\N	\N	Trivandrum	\N	\N	\N
1037	Hari S Lal	 	\N	8 Yrs	 Logical Steps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	harislal1988@gmail.com	1111111111	\N	\N	\N	5	30 Days	40	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1038	Remya R	 	\N	4 Yrs	SoftLand Pvt	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	111remya.sree@gmail.com	1111111111	\N	\N	\N	5	45 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1039	Nahla	 	\N	2.5Yrs	Technareus	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nahlaalikutty24@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	back-off	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1259	Hashique P	 	\N	7.6 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	hashi7p@gmail.com	1111111111	\N	\N	\N	5	30 Days	18	inprogress	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1040	Rizwan 	 	\N	4.3YEARS	Zoi Fintech 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mohammedrizwan@gmail.com	1111111111	\N	\N	\N	5	60DAYS 	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1041	Sivadas P 	 	\N	5Years 	Sinergia 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sivadasp@gmail.com 	1111111111	\N	\N	\N	5	15 Days 	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1042	Julie Jomon 	 	\N	7 Yrs	Stealth Guard	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	juliejomon97@gmail.com 	1111111111	\N	\N	\N	5	30 Days	13	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1043	Varsha P M	 	\N	2.3 Yrs	Urolime Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	varshapm313@gmail.com	1111111111	\N	\N	\N	5	Immediate	29	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1044	Saifali K T	 	\N	5 yRs	ACMO	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ktsaifali@gmail.com	1111111111	\N	\N	\N	5	Serving LWD Nov 29th)	25	back-off	\N	\N	Calicutt	\N	\N	Cochin	\N	\N	\N
1045	Anaghalekshmi K J	 	\N	2 Yrs	CCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anaghalakshmikj@gmail.com	1111111111	\N	\N	\N	5	90 Days	29	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1046	Arjun PV	 	\N	9Yrs	SOLWYZ TECHNOLOGIES	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arjunpv09@gmail.com	1111111111	\N	\N	\N	5	90 Days	29	rejected	\N	\N	Kannur	\N	\N	Trivandrum	\N	\N	\N
1047	Merin Saju 	 	\N	4.5years .netcore , msql 4.5years 	: Benzy Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jerinsebastian07@gmail.com	1111111111	\N	\N	\N	5	60 days 	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1048	Sarath	 	\N	6years, 2years.net core , sql -4-5yrs 	Buck, A Gallagher Company,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sarathmohanan005@gmail.com	1111111111	\N	\N	\N	5	60days	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1049	Alan Winson	 	\N	6YEARS, 4YEARS, SQL MVC  6YEARS 	ZERONE 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alanwinson7@gmail.com	1111111111	\N	\N	\N	5	IMMEDIATE 	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1050	Sooraj Suresh	 	\N	7 Months exp 	Softzane Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sooraj1116@gmail.com	1111111111	\N	\N	\N	5	Immediate 	27	rejected	\N	\N	Kollam 	\N	\N	Trivandrum	\N	\N	\N
1051	Anandhu Subash	 	\N	5years,  3years in 	pits 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anandhusubash96@gmail.com	1111111111	\N	\N	\N	5	90 days , 	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1052	Hareesh S	 	\N	5Yrs	Mariapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	hareeshs34@gmail.com	1111111111	\N	\N	\N	5	90 days	22	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1053	Neetha Mohan	 	\N	5Yrs	Pits Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethamtech@gmail.com	1111111111	\N	\N	\N	5	60 days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1054	Jibin Thampi	 	\N	7Yrs	Quest	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jibinthampitech4@gmailcom	1111111111	\N	\N	\N	5	60 days	21	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1055	Meenu S	 	\N	3Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	meenusankarmr@gmail.com	1111111111	\N	\N	\N	5	30 days	25	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1056	Shahnad S	 	\N	7 Yrs	Ateam info Soft Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nshahnad90@gmail.com	1111111111	\N	\N	\N	5	60 Days	40	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1057	Nimisha V A	 	\N	6 Yrs	Acsia Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nimisha.va.nrk@gmail.com	1111111111	\N	\N	\N	5	30 Days	7	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1058	Avinash T S	 	\N	2.3 Yrs	TechWyse IT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	 avinashts1122@gmail.com	1111111111	\N	\N	\N	5	Serving NP	22	inprogress	\N	\N	Wayanad	\N	\N	Cochin	\N	\N	\N
1059	Rahul T O	 	\N	9Yrs	FPLE Technologies Pvt. Ltd.	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahul1992rto@gmail.com	1111111111	\N	\N	\N	5	Immediate	39	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
1060	Aneeshkumar G	 	\N	3 Yrs	Epixel	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rajeshrajan18@gmail.com	1111111111	\N	\N	\N	5	90 Days	27	rejected	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
1061	Gopakumar	 	\N	2.4 Yrs	Simplogics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gopakumarg893@gmail.com	1111111111	\N	\N	\N	5	Immediate	22	rejected	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
1062	Vignesh K	 	\N	5 Yrs	Citrus Informatics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vigneshkrishnan4786@gmail.com	1111111111	\N	\N	\N	5	Immediate	28	rejected	\N	\N	Kottayam	\N	\N	Trivandrum	\N	\N	\N
1063	Sooraj R S	 	\N	8 Yrs	Scalgo Technologies Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sooraj.soorajrs@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1064	Athiramol Sali	 	\N	5 Yrs	Logic Plums	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athiramolsali94@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	rejected	\N	\N	Kottayam	\N	\N	Trivandrum	\N	\N	\N
1065	Jinu Kishore	 	\N	13Yrs	Equifax	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jinukishore@ gmail.com	1111111111	\N	\N	\N	5	90 days to 60 days	32	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1066	Jinitha S Babu	 	\N	5Yrs	Mariapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jinithasbabu32@gmail.com	1111111111	\N	\N	\N	5	60 days	22	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1067	Riya Thomas	 	\N	4Yrs	Quest	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	riyatomassr@gmail.com	1111111111	\N	\N	\N	5	60 days	21	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1068	Rejil Mathew	 	\N	4Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rejithmathew@gmail.com	1111111111	\N	\N	\N	5	30 days	25	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1069	Midhun KP	 	\N	3.6Yrs	Applaunch	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	midhunk059@gmail.com	1111111111	\N	\N	\N	5	30 days	22	inprogress	\N	\N	KOchi	\N	\N	Cochin	\N	\N	\N
1070	Siji Thampy	 	\N	12years 	IBS 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	itsmesiji@gmail.com	1111111111	\N	\N	\N	5	Immediate 	32	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1071	Subi N 	 	\N	4.7Years 	Ridhitech india Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	subi.niravil@gmail.com	1111111111	\N	\N	\N	5	30 Days 	33	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1072	Sarathlal V P	 	\N	5 Yrs	Nucore Software Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sarathlalvpniit@gmail.com	1111111111	\N	\N	\N	5	45 Days	28	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1073	Neethu S	 	\N	6 Yrs	PearlSoft Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethusnair2023@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1074	Sruthy Das	 	\N	7 Yrs	Gallagher Service	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sruthydas691@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1075	Vishnu H Nair	 	\N	3 Yrs	Bluo Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnuharikrishnan12@gmail.com	1111111111	\N	\N	\N	5	30 Days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1076	Heera K B	 	\N	3 Yrs	SQUAD Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	heerakbabu@gmail.com	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
1077	Vishnu R	 	\N	4.7 Yrs	Deepnetsoft solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnuprodev23@gmail.com	1111111111	\N	\N	\N	5	60 Days	22	inprogress	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
1078	Avinesh	 	\N	3.5 Yrr	Digital Mesh	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	avineshpamba@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	inprogress	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
1079	Joyal K	 	\N	3.4Yrs	Trenser Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	joyalthottan@gmail.com	1111111111	\N	\N	\N	5	90 Days	17	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1080	Midhun K	 	\N	4Yrs	Flexm	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	midhunksr@gmail.com	1111111111	\N	\N	\N	5	30 Days	17	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1081	Manu Chandra	 	\N	5+Yrs	Kameda iNfo	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	manuchandramathy@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	back-off	\N	\N	Pathanamthitta	\N	\N	Cochin	\N	\N	\N
1082	Advaitha Ravi	 	\N	5Yrs	Qburst	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	adwaitharavikj@gmail.com	1111111111	\N	\N	\N	5	60 days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1083	Midhila Mohan	 	\N	6Yrs	Inapp	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	midhilamohanm@gmailcom	1111111111	\N	\N	\N	5	90 Days	28	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1084	Anjali S 	 	\N	4.5years .netcore , msql 4.5years 	: Benzy Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjalis@gmail.com	1111111111	\N	\N	\N	5	60 days 	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1085	Sreerag ps 	 	\N	4Years 	Applaunch Business Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreerags98@gmail.com 	1111111111	\N	\N	\N	5	Immediate 	29	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1086	Ajmal	 	\N	10years, microservices - 10years , 15years, 13-14 yrs 	IBM 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajajmal@gmail.com	1111111111	\N	\N	\N	5	Immediate 	38	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1087	Jinomon Satheesan	 	\N	5.5 Yrs	Adroitminds Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jinomonsatheesan@gmail.com	1111111111	\N	\N	\N	5	90 Days	30	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1088	Muhammad Faisal	 	\N	5 Yrs	Codelynks Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vgamfaisal@gmail.com	1111111111	\N	\N	\N	5	Immediate	30	inprogress	\N	\N	Malappuram	\N	\N	Cochin	\N	\N	\N
1089	Vishnu V K	 	\N	12 Yrs	Epixel Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnuvijayan239@gmail.com	1111111111	\N	\N	\N	5	30 Days	45	inprogress	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
1090	Athira Balakrishnan	 	\N	\N	Techtaliya Informatics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athirapkrishnan@gmail.com	1111111111	\N	\N	\N	5	30 Days	19	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1091	Rojin	 	\N	3 Yrs	Tactus Ventures	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rojin007.rr@gmail.com	1111111111	\N	\N	\N	5	30 Days	22	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1092	Thahira	 	\N	4.4 Yrs	Elkanio Research Labs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	thahira.abdulrahim@gmail.com	1111111111	\N	\N	\N	5	TL	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1093	Meera C Nair	 	\N	7 Yrs	Ateam Soft Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	cmeerac@gmail.com	1111111111	\N	\N	\N	5	Immediate	19	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1094	Akhila C Sivan	 	\N	5.3 Yrs	Sayone Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhilacsivan94@gmail.com	1111111111	\N	\N	\N	5	Immediate	17	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1095	Sruthi Rajendra Babu	 	\N	2.4 Yrs	Techmaven IT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sruthirajendrababu@mail.com	1111111111	\N	\N	\N	5	60 Days	17	inprogress	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
1096	Jasentha Jose	 	\N	7.9 yrs	Emsyne	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jassenthajose@gmail.com	1111111111	\N	\N	\N	5	90 Days	38	inprogress	\N	\N	Idukki	\N	\N	Cochin	\N	\N	\N
1097	Amrutha	 	\N	5 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amruthasuku96@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
1098	Gince George	 	\N	7.10 Yrs	 Infosmart Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ginceperunilam@gmai.com	1111111111	\N	\N	\N	5	30 Days	21	inprogress	\N	\N	Idukki	\N	\N	Cochin	\N	\N	\N
1099	Sreejith	 	\N	12Yrs	Envestnet	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreejithmani63@yahoo.in	1111111111	\N	\N	\N	5	90 Days	21	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1100	Girish S	 	\N	5+Yrs	Pits Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	girishs@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1101	Bibitha Suresh	 	\N	7Yrs	Qburst	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bibithasureshsr@gmail.com	1111111111	\N	\N	\N	5	60 days	25	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1102	Harith S Kumar	 	\N	6Yrs	Inapp	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	harithaharikumar@gmail.com	1111111111	\N	\N	\N	5	90 Days	29	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1103	Maris Baby 	 	\N	2Yrs 	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	marisbaby18@gmail.com	1111111111	\N	\N	\N	5	30 Days 	17	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1104	Nikhila Sivan 	 	\N	6YEARS, 4YEARS, SQL MVC  6YEARS 	ZERONE 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nikilasivan88@gmail.com 	1111111111	\N	\N	\N	5	IMMEDIATE 	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1105	Uthara Sreekumar	 	\N	5Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	utharasreekumarsr@gmail.com	1111111111	\N	\N	\N	5	60 days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1106	Archana M	 	\N	5+Yrs	Pits Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	archanams@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1107	Shanu S	 	\N	7Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shanustech4@gmail.com	1111111111	\N	\N	\N	5	60 days	25	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1108	Aiswarya Mohan	 	\N	6Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aiswarys34@gmail.com	1111111111	\N	\N	\N	5	90 Days	29	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1109	Jerin Thomas	 	\N	5 Yrs 	Ndimensions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jerinthomas09gamil.com	1111111111	\N	\N	\N	5	60 Days 	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1283	Alex	 	\N	6 Yrs	Finobase	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alextelias@gmail.com	1111111111	\N	\N	\N	5	30 Days	29	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1110	Saranya V 	 	\N	2.5Yrs 	ULTS 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	saranyasreekumar@gmail.com	1111111111	\N	\N	\N	5	60 Days 	23	rejected	\N	\N	Calicut	\N	\N	Trivandrum	\N	\N	\N
1111	Reshma Suresh 	 	\N	3 Yrs	SQUAD Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmasuresh@gmail.com 	1111111111	\N	\N	\N	5	30 Days	13	back-off	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
1112	Amar R	 	\N	5 Yrs	Zoifintech Service	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amarramamoorthy@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Tirunelveli	\N	\N	Trivandrum	\N	\N	\N
1113	Sreenath P N	 	\N	5 Yrs	Zoondia Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreenathpnofficial@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-30th Nov)	19	rejected	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
1114	Saumya Markose	 	\N	2.9 Yrs	Kenland	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	saumya.m561@gmail.com	1111111111	\N	\N	\N	5	30 Days	28	back-off	\N	\N	Idukki	\N	\N	Trivandrum	\N	\N	\N
1115	Ashiq Sabith	 	\N	3 Yrs	Signal Zero Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	a shiqsabith328@gmail.com	1111111111	\N	\N	\N	5	30 Days	8	inprogress	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1116	Lincy Devassy K	 	\N	4.8 Yrs	TCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lincydk7@gmail.com	1111111111	\N	\N	\N	5	Immediate	19	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1117	Sribin K K	 	\N	3.2 Yrs	Marriapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sribinkk26@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	rejected	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
1118	Krishna Prabha	 	\N	5 Yrs	Xminds Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	prabhadevi2505@gmail.com	1111111111	\N	\N	\N	5	30 Days	30	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1119	Keerthana S	 	\N	5Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	keerthanasr@gmail.com	1111111111	\N	\N	\N	5	60 days	21	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1120	Jinu S Babu	 	\N	6Yrs	Niira Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jinustech@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1121	Shikha S	 	\N	5Yrs	InApp	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shikhasbabumy@gmail.com	1111111111	\N	\N	\N	5	60 days	22	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1122	Abhishek M	 	\N	4Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abhishekmr@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1123	Titty Sebastian	 	\N	12Yrs	SE Mentor	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	titty14nov@gmail.com	1111111111	\N	\N	\N	5	45 days to 60	3	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1124	Issac Peter Cherian	 	\N	8Yrs 	Infosys 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	issacpc3@gmail.com	1111111111	\N	\N	\N	5	90 days 	17	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1125	Shaima 	 	\N	7Years 	Tuna Software Solutions,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	m.rshaima1234@gmaiI.com	1111111111	\N	\N	\N	5	60 days 	30	inprogress	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
1126	Kaviya A	 	\N	4.8 Yrs	Capestart	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kaviyakk246@gmail.com	1111111111	\N	\N	\N	5	90 Days	25	rejected	\N	\N	Kanyakumari	\N	\N	Trivandrum	\N	\N	\N
1127	Reshmi Ravi	 	\N	5Yrs	CTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	reshmiravi2@gmail.com	1111111111	\N	\N	\N	5	60 days	21	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1128	Arun Mohan	 	\N	6Yrs	Pits Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunmohantech@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1129	Anjana Deepak	 	\N	5Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjanakr@gmail.com	1111111111	\N	\N	\N	5	60 days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1130	Anjali Raju	 	\N	4Yrs	Cybrosis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjalydb2@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1131	Midhun S 	 	\N	5 Yrs 	Ndimensions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	midhuns@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1132	Joseph Seby 	 	\N	4.5years .netcore , msql 4.5years 	: Benzy Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	josephseby@gmail.com 	1111111111	\N	\N	\N	5	60 days 	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1133	Sreepriya S 	 	\N	5 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreepriyasreekumar@gmail.com 	1111111111	\N	\N	\N	5	30 Days	23	inprogress	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
1134	Santhosh Joy	 	\N	4 Yrs	Sayone Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	santojoyful@gmail.com	1111111111	\N	\N	\N	5	Immediate	27	inprogress	\N	\N	Idukki	\N	\N	Cochin	\N	\N	\N
1135	Rahul Raj	 	\N	4.5 Yrs	WAC	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahulrajeb@gmail.com	1111111111	\N	\N	\N	5	30 Days	4	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1136	Shamjith A K	 	\N	3.11 Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shamjithak4597@gmail.com	1111111111	\N	\N	\N	5	60 Days	4	rejected	\N	\N	Wayanad	\N	\N	Cochin	\N	\N	\N
1137	John Bright	 	\N	8 Yrs	Igen Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	johnbright03@gmail.com	1111111111	\N	\N	\N	5	15-30 Days	14	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1138	Justin James	 	\N	7 Yrs	Learning Integration for Education	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	justinjamesrdrgz@gmail.com	1111111111	\N	\N	\N	5	30 Days	14	inprogress	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
1139	Kshanith Prakash	 	\N	5 Yrs	Leeyet Technohub	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kshanith965@gmail.com	1111111111	\N	\N	\N	5	Immediate	22	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1140	Neethu P Soman	 	\N	3 Yrs	Quest	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethupsoman1@gmail.com	1111111111	\N	\N	\N	5	Immediate	24	rejected	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
1141	Swathy S	 	\N	6Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	swathysd@gmail.com	1111111111	\N	\N	\N	5	60 days	21	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1142	Karthik	 	\N	4.7Yrs	Art Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	karthiktech2@gmail.com	1111111111	\N	\N	\N	5	60 days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1143	Ansal	 	\N	4.6Yrs	Bridge Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ansalfrd@gmail.com	1111111111	\N	\N	\N	5	60 days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1144	Jinu Kishore	 	\N	13Yrs	Equifax	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jinushrkishor@gmail.com	1111111111	\N	\N	\N	5	90 Days	32	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1145	Varun V 	 	\N	4.6years	Guidehouse 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	varunvikraman1995@gmail.com	1111111111	\N	\N	\N	5	immediate 	18	inprogress	\N	\N	kollam 	\N	\N	Trivandrum	\N	\N	\N
1146	Jini Mathew 	 	\N	6YEARS, 4YEARS, SQL MVC  6YEARS 	ZERONE 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jinimathew@gmail.com 	1111111111	\N	\N	\N	5	IMMEDIATE 	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1147	Dhanush Krishna 	 	\N	3.5Yrs 	Xillegence 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dhanushkrishnan998@gmail.com	1111111111	\N	\N	\N	5	60 Days 	25	inprogress	\N	\N	Trivandrum	\N	\N	Cochin	\N	\N	\N
1148	Jaisymol Augustine 	 	\N	8Years 	Charter Mercantile Pty Ltd, Kakkanad	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jaisy.1489@gmail.com	1111111111	\N	\N	\N	5	60 Days 	14	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1149	Anand Sreedhar 	 	\N	8years	Qworks Technologies Pvt. Ltd.,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anandsreedhar24@gmail.com	1111111111	\N	\N	\N	5	60 Days 	3	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1150	Dinu Daniel	 	\N	18 Yrs	Airpay	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dinudanial@gmail.com	1111111111	\N	\N	\N	5	90 Days	3	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1151	Subash V	 	\N	5.8 Yrs	Impiger Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vsubaash@gmail.com	1111111111	\N	\N	\N	5	90 Days	4	inprogress	\N	\N	Coimbatore	\N	\N	Cochin	\N	\N	\N
1152	Ajay Jose	 	\N	4.1 Yrs	Revire Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajayjose077@gmail.com	1111111111	\N	\N	\N	5	90 Days	4	inprogress	\N	\N	Kanyakumari	\N	\N	Cochin	\N	\N	\N
1153	Joel Jose	 	\N	4.3 Yrs	Chillar Payments	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	joeljose555@gmail.com	1111111111	\N	\N	\N	5	60 Days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1154	Akshay Raj	 	\N	4 Yrs	Web And Craft	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jaakshayraj@gmail.com	1111111111	\N	\N	\N	5	30 Days	25	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1155	Ajay G	 	\N	8 Yrs	ZH Health care	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajayvamanapuram@gmail.com	1111111111	\N	\N	\N	5	Dec 4th LWD	25	rejected	\N	\N	Trivandrum	\N	\N	Cochin	\N	\N	\N
1156	K S Akhila	 	\N	4.5 Yrs	Electropack General Trading L L C	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ksakhilaofcl@gmail.com	1111111111	\N	\N	\N	5	Immediate	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1157	Vineeth 	 	\N	14years , .netcore - 11years 	with BigLittle Innovations	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kvinuvineeth@gmail.com	1111111111	\N	\N	\N	5	immediate 	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1158	Vimal Krishna V 	 	\N	2years, 	TIC Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vimalkrishna091@gmail.com	1111111111	\N	\N	\N	5	30 Days 	13	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1159	Greeshma	 	\N	7Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	greeshmajohnsont@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1160	Anamika	 	\N	4Yrs	Mariapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anamikamenon078@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1161	Siila	 	\N	7Yrs	Lean Transition	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sillakayathinkal@gmail.com	1111111111	\N	\N	\N	5	90 Days	22	back-off	\N	\N	Wayanad	\N	\N	Cochin	\N	\N	\N
1162	Amal NK	 	\N	2.6Yrs	Confianz	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amalntk07@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
1163	Sreelakshmi S 	 	\N	2Yrs 	ULTS 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreelakshmis@gmail.com 	1111111111	\N	\N	\N	5	60 Days	23	back-off	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1164	Joseph Jolly 	 	\N	5Yrs 	Zerone Consulting Pvt Ltd 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	josephj@gmail.com 	1111111111	\N	\N	\N	5	60 Days	18	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1165	Shibin Mariyan Stanly	 	\N	6.5 Yrs	Suyathi	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shibinmariyanstanley@gmail.com	1111111111	\N	\N	\N	5	Immediate	37	inprogress	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
1166	Abhinesh Raja	 	\N	9 Yrs	Freston Analytics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abineshraja.peter@gmail.com	1111111111	\N	\N	\N	5	90 Days	21	inprogress	\N	\N	Kanyakumari	\N	\N	Trivandrum	\N	\N	\N
1167	Vimesh C	 	\N	10 Yrs	Trusttech Solutions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vimeshc13@gmail.com	1111111111	\N	\N	\N	5	45 Days	3	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1168	Sreeja Lin	 	\N	6.6 Yrs	 Gadgeon Smart Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreejalin@gmail.com	1111111111	\N	\N	\N	5	30 Days	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1169	Aswathy V M	 	\N	7 Yrs	NeST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswathyvm13@gmail.com	1111111111	\N	\N	\N	5	30 Days	18	inprogress	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
1170	Noufal J	 	\N	5Yrs	Speridian	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	noufaljs@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1171	Neethu S	 	\N	4Yrs	Pits Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethustech4@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1172	Jayashankar	 	\N	6.5Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jayashankarst@gmail.com	1111111111	\N	\N	\N	5	90 Days	22	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1173	Athira AS	 	\N	7Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	athirasrh@gmail.com	1111111111	\N	\N	\N	5	90 Days	25	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1174	Gayathri Sreekumar	 	\N	1.3.7Yrs	Zyxware Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gayathri.sreekumars@gmail.com	1111111111	\N	\N	\N	5	60 days Nego 30 days	16	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1175	Jibin Jose 	 	\N	4Yrs 	M Squared Software & Services Pvt. Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	· jibinjose173@gmail.com	1111111111	\N	\N	\N	5	60 Days	13	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1176	Vinesh Saju	 	\N	13.6 Yrs	Beo Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vinesh.saju@gmail.com	1111111111	\N	\N	\N	5	90 Days (Neg to 30 days)	16	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1177	Jeo Mathew	 	\N	5.6 Yrs	Practise Suite	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	Jeo@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1178	Shikha Nair	 	\N	4.4 Yrs	H&R	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nairshikha20@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1179	Prathibha P Nair	 	\N	7YEARS , NO EXP IN MVC , 7YEARS IN SQL , SP. NET , SESHA , NO EXP .NET CORE	SBN Technologics,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	prathibha2pnair@gmail.com	1111111111	\N	\N	\N	5	90 DAYS 	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1180	Suhail	 	\N	3years in php 	TechWyse IT Solutions.	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	suhailsharafudheen2@gmail.com	1111111111	\N	\N	\N	5	immediate 	13	rejected	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
1181	SACHIN RENJITH	 	\N	3years , angular 2.5years, 	Touchworld Technologies Pvt Ltd,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sachinrenjith08@gmail.com	1111111111	\N	\N	\N	5	immediate 	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1182	ARYA A P	 	\N	3.5Years 	Quest	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aryaap2020@gmail.com	1111111111	\N	\N	\N	5	Immediate 	34	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1183	Sophy George	 	\N	6 Yrs	Cubet Technolabs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sophygeorge000@gmail.com	1111111111	\N	\N	\N	5	45 Days	4	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1184	Sreenath MK 	 	\N	9Years 	Fakeeh Technologies,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	Sreenathan595@gmail.com	1111111111	\N	\N	\N	5	90 Days 	16	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1185	Sujith J	 	\N	12 Yrs	Additional Skill Acquisition Programme 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	 sujith006@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-10th Nov)	3	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1186	Beema Basheer	 	\N	2.6 Yrs	STANDOUT IT SOLUTIONS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	beemabasheer79@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-31st Oct)	27	rejected	\N	\N	Kottayam	\N	\N	Trivandrum	\N	\N	\N
1187	Sherin Thomas	 	\N	10 Yrs	Maxwell Geo Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sherinthomas0062@gmail.com	1111111111	\N	\N	\N	5	60 Days	11	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1188	Neethu C S	 	\N	7 Yrs	Codepoint softwares	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethusreenivasan22@gmail.com	1111111111	\N	\N	\N	5	Immediate	18	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1189	Midhun Mohan P	 	\N	7.10 Yrs	Trianz Digital Consulting	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	midhunmomihan@gmail.com	1111111111	\N	\N	\N	5	Immediate	4	rejected	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
1190	Nijil Raj N R	 	\N	5.5 Yrs	GIZMEON TECHNOLOGIES	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nijil.nr@gmail.com	1111111111	\N	\N	\N	5	45 Days	30	inprogress	\N	\N	Wayanad	\N	\N	Cochin	\N	\N	\N
1191	Jerin Sebastian 	 	\N	4.5years .netcore , msql 4.5years 	: Benzy Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jerinsebastian@gmail.com	1111111111	\N	\N	\N	5	60 days 	18	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1192	Vijay V 	 	\N	2years, 	TIC Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vijay@gmail.com 	1111111111	\N	\N	\N	5	30Days 	13	back-off	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1193	Risin Arrakal	 	\N	10 Yrs	Teknowmics Knowledge Solutions,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	risin.arakkal1992@gmail.com	1111111111	\N	\N	\N	5	60 Days	16	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1194	Navas Sherif	 	\N	3 Yrs	Sofiyer Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	navasnechiyan3@gmail.com	1111111111	\N	\N	\N	5	Immediate	27	rejected	\N	\N	Malappuram	\N	\N	Cochin	\N	\N	\N
1195	Thomas Jebadurai	 	\N	15 Yrs	Speridian Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	thomasjebadurai@gmail.com	1111111111	\N	\N	\N	5	60 Days	3	inprogress	\N	\N	Thoothukudi	\N	\N	Trivandrum	\N	\N	\N
1196	Sindoora S	 	\N	3 Yrs	McMillan Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sindoorasatheesan97@gmail.com	1111111111	\N	\N	\N	5	60 Days	23	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
1197	Chinchu S	 	\N	3.8 Yrs	Greenbay IT Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	chinchus@mail.com	1111111111	\N	\N	\N	5	Immediate	35	inprogress	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
1198	Karthika S 	 	\N	2years, 	TIC Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	karthikas@gmail.com	1111111111	\N	\N	\N	5	30Days 	18	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1199	Jaison Mathews	 	\N	2years, 	TIC Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jaisonmthews89@gmail.com	1111111111	\N	\N	\N	5	30Days 	13	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1200	Samitha Rasal	 	\N	13 Yrs	Forefront Solutions & Consultancies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	samithar70@gmail.com	1111111111	\N	\N	\N	5	30 Days	16	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1201	Hadiya Anvar	 	\N	4.3 Yrs	SourceFuse Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	hadi.hanna75@gmail.com	1111111111	\N	\N	\N	5	60 Days	4	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1202	Sarath V	 	\N	5.6 Yrs	CapeStart	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sarathvictor5@gmail.com	1111111111	\N	\N	\N	5	30 Days	7	rejected	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
1203	Dileep G G	 	\N	14.4 Yrs	Onetikk Onetikk Consultants Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dileepgg@gmail.com	1111111111	\N	\N	\N	5	Immediate	3	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1204	Rosemol Jose	 	\N	6.6 Yrs	Pits Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rosemoljose332@gmail.com	1111111111	\N	\N	\N	5	90 Days	4	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1205	Alan Vinu Abraham	 	\N	6 Yrs	Travancore Analytics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alanvinuabraham@gmail.com	1111111111	\N	\N	\N	5	90 Days	27	inprogress	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
1206	Amal Thomas	 	\N	4Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amalthomasmr@gmail.com	1111111111	\N	\N	\N	5	90 days nego 60	18	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1207	Jibin Mohan	 	\N	4Yrs	Armia Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jibinmohaner@gmail.com	1111111111	\N	\N	\N	5	90 Days	25	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1208	Nima s	 	\N	3.5Yrs	Inapp	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nimsdhr@gmail.com	1111111111	\N	\N	\N	5	30 days	13	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1209	Revathy 	 	\N	6Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	revathyfs@gmail.com	1111111111	\N	\N	\N	5	90 days	29	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1210	Vyas D A	 	\N	10.4 Yrs	Azentio Software 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vyasamat5@gmail.com	1111111111	\N	\N	\N	5	60 Days	11	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1211	Sailesh R	 	\N	19 Yrs	SCG Digital	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sailesh.ravikumar@gmail.com	1111111111	\N	\N	\N	5	60 Days	16	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1212	Manoj.N.B	 	\N	11 Yrs	 Xerox Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nbmanoj@gmail.com	1111111111	\N	\N	\N	5	30 Days	35	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1213	Akhilesh P	 	\N	7 Yrs	Chris Johnson	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhileshmp.soft@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1214	Kiran S 	 	\N	2years, 	TIC Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kirans@gmail.com	1111111111	\N	\N	\N	5	30Days 	18	back-off	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1215	Ananya 	 	\N	7Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ananya@gmail.com 	1111111111	\N	\N	\N	5	90 Days	29	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1216	Saranya S	 	\N	12 Yrs	Inapp Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	saranyas@mail.com	1111111111	\N	\N	\N	5	60 Days	16	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1217	Jishnu M K	 	\N	5 Yrs	Hodo medical informatic solution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jishnumkkayani@gmail.com	1111111111	\N	\N	\N	5	30 Days	33	rejected	\N	\N	Kannur	\N	\N	Trivandrum	\N	\N	\N
1218	Lakshmi Raj	 	\N	6.5 Yrs	Test House	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lekshmiraj12@gmail.com	1111111111	\N	\N	\N	5	Immediate	6	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1219	Jayachristhudas	 	\N	9 yrs	Verbat Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jayachristudasdl@gmail.com	1111111111	\N	\N	\N	5	Serving NP Lwd Nov 30th	18	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1220	Aravind K	 	\N	7 Yrs	Empress Cybernetic Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aravindkumarlotus@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	inprogress	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
1221	Gilbert P S	 	\N	8.3 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gilbertps007@gmail.com	1111111111	\N	\N	\N	5	30 Days	4	inprogress	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1222	Mohseenali N K	 	\N	11 Yrs	Zaimus Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mohseennk@gmail.com	1111111111	\N	\N	\N	5	30 Days	14	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1223	Nimeesh Koshy	 	\N	2.4 Yrs	Paranoia Systems INternatinal	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nimeeshkoshy400@gmail.com	1111111111	\N	\N	\N	5	Immediate	17	inprogress	\N	\N	Calicut	\N	\N	Trivandrum	\N	\N	\N
1224	Charlson Peter	 	\N	6 Yrs	SEQATO Software	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	charlsonpeter@yahoo.com	1111111111	\N	\N	\N	5	90 Days	27	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1225	Jomon P Thomas	 	\N	6 Yrs	Cynque Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jomonrockingstar@gmail.com	1111111111	\N	\N	\N	5	60 Days	4	back-off	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
1226	Ashik AU 	 	\N	3Yrs 	Simelabs 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	auashik.connect@gmail.com	1111111111	\N	\N	\N	5	60 Days 	17	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1227	Kalesh M	 	\N	5.5Yrs	Mariapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kaleshnr@gmail.com	1111111111	\N	\N	\N	5	90 days nego 60	21	rejected	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1228	Prathibha	 	\N	4Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	prathibhasr@gmail.com	1111111111	\N	\N	\N	5	30 days	22	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1229	Nikhil SR	 	\N	3Yrs	Cybrosis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nikhilsd@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1230	Arjun G R	 	\N	1.8 Yrs	Zesty Beans	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	govardhanam987@gmail.com	1111111111	\N	\N	\N	5	60 Days	23	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1231	Khaleel I K	 	\N	7.5 Yrs	Aspire Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	khalisaina@gmail.com	1111111111	\N	\N	\N	5	90 Days	43	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1232	Fremin Francis	 	\N	9.10 Yrs	zerone consulting	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	fremintcr@gmail.com	1111111111	\N	\N	\N	5	Serving Lwd Dec 21st	18	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1233	Megha Ramesh	 	\N	6.4 Yrs	Beinex Consulting	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	megharemesh@gmail.com	1111111111	\N	\N	\N	5	90 Days	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1234	Sijesh Babu K K	 	\N	5 Yrs	Thougt Line	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sijeshbabu18@gmail.com	1111111111	\N	\N	\N	5	30 Days	25	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
1235	Mithun K Vinayan	 	\N	7.10 Yrs	BENZY INFOTECH	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mithunkvinayan111@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	inprogress	\N	\N	Idukki	\N	\N	Cochin	\N	\N	\N
1236	Riya Jose	 	\N	7.4 Yrs	Tata Elxsi	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	riyatreesajose@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-7th Jan)	4	inprogress	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
1237	Amrutha M S	 	\N	5 Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	3amruthasuku96@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
1238	Lekshmi Sree	 	\N	5 Yrs	Kefitech Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lekshmisree777@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	back-off	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
1239	Vasan	 	\N	5 Yrs	Venpep Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vasan@mail.com	1111111111	\N	\N	\N	5	Immediate	27	inprogress	\N	\N	Coimbatore	\N	\N	Cochin	\N	\N	\N
1240	Subashini A	 	\N	3 Yrs	TVM infotech 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	subashinisaran6@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	inprogress	\N	\N	Trivandrum	\N	\N	Cochin	\N	\N	\N
1241	Sutha Pakiya Grace	 	\N	2 Yrs	Vcinch Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	suthajones28@gmail.com	1111111111	\N	\N	\N	5	30 Days	25	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1242	Rabeka	 	\N	9 Yrs	Reflections	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rabekajacob@gmail.com	1111111111	\N	\N	\N	5	Immediate	19	rejected	\N	\N	Idukki	\N	\N	Cochin	\N	\N	\N
1243	Neethu balachadran	 	\N	13.4 Yrs	Reflections	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethubalachadran@mail.com	1111111111	\N	\N	\N	5	Immediate	35	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1244	Rameeza Rahim	 	\N	7 Yrs	RMESI	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rameezarahim@mail.com	1111111111	\N	\N	\N	5	60 Days	18	inprogress	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
1245	Rinoj	 	\N	3.2 Yrs	Techware lab pvt ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rinojalappadan.001@gmail.com	1111111111	\N	\N	\N	5	Immediate	22	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1246	Nancy Micheal	 	\N	6 Yrs	Quest Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nancymicheal333@gmail.com	1111111111	\N	\N	\N	5	90 Days	27	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1247	Bavya 	 	\N	-	-	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bavyagangadharan.v@gmail.com	1111111111	\N	\N	\N	5	Immediate	35	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1248	Revathy M	 	\N	5Yrs	Inapp	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	revathysree@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1249	Swathy	 	\N	10Yrs	Infosys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	swathysr@gmail.com	1111111111	\N	\N	\N	5	90 days nego 60	35	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1250	Mathew Xavier	 	\N	4.3Yrs	Aspire Systems	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mathewxavier@gmailcom	1111111111	\N	\N	\N	5	60 days	22	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1251	Jithin	 	\N	3Yrs	Alphalize	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jithisrtech@gmail.com	1111111111	\N	\N	\N	5	30 days	22	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1252	Prakash N	 	\N	13 yrs	Reflections	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	prakashfromtvpm@gmail.com	1111111111	\N	\N	\N	5	IMMEDIATE	38	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1253	Neenu Venugopal	 	\N	4 Yrs	Mysearch Global Rewards	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neenu.kyk@gmail.com	1111111111	\N	\N	\N	5	30 Days	4	inprogress	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
1254	Riju John 	 	\N	16Yrs 	UST 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rijujohn55@gmail.com	1111111111	\N	\N	\N	5	60 Days 	16	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1255	Anju A 	 	\N	14Yrs 	Nest Stratium	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anju.pkd@gmail.com	1111111111	\N	\N	\N	5	IMMEDIATE	16	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1256	Devika RS 	 	\N	4Months 	Srishti Innovative 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	devuv1234@gmail.com	1111111111	\N	\N	\N	5	IMMEDIATE	35	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1257	Vinishma 	 	\N	2Yrs 	Hodo medical informatic solution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vinishmam@gmail.com	1111111111	\N	\N	\N	5	30 Days	33	rejected	\N	\N	Kannur	\N	\N	Trivandrum	\N	\N	\N
1258	Tinju	 	\N	5 Yrs	CLOUD NAUTICAL SOLUTION	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	tinjusamuel697@gmail.com	1111111111	\N	\N	\N	5	30 Days	33	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1260	Greeshma Prakasan	 	\N	5 Yrs	UST	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	greeshma.prakashk@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1261	Nithin Prakash	 	\N	10 Yrs	 Citrus Informatics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nithinp0204@gmail.com	1111111111	\N	\N	\N	5	30 Days	7	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1262	Rincy Roy	 	\N	4Yrs 	Reflections 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rincyroy@gmail.com 	1111111111	\N	\N	\N	5	60 Days 	19	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1263	Sreelakshmi S 	 	\N	5Yrs 	Kefitech Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreelakshmisk@gmail.com	1111111111	\N	\N	\N	5	60 Days 	27	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1264	Vibin VB 	 	\N	6Yrs 	Guidehouse 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vipinvijayan00@yahoo.com	1111111111	\N	\N	\N	5	60 Days 	4	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1265	Jerin James 	 	\N	2Yrs 	Next Gen Pro 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jerinjames707@gmail.com	1111111111	\N	\N	\N	5	IMMEDIATE	13	rejected	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
1266	Deepa C	 	\N	8Yrs	Envestnet	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	deepa.94krishna@gmail.com	1111111111	\N	\N	\N	5	30 days	16	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1267	Karthik	 	\N	8.5Yrs	Cabot Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	skkarthik0062@gmail.com	1111111111	\N	\N	\N	5	30 days	39	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1268	Denis Mathew	 	\N	5Yrs	Gadgeon	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	denismathewsr@gmail.com	1111111111	\N	\N	\N	5	60 days	28	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1269	Rekha S Nair	 	\N	4.5Yrs	ULTS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rekhsnairm@gmail.com	1111111111	\N	\N	\N	5	60 days	5	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1270	Shibin Kumar	 	\N	6.5Yrs	Socious	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shibinkumartech@gmail.com	1111111111	\N	\N	\N	5	60 days	23	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1271	Abin Abraham	 	\N	10 Yrs	Hash Include	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abinmullothu@gmail.com	1111111111	\N	\N	\N	5	Immediate	11	inprogress	\N	\N	Kottayam	\N	\N	Trivandrum	\N	\N	\N
1272	Ajith M	 	\N	6 Yrs	PITS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	 ajithmdhas@gmail.com	1111111111	\N	\N	\N	5	60 Days	24	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1273	Aswathy Umesh	 	\N	12 Yrs	Emvigo Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswathiumesh@gmail.com	1111111111	\N	\N	\N	5	90 Days	3	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1274	Shany Thomas	 	\N	13 Yrs	Finobase Global Solutions Pvt.Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shanikandanad@gmail.com	1111111111	\N	\N	\N	5	Serving Lwd Nov 14th	43	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1275	Arjun K	 	\N	10.4Yrs	Simelabs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arjunchandra1990@gmail.com	1111111111	\N	\N	\N	5	60 days Nego 30	38	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1276	Vipin M	 	\N	11Yrs	Neudesic	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vipinms31589@gmail.com	1111111111	\N	\N	\N	5	60 days	38	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1277	Sreeraj Madatheri	 	\N	12 Yrs	Inspired Gaming	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreerajmadatheri@gmail.com	1111111111	\N	\N	\N	5	Immediate	38	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1278	Ajith Venu	 	\N	6.5 Yrs	 Trigyn Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajvenu@outlook.com	1111111111	\N	\N	\N	5	60 Days	4	inprogress	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
1279	Muhammed Asif P	 	\N	6 Yrs	HubSpire	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	asifpmn@gmail.com	1111111111	\N	\N	\N	5	30 Days	22	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1280	Anahatha 	 	\N	2Yrs 	WAY.COM 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anahathakalyani@gmail.com	1111111111	\N	\N	\N	5	Immediate	35	back-off	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1281	Ajay K	 	\N	14 Yrs	Wipro	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajayk@mail.com	1111111111	\N	\N	\N	5	Immediate	16	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1282	Ajimol T R	 	\N	9.2 Yrs	Thinkpalm Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajimoltr@mail.com	1111111111	\N	\N	\N	5	90 Days	4	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1284	Arathi 	 	\N	1Year 	Icwares Systems and Softwares Ltd,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arathindas98@gmail.com	1111111111	\N	\N	\N	5	Immediate	35	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1285	Deepa Thomas 	 	\N	1Year 	iROID Technologies,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	deepatreesathomas14@gmail.com	1111111111	\N	\N	\N	5	Immediate	9	inprogress	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
1286	Afsana Rahath	 	\N	Fresher 	-	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahathafsana7@gmail.com	1111111111	\N	\N	\N	5	Immediate	9	rejected	\N	\N	Kollam 	\N	\N	Trivandrum	\N	\N	\N
1287	Nikhil MS 	 	\N	Fresher 	-	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	Jbs22nikhilms@gmail.com	1111111111	\N	\N	\N	5	Immediate	9	back-off	\N	\N	Palakkad 	\N	\N	Trivandrum	\N	\N	\N
1288	Devika A Nair 	 	\N	Fresher 	-	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	devikaajith2810@gmail.com	1111111111	\N	\N	\N	5	Immediate	9	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1289	Sanjay MS 	 	\N	5Yrs 	Infosys 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sanjayms1973@gmail.com	1111111111	\N	\N	\N	5	90 Days 	19	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1290	Aarshit SL 	 	\N	3.9Yrs 	Valoriz Digital,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aarshitsl@gmail.com	1111111111	\N	\N	\N	5	90 Days 	33	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1291	Aiswarya 	 	\N	1Year 	Qincore labs 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aishu20091999@gmail.com 	1111111111	\N	\N	\N	5	Immediate	35	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1292	Celux Varghese Babu	 	\N	7 Yrs	Xerox	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	pluscelex@gmail.com	1111111111	\N	\N	\N	5	60 Days	18	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1293	Maria George	 	\N	4.1 Urs	Thinkpalm	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mariya95george@gmail.com	1111111111	\N	\N	\N	5	90 Days	19	rejected	\N	\N	Kottayam	\N	\N	Trivandrum	\N	\N	\N
1294	Ashik Bhaseer	 	\N	6 Yrs	Scalgo	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ashik.franco@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	inprogress	\N	\N	Alleppy	\N	\N	Trivandrum	\N	\N	\N
1295	Sanal S	 	\N	9 Yrs	Fingent	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sanaloct@gmail.com	1111111111	\N	\N	\N	5	serving LWD dec 31st	38	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1296	Satheesh V S	 	\N	12 Yrs 	RR Donnelly	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mail2satheesh34@gmail.com	1111111111	\N	\N	\N	5	60 Days	38	inprogress	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1297	Bibin	 	\N	8.6Yrs	Inapp	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	bibin@mail.com	1111111111	\N	\N	\N	5	60 days	29	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1298	Soju	 	\N	9Yrs	Litmus	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sojucr7@gmail.com	1111111111	\N	\N	\N	5	60 days	22	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1299	Sajin	 	\N	5+Yrs	Znifa Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sajinrs96@gmail.com	1111111111	\N	\N	\N	5	60 days	21	inprogress	\N	\N	Kanyakumari	\N	\N	Trivandrum	\N	\N	\N
1300	Bhagyadev	 	\N	2.3Yrs	Cybrosis	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kpbhagyadev@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1301	Roshan	 	\N	5Yrs	Justkare Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	roshanmuhammadc@gmail.com	1111111111	\N	\N	\N	5	30 Days	21	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1302	Aishwarya SK 	 	\N	3.5Yrs 	Revyrie Global 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	s.k_a18@yahoo.com	1111111111	\N	\N	\N	5	90 Days 	33	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1303	Reshma 	 	\N	6Yrs 	Creative APP Lab Private Limited	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	malugrkurup@gmail.com	1111111111	\N	\N	\N	5	Immediate 	13	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1304	Rashid	 	\N	6yrs 	SRS Global Technologies 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rashidkpvml@gmail.com	1111111111	\N	\N	\N	5	60 Days	13	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1305	Rijo	 	\N	4.5Yrs	ISPG Technologies India Pvt. Ltd.	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rijorajan585@gmail.com	1111111111	\N	\N	\N	5	Immediate 	24	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1306	Ajnas	 	\N	4.5Yrs 	Web Castle 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajnaznaz123@gmail.com	1111111111	\N	\N	\N	5	30 Days 	13	rejected	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
1307	Shiny Chacko	 	\N	3.1 Yrs	BOCHDALE SOLUTIONS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shinyzmail@gmail.com	1111111111	\N	\N	\N	5	30 Days	33	inprogress	\N	\N	Kollam	\N	\N	Trivandrum	\N	\N	\N
1308	AISWARYA V P	 	\N	5.2 Yrs	Testing Mavens	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aiswaryavp7048@gmail.com	1111111111	\N	\N	\N	5	90 Days	33	inprogress	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1309	Nimal Suresh	 	\N	4.3 Yrs	Manappuram Comptech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nimalsuresh5@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-25th Jan)	19	rejected	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1310	Nidheesh Kamal	 	\N	6 Yrs	Bourntec Solutions 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nidheeshkamal56@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1311	ALBEN JOSEPH	 	\N	3 Yrs	Sinergia Media Labs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alben.joseph107@gmail.com	1111111111	\N	\N	\N	5	45 Days	24	inprogress	\N	\N	Cochin	\N	\N	Trivandrum	\N	\N	\N
1312	Indu M S	 	\N	4 Yrs	Leeyet Technohub LLP	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	indusudheesh@gmail.com	1111111111	\N	\N	\N	5	15-30 Days	22	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1313	Alina Chinnu Abraham	 	\N	2.3 Yrs	SPERICORN TECHNOLOGIES	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alinachinnuabraham@gmail.com	1111111111	\N	\N	\N	5	60 Days	25	rejected	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
1314	Georgy Ninan	 	\N	6Yrs	Travancore Analytics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	georgy.ninan77@gmail.com	1111111111	\N	\N	\N	5	90 days	22	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1315	Akshay	 	\N	4Yrs	Techware Lab	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akshayvg@live.com	1111111111	\N	\N	\N	5	90 Days Nego 60	22	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1316	David	 	\N	3.4yrs	HTIC Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	davidbranham7667@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1317	Arun A George	 	\N	5.6 Yrs	Ideenkreise Tech Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunalexgeorge@gmail.com	1111111111	\N	\N	\N	5	30 Days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1318	Sarath R Nath	 	\N	5.11 Yrs	Sayone technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dev.sarath.py@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	inprogress	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1319	Akku	 	\N	4 Yrs	Kameda Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akkuvalliath4@yahoo.com	1111111111	\N	\N	\N	5	Immediate	19	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1320	Minnu Sebastian	 	\N	3.7 Yrs	Intersmart Technologies Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	minnusebastian95@gmail.com	1111111111	\N	\N	\N	5	60 Days	33	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1321	Geethu A	 	\N	6.5 Yrs	Abacies Logiciels Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	geethua95@gmail.com	1111111111	\N	\N	\N	5	30 Days	33	inprogress	\N	\N	Alleppy	\N	\N	Cochin	\N	\N	\N
1322	Chippy George	 	\N	5 Yrs	Emsyne	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	chippygeorge24@gmail.com	1111111111	\N	\N	\N	5	60 Days	33	inprogress	\N	\N	Idukki	\N	\N	Cochin	\N	\N	\N
1323	Avees Joseph	 	\N	6.9 Yrs	Pits Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	a v e e sj o s e p h @ gma i l . c om	1111111111	\N	\N	\N	5	90 Days	21	inprogress	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1324	Midhun C K	 	\N	8 Yrs	Letmedoit Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	midhun.ck06@gmail.com	1111111111	\N	\N	\N	5	90 Days	45	inprogress	\N	\N	Pathanamthitta	\N	\N	TRIVANDRUM	\N	\N	\N
1325	Allen	 	\N	5yrs 	Brandoptics,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	allenpallath@gmail.com	1111111111	\N	\N	\N	5	60 days 	19	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1326	ArunKumar	 	\N	3.2	thinkpalm 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunkumarvg@outlook.com	1111111111	\N	\N	\N	5	90 days	24	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1327	Jeletta 	 	\N	Fresher 	-	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jel220394@gmail.com	1111111111	\N	\N	\N	5	Immediate 	35	inprogress	\N	\N	Kottayam	\N	\N	Trivandrum	\N	\N	\N
1328	S A N D R A S S U R E S H	 	\N	Fresher 	-	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sandras57478@gmail.com	1111111111	\N	\N	\N	5	Immediate 	35	inprogress	\N	\N	Pathanamthitta	\N	\N	Trivandrum	\N	\N	\N
1329	Sandheep	 	\N	6Yrs 	Shopalyst Inc.	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sandheepsanthosh@gmail.com	1111111111	\N	\N	\N	5	60 Days	27	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1330	Subhair VB 	 	\N	3.7YRS 	SCHNEIDE SOLUTION PVT LTD	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	subair.vb@gmail.com	1111111111	\N	\N	\N	5	30 DAYS 	33	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1331	Safwan PK 	 	\N	9+ 5years	sayone 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	safwanpk4@gmail.com	1111111111	\N	\N	\N	5	60 days 	45	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1332	Karthika	 	\N	6Yrs	Accubits Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	karthikapj12@gmail.com	1111111111	\N	\N	\N	5	30 days	22	back-off	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1333	Shalumon	 	\N	7Yrs	Kameda Infologics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shaluprakash91@gmail.com	1111111111	\N	\N	\N	5	LWD Feb 8	19	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1334	Arjun Ramesh	 	\N	5.6Yrs	Guidehouse	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arjunramesh.v@gmail.com	1111111111	\N	\N	\N	5	60 days	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1335	Mathew Santhosh	 	\N	4Yrs	Cognitive Clouds	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mathewsanthoshs@gmail.com	1111111111	\N	\N	\N	5	Immediate	27	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1336	Pranav Thayyil	 	\N	2.5 Yrs	Invenics	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	pranavt666@gmail.com	1111111111	\N	\N	\N	5	15 Days	27	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1337	Midhun R S	 	\N	5.3 Yrs	Pits Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	midhun.mrs.98@gmail.com	1111111111	\N	\N	\N	5	90 Days	33	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1338	Ajay Augustine	 	\N	3.5 Yrs	Geojit	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajayaugustine2007@gmail.com	1111111111	\N	\N	\N	5	Serving LWD Nov 14th	19	rejected	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
1339	Roshan James	 	\N	3.10 Yrs	Teknowmics Knowledge Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	roshanjames53@gmail.com	1111111111	\N	\N	\N	5	30 Days	19	rejected	\N	\N	Pathanamthitta	\N	\N	Cochin	\N	\N	\N
1340	Muktha A R	 	\N	5.6 Yrs	Swagg	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	muktha.akathuttel@gmail.com	1111111111	\N	\N	\N	5	30 Days	2	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1341	Neethu V M	 	\N	3.5 Yrs	Xgen Business Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethuvm07@gmail.com	1111111111	\N	\N	\N	5	60 Days	2	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1342	Preethi P	 	\N	3.4 Yrs	CodersFort	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	preethiprasobh@gmail.com	1111111111	\N	\N	\N	5	30 Days	33	inprogress	\N	\N	Kollam	\N	\N	Trivandrum 	\N	\N	\N
1343	Syamjith Krishna A S	 	\N	3 Yrs	LogicPlum India	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	skasonline@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	rejected	\N	\N	Calicut	\N	\N	Cochin	\N	\N	\N
1344	Muhammed Mushthaque	 	\N	5 Yrs	EXPEED SOFTWARE	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	musthaqskp13@gmail.com	1111111111	\N	\N	\N	5	Immediate	19	inprogress	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
1345	Arun S	 	\N	8 Yrs	Trenser Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	arunsanilkumar@gmail.com	1111111111	\N	\N	\N	5	90 Days(Neg to 70 Days)	40	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum 	\N	\N	\N
1346	Smrithi M A	 	\N	2.5 Yrs	Sodisys Business Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	neethuaji1997@gmail.com	1111111111	\N	\N	\N	5	30 Days	25	rejected	\N	\N	Trivandrum 	\N	\N	Trivandrum 	\N	\N	\N
1347	Sreelekshmi U	 	\N	4.8 Yrs	PITS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	lekshmishibin@gmail.com	1111111111	\N	\N	\N	5	90 Days	33	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum 	\N	\N	\N
1348	AKhila John	 	\N	8 months	IMPACT	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhilajohn98@gmail.com	1111111111	\N	\N	\N	5	Immediate	35	rejected	\N	\N	Kollam	\N	\N	Trivandrum 	\N	\N	\N
1349	Manu Prem M 	 	\N	9 Yrs	TCS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	manu.prem839@gmail.com	1111111111	\N	\N	\N	5	90 Days	35	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum 	\N	\N	\N
1350	Maria Varghese 	 	\N	2YRS 	BZ ANALYTICS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	maria.arikatt@gmail.com	1111111111	\N	\N	\N	5	60 Days 	33	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum 	\N	\N	\N
1351	Amal K 	 	\N	2years	Vandalay Business Solutions Pvt Ltd |	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	amalashok.knr@gmail.com	1111111111	\N	\N	\N	5	immediate 	45	rejected	\N	\N	kannur 	\N	\N	trivandrum 	\N	\N	\N
1352	Gishwin 	 	\N	2.5yrs 	Innovature labs,	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gishwinantony@gmail.com	1111111111	\N	\N	\N	5	90days	27	inprogress	\N	\N	kochi 	\N	\N	Cochin	\N	\N	\N
1353	Jasmine Joseph 	 	\N	Fresher 	-	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jasmine.joseph242@gmail.com	1111111111	\N	\N	\N	5	Immediate 	9	inprogress	\N	\N	Kannur 	\N	\N	Trivandrum 	\N	\N	\N
1354	Mahesh S L	 	\N	12 Yrs	Way.Com	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mahi25s.l@gmail.com	1111111111	\N	\N	\N	5	60 Days	14	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum 	\N	\N	\N
1355	Karthikeyan Keppanan	 	\N	7.8 Yrs	Qualifacts	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	karthikkeppanan@gmail.com	1111111111	\N	\N	\N	5	Immediate	18	inprogress	\N	\N	Kannur	\N	\N	Trivandrum 	\N	\N	\N
1356	EMIL YELDHO	 	\N	7 Yrs	Trois Infotech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	emilyeldho1992@gmail.com	1111111111	\N	\N	\N	5	30 Days	40	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1357	Anupama K B	 	\N	6 Yrs	Gsoft Cloud	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anupamabrahmanandan09@gmail.com	1111111111	\N	\N	\N	5	30 Days	5	inprogress	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
1358	Ashil PP	 	\N	4.2Yrs	Bridge Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ashilprakash369@gmail.com	1111111111	\N	\N	\N	5	30 days	22	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1359	Said Muhammed	 	\N	5Yrs	Solver ERP	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	zeydmohammed1999@gmail.com	1111111111	\N	\N	\N	5	60 days	19	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1360	Rahul J	 	\N	5Yrs	Hyreo Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahul95.jayakumar@gmail.com	1111111111	\N	\N	\N	5	60 days	19	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1361	Aswin Prasanth	 	\N	2Yrs	HTIC Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswinprasanth02@gmail.com	1111111111	\N	\N	\N	5	60 days	23	rejected	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1362	Simi Sam George	 	\N	6 Yrs	Bourntec	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	simimarysam@gmail.com	1111111111	\N	\N	\N	5	Immediate	33	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1363	Akshaya	 	\N	5 Yrs	esight bussiness solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sakshayas1998@gmail.com	1111111111	\N	\N	\N	5	Immediate	33	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1364	Kasthuri A	 	\N	3 Yrs	Fakeeh Technologies 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kasthuri4224@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-15th Dec)	19	inprogress	\N	\N	Tirunelveli	\N	\N	Trivandrum 	\N	\N	\N
1365	Viji Kumari V C	 	\N	2.6 Yrs	Innoval Digital Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vijivkvc28@gmail.com	1111111111	\N	\N	\N	5	90 Days	29	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum 	\N	\N	\N
1366	Manoj Prakash R	 	\N	2.8 Yrs	Wibits Web solution	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	manojprakash712@gmail.com	1111111111	\N	\N	\N	5	30 Days	13	rejected	\N	\N	Kanyakumari	\N	\N	Trivandrum 	\N	\N	\N
1367	Kavitha Kuriya	 	\N	7 Yrs	HASpaces	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	kavithakuriya94@gmail.com	1111111111	\N	\N	\N	5	Immediate	33	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1368	Megha Mohandas	 	\N	3 Yrs	simelabs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	meghamohandas48@gmail.com	1111111111	\N	\N	\N	5	60 Days	21	inprogress	\N	\N	Palakkad	\N	\N	Cochin	\N	\N	\N
1369	Sarath Soman	 	\N	4Yrs	ISPG	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	mesarathsoman@gmail.com	1111111111	\N	\N	\N	5	30 days	22	inprogress	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
1370	Vipin M	 	\N	4Yrs	Geojith Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vipinmkaimal@gmail.com	1111111111	\N	\N	\N	5	90 days nego 60 days	19	inprogress	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
1371	Sujith S	 	\N	5Yrs	Timesworld	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sujithsudarsanan2014@gmail.com	1111111111	\N	\N	\N	5	60 days nego 30 days	27	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1372	Martin Benny	 	\N	3.9Yrs	Trivandrum	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	martin8086benny@gmail.com	1111111111	\N	\N	\N	5	90 days nego 30 days	21	inprogress	\N	\N	Equifax	\N	\N	Trivandrum	\N	\N	\N
1373	Sajith PS	 	\N	6.5Yrs	Trivandrum	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sajithmuhammed95@gmail.com	1111111111	\N	\N	\N	5	60 days	38	inprogress	\N	\N	Polus Solutions	\N	\N	Cochin	\N	\N	\N
1374	Sanu Louis	 	\N	4+ Yrs	Mariapps Marine Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sanulouis44@gmail.com	1111111111	\N	\N	\N	5	Serving (Lwd jan 20th)	27	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1375	Anju S	 	\N	17 Yrs	Emvigo Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjupournami@gmail.com	1111111111	\N	\N	\N	5	Serving NP(Lwd Dec 28th	3	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1376	Ranju K	 	\N	10 Yrs	eMpulse Research and Data Analytics (I) Pvt	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sijuranju@gmail.com	1111111111	\N	\N	\N	5	60 Days	14	inprogress	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
1377	Anuraj R	 	\N	4 Yrs	Revire Global	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anurajpanayil@gmail.com	1111111111	\N	\N	\N	5	90 Days	24	inprogress	\N	\N	Alleppy	\N	\N	Trivandrum	\N	\N	\N
1378	Prakash	 	\N	10 Yrs	Reflections	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	prakash@mail.com	1111111111	\N	\N	\N	5	Immediate	38	rejected	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1379	Jasna Salim	 	\N	2.8 Yrs	Cameroinfolks PVT Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shezjes@gmail.com	1111111111	\N	\N	\N	5	30 Days	27	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1380	Sreejith G	 	\N	7.7 Yrs	Kawika Technology	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sreejithgirieeshnair@gmail.com	1111111111	\N	\N	\N	5	60 Days	14	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1381	Ajitha Balakrishnan	 	\N	3+ 	Sayone 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajithahere@gmail.com	1111111111	\N	\N	\N	5	15 Days 	24	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum 	\N	\N	\N
1382	TERLIN VARGHESE	 	\N	2.6yrs 	IRIS MEDICAL SOLUTIONS PVT LTD	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	terlin.varghese20@gmail.com	1111111111	\N	\N	\N	5	60 DAYS 	33	inprogress	\N	\N	Cochin	\N	\N	Trivandrum 	\N	\N	\N
1383	Sherin Joseph	 	\N	\N	\N	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sherinbenjamin451@gmail.com	1111111111	\N	\N	\N	5	\N	33	inprogress	\N	\N	\N	\N	\N	\N	\N	\N	\N
1384	Ram Perumal	 	\N	4Yrs 	TCS 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ramperumal037@gmail.com	1111111111	\N	\N	\N	5	30 DAYS 	35	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum 	\N	\N	\N
1385	Ansu Jain 	 	\N	Intern 	IBS 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ansupottakulathu@gmail.com	1111111111	\N	\N	\N	5	Immediate 	9	inprogress	\N	\N	Cochin 	\N	\N	Trivandrum	\N	\N	\N
1386	Aswanth CP	 	\N	\N	\N	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	aswandcp@gmail.com	1111111111	\N	\N	\N	5	\N	24	inprogress	\N	\N	\N	\N	\N	\N	\N	\N	\N
1387	Melvin Shaju	 	\N	4Yrs	Daiviksoft Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	melvinshaju155@gmail.com	1111111111	\N	\N	\N	5	60 days	21	inprogress	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
1388	Suchitra	 	\N	3.6Yrs	Enzapps	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	suchitrasprabhakaran@gmail.com	1111111111	\N	\N	\N	5	60 days	23	inprogress	\N	\N	Kochi	\N	\N	Cochin	\N	\N	\N
1389	Leo Varghese	 	\N	4Yrs	Impress.ai	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	leomv3@gmail.com	1111111111	\N	\N	\N	5	60 days	27	inprogress	\N	\N	KOchi	\N	\N	Cochin	\N	\N	\N
1390	Rahul Ks	 	\N	5Yrs	Cascade	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rahulrahu151999@gmail.com	1111111111	\N	\N	\N	5	60 days	27	inprogress	\N	\N	KOchi	\N	\N	Cochin	\N	\N	\N
1391	Anjana K A	 	\N	4 Yrs	Emsyne Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anjanaaravindhakshan@gmail.com	1111111111	\N	\N	\N	5	60 Days	19	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1392	Christy Shaji	 	\N	2 Yrs	Innoval Digital Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	christyshaji500@gmail.com	1111111111	\N	\N	\N	5	90 Days	29	inprogress	\N	\N	Pathanamthitta	\N	\N	Trivandrum 	\N	\N	\N
1393	Muhammed Shafeek	 	\N	4 Yrs	Classyserve Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	shafeequevesala@gmail.com	1111111111	\N	\N	\N	5	30 Days	27	inprogress	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
1394	M Vishnu	 	\N	3 Yrs	Notasco Technologies 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishnuasb123@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-30th Nov)	17	inprogress	\N	\N	Kanyakumari	\N	\N	Cochin	\N	\N	\N
1395	Manjusha Mohan	 	\N	5.5 Yrs	Contact Point 360	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	manjushamohan16@gmail.com	1111111111	\N	\N	\N	5	Immediate	33	inprogress	\N	\N	Alappuzha	\N	\N	Trivandrum 	\N	\N	\N
1396	Sharmi S V	 	\N	2.5 Yrs	Klystron Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sharmisv2704@gmail.com	1111111111	\N	\N	\N	5	90 Days	23	inprogress	\N	\N	Kanyakumari	\N	\N	Cochin	\N	\N	\N
1397	Sneha Thomas   	 	\N	5.4 Yrs	Wipro	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	 alphonsamaliyakal@gmail.com	1111111111	\N	\N	\N	5	Immediate	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1398	Alosious Davis	 	\N	4 Yrs	Dbiz	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	alosiousdavis07@gmail.com	1111111111	\N	\N	\N	5	Immediate	27	inprogress	\N	\N	Thrissur	\N	\N	Cochin	\N	\N	\N
1399	Sibin Xavior	 	\N	11+ Yr	Sinergia Labs	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sibinx7@gmail.com	1111111111	\N	\N	\N	5	60 Days	41	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1400	Sruthy Prasad	 	\N	6 Yrs	Aabasoft	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	sruthypnair99@gmail.com	1111111111	\N	\N	\N	5	Immediate	19	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1401	Vimitha K	 	\N	6.6 Yrs	Finastra	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vimitha043@gmail.com	1111111111	\N	\N	\N	5	Immediate	21	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1402	Anusha P	 	\N	3 Yrs	Reflections	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anushavasudhev39@gmail.com	1111111111	\N	\N	\N	5	Immediate	2	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1403	Anoob V M	 	\N	13+ Yrs	MAVA Partners Business Consulting Pvt Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anoobvm@gmail.com	1111111111	\N	\N	\N	5	60 Days	31	inprogress	\N	\N	Kannur	\N	\N	Cochin	\N	\N	\N
1404	Nidhin Kumar	 	\N	\N	\N	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nidhinkumar@mail.com	1111111111	\N	\N	\N	5	\N	33	inprogress	\N	\N	\N	\N	\N	\N	\N	\N	\N
1405	Gayathri	 	\N	3.10Yrs 	Allianz 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	gayathryhari29@gmail.com	1111111111	\N	\N	\N	5	Immediate 	35	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum 	\N	\N	\N
1406	Abhilash Ravi	 	\N	7yrs	Atraco 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	abhi.rp010@gmail.com	1111111111	\N	\N	\N	5	immedite 	35	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum 	\N	\N	\N
1407	Jeffin P Paul	 	\N	3yrs	Trnzmeo 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	jeffin.paul.joseph@gmail.com 	1111111111	\N	\N	\N	5	immediate 	17	inprogress	\N	\N	kochi 	\N	\N	Cochin	\N	\N	\N
1408	Krishna G Vijayan	 	\N	\N	\N	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	krishnagvijayan@gmail.com	1111111111	\N	\N	\N	5	\N	35	inprogress	\N	\N	\N	\N	\N	\N	\N	\N	\N
1409	Devika Krishnan	 	\N	4Yrs	Infosys	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	devukrish18@gmail.com	1111111111	\N	\N	\N	5	90 days	21	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1410	Ajith A	 	\N	4.9Yrs	Experion	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ajithsra@gmailcom	1111111111	\N	\N	\N	5	60 days	19	inprogress	\N	\N	Nagercoil	\N	\N	Trivandrum	\N	\N	\N
1411	Ambili Sunil	 	\N	3Yrs	Neyyar App	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	ambilisunil1998@gmail.com	1111111111	\N	\N	\N	5	60 days	22	inprogress	\N	\N	Trivandrum	\N	\N	Trivandrum	\N	\N	\N
1412	Geethu Varghese	 	\N	8 Yrs 	Experion 	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	geethuvarghese95@gmail.com	1111111111	\N	\N	\N	5	60 Days	38	inprogress	\N	\N	cochin	\N	\N	Cochin	\N	\N	\N
1413	Parvathy R Nair	 	\N	2.4 Yrs	Flycatch Infotech Pvt. Ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	parurajendran6633@gmail.com	1111111111	\N	\N	\N	5	30 Days	34	inprogress	\N	\N	Pathanamthitta	\N	\N	Cochin	\N	\N	\N
1414	Archana Rajan	 	\N	5 Yrs	SRS	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	archanarajan93@gmail.com	1111111111	\N	\N	\N	5	60 Days	29	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum	\N	\N	\N
1415	Anandhu Anil	 	\N	4.5 Yrs	Xminds Infotech Pvt ltd	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anandhuanil7@gmail.com	1111111111	\N	\N	\N	5	60 Days	22	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum	\N	\N	\N
1416	Rajesh P	 	\N	11 Yrs	Designtech	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	rajesh007me@gmail.com	1111111111	\N	\N	\N	5	30 Days	14	inprogress	\N	\N	Malappuram	\N	\N	Trivandrum	\N	\N	\N
1417	Nishanth D	 	\N	6 Yrs	NIC	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	nishant181@gmail.com 	1111111111	\N	\N	\N	5	60 Days	21	inprogress	\N	\N	Trivandrum 	\N	\N	Trivandrum 	\N	\N	\N
1418	Vishal S	 	\N	6 Yrs	LogicPlum	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	vishal.python.engineer@gmail.com	1111111111	\N	\N	\N	5	60 Days	31	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1419	Dharsana K Das	 	\N	3 Yrs	TechWyse Internet	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	dharsanakdas@gmail.com	1111111111	\N	\N	\N	5	60 Days	22	inprogress	\N	\N	Cochin	\N	\N	Cochin	\N	\N	\N
1420	Akhil S	 	\N	2.6 Yrs	Spectrum 7	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	akhilsathyadevan@gmail.com	1111111111	\N	\N	\N	5	Immediate	22	inprogress	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1421	Najeela P A	 	\N	9 Yrs	Caxita Tech Solutions	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	najeelap.a@gmail.com	1111111111	\N	\N	\N	5	Serving(LWD-29th Nov)	40	inprogress	\N	\N	Kottayam	\N	\N	Cochin	\N	\N	\N
1422	Anu Krishnan	 	\N	2.5 Yrs	Geofenice Technologies	\N	\N	\N	\N	\N	active	2024-11-22 04:31:51.49+00	2024-11-22 04:31:51.49+00	anukrishnan0102@gmail.com	1111111111	\N	\N	\N	5	30 Days	13	inprogress	\N	\N	Kollam	\N	\N	Trivandrum 	\N	\N	\N
\.


--
-- Data for Name: reqDesignations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqDesignations" ("designationId", "designationName", "createdAt", "updatedAt") FROM stdin;
1	Associate Software Engineer	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
2	Associate Software Engineer Trainee	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
3	Senior Software Engineer	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
4	Manager Business Development	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
5	Business Development Executive	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
6	Senior Executive Business Development	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
7	Associate Business Development	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
8	Senior Manager - Business Development	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
9	Associate Lead Business Development	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
10	Vice President - Human Resources	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
11	Associate HR	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
12	Executive Recruiter	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
13	HR Generalist	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
14	Manager Talent Acquisition	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
15	Senior Associate Talent Acquisition	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
16	Associate Talent Acquisition Partner	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
17	Associate Lead Talent Acquisition	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
18	Assistant Manager Accounts	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
19	Finance Associate	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
20	Senior Technical Architect	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
21	Project Lead	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
22	Associate Software Test Engineer	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
23	Associate Lead	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
24	Technical Accounts Manager	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
25	Lead - Mobility	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
26	Senior UI/UX Developer	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
28	Senior UI UX Designer	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
29	Senior Test Engineer	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
30	Senior AI Engineer	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
31	Associate Team Lead	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
32	Software Engineer	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
33	Senior Devops Engineer	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
34	Solution Architect	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
35	Associate Software Test Engineer Trainee	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
36	COO and Director - Strategic Consulting & Partnerships	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
37	Test Engineer	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
38	Lead Test Engineer	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
39	Team Lead	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
40	UI/UX Designer	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
41	Associative Project Manager	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
42	Business Analyst	2020-12-31 18:30:00+00	2020-12-31 18:30:00+00
\.


--
-- Data for Name: reqExperienceReports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqExperienceReports" (id, technology, "interviewStatusCount", "rescheduleStatusCount") FROM stdin;
3	3	23	0
23	24	25	0
41	9	6	0
2	32	26	0
37	1	1	0
21	6	7	0
30	12	5	0
31	41	6	0
29	34	4	0
22	42	2	0
27	43	6	0
20	29	40	0
18	35	22	0
15	13	39	0
36	14	9	0
33	39	6	0
16	28	28	0
39	45	3	0
9	17	10	0
25	26	2	0
4	4	28	0
35	7	8	0
19	23	64	0
6	38	20	0
28	27	48	0
17	19	56	0
38	33	27	0
40	5	4	0
5	30	23	0
13	22	62	0
12	25	48	0
32	37	2	0
14	20	3	0
11	8	15	0
7	21	66	0
26	31	4	0
34	40	7	0
1	11	44	0
10	18	87	0
24	2	31	0
8	16	24	0
\.


--
-- Data for Name: reqFeedbacks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqFeedbacks" (id, value) FROM stdin;
1	Selected
2	Rejected
3	Hold
\.


--
-- Data for Name: reqHrReviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqHrReviews" ("reviewedId", "reviewedServiceId", "reviewedSalary", "reviewedDescription", "reviewedStatus", "reviewedJoiningDate") FROM stdin;
\.


--
-- Data for Name: reqIntervieModes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqIntervieModes" (id, "modeName") FROM stdin;
1	Gmeet
2	Zoom
3	Offline
\.


--
-- Data for Name: reqLogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqLogs" (id, "userId", "serviceRequest", "fromStation", "toStation", mail, "mailType", status) FROM stdin;
\.


--
-- Data for Name: reqMultipleRoleAccesses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqMultipleRoleAccesses" ("roleAccessId", "roleAccessRoleId", "roleAccessUserId") FROM stdin;
\.


--
-- Data for Name: reqOfferAttachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqOfferAttachments" (id, "candidateId", "updatedBy", station, "attachmentPath", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: reqProgressSkills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqProgressSkills" (id, "skillId", score, "serviceSeqId") FROM stdin;
\.


--
-- Data for Name: reqQuestionBoxes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqQuestionBoxes" (id, "requstId") FROM stdin;
\.


--
-- Data for Name: reqQuestions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqQuestions" ("questionId", "questionName", "questionTotalMark") FROM stdin;
\.


--
-- Data for Name: reqRejectReasons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqRejectReasons" (id, value) FROM stdin;
\.


--
-- Data for Name: reqReports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqReports" (id, recruiter, "position", "positionHc", "naukriResume", "linkedinResume", "sourcedScreened", "candidateContacted", "candidatesIntrested", "interviewScheduled", "offerReleased", date, "interviewConducted", "interviewReScheduled", "offerAccepeted", "indeedResume", "candidateResume", "inHouseResume") FROM stdin;
192	6	11	\N	0	0	2	1	1	1	0	2024-06-10 00:00:00+00	0	0	0	0	0	2
193	6	32	\N	0	0	2	1	1	1	0	2024-06-13 00:00:00+00	0	0	0	0	0	2
194	6	3	\N	0	0	2	1	1	1	0	2024-06-14 00:00:00+00	0	0	0	0	0	2
195	6	11	\N	0	0	2	1	1	1	0	2024-06-24 00:00:00+00	0	0	0	0	0	2
196	5	4	\N	0	0	2	1	1	1	0	2024-06-25 00:00:00+00	0	0	0	0	0	2
197	6	4	\N	0	0	2	1	1	1	0	2024-06-25 00:00:00+00	0	0	0	0	0	2
198	6	3	\N	0	0	2	1	1	1	0	2024-06-25 00:00:00+00	0	0	0	0	0	2
199	3	4	\N	0	0	2	1	1	1	0	2024-06-25 00:00:00+00	0	0	0	0	0	2
200	3	3	\N	0	0	2	1	1	1	0	2024-06-26 00:00:00+00	0	0	0	0	0	2
201	6	3	\N	0	0	2	1	1	1	0	2024-06-27 00:00:00+00	0	0	0	0	0	2
202	6	30	\N	0	0	2	1	1	1	0	2024-06-27 00:00:00+00	0	0	0	0	0	2
203	3	38	\N	0	0	2	1	1	1	0	2024-06-28 00:00:00+00	0	0	0	0	0	2
231	3	21	\N	0	0	2	2	1	2	0	2024-07-23 00:00:00+00	1	0	0	0	0	2
204	6	3	\N	0	0	4	2	2	2	0	2024-07-01 00:00:00+00	0	0	0	0	0	4
205	6	4	\N	0	0	2	1	1	1	0	2024-07-01 00:00:00+00	0	0	0	0	0	2
206	3	4	\N	0	0	2	1	1	1	0	2024-10-11 00:00:00+00	0	0	0	0	0	2
207	3	4	\N	0	0	2	1	1	1	0	2024-07-01 00:00:00+00	0	0	0	0	0	2
208	6	4	\N	0	0	2	1	1	1	0	2024-07-02 00:00:00+00	0	0	0	0	0	2
224	6	11	\N	0	0	2	1	1	1	0	2024-07-16 00:00:00+00	0	0	0	0	0	2
209	3	30	\N	0	0	4	2	2	2	0	2024-07-03 00:00:00+00	0	0	0	0	0	4
210	6	11	\N	0	0	2	1	1	1	0	2024-07-03 00:00:00+00	0	0	0	0	0	2
211	6	30	\N	0	0	2	1	1	1	0	2024-07-03 00:00:00+00	0	0	0	0	0	2
212	6	3	\N	0	0	2	1	1	1	0	2024-07-04 00:00:00+00	0	0	0	0	0	2
213	6	30	\N	0	0	2	1	1	1	0	2024-07-05 00:00:00+00	0	0	0	0	0	2
214	6	4	\N	0	0	2	1	1	1	0	2024-07-05 00:00:00+00	0	0	0	0	0	2
215	3	4	\N	0	0	2	1	1	1	0	2024-07-05 00:00:00+00	0	0	0	0	0	2
216	3	3	\N	0	0	2	1	1	1	0	2024-07-08 00:00:00+00	0	0	0	0	0	2
217	6	4	\N	0	0	2	1	1	1	0	2024-07-08 00:00:00+00	0	0	0	0	0	2
223	5	3	\N	0	0	2	2	1	2	0	2024-07-12 00:00:00+00	1	0	0	0	0	2
225	3	16	\N	0	0	2	1	1	1	0	2024-07-17 00:00:00+00	0	0	0	0	0	2
219	5	30	\N	0	0	4	2	2	2	0	2024-07-08 00:00:00+00	0	0	0	0	0	4
220	6	3	\N	0	0	2	1	1	1	0	2024-07-09 00:00:00+00	0	0	0	0	0	2
221	3	30	\N	0	0	2	1	1	1	0	2024-07-09 00:00:00+00	0	0	0	0	0	2
222	3	30	\N	0	0	2	1	1	1	0	2024-09-24 00:00:00+00	0	0	0	0	0	2
226	3	16	\N	0	0	2	1	1	1	0	2024-07-18 00:00:00+00	0	0	0	0	0	2
227	6	16	\N	0	0	2	1	1	1	0	2024-07-18 00:00:00+00	0	0	0	0	0	2
228	6	4	\N	0	0	2	1	1	1	0	2024-07-18 00:00:00+00	0	0	0	0	0	2
229	6	16	\N	0	0	2	1	1	1	0	2024-07-19 00:00:00+00	0	0	0	0	0	2
230	6	11	\N	0	0	2	1	1	1	0	2024-07-22 00:00:00+00	0	0	0	0	0	2
236	6	16	\N	0	0	2	2	1	2	0	2024-07-31 00:00:00+00	1	0	0	0	0	2
233	3	21	\N	0	0	2	1	1	1	0	2024-07-25 00:00:00+00	0	0	0	0	0	2
234	6	16	\N	0	0	2	1	1	1	0	2024-07-25 00:00:00+00	0	0	0	0	0	2
235	3	4	\N	0	0	2	1	1	1	0	2024-07-26 00:00:00+00	0	0	0	0	0	2
232	3	16	\N	0	0	2	2	1	2	0	2024-07-25 00:00:00+00	1	0	0	0	0	2
240	5	38	\N	0	0	2	1	1	1	0	2024-09-23 00:00:00+00	0	0	0	0	0	2
237	6	3	\N	0	0	4	2	2	2	0	2024-09-02 00:00:00+00	0	0	0	0	0	4
238	5	30	\N	0	0	2	1	1	1	0	2024-09-05 00:00:00+00	0	0	0	0	0	2
239	5	4	\N	0	0	2	1	1	1	0	2024-09-06 00:00:00+00	0	0	0	0	0	2
241	5	38	\N	0	0	2	1	1	1	0	2024-09-24 00:00:00+00	0	0	0	0	0	2
247	6	3	\N	0	0	2	1	1	1	0	2024-10-18 00:00:00+00	0	0	0	0	0	2
242	3	17	\N	0	0	4	2	2	2	0	2024-10-07 00:00:00+00	0	0	0	0	0	4
243	3	3	\N	0	0	2	1	1	1	0	2024-10-10 00:00:00+00	0	0	0	0	0	2
248	6	11	\N	0	0	2	1	1	1	0	2024-10-21 00:00:00+00	0	0	0	0	0	2
244	5	4	\N	0	0	4	2	2	2	0	2024-10-11 00:00:00+00	0	0	0	0	0	4
245	7	3	\N	0	0	2	1	1	1	0	2024-10-14 00:00:00+00	0	0	0	0	0	2
246	6	3	\N	0	0	2	1	1	1	0	2024-10-17 00:00:00+00	0	0	0	0	0	2
249	6	4	\N	0	0	2	1	1	1	0	2024-10-21 00:00:00+00	0	0	0	0	0	2
250	6	16	\N	0	0	2	1	1	1	0	2024-10-22 00:00:00+00	0	0	0	0	0	2
251	6	11	\N	0	0	2	1	1	1	0	2024-10-23 00:00:00+00	0	0	0	0	0	2
252	6	16	\N	0	0	2	1	1	1	0	2024-10-23 00:00:00+00	0	0	0	0	0	2
218	6	3	\N	0	0	2	2	1	2	0	2024-07-08 00:00:00+00	1	0	0	0	0	2
254	3	21	\N	0	0	1	1	1	1	0	2024-06-19 00:00:00+00	0	0	0	0	0	1
257	3	18	\N	0	0	0	0	0	1	0	2024-11-12 18:30:00+00	0	0	0	0	0	0
255	6	30	\N	0	0	1	1	1	1	0	2024-07-02 00:00:00+00	0	0	0	0	0	1
256	3	38	\N	0	0	1	1	1	1	0	2024-07-08 00:00:00+00	0	0	0	0	0	1
258	3	18	\N	0	0	0	1	0	0	0	2024-11-12 18:30:00+00	0	0	0	0	0	0
259	3	18	\N	0	0	0	0	0	0	0	2024-11-12 18:30:00+00	1	0	0	0	0	0
260	5	8	\N	0	0	0	1	0	1	0	2024-06-03 00:00:00+00	1	0	0	0	0	0
261	5	25	\N	0	0	0	1	0	1	0	2024-06-03 00:00:00+00	1	0	0	0	0	0
262	5	22	\N	0	0	0	1	0	1	0	2024-06-03 00:00:00+00	1	0	0	0	0	0
263	3	22	\N	0	0	0	1	0	1	0	2024-06-03 00:00:00+00	1	0	0	0	0	0
253	3	32	\N	0	0	1	2	1	2	0	2024-06-21 00:00:00+00	1	0	0	0	0	1
264	3	21	\N	0	0	0	1	0	1	0	2024-06-03 00:00:00+00	1	0	0	0	0	0
308	5	20	\N	0	0	0	1	0	1	0	2024-06-13 00:00:00+00	1	0	0	0	0	0
265	3	25	\N	0	0	0	1	0	1	0	2024-06-03 00:00:00+00	1	0	0	0	0	0
284	6	18	\N	0	0	0	1	0	1	0	2024-06-05 00:00:00+00	1	0	0	0	0	0
266	3	22	\N	0	0	0	1	0	1	0	2024-06-04 00:00:00+00	1	0	0	0	0	0
267	3	21	\N	0	0	0	1	0	1	0	2024-06-04 00:00:00+00	1	0	0	0	0	0
285	6	21	\N	0	0	0	1	0	1	0	2024-06-05 00:00:00+00	1	0	0	0	0	0
269	6	8	\N	0	0	0	1	0	1	0	2024-06-04 00:00:00+00	1	0	0	0	0	0
298	5	8	\N	0	0	0	2	0	2	0	2024-06-06 00:00:00+00	2	0	0	0	0	0
286	6	22	\N	0	0	0	1	0	1	0	2024-09-23 00:00:00+00	1	0	0	0	0	0
270	6	13	\N	0	0	0	2	0	2	0	2024-06-04 00:00:00+00	2	0	0	0	0	0
287	5	28	\N	0	0	0	1	0	1	0	2024-06-05 00:00:00+00	1	0	0	0	0	0
271	6	22	\N	0	0	0	1	0	1	0	2024-06-04 00:00:00+00	1	0	0	0	0	0
268	6	21	\N	0	0	0	2	0	2	0	2024-06-04 00:00:00+00	2	0	0	0	0	0
272	5	8	\N	0	0	0	1	0	1	0	2024-06-07 00:00:00+00	1	0	0	0	0	0
273	5	25	\N	0	0	0	1	0	1	0	2024-06-07 00:00:00+00	1	0	0	0	0	0
309	5	11	\N	0	0	0	1	0	1	0	2024-06-07 00:00:00+00	1	0	0	0	0	0
274	5	19	\N	0	0	0	1	0	1	0	2024-06-04 00:00:00+00	1	0	0	0	0	0
288	5	21	\N	0	0	0	2	0	2	0	2024-06-05 00:00:00+00	2	0	0	0	0	0
275	5	28	\N	0	0	0	1	0	1	0	2024-06-07 00:00:00+00	1	0	0	0	0	0
276	5	21	\N	0	0	0	1	0	1	0	2024-06-14 00:00:00+00	1	0	0	0	0	0
324	6	11	\N	0	0	0	3	0	3	0	2024-06-21 00:00:00+00	3	0	0	0	0	0
277	5	13	\N	0	0	0	1	0	1	0	2024-06-04 00:00:00+00	1	0	0	0	0	0
289	3	35	\N	0	0	0	1	0	1	0	2024-06-06 00:00:00+00	1	0	0	0	0	0
278	5	23	\N	0	0	0	1	0	1	0	2024-06-04 00:00:00+00	1	0	0	0	0	0
279	3	18	\N	0	0	0	1	0	1	0	2024-06-05 00:00:00+00	1	0	0	0	0	0
280	3	38	\N	0	0	0	1	0	1	0	2024-06-05 00:00:00+00	1	0	0	0	0	0
290	3	23	\N	0	0	0	1	0	1	0	2024-06-06 00:00:00+00	1	0	0	0	0	0
281	3	25	\N	0	0	0	1	0	1	0	2024-06-05 00:00:00+00	1	0	0	0	0	0
282	3	29	\N	0	0	0	1	0	1	0	2024-06-05 00:00:00+00	1	0	0	0	0	0
291	3	28	\N	0	0	0	1	0	1	0	2024-06-06 00:00:00+00	1	0	0	0	0	0
301	6	18	\N	0	0	0	1	0	1	0	2024-06-07 00:00:00+00	1	0	0	0	0	0
283	6	6	\N	0	0	0	2	0	2	0	2024-06-05 00:00:00+00	2	0	0	0	0	0
292	6	18	\N	0	0	0	1	0	1	0	2024-06-06 00:00:00+00	1	0	0	0	0	0
293	6	6	\N	0	0	0	1	0	1	0	2024-06-06 00:00:00+00	1	0	0	0	0	0
322	6	35	\N	0	0	0	1	0	1	0	2024-06-11 00:00:00+00	1	0	0	0	0	0
294	6	25	\N	0	0	0	1	0	1	0	2024-06-06 00:00:00+00	1	0	0	0	0	0
302	6	23	\N	0	0	0	1	0	1	0	2024-06-07 00:00:00+00	1	0	0	0	0	0
295	6	8	\N	0	0	0	1	0	1	0	2024-06-06 00:00:00+00	1	0	0	0	0	0
296	5	42	\N	0	0	0	1	0	1	0	2024-06-06 00:00:00+00	1	0	0	0	0	0
315	6	28	\N	0	0	0	1	0	1	0	2024-06-10 00:00:00+00	1	0	0	0	0	0
297	5	23	\N	0	0	0	1	0	1	0	2024-06-13 00:00:00+00	1	0	0	0	0	0
303	6	35	\N	0	0	0	1	0	1	0	2024-06-07 00:00:00+00	1	0	0	0	0	0
319	5	29	\N	0	0	0	1	0	1	0	2024-06-13 00:00:00+00	1	0	0	0	0	0
304	3	35	\N	0	0	0	1	0	1	0	2024-06-07 00:00:00+00	1	0	0	0	0	0
310	3	18	\N	0	0	0	2	0	2	0	2024-06-10 00:00:00+00	2	0	0	0	0	0
305	3	38	\N	0	0	0	1	0	1	0	2024-06-07 00:00:00+00	1	0	0	0	0	0
306	3	24	\N	0	0	0	1	0	1	0	2024-06-07 00:00:00+00	1	0	0	0	0	0
316	6	13	\N	0	0	0	1	0	1	0	2024-06-10 00:00:00+00	1	0	0	0	0	0
307	5	2	\N	0	0	0	1	0	1	0	2024-06-07 00:00:00+00	1	0	0	0	0	0
311	3	22	\N	0	0	0	1	0	1	0	2024-06-10 00:00:00+00	1	0	0	0	0	0
312	3	2	\N	0	0	0	1	0	1	0	2024-06-10 00:00:00+00	1	0	0	0	0	0
313	6	11	\N	0	0	0	1	0	1	0	2024-06-20 00:00:00+00	1	0	0	0	0	0
320	5	11	\N	0	0	0	1	0	1	0	2024-06-21 00:00:00+00	1	0	0	0	0	0
314	6	11	\N	0	0	0	1	0	1	0	2024-06-26 00:00:00+00	1	0	0	0	0	0
317	5	2	\N	0	0	0	2	0	2	0	2024-06-10 00:00:00+00	2	0	0	0	0	0
318	5	29	\N	0	0	0	1	0	1	0	2024-06-18 00:00:00+00	1	0	0	0	0	0
321	6	21	\N	0	0	0	1	0	1	0	2024-06-11 00:00:00+00	1	0	0	0	0	0
326	3	18	\N	0	0	0	1	0	1	0	2024-06-11 00:00:00+00	1	0	0	0	0	0
323	6	25	\N	0	0	0	1	0	1	0	2024-06-11 00:00:00+00	1	0	0	0	0	0
325	6	23	\N	0	0	0	1	0	1	0	2024-06-11 00:00:00+00	1	0	0	0	0	0
300	6	21	\N	0	0	0	2	0	2	0	2024-06-07 00:00:00+00	2	0	0	0	0	0
327	3	38	\N	0	0	0	1	0	1	0	2024-06-11 00:00:00+00	1	0	0	0	0	0
328	3	22	\N	0	0	0	1	0	1	0	2024-06-11 00:00:00+00	1	0	0	0	0	0
329	3	23	\N	0	0	0	1	0	1	0	2024-06-11 00:00:00+00	1	0	0	0	0	0
330	5	21	\N	0	0	0	1	0	1	0	2024-06-11 00:00:00+00	1	0	0	0	0	0
331	5	23	\N	0	0	0	1	0	1	0	2024-06-18 00:00:00+00	1	0	0	0	0	0
332	5	19	\N	0	0	0	1	0	1	0	2024-06-11 00:00:00+00	1	0	0	0	0	0
333	6	11	\N	0	0	0	1	0	1	0	2024-06-12 00:00:00+00	1	0	0	0	0	0
334	6	25	\N	0	0	0	1	0	1	0	2024-06-12 00:00:00+00	1	0	0	0	0	0
299	6	21	\N	0	0	0	2	0	2	0	2024-06-13 00:00:00+00	2	0	0	0	0	0
354	5	22	\N	0	0	0	1	0	1	0	2024-06-25 00:00:00+00	1	0	0	0	0	0
336	6	21	\N	0	0	0	1	0	1	0	2024-06-19 00:00:00+00	1	0	0	0	0	0
367	6	26	\N	0	0	0	2	0	2	0	2024-06-19 00:00:00+00	2	0	0	0	0	0
337	3	18	\N	0	0	0	2	0	2	0	2024-06-12 00:00:00+00	2	0	0	0	0	0
368	3	18	\N	0	0	0	1	0	1	0	2024-06-18 00:00:00+00	1	0	0	0	0	0
355	3	18	\N	0	0	0	2	0	2	0	2024-06-14 00:00:00+00	2	0	0	0	0	0
338	3	21	\N	0	0	0	2	0	2	0	2024-06-12 00:00:00+00	2	0	0	0	0	0
356	3	28	\N	0	0	0	1	0	1	0	2024-06-14 00:00:00+00	1	0	0	0	0	0
339	3	25	\N	0	0	0	1	0	1	0	2024-06-12 00:00:00+00	1	0	0	0	0	0
340	3	23	\N	0	0	0	1	0	1	0	2024-06-12 00:00:00+00	1	0	0	0	0	0
341	5	18	\N	0	0	0	1	0	1	0	2024-06-19 00:00:00+00	1	0	0	0	0	0
357	3	21	\N	0	0	0	1	0	1	0	2024-06-14 00:00:00+00	1	0	0	0	0	0
342	5	8	\N	0	0	0	1	0	1	0	2024-06-12 00:00:00+00	1	0	0	0	0	0
343	5	23	\N	0	0	0	1	0	1	0	2024-06-12 00:00:00+00	1	0	0	0	0	0
378	5	11	\N	0	0	0	1	0	1	0	2024-07-03 00:00:00+00	1	0	0	0	0	0
358	3	25	\N	0	0	0	1	0	1	0	2024-06-14 00:00:00+00	1	0	0	0	0	0
363	5	2	\N	0	0	0	2	0	2	0	2024-06-17 00:00:00+00	2	0	0	0	0	0
346	3	18	\N	0	0	0	1	0	1	0	2024-06-13 00:00:00+00	1	0	0	0	0	0
347	3	21	\N	0	0	0	1	0	1	0	2024-06-13 00:00:00+00	1	0	0	0	0	0
359	3	23	\N	0	0	0	1	0	1	0	2024-06-14 00:00:00+00	1	0	0	0	0	0
348	3	25	\N	0	0	0	1	0	1	0	2024-06-13 00:00:00+00	1	0	0	0	0	0
349	3	24	\N	0	0	0	1	0	1	0	2024-06-13 00:00:00+00	1	0	0	0	0	0
370	3	32	\N	0	0	0	1	0	1	0	2024-06-18 00:00:00+00	1	0	0	0	0	0
360	5	32	\N	0	0	0	1	0	1	0	2024-06-21 00:00:00+00	1	0	0	0	0	0
350	6	11	\N	0	0	0	2	0	2	0	2024-06-13 00:00:00+00	2	0	0	0	0	0
361	5	31	\N	0	0	0	1	0	1	0	2024-06-18 00:00:00+00	1	0	0	0	0	0
389	3	18	\N	0	0	0	1	0	1	0	2024-06-21 00:00:00+00	1	0	0	0	0	0
385	3	11	\N	0	0	0	1	0	1	0	2024-06-19 00:00:00+00	1	0	0	0	0	0
335	6	21	\N	0	0	0	2	0	2	0	2024-06-21 00:00:00+00	2	0	0	0	0	0
362	5	43	\N	0	0	0	1	0	1	0	2024-06-17 00:00:00+00	1	0	0	0	0	0
352	6	22	\N	0	0	0	1	0	1	0	2024-06-14 00:00:00+00	1	0	0	0	0	0
353	5	2	\N	0	0	0	1	0	1	0	2024-06-14 00:00:00+00	1	0	0	0	0	0
371	3	23	\N	0	0	0	1	0	1	0	2024-06-18 00:00:00+00	1	0	0	0	0	0
379	5	32	\N	0	0	0	1	0	1	0	2024-07-01 00:00:00+00	1	0	0	0	0	0
391	5	32	\N	0	0	0	2	0	2	0	2024-07-04 00:00:00+00	2	0	0	0	0	0
369	3	22	\N	0	0	0	2	0	2	0	2024-06-18 00:00:00+00	2	0	0	0	0	0
344	5	11	\N	0	0	0	2	0	2	0	2024-06-17 00:00:00+00	2	0	0	0	0	0
364	6	29	\N	0	0	0	1	0	1	0	2024-06-17 00:00:00+00	1	0	0	0	0	0
365	6	28	\N	0	0	0	1	0	1	0	2024-06-17 00:00:00+00	1	0	0	0	0	0
372	6	24	\N	0	0	0	1	0	1	0	2024-06-18 00:00:00+00	1	0	0	0	0	0
366	6	23	\N	0	0	0	1	0	1	0	2024-06-17 00:00:00+00	1	0	0	0	0	0
373	6	29	\N	0	0	0	1	0	1	0	2024-06-18 00:00:00+00	1	0	0	0	0	0
393	3	11	\N	0	0	0	3	0	3	0	2024-06-25 00:00:00+00	3	0	0	0	0	0
374	5	32	\N	0	0	0	1	0	1	0	2024-06-18 00:00:00+00	1	0	0	0	0	0
381	6	29	\N	0	0	0	1	0	1	0	2024-06-19 00:00:00+00	1	0	0	0	0	0
375	5	2	\N	0	0	0	1	0	1	0	2024-06-25 00:00:00+00	1	0	0	0	0	0
376	5	25	\N	0	0	0	1	0	1	0	2024-06-18 00:00:00+00	1	0	0	0	0	0
384	3	23	\N	0	0	0	2	0	2	0	2024-06-19 00:00:00+00	2	0	0	0	0	0
377	5	11	\N	0	0	0	1	0	1	0	2024-06-24 00:00:00+00	1	0	0	0	0	0
382	6	23	\N	0	0	0	1	0	1	0	2024-06-19 00:00:00+00	1	0	0	0	0	0
345	5	21	\N	0	0	0	2	0	2	0	2024-06-13 00:00:00+00	2	0	0	0	0	0
390	3	38	\N	0	0	0	1	0	1	0	2024-06-21 00:00:00+00	1	0	0	0	0	0
386	6	35	\N	0	0	0	1	0	1	0	2024-06-20 00:00:00+00	1	0	0	0	0	0
351	6	32	\N	0	0	0	2	0	2	0	2024-06-20 00:00:00+00	2	0	0	0	0	0
387	3	2	\N	0	0	0	1	0	1	0	2024-06-21 00:00:00+00	1	0	0	0	0	0
380	5	32	\N	0	0	0	2	0	2	0	2024-07-09 00:00:00+00	2	0	0	0	0	0
383	6	32	\N	0	0	0	2	0	2	0	2024-07-16 00:00:00+00	2	0	0	0	0	0
396	6	18	\N	0	0	0	1	0	1	0	2024-06-24 00:00:00+00	1	0	0	0	0	0
395	5	23	\N	0	0	0	1	0	1	0	2024-06-24 00:00:00+00	1	0	0	0	0	0
392	3	18	\N	0	0	0	1	0	1	0	2024-06-25 00:00:00+00	1	0	0	0	0	0
394	3	2	\N	0	0	0	3	0	3	0	2024-06-25 00:00:00+00	3	0	0	0	0	0
397	5	32	\N	0	0	0	1	0	1	0	2024-06-25 00:00:00+00	1	0	0	0	0	0
398	5	30	\N	0	0	0	1	0	1	0	2024-07-03 00:00:00+00	1	0	0	0	0	0
399	5	30	\N	0	0	0	1	0	1	0	2024-07-01 00:00:00+00	1	0	0	0	0	0
400	6	11	\N	0	0	0	1	0	1	0	2024-07-01 00:00:00+00	1	0	0	0	0	0
401	6	18	\N	0	0	0	1	0	1	0	2024-06-25 00:00:00+00	1	0	0	0	0	0
402	5	29	\N	0	0	0	1	0	1	0	2024-06-26 00:00:00+00	1	0	0	0	0	0
403	3	2	\N	0	0	0	1	0	1	0	2024-06-26 00:00:00+00	1	0	0	0	0	0
404	3	38	\N	0	0	0	1	0	1	0	2024-06-27 00:00:00+00	1	0	0	0	0	0
405	6	25	\N	0	0	0	1	0	1	0	2024-10-14 00:00:00+00	1	0	0	0	0	0
388	6	32	\N	0	0	0	2	0	2	0	2024-06-28 00:00:00+00	2	0	0	0	0	0
425	3	32	\N	0	0	0	2	0	2	0	2024-07-04 00:00:00+00	2	0	0	0	0	0
406	6	28	\N	0	0	0	2	0	2	0	2024-06-28 00:00:00+00	2	0	0	0	0	0
440	5	29	\N	0	0	0	1	0	1	0	2024-07-09 00:00:00+00	1	0	0	0	0	0
407	3	18	\N	0	0	0	1	0	1	0	2024-06-28 00:00:00+00	1	0	0	0	0	0
426	3	25	\N	0	0	0	1	0	1	0	2024-07-04 00:00:00+00	1	0	0	0	0	0
408	5	28	\N	0	0	0	1	0	1	0	2024-06-28 00:00:00+00	1	0	0	0	0	0
409	5	24	\N	0	0	0	1	0	1	0	2024-07-04 00:00:00+00	1	0	0	0	0	0
410	5	4	\N	0	0	0	1	0	1	0	2024-07-01 00:00:00+00	1	0	0	0	0	0
427	3	29	\N	0	0	0	1	0	1	0	2024-07-04 00:00:00+00	1	0	0	0	0	0
411	5	8	\N	0	0	0	1	0	1	0	2024-07-01 00:00:00+00	1	0	0	0	0	0
412	6	18	\N	0	0	0	1	0	1	0	2024-07-01 00:00:00+00	1	0	0	0	0	0
468	5	28	\N	0	0	0	1	0	1	0	2024-07-11 00:00:00+00	1	0	0	0	0	0
413	3	18	\N	0	0	0	1	0	1	0	2024-07-01 00:00:00+00	1	0	0	0	0	0
428	5	30	\N	0	0	0	1	0	1	0	2024-07-09 00:00:00+00	1	0	0	0	0	0
414	5	27	\N	0	0	0	1	0	1	0	2024-07-02 00:00:00+00	1	0	0	0	0	0
415	5	23	\N	0	0	0	1	0	1	0	2024-07-03 00:00:00+00	1	0	0	0	0	0
441	3	22	\N	0	0	0	1	0	1	0	2024-07-08 00:00:00+00	1	0	0	0	0	0
416	5	23	\N	0	0	0	1	0	1	0	2024-07-02 00:00:00+00	1	0	0	0	0	0
451	6	4	\N	0	0	0	1	0	1	0	2024-07-11 00:00:00+00	1	0	0	0	0	0
442	3	11	\N	0	0	0	1	0	1	0	2024-07-08 00:00:00+00	1	0	0	0	0	0
429	6	27	\N	0	0	0	2	0	2	0	2024-07-04 00:00:00+00	2	0	0	0	0	0
417	5	13	\N	0	0	0	2	0	2	0	2024-07-02 00:00:00+00	2	0	0	0	0	0
430	6	13	\N	0	0	0	1	0	1	0	2024-07-04 00:00:00+00	1	0	0	0	0	0
418	6	13	\N	0	0	0	2	0	2	0	2024-07-02 00:00:00+00	2	0	0	0	0	0
419	6	11	\N	0	0	0	1	0	1	0	2024-07-02 00:00:00+00	1	0	0	0	0	0
431	6	25	\N	0	0	0	1	0	1	0	2024-07-04 00:00:00+00	1	0	0	0	0	0
420	3	18	\N	0	0	0	1	0	1	0	2024-07-03 00:00:00+00	1	0	0	0	0	0
421	3	25	\N	0	0	0	1	0	1	0	2024-07-03 00:00:00+00	1	0	0	0	0	0
443	3	23	\N	0	0	0	1	0	1	0	2024-11-08 00:00:00+00	1	0	0	0	0	0
422	6	25	\N	0	0	0	1	0	1	0	2024-07-03 00:00:00+00	1	0	0	0	0	0
432	6	34	\N	0	0	0	1	0	1	0	2024-07-05 00:00:00+00	1	0	0	0	0	0
423	5	29	\N	0	0	0	1	0	1	0	2024-07-03 00:00:00+00	1	0	0	0	0	0
424	3	18	\N	0	0	0	1	0	1	0	2024-07-04 00:00:00+00	1	0	0	0	0	0
433	6	13	\N	0	0	0	1	0	1	0	2024-07-05 00:00:00+00	1	0	0	0	0	0
457	5	12	\N	0	0	0	1	0	1	0	2024-07-09 00:00:00+00	1	0	0	0	0	0
444	6	12	\N	0	0	0	1	0	1	0	2024-07-08 00:00:00+00	1	0	0	0	0	0
434	3	22	\N	0	0	0	1	0	1	0	2024-07-05 00:00:00+00	1	0	0	0	0	0
435	3	6	\N	0	0	0	1	0	1	0	2024-07-05 00:00:00+00	1	0	0	0	0	0
452	6	2	\N	0	0	0	1	0	1	0	2024-07-09 00:00:00+00	1	0	0	0	0	0
436	3	6	\N	0	0	0	1	0	1	0	2024-11-12 00:00:00+00	1	0	0	0	0	0
445	5	22	\N	0	0	0	1	0	1	0	2024-07-08 00:00:00+00	1	0	0	0	0	0
437	3	34	\N	0	0	0	1	0	1	0	2024-07-05 00:00:00+00	1	0	0	0	0	0
438	5	22	\N	0	0	0	1	0	1	0	2024-07-05 00:00:00+00	1	0	0	0	0	0
439	5	12	\N	0	0	0	1	0	1	0	2024-07-05 00:00:00+00	1	0	0	0	0	0
446	5	16	\N	0	0	0	1	0	1	0	2024-07-16 00:00:00+00	1	0	0	0	0	0
453	3	18	\N	0	0	0	1	0	1	0	2024-07-09 00:00:00+00	1	0	0	0	0	0
447	6	18	\N	0	0	0	1	0	1	0	2024-07-09 00:00:00+00	1	0	0	0	0	0
448	6	27	\N	0	0	0	1	0	1	0	2024-07-17 00:00:00+00	1	0	0	0	0	0
462	3	25	\N	0	0	0	1	0	1	0	2024-07-10 00:00:00+00	1	0	0	0	0	0
458	5	35	\N	0	0	0	1	0	1	0	2024-07-09 00:00:00+00	1	0	0	0	0	0
450	6	41	\N	0	0	0	1	0	1	0	2024-07-09 00:00:00+00	1	0	0	0	0	0
454	3	11	\N	0	0	0	2	0	2	0	2024-07-09 00:00:00+00	2	0	0	0	0	0
459	5	27	\N	0	0	0	1	0	1	0	2024-07-09 00:00:00+00	1	0	0	0	0	0
455	3	32	\N	0	0	0	1	0	1	0	2024-07-09 00:00:00+00	1	0	0	0	0	0
456	5	19	\N	0	0	0	1	0	1	0	2024-07-10 00:00:00+00	1	0	0	0	0	0
465	5	27	\N	0	0	0	1	0	1	0	2024-07-10 00:00:00+00	1	0	0	0	0	0
460	3	18	\N	0	0	0	1	0	1	0	2024-07-10 00:00:00+00	1	0	0	0	0	0
463	3	22	\N	0	0	0	1	0	1	0	2024-07-10 00:00:00+00	1	0	0	0	0	0
461	3	11	\N	0	0	0	1	0	1	0	2024-07-10 00:00:00+00	1	0	0	0	0	0
464	5	38	\N	0	0	0	1	0	1	0	2024-07-10 00:00:00+00	1	0	0	0	0	0
467	5	13	\N	0	0	0	1	0	1	0	2024-07-12 00:00:00+00	1	0	0	0	0	0
466	5	18	\N	0	0	0	1	0	1	0	2024-07-19 00:00:00+00	1	0	0	0	0	0
469	5	28	\N	0	0	0	1	0	1	0	2024-11-05 00:00:00+00	1	0	0	0	0	0
470	3	18	\N	0	0	0	1	0	1	0	2024-07-11 00:00:00+00	1	0	0	0	0	0
471	3	11	\N	0	0	0	1	0	1	0	2024-07-11 00:00:00+00	1	0	0	0	0	0
472	3	29	\N	0	0	0	1	0	1	0	2024-07-11 00:00:00+00	1	0	0	0	0	0
449	6	11	\N	0	0	0	2	0	2	0	2024-07-12 00:00:00+00	2	0	0	0	0	0
473	3	22	\N	0	0	0	1	0	1	0	2024-07-11 00:00:00+00	1	0	0	0	0	0
474	6	21	\N	0	0	0	2	0	2	0	2024-07-11 00:00:00+00	2	0	0	0	0	0
475	6	27	\N	0	0	0	1	0	1	0	2024-07-11 00:00:00+00	1	0	0	0	0	0
476	6	19	\N	0	0	0	1	0	1	0	2024-07-11 00:00:00+00	1	0	0	0	0	0
477	5	37	\N	0	0	0	1	0	1	0	2024-07-12 00:00:00+00	1	0	0	0	0	0
500	3	18	\N	0	0	0	1	0	1	0	2024-07-18 00:00:00+00	1	0	0	0	0	0
478	5	39	\N	0	0	0	1	0	1	0	2024-07-12 00:00:00+00	1	0	0	0	0	0
479	3	23	\N	0	0	0	1	0	1	0	2024-07-12 00:00:00+00	1	0	0	0	0	0
519	5	19	\N	0	0	0	2	0	2	0	2024-07-23 00:00:00+00	2	0	0	0	0	0
480	3	29	\N	0	0	0	1	0	1	0	2024-07-12 00:00:00+00	1	0	0	0	0	0
501	3	29	\N	0	0	0	1	0	1	0	2024-07-18 00:00:00+00	1	0	0	0	0	0
481	6	23	\N	0	0	0	1	0	1	0	2024-07-22 00:00:00+00	1	0	0	0	0	0
482	6	6	\N	0	0	0	1	0	1	0	2024-07-12 00:00:00+00	1	0	0	0	0	0
515	3	4	\N	0	0	0	1	0	1	0	2024-07-22 00:00:00+00	1	0	0	0	0	0
483	6	13	\N	0	0	0	1	0	1	0	2024-07-12 00:00:00+00	1	0	0	0	0	0
502	6	25	\N	0	0	0	1	0	1	0	2024-07-18 00:00:00+00	1	0	0	0	0	0
484	6	35	\N	0	0	0	1	0	1	0	2024-07-12 00:00:00+00	1	0	0	0	0	0
485	3	25	\N	0	0	0	1	0	1	0	2024-07-15 00:00:00+00	1	0	0	0	0	0
486	3	32	\N	0	0	0	1	0	1	0	2024-07-15 00:00:00+00	1	0	0	0	0	0
503	3	16	\N	0	0	0	1	0	1	0	2024-10-14 00:00:00+00	1	0	0	0	0	0
487	6	12	\N	0	0	0	1	0	1	0	2024-07-15 00:00:00+00	1	0	0	0	0	0
489	6	8	\N	0	0	0	1	0	1	0	2024-07-15 00:00:00+00	1	0	0	0	0	0
504	6	13	\N	0	0	0	1	0	1	0	2024-07-18 00:00:00+00	1	0	0	0	0	0
490	6	19	\N	0	0	0	1	0	1	0	2024-07-15 00:00:00+00	1	0	0	0	0	0
491	3	18	\N	0	0	0	1	0	1	0	2024-07-16 00:00:00+00	1	0	0	0	0	0
516	3	43	\N	0	0	0	1	0	1	0	2024-07-22 00:00:00+00	1	0	0	0	0	0
492	3	22	\N	0	0	0	1	0	1	0	2024-07-16 00:00:00+00	1	0	0	0	0	0
505	6	21	\N	0	0	0	1	0	1	0	2024-07-18 00:00:00+00	1	0	0	0	0	0
493	3	29	\N	0	0	0	1	0	1	0	2024-07-16 00:00:00+00	1	0	0	0	0	0
494	5	43	\N	0	0	0	1	0	1	0	2024-07-16 00:00:00+00	1	0	0	0	0	0
495	5	24	\N	0	0	0	1	0	1	0	2024-07-16 00:00:00+00	1	0	0	0	0	0
506	6	4	\N	0	0	0	1	0	1	0	2024-07-22 00:00:00+00	1	0	0	0	0	0
496	5	35	\N	0	0	0	1	0	1	0	2024-07-16 00:00:00+00	1	0	0	0	0	0
497	6	40	\N	0	0	0	1	0	1	0	2024-07-16 00:00:00+00	1	0	0	0	0	0
529	6	13	\N	0	0	0	1	0	1	0	2024-07-23 00:00:00+00	1	0	0	0	0	0
498	3	25	\N	0	0	0	1	0	1	0	2024-07-17 00:00:00+00	1	0	0	0	0	0
507	6	28	\N	0	0	0	1	0	1	0	2024-11-11 00:00:00+00	1	0	0	0	0	0
499	3	29	\N	0	0	0	1	0	1	0	2024-07-17 00:00:00+00	1	0	0	0	0	0
517	6	19	\N	0	0	0	1	0	1	0	2024-07-22 00:00:00+00	1	0	0	0	0	0
508	6	13	\N	0	0	0	1	0	1	0	2024-07-19 00:00:00+00	1	0	0	0	0	0
523	3	23	\N	0	0	0	1	0	1	0	2024-07-23 00:00:00+00	1	0	0	0	0	0
509	5	43	\N	0	0	0	1	0	1	0	2024-07-19 00:00:00+00	1	0	0	0	0	0
518	6	21	\N	0	0	0	1	0	1	0	2024-07-29 00:00:00+00	1	0	0	0	0	0
510	5	13	\N	0	0	0	1	0	1	0	2024-07-19 00:00:00+00	1	0	0	0	0	0
511	3	16	\N	0	0	0	1	0	1	0	2024-07-19 00:00:00+00	1	0	0	0	0	0
512	3	4	\N	0	0	0	1	0	1	0	2024-07-19 00:00:00+00	1	0	0	0	0	0
513	3	25	\N	0	0	0	1	0	1	0	2024-07-22 00:00:00+00	1	0	0	0	0	0
514	3	16	\N	0	0	0	1	0	1	0	2024-07-22 00:00:00+00	1	0	0	0	0	0
524	3	25	\N	0	0	0	1	0	1	0	2024-07-23 00:00:00+00	1	0	0	0	0	0
525	3	18	\N	0	0	0	1	0	1	0	2024-07-23 00:00:00+00	1	0	0	0	0	0
520	5	21	\N	0	0	0	2	0	2	0	2024-07-22 00:00:00+00	2	0	0	0	0	0
521	5	23	\N	0	0	0	1	0	1	0	2024-07-23 00:00:00+00	1	0	0	0	0	0
522	5	16	\N	0	0	0	1	0	1	0	2024-07-24 00:00:00+00	1	0	0	0	0	0
526	3	22	\N	0	0	0	1	0	1	0	2024-07-23 00:00:00+00	1	0	0	0	0	0
534	5	27	\N	0	0	0	1	0	1	0	2024-07-24 00:00:00+00	1	0	0	0	0	0
527	6	41	\N	0	0	0	1	0	1	0	2024-07-23 00:00:00+00	1	0	0	0	0	0
531	3	18	\N	0	0	0	1	0	1	0	2024-07-25 00:00:00+00	1	0	0	0	0	0
528	6	38	\N	0	0	0	1	0	1	0	2024-07-26 00:00:00+00	1	0	0	0	0	0
539	5	24	\N	0	0	0	2	0	2	0	2024-07-25 00:00:00+00	2	0	0	0	0	0
535	6	16	\N	0	0	0	1	0	1	0	2024-07-26 00:00:00+00	1	0	0	0	0	0
533	5	27	\N	0	0	0	1	0	1	0	2024-07-29 00:00:00+00	1	0	0	0	0	0
537	3	38	\N	0	0	0	1	0	1	0	2024-07-25 00:00:00+00	1	0	0	0	0	0
536	6	41	\N	0	0	0	1	0	1	0	2024-07-24 00:00:00+00	1	0	0	0	0	0
532	3	29	\N	0	0	0	2	0	2	0	2024-07-25 00:00:00+00	2	0	0	0	0	0
530	3	25	\N	0	0	0	2	0	2	0	2024-07-25 00:00:00+00	2	0	0	0	0	0
540	3	29	\N	0	0	0	1	0	1	0	2024-07-26 00:00:00+00	1	0	0	0	0	0
538	5	23	\N	0	0	0	2	0	2	0	2024-07-25 00:00:00+00	2	0	0	0	0	0
541	3	32	\N	0	0	0	1	0	1	0	2024-07-26 00:00:00+00	1	0	0	0	0	0
542	5	24	\N	0	0	0	1	0	1	0	2024-07-26 00:00:00+00	1	0	0	0	0	0
543	5	28	\N	0	0	0	1	0	1	0	2024-07-26 00:00:00+00	1	0	0	0	0	0
544	5	29	\N	0	0	0	1	0	1	0	2024-07-26 00:00:00+00	1	0	0	0	0	0
545	6	28	\N	0	0	0	1	0	1	0	2024-07-26 00:00:00+00	1	0	0	0	0	0
546	6	24	\N	0	0	0	1	0	1	0	2024-07-26 00:00:00+00	1	0	0	0	0	0
547	6	23	\N	0	0	0	1	0	1	0	2024-07-26 00:00:00+00	1	0	0	0	0	0
548	6	27	\N	0	0	0	1	0	1	0	2024-07-26 00:00:00+00	1	0	0	0	0	0
549	5	18	\N	0	0	0	1	0	1	0	2024-07-29 00:00:00+00	1	0	0	0	0	0
550	5	28	\N	0	0	0	1	0	1	0	2024-07-30 00:00:00+00	1	0	0	0	0	0
571	6	24	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
551	5	19	\N	0	0	0	1	0	1	0	2024-07-29 00:00:00+00	1	0	0	0	0	0
552	3	22	\N	0	0	0	1	0	1	0	2024-07-29 00:00:00+00	1	0	0	0	0	0
585	6	24	\N	0	0	0	1	0	1	0	2024-09-03 00:00:00+00	1	0	0	0	0	0
553	6	13	\N	0	0	0	1	0	1	0	2024-07-30 00:00:00+00	1	0	0	0	0	0
572	6	38	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
554	6	19	\N	0	0	0	1	0	1	0	2024-07-30 00:00:00+00	1	0	0	0	0	0
573	6	4	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
555	3	38	\N	0	0	0	2	0	2	0	2024-07-30 00:00:00+00	2	0	0	0	0	0
594	5	21	\N	0	0	0	1	0	1	0	2024-09-26 00:00:00+00	1	0	0	0	0	0
556	3	28	\N	0	0	0	1	0	1	0	2024-07-30 00:00:00+00	1	0	0	0	0	0
574	6	21	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
557	3	42	\N	0	0	0	1	0	1	0	2024-07-30 00:00:00+00	1	0	0	0	0	0
558	3	22	\N	0	0	0	1	0	1	0	2024-07-30 00:00:00+00	1	0	0	0	0	0
586	6	19	\N	0	0	0	1	0	1	0	2024-09-03 00:00:00+00	1	0	0	0	0	0
559	3	19	\N	0	0	0	1	0	1	0	2024-07-31 00:00:00+00	1	0	0	0	0	0
575	5	27	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
560	3	25	\N	0	0	0	1	0	1	0	2024-07-31 00:00:00+00	1	0	0	0	0	0
561	3	22	\N	0	0	0	1	0	1	0	2024-07-31 00:00:00+00	1	0	0	0	0	0
562	3	38	\N	0	0	0	1	0	1	0	2024-07-31 00:00:00+00	1	0	0	0	0	0
576	5	21	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
614	6	8	\N	0	0	0	2	0	2	0	2024-09-23 00:00:00+00	2	0	0	0	0	0
564	5	27	\N	0	0	0	1	0	1	0	2024-07-31 00:00:00+00	1	0	0	0	0	0
565	6	41	\N	0	0	0	1	0	1	0	2024-07-31 00:00:00+00	1	0	0	0	0	0
577	5	28	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
566	3	18	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
567	3	23	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
587	6	13	\N	0	0	0	1	0	1	0	2024-09-03 00:00:00+00	1	0	0	0	0	0
568	3	22	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
578	5	19	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
569	3	24	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
570	7	23	\N	0	0	0	1	0	1	0	2024-09-02 00:00:00+00	1	0	0	0	0	0
579	5	19	\N	0	0	0	1	0	1	0	2024-09-05 00:00:00+00	1	0	0	0	0	0
607	7	29	\N	0	0	0	1	0	1	0	2024-09-20 00:00:00+00	1	0	0	0	0	0
595	5	24	\N	0	0	0	1	0	1	0	2024-09-18 00:00:00+00	1	0	0	0	0	0
604	5	21	\N	0	0	0	1	0	1	0	2024-09-24 00:00:00+00	1	0	0	0	0	0
580	7	18	\N	0	0	0	2	0	2	0	2024-09-03 00:00:00+00	2	0	0	0	0	0
588	7	27	\N	0	0	0	2	0	2	0	2024-09-04 00:00:00+00	2	0	0	0	0	0
581	7	23	\N	0	0	0	1	0	1	0	2024-09-03 00:00:00+00	1	0	0	0	0	0
582	7	23	\N	0	0	0	1	0	1	0	2024-10-23 00:00:00+00	1	0	0	0	0	0
596	5	29	\N	0	0	0	1	0	1	0	2024-09-18 00:00:00+00	1	0	0	0	0	0
583	7	17	\N	0	0	0	1	0	1	0	2024-09-03 00:00:00+00	1	0	0	0	0	0
589	7	18	\N	0	0	0	1	0	1	0	2024-09-04 00:00:00+00	1	0	0	0	0	0
584	5	18	\N	0	0	0	1	0	1	0	2024-09-03 00:00:00+00	1	0	0	0	0	0
590	5	29	\N	0	0	0	1	0	1	0	2024-09-04 00:00:00+00	1	0	0	0	0	0
591	7	18	\N	0	0	0	1	0	1	0	2024-09-05 00:00:00+00	1	0	0	0	0	0
597	5	23	\N	0	0	0	1	0	1	0	2024-10-01 00:00:00+00	1	0	0	0	0	0
592	7	23	\N	0	0	0	1	0	1	0	2024-09-05 00:00:00+00	1	0	0	0	0	0
593	5	25	\N	0	0	0	1	0	1	0	2024-09-18 00:00:00+00	1	0	0	0	0	0
601	7	23	\N	0	0	0	2	0	2	0	2024-09-19 00:00:00+00	2	0	0	0	0	0
598	7	23	\N	0	0	0	1	0	1	0	2024-09-18 00:00:00+00	1	0	0	0	0	0
599	6	8	\N	0	0	0	1	0	1	0	2024-09-18 00:00:00+00	1	0	0	0	0	0
600	6	17	\N	0	0	0	1	0	1	0	2024-09-18 00:00:00+00	1	0	0	0	0	0
605	5	39	\N	0	0	0	1	0	1	0	2024-09-19 00:00:00+00	1	0	0	0	0	0
602	6	18	\N	0	0	0	2	0	2	0	2024-09-19 00:00:00+00	2	0	0	0	0	0
606	7	13	\N	0	0	0	1	0	1	0	2024-09-20 00:00:00+00	1	0	0	0	0	0
603	6	13	\N	0	0	0	1	0	1	0	2024-09-19 00:00:00+00	1	0	0	0	0	0
611	6	18	\N	0	0	0	1	0	1	0	2024-09-23 00:00:00+00	1	0	0	0	0	0
608	7	23	\N	0	0	0	1	0	1	0	2024-09-20 00:00:00+00	1	0	0	0	0	0
610	5	19	\N	0	0	0	1	0	1	0	2024-09-20 00:00:00+00	1	0	0	0	0	0
609	5	25	\N	0	0	0	1	0	1	0	2024-09-24 00:00:00+00	1	0	0	0	0	0
612	6	7	\N	0	0	0	1	0	1	0	2024-10-01 00:00:00+00	1	0	0	0	0	0
613	6	7	\N	0	0	0	1	0	1	0	2024-09-30 00:00:00+00	1	0	0	0	0	0
615	5	18	\N	0	0	0	1	0	1	0	2024-09-30 00:00:00+00	1	0	0	0	0	0
616	5	19	\N	0	0	0	1	0	1	0	2024-09-23 00:00:00+00	1	0	0	0	0	0
617	5	19	\N	0	0	0	1	0	1	0	2024-09-25 00:00:00+00	1	0	0	0	0	0
618	7	13	\N	0	0	0	1	0	1	0	2024-09-23 00:00:00+00	1	0	0	0	0	0
619	7	23	\N	0	0	0	1	0	1	0	2024-09-23 00:00:00+00	1	0	0	0	0	0
563	5	24	\N	0	0	0	2	0	2	0	2024-07-31 00:00:00+00	2	0	0	0	0	0
640	5	19	\N	0	0	0	1	0	1	0	2024-09-26 00:00:00+00	1	0	0	0	0	0
621	6	25	\N	0	0	0	1	0	1	0	2024-09-24 00:00:00+00	1	0	0	0	0	0
620	6	19	\N	0	0	0	2	0	2	0	2024-09-24 00:00:00+00	2	0	0	0	0	0
641	5	17	\N	0	0	0	1	0	1	0	2024-09-26 00:00:00+00	1	0	0	0	0	0
622	3	21	\N	0	0	0	1	0	1	0	2024-09-24 00:00:00+00	1	0	0	0	0	0
623	3	22	\N	0	0	0	1	0	1	0	2024-09-24 00:00:00+00	1	0	0	0	0	0
654	6	40	\N	0	0	0	1	0	1	0	2024-10-01 00:00:00+00	1	0	0	0	0	0
624	3	18	\N	0	0	0	1	0	1	0	2024-09-24 00:00:00+00	1	0	0	0	0	0
642	5	28	\N	0	0	0	1	0	1	0	2024-10-07 00:00:00+00	1	0	0	0	0	0
625	7	23	\N	0	0	0	1	0	1	0	2024-09-24 00:00:00+00	1	0	0	0	0	0
655	6	18	\N	0	0	0	1	0	1	0	2024-10-01 00:00:00+00	1	0	0	0	0	0
626	7	18	\N	0	0	0	2	0	2	0	2024-09-24 00:00:00+00	2	0	0	0	0	0
627	7	29	\N	0	0	0	1	0	1	0	2024-09-24 00:00:00+00	1	0	0	0	0	0
643	5	28	\N	0	0	0	2	0	2	0	2024-09-26 00:00:00+00	2	0	0	0	0	0
628	5	28	\N	0	0	0	1	0	1	0	2024-09-24 00:00:00+00	1	0	0	0	0	0
644	3	41	\N	0	0	0	1	0	1	0	2024-09-27 00:00:00+00	1	0	0	0	0	0
629	5	2	\N	0	0	0	2	0	2	0	2024-10-25 00:00:00+00	2	0	0	0	0	0
656	3	23	\N	0	0	0	1	0	1	0	2024-10-01 00:00:00+00	1	0	0	0	0	0
630	7	21	\N	0	0	0	1	0	1	0	2024-09-25 00:00:00+00	1	0	0	0	0	0
645	3	23	\N	0	0	0	1	0	1	0	2024-09-27 00:00:00+00	1	0	0	0	0	0
631	7	17	\N	0	0	0	1	0	1	0	2024-09-25 00:00:00+00	1	0	0	0	0	0
632	5	21	\N	0	0	0	1	0	1	0	2024-09-27 00:00:00+00	1	0	0	0	0	0
633	5	24	\N	0	0	0	1	0	1	0	2024-09-25 00:00:00+00	1	0	0	0	0	0
646	3	21	\N	0	0	0	1	0	1	0	2024-09-27 00:00:00+00	1	0	0	0	0	0
634	5	19	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
635	5	7	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
669	6	40	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
636	6	14	\N	0	0	0	1	0	1	0	2024-09-25 00:00:00+00	1	0	0	0	0	0
647	3	22	\N	0	0	0	1	0	1	0	2024-09-27 00:00:00+00	1	0	0	0	0	0
637	6	13	\N	0	0	0	1	0	1	0	2024-09-25 00:00:00+00	1	0	0	0	0	0
638	6	39	\N	0	0	0	1	0	1	0	2024-09-26 00:00:00+00	1	0	0	0	0	0
639	5	24	\N	0	0	0	1	0	1	0	2024-10-07 00:00:00+00	1	0	0	0	0	0
678	3	22	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
657	7	18	\N	0	0	0	2	0	2	0	2024-10-01 00:00:00+00	2	0	0	0	0	0
648	7	18	\N	0	0	0	2	0	2	0	2024-09-27 00:00:00+00	2	0	0	0	0	0
670	6	7	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
649	7	23	\N	0	0	0	1	0	1	0	2024-09-27 00:00:00+00	1	0	0	0	0	0
658	7	13	\N	0	0	0	1	0	1	0	2024-10-01 00:00:00+00	1	0	0	0	0	0
650	7	13	\N	0	0	0	1	0	1	0	2024-09-27 00:00:00+00	1	0	0	0	0	0
651	5	1	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
664	7	27	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
652	5	24	\N	0	0	0	1	0	1	0	2024-09-30 00:00:00+00	1	0	0	0	0	0
659	5	28	\N	0	0	0	3	0	3	0	2024-10-09 00:00:00+00	3	0	0	0	0	0
653	5	23	\N	0	0	0	1	0	1	0	2024-09-30 00:00:00+00	1	0	0	0	0	0
660	5	25	\N	0	0	0	1	0	1	0	2024-10-17 00:00:00+00	1	0	0	0	0	0
675	5	19	\N	0	0	0	1	0	1	0	2024-10-18 00:00:00+00	1	0	0	0	0	0
663	7	18	\N	0	0	0	3	0	3	0	2024-10-03 00:00:00+00	3	0	0	0	0	0
671	6	22	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
661	5	29	\N	0	0	0	2	0	2	0	2024-10-01 00:00:00+00	2	0	0	0	0	0
665	3	22	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
662	7	18	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
666	3	18	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
667	3	21	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
672	5	39	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
668	3	25	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
673	5	27	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
676	5	19	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
674	5	22	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
677	5	27	\N	0	0	0	1	0	1	0	2024-10-07 00:00:00+00	1	0	0	0	0	0
682	7	32	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
679	3	21	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
681	7	29	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
680	3	25	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
683	7	33	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
684	6	28	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
685	6	19	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
686	6	18	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
687	6	22	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
688	6	13	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
689	5	22	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
690	5	27	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
691	3	18	\N	0	0	0	1	0	1	0	2024-10-07 00:00:00+00	1	0	0	0	0	0
714	7	18	\N	0	0	0	1	0	1	0	2024-10-09 00:00:00+00	1	0	0	0	0	0
692	3	21	\N	0	0	0	1	0	1	0	2024-10-07 00:00:00+00	1	0	0	0	0	0
693	3	28	\N	0	0	0	1	0	1	0	2024-10-07 00:00:00+00	1	0	0	0	0	0
694	7	18	\N	0	0	0	1	0	1	0	2024-10-07 00:00:00+00	1	0	0	0	0	0
715	7	23	\N	0	0	0	1	0	1	0	2024-10-14 00:00:00+00	1	0	0	0	0	0
696	6	30	\N	0	0	0	2	0	2	0	2024-10-16 00:00:00+00	2	0	0	0	0	0
702	5	19	\N	0	0	0	2	0	2	0	2024-10-11 00:00:00+00	2	0	0	0	0	0
728	3	18	\N	0	0	0	1	0	1	0	2024-10-11 00:00:00+00	1	0	0	0	0	0
697	6	30	\N	0	0	0	1	0	1	0	2024-10-08 00:00:00+00	1	0	0	0	0	0
716	7	13	\N	0	0	0	1	0	1	0	2024-10-09 00:00:00+00	1	0	0	0	0	0
698	6	45	\N	0	0	0	1	0	1	0	2024-10-07 00:00:00+00	1	0	0	0	0	0
699	6	19	\N	0	0	0	1	0	1	0	2024-10-07 00:00:00+00	1	0	0	0	0	0
700	5	22	\N	0	0	0	1	0	1	0	2024-10-11 00:00:00+00	1	0	0	0	0	0
717	6	18	\N	0	0	0	1	0	1	0	2024-10-09 00:00:00+00	1	0	0	0	0	0
701	5	19	\N	0	0	0	1	0	1	0	2024-10-07 00:00:00+00	1	0	0	0	0	0
703	5	30	\N	0	0	0	1	0	1	0	2024-10-09 00:00:00+00	1	0	0	0	0	0
718	6	19	\N	0	0	0	1	0	1	0	2024-10-16 00:00:00+00	1	0	0	0	0	0
704	5	23	\N	0	0	0	1	0	1	0	2024-10-07 00:00:00+00	1	0	0	0	0	0
705	3	18	\N	0	0	0	1	0	1	0	2024-10-08 00:00:00+00	1	0	0	0	0	0
729	3	22	\N	0	0	0	1	0	1	0	2024-10-11 00:00:00+00	1	0	0	0	0	0
706	3	25	\N	0	0	0	1	0	1	0	2024-10-08 00:00:00+00	1	0	0	0	0	0
719	5	8	\N	0	0	0	1	0	1	0	2024-10-09 00:00:00+00	1	0	0	0	0	0
707	3	29	\N	0	0	0	1	0	1	0	2024-10-08 00:00:00+00	1	0	0	0	0	0
708	7	17	\N	0	0	0	1	0	1	0	2024-10-08 00:00:00+00	1	0	0	0	0	0
709	7	18	\N	0	0	0	1	0	1	0	2024-10-08 00:00:00+00	1	0	0	0	0	0
720	5	18	\N	0	0	0	1	0	1	0	2024-10-09 00:00:00+00	1	0	0	0	0	0
710	3	21	\N	0	0	0	1	0	1	0	2024-10-09 00:00:00+00	1	0	0	0	0	0
711	3	18	\N	0	0	0	1	0	1	0	2024-10-09 00:00:00+00	1	0	0	0	0	0
736	6	24	\N	0	0	0	1	0	1	0	2024-10-11 00:00:00+00	1	0	0	0	0	0
712	3	25	\N	0	0	0	1	0	1	0	2024-10-09 00:00:00+00	1	0	0	0	0	0
721	3	21	\N	0	0	0	1	0	1	0	2024-10-10 00:00:00+00	1	0	0	0	0	0
713	3	29	\N	0	0	0	1	0	1	0	2024-10-09 00:00:00+00	1	0	0	0	0	0
730	3	23	\N	0	0	0	1	0	1	0	2024-10-11 00:00:00+00	1	0	0	0	0	0
722	3	18	\N	0	0	0	1	0	1	0	2024-10-10 00:00:00+00	1	0	0	0	0	0
723	3	22	\N	0	0	0	1	0	1	0	2024-10-10 00:00:00+00	1	0	0	0	0	0
742	7	25	\N	0	0	0	1	0	1	0	2024-10-14 00:00:00+00	1	0	0	0	0	0
724	3	23	\N	0	0	0	1	0	1	0	2024-10-10 00:00:00+00	1	0	0	0	0	0
737	3	21	\N	0	0	0	1	0	1	0	2024-10-14 00:00:00+00	1	0	0	0	0	0
731	7	18	\N	0	0	0	2	0	2	0	2024-10-11 00:00:00+00	2	0	0	0	0	0
725	7	17	\N	0	0	0	2	0	2	0	2024-10-10 00:00:00+00	2	0	0	0	0	0
726	5	25	\N	0	0	0	1	0	1	0	2024-10-16 00:00:00+00	1	0	0	0	0	0
732	7	23	\N	0	0	0	1	0	1	0	2024-10-11 00:00:00+00	1	0	0	0	0	0
727	3	21	\N	0	0	0	1	0	1	0	2024-10-11 00:00:00+00	1	0	0	0	0	0
738	3	18	\N	0	0	0	1	0	1	0	2024-10-14 00:00:00+00	1	0	0	0	0	0
733	5	27	\N	0	0	0	1	0	1	0	2024-10-11 00:00:00+00	1	0	0	0	0	0
746	7	35	\N	0	0	0	1	0	1	0	2024-10-17 00:00:00+00	1	0	0	0	0	0
739	3	22	\N	0	0	0	1	0	1	0	2024-10-14 00:00:00+00	1	0	0	0	0	0
734	6	14	\N	0	0	0	2	0	2	0	2024-10-11 00:00:00+00	2	0	0	0	0	0
743	5	22	\N	0	0	0	1	0	1	0	2024-10-14 00:00:00+00	1	0	0	0	0	0
735	6	22	\N	0	0	0	1	0	1	0	2024-10-11 00:00:00+00	1	0	0	0	0	0
740	3	32	\N	0	0	0	1	0	1	0	2024-10-14 00:00:00+00	1	0	0	0	0	0
744	5	25	\N	0	0	0	1	0	1	0	2024-10-21 00:00:00+00	1	0	0	0	0	0
741	7	18	\N	0	0	0	2	0	2	0	2024-10-14 00:00:00+00	2	0	0	0	0	0
753	7	18	\N	0	0	0	1	0	1	0	2024-10-16 00:00:00+00	1	0	0	0	0	0
747	7	13	\N	0	0	0	1	0	1	0	2024-10-16 00:00:00+00	1	0	0	0	0	0
750	3	22	\N	0	0	0	1	0	1	0	2024-10-16 00:00:00+00	1	0	0	0	0	0
745	5	25	\N	0	0	0	2	0	2	0	2024-10-15 00:00:00+00	2	0	0	0	0	0
748	3	21	\N	0	0	0	1	0	1	0	2024-10-16 00:00:00+00	1	0	0	0	0	0
749	3	18	\N	0	0	0	1	0	1	0	2024-10-16 00:00:00+00	1	0	0	0	0	0
752	7	23	\N	0	0	0	1	0	1	0	2024-10-16 00:00:00+00	1	0	0	0	0	0
751	3	23	\N	0	0	0	1	0	1	0	2024-10-16 00:00:00+00	1	0	0	0	0	0
754	5	37	\N	0	0	0	1	0	1	0	2024-10-16 00:00:00+00	1	0	0	0	0	0
755	6	18	\N	0	0	0	2	0	2	0	2024-10-22 00:00:00+00	2	0	0	0	0	0
756	3	21	\N	0	0	0	1	0	1	0	2024-10-17 00:00:00+00	1	0	0	0	0	0
757	3	18	\N	0	0	0	1	0	1	0	2024-10-17 00:00:00+00	1	0	0	0	0	0
758	3	22	\N	0	0	0	1	0	1	0	2024-10-17 00:00:00+00	1	0	0	0	0	0
759	3	29	\N	0	0	0	1	0	1	0	2024-10-23 00:00:00+00	1	0	0	0	0	0
760	3	16	\N	0	0	0	1	0	1	0	2024-10-17 00:00:00+00	1	0	0	0	0	0
761	7	13	\N	0	0	0	1	0	1	0	2024-10-17 00:00:00+00	1	0	0	0	0	0
695	7	29	\N	0	0	0	2	0	2	0	2024-10-07 00:00:00+00	2	0	0	0	0	0
762	5	27	\N	0	0	0	2	0	2	0	2024-10-17 00:00:00+00	2	0	0	0	0	0
763	7	18	\N	0	0	0	1	0	1	0	2024-10-18 00:00:00+00	1	0	0	0	0	0
785	6	35	\N	0	0	0	1	0	1	0	2024-10-23 00:00:00+00	1	0	0	0	0	0
764	7	13	\N	0	0	0	1	0	1	0	2024-10-18 00:00:00+00	1	0	0	0	0	0
765	7	19	\N	0	0	0	1	0	1	0	2024-10-18 00:00:00+00	1	0	0	0	0	0
766	7	34	\N	0	0	0	1	0	1	0	2024-10-18 00:00:00+00	1	0	0	0	0	0
786	6	25	\N	0	0	0	1	0	1	0	2024-10-23 00:00:00+00	1	0	0	0	0	0
767	6	27	\N	0	0	0	1	0	1	0	2024-10-18 00:00:00+00	1	0	0	0	0	0
768	6	18	\N	0	0	0	1	0	1	0	2024-10-21 00:00:00+00	1	0	0	0	0	0
800	6	23	\N	0	0	0	1	0	1	0	2024-10-29 00:00:00+00	1	0	0	0	0	0
769	7	18	\N	0	0	0	1	0	1	0	2024-10-21 00:00:00+00	1	0	0	0	0	0
787	7	18	\N	0	0	0	1	0	1	0	2024-10-23 00:00:00+00	1	0	0	0	0	0
770	7	13	\N	0	0	0	1	0	1	0	2024-10-21 00:00:00+00	1	0	0	0	0	0
771	5	16	\N	0	0	0	1	0	1	0	2024-11-05 00:00:00+00	1	0	0	0	0	0
772	5	27	\N	0	0	0	1	0	1	0	2024-10-21 00:00:00+00	1	0	0	0	0	0
788	7	29	\N	0	0	0	1	0	1	0	2024-10-23 00:00:00+00	1	0	0	0	0	0
773	5	23	\N	0	0	0	1	0	1	0	2024-10-21 00:00:00+00	1	0	0	0	0	0
774	7	18	\N	0	0	0	1	0	1	0	2024-10-22 00:00:00+00	1	0	0	0	0	0
775	7	13	\N	0	0	0	1	0	1	0	2024-10-22 00:00:00+00	1	0	0	0	0	0
789	5	33	\N	0	0	0	1	0	1	0	2024-10-23 00:00:00+00	1	0	0	0	0	0
776	6	4	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
777	6	7	\N	0	0	0	1	0	1	0	2024-10-22 00:00:00+00	1	0	0	0	0	0
801	5	27	\N	0	0	0	1	0	1	0	2024-11-01 00:00:00+00	1	0	0	0	0	0
778	5	3	\N	0	0	0	1	0	1	0	2024-11-11 00:00:00+00	1	0	0	0	0	0
790	5	6	\N	0	0	0	1	0	1	0	2024-10-24 00:00:00+00	1	0	0	0	0	0
779	5	4	\N	0	0	0	1	0	1	0	2024-11-14 00:00:00+00	1	0	0	0	0	0
780	5	27	\N	0	0	0	1	0	1	0	2024-10-24 00:00:00+00	1	0	0	0	0	0
781	3	18	\N	0	0	0	1	0	1	0	2024-10-22 00:00:00+00	1	0	0	0	0	0
791	6	14	\N	0	0	0	1	0	1	0	2024-10-24 00:00:00+00	1	0	0	0	0	0
782	3	25	\N	0	0	0	1	0	1	0	2024-10-22 00:00:00+00	1	0	0	0	0	0
783	3	13	\N	0	0	0	1	0	1	0	2024-10-22 00:00:00+00	1	0	0	0	0	0
814	6	27	\N	0	0	0	1	0	1	0	2024-11-05 00:00:00+00	1	0	0	0	0	0
784	3	29	\N	0	0	0	1	0	1	0	2024-10-22 00:00:00+00	1	0	0	0	0	0
792	5	27	\N	0	0	0	1	0	1	0	2024-10-25 00:00:00+00	1	0	0	0	0	0
802	6	19	\N	0	0	0	1	0	1	0	2024-11-04 00:00:00+00	1	0	0	0	0	0
793	5	4	\N	0	0	0	1	0	1	0	2024-11-05 00:00:00+00	1	0	0	0	0	0
794	3	21	\N	0	0	0	1	0	1	0	2024-10-28 00:00:00+00	1	0	0	0	0	0
809	3	22	\N	0	0	0	2	0	2	0	2024-11-05 00:00:00+00	2	0	0	0	0	0
795	3	22	\N	0	0	0	1	0	1	0	2024-10-28 00:00:00+00	1	0	0	0	0	0
803	6	25	\N	0	0	0	1	0	1	0	2024-11-04 00:00:00+00	1	0	0	0	0	0
796	3	23	\N	0	0	0	1	0	1	0	2024-10-28 00:00:00+00	1	0	0	0	0	0
797	5	23	\N	0	0	0	1	0	1	0	2024-10-28 00:00:00+00	1	0	0	0	0	0
798	5	43	\N	0	0	0	1	0	1	0	2024-11-04 00:00:00+00	1	0	0	0	0	0
804	5	19	\N	0	0	0	1	0	1	0	2024-11-04 00:00:00+00	1	0	0	0	0	0
799	5	25	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
805	5	22	\N	0	0	0	1	0	1	0	2024-11-04 00:00:00+00	1	0	0	0	0	0
806	5	27	\N	0	0	0	1	0	1	0	2024-11-04 00:00:00+00	1	0	0	0	0	0
815	7	19	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
807	7	35	\N	0	0	0	1	0	1	0	2024-11-04 00:00:00+00	1	0	0	0	0	0
808	3	21	\N	0	0	0	1	0	1	0	2024-11-05 00:00:00+00	1	0	0	0	0	0
819	3	39	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
810	7	16	\N	0	0	0	2	0	2	0	2024-11-05 00:00:00+00	2	0	0	0	0	0
816	7	27	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
811	7	35	\N	0	0	0	1	0	1	0	2024-11-05 00:00:00+00	1	0	0	0	0	0
812	7	33	\N	0	0	0	1	0	1	0	2024-11-05 00:00:00+00	1	0	0	0	0	0
813	6	33	\N	0	0	0	1	0	1	0	2024-11-05 00:00:00+00	1	0	0	0	0	0
817	7	4	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
818	7	13	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
820	3	28	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
822	3	23	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
821	3	5	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
823	6	24	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
824	5	43	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
825	6	22	\N	0	0	0	1	0	1	0	2024-11-07 00:00:00+00	1	0	0	0	0	0
826	7	35	\N	0	0	0	1	0	1	0	2024-11-07 00:00:00+00	1	0	0	0	0	0
827	5	29	\N	0	0	0	1	0	1	0	2024-11-12 00:00:00+00	1	0	0	0	0	0
829	7	9	\N	0	0	0	4	0	4	0	2024-11-11 00:00:00+00	4	0	0	0	0	0
830	7	19	\N	0	0	0	1	0	1	0	2024-11-11 00:00:00+00	1	0	0	0	0	0
828	7	35	\N	0	0	0	2	0	2	0	2024-11-11 00:00:00+00	2	0	0	0	0	0
831	7	33	\N	0	0	0	1	0	1	0	2024-11-11 00:00:00+00	1	0	0	0	0	0
832	5	19	\N	0	0	0	1	0	1	0	2024-11-11 00:00:00+00	1	0	0	0	0	0
833	5	19	\N	0	0	0	2	0	2	0	2024-11-12 00:00:00+00	2	0	0	0	0	0
835	3	22	\N	0	0	0	2	0	2	0	2024-11-11 00:00:00+00	2	0	0	0	0	0
875	7	33	\N	0	0	0	2	0	2	0	2024-11-14 00:00:00+00	2	0	0	0	0	0
851	5	33	\N	0	0	0	1	0	1	0	2024-11-12 00:00:00+00	1	0	0	0	0	0
837	3	23	\N	0	0	0	1	0	1	0	2024-11-11 00:00:00+00	1	0	0	0	0	0
842	6	33	\N	0	0	0	3	0	3	0	2024-11-15 00:00:00+00	3	0	0	0	0	0
889	3	22	\N	0	0	0	1	0	1	0	2024-11-15 00:00:00+00	1	0	0	0	0	0
836	3	21	\N	0	0	0	2	0	2	0	2024-11-11 00:00:00+00	2	0	0	0	0	0
838	7	33	\N	0	0	0	1	0	1	0	2024-11-12 00:00:00+00	1	0	0	0	0	0
853	5	33	\N	0	0	0	1	0	1	0	2024-11-15 00:00:00+00	1	0	0	0	0	0
886	6	29	\N	0	0	0	1	0	1	0	2024-11-15 00:00:00+00	1	0	0	0	0	0
854	5	45	\N	0	0	0	1	0	1	0	2024-11-15 00:00:00+00	1	0	0	0	0	0
840	7	24	\N	0	0	0	1	0	1	0	2024-11-12 00:00:00+00	1	0	0	0	0	0
866	5	19	\N	0	0	0	2	0	2	0	2024-11-13 00:00:00+00	2	0	0	0	0	0
855	7	19	\N	0	0	0	1	0	1	0	2024-11-13 00:00:00+00	1	0	0	0	0	0
839	7	13	\N	0	0	0	3	0	3	0	2024-11-12 00:00:00+00	3	0	0	0	0	0
841	6	33	\N	0	0	0	1	0	1	0	2024-11-12 00:00:00+00	1	0	0	0	0	0
856	7	24	\N	0	0	0	1	0	1	0	2024-11-13 00:00:00+00	1	0	0	0	0	0
876	7	45	\N	0	0	0	1	0	1	0	2024-11-14 00:00:00+00	1	0	0	0	0	0
834	5	38	\N	0	0	0	2	0	2	0	2024-11-19 00:00:00+00	2	0	0	0	0	0
843	6	19	\N	0	0	0	2	0	2	0	2024-11-14 00:00:00+00	2	0	0	0	0	0
844	6	24	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
845	6	22	\N	0	0	0	1	0	1	0	2024-11-12 00:00:00+00	1	0	0	0	0	0
857	7	35	\N	0	0	0	2	0	2	0	2024-11-13 00:00:00+00	2	0	0	0	0	0
846	6	25	\N	0	0	0	1	0	1	0	2024-11-12 00:00:00+00	1	0	0	0	0	0
868	5	2	\N	0	0	0	1	0	1	0	2024-11-15 00:00:00+00	1	0	0	0	0	0
858	7	27	\N	0	0	0	1	0	1	0	2024-11-13 00:00:00+00	1	0	0	0	0	0
847	3	22	\N	0	0	0	2	0	2	0	2024-11-12 00:00:00+00	2	0	0	0	0	0
848	3	23	\N	0	0	0	1	0	1	0	2024-11-12 00:00:00+00	1	0	0	0	0	0
859	7	33	\N	0	0	0	1	0	1	0	2024-11-13 00:00:00+00	1	0	0	0	0	0
849	5	23	\N	0	0	0	1	0	1	0	2024-11-12 00:00:00+00	1	0	0	0	0	0
850	5	27	\N	0	0	0	1	0	1	0	2024-11-12 00:00:00+00	1	0	0	0	0	0
869	6	33	\N	0	0	0	1	0	1	0	2024-11-14 00:00:00+00	1	0	0	0	0	0
894	5	27	\N	0	0	0	2	0	2	0	2024-11-15 00:00:00+00	2	0	0	0	0	0
861	3	19	\N	0	0	0	1	0	1	0	2024-11-13 00:00:00+00	1	0	0	0	0	0
877	7	27	\N	0	0	0	1	0	1	0	2024-11-14 00:00:00+00	1	0	0	0	0	0
862	3	21	\N	0	0	0	1	0	1	0	2024-11-13 00:00:00+00	1	0	0	0	0	0
863	3	27	\N	0	0	0	1	0	1	0	2024-11-13 00:00:00+00	1	0	0	0	0	0
892	3	21	\N	0	0	0	1	0	1	0	2024-11-15 00:00:00+00	1	0	0	0	0	0
864	5	27	\N	0	0	0	1	0	1	0	2024-11-13 00:00:00+00	1	0	0	0	0	0
878	7	9	\N	0	0	0	1	0	1	0	2024-11-14 00:00:00+00	1	0	0	0	0	0
865	5	33	\N	0	0	0	1	0	1	0	2024-11-13 00:00:00+00	1	0	0	0	0	0
870	6	19	\N	0	0	0	2	0	2	0	2024-11-13 00:00:00+00	2	0	0	0	0	0
882	3	19	\N	0	0	0	2	0	2	0	2024-11-14 00:00:00+00	2	0	0	0	0	0
872	6	25	\N	0	0	0	1	0	1	0	2024-11-13 00:00:00+00	1	0	0	0	0	0
879	6	14	\N	0	0	0	1	0	1	0	2024-11-14 00:00:00+00	1	0	0	0	0	0
873	6	33	\N	0	0	0	1	0	1	0	2024-11-13 00:00:00+00	1	0	0	0	0	0
887	6	13	\N	0	0	0	1	0	1	0	2024-11-15 00:00:00+00	1	0	0	0	0	0
874	6	35	\N	0	0	0	1	0	1	0	2024-11-13 00:00:00+00	1	0	0	0	0	0
883	3	23	\N	0	0	0	1	0	1	0	2024-11-14 00:00:00+00	1	0	0	0	0	0
871	6	40	\N	0	0	0	2	0	2	0	2024-11-18 00:00:00+00	2	0	0	0	0	0
890	3	19	\N	0	0	0	1	0	1	0	2024-11-15 00:00:00+00	1	0	0	0	0	0
880	6	5	\N	0	0	0	1	0	1	0	2024-11-14 00:00:00+00	1	0	0	0	0	0
881	3	22	\N	0	0	0	1	0	1	0	2024-11-14 00:00:00+00	1	0	0	0	0	0
852	5	33	\N	0	0	0	2	0	2	0	2024-11-14 00:00:00+00	2	0	0	0	0	0
885	6	19	\N	0	0	0	2	0	2	0	2024-11-15 00:00:00+00	2	0	0	0	0	0
884	5	33	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
860	3	22	\N	0	0	0	2	0	2	0	2024-11-13 00:00:00+00	2	0	0	0	0	0
888	6	21	\N	0	0	0	1	0	1	0	2024-11-15 00:00:00+00	1	0	0	0	0	0
891	3	27	\N	0	0	0	1	0	1	0	2024-11-15 00:00:00+00	1	0	0	0	0	0
893	3	38	\N	0	0	0	1	0	1	0	2024-11-15 00:00:00+00	1	0	0	0	0	0
896	5	24	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
895	5	14	\N	0	0	0	2	0	2	0	2024-11-15 00:00:00+00	2	0	0	0	0	0
867	5	2	\N	0	0	0	2	0	2	0	2024-11-19 00:00:00+00	2	0	0	0	0	0
898	7	24	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
899	7	33	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
900	7	35	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
901	7	9	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
902	3	21	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
903	3	23	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
897	5	27	\N	0	0	0	2	0	2	0	2024-11-18 00:00:00+00	2	0	0	0	0	0
904	3	27	\N	0	0	0	2	0	2	0	2024-11-18 00:00:00+00	2	0	0	0	0	0
940	5	32	\N	0	0	0	1	0	1	0	2024-07-02 00:00:00+00	1	0	0	0	0	0
905	6	19	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
925	6	22	\N	0	0	0	2	0	2	0	2024-11-19 00:00:00+00	2	0	0	0	0	0
906	6	29	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
907	6	27	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
908	6	33	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
926	6	40	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
909	6	23	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
910	6	21	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
950	6	12	\N	0	0	0	1	0	1	0	2024-07-09 00:00:00+00	1	0	0	0	0	0
911	5	41	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
927	6	13	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
912	5	19	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
913	5	21	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
941	5	11	\N	0	0	0	1	0	1	0	2024-07-05 00:00:00+00	1	0	0	0	0	0
914	5	31	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
928	5	22	\N	0	0	0	1	0	1	0	2024-06-05 00:00:00+00	1	0	0	0	0	0
929	5	2	\N	0	0	0	1	0	1	0	2024-06-04 00:00:00+00	1	0	0	0	0	0
915	7	35	\N	0	0	0	2	0	2	0	2024-11-19 00:00:00+00	2	0	0	0	0	0
916	3	21	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
917	3	19	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
930	6	22	\N	0	0	0	1	0	1	0	2024-09-30 00:00:00+00	1	0	0	0	0	0
918	3	22	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
919	5	34	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
942	6	29	\N	0	0	0	1	0	1	0	2024-06-25 00:00:00+00	1	0	0	0	0	0
920	5	29	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
931	5	2	\N	0	0	0	1	0	1	0	2024-06-05 00:00:00+00	1	0	0	0	0	0
921	5	22	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
922	5	14	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
923	6	21	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
932	5	20	\N	0	0	0	1	0	1	0	2024-06-19 00:00:00+00	1	0	0	0	0	0
924	6	31	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
960	6	4	\N	0	0	0	1	0	1	0	2024-07-25 00:00:00+00	1	0	0	0	0	0
935	6	21	\N	0	0	0	2	0	2	0	2024-06-26 00:00:00+00	2	0	0	0	0	0
933	3	2	\N	0	0	0	1	0	1	0	2024-06-13 00:00:00+00	1	0	0	0	0	0
934	6	11	\N	0	0	0	1	0	1	0	2024-06-27 00:00:00+00	1	0	0	0	0	0
951	6	27	\N	0	0	0	1	0	1	0	2024-07-23 00:00:00+00	1	0	0	0	0	0
944	5	30	\N	0	0	0	1	0	1	0	2024-07-05 00:00:00+00	1	0	0	0	0	0
936	5	8	\N	0	0	0	1	0	1	0	2024-06-19 00:00:00+00	1	0	0	0	0	0
937	6	22	\N	0	0	0	1	0	1	0	2024-06-20 00:00:00+00	1	0	0	0	0	0
938	5	2	\N	0	0	0	1	0	1	0	2024-06-19 00:00:00+00	1	0	0	0	0	0
945	6	11	\N	0	0	0	1	0	1	0	2024-07-04 00:00:00+00	1	0	0	0	0	0
939	6	29	\N	0	0	0	1	0	1	0	2024-06-20 00:00:00+00	1	0	0	0	0	0
956	6	23	\N	0	0	0	1	0	1	0	2024-07-24 00:00:00+00	1	0	0	0	0	0
946	5	23	\N	0	0	0	1	0	1	0	2024-07-04 00:00:00+00	1	0	0	0	0	0
488	6	11	\N	0	0	0	2	0	2	0	2024-07-17 00:00:00+00	2	0	0	0	0	0
947	6	25	\N	0	0	0	1	0	1	0	2024-07-11 00:00:00+00	1	0	0	0	0	0
948	5	29	\N	0	0	0	1	0	1	0	2024-07-11 00:00:00+00	1	0	0	0	0	0
949	5	30	\N	0	0	0	1	0	1	0	2024-07-12 00:00:00+00	1	0	0	0	0	0
952	6	2	\N	0	0	0	1	0	1	0	2024-07-11 00:00:00+00	1	0	0	0	0	0
953	3	11	\N	0	0	0	1	0	1	0	2024-07-12 00:00:00+00	1	0	0	0	0	0
957	6	19	\N	0	0	0	1	0	1	0	2024-07-17 00:00:00+00	1	0	0	0	0	0
954	5	33	\N	0	0	0	1	0	1	0	2024-07-12 00:00:00+00	1	0	0	0	0	0
955	5	3	\N	0	0	0	1	0	1	0	2024-07-25 00:00:00+00	1	0	0	0	0	0
958	5	35	\N	0	0	0	1	0	1	0	2024-07-19 00:00:00+00	1	0	0	0	0	0
961	5	27	\N	0	0	0	1	0	1	0	2024-09-18 00:00:00+00	1	0	0	0	0	0
959	3	16	\N	0	0	0	1	0	1	0	2024-11-06 00:00:00+00	1	0	0	0	0	0
963	5	27	\N	0	0	0	1	0	1	0	2024-09-05 00:00:00+00	1	0	0	0	0	0
962	7	27	\N	0	0	0	1	0	1	0	2024-09-05 00:00:00+00	1	0	0	0	0	0
964	6	7	\N	0	0	0	1	0	1	0	2024-10-10 00:00:00+00	1	0	0	0	0	0
965	7	13	\N	0	0	0	1	0	1	0	2024-09-25 00:00:00+00	1	0	0	0	0	0
966	5	2	\N	0	0	0	1	0	1	0	2024-10-01 00:00:00+00	1	0	0	0	0	0
967	5	2	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
968	5	7	\N	0	0	0	1	0	1	0	2024-10-11 00:00:00+00	1	0	0	0	0	0
969	6	14	\N	0	0	0	1	0	1	0	2024-10-03 00:00:00+00	1	0	0	0	0	0
970	6	39	\N	0	0	0	1	0	1	0	2024-10-11 00:00:00+00	1	0	0	0	0	0
971	5	28	\N	0	0	0	1	0	1	0	2024-10-04 00:00:00+00	1	0	0	0	0	0
972	7	18	\N	0	0	0	1	0	1	0	2024-10-15 00:00:00+00	1	0	0	0	0	0
973	6	30	\N	0	0	0	1	0	1	0	2024-10-21 00:00:00+00	1	0	0	0	0	0
943	3	11	\N	0	0	0	2	0	2	1	2024-06-26 00:00:00+00	2	0	1	0	0	0
974	5	17	\N	0	0	0	1	0	1	0	2024-10-15 00:00:00+00	1	0	0	0	0	0
993	5	33	\N	0	0	0	1	0	1	1	2024-07-19 00:00:00+00	1	0	1	0	0	0
975	5	19	\N	0	0	0	1	0	1	0	2024-10-09 00:00:00+00	1	0	0	0	0	0
976	7	30	\N	0	0	0	1	0	1	0	2024-10-17 00:00:00+00	1	0	0	0	0	0
977	5	27	\N	0	0	0	1	0	1	0	2024-10-15 00:00:00+00	1	0	0	0	0	0
1005	3	16	\N	0	0	0	1	0	1	0	2024-07-29 00:00:00+00	1	0	0	0	0	0
978	7	25	\N	0	0	0	1	0	1	0	2024-10-29 00:00:00+00	1	0	0	0	0	0
979	3	21	\N	0	0	0	1	0	1	0	2024-11-07 00:00:00+00	1	0	0	0	0	0
994	6	23	\N	0	0	0	1	0	1	1	2024-07-30 00:00:00+00	1	0	1	0	0	0
980	7	4	\N	0	0	0	1	0	1	0	2024-11-07 00:00:00+00	1	0	0	0	0	0
981	6	7	\N	0	0	0	1	0	1	0	2024-10-24 00:00:00+00	1	0	0	0	0	0
982	5	23	\N	0	0	0	1	0	1	0	2024-10-29 00:00:00+00	1	0	0	0	0	0
983	5	22	\N	0	0	0	1	0	1	0	2024-11-08 00:00:00+00	1	0	0	0	0	0
984	6	38	\N	0	0	0	1	0	1	0	2024-11-07 00:00:00+00	1	0	0	0	0	0
995	6	27	\N	0	0	0	1	0	1	1	2024-07-31 00:00:00+00	1	0	1	0	0	0
985	7	33	\N	0	0	0	1	0	1	0	2025-11-18 00:00:00+00	1	0	0	0	0	0
986	7	19	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
987	5	33	\N	0	0	0	1	0	1	0	2024-11-19 00:00:00+00	1	0	0	0	0	0
1006	7	5	\N	0	0	0	2	0	2	0	2024-09-23 00:00:00+00	2	0	0	0	0	0
996	6	30	\N	0	0	0	1	0	1	1	2024-10-23 00:00:00+00	1	0	1	0	0	0
988	5	22	\N	0	0	0	1	0	1	1	2024-06-11 00:00:00+00	1	0	1	0	0	0
1007	5	2	\N	0	0	0	1	0	1	0	2024-10-16 00:00:00+00	1	0	0	0	0	0
989	5	25	\N	0	0	0	1	0	1	1	2024-06-13 00:00:00+00	1	0	1	0	0	0
997	7	25	\N	0	0	0	1	0	1	1	2024-11-05 00:00:00+00	1	0	1	0	0	0
990	5	2	\N	0	0	0	1	0	1	1	2024-06-21 00:00:00+00	1	0	1	0	0	0
1008	5	2	\N	0	0	0	1	0	1	0	2024-10-22 00:00:00+00	1	0	0	0	0	0
991	5	20	\N	0	0	0	1	0	1	1	2024-07-10 00:00:00+00	1	0	1	0	0	0
998	6	8	\N	0	0	0	1	0	1	1	2024-09-24 00:00:00+00	1	0	1	0	0	0
992	3	2	\N	0	0	0	1	0	1	1	2024-07-16 00:00:00+00	1	0	1	0	0	0
999	6	21	\N	0	0	0	1	0	1	0	2024-07-01 00:00:00+00	1	0	0	0	0	0
1000	5	31	\N	0	0	0	1	0	1	0	2024-06-24 00:00:00+00	1	0	0	0	0	0
1010	6	40	\N	0	0	0	1	0	1	0	2024-10-17 00:00:00+00	1	0	0	0	0	0
1001	3	11	\N	0	0	0	2	0	2	0	2024-06-27 00:00:00+00	2	0	0	0	0	0
1009	7	18	\N	0	0	0	2	0	2	0	2024-10-17 00:00:00+00	2	0	0	0	0	0
1002	3	2	\N	0	0	0	1	0	1	0	2024-07-11 00:00:00+00	1	0	0	0	0	0
1003	6	3	\N	0	0	0	1	0	1	0	2024-07-25 00:00:00+00	1	0	0	0	0	0
1004	3	16	\N	0	0	0	1	0	1	0	2024-11-18 00:00:00+00	1	0	0	0	0	0
1011	5	3	\N	0	0	0	1	0	1	0	2024-11-12 00:00:00+00	1	0	0	0	0	0
\.


--
-- Data for Name: reqServiceFlows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqServiceFlows" ("flowId", "flowServiceId", "flowStationId", "flowStationName") FROM stdin;
\.


--
-- Data for Name: reqServiceRequests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqServiceRequests" ("requestId", "requestName", "requestSkills", "requestExperience", "requestStatus", "requestTeam", "requestServiceId", "requestDate", "requestVacancy", "requestCode", "requestDesignation", "requestDescription", "requestPostingDate", "requestClosingDate", "requestMinimumExperience", "requestMaximumExperience", "requestManager", "requestMaxSalary", "requestBaseSalary", "requestHiredCount", "requestLocation", "requestSalaryType") FROM stdin;
1	Account Manager	\N	\N	active	1	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
2	Ai/Ml Architect	\N	\N	active	11	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
3	Associate Project Manager	\N	\N	active	3	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
4	Business Analyst	\N	\N	active	4	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
5	Business Development Executive	\N	\N	active	4	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
6	Business Development Manager	\N	\N	active	4	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
7	Devops Engineer	\N	\N	active	5	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
8	Golang Senior	\N	\N	active	16	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
9	Hr Generalist	\N	\N	active	17	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
10	Lead Automation Test Engineer	\N	\N	active	10	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
11	Lead Manual Testing	\N	\N	active	10	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
12	Manual Test Engineer (Azure+Devops)	\N	\N	active	10	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
13	PHP Developer	\N	\N	active	15	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
14	PHP Lead	\N	\N	active	15	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
15	PM	\N	\N	active	3	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
16	QA Manager	\N	\N	active	10	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
17	SE Android	\N	\N	active	9	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
18	SE/SSE - .Net	\N	\N	active	2	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
19	SE/SSE - Angular	\N	\N	active	8	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
20	SE/SSE - ColdFusion	\N	\N	active	6	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
21	SE/SSE - Java	\N	\N	active	7	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
22	SE/SSE - Node js	\N	\N	active	8	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
23	SE/SSE - Odoo	\N	\N	active	14	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
24	SE/SSE - React js	\N	\N	active	8	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
25	SE/SSE - React Native	\N	\N	active	8	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
26	SE/SSE - ROR	\N	\N	active	13	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
27	SE/SSE - Python	\N	\N	active	11	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
28	SE/SSE - Angular+Node	\N	\N	active	8	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
29	SE/SSE - React+Node	\N	\N	active	8	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
30	Senior Android Developer	\N	\N	active	9	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
31	Solution Architect - Python	\N	\N	active	11	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
32	Solution Architect - Java	\N	\N	active	7	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
33	STE/SSTE - Manual Testing	\N	\N	active	10	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
34	STE/SSTE - Mobile Testing	\N	\N	active	10	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
35	TA - Fresher	\N	\N	active	10	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
36	TL - .Net	\N	\N	active	2	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
37	TL - (Angular+Node)	\N	\N	active	8	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
38	TL - Java	\N	\N	active	7	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
39	TL - Node js	\N	\N	active	8	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
40	TL - React js	\N	\N	active	8	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
41	TL - Angular	\N	\N	active	8	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
42	TL - React Native	\N	\N	active	8	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
43	TL - (React+Node)	\N	\N	active	8	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
44	TL - Python	\N	\N	active	11	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
45	UI/UX Designer	\N	\N	active	12	\N	2024-11-19 08:57:15.975612+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
46	Magento Developer	\N	\N	active	11	\N	2024-11-21 07:38:15.408708+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
47	Data engineer	\N	\N	active	11	\N	2024-11-21 07:38:58.388592+00	\N	\N	\N	\N	\N	\N	0	0	\N	\N	\N	0	\N	\N
\.


--
-- Data for Name: reqServiceSequences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqServiceSequences" ("serviceId", "serviceStation", "serviceServiceRequst", "serviceCandidate", "serviceAssignee", "serviceDate", "serviceStatus", "serviceServiceId", "serviceScheduledBy", "previousCurrentStation", "resonSwitchStation", "interviewCount", "interviewRescheduled", "interviewRescheduledCount", "interviewMode", "interviewLocation", "interviewMail", "interviewMailType", "insertOrUpdateDate", "serviceSourceDate") FROM stdin;
2	2	24	2	14	2024-04-08 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
3	2	25	3	15	2024-04-03 23:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
4	2	38	4	16	2024-04-03 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
5	2	2	5	17	2024-04-02 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
6	2	10	6	18	2024-04-05 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
7	2	13	7	19	2024-04-02 20:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
8	2	13	8	19	2024-04-04 05:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
9	2	13	9	19	2024-04-05 05:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
10	2	46	10	20	2024-04-03 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
11	2	21	11	16	2024-04-02 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
12	2	21	12	16	2024-04-02 23:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
13	2	35	13	13	2024-04-01 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
14	6	38	14	21	2024-04-01 23:30:00+00	on-hold	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
15	3	10	15	22	2024-04-04 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
16	2	6	16	23	2024-04-03 06:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
17	2	13	17	19	2024-04-04 06:00:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
18	2	13	18	19	2024-04-05 06:00:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
19	2	35	19	13	2024-04-03 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
20	2	8	20	24	2024-04-07 20:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
21	2	18	21	13	2024-04-03 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
22	2	25	22	15	2024-04-02 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
23	2	19	23	25	2024-04-08 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
24	3	19	24	26	2024-04-03 22:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
25	2	22	25	27	2024-04-07 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
26	2	18	26	13	2024-04-08 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
27	2	24	27	14	2024-04-10 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
28	2	38	28	16	2024-04-08 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
29	1	23	29	\N	2024-11-21 21:09:33+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
30	2	10	30	18	2024-04-07 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
31	2	10	31	18	2024-04-03 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
32	2	19	32	25	2024-04-10 23:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
33	2	10	33	18	2024-04-08 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
35	2	18	34	13	2024-04-10 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
36	2	24	35	14	2024-04-08 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
37	2	38	36	16	2024-04-11 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
38	1	28	37	\N	2024-11-21 21:09:33+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
39	2	2	38	17	2024-04-07 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
40	2	2	39	17	2024-04-03 21:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
41	2	2	40	17	2024-04-08 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
42	1	46	41	\N	2024-11-21 21:09:33+00	sourced	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
43	1	9	42	\N	2024-11-21 21:09:33+00	sourced	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
44	1	9	43	\N	2024-11-21 21:09:33+00	sourced	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
45	2	18	44	13	2024-04-11 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
46	2	24	45	14	2024-04-14 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
47	2	38	46	16	2024-04-11 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
48	2	2	37	17	2024-04-08 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
49	2	2	47	17	2024-04-10 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
50	2	2	48	17	2024-04-08 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
51	2	10	49	18	2024-04-10 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
52	2	23	50	28	2024-04-07 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
53	2	25	51	29	2024-04-11 21:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
55	1	2	52	\N	2024-11-21 21:09:33+00	sourced	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
56	2	13	53	19	2024-04-11 05:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
57	2	10	54	18	2024-04-09 06:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
58	2	10	55	18	2024-04-10 06:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
59	1	9	56	\N	2024-11-21 21:09:33+00	sourced	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
60	3	2	39	30	2024-04-08 21:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
62	2	18	57	13	2024-04-14 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
63	2	24	58	14	2024-04-15 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
64	2	25	59	15	2024-04-07 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
65	3	25	3	29	2024-04-07 23:00:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
66	2	22	60	27	2024-04-10 21:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
67	2	22	61	27	2024-04-11 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
68	2	23	62	28	2024-04-11 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
69	2	18	63	13	2024-04-10 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
70	2	18	64	13	2024-04-11 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
71	2	21	65	16	2024-04-10 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
72	2	21	66	16	2024-04-11 22:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
73	6	6	67	21	2024-04-07 20:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
74	6	6	68	21	2024-04-09 06:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
75	2	18	69	13	2024-04-10 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
76	2	18	70	13	2024-04-10 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
77	2	24	71	14	2024-04-15 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
78	2	25	72	15	2024-04-07 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
79	2	2	73	17	2024-04-14 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
80	2	2	74	17	2024-04-16 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
81	2	10	75	18	2024-04-15 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
82	2	19	76	32	2024-04-11 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
83	2	13	77	19	2024-04-11 05:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
84	2	21	78	16	2024-04-16 23:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
85	2	23	79	28	2024-04-10 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
86	2	10	80	18	2024-04-14 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
87	5	9	43	33	2024-04-09 06:00:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
88	5	9	56	33	2024-04-09 06:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
89	2	18	81	13	2024-04-14 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
90	2	24	82	14	2024-04-16 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
91	1	25	83	\N	2024-11-21 21:09:33+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
92	2	35	84	13	2024-04-11 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
93	2	35	85	13	2024-04-11 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
94	2	46	86	20	2024-04-15 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
95	2	24	87	14	2024-04-15 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
96	2	2	88	17	2024-04-11 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
97	2	21	89	16	2024-04-17 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
98	2	13	90	19	2024-04-12 05:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
100	2	14	91	19	2024-04-12 06:00:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
101	2	10	92	18	2024-04-11 21:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
102	2	10	93	18	2024-04-16 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
103	2	10	94	18	2024-04-17 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
104	2	2	95	17	2024-04-15 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
105	2	18	96	13	2024-04-15 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
106	2	38	97	16	2024-04-17 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
107	2	18	98	13	2024-04-15 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
108	2	35	99	13	2024-04-15 22:00:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
109	2	32	100	16	2024-04-15 23:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
110	2	39	101	26	2024-04-14 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
112	2	18	102	13	2024-04-15 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
113	2	38	103	16	2024-04-16 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
114	1	23	104	\N	2024-11-21 21:09:33+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
118	2	25	105	29	2024-04-14 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
119	2	35	106	13	2024-04-16 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
120	2	10	107	18	2024-04-16 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
121	2	19	108	25	2024-04-18 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
122	2	38	109	16	2024-04-18 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
123	2	28	110	32	2024-04-16 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
124	2	25	111	29	2024-04-17 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
125	3	38	4	34	2024-04-16 04:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
127	2	13	112	19	2024-04-17 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
128	2	13	113	19	2024-04-17 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
129	2	19	114	25	2024-04-17 00:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
131	3	13	115	19	2024-04-17 05:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
132	2	23	116	28	2024-04-15 22:00:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
133	2	18	117	13	2024-04-16 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
134	2	38	118	16	2024-04-16 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
135	3	10	92	22	2024-04-16 06:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
139	2	18	119	13	2024-04-17 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
140	2	18	120	13	2024-04-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
141	2	21	121	16	2024-04-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
142	2	25	122	29	2024-04-16 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
143	2	23	29	28	2024-04-17 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
144	2	35	123	13	2024-04-16 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
145	2	37	124	26	2024-04-16 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
146	2	21	125	16	2024-04-21 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
147	1	25	126	\N	2024-11-21 21:09:33+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
148	2	13	127	19	2024-04-22 05:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
149	2	13	128	19	2024-04-19 05:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
150	2	13	129	19	2024-04-19 06:00:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
151	2	35	130	13	2024-04-17 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
152	2	10	131	18	2024-04-17 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
153	3	10	107	22	2024-04-17 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
155	2	18	132	13	2024-04-21 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
156	2	21	133	16	2024-04-21 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
157	2	25	134	36	2024-04-17 23:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
158	2	28	135	26	2024-04-18 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
159	2	23	136	28	2024-04-18 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
160	2	14	137	19	2024-04-19 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
161	2	10	138	18	2024-04-19 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
162	2	25	139	29	2024-04-21 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
163	2	35	140	13	2024-04-21 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
164	2	6	141	23	2024-04-18 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
165	2	6	142	23	2024-04-21 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
166	2	23	143	28	2024-04-18 21:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
167	2	13	144	19	2024-04-19 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
168	6	25	51	21	2024-04-16 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
169	2	14	145	19	2024-04-22 05:30:00+00	on-hold	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
170	3	13	146	19	2024-04-18 06:00:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
171	2	19	147	32	2024-04-18 23:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
172	2	43	148	26	2024-04-17 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
173	2	18	149	13	2024-04-24 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
174	2	21	150	16	2024-04-22 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
175	2	24	151	14	2024-04-23 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
176	2	35	152	13	2024-04-24 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
177	2	2	153	17	2024-04-22 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
178	2	35	154	13	2024-04-22 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
179	2	14	155	19	2024-04-24 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
180	2	10	156	18	2024-04-22 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
181	2	19	157	32	2024-04-21 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
182	2	19	158	25	2024-04-24 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
183	2	25	159	29	2024-04-24 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
184	2	21	160	16	2024-04-22 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
185	2	21	161	16	2024-04-24 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
187	2	18	162	13	2024-04-22 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
188	2	22	163	37	2024-04-18 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
189	2	24	164	14	2024-04-21 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
190	2	10	165	18	2024-04-21 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
191	3	35	106	26	2024-04-21 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
192	2	21	166	16	2024-04-22 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
193	2	18	167	13	2024-04-22 23:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
194	2	18	168	13	2024-04-22 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
195	2	42	169	29	2024-04-23 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
196	2	18	170	13	2024-04-28 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
197	2	2	171	17	2024-04-22 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
198	2	35	172	13	2024-04-24 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
199	2	2	173	17	2024-04-21 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
201	2	18	174	13	2024-04-22 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
202	2	18	175	13	2024-04-24 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
203	2	2	176	17	2024-04-24 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
204	2	8	177	24	2024-04-21 20:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
205	2	10	178	18	2024-04-22 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
206	2	3	179	38	2024-04-22 21:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
207	3	23	116	38	2024-04-21 22:00:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
210	2	13	180	19	2024-04-24 05:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
211	2	8	181	24	2024-04-23 20:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
212	2	35	182	13	2024-04-23 20:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
213	2	24	183	14	2024-04-23 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
214	2	25	184	29	2024-04-24 00:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
215	2	19	185	25	2024-04-24 23:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
218	1	21	186	\N	2024-11-21 21:09:33+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
219	2	22	187	27	2024-04-24 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
220	2	18	188	13	2024-04-28 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
221	2	25	189	29	2024-04-24 06:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
222	2	23	190	28	2024-04-24 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
223	2	18	191	13	2024-04-28 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
224	2	18	192	13	2024-04-24 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
225	2	28	193	39	2024-04-29 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
226	2	21	194	16	2024-04-28 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
227	2	35	195	13	2024-04-28 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
228	2	24	196	14	2024-04-28 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
229	2	28	197	26	2024-04-28 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
230	2	25	198	29	2024-04-29 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
232	5	13	146	33	2024-04-23 06:00:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
233	2	18	199	13	2024-04-29 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
234	2	18	200	13	2024-04-29 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
235	2	23	201	28	2024-04-28 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
236	2	6	202	23	2024-04-25 05:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
237	2	13	203	19	2024-04-25 00:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
239	3	10	93	22	2024-04-23 21:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
240	3	2	173	30	2024-04-23 21:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
241	2	18	204	13	2024-04-24 20:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
242	2	23	205	28	2024-04-24 20:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
243	2	37	206	26	2024-04-24 22:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
244	2	25	207	29	2024-04-24 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
245	2	18	208	13	2024-04-29 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
246	2	21	209	16	2024-04-29 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
247	2	23	210	28	2024-04-28 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
248	1	\N	211	\N	2024-11-21 21:09:33+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
249	2	13	212	19	2024-04-29 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
250	2	19	213	32	2024-05-01 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
251	2	22	214	27	2024-05-02 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
252	1	47	215	\N	2024-11-21 21:09:33+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
254	2	35	216	13	2024-04-28 20:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
256	2	19	217	26	2024-04-28 22:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
257	2	22	218	37	2024-04-28 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
258	1	\N	219	\N	2024-11-21 21:09:33+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
259	1	\N	220	\N	2024-11-21 21:09:33+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
260	3	19	147	26	2024-04-28 23:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
263	2	18	221	13	2024-05-02 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
265	2	23	222	28	2024-05-02 21:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
266	2	38	223	16	2024-05-02 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
268	2	18	224	13	2024-04-29 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
269	2	19	225	25	2024-04-29 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
271	2	2	226	17	2024-04-28 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
272	2	10	227	18	2024-05-01 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
273	1	47	228	\N	2024-11-21 21:09:33+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
274	6	6	141	21	2024-04-30 00:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
275	6	6	142	21	2024-04-29 23:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
277	2	21	229	16	2024-04-29 22:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
278	2	21	230	16	2024-04-29 23:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
279	2	38	231	16	2024-05-01 22:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
280	2	22	232	37	2024-04-29 21:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
281	6	6	16	21	2024-04-28 23:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
284	2	18	233	13	2024-05-02 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
285	2	21	234	16	2024-05-01 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
287	2	38	235	16	2024-05-02 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
288	2	38	236	16	2024-05-05 23:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
291	2	18	237	13	2024-05-01 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
294	2	18	238	13	2024-05-01 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
295	2	21	239	16	2024-05-02 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
296	2	25	240	29	2024-05-02 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
297	3	13	112	35	2024-05-01 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
298	2	2	241	17	2024-05-02 22:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
299	2	25	242	29	2024-05-02 22:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
300	2	10	243	18	2024-05-02 21:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
301	1	6	244	\N	2024-11-21 21:09:33+00	sourced	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
302	3	21	78	34	2024-05-01 23:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
303	3	23	205	38	2024-05-01 20:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
305	6	3	179	21	2024-05-02 23:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
306	3	2	38	30	2024-05-02 22:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
307	2	13	245	19	2024-05-06 05:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
308	2	13	246	19	2024-05-07 05:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
309	2	24	247	14	2024-05-05 22:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
310	2	24	248	14	2024-05-06 22:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
311	2	18	249	13	2024-05-05 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
312	2	21	250	16	2024-05-05 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
313	2	23	251	28	2024-05-06 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
314	2	38	252	16	2024-05-06 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
315	1	\N	253	\N	2024-11-21 21:09:33+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
319	2	3	254	38	2024-05-09 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
320	1	47	255	\N	2024-11-21 21:09:33+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
321	1	47	256	\N	2024-11-21 21:09:33+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
322	3	2	226	30	2024-05-02 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
323	3	13	203	41	2024-04-30 20:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
324	2	18	257	13	2024-05-06 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
325	1	37	258	\N	2024-11-21 21:09:33+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
326	2	21	259	16	2024-05-05 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
327	2	21	260	16	2024-05-06 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
328	2	18	261	13	2024-05-06 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
329	2	18	262	13	2024-05-05 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
330	2	38	263	16	2024-05-06 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
331	2	22	264	39	2024-05-08 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
332	3	6	202	21	2024-05-01 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
333	2	19	265	25	2024-05-09 23:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
336	2	10	266	18	2024-05-06 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
337	5	13	203	33	2024-05-03 06:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
340	2	28	267	32	2024-05-09 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
341	2	38	268	16	2024-05-07 06:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
342	2	14	269	19	2024-05-05 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
343	2	18	270	13	2024-05-07 22:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
344	2	25	271	29	2024-05-07 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
345	2	19	272	32	2024-05-07 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
346	2	18	273	13	2024-05-06 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
347	2	14	274	19	2024-05-08 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
349	2	21	275	16	2024-05-08 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
350	2	22	276	39	2024-05-07 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
351	2	38	277	16	2024-05-08 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
352	3	23	222	38	2024-05-02 21:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
353	2	19	278	25	2024-05-10 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
354	2	23	279	\N	2024-11-21 21:09:33+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
355	3	2	280	30	2024-05-08 22:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
356	2	18	281	13	2024-05-07 23:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
357	5	23	205	33	2024-05-07 06:00:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
358	5	19	147	33	2024-05-05 20:30:00+00	on-hold	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
360	2	2	282	42	2024-05-08 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
361	2	18	283	13	2024-05-09 07:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
365	2	18	284	13	2024-05-09 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
366	2	21	285	16	2024-05-14 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
367	2	24	286	14	2024-05-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
368	1	8	287	\N	2024-11-21 21:09:34+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
369	5	23	222	33	2024-05-08 20:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
370	2	21	288	16	2024-05-16 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
371	2	8	289	24	2024-05-13 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
372	2	35	290	13	2024-05-08 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
373	2	14	291	19	2024-05-09 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
374	2	25	292	29	2024-05-07 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
375	2	19	293	25	2024-05-12 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
376	2	22	294	27	2024-05-12 21:00:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
377	2	21	295	16	2024-05-13 21:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
378	3	19	213	26	2024-05-07 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
380	2	18	296	13	2024-05-12 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
381	2	22	297	39	2024-05-14 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
382	2	42	298	29	2024-05-12 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
383	2	22	299	39	2024-05-16 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
384	2	35	300	13	2024-05-08 23:00:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
385	2	19	301	32	2024-05-08 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
386	2	22	302	39	2024-05-10 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
387	2	21	303	16	2024-05-09 22:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
388	2	25	304	29	2024-05-12 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
389	2	21	305	16	2024-05-12 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
390	2	19	306	32	2024-05-12 20:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
391	2	37	258	26	2024-05-09 22:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
392	2	18	307	13	2024-05-12 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
393	2	21	308	16	2024-05-13 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
394	2	42	309	29	2024-05-14 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
395	2	23	310	28	2024-05-14 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
397	2	37	311	26	2024-05-12 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
398	3	22	214	26	2024-05-09 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
399	2	35	312	13	2024-05-13 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
400	2	13	313	19	2024-05-21 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
401	1	11	314	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
402	2	13	315	19	2024-05-14 00:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
403	2	28	316	26	2024-05-13 23:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
404	2	10	317	18	2024-05-13 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
406	1	11	318	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
407	1	11	319	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
409	2	21	320	16	2024-05-15 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
410	2	25	321	29	2024-05-19 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
411	2	23	322	28	2024-05-15 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
412	2	6	323	23	2024-05-13 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
413	2	18	324	13	2024-05-13 22:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
414	1	11	325	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
415	1	11	326	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
418	2	2	327	42	2024-05-14 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
421	2	38	328	16	2024-05-14 22:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
422	2	38	329	16	2024-05-15 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
423	5	2	38	33	2024-05-12 20:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
424	3	18	281	26	2024-05-12 23:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
426	2	2	330	42	2024-05-15 23:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
427	1	19	331	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
428	3	19	265	26	2024-05-16 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
429	2	8	332	24	2024-05-15 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
430	2	8	333	24	2025-05-16 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
431	2	25	126	29	2024-05-13 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
432	2	18	334	13	2024-05-15 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
433	2	21	335	16	2024-05-19 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
434	2	22	336	39	2024-05-20 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
435	5	6	202	33	2024-05-13 06:00:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
436	2	35	337	13	2024-05-29 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
437	2	13	338	19	2024-05-19 22:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
438	2	21	339	16	2024-05-20 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
439	2	25	340	29	2024-05-14 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
442	\N	19	272	\N	2024-11-21 21:09:34+00	null	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
443	2	18	341	13	2024-05-20 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
444	2	8	342	43	2024-05-19 20:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
445	2	23	343	28	2024-05-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
446	2	22	344	39	2024-05-21 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
447	2	25	345	29	2024-05-15 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
448	2	14	346	19	2024-05-17 06:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
449	2	19	347	32	2024-05-20 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
452	2	8	348	44	2024-05-19 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
453	1	11	349	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
454	2	18	350	13	2024-05-30 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
455	2	28	351	26	2024-05-15 23:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
457	5	18	281	33	2024-05-15 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
458	2	8	352	43	2024-05-16 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
459	2	8	353	43	2024-05-15 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
460	2	18	354	13	2024-05-16 23:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
461	2	18	355	13	2024-05-20 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
462	2	39	356	39	2024-05-24 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
463	6	2	38	21	2024-05-15 23:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
464	2	25	357	29	2024-05-21 01:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
465	2	18	358	13	2024-05-19 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
466	2	13	359	19	2024-05-20 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
470	2	18	360	13	2024-05-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
471	2	8	361	43	2024-05-20 20:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
472	2	25	362	29	2024-05-21 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
473	1	11	363	\N	2024-11-21 21:09:34+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
474	2	22	364	39	2024-05-22 05:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
475	2	18	365	13	2024-05-19 23:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
476	2	18	366	13	2024-05-27 23:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
477	2	21	367	16	2024-05-21 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
478	2	37	368	26	2024-05-20 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
479	2	25	369	29	2024-05-23 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
480	2	42	370	29	2024-05-16 22:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
481	2	35	371	13	2024-05-23 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
482	2	19	372	32	2024-05-21 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
486	2	2	373	42	2024-05-20 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
487	2	24	374	14	2024-05-19 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
488	2	24	375	14	2024-05-20 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
489	2	19	376	32	2024-05-20 20:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
490	2	38	377	16	2024-05-20 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
491	2	38	378	16	2024-05-26 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
492	2	21	379	16	2024-05-28 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
493	2	25	380	29	2024-05-19 22:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
495	2	8	381	44	2024-05-22 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
499	3	2	330	30	2024-05-19 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
500	2	21	382	16	2024-05-24 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
501	2	18	383	13	2024-05-23 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
502	2	13	384	19	2024-05-27 22:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
503	2	18	385	13	2024-05-26 22:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
504	2	18	386	13	2024-05-21 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
505	2	21	387	16	2024-05-22 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
506	2	2	388	42	2024-05-22 00:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
508	2	23	389	28	2024-05-26 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
509	2	25	390	29	2024-05-21 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
511	2	38	391	16	2024-05-26 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
512	2	21	392	16	2024-05-22 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
513	2	24	393	14	2024-05-22 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
514	2	21	394	16	2024-05-24 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
515	2	8	395	43	2024-05-27 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
516	3	21	339	34	2024-05-24 04:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
517	2	18	396	13	2024-05-27 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
518	2	2	397	42	2024-05-23 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
519	2	23	398	28	2024-05-21 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
520	2	25	399	29	2024-05-26 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
521	2	2	400	42	2024-05-27 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
522	2	21	401	16	2024-06-02 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
523	2	8	402	24	2024-05-27 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
526	2	35	403	13	2024-05-27 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
527	2	13	404	19	2024-05-27 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
528	2	10	405	18	2024-05-22 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
529	5	18	312	33	2024-05-23 06:00:00+00	on-hold	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
530	5	18	365	33	2024-05-23 06:45:00+00	on-hold	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
531	2	25	406	29	2024-05-26 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
533	2	22	407	27	2024-05-27 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
534	2	22	408	37	2024-05-26 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
536	2	21	409	16	2024-05-27 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
537	2	21	410	16	2024-05-28 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
539	2	23	411	28	2024-05-27 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
540	2	2	412	42	2024-05-23 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
541	2	18	413	13	2024-05-28 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
542	2	18	414	13	2024-05-27 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
545	2	8	415	24	2024-05-28 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
546	2	21	416	16	2024-05-28 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
547	2	13	417	19	2024-05-29 00:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
548	\N	35	418	\N	2024-11-21 21:09:34+00	null	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
549	2	18	419	13	2024-05-27 22:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
550	2	38	420	16	2024-05-29 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
551	2	23	421	28	2024-05-26 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
552	2	29	422	26	2024-05-29 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
553	2	21	423	16	2024-05-26 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
555	2	14	424	19	2024-05-30 00:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
556	2	19	425	25	2024-06-03 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
558	2	19	426	25	2024-05-31 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
560	3	2	373	30	2024-05-26 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
561	1	44	427	\N	2024-11-21 21:09:34+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
562	1	44	428	\N	2024-11-21 21:09:34+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
563	2	14	429	19	2024-05-31 00:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
564	2	25	430	29	2024-05-30 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
565	2	18	431	13	2024-05-30 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
567	2	23	432	28	2024-05-30 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
568	2	8	433	24	2024-05-29 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
569	2	25	434	29	2024-06-02 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
570	2	19	435	25	2024-05-30 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
571	2	23	436	28	2024-05-30 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
572	2	18	437	13	2024-06-02 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
574	2	18	438	13	2024-06-03 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
575	2	24	439	14	2024-05-30 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
576	2	21	440	16	2024-06-02 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
577	2	8	441	24	2024-06-06 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
579	2	28	442	32	2024-06-02 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
580	2	21	443	16	2024-06-04 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
581	2	25	444	29	2024-06-02 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
582	2	8	445	24	2024-06-05 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
583	2	22	446	45	2024-06-03 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
584	2	29	447	26	2024-06-02 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
585	2	24	448	14	2024-06-06 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
586	2	23	449	28	2024-06-05 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
587	2	18	450	13	2024-06-05 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
588	2	8	451	24	2024-06-02 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
592	2	2	452	42	2024-05-30 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
593	2	2	453	42	2024-05-29 23:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
594	2	21	454	16	2024-05-30 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
595	2	21	455	16	2024-06-02 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
596	2	37	456	26	2024-06-02 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
598	3	8	415	22	2024-05-30 07:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
602	2	18	457	13	2024-06-03 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
604	2	42	458	29	2024-06-03 22:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
605	2	22	459	45	2024-06-04 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
606	2	24	460	14	2024-05-29 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
608	2	22	461	45	2024-06-05 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
609	2	22	462	45	2024-06-11 06:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
611	2	23	463	28	2024-06-06 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
612	2	25	464	29	2024-06-02 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
613	2	21	465	16	2024-06-05 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
614	2	25	466	29	2024-06-03 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
615	2	38	467	16	2024-06-04 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
616	2	18	468	13	2024-06-04 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
617	2	21	469	16	2024-06-04 20:30:00+00	on-hold	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
618	3	10	405	22	2024-06-05 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
619	2	23	470	28	2024-06-03 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
620	2	18	471	13	2024-06-06 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
621	2	2	472	42	2024-06-07 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
622	2	38	473	16	2024-06-07 22:00:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
624	2	25	475	29	2024-06-12 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-03 00:00:00+00	12:00:00
625	2	22	476	45	2024-06-04 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-03 00:00:00+00	12:00:00
626	2	22	477	45	2024-06-10 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-03 00:00:00+00	12:00:00
627	2	21	478	16	2024-06-02 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-03 00:00:00+00	12:00:00
628	2	25	479	14	2024-06-23 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-03 00:00:00+00	12:00:00
629	2	22	480	45	2024-06-07 05:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-04 00:00:00+00	12:00:00
630	2	21	481	16	2024-06-06 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-04 00:00:00+00	12:00:00
631	2	21	482	16	2024-06-05 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-04 00:00:00+00	12:00:00
632	2	8	483	24	2024-06-06 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-04 00:00:00+00	12:00:00
633	2	13	484	19	2024-06-07 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-04 00:00:00+00	12:00:00
634	2	13	485	19	2024-06-06 00:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-04 00:00:00+00	12:00:00
635	2	22	486	45	2024-06-05 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-04 00:00:00+00	12:00:00
636	2	21	487	16	2024-06-06 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-04 00:00:00+00	12:00:00
639	3	22	476	26	2024-06-04 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
642	2	28	492	32	2024-06-06 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
643	2	21	493	16	2024-06-10 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-14 00:00:00+00	12:00:00
623	2	8	474	43	2024-06-05 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-03 00:00:00+00	12:00:00
637	2	8	488	24	2024-06-04 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
638	3	2	489	30	2024-06-04 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-04 00:00:00+00	12:00:00
644	2	13	494	19	2024-06-06 06:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-04 00:00:00+00	12:00:00
645	2	23	495	28	2024-06-05 21:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-04 00:00:00+00	12:00:00
646	2	18	496	13	2024-06-02 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
647	2	38	497	16	2024-06-09 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
648	2	25	498	14	2024-06-10 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
649	2	29	499	\N	2024-11-21 21:09:34+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
650	2	6	500	23	2024-06-06 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
651	2	6	501	23	2024-06-07 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
652	2	18	502	13	2024-06-05 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
640	2	25	490	29	2024-06-04 22:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
641	2	19	491	25	2024-06-05 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-04 00:00:00+00	12:00:00
653	2	21	503	16	2024-06-06 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
657	2	21	506	16	2024-06-06 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
658	2	21	507	16	2024-06-11 01:00:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
660	3	2	508	30	2024-06-09 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
661	2	35	509	13	2024-06-11 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-06 00:00:00+00	12:00:00
662	2	23	510	28	2024-06-10 22:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-06 00:00:00+00	12:00:00
663	2	28	511	26	2024-06-11 22:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-06 00:00:00+00	12:00:00
664	2	18	512	13	2024-06-09 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-06 00:00:00+00	12:00:00
665	2	6	513	23	2024-06-13 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-06 00:00:00+00	12:00:00
666	2	25	514	29	2024-06-10 22:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-06 00:00:00+00	12:00:00
667	2	8	515	24	2024-06-09 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-06 00:00:00+00	12:00:00
668	2	42	516	29	2024-06-06 22:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-06 00:00:00+00	12:00:00
700	2	29	545	26	2024-06-12 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
701	1	11	546	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-10 00:00:00+00	12:00:00
671	2	8	519	24	2024-06-13 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-06 00:00:00+00	12:00:00
732	3	2	529	30	2024-06-16 23:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-17 00:00:00+00	12:00:00
669	2	23	517	28	2024-06-09 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
674	2	18	522	13	2024-06-09 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
675	2	23	523	28	2024-06-10 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
676	2	35	524	13	2024-06-11 23:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
677	3	21	525	34	2024-06-17 00:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
678	2	35	526	13	2024-06-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
679	2	38	527	16	2024-06-19 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
680	2	24	528	14	2024-06-13 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
682	2	2	529	42	2024-06-10 00:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
730	2	11	572	47	2024-06-16 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-17 00:00:00+00	12:00:00
716	3	21	506	34	2024-06-13 04:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
686	2	11	532	47	2024-06-10 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
688	2	18	533	13	2024-06-13 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-10 00:00:00+00	12:00:00
689	2	18	534	13	2024-06-20 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-10 00:00:00+00	12:00:00
690	2	22	535	45	2024-06-10 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-10 00:00:00+00	12:00:00
691	2	2	536	42	2024-06-10 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-10 00:00:00+00	12:00:00
692	1	11	537	\N	2024-11-21 21:09:34+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-10 00:00:00+00	12:00:00
693	1	11	538	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-10 00:00:00+00	12:00:00
694	1	11	539	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-10 00:00:00+00	12:00:00
695	2	28	540	32	2024-06-11 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-10 00:00:00+00	12:00:00
696	2	13	541	19	2024-06-11 00:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-10 00:00:00+00	12:00:00
697	2	2	542	42	2024-06-11 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-10 00:00:00+00	12:00:00
698	2	2	543	42	2024-06-13 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-10 00:00:00+00	12:00:00
714	2	23	557	28	2024-06-17 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-18 00:00:00+00	12:00:00
715	2	19	558	25	2024-06-30 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-11 00:00:00+00	12:00:00
685	1	11	531	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
702	2	21	547	16	2024-06-12 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-11 00:00:00+00	12:00:00
703	2	35	548	13	2024-06-12 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-11 00:00:00+00	12:00:00
704	2	25	549	29	2024-06-16 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-11 00:00:00+00	12:00:00
705	1	11	550	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-11 00:00:00+00	12:00:00
706	2	23	551	28	2024-06-10 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-11 00:00:00+00	12:00:00
707	2	18	552	13	2024-06-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-11 00:00:00+00	12:00:00
708	2	38	553	16	2024-06-13 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-11 00:00:00+00	12:00:00
709	2	22	554	45	2024-06-13 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-11 00:00:00+00	12:00:00
710	2	23	555	28	2024-06-12 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-11 00:00:00+00	12:00:00
711	5	22	476	33	2024-06-12 06:45:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-11 00:00:00+00	12:00:00
713	2	21	556	16	2024-06-18 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-11 00:00:00+00	12:00:00
727	2	18	569	13	2024-06-18 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
728	2	8	570	24	2024-06-17 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-12 00:00:00+00	12:00:00
672	2	21	520	16	2024-06-13 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
673	2	21	521	16	2024-06-17 00:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-07 00:00:00+00	12:00:00
718	2	25	560	29	2024-06-12 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-12 00:00:00+00	12:00:00
654	2	22	504	45	2024-06-12 00:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-23 00:00:00+00	12:00:00
656	2	28	505	32	2024-06-27 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-05 00:00:00+00	12:00:00
719	2	21	561	16	2024-06-20 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
722	2	18	564	13	2024-06-18 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-12 00:00:00+00	12:00:00
723	2	21	565	16	2024-06-12 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-12 00:00:00+00	12:00:00
724	2	21	566	16	2024-06-17 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-12 00:00:00+00	12:00:00
726	2	23	568	28	2024-06-17 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-12 00:00:00+00	12:00:00
720	2	21	562	16	2024-06-12 23:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
721	2	18	563	13	2024-06-13 21:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-12 00:00:00+00	12:00:00
729	2	23	571	28	2024-06-17 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-12 00:00:00+00	12:00:00
699	2	29	544	26	2024-06-17 23:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-18 00:00:00+00	12:00:00
684	2	20	530	46	2024-06-11 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
717	2	11	559	47	2024-06-13 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-12 00:00:00+00	12:00:00
670	2	8	518	\N	2024-11-21 21:09:34+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-06 00:00:00+00	12:00:00
738	5	25	490	33	2024-06-14 06:45:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
739	2	18	574	13	2024-06-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
740	2	21	575	16	2024-06-12 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
741	2	25	576	29	2024-06-13 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
742	2	24	577	14	2024-06-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
743	3	2	536	30	2024-06-19 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
744	2	11	578	47	2024-06-20 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
745	2	11	579	47	2024-06-14 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
746	3	21	547	34	2024-06-19 04:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
748	1	32	580	\N	2024-11-21 21:09:34+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
749	1	32	581	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
784	2	2	611	42	2024-06-23 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
785	2	25	612	29	2024-06-30 22:00:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-18 00:00:00+00	12:00:00
752	1	3	584	\N	2024-11-21 21:09:34+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-14 00:00:00+00	12:00:00
754	2	2	585	42	2024-06-17 22:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-14 00:00:00+00	12:00:00
798	1	32	620	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
736	2	21	573	16	2024-06-17 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-13 00:00:00+00	12:00:00
757	2	18	588	13	2024-06-18 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-14 00:00:00+00	12:00:00
758	2	28	589	45	2024-06-18 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-14 00:00:00+00	12:00:00
759	2	21	590	16	2024-06-20 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-14 00:00:00+00	12:00:00
760	2	25	591	29	2024-06-20 23:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-14 00:00:00+00	12:00:00
761	2	23	592	28	2024-06-18 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-14 00:00:00+00	12:00:00
762	1	32	593	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-17 00:00:00+00	12:00:00
763	1	31	594	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-17 00:00:00+00	12:00:00
764	2	43	595	26	2024-06-19 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-17 00:00:00+00	12:00:00
765	2	2	596	42	2024-06-19 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-17 00:00:00+00	12:00:00
768	2	11	597	48	2024-06-18 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-17 00:00:00+00	12:00:00
769	2	29	598	26	2024-06-18 23:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-17 00:00:00+00	12:00:00
770	2	28	599	26	2024-06-19 23:00:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-17 00:00:00+00	12:00:00
771	2	23	600	28	2024-06-18 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-17 00:00:00+00	12:00:00
772	1	26	601	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-17 00:00:00+00	12:00:00
773	1	26	602	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-17 00:00:00+00	12:00:00
774	2	18	603	13	2024-06-24 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-18 00:00:00+00	12:00:00
775	2	22	604	45	2024-06-25 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-18 00:00:00+00	12:00:00
776	2	32	605	49	2024-06-25 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-18 00:00:00+00	12:00:00
777	2	23	606	28	2024-06-20 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-18 00:00:00+00	12:00:00
778	2	22	607	45	2024-06-24 05:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-18 00:00:00+00	12:00:00
779	2	24	608	50	2024-06-23 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-18 00:00:00+00	12:00:00
780	2	29	609	39	2024-06-19 04:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-18 00:00:00+00	12:00:00
781	2	32	610	49	2024-06-25 04:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-18 00:00:00+00	12:00:00
782	2	31	594	51	2024-06-21 06:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-18 00:00:00+00	12:00:00
790	2	11	613	48	2024-06-24 07:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-24 00:00:00+00	12:00:00
791	1	11	614	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
788	3	8	570	22	2024-06-20 21:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
789	3	20	530	22	2024-06-20 07:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
755	2	22	586	27	2024-06-24 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
756	2	18	587	13	2024-06-19 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-14 00:00:00+00	12:00:00
792	1	32	615	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
793	1	32	616	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
794	3	2	585	30	2024-06-19 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
795	2	29	617	39	2024-06-21 04:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
796	2	23	618	28	2024-06-19 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
797	1	32	619	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
799	2	26	601	23	2024-06-20 05:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
800	2	26	602	23	2024-06-20 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
802	2	23	621	28	2024-06-24 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
803	1	21	622	\N	2024-11-21 21:09:34+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
804	2	11	623	47	2024-06-24 06:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
805	2	23	624	28	2024-06-19 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-19 00:00:00+00	12:00:00
806	2	32	581	49	2024-06-28 00:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-20 00:00:00+00	12:00:00
807	3	22	583	26	2024-06-20 22:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-20 00:00:00+00	12:00:00
808	3	29	609	26	2024-06-20 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-20 00:00:00+00	12:00:00
809	2	11	538	47	2024-06-21 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-20 00:00:00+00	12:00:00
810	2	32	620	49	2024-06-24 04:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-20 00:00:00+00	12:00:00
811	1	26	625	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-20 00:00:00+00	12:00:00
812	1	26	626	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-20 00:00:00+00	12:00:00
813	2	35	627	13	2024-06-24 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-20 00:00:00+00	12:00:00
814	2	2	628	42	2024-06-23 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
815	2	32	629	49	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
816	2	11	550	47	2024-06-24 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
750	2	21	582	16	2024-06-17 23:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
751	2	22	583	27	2024-06-17 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-14 00:00:00+00	12:00:00
818	1	32	631	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
819	3	11	538	22	2024-06-24 07:00:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
822	2	18	632	13	2024-06-27 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
823	2	38	633	16	2024-06-19 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
824	1	32	481	\N	2024-11-21 21:09:35+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
825	2	11	546	47	2024-06-25 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
827	1	32	634	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
828	2	32	593	49	2024-06-26 04:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
829	5	2	585	33	2024-06-21 07:15:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
830	2	18	635	13	2024-06-26 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
831	2	11	636	47	2024-06-26 07:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
832	2	11	637	47	2024-06-25 06:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
833	2	2	638	42	2024-06-25 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
834	2	23	639	28	2024-06-26 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-24 00:00:00+00	12:00:00
836	1	11	640	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-24 00:00:00+00	12:00:00
838	1	26	641	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-24 00:00:00+00	12:00:00
839	6	31	594	21	2024-06-26 06:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-24 00:00:00+00	12:00:00
840	1	11	642	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-24 00:00:00+00	12:00:00
841	1	26	643	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-24 00:00:00+00	12:00:00
842	2	18	644	13	2024-06-30 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-24 00:00:00+00	12:00:00
899	1	3	677	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
846	2	32	634	49	2024-07-04 04:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
885	2	24	671	50	2024-07-03 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
886	1	4	672	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-28 00:00:00+00	12:00:00
848	1	30	647	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
849	1	30	648	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
851	1	11	649	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
852	1	4	650	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
853	1	3	651	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
854	2	18	652	13	2024-06-25 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
855	3	29	617	26	2024-06-25 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
856	3	2	638	30	2024-06-26 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
857	1	4	653	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
858	3	11	637	22	2024-06-26 00:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
859	3	2	628	30	2024-06-25 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
860	2	29	654	39	2024-07-01 05:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-26 00:00:00+00	12:00:00
861	1	30	655	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-26 00:00:00+00	12:00:00
862	1	3	656	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-26 00:00:00+00	12:00:00
863	1	3	657	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-26 00:00:00+00	12:00:00
864	2	2	658	42	2024-06-27 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-26 00:00:00+00	12:00:00
865	5	11	659	33	2024-06-27 06:45:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-26 00:00:00+00	12:00:00
866	3	11	636	22	2024-06-27 07:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-26 00:00:00+00	12:00:00
867	3	21	562	34	2024-06-27 04:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-26 00:00:00+00	12:00:00
868	2	11	539	47	2024-07-01 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-26 00:00:00+00	12:00:00
869	6	21	525	26	2024-06-27 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-26 00:00:00+00	12:00:00
870	2	38	660	34	2024-07-03 04:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-27 00:00:00+00	12:00:00
871	6	11	636	52	2024-07-02 21:30:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-27 00:00:00+00	12:00:00
872	6	11	637	52	2024-07-03 00:00:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-27 00:00:00+00	12:00:00
873	3	11	550	22	2024-06-28 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-27 00:00:00+00	12:00:00
874	1	3	661	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-27 00:00:00+00	12:00:00
875	1	30	662	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-27 00:00:00+00	12:00:00
876	2	25	663	29	2024-06-30 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
877	2	28	664	32	2024-07-04 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-28 00:00:00+00	12:00:00
878	2	28	665	26	2024-07-01 23:00:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-28 00:00:00+00	12:00:00
879	1	21	666	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-28 00:00:00+00	12:00:00
880	2	32	631	49	2024-07-04 04:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-28 00:00:00+00	12:00:00
881	2	32	667	49	2024-07-05 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-28 00:00:00+00	12:00:00
882	2	18	668	13	2024-06-30 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-28 00:00:00+00	12:00:00
883	1	38	669	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-28 00:00:00+00	12:00:00
884	2	28	670	32	2024-07-01 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-28 00:00:00+00	12:00:00
896	2	32	616	34	2024-07-02 04:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
897	2	11	649	47	2024-07-02 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
887	1	3	673	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-28 00:00:00+00	12:00:00
888	1	3	674	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-28 00:00:00+00	12:00:00
889	2	30	647	53	2024-07-01 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-03 00:00:00+00	12:00:00
893	2	4	672	23	2024-07-03 06:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
894	1	4	676	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
890	2	30	648	53	2024-06-30 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
891	2	8	675	24	2024-07-02 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
817	2	11	630	48	2024-06-25 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-21 00:00:00+00	12:00:00
843	5	21	547	33	2024-06-26 06:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
845	2	32	645	49	2024-06-28 04:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
847	1	4	646	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-25 00:00:00+00	12:00:00
901	1	4	679	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
902	2	18	680	13	2024-07-07 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
903	2	18	681	13	2024-07-03 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
959	2	6	724	23	2024-07-09 06:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
900	1	3	678	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
906	2	27	684	51	2024-07-05 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-02 00:00:00+00	12:00:00
943	1	4	710	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
944	1	23	711	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
910	2	13	687	19	2024-07-05 06:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-02 00:00:00+00	12:00:00
911	2	13	688	19	2024-07-08 01:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-02 00:00:00+00	12:00:00
912	3	32	610	26	2024-07-03 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-02 00:00:00+00	12:00:00
967	1	4	730	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
915	2	13	690	19	2024-07-04 01:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-02 00:00:00+00	12:00:00
916	2	13	691	19	2024-07-04 01:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-02 00:00:00+00	12:00:00
917	2	11	692	47	2024-07-02 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-02 00:00:00+00	12:00:00
918	1	4	693	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-02 00:00:00+00	12:00:00
919	1	30	694	\N	2024-11-21 21:09:35+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-02 00:00:00+00	12:00:00
920	2	18	695	13	2024-07-07 22:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-03 00:00:00+00	12:00:00
921	1	30	696	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-03 00:00:00+00	12:00:00
922	1	30	697	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-03 00:00:00+00	12:00:00
923	2	25	698	29	2024-07-09 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-03 00:00:00+00	12:00:00
924	1	11	699	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-03 00:00:00+00	12:00:00
925	1	30	700	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-03 00:00:00+00	12:00:00
926	2	25	701	29	2024-07-07 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-03 00:00:00+00	12:00:00
927	1	3	702	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-03 00:00:00+00	12:00:00
982	6	3	702	21	2024-07-09 00:30:00+00	on-hold	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
939	2	30	709	53	2024-07-08 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
908	2	23	686	28	2024-07-04 06:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-02 00:00:00+00	12:00:00
933	2	29	703	39	2024-07-08 04:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-03 00:00:00+00	12:00:00
934	2	18	704	13	2024-07-08 22:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
935	2	32	705	49	2024-07-09 03:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
936	2	32	706	34	2024-07-07 02:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
937	2	25	707	29	2024-07-10 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
938	2	29	708	26	2024-07-08 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
968	2	29	731	26	2024-07-08 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
969	2	22	732	39	2024-07-11 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-08 00:00:00+00	12:00:00
931	3	32	645	26	2024-07-04 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
932	2	11	614	47	2024-07-08 06:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-03 00:00:00+00	12:00:00
945	1	3	712	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
947	1	3	713	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
948	2	27	714	51	2024-07-04 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
949	2	27	715	51	2024-07-07 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
950	2	13	716	19	2024-07-10 01:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
951	2	25	717	29	2024-07-07 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
952	3	11	649	22	2024-07-05 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
953	2	34	718	48	2024-07-07 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
954	1	30	719	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
955	1	4	720	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
956	2	13	721	19	2024-07-08 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
957	2	22	722	45	2024-07-08 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
958	2	6	723	23	2024-07-08 06:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
966	1	11	729	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
960	1	4	725	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
962	3	30	647	54	2024-07-07 20:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
963	2	22	727	39	2024-07-09 05:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
964	2	12	728	48	2024-07-09 07:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
913	3	11	613	22	2024-07-04 07:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
914	1	3	689	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-02 00:00:00+00	12:00:00
928	2	32	619	49	2024-07-05 02:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-16 00:00:00+00	12:00:00
907	2	23	685	28	2024-07-02 22:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-03 00:00:00+00	12:00:00
970	2	11	733	47	2024-07-09 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-08 00:00:00+00	12:00:00
971	1	3	734	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-08 00:00:00+00	12:00:00
973	1	38	736	\N	2024-11-21 21:09:35+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-08 00:00:00+00	12:00:00
974	2	12	737	47	2024-07-09 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-08 00:00:00+00	12:00:00
975	1	4	738	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-08 00:00:00+00	12:00:00
976	1	3	739	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-08 00:00:00+00	12:00:00
977	2	3	702	38	2024-07-07 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-08 00:00:00+00	12:00:00
978	2	22	740	26	2024-07-10 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-08 00:00:00+00	12:00:00
979	1	30	741	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-08 00:00:00+00	12:00:00
980	1	30	742	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-08 00:00:00+00	12:00:00
904	1	4	682	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
905	1	4	683	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
940	3	23	686	38	2024-07-05 06:00:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-04 00:00:00+00	12:00:00
984	2	18	744	13	2024-07-11 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
1016	2	18	770	13	2024-07-14 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-19 00:00:00+00	12:00:00
1037	2	39	784	26	2024-07-17 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1052	2	32	793	\N	2024-11-21 21:09:35+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-15 00:00:00+00	12:00:00
988	1	4	748	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
989	2	2	749	55	2024-07-09 20:00:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
990	1	3	750	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
991	2	18	751	13	2024-07-11 21:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
992	2	11	752	47	2024-07-11 06:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
993	2	11	753	47	2024-07-12 06:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
994	2	32	754	49	2024-07-17 03:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
995	1	30	755	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
1019	2	28	773	32	2024-07-14 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1012	1	3	766	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-10 00:00:00+00	12:00:00
1000	2	12	757	48	2024-07-10 07:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
1001	2	35	758	13	2024-07-11 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
1003	2	27	759	51	2024-07-11 06:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
1004	5	20	530	33	2024-07-10 05:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-10 00:00:00+00	12:00:00
1005	2	18	760	13	2024-07-15 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-10 00:00:00+00	12:00:00
1006	2	11	761	47	2024-07-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-10 00:00:00+00	12:00:00
1007	2	25	762	29	2024-07-14 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-10 00:00:00+00	12:00:00
1011	1	4	765	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
983	3	12	737	35	2024-07-09 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
996	2	19	756	25	2024-07-09 23:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-10 00:00:00+00	12:00:00
999	6	32	610	21	2024-07-10 23:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
1013	2	38	767	34	2024-07-15 04:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-10 00:00:00+00	12:00:00
1014	2	27	768	51	2024-07-15 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-10 00:00:00+00	12:00:00
1015	1	30	769	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1020	3	29	703	26	2024-07-11 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1038	3	33	757	35	2024-07-14 21:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1064	2	43	802	26	2024-07-16 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-16 00:00:00+00	12:00:00
1039	2	16	743	47	2024-07-16 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-16 00:00:00+00	12:00:00
1021	6	2	638	21	2024-07-11 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1022	2	18	774	13	2024-07-15 22:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1023	2	11	775	47	2024-07-17 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1024	2	29	776	26	2024-07-17 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1025	2	22	777	45	2024-07-18 06:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1026	1	11	778	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1027	2	21	779	56	2024-07-15 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1028	2	21	780	57	2024-07-15 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1029	2	27	781	51	2024-07-12 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1030	2	19	782	32	2024-07-15 23:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1031	2	4	748	23	2024-07-11 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1032	3	2	749	30	2024-07-12 06:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1033	3	25	701	35	2024-07-16 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
1034	3	30	709	54	2024-07-15 23:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1035	2	37	783	26	2024-07-15 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1017	2	13	771	19	2024-07-11 21:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1018	2	28	772	32	2024-07-16 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-11 00:00:00+00	12:00:00
985	2	27	745	51	2024-07-12 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-17 00:00:00+00	12:00:00
1051	2	25	792	29	2024-07-16 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-15 00:00:00+00	12:00:00
1041	2	3	766	38	2024-07-15 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1042	2	23	786	28	2024-07-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1043	3	11	753	22	2024-07-15 06:30:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1044	2	29	787	26	2024-07-18 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1008	1	30	763	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1009	2	22	764	45	2024-07-15 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-10 00:00:00+00	12:00:00
1047	2	13	790	19	2024-07-15 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1048	2	35	791	13	2024-07-16 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
986	2	11	746	47	2024-07-09 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
987	2	41	747	26	2024-07-09 23:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-09 00:00:00+00	12:00:00
1053	1	32	794	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-15 00:00:00+00	12:00:00
1054	2	12	795	47	2024-07-17 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-15 00:00:00+00	12:00:00
1055	1	11	796	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-15 00:00:00+00	12:00:00
1056	2	8	797	24	2024-07-16 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-15 00:00:00+00	12:00:00
1057	2	19	798	32	2024-07-17 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-15 00:00:00+00	12:00:00
1058	2	18	799	13	2024-07-17 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-16 00:00:00+00	12:00:00
1060	2	29	801	26	2024-07-21 22:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-16 00:00:00+00	12:00:00
1061	5	2	638	33	2024-07-17 06:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-16 00:00:00+00	12:00:00
1045	2	23	788	28	2024-07-21 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-22 00:00:00+00	12:00:00
1046	2	6	789	23	2024-07-16 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1040	1	3	785	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1082	2	16	813	47	2024-07-23 06:30:00+00	rejected	\N	4	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1066	2	35	804	13	2024-07-17 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-16 00:00:00+00	12:00:00
1069	1	11	805	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-16 00:00:00+00	12:00:00
1070	2	40	806	26	2024-07-23 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-16 00:00:00+00	12:00:00
1071	2	32	794	49	2024-07-17 02:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-16 00:00:00+00	12:00:00
1072	2	25	807	29	2024-07-22 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-17 00:00:00+00	12:00:00
1073	1	16	808	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-17 00:00:00+00	12:00:00
1074	2	29	809	26	2024-07-23 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-17 00:00:00+00	12:00:00
1075	2	11	796	47	2024-07-23 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-17 00:00:00+00	12:00:00
1076	3	11	746	22	2024-07-22 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-17 00:00:00+00	12:00:00
1078	3	19	798	26	2024-07-22 23:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-17 00:00:00+00	12:00:00
1079	2	18	810	13	2024-07-24 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-18 00:00:00+00	12:00:00
1080	1	16	811	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-18 00:00:00+00	12:00:00
1081	2	29	812	26	2024-07-21 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-18 00:00:00+00	12:00:00
1083	2	25	814	29	2024-07-22 23:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-18 00:00:00+00	12:00:00
1084	1	16	815	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-18 00:00:00+00	12:00:00
1085	2	13	816	19	2024-07-19 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-18 00:00:00+00	12:00:00
1086	1	4	817	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-18 00:00:00+00	12:00:00
1087	2	21	818	56	2024-07-21 23:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-18 00:00:00+00	12:00:00
1088	1	16	819	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-19 00:00:00+00	12:00:00
1089	1	4	820	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-19 00:00:00+00	12:00:00
1091	2	13	822	19	2024-07-23 01:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-19 00:00:00+00	12:00:00
1093	2	43	823	26	2024-07-21 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-19 00:00:00+00	12:00:00
1094	1	3	824	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-19 00:00:00+00	12:00:00
1095	3	35	804	26	2024-07-22 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-19 00:00:00+00	12:00:00
1096	5	33	613	33	2024-07-23 06:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-19 00:00:00+00	12:00:00
1097	2	13	825	19	2024-07-22 06:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-19 00:00:00+00	12:00:00
1098	2	16	826	47	2024-07-25 06:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-19 00:00:00+00	12:00:00
1099	2	4	827	23	2024-07-29 06:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-19 00:00:00+00	12:00:00
1100	2	25	828	29	2024-07-24 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-22 00:00:00+00	12:00:00
1101	2	16	829	47	2024-07-26 06:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-22 00:00:00+00	12:00:00
1102	2	4	830	23	2024-07-26 06:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-22 00:00:00+00	12:00:00
1103	2	43	831	26	2024-07-25 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-22 00:00:00+00	12:00:00
1104	2	19	832	32	2024-07-24 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-22 00:00:00+00	12:00:00
1105	1	11	833	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-22 00:00:00+00	12:00:00
1106	1	21	834	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-22 00:00:00+00	12:00:00
1108	2	4	820	23	2024-07-23 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-22 00:00:00+00	12:00:00
1109	1	16	835	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-22 00:00:00+00	12:00:00
1117	1	21	842	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1118	1	38	843	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1112	2	21	838	56	2024-07-23 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-22 00:00:00+00	12:00:00
1113	2	23	839	28	2024-07-24 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1114	1	16	840	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1110	2	19	836	25	2024-07-23 00:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1111	2	21	837	56	2024-07-22 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-22 00:00:00+00	12:00:00
1119	1	21	844	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1120	2	23	845	28	2024-07-28 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1121	1	21	846	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1122	2	21	847	34	2024-07-31 04:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1123	2	25	848	29	2024-07-30 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1125	2	22	850	39	2024-07-25 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1126	3	27	745	38	2024-07-25 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1127	1	21	851	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1128	2	41	852	26	2024-07-23 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1129	1	38	853	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1130	2	13	854	19	2024-07-30 01:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1131	1	16	855	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1132	1	21	856	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1134	2	18	858	13	2024-07-28 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1135	2	29	859	26	2024-07-31 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1136	1	38	860	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-24 00:00:00+00	12:00:00
1137	2	16	840	47	2024-07-29 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-24 00:00:00+00	12:00:00
1139	2	27	861	51	2024-07-29 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-29 00:00:00+00	12:00:00
1140	2	27	862	51	2024-07-26 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-24 00:00:00+00	12:00:00
1065	2	24	803	50	2024-07-16 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-16 00:00:00+00	12:00:00
1141	3	23	788	38	2024-07-25 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-24 00:00:00+00	12:00:00
1142	1	16	863	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-24 00:00:00+00	12:00:00
1144	2	38	865	34	2024-08-12 04:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1145	2	25	866	29	2024-07-31 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1146	2	29	867	26	2024-07-31 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1147	3	16	868	22	2024-07-25 20:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1138	3	3	766	35	2024-07-28 20:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1090	2	28	821	32	2024-07-21 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1149	2	23	870	28	2024-07-25 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1150	2	23	871	28	2024-07-28 20:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1151	2	24	872	50	2024-07-29 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1152	2	24	873	26	2024-07-30 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1154	3	4	820	26	2024-07-29 00:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1156	1	16	874	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1157	2	29	875	39	2024-07-30 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1158	2	32	876	34	2024-08-11 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1159	1	4	877	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1160	2	24	878	50	2024-07-29 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1161	2	28	879	32	2024-07-29 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1162	2	29	880	39	2024-07-29 05:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1163	1	16	881	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1164	2	38	853	34	2024-07-31 04:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1165	2	16	863	47	2024-07-30 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1166	2	28	882	32	2024-07-30 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1167	2	24	883	50	2024-07-28 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1168	2	23	884	28	2024-07-30 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1169	2	27	885	51	2024-07-30 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-26 00:00:00+00	12:00:00
1170	2	18	886	13	2024-07-30 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-29 00:00:00+00	12:00:00
1194	1	33	904	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1196	2	19	906	32	2024-08-06 20:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-31 00:00:00+00	12:00:00
1174	1	21	889	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-29 00:00:00+00	12:00:00
1175	1	21	890	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-29 00:00:00+00	12:00:00
1181	6	16	826	35	2024-07-31 20:30:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-29 00:00:00+00	12:00:00
1182	5	23	788	33	2024-07-31 06:45:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1178	2	21	834	57	2024-07-30 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-29 00:00:00+00	12:00:00
1179	1	21	893	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-29 00:00:00+00	12:00:00
1176	1	33	891	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-29 00:00:00+00	12:00:00
1177	2	22	892	26	2024-07-31 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-29 00:00:00+00	12:00:00
1183	1	21	894	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1184	2	13	895	19	2024-07-31 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1186	1	33	897	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1187	2	38	898	34	2024-08-01 04:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1188	2	38	899	34	2024-08-01 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1189	2	28	900	32	2024-08-05 20:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1190	2	42	901	29	2024-08-05 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1191	2	22	902	39	2024-08-07 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1192	1	21	903	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1171	2	28	887	32	2024-08-01 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1172	2	19	888	25	2024-08-01 00:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-29 00:00:00+00	12:00:00
1197	2	25	907	29	2024-08-07 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-31 00:00:00+00	12:00:00
1198	2	22	908	45	2024-08-07 06:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-31 00:00:00+00	12:00:00
1199	2	38	909	34	2024-08-13 04:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-31 00:00:00+00	12:00:00
1200	3	24	878	26	2024-08-04 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-31 00:00:00+00	12:00:00
1201	2	24	910	50	2024-07-31 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-31 00:00:00+00	12:00:00
1202	2	27	911	51	2024-08-02 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-31 00:00:00+00	12:00:00
1204	5	27	745	33	2024-08-01 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-31 00:00:00+00	12:00:00
1205	1	16	912	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-31 00:00:00+00	12:00:00
1206	2	41	913	32	2024-08-06 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-31 00:00:00+00	12:00:00
1207	1	33	726	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-31 00:00:00+00	12:00:00
1208	2	18	914	13	2024-09-08 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1209	2	23	915	28	2024-09-03 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1210	2	22	916	39	2024-09-06 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1211	2	24	917	14	2024-09-03 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1213	2	24	919	14	2024-09-02 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1214	2	38	920	34	2024-09-06 02:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1215	2	4	921	23	2024-09-02 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1216	1	3	922	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1217	1	3	923	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1218	2	21	924	34	2024-09-05 02:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1219	2	27	925	51	2024-09-04 06:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1220	2	21	926	57	2024-09-03 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1221	1	4	927	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1223	2	19	929	32	2024-09-03 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1228	2	23	934	28	2024-09-05 22:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-23 00:00:00+00	12:00:00
1148	1	21	869	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1226	2	18	932	13	2024-09-11 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-03 00:00:00+00	12:00:00
1227	2	23	933	28	2024-09-05 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-03 00:00:00+00	12:00:00
1229	2	17	935	53	2024-09-22 22:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-03 00:00:00+00	12:00:00
1224	2	19	930	25	2024-09-04 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-05 00:00:00+00	12:00:00
1225	2	18	931	13	2024-09-10 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-03 00:00:00+00	12:00:00
1310	\N	45	1002	\N	2024-11-21 21:09:35+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1232	2	24	938	14	2024-09-06 07:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-03 00:00:00+00	12:00:00
1233	2	19	939	32	2024-09-05 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-03 00:00:00+00	12:00:00
1234	2	13	940	59	2024-09-05 05:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-03 00:00:00+00	12:00:00
1235	2	27	941	51	2024-09-06 06:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-04 00:00:00+00	12:00:00
1236	2	27	942	51	2024-09-23 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-04 00:00:00+00	12:00:00
1237	2	18	943	13	2024-09-08 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-04 00:00:00+00	12:00:00
1238	2	29	944	26	2024-09-05 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-04 00:00:00+00	12:00:00
1239	1	30	945	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-05 00:00:00+00	12:00:00
1240	3	27	946	38	2024-09-05 21:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-05 00:00:00+00	12:00:00
1242	2	18	947	13	2024-09-08 23:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-05 00:00:00+00	12:00:00
1243	2	23	948	28	2024-09-09 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-05 00:00:00+00	12:00:00
1244	3	27	941	38	2024-09-06 06:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-05 00:00:00+00	12:00:00
1245	1	4	949	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-06 00:00:00+00	12:00:00
1246	3	27	925	38	2024-09-18 21:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-18 00:00:00+00	12:00:00
1247	2	25	950	29	2024-09-22 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-18 00:00:00+00	12:00:00
1301	2	28	996	32	2024-09-25 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1302	1	38	997	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1250	2	29	953	39	2024-09-18 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-18 00:00:00+00	12:00:00
1251	1	32	954	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-18 00:00:00+00	12:00:00
1252	1	23	955	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-18 00:00:00+00	12:00:00
1253	2	23	956	28	2024-09-18 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-18 00:00:00+00	12:00:00
1254	2	8	957	24	2024-09-18 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-18 00:00:00+00	12:00:00
1255	2	17	958	53	2024-09-18 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-18 00:00:00+00	12:00:00
1256	1	21	959	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-18 00:00:00+00	12:00:00
1257	2	23	960	28	2024-09-19 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-19 00:00:00+00	12:00:00
1258	2	23	961	28	2024-09-22 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-19 00:00:00+00	12:00:00
1259	2	18	962	13	2024-09-19 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-19 00:00:00+00	12:00:00
1260	2	18	963	13	2024-09-22 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-19 00:00:00+00	12:00:00
1261	2	13	964	59	2024-09-22 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-19 00:00:00+00	12:00:00
1284	2	19	981	32	2024-09-24 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-25 00:00:00+00	12:00:00
1285	2	13	982	59	2024-10-09 21:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-23 00:00:00+00	12:00:00
1264	1	32	629	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-19 00:00:00+00	12:00:00
1265	1	32	967	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-19 00:00:00+00	12:00:00
1266	2	13	968	59	2024-09-24 06:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-20 00:00:00+00	12:00:00
1267	2	29	969	26	2024-09-23 23:00:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-20 00:00:00+00	12:00:00
1268	2	23	970	28	2024-09-24 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-20 00:00:00+00	12:00:00
1307	3	13	982	22	2024-09-25 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-25 00:00:00+00	12:00:00
1308	2	21	1000	57	2024-09-29 22:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-25 00:00:00+00	12:00:00
1271	2	19	973	25	2024-09-23 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-20 00:00:00+00	12:00:00
1303	2	2	998	55	2024-09-25 23:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-25 00:00:00+00	12:00:00
1231	1	32	937	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-03 00:00:00+00	12:00:00
1274	2	18	974	13	2024-09-25 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-23 00:00:00+00	12:00:00
1275	1	7	975	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-23 00:00:00+00	12:00:00
1276	1	7	976	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-23 00:00:00+00	12:00:00
1278	2	8	977	24	2024-09-25 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-23 00:00:00+00	12:00:00
1281	2	18	978	13	2024-09-23 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-30 00:00:00+00	12:00:00
1282	1	38	979	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-23 00:00:00+00	12:00:00
1283	2	19	980	25	2024-09-24 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-23 00:00:00+00	12:00:00
1248	2	21	951	57	2024-09-22 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-26 00:00:00+00	12:00:00
1249	2	24	952	60	2024-09-18 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-18 00:00:00+00	12:00:00
1286	2	23	983	28	2024-09-24 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-23 00:00:00+00	12:00:00
1287	6	5	984	21	2024-09-26 01:00:00+00	on-hold	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-23 00:00:00+00	12:00:00
1288	6	5	985	21	2024-09-25 06:30:00+00	on-hold	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-23 00:00:00+00	12:00:00
1290	2	19	986	32	2024-09-26 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1291	2	25	987	29	2024-09-26 22:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1292	2	19	988	25	2024-09-25 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1293	2	21	989	56	2024-09-26 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1294	2	22	990	39	2024-09-26 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1295	2	18	991	13	2024-09-25 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1296	2	23	992	28	2024-09-25 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1297	2	18	993	13	2024-09-26 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1299	2	29	995	26	2024-09-25 22:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1262	2	21	965	56	2024-09-22 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1263	2	39	966	26	2024-09-22 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-19 00:00:00+00	12:00:00
1304	2	2	999	55	2024-09-29 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-25 00:00:00+00	12:00:00
1272	2	23	955	28	2024-09-22 21:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1273	3	8	957	22	2024-09-23 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-23 00:00:00+00	12:00:00
1270	1	17	972	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-20 00:00:00+00	12:00:00
1309	2	17	1001	53	2024-09-30 22:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-25 00:00:00+00	12:00:00
1312	2	24	1004	14	2024-10-02 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-25 00:00:00+00	12:00:00
1269	2	25	971	29	2024-09-23 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1388	2	19	1063	25	2024-10-07 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1317	1	45	1007	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-25 00:00:00+00	12:00:00
1318	1	45	1008	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-25 00:00:00+00	12:00:00
1319	1	45	1009	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-25 00:00:00+00	12:00:00
1320	2	14	1010	59	2024-09-29 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-25 00:00:00+00	12:00:00
1321	1	25	1011	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-25 00:00:00+00	12:00:00
1322	2	13	1012	59	2024-09-26 07:00:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-25 00:00:00+00	12:00:00
1323	2	39	1013	26	2024-09-26 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-26 00:00:00+00	12:00:00
1324	1	21	1014	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-26 00:00:00+00	12:00:00
1330	2	28	1019	26	2024-10-02 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1331	2	28	1020	32	2024-10-02 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-26 00:00:00+00	12:00:00
1328	2	17	1017	53	2024-10-03 01:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-26 00:00:00+00	12:00:00
1329	1	17	1018	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-26 00:00:00+00	12:00:00
1390	2	27	1064	51	2024-10-07 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1391	1	32	1065	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1332	2	28	1021	32	2024-10-03 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-26 00:00:00+00	12:00:00
1333	2	41	1022	26	2024-10-01 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-27 00:00:00+00	12:00:00
1334	2	23	1023	28	2024-10-07 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-27 00:00:00+00	12:00:00
1335	2	21	1024	56	2024-10-03 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-27 00:00:00+00	12:00:00
1336	2	22	1025	39	2024-10-02 06:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-27 00:00:00+00	12:00:00
1338	1	17	1026	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-27 00:00:00+00	12:00:00
1339	1	25	1027	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-27 00:00:00+00	12:00:00
1340	1	25	1028	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-27 00:00:00+00	12:00:00
1341	2	18	1029	13	2024-10-03 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-27 00:00:00+00	12:00:00
1342	2	18	1030	13	2024-09-02 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-27 00:00:00+00	12:00:00
1343	2	23	1031	28	2024-10-02 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-27 00:00:00+00	12:00:00
1344	2	13	1032	59	2024-10-04 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-27 00:00:00+00	12:00:00
1345	1	23	1033	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-30 00:00:00+00	12:00:00
1346	2	24	1034	60	2024-09-30 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-30 00:00:00+00	12:00:00
1347	2	23	1035	28	2024-10-02 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-30 00:00:00+00	12:00:00
1355	1	21	1036	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1356	2	40	1037	26	2024-10-03 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1352	3	22	504	37	2024-10-02 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-30 00:00:00+00	12:00:00
1387	2	19	1062	25	2024-10-03 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-18 00:00:00+00	12:00:00
1351	2	7	976	51	2024-09-30 21:30:00+00	on-hold	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-30 00:00:00+00	12:00:00
1357	2	18	1038	13	2024-10-02 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1359	2	23	1039	28	2024-10-06 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1360	2	18	1040	13	2024-10-03 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1361	2	18	1041	13	2024-10-03 23:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1362	2	13	1042	59	2024-10-08 07:00:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1315	2	19	1005	32	2024-09-29 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1316	1	7	1006	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-25 00:00:00+00	12:00:00
1366	1	25	1044	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1367	2	29	1045	39	2024-10-04 05:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1368	2	29	1046	26	2024-10-06 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1369	3	2	998	30	2024-10-07 07:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1363	2	1	1033	38	2024-10-06 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1365	2	28	1043	26	2024-10-03 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1372	2	18	1049	13	2024-10-07 22:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1373	2	27	1050	51	2024-10-07 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1374	2	18	1051	13	2024-10-07 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1375	2	22	1052	39	2024-10-04 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1376	2	18	1053	13	2024-10-03 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1377	2	21	1054	34	2024-10-07 04:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1378	2	25	1055	36	2024-10-03 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1379	2	40	1056	26	2024-10-07 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1380	2	7	1057	61	2024-10-04 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1381	3	14	1010	22	2024-10-07 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1382	2	22	1058	39	2024-10-04 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1383	2	39	1059	26	2024-10-06 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1384	2	7	1006	61	2024-10-09 05:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1385	1	38	1060	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1386	2	22	1061	27	2024-10-07 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1353	3	39	1013	26	2024-10-02 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1350	2	7	975	51	2024-10-03 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-01 00:00:00+00	12:00:00
1389	2	27	1060	51	2024-10-08 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1326	2	24	1015	14	2024-09-30 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1327	2	19	1016	25	2024-09-30 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-26 00:00:00+00	12:00:00
1392	2	22	1066	39	2024-10-08 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1394	2	25	1068	36	2024-10-06 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1370	2	18	1047	13	2024-10-08 23:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1371	2	18	1048	13	2024-10-07 21:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-03 00:00:00+00	12:00:00
1419	\N	38	1086	\N	2024-11-21 21:09:36+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1431	2	17	1095	53	2024-10-11 01:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1397	2	32	1070	34	2024-10-14 02:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1398	2	33	1071	48	2024-10-09 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1399	2	28	1072	37	2024-10-09 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1400	2	19	1073	32	2024-10-08 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1401	2	18	1074	13	2024-10-08 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1402	2	22	1075	39	2024-10-07 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1403	2	13	1076	59	2024-10-08 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1405	2	22	1077	39	2024-10-09 05:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1406	3	2	999	30	2024-10-09 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1407	2	27	1078	51	2024-10-09 06:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1408	3	28	1020	26	2024-10-08 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
1411	1	17	1079	53	2024-10-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1412	1	17	1080	\N	2024-11-21 21:09:36+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1413	2	18	1081	13	2024-10-09 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1414	2	21	1082	56	2024-10-07 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1415	2	28	1083	32	2024-10-07 20:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1416	3	29	1069	26	2024-10-14 05:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1417	2	18	1084	13	2024-10-08 23:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1418	2	29	1085	39	2024-10-09 05:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1420	1	30	1087	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1421	1	30	1088	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1422	2	45	1089	22	2024-10-08 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1423	2	19	1090	25	2024-10-08 23:00:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1449	2	23	1110	28	2024-10-09 23:45:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1450	2	13	1111	59	2024-10-15 06:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1425	2	22	1091	37	2024-10-10 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1428	2	19	1092	32	2024-10-09 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1432	1	38	1096	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1433	2	23	1097	28	2024-10-09 23:45:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1437	3	7	975	26	2024-10-10 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-10 00:00:00+00	12:00:00
1438	1	21	1099	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-08 00:00:00+00	12:00:00
1436	1	21	1098	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-08 00:00:00+00	12:00:00
1471	2	25	1126	62	2024-10-15 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1396	2	29	1069	39	2024-10-07 05:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1439	2	18	1100	13	2024-10-08 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-08 00:00:00+00	12:00:00
1440	2	25	1101	29	2024-10-09 04:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-08 00:00:00+00	12:00:00
1441	2	29	1102	39	2024-10-09 04:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-08 00:00:00+00	12:00:00
1442	2	17	1103	53	2024-10-13 22:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-08 00:00:00+00	12:00:00
1443	2	18	1104	13	2024-10-08 22:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-08 00:00:00+00	12:00:00
1444	2	21	1105	56	2024-10-09 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1445	2	18	1106	13	2024-10-10 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1446	2	25	1107	29	2024-10-10 04:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1447	2	29	1108	39	2024-10-10 04:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1448	2	18	1109	13	2024-10-09 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1434	2	30	1087	53	2024-10-09 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1435	2	30	1088	53	2024-10-09 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-08 00:00:00+00	12:00:00
1451	2	18	1112	13	2024-10-10 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1473	2	25	1044	62	2024-10-16 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1454	3	28	1021	26	2024-10-13 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1455	2	8	1115	24	2024-10-13 20:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1456	3	19	1116	26	2024-10-10 23:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1457	2	18	1117	13	2024-10-14 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1458	1	30	1118	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1459	2	30	1094	53	2024-10-13 22:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1461	2	21	1119	56	2024-10-10 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-10 00:00:00+00	12:00:00
1462	2	18	1120	13	2024-10-10 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-10 00:00:00+00	12:00:00
1463	2	22	1121	39	2024-10-11 05:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-10 00:00:00+00	12:00:00
1464	2	23	1122	28	2024-10-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-10 00:00:00+00	12:00:00
1465	1	3	1123	\N	2024-11-21 21:09:36+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-10 00:00:00+00	12:00:00
1466	2	17	1124	53	2024-10-14 22:30:00+00	on-hold	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-10 00:00:00+00	12:00:00
1467	2	17	1125	53	2024-10-16 01:30:00+00	on-hold	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-10 00:00:00+00	12:00:00
1452	2	19	1113	25	2024-10-10 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1453	2	28	1114	32	2024-10-14 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-09 00:00:00+00	12:00:00
1474	2	21	1127	56	2024-10-13 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1475	2	18	1128	13	2024-10-14 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1476	2	22	1129	39	2024-10-14 05:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1429	2	19	1093	32	2024-10-10 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1430	1	30	1094	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-07 00:00:00+00	12:00:00
1513	3	17	1095	54	2024-10-15 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1478	2	18	1131	13	2024-10-13 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1479	2	18	1132	13	2024-10-13 23:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1480	2	23	1133	28	2024-10-13 23:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1482	3	19	1093	26	2024-10-14 22:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1483	2	27	1134	51	2024-10-14 06:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1485	1	4	1135	\N	2024-11-21 21:09:36+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1486	1	4	1136	\N	2024-11-21 21:09:36+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1487	3	7	1006	26	2024-10-14 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1490	2	14	1137	59	2024-10-17 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1491	2	14	1138	59	2024-10-16 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1492	2	22	1139	39	2024-10-18 05:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1493	2	24	1140	14	2024-10-17 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1495	2	21	1141	56	2024-10-16 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1496	2	18	1142	13	2024-10-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1497	2	22	1143	39	2024-10-17 05:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1498	2	32	1144	34	2024-10-17 02:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1499	2	16	815	63	2024-10-27 20:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1500	2	18	1145	13	2024-10-15 21:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1501	2	18	1146	13	2024-10-14 22:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1503	2	25	1147	62	2024-10-28 21:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1504	1	14	1148	59	2024-10-17 06:30:00+00	sourced	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1505	1	3	1149	\N	2024-11-21 21:09:36+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1506	1	3	1150	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1507	1	4	1151	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1508	1	4	1152	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1510	2	22	1153	27	2024-10-17 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-14 00:00:00+00	12:00:00
1511	3	27	1134	38	2024-10-15 00:00:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-15 00:00:00+00	12:00:00
1512	3	17	1094	54	2024-10-16 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-15 00:00:00+00	12:00:00
1536	2	18	1168	13	2024-10-20 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1515	2	25	1155	36	2024-10-16 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-15 00:00:00+00	12:00:00
1516	2	25	1156	62	2024-10-21 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-15 00:00:00+00	12:00:00
1547	2	13	1175	59	2024-10-23 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1518	3	18	1048	26	2024-10-15 22:00:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-15 00:00:00+00	12:00:00
1528	3	30	1088	54	2024-10-23 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1530	6	2	998	63	2024-10-16 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1521	2	18	1160	13	2024-10-17 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1522	2	22	1161	39	2024-10-21 05:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1523	2	23	1162	28	2024-10-21 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1524	2	23	1163	28	2024-10-16 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1525	2	18	1164	13	2024-10-17 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1519	2	13	1158	59	2024-10-21 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1520	2	21	1159	57	2024-10-21 21:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1542	2	29	1173	26	2024-10-21 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-23 00:00:00+00	12:00:00
1532	2	37	1165	26	2024-10-20 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1534	1	21	1166	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-16 00:00:00+00	12:00:00
1535	1	3	1167	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1537	2	18	1169	13	2024-10-20 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1531	6	2	999	63	2024-10-17 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1538	6	40	1056	63	2024-10-22 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1539	2	21	1170	57	2024-10-22 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1540	2	18	1171	13	2024-10-21 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1541	2	22	1172	39	2024-10-22 05:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1543	2	16	1174	63	2024-10-24 20:30:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1544	6	18	1048	63	2024-10-20 20:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1477	2	23	1130	28	2024-10-15 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-11 00:00:00+00	12:00:00
1545	6	18	1145	63	2024-10-21 20:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1517	2	35	1157	13	2024-10-16 23:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1548	3	30	1125	54	2024-10-18 00:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1549	1	16	1176	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1550	2	27	1177	51	2024-10-25 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1551	2	27	1178	51	2024-10-29 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-17 00:00:00+00	12:00:00
1553	2	18	1179	13	2024-10-22 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-18 00:00:00+00	12:00:00
1554	2	13	1180	59	2024-10-22 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-18 00:00:00+00	12:00:00
1555	2	19	1181	25	2024-10-20 23:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-18 00:00:00+00	12:00:00
1556	2	34	1182	48	2024-10-22 05:00:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-18 00:00:00+00	12:00:00
1557	1	4	1183	\N	2024-11-21 21:09:36+00	sourced	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-18 00:00:00+00	12:00:00
1558	1	16	1184	\N	2024-11-21 21:09:36+00	sourced	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-18 00:00:00+00	12:00:00
1514	2	25	1154	62	2024-10-20 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
1575	1	35	1197	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1601	1	16	1216	\N	2024-11-21 21:09:36+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1633	2	27	1239	51	2024-11-04 06:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1640	1	35	1243	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1641	1	18	1244	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1559	1	3	1185	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-18 00:00:00+00	12:00:00
1561	2	27	1186	51	2024-10-24 05:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-18 00:00:00+00	12:00:00
1562	1	11	1187	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
1563	2	18	1188	13	2024-10-24 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
1564	1	4	1189	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
1566	1	30	1190	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
1567	3	30	1087	54	2024-10-24 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
1568	2	18	1191	13	2024-10-23 23:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
1569	2	13	1192	59	2024-10-24 06:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
1570	1	16	1193	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
1571	2	27	1194	51	2024-10-23 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
1573	1	3	1195	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
1574	2	23	1196	28	2024-10-21 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-21 00:00:00+00	12:00:00
1576	2	18	1198	13	2024-10-28 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1577	2	13	1199	59	2024-11-06 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1578	1	16	1200	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1579	1	4	1201	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1580	2	7	1202	51	2024-10-24 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1583	1	3	1203	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1584	1	4	1204	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1603	2	6	1218	23	2024-10-24 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-24 00:00:00+00	12:00:00
1588	2	18	1206	13	2024-10-23 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1589	2	25	1207	36	2024-10-24 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1590	2	13	1208	59	2024-10-22 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1591	2	29	1209	26	2024-10-23 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-22 00:00:00+00	12:00:00
1592	1	11	1210	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-23 00:00:00+00	12:00:00
1593	1	16	1211	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-23 00:00:00+00	12:00:00
1594	5	30	1088	33	2024-10-29 06:00:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-23 00:00:00+00	12:00:00
1595	2	35	1212	13	2024-11-04 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-23 00:00:00+00	12:00:00
1596	2	25	1213	36	2024-11-04 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-23 00:00:00+00	12:00:00
1597	2	18	1214	13	2024-10-29 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-23 00:00:00+00	12:00:00
1598	2	29	1215	26	2024-10-29 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-23 00:00:00+00	12:00:00
1602	2	33	1217	48	2024-10-25 06:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-23 00:00:00+00	12:00:00
1610	2	14	1222	59	2024-11-04 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-24 00:00:00+00	12:00:00
1604	1	18	1219	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-24 00:00:00+00	12:00:00
1585	2	27	1205	51	2024-10-24 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-24 00:00:00+00	12:00:00
1607	3	7	1202	26	2024-11-05 00:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-24 00:00:00+00	12:00:00
1608	1	18	1220	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-24 00:00:00+00	12:00:00
1609	1	4	1221	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-24 00:00:00+00	12:00:00
1611	1	17	1223	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-25 00:00:00+00	12:00:00
1612	2	27	1224	51	2024-10-29 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-25 00:00:00+00	12:00:00
1615	1	4	1225	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-25 00:00:00+00	12:00:00
1616	1	17	1226	\N	2024-11-21 21:09:36+00	sourced	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-28 00:00:00+00	12:00:00
1617	2	21	1227	57	2024-11-05 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-28 00:00:00+00	12:00:00
1618	2	22	1228	39	2024-11-06 06:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-28 00:00:00+00	12:00:00
1619	2	23	1229	28	2024-11-06 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-28 00:00:00+00	12:00:00
1620	2	23	1230	28	2024-10-28 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-28 00:00:00+00	12:00:00
1639	2	19	1242	32	2024-11-06 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-04 00:00:00+00	12:00:00
1622	1	18	1232	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-28 00:00:00+00	12:00:00
1623	1	18	1233	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-28 00:00:00+00	12:00:00
1624	3	23	1230	38	2024-10-29 22:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-29 00:00:00+00	12:00:00
1634	1	18	548	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-04 00:00:00+00	12:00:00
1626	3	25	1147	54	2024-11-04 21:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-29 00:00:00+00	12:00:00
1627	1	18	1235	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-29 00:00:00+00	12:00:00
1628	1	4	1236	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-29 00:00:00+00	12:00:00
1629	2	23	1237	28	2024-11-06 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-29 00:00:00+00	12:00:00
1632	2	27	1238	51	2024-11-07 06:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-01 00:00:00+00	12:00:00
1635	2	19	1240	25	2024-11-05 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-04 00:00:00+00	12:00:00
1636	2	25	1241	62	2024-11-07 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-04 00:00:00+00	12:00:00
1621	2	43	1231	26	2024-10-31 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-04 00:00:00+00	12:00:00
1642	2	22	1245	27	2024-11-04 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-04 00:00:00+00	12:00:00
1625	2	25	1234	62	2024-10-31 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1688	1	16	1281	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1689	1	4	1282	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1710	2	29	1297	26	2024-11-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1643	2	27	1246	51	2024-11-06 06:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-04 00:00:00+00	12:00:00
1644	2	35	1247	64	2024-11-04 19:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-04 00:00:00+00	12:00:00
1645	2	21	1248	57	2024-11-07 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1646	1	35	1249	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1647	2	22	1250	39	2024-11-07 05:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1648	2	22	1251	39	2024-11-08 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1649	1	38	1252	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1650	1	4	1253	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1651	2	4	1225	23	2024-11-10 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1652	2	16	1193	63	2024-11-05 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1653	5	25	1147	33	2024-11-06 06:00:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1654	2	16	1254	63	2024-11-18 20:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1655	2	16	1255	63	2024-11-17 20:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1656	2	35	1256	64	2024-11-05 19:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1657	2	33	1257	48	2024-11-07 05:00:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1658	2	33	1258	48	2024-11-06 05:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1659	1	18	1259	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1660	2	27	1260	51	2024-11-07 06:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1662	1	7	1261	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-05 00:00:00+00	12:00:00
1663	2	19	1262	25	2024-11-11 06:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1664	2	27	1263	51	2024-11-06 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1665	2	4	1264	23	2024-11-18 06:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1666	2	13	1265	59	2024-11-07 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1667	1	16	1266	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1668	2	39	1267	26	2024-11-10 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1669	2	28	1268	26	2024-11-07 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1670	2	5	1269	23	2024-11-06 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1671	2	23	1270	28	2024-11-06 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1672	3	16	815	35	2024-11-06 20:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1673	2	4	1201	23	2024-11-07 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1674	1	11	1271	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1675	2	24	1272	14	2024-11-07 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1676	1	3	1273	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1677	2	43	1274	26	2024-11-07 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-06 00:00:00+00	12:00:00
1722	2	33	1308	48	2024-11-14 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1680	1	38	1275	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-07 00:00:00+00	12:00:00
1681	1	38	1276	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-07 00:00:00+00	12:00:00
1682	3	21	1159	34	2024-11-08 04:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-07 00:00:00+00	12:00:00
1683	3	38	1277	34	2024-11-12 04:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-07 00:00:00+00	12:00:00
1684	1	4	1278	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-07 00:00:00+00	12:00:00
1685	2	22	1279	39	2024-11-08 05:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-07 00:00:00+00	12:00:00
1686	3	4	1183	63	2024-11-07 20:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-07 00:00:00+00	12:00:00
1687	2	35	1280	64	2024-11-07 19:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-07 00:00:00+00	12:00:00
1694	2	35	1284	64	2024-11-11 19:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1678	3	22	1245	26	2024-11-07 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-08 00:00:00+00	12:00:00
1695	2	9	1285	33	2024-11-12 06:00:00+00	on-hold	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1696	2	9	1286	33	2024-11-13 06:45:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1697	2	9	1287	33	2024-11-13 06:00:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1699	2	19	1289	26	2024-11-13 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1700	2	33	1290	48	2024-11-18 05:00:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1702	2	35	1291	64	2024-11-11 21:00:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1703	2	3	1203	38	2024-11-11 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1724	2	19	1310	32	2024-11-12 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1705	1	18	1292	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1706	2	19	1293	32	2024-11-11 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1692	2	29	1283	26	2024-11-11 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1709	1	38	1296	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1711	2	22	1298	39	2024-11-12 06:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1712	2	21	1299	57	2024-11-17 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1713	2	23	1300	28	2024-11-11 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1714	2	21	1301	57	2024-11-13 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1715	3	22	1250	26	2024-11-14 23:00:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1716	2	33	1302	48	2024-11-14 05:00:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1718	2	13	1304	59	2024-11-18 06:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1719	2	24	1305	65	2024-11-18 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1720	2	13	1306	59	2024-11-13 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1721	2	33	1307	48	2024-11-12 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1704	2	4	1204	23	2024-11-13 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1723	2	19	1309	32	2024-11-13 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1707	2	19	1294	25	2024-11-11 23:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1763	2	33	1342	48	2024-11-13 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1726	2	22	1312	39	2024-11-13 05:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1727	2	25	1313	36	2024-11-12 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1729	2	22	1314	39	2024-11-14 06:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1730	2	22	1315	39	2024-11-13 06:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1731	2	23	1316	28	2024-11-12 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1732	6	3	1203	63	2024-11-17 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1733	2	23	1317	28	2024-11-14 00:45:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1734	2	27	1318	51	2024-11-14 06:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1735	2	19	1319	26	2024-11-12 23:00:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1737	2	33	1320	48	2024-11-13 06:00:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1793	3	33	1307	22	2024-11-20 07:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1762	2	2	1341	66	2024-11-15 01:15:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1741	1	21	1323	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1742	1	45	1324	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1743	2	19	1325	32	2024-11-18 01:00:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1744	2	24	1326	65	2024-11-17 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1745	2	35	1327	64	2024-11-14 20:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1746	2	35	1328	64	2024-11-14 21:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1747	2	27	1329	51	2024-11-19 06:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1748	2	33	1330	48	2024-11-20 05:00:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1749	1	45	1331	\N	2024-11-21 21:09:36+00	sourced	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1750	2	22	1332	39	2024-11-15 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1751	2	19	1333	25	2024-11-13 20:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1752	2	21	1334	57	2024-11-19 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1753	1	18	564	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1754	2	27	1335	51	2024-11-18 06:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1755	3	22	1315	37	2024-11-14 21:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1757	2	27	1336	51	2024-11-15 06:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1758	2	33	1337	48	2024-11-21 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1759	2	19	1338	25	2024-11-14 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1760	2	19	1339	25	2024-11-14 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1766	2	40	1345	26	2024-11-17 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1775	2	33	1350	48	2024-11-20 05:00:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1764	2	19	1343	25	2024-11-14 23:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1765	2	19	1344	26	2024-11-13 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1783	2	40	1356	26	2024-11-17 23:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1767	2	25	1346	36	2024-11-14 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1768	2	33	1347	48	2024-11-14 01:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1769	2	35	1348	64	2024-11-13 19:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1770	1	35	1349	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-13 00:00:00+00	12:00:00
1791	2	33	1363	48	2024-11-20 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1776	2	45	1351	67	2024-11-14 22:00:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1777	2	27	1352	51	2024-11-20 06:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1778	2	9	1353	33	2024-11-19 06:00:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1779	3	33	1302	22	2024-11-19 07:00:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1780	1	11	572	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1781	2	14	1354	59	2024-11-21 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1782	1	18	1355	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1725	2	24	1311	14	2024-11-13 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1784	2	5	1357	23	2024-11-15 00:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1785	2	22	1358	39	2024-11-18 05:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1786	2	19	1359	32	2024-11-18 20:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1787	2	19	1360	32	2024-11-19 20:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1788	2	23	1361	28	2024-11-14 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1790	2	33	1362	48	2024-11-19 05:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1761	2	2	1340	66	2024-11-19 04:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1738	2	33	1321	48	2024-11-14 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-14 00:00:00+00	12:00:00
1795	3	19	1310	26	2024-11-18 23:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1796	2	19	1364	25	2024-11-17 23:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1797	2	29	1365	26	2024-11-21 23:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1798	2	13	1366	68	2024-11-18 07:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1799	2	33	1367	48	2024-11-21 01:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1800	2	21	1368	56	2024-11-22 00:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1801	2	22	1369	39	2024-11-21 05:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1802	2	19	1370	32	2024-11-20 20:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1803	2	27	1371	51	2024-11-17 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1804	2	21	1372	56	2024-11-21 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1805	2	38	1373	34	2024-11-20 04:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1806	2	27	1374	51	2024-11-21 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1739	2	33	1322	48	2024-11-15 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1812	2	38	1378	34	2024-11-18 04:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1821	\N	33	1383	\N	2024-11-21 21:09:36+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1826	\N	24	1386	\N	2024-11-21 21:09:36+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1849	\N	33	1404	\N	2024-11-21 21:09:36+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1853	\N	17	1407	\N	2024-11-21 21:09:37+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1854	\N	35	1408	\N	2024-11-21 21:09:37+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	\N	12:00:00
1	2	18	1	13	2024-04-08 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 18:30:00+00	12:00:00
1311	2	21	1003	56	2024-09-26 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-27 00:00:00+00	12:00:00
725	2	25	567	29	2024-06-13 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-06-12 00:00:00+00	12:00:00
895	2	32	615	34	2024-07-05 04:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-01 00:00:00+00	12:00:00
1875	\N	\N	1423	6	\N	sourced	\N	\N	\N	\N	0	\N	0	\N	\N	\N	\N	2024-12-10 00:00:00+00	00:00:00
961	2	34	726	48	2024-07-08 06:30:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-05 00:00:00+00	12:00:00
1698	2	9	1288	33	2024-11-14 06:00:00+00	on-hold	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
981	1	11	743	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-08 00:00:00+00	12:00:00
1049	2	11	778	47	2024-07-24 06:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-12 00:00:00+00	12:00:00
1059	2	22	800	39	2024-07-24 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-16 00:00:00+00	12:00:00
1115	2	19	841	25	2024-07-23 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1124	2	18	849	13	2024-07-29 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-23 00:00:00+00	12:00:00
1133	2	25	857	29	2024-07-29 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-25 00:00:00+00	12:00:00
1143	2	41	864	26	2024-07-28 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-24 00:00:00+00	12:00:00
1185	2	19	896	25	2024-07-31 22:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1195	1	33	905	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-30 00:00:00+00	12:00:00
1203	3	16	863	22	2024-08-01 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-07-31 00:00:00+00	12:00:00
1212	2	23	918	28	2024-09-04 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1222	2	28	928	32	2024-09-02 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-02 00:00:00+00	12:00:00
1230	2	18	936	13	2024-09-09 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-03 00:00:00+00	12:00:00
1289	5	8	957	33	2024-09-26 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1298	2	18	994	13	2024-09-26 22:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-09-24 00:00:00+00	12:00:00
1393	2	21	1067	56	2024-10-06 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-10-04 00:00:00+00	12:00:00
972	2	23	735	28	2024-07-09 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-08 00:00:00+00	12:00:00
1708	1	38	1295	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-11 00:00:00+00	12:00:00
1808	1	3	1375	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1869	2	21	1417	34	2024-11-21 01:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1815	2	45	1324	22	2024-11-17 23:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1842	2	27	1398	51	2024-11-19 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1817	2	14	1380	59	2024-11-20 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1810	2	24	1377	14	2024-11-18 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1819	2	24	1381	65	2024-11-21 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1820	2	33	1382	48	2024-11-21 05:00:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1822	2	35	1384	64	2024-11-19 19:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1825	2	9	1385	33	2024-11-19 06:45:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1827	2	21	1387	56	2024-11-18 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1828	2	23	1388	28	2024-11-21 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1829	2	27	1389	51	2024-11-18 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1830	2	27	1390	51	2024-11-19 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1831	6	16	815	21	2024-11-18 23:15:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1832	2	19	1391	25	2024-11-18 23:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1833	2	29	1392	39	2024-11-19 05:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1835	1	17	1394	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1836	2	33	1395	48	2024-11-21 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1837	2	23	1396	28	2024-11-20 01:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1838	2	21	1397	56	2024-11-20 00:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1816	2	27	1379	51	2024-11-18 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1843	2	41	1399	26	2024-11-19 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1844	2	19	1400	26	2024-11-19 23:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1845	2	21	1401	57	2024-11-21 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1847	2	31	1403	51	2024-11-26 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1850	3	19	1325	26	2024-11-21 22:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1851	2	35	1405	64	2024-11-18 19:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1852	2	35	1406	64	2024-11-19 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1855	2	21	1409	56	2024-11-20 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1856	2	19	1410	32	2024-11-20 20:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1858	2	22	1411	39	2024-11-22 05:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1859	2	38	1412	34	2024-11-25 04:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1861	3	33	1362	22	2024-11-22 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1862	2	29	1414	39	2024-11-25 05:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1863	2	22	1415	27	2024-11-25 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1866	2	14	1416	59	2024-11-27 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1818	2	38	1296	34	2024-11-19 05:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1870	2	31	1418	51	2024-11-20 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1871	2	22	1419	39	2024-11-21 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1872	2	22	1420	39	2024-11-20 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1874	2	13	1422	68	2024-11-21 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1717	2	13	1303	59	2024-11-25 06:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-12 00:00:00+00	12:00:00
1807	3	27	1336	38	2024-11-17 21:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1809	2	14	1376	59	2024-11-21 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-15 00:00:00+00	12:00:00
1824	3	33	1290	22	2024-11-25 06:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N	2025-11-18 00:00:00+00	12:00:00
1834	2	27	1393	51	2024-11-18 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-18 00:00:00+00	12:00:00
1860	2	34	1413	48	2024-11-25 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1846	2	2	1402	66	2024-11-19 05:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1873	2	40	1421	26	2024-11-21 23:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N	2024-11-19 00:00:00+00	12:00:00
1876	\N	\N	1424	6	\N	sourced	\N	\N	\N	\N	0	\N	0	\N	\N	\N	\N	2024-12-10 00:00:00+00	00:00:00
\.


--
-- Data for Name: reqServiceSequencesAcitves; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqServiceSequencesAcitves" ("serviceActiveId", "serviceId", "serviceStation", "serviceServiceRequst", "serviceCandidate", "serviceAssignee", "serviceDate", "serviceStatus", "serviceServiceId", "serviceScheduledBy", "previousCurrentStation", "resonSwitchStation", "interviewCount", "interviewRescheduled", "interviewRescheduledCount", "interviewMode", "interviewLocation", "interviewMail", "interviewMailType") FROM stdin;
2	2	2	24	2	14	2024-04-08 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
3	3	2	25	3	15	2024-04-03 23:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
5	5	2	2	5	17	2024-04-02 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
6	6	2	10	6	18	2024-04-05 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
9	9	2	13	9	19	2024-04-05 05:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
10	10	2	46	10	20	2024-04-03 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
11	11	2	21	11	16	2024-04-02 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
12	12	2	21	12	16	2024-04-02 23:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
13	13	2	35	13	13	2024-04-01 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
14	14	6	38	14	21	2024-04-01 23:30:00+00	on-hold	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
16	16	2	6	16	23	2024-04-03 06:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
17	17	2	13	17	19	2024-04-04 06:00:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
18	18	2	13	18	19	2024-04-05 06:00:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
19	19	2	35	19	13	2024-04-03 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
20	20	2	8	20	24	2024-04-07 20:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
21	21	2	18	21	13	2024-04-03 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
22	22	2	25	22	15	2024-04-02 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
23	23	2	19	23	25	2024-04-08 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1	1	2	18	1	13	2024-04-08 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
25	25	2	22	25	27	2024-04-07 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
26	26	2	18	26	13	2024-04-08 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
27	27	2	24	27	14	2024-04-10 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
28	28	2	38	28	16	2024-04-08 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
29	29	1	23	29	\N	2024-11-21 21:09:33+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
30	30	2	10	30	18	2024-04-07 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
31	31	2	10	31	18	2024-04-03 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
32	32	2	19	32	25	2024-04-10 23:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
33	33	2	10	33	18	2024-04-08 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
7	34	2	13	7	19	2024-04-05 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
34	35	2	18	34	13	2024-04-10 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
35	36	2	24	35	14	2024-04-08 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
36	37	2	38	36	16	2024-04-11 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
37	38	1	28	37	\N	2024-11-21 21:09:33+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1075	1213	2	24	919	14	2024-09-02 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
39	40	2	2	39	17	2024-04-03 21:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
40	41	2	2	40	17	2024-04-08 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
41	42	1	46	41	\N	2024-11-21 21:09:33+00	sourced	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
42	43	1	9	42	\N	2024-11-21 21:09:33+00	sourced	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
43	44	1	9	43	\N	2024-11-21 21:09:33+00	sourced	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
44	45	2	18	44	13	2024-04-11 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
45	46	2	24	45	14	2024-04-14 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
46	47	2	38	46	16	2024-04-11 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
47	48	2	2	37	17	2024-04-08 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
48	49	2	2	47	17	2024-04-10 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
49	50	2	2	48	17	2024-04-08 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
50	51	2	10	49	18	2024-04-10 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
51	52	2	23	50	28	2024-04-07 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
52	53	2	25	51	29	2024-04-11 21:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
4	54	2	38	4	16	2024-04-10 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
53	55	1	2	52	\N	2024-11-21 21:09:33+00	sourced	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
54	56	2	13	53	19	2024-04-11 05:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
55	57	2	10	54	18	2024-04-09 06:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
56	58	2	10	55	18	2024-04-10 06:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
57	59	1	9	56	\N	2024-11-21 21:09:33+00	sourced	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
58	60	3	2	39	30	2024-04-08 21:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
8	61	2	13	8	19	2024-04-08 05:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
59	62	2	18	57	13	2024-04-14 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
60	63	2	24	58	14	2024-04-15 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
61	64	2	25	59	15	2024-04-07 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
62	65	3	25	3	29	2024-04-07 23:00:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
63	66	2	22	60	27	2024-04-10 21:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
64	67	2	22	61	27	2024-04-11 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
65	68	2	23	62	28	2024-04-11 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
66	69	2	18	63	13	2024-04-10 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
67	70	2	18	64	13	2024-04-11 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
68	71	2	21	65	16	2024-04-10 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
69	72	2	21	66	16	2024-04-11 22:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
70	73	6	6	67	21	2024-04-07 20:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
71	74	6	6	68	21	2024-04-09 06:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
72	75	2	18	69	13	2024-04-10 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
73	76	2	18	70	13	2024-04-10 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
74	77	2	24	71	14	2024-04-15 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
75	78	2	25	72	15	2024-04-07 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
77	80	2	2	74	17	2024-04-16 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
78	81	2	10	75	18	2024-04-15 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
79	82	2	19	76	32	2024-04-11 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
80	83	2	13	77	19	2024-04-11 05:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
84	87	5	9	43	33	2024-04-09 06:00:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
85	88	5	9	56	33	2024-04-09 06:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
86	89	2	18	81	13	2024-04-14 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
87	90	2	24	82	14	2024-04-16 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
88	91	1	25	83	\N	2024-11-21 21:09:33+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
89	92	2	35	84	13	2024-04-11 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
90	93	2	35	85	13	2024-04-11 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
91	94	2	46	86	20	2024-04-15 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
92	95	2	24	87	14	2024-04-15 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
94	97	2	21	89	16	2024-04-17 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
81	99	2	21	78	16	2024-04-16 23:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
1663	1875	\N	\N	1423	6	\N	sourced	\N	\N	\N	\N	0	\N	0	\N	\N	\N	\N
97	101	2	10	92	18	2024-04-11 21:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
99	103	2	10	94	18	2024-04-17 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
100	104	2	2	95	17	2024-04-15 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
101	105	2	18	96	13	2024-04-15 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
102	106	2	38	97	16	2024-04-17 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
103	107	2	18	98	13	2024-04-15 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
104	108	2	35	99	13	2024-04-15 22:00:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
105	109	2	32	100	16	2024-04-15 23:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
106	110	2	39	101	26	2024-04-14 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
82	111	2	23	79	28	2024-04-11 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
107	112	2	18	102	13	2024-04-15 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
108	113	2	38	103	16	2024-04-16 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
109	114	1	23	104	\N	2024-11-21 21:09:33+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
96	116	2	14	91	19	2024-04-16 06:00:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
111	119	2	35	106	13	2024-04-16 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
112	120	2	10	107	18	2024-04-16 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
113	121	2	19	108	25	2024-04-18 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
114	122	2	38	109	16	2024-04-18 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
115	123	2	28	110	32	2024-04-16 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
116	124	2	25	111	29	2024-04-17 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
117	125	3	38	4	34	2024-04-16 04:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
93	126	2	2	88	17	2024-04-16 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
118	127	2	13	112	19	2024-04-17 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
119	128	2	13	113	19	2024-04-17 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
15	130	3	10	15	22	2024-04-18 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
121	131	3	13	115	19	2024-04-17 05:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
122	132	2	23	116	28	2024-04-15 22:00:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
123	133	2	18	117	13	2024-04-16 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
124	134	2	38	118	16	2024-04-16 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
125	135	3	10	92	22	2024-04-16 06:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
95	136	2	13	90	19	2024-04-18 05:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
83	138	2	10	80	18	2024-04-16 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
126	139	2	18	119	13	2024-04-17 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
127	140	2	18	120	13	2024-04-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
128	141	2	21	121	16	2024-04-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
129	142	2	25	122	29	2024-04-16 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
130	143	2	23	29	28	2024-04-17 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
131	144	2	35	123	13	2024-04-16 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
132	145	2	37	124	26	2024-04-16 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
133	146	2	21	125	16	2024-04-21 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
134	147	1	25	126	\N	2024-11-21 21:09:33+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
135	148	2	13	127	19	2024-04-22 05:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
136	149	2	13	128	19	2024-04-19 05:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
137	150	2	13	129	19	2024-04-19 06:00:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
138	151	2	35	130	13	2024-04-17 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
139	152	2	10	131	18	2024-04-17 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
140	153	3	10	107	22	2024-04-17 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
110	154	2	25	105	35	2024-04-17 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
141	155	2	18	132	13	2024-04-21 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
142	156	2	21	133	16	2024-04-21 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
144	158	2	28	135	26	2024-04-18 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
145	159	2	23	136	28	2024-04-18 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
146	160	2	14	137	19	2024-04-19 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
147	161	2	10	138	18	2024-04-19 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
148	162	2	25	139	29	2024-04-21 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
149	163	2	35	140	13	2024-04-21 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
152	166	2	23	143	28	2024-04-18 21:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
153	167	2	13	144	19	2024-04-19 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
154	168	6	25	51	21	2024-04-16 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
155	169	2	14	145	19	2024-04-22 05:30:00+00	on-hold	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
156	170	3	13	146	19	2024-04-18 06:00:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
158	172	2	43	148	26	2024-04-17 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
159	173	2	18	149	13	2024-04-24 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
161	175	2	24	151	14	2024-04-23 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
162	176	2	35	152	13	2024-04-24 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
163	177	2	2	153	17	2024-04-22 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
164	178	2	35	154	13	2024-04-22 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
165	179	2	14	155	19	2024-04-24 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
166	180	2	10	156	18	2024-04-22 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
167	181	2	19	157	32	2024-04-21 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
168	182	2	19	158	25	2024-04-24 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
169	183	2	25	159	29	2024-04-24 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
170	184	2	21	160	16	2024-04-22 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
171	185	2	21	161	16	2024-04-24 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
98	186	2	10	93	18	2024-04-18 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
172	187	2	18	162	13	2024-04-22 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
173	188	2	22	163	37	2024-04-18 23:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
174	189	2	24	164	14	2024-04-21 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
175	190	2	10	165	18	2024-04-21 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
176	191	3	35	106	26	2024-04-21 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
177	192	2	21	166	16	2024-04-22 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
178	193	2	18	167	13	2024-04-22 23:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
179	194	2	18	168	13	2024-04-22 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
180	195	2	42	169	29	2024-04-23 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
181	196	2	18	170	13	2024-04-28 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
183	198	2	35	172	13	2024-04-24 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
184	199	2	2	173	17	2024-04-21 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
76	200	2	2	73	17	2024-04-22 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1664	1876	\N	\N	1424	6	\N	sourced	\N	\N	\N	\N	0	\N	0	\N	\N	\N	\N
188	204	2	8	177	24	2024-04-21 20:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
189	205	2	10	178	18	2024-04-22 21:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
190	206	2	3	179	38	2024-04-22 21:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
191	207	3	23	116	38	2024-04-21 22:00:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
157	209	2	19	147	32	2024-04-22 23:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
192	210	2	13	180	19	2024-04-24 05:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
193	211	2	8	181	24	2024-04-23 20:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
194	212	2	35	182	13	2024-04-23 20:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
195	213	2	24	183	14	2024-04-23 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
196	214	2	25	184	29	2024-04-24 00:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
197	215	2	19	185	25	2024-04-24 23:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
150	216	2	6	141	23	2024-04-23 06:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
151	217	2	6	142	23	2024-04-24 06:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
198	218	1	21	186	\N	2024-11-21 21:09:33+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
199	219	2	22	187	27	2024-04-24 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
200	220	2	18	188	13	2024-04-28 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
202	222	2	23	190	28	2024-04-24 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
203	223	2	18	191	13	2024-04-28 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
205	225	2	28	193	39	2024-04-29 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
206	226	2	21	194	16	2024-04-28 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
207	227	2	35	195	13	2024-04-28 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
208	228	2	24	196	14	2024-04-28 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
209	229	2	28	197	26	2024-04-28 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
210	230	2	25	198	29	2024-04-29 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
143	231	2	25	134	29	2024-04-17 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
211	232	5	13	146	33	2024-04-23 06:00:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
212	233	2	18	199	13	2024-04-29 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
213	234	2	18	200	13	2024-04-29 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
214	235	2	23	201	28	2024-04-28 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
215	236	2	6	202	23	2024-04-25 05:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
216	237	2	13	203	19	2024-04-25 00:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
217	239	3	10	93	22	2024-04-23 21:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
219	241	2	18	204	13	2024-04-24 20:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
220	242	2	23	205	28	2024-04-24 20:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
221	243	2	37	206	26	2024-04-24 22:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
222	244	2	25	207	29	2024-04-24 21:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
223	245	2	18	208	13	2024-04-29 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
224	246	2	21	209	16	2024-04-29 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
225	247	2	23	210	28	2024-04-28 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
226	248	1	\N	211	\N	2024-11-21 21:09:33+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
230	252	1	47	215	\N	2024-11-21 21:09:33+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
231	254	2	35	216	13	2024-04-28 20:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
120	255	2	19	114	26	2024-04-24 22:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
232	256	2	19	217	26	2024-04-28 22:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
234	258	1	\N	219	\N	2024-11-21 21:09:33+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
235	259	1	\N	220	\N	2024-11-21 21:09:33+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
38	261	2	2	38	17	2024-04-28 22:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
187	262	2	2	176	17	2024-04-29 21:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
237	263	2	18	221	13	2024-05-02 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
160	264	2	21	150	16	2024-05-01 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
239	266	2	38	223	16	2024-05-02 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
201	267	2	25	189	29	2024-04-29 06:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
240	268	2	18	224	13	2024-04-29 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
241	269	2	19	225	25	2024-04-29 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
218	270	3	2	173	30	2024-04-28 21:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
243	272	2	10	227	18	2024-05-01 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
244	273	1	47	228	\N	2024-11-21 21:09:33+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
247	277	2	21	229	16	2024-04-29 22:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
248	278	2	21	230	16	2024-04-29 23:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
250	280	2	22	232	37	2024-04-29 21:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
251	281	6	6	16	21	2024-04-28 23:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
236	283	3	19	147	26	2024-04-29 23:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
252	284	2	18	233	13	2024-05-02 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
253	285	2	21	234	16	2024-05-01 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
238	286	2	23	222	28	2024-05-01 21:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
254	287	2	38	235	16	2024-05-02 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
242	289	2	2	226	17	2024-04-29 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
227	290	2	13	212	19	2024-05-01 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
256	291	2	18	237	13	2024-05-01 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
185	292	2	18	174	13	2024-05-01 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
186	293	2	18	175	13	2024-05-02 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
257	294	2	18	238	13	2024-05-01 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
258	295	2	21	239	16	2024-05-02 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
259	296	2	25	240	29	2024-05-02 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
260	297	3	13	112	35	2024-05-01 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
261	298	2	2	241	17	2024-05-02 22:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
262	299	2	25	242	29	2024-05-02 22:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
263	300	2	10	243	18	2024-05-02 21:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
264	301	1	6	244	\N	2024-11-21 21:09:33+00	sourced	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
266	303	3	23	205	38	2024-05-01 20:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
268	306	3	2	38	30	2024-05-02 22:30:00+00	pending	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
269	307	2	13	245	19	2024-05-06 05:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
270	308	2	13	246	19	2024-05-07 05:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
271	309	2	24	247	14	2024-05-05 22:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
272	310	2	24	248	14	2024-05-06 22:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
273	311	2	18	249	13	2024-05-05 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
274	312	2	21	250	16	2024-05-05 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
275	313	2	23	251	28	2024-05-06 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
276	314	2	38	252	16	2024-05-06 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
277	315	1	\N	253	\N	2024-11-21 21:09:33+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
245	316	6	6	141	21	2024-05-02 00:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
246	317	6	6	142	21	2024-04-30 23:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
279	319	2	3	254	38	2024-05-09 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
280	320	1	47	255	\N	2024-11-21 21:09:33+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
281	321	1	47	256	\N	2024-11-21 21:09:33+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
282	322	3	2	226	30	2024-05-02 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
283	323	3	13	203	41	2024-04-30 20:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
284	324	2	18	257	13	2024-05-06 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
285	325	1	37	258	\N	2024-11-21 21:09:33+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
286	326	2	21	259	16	2024-05-05 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
287	327	2	21	260	16	2024-05-06 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
288	328	2	18	261	13	2024-05-06 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
289	329	2	18	262	13	2024-05-05 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
290	330	2	38	263	16	2024-05-06 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
291	331	2	22	264	39	2024-05-08 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
292	332	3	6	202	21	2024-05-01 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
293	333	2	19	265	25	2024-05-09 23:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
228	334	2	19	213	32	2024-05-02 23:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
296	337	5	13	203	33	2024-05-03 06:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
233	338	2	22	218	39	2024-05-03 05:00:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
249	339	2	38	231	16	2024-05-05 23:30:00+00	back-off	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
297	340	2	28	267	32	2024-05-09 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
298	341	2	38	268	16	2024-05-07 06:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
300	343	2	18	270	13	2024-05-07 22:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
301	344	2	25	271	29	2024-05-07 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
303	346	2	18	273	13	2024-05-06 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
304	347	2	14	274	19	2024-05-08 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
306	349	2	21	275	16	2024-05-08 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
307	350	2	22	276	39	2024-05-07 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
308	351	2	38	277	16	2024-05-08 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
309	352	3	23	222	38	2024-05-02 21:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
310	353	2	19	278	25	2024-05-10 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
312	355	3	2	280	30	2024-05-08 22:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
313	356	2	18	281	13	2024-05-07 23:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
315	358	5	19	147	33	2024-05-05 20:30:00+00	on-hold	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
267	359	6	3	179	21	2024-05-07 00:00:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
316	360	2	2	282	42	2024-05-08 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
317	361	2	18	283	13	2024-05-09 07:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
255	362	2	38	236	16	2024-05-07 21:00:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
229	363	2	22	214	27	2024-05-06 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
314	364	5	23	205	33	2024-05-09 06:00:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
318	365	2	18	284	13	2024-05-09 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
319	366	2	21	285	16	2024-05-14 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
320	367	2	24	286	14	2024-05-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
321	368	1	8	287	\N	2024-11-21 21:09:34+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
322	369	5	23	222	33	2024-05-08 20:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
323	370	2	21	288	16	2024-05-16 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
324	371	2	8	289	24	2024-05-13 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
325	372	2	35	290	13	2024-05-08 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
326	373	2	14	291	19	2024-05-09 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
327	374	2	25	292	29	2024-05-07 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
328	375	2	19	293	25	2024-05-12 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
329	376	2	22	294	27	2024-05-12 21:00:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
330	377	2	21	295	16	2024-05-13 21:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
331	378	3	19	213	26	2024-05-07 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
265	379	3	21	78	34	2024-05-08 04:30:00+00	rejected	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
332	380	2	18	296	13	2024-05-12 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
333	381	2	22	297	39	2024-05-14 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
334	382	2	42	298	29	2024-05-12 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
335	383	2	22	299	39	2024-05-16 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
336	384	2	35	300	13	2024-05-08 23:00:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
337	385	2	19	301	32	2024-05-08 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
338	386	2	22	302	39	2024-05-10 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
339	387	2	21	303	16	2024-05-09 22:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
340	388	2	25	304	29	2024-05-12 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
341	389	2	21	305	16	2024-05-12 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
342	390	2	19	306	32	2024-05-12 20:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
343	391	2	37	258	26	2024-05-09 22:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
344	392	2	18	307	13	2024-05-12 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
345	393	2	21	308	16	2024-05-13 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
346	394	2	42	309	29	2024-05-14 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
347	395	2	23	310	28	2024-05-14 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
182	396	2	2	171	42	2024-05-12 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
348	397	2	37	311	26	2024-05-12 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
351	400	2	13	313	19	2024-05-21 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
352	401	1	11	314	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
353	402	2	13	315	19	2024-05-14 00:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
355	404	2	10	317	18	2024-05-13 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
311	405	2	23	279	28	2024-05-14 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
356	406	1	11	318	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
357	407	1	11	319	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
359	409	2	21	320	16	2024-05-15 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
360	410	2	25	321	29	2024-05-19 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
361	411	2	23	322	28	2024-05-15 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
362	412	2	6	323	23	2024-05-13 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
363	413	2	18	324	13	2024-05-13 22:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
364	414	1	11	325	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
365	415	1	11	326	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
302	416	2	19	272	32	2024-05-12 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
204	417	2	18	192	13	2024-05-12 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
295	419	2	10	266	18	2024-05-14 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
349	420	3	22	214	26	2024-05-13 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
367	421	2	38	328	16	2024-05-14 22:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
368	422	2	38	329	16	2024-05-15 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
370	424	3	18	281	26	2024-05-12 23:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
369	425	5	2	38	33	2024-05-13 20:30:00+00	done	\N	2	\N	\N	0	\N	0	\N	\N	\N	\N
371	426	2	2	330	42	2024-05-15 23:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
372	427	1	19	331	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
376	431	2	25	126	29	2024-05-13 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
377	432	2	18	334	13	2024-05-15 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
378	433	2	21	335	16	2024-05-19 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
379	434	2	22	336	39	2024-05-20 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
380	435	5	6	202	33	2024-05-13 06:00:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
383	438	2	21	339	16	2024-05-20 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
384	439	2	25	340	29	2024-05-14 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
350	440	2	35	312	13	2024-05-14 00:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
385	442	\N	19	272	\N	2024-11-21 21:09:34+00	null	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
386	443	2	18	341	13	2024-05-20 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
387	444	2	8	342	43	2024-05-19 20:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
388	445	2	23	343	28	2024-05-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
389	446	2	22	344	39	2024-05-21 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
390	447	2	25	345	29	2024-05-15 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
391	448	2	14	346	19	2024-05-17 06:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
382	450	2	13	338	19	2024-05-14 22:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
299	451	2	14	269	19	2024-05-15 20:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
394	453	1	11	349	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
395	454	2	18	350	13	2024-05-30 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
397	457	5	18	281	33	2024-05-15 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
398	458	2	8	352	43	2024-05-16 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
400	460	2	18	354	13	2024-05-16 23:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
401	461	2	18	355	13	2024-05-20 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
402	462	2	39	356	39	2024-05-24 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
404	464	2	25	357	29	2024-05-21 01:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
405	465	2	18	358	13	2024-05-19 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
406	466	2	13	359	19	2024-05-20 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
24	467	3	19	24	26	2024-05-16 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
366	469	2	2	327	42	2024-05-23 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
408	470	2	18	360	13	2024-05-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
410	472	2	25	362	29	2024-05-21 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
411	473	1	11	363	\N	2024-11-21 21:09:34+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
412	474	2	22	364	39	2024-05-22 05:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
413	475	2	18	365	13	2024-05-19 23:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
414	476	2	18	366	13	2024-05-27 23:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
416	478	2	37	368	26	2024-05-20 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
417	479	2	25	369	29	2024-05-23 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
419	481	2	35	371	13	2024-05-23 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
396	484	2	28	351	26	2024-05-20 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
421	486	2	2	373	42	2024-05-20 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
422	487	2	24	374	14	2024-05-19 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
423	488	2	24	375	14	2024-05-20 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
424	489	2	19	376	32	2024-05-20 20:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
425	490	2	38	377	16	2024-05-20 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
426	491	2	38	378	16	2024-05-26 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
427	492	2	21	379	16	2024-05-28 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
375	494	2	8	333	44	2024-05-21 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
429	495	2	8	381	44	2024-05-22 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
354	496	2	28	316	26	2024-05-20 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
373	497	3	19	265	26	2024-05-21 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
403	498	6	2	38	21	2024-05-20 23:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
430	499	3	2	330	30	2024-05-19 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
431	500	2	21	382	16	2024-05-24 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
432	501	2	18	383	13	2024-05-23 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
433	502	2	13	384	19	2024-05-27 22:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
434	503	2	18	385	13	2024-05-26 22:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
435	504	2	18	386	13	2024-05-21 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
436	505	2	21	387	16	2024-05-22 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
437	506	2	2	388	42	2024-05-22 00:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
439	508	2	23	389	28	2024-05-26 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
440	509	2	25	390	29	2024-05-21 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
393	510	2	8	348	44	2024-05-23 05:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
441	511	2	38	391	16	2024-05-26 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
443	513	2	24	393	14	2024-05-22 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
444	514	2	21	394	16	2024-05-24 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
445	515	2	8	395	43	2024-05-27 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
446	516	3	21	339	34	2024-05-24 04:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
447	517	2	18	396	13	2024-05-27 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
448	518	2	2	397	42	2024-05-23 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
449	519	2	23	398	28	2024-05-21 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
450	520	2	25	399	29	2024-05-26 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
451	521	2	2	400	42	2024-05-27 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
452	522	2	21	401	16	2024-06-02 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
453	523	2	8	402	24	2024-05-27 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
418	524	2	42	370	29	2024-05-22 21:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
428	525	2	25	380	29	2024-05-24 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
454	526	2	35	403	13	2024-05-27 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
455	527	2	13	404	19	2024-05-27 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
456	528	2	10	405	18	2024-05-22 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
457	529	5	18	312	33	2024-05-23 06:00:00+00	on-hold	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
458	530	5	18	365	33	2024-05-23 06:45:00+00	on-hold	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
459	531	2	25	406	29	2024-05-26 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
409	532	2	8	361	43	2024-05-27 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
460	533	2	22	407	27	2024-05-27 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
462	536	2	21	409	16	2024-05-27 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
442	538	2	21	392	16	2024-05-28 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
464	539	2	23	411	28	2024-05-27 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
465	540	2	2	412	42	2024-05-23 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
467	542	2	18	414	13	2024-05-27 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
470	545	2	8	415	24	2024-05-28 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
471	546	2	21	416	16	2024-05-28 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
472	547	2	13	417	19	2024-05-29 00:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
473	548	\N	35	418	\N	2024-11-21 21:09:34+00	null	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
474	549	2	18	419	13	2024-05-27 22:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
476	551	2	23	421	28	2024-05-26 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
477	552	2	29	422	26	2024-05-29 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
478	553	2	21	423	16	2024-05-26 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
480	555	2	14	424	19	2024-05-30 00:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
481	556	2	19	425	25	2024-06-03 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
482	558	2	19	426	25	2024-05-31 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
374	559	2	8	332	24	2024-05-27 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
483	560	3	2	373	30	2024-05-26 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
484	561	1	44	427	\N	2024-11-21 21:09:34+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
485	562	1	44	428	\N	2024-11-21 21:09:34+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
486	563	2	14	429	19	2024-05-31 00:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
487	564	2	25	430	29	2024-05-30 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
488	565	2	18	431	13	2024-05-30 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
475	566	2	38	420	16	2024-06-03 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
489	567	2	23	432	28	2024-05-30 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
490	568	2	8	433	24	2024-05-29 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
491	569	2	25	434	29	2024-06-02 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
492	570	2	19	435	25	2024-05-30 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
493	571	2	23	436	28	2024-05-30 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
494	572	2	18	437	13	2024-06-02 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
461	573	2	22	408	45	2024-06-02 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
495	574	2	18	438	13	2024-06-03 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
496	575	2	24	439	14	2024-05-30 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
497	576	2	21	440	16	2024-06-02 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
498	577	2	8	441	24	2024-06-06 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
500	579	2	28	442	32	2024-06-02 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
501	580	2	21	443	16	2024-06-04 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
502	581	2	25	444	29	2024-06-02 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
503	582	2	8	445	24	2024-06-05 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
504	583	2	22	446	45	2024-06-03 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
505	584	2	29	447	26	2024-06-02 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
506	585	2	24	448	14	2024-06-06 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
507	586	2	23	449	28	2024-06-05 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
508	587	2	18	450	13	2024-06-05 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
509	588	2	8	451	24	2024-06-02 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
466	589	2	18	413	13	2024-06-02 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
463	590	2	21	410	16	2024-06-09 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
420	591	2	19	372	25	2024-06-03 00:00:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
510	592	2	2	452	42	2024-05-30 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
512	594	2	21	454	16	2024-05-30 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
513	595	2	21	455	16	2024-06-02 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
514	596	2	37	456	26	2024-06-02 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
392	597	2	19	347	32	2024-06-09 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
515	598	3	8	415	22	2024-05-30 07:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
415	599	2	21	367	16	2024-05-31 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
399	600	2	8	353	24	2024-06-03 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
381	601	2	35	337	13	2024-06-03 00:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
516	602	2	18	457	13	2024-06-03 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
511	603	2	2	453	42	2024-05-30 23:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
517	604	2	42	458	29	2024-06-03 22:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
518	605	2	22	459	45	2024-06-04 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
519	606	2	24	460	14	2024-05-29 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
521	608	2	22	461	45	2024-06-05 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
522	609	2	22	462	45	2024-06-11 06:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
524	611	2	23	463	28	2024-06-06 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
525	612	2	25	464	29	2024-06-02 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
526	613	2	21	465	16	2024-06-05 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
527	614	2	25	466	29	2024-06-03 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
528	615	2	38	467	16	2024-06-04 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
529	616	2	18	468	13	2024-06-04 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
530	617	2	21	469	16	2024-06-04 20:30:00+00	on-hold	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
531	618	3	10	405	22	2024-06-05 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
532	619	2	23	470	28	2024-06-03 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
533	620	2	18	471	13	2024-06-06 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
534	621	2	2	472	42	2024-06-07 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
535	622	2	38	473	16	2024-06-07 22:00:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
537	624	2	25	475	29	2024-06-12 22:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
538	625	2	22	476	45	2024-06-04 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
539	626	2	22	477	45	2024-06-10 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
592	682	2	2	529	42	2024-06-10 00:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
540	627	2	21	478	16	2024-06-02 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
541	628	2	25	479	14	2024-06-23 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
559	646	2	18	496	13	2024-06-02 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
571	660	3	2	508	30	2024-06-09 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
542	629	2	22	480	45	2024-06-07 05:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
550	637	2	8	488	24	2024-06-04 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
543	630	2	21	481	16	2024-06-06 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
544	631	2	21	482	16	2024-06-05 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
545	632	2	8	483	24	2024-06-06 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
546	633	2	13	484	19	2024-06-07 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
547	634	2	13	485	19	2024-06-06 00:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
548	635	2	22	486	45	2024-06-05 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
549	636	2	21	487	16	2024-06-06 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
568	656	2	28	505	32	2024-06-27 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
569	657	2	21	506	16	2024-06-06 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
572	661	2	35	509	13	2024-06-11 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
597	689	2	18	534	13	2024-06-20 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
558	645	2	23	495	28	2024-06-05 21:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
560	647	2	38	497	16	2024-06-09 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
561	648	2	25	498	14	2024-06-10 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
562	649	2	29	499	\N	2024-11-21 21:09:34+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
563	650	2	6	500	23	2024-06-06 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
564	651	2	6	501	23	2024-06-07 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
565	652	2	18	502	13	2024-06-05 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
566	653	2	21	503	16	2024-06-06 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
594	685	1	11	531	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
595	686	2	11	532	47	2024-06-10 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
570	658	2	21	507	16	2024-06-11 01:00:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
552	639	3	22	476	26	2024-06-04 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
596	688	2	18	533	13	2024-06-13 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
573	662	2	23	510	28	2024-06-10 22:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
574	663	2	28	511	26	2024-06-11 22:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
575	664	2	18	512	13	2024-06-09 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
576	665	2	6	513	23	2024-06-13 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
577	666	2	25	514	29	2024-06-10 22:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
578	667	2	8	515	24	2024-06-09 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
579	668	2	42	516	29	2024-06-06 22:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
581	670	2	8	518	\N	2024-11-21 21:09:34+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
582	671	2	8	519	24	2024-06-13 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
584	673	2	21	521	16	2024-06-17 00:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
585	674	2	18	522	13	2024-06-09 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
586	675	2	23	523	28	2024-06-10 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
587	676	2	35	524	13	2024-06-11 23:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
588	677	3	21	525	34	2024-06-17 00:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
589	678	2	35	526	13	2024-06-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
590	679	2	38	527	16	2024-06-19 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
591	680	2	24	528	14	2024-06-13 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
555	642	2	28	492	32	2024-06-06 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
557	644	2	13	494	19	2024-06-06 06:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
551	638	3	2	489	30	2024-06-04 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
553	640	2	25	490	29	2024-06-04 22:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
554	641	2	19	491	25	2024-06-05 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
598	690	2	22	535	45	2024-06-10 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
599	691	2	2	536	42	2024-06-10 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
600	692	1	11	537	\N	2024-11-21 21:09:34+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
601	693	1	11	538	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
602	694	1	11	539	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
603	695	2	28	540	32	2024-06-11 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
604	696	2	13	541	19	2024-06-11 00:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
605	697	2	2	542	42	2024-06-11 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
606	698	2	2	543	42	2024-06-13 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
536	623	2	8	474	43	2024-06-05 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
610	702	2	21	547	16	2024-06-12 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
611	703	2	35	548	13	2024-06-12 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
612	704	2	25	549	29	2024-06-16 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
613	705	1	11	550	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
607	699	2	29	544	26	2024-06-17 23:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
609	701	1	11	546	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
630	723	2	21	565	16	2024-06-12 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
614	706	2	23	551	28	2024-06-10 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
617	709	2	22	554	45	2024-06-13 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
631	724	2	21	566	16	2024-06-17 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
654	754	2	2	585	42	2024-06-17 22:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
618	710	2	23	555	28	2024-06-12 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
640	738	5	25	490	33	2024-06-14 06:45:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
625	718	2	25	560	29	2024-06-12 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
643	741	2	25	576	29	2024-06-13 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
644	742	2	24	577	14	2024-06-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
632	725	2	25	567	29	2024-06-13 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
668	770	2	28	599	26	2024-06-19 23:00:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
619	711	5	22	476	33	2024-06-12 06:45:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
656	756	2	18	587	13	2024-06-19 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
620	713	2	21	556	16	2024-06-18 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
634	727	2	18	569	13	2024-06-18 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
658	758	2	28	589	45	2024-06-18 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
622	715	2	19	558	25	2024-06-30 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
687	791	1	11	614	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
628	721	2	18	563	13	2024-06-13 21:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
645	743	3	2	536	30	2024-06-19 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
629	722	2	18	564	13	2024-06-18 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
633	726	2	23	568	28	2024-06-17 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
688	792	1	32	615	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
635	728	2	8	570	24	2024-06-17 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
636	729	2	23	571	28	2024-06-17 21:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
669	771	2	23	600	28	2024-06-18 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
637	730	2	11	572	47	2024-06-16 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
646	744	2	11	578	47	2024-06-20 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
671	773	1	26	602	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
652	751	2	22	583	27	2024-06-17 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
615	707	2	18	552	13	2024-06-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
647	745	2	11	579	47	2024-06-14 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
648	746	3	21	547	34	2024-06-19 04:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
583	672	2	21	520	16	2024-06-13 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
649	748	1	32	580	\N	2024-11-21 21:09:34+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
650	749	1	32	581	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
616	708	2	38	553	16	2024-06-13 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
653	752	1	3	584	\N	2024-11-21 21:09:34+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
556	643	2	21	493	16	2024-06-10 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
657	757	2	18	588	13	2024-06-18 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
580	669	2	23	517	28	2024-06-09 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
659	759	2	21	590	16	2024-06-20 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
660	760	2	25	591	29	2024-06-20 23:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
661	761	2	23	592	28	2024-06-18 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
662	762	1	32	593	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
663	763	1	31	594	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
664	764	2	43	595	26	2024-06-19 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
665	765	2	2	596	42	2024-06-19 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
638	732	3	2	529	30	2024-06-16 23:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
666	768	2	11	597	48	2024-06-18 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
667	769	2	29	598	26	2024-06-18 23:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
593	684	2	20	530	46	2024-06-11 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
608	700	2	29	545	26	2024-06-12 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
670	772	1	26	601	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
672	774	2	18	603	13	2024-06-24 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
673	775	2	22	604	45	2024-06-25 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
674	776	2	32	605	49	2024-06-25 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
675	777	2	23	606	28	2024-06-20 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
676	778	2	22	607	45	2024-06-24 05:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
677	779	2	24	608	50	2024-06-23 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
678	780	2	29	609	39	2024-06-19 04:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
679	781	2	32	610	49	2024-06-25 04:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
680	782	2	31	594	51	2024-06-21 06:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
683	785	2	25	612	29	2024-06-30 22:00:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
621	714	2	23	557	28	2024-06-17 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
684	788	3	8	570	22	2024-06-20 21:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
685	789	3	20	530	22	2024-06-20 07:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
641	739	2	18	574	13	2024-06-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
642	740	2	21	575	16	2024-06-12 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
689	793	1	32	616	\N	2024-11-21 21:09:34+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
624	717	2	11	559	47	2024-06-13 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
639	736	2	21	573	16	2024-06-17 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
623	716	3	21	506	34	2024-06-13 04:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
691	795	2	29	617	39	2024-06-21 04:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
716	823	2	38	633	16	2024-06-19 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
720	828	2	32	593	49	2024-06-26 04:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
698	803	1	21	622	\N	2024-11-21 21:09:34+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
697	802	2	23	621	28	2024-06-24 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
740	852	1	4	650	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
686	790	2	11	613	48	2024-06-24 07:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
692	796	2	23	618	28	2024-06-19 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
693	797	1	32	619	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
695	799	2	26	601	23	2024-06-20 05:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
696	800	2	26	602	23	2024-06-20 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
627	720	2	21	562	16	2024-06-12 23:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
626	719	2	21	561	16	2024-06-20 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
699	804	2	11	623	47	2024-06-24 06:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
700	805	2	23	624	28	2024-06-19 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
701	806	2	32	581	49	2024-06-28 00:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
702	807	3	22	583	26	2024-06-20 22:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
703	808	3	29	609	26	2024-06-20 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
704	809	2	11	538	47	2024-06-21 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
705	810	2	32	620	49	2024-06-24 04:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
706	811	1	26	625	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
707	812	1	26	626	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
708	813	2	35	627	13	2024-06-24 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
709	814	2	2	628	42	2024-06-23 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
710	815	2	32	629	49	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
711	816	2	11	550	47	2024-06-24 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
712	817	2	11	630	48	2024-06-25 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
713	818	1	32	631	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
714	819	3	11	538	22	2024-06-24 07:00:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
651	750	2	21	582	16	2024-06-17 23:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
739	851	1	11	649	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
717	824	1	32	481	\N	2024-11-21 21:09:35+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
718	825	2	11	546	47	2024-06-25 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
728	838	1	26	641	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
729	839	6	31	594	21	2024-06-26 06:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
721	829	5	2	585	33	2024-06-21 07:15:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
722	830	2	18	635	13	2024-06-26 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
723	831	2	11	636	47	2024-06-26 07:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
724	832	2	11	637	47	2024-06-25 06:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
725	833	2	2	638	42	2024-06-25 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
726	834	2	23	639	28	2024-06-26 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
734	845	2	32	645	49	2024-06-28 04:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
736	847	1	4	646	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
690	794	3	2	585	30	2024-06-19 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
730	840	1	11	642	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
731	841	1	26	643	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
732	842	2	18	644	13	2024-06-30 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
682	784	2	2	611	42	2024-06-23 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
719	827	1	32	634	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
737	848	1	30	647	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
738	849	1	30	648	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
655	755	2	22	586	27	2024-06-24 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
727	836	1	11	640	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
741	853	1	3	651	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
742	854	2	18	652	13	2024-06-25 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
743	855	3	29	617	26	2024-06-25 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
744	856	3	2	638	30	2024-06-26 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
745	857	1	4	653	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
746	858	3	11	637	22	2024-06-26 00:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
747	859	3	2	628	30	2024-06-25 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
748	860	2	29	654	39	2024-07-01 05:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
749	861	1	30	655	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
750	862	1	3	656	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
751	863	1	3	657	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
752	864	2	2	658	42	2024-06-27 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
753	865	5	11	659	33	2024-06-27 06:45:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
754	866	3	11	636	22	2024-06-27 07:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
755	867	3	21	562	34	2024-06-27 04:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
756	868	2	11	539	47	2024-07-01 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
757	869	6	21	525	26	2024-06-27 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
758	870	2	38	660	34	2024-07-03 04:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
759	871	6	11	636	52	2024-07-02 21:30:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
760	872	6	11	637	52	2024-07-03 00:00:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
761	873	3	11	550	22	2024-06-28 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
762	874	1	3	661	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
763	875	1	30	662	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
765	877	2	28	664	32	2024-07-04 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
766	878	2	28	665	26	2024-07-01 23:00:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
767	879	1	21	666	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
768	880	2	32	631	49	2024-07-04 04:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
769	881	2	32	667	49	2024-07-05 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
694	798	1	32	620	\N	2024-11-21 21:09:34+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
715	822	2	18	632	13	2024-06-27 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
778	890	2	30	648	53	2024-06-30 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
787	901	1	4	679	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
815	932	2	11	614	47	2024-07-08 06:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
771	883	1	38	669	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
772	884	2	28	670	32	2024-07-01 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
779	891	2	8	675	24	2024-07-02 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
796	911	2	13	688	19	2024-07-08 01:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
827	947	1	3	713	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
817	934	2	18	704	13	2024-07-08 22:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
776	888	1	3	674	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
829	949	2	27	715	51	2024-07-07 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
775	887	1	3	673	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
795	910	2	13	687	19	2024-07-05 06:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
797	912	3	32	610	26	2024-07-03 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
784	897	2	11	649	47	2024-07-02 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
781	894	1	4	676	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
782	895	2	32	615	34	2024-07-05 04:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
733	843	5	21	547	33	2024-06-26 06:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
814	931	3	32	645	26	2024-07-04 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
786	900	1	3	678	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
788	902	2	18	680	13	2024-07-07 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
789	903	2	18	681	13	2024-07-03 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
791	905	1	4	683	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
792	906	2	27	684	51	2024-07-05 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
824	943	1	4	710	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
826	945	1	3	712	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
793	907	2	23	685	28	2024-07-02 22:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
816	933	2	29	703	39	2024-07-08 04:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
847	967	1	4	730	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
800	915	2	13	690	19	2024-07-04 01:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
801	916	2	13	691	19	2024-07-04 01:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
802	917	2	11	692	47	2024-07-02 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
803	918	1	4	693	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
804	919	1	30	694	\N	2024-11-21 21:09:35+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
805	920	2	18	695	13	2024-07-07 22:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
806	921	1	30	696	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
807	922	1	30	697	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
808	923	2	25	698	29	2024-07-09 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
809	924	1	11	699	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
810	925	1	30	700	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
811	926	2	25	701	29	2024-07-07 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
812	927	1	3	702	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
777	889	2	30	647	53	2024-07-01 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
780	893	2	4	672	23	2024-07-03 06:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
794	908	2	23	686	28	2024-07-04 06:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
818	935	2	32	705	49	2024-07-09 03:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
819	936	2	32	706	34	2024-07-07 02:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
820	937	2	25	707	29	2024-07-10 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
821	938	2	29	708	26	2024-07-08 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
823	940	3	23	686	38	2024-07-05 06:00:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
735	846	2	32	634	49	2024-07-04 04:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
770	882	2	18	668	13	2024-06-30 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
825	944	1	23	711	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
773	885	2	24	671	50	2024-07-03 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
774	886	1	4	672	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
828	948	2	27	714	51	2024-07-04 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
830	950	2	13	716	19	2024-07-10 01:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
831	951	2	25	717	29	2024-07-07 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
832	952	3	11	649	22	2024-07-05 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
833	953	2	34	718	48	2024-07-07 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
834	954	1	30	719	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
835	955	1	4	720	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
836	956	2	13	721	19	2024-07-08 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
837	957	2	22	722	45	2024-07-08 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
838	958	2	6	723	23	2024-07-08 06:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
846	966	1	11	729	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
840	960	1	4	725	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
841	961	2	34	726	48	2024-07-08 06:30:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
842	962	3	30	647	54	2024-07-07 20:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
843	963	2	22	727	39	2024-07-09 05:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
844	964	2	12	728	48	2024-07-09 07:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
798	913	3	11	613	22	2024-07-04 07:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
799	914	1	3	689	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
849	969	2	22	732	39	2024-07-11 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
839	959	2	6	724	23	2024-07-09 06:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
785	899	1	3	677	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
878	1000	2	12	757	48	2024-07-10 07:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
783	896	2	32	616	34	2024-07-02 04:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
880	1003	2	27	759	51	2024-07-11 06:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
881	1004	5	20	530	33	2024-07-10 05:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
851	971	1	3	734	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
896	1020	3	29	703	26	2024-07-11 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
853	973	1	38	736	\N	2024-11-21 21:09:35+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
868	988	1	4	748	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
854	974	2	12	737	47	2024-07-09 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
855	975	1	4	738	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
856	976	1	3	739	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
857	977	2	3	702	38	2024-07-07 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
858	978	2	22	740	26	2024-07-10 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
859	979	1	30	741	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
860	980	1	30	742	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
861	981	1	11	743	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
863	983	3	12	737	35	2024-07-09 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
864	984	2	18	744	13	2024-07-11 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
925	1051	2	25	792	29	2024-07-16 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
926	1052	2	32	793	\N	2024-11-21 21:09:35+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
869	989	2	2	749	55	2024-07-09 20:00:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
870	990	1	3	750	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
871	991	2	18	751	13	2024-07-11 21:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
872	992	2	11	752	47	2024-07-11 06:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
873	993	2	11	753	47	2024-07-12 06:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
874	994	2	32	754	49	2024-07-17 03:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
875	995	1	30	755	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
888	1012	1	3	766	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
889	1013	2	38	767	34	2024-07-15 04:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
879	1001	2	35	758	13	2024-07-11 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
848	968	2	29	731	26	2024-07-08 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
850	970	2	11	733	47	2024-07-09 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
882	1005	2	18	760	13	2024-07-15 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
883	1006	2	11	761	47	2024-07-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
884	1007	2	25	762	29	2024-07-14 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
852	972	2	23	735	28	2024-07-09 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
877	999	6	32	610	21	2024-07-10 23:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
876	996	2	19	756	25	2024-07-09 23:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
822	939	2	30	709	53	2024-07-08 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
890	1014	2	27	768	51	2024-07-15 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
891	1015	1	30	769	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
912	1037	2	39	784	26	2024-07-17 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
913	1038	3	33	757	35	2024-07-14 21:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
897	1021	6	2	638	21	2024-07-11 23:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
898	1022	2	18	774	13	2024-07-15 22:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
899	1023	2	11	775	47	2024-07-17 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
900	1024	2	29	776	26	2024-07-17 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
901	1025	2	22	777	45	2024-07-18 06:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
902	1026	1	11	778	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
903	1027	2	21	779	56	2024-07-15 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
904	1028	2	21	780	57	2024-07-15 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
905	1029	2	27	781	51	2024-07-12 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
906	1030	2	19	782	32	2024-07-15 23:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
907	1031	2	4	748	23	2024-07-11 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
908	1032	3	2	749	30	2024-07-12 06:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
909	1033	3	25	701	35	2024-07-16 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
910	1034	3	30	709	54	2024-07-15 23:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
911	1035	2	37	783	26	2024-07-15 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
893	1017	2	13	771	19	2024-07-11 21:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
894	1018	2	28	772	32	2024-07-16 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
885	1008	1	30	763	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
886	1009	2	22	764	45	2024-07-15 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
916	1041	2	3	766	38	2024-07-15 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
917	1042	2	23	786	28	2024-07-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
918	1043	3	11	753	22	2024-07-15 06:30:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
919	1044	2	29	787	26	2024-07-18 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
921	1046	2	6	789	23	2024-07-16 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
922	1047	2	13	790	19	2024-07-15 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
923	1048	2	35	791	13	2024-07-16 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
924	1049	2	11	778	47	2024-07-24 06:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
866	986	2	11	746	47	2024-07-09 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
867	987	2	41	747	26	2024-07-09 23:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
927	1053	1	32	794	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
928	1054	2	12	795	47	2024-07-17 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
929	1055	1	11	796	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
930	1056	2	8	797	24	2024-07-16 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
931	1057	2	19	798	32	2024-07-17 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
914	1039	2	16	743	47	2024-07-16 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
915	1040	1	3	785	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
952	1082	2	16	813	47	2024-07-23 06:30:00+00	rejected	\N	4	\N	\N	0	\N	0	\N	\N	\N	\N
937	1065	2	24	803	50	2024-07-16 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
980	1112	2	21	838	56	2024-07-23 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
941	1070	2	40	806	26	2024-07-23 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
949	1079	2	18	810	13	2024-07-24 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
976	1108	2	4	820	23	2024-07-23 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
977	1109	1	16	835	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
933	1059	2	22	800	39	2024-07-24 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
934	1060	2	29	801	26	2024-07-21 22:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
935	1061	5	2	638	33	2024-07-17 06:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
962	1093	2	43	823	26	2024-07-21 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
963	1094	1	3	824	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
938	1066	2	35	804	13	2024-07-17 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
813	928	2	32	619	49	2024-07-05 02:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
948	1078	3	19	798	26	2024-07-22 23:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
942	1071	2	32	794	49	2024-07-17 02:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
943	1072	2	25	807	29	2024-07-22 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
944	1073	1	16	808	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
945	1074	2	29	809	26	2024-07-23 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
946	1075	2	11	796	47	2024-07-23 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
947	1076	3	11	746	22	2024-07-22 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
865	985	2	27	745	51	2024-07-12 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
960	1090	2	28	821	32	2024-07-21 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
950	1080	1	16	811	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
951	1081	2	29	812	26	2024-07-21 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
953	1083	2	25	814	29	2024-07-22 23:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
954	1084	1	16	815	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
955	1085	2	13	816	19	2024-07-19 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
956	1086	1	4	817	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
957	1087	2	21	818	56	2024-07-21 23:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
958	1088	1	16	819	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
959	1089	1	4	820	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
961	1091	2	13	822	19	2024-07-23 01:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
892	1016	2	18	770	13	2024-07-14 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
936	1064	2	43	802	26	2024-07-16 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
964	1095	3	35	804	26	2024-07-22 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
965	1096	5	33	613	33	2024-07-23 06:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
966	1097	2	13	825	19	2024-07-22 06:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
967	1098	2	16	826	47	2024-07-25 06:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
968	1099	2	4	827	23	2024-07-29 06:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
969	1100	2	25	828	29	2024-07-24 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
970	1101	2	16	829	47	2024-07-26 06:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
971	1102	2	4	830	23	2024-07-26 06:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
972	1103	2	43	831	26	2024-07-25 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
973	1104	2	19	832	32	2024-07-24 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
974	1105	1	11	833	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
975	1106	1	21	834	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
920	1045	2	23	788	28	2024-07-21 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
932	1058	2	18	799	13	2024-07-17 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
984	1117	1	21	842	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
985	1118	1	38	843	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
981	1113	2	23	839	28	2024-07-24 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
982	1114	1	16	840	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
983	1115	2	19	841	25	2024-07-23 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
978	1110	2	19	836	25	2024-07-23 00:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
979	1111	2	21	837	56	2024-07-22 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
986	1119	1	21	844	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
987	1120	2	23	845	28	2024-07-28 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
988	1121	1	21	846	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
989	1122	2	21	847	34	2024-07-31 04:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
990	1123	2	25	848	29	2024-07-30 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
991	1124	2	18	849	13	2024-07-29 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
992	1125	2	22	850	39	2024-07-25 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
993	1126	3	27	745	38	2024-07-25 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
994	1127	1	21	851	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
995	1128	2	41	852	26	2024-07-23 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
996	1129	1	38	853	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
997	1130	2	13	854	19	2024-07-30 01:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
998	1131	1	16	855	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
999	1132	1	21	856	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1000	1133	2	25	857	29	2024-07-29 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1001	1134	2	18	858	13	2024-07-28 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1002	1135	2	29	859	26	2024-07-31 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1003	1136	1	38	860	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1004	1137	2	16	840	47	2024-07-29 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1007	1140	2	27	862	51	2024-07-26 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1008	1141	3	23	788	38	2024-07-25 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1009	1142	1	16	863	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1010	1143	2	41	864	26	2024-07-28 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1011	1144	2	38	865	34	2024-08-12 04:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1012	1145	2	25	866	29	2024-07-31 23:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
895	1019	2	28	773	32	2024-07-14 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
940	1069	1	11	805	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1042	1178	2	21	834	57	2024-07-30 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1006	1139	2	27	861	51	2024-07-29 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1022	1157	2	29	875	39	2024-07-30 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
862	982	6	3	702	21	2024-07-09 00:30:00+00	on-hold	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1039	1175	1	21	890	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1014	1147	3	16	868	22	2024-07-25 20:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1015	1148	1	21	869	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1016	1149	2	23	870	28	2024-07-25 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1017	1150	2	23	871	28	2024-07-28 20:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1018	1151	2	24	872	50	2024-07-29 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1019	1152	2	24	873	26	2024-07-30 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1005	1138	3	3	766	35	2024-07-28 20:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1038	1174	1	21	889	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1020	1154	3	4	820	26	2024-07-29 00:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1023	1158	2	32	876	34	2024-08-11 23:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1024	1159	1	4	877	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1025	1160	2	24	878	50	2024-07-29 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1026	1161	2	28	879	32	2024-07-29 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1027	1162	2	29	880	39	2024-07-29 05:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1028	1163	1	16	881	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1029	1164	2	38	853	34	2024-07-31 04:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1030	1165	2	16	863	47	2024-07-30 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1031	1166	2	28	882	32	2024-07-30 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1032	1167	2	24	883	50	2024-07-28 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1033	1168	2	23	884	28	2024-07-30 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1034	1169	2	27	885	51	2024-07-30 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1035	1170	2	18	886	13	2024-07-30 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1056	1194	1	33	904	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1057	1195	1	33	905	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1013	1146	2	29	867	26	2024-07-31 23:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1044	1181	6	16	826	35	2024-07-31 20:30:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1045	1182	5	23	788	33	2024-07-31 06:45:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1043	1179	1	21	893	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1040	1176	1	33	891	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1041	1177	2	22	892	26	2024-07-31 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1046	1183	1	21	894	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1047	1184	2	13	895	19	2024-07-31 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1048	1185	2	19	896	25	2024-07-31 22:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1049	1186	1	33	897	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1050	1187	2	38	898	34	2024-08-01 04:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1051	1188	2	38	899	34	2024-08-01 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1052	1189	2	28	900	32	2024-08-05 20:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1053	1190	2	42	901	29	2024-08-05 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1054	1191	2	22	902	39	2024-08-07 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1055	1192	1	21	903	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1036	1171	2	28	887	32	2024-08-01 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1037	1172	2	19	888	25	2024-08-01 00:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1058	1196	2	19	906	32	2024-08-06 20:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1059	1197	2	25	907	29	2024-08-07 23:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1060	1198	2	22	908	45	2024-08-07 06:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1061	1199	2	38	909	34	2024-08-13 04:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1062	1200	3	24	878	26	2024-08-04 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1063	1201	2	24	910	50	2024-07-31 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1064	1202	2	27	911	51	2024-08-02 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1065	1203	3	16	863	22	2024-08-01 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1066	1204	5	27	745	33	2024-08-01 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1067	1205	1	16	912	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1068	1206	2	41	913	32	2024-08-06 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1069	1207	1	33	726	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1070	1208	2	18	914	13	2024-09-08 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1071	1209	2	23	915	28	2024-09-03 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1072	1210	2	22	916	39	2024-09-06 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1073	1211	2	24	917	14	2024-09-03 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1074	1212	2	23	918	28	2024-09-04 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1076	1214	2	38	920	34	2024-09-06 02:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1077	1215	2	4	921	23	2024-09-02 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1078	1216	1	3	922	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1079	1217	1	3	923	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1080	1218	2	21	924	34	2024-09-05 02:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1081	1219	2	27	925	51	2024-09-04 06:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1082	1220	2	21	926	57	2024-09-03 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1083	1221	1	4	927	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1084	1222	2	28	928	32	2024-09-02 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1085	1223	2	19	929	32	2024-09-03 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1087	1225	2	18	931	13	2024-09-10 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1088	1226	2	18	932	13	2024-09-11 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1089	1227	2	23	933	28	2024-09-05 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1091	1229	2	17	935	53	2024-09-22 22:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1092	1230	2	18	936	13	2024-09-09 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1093	1231	1	32	937	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1094	1232	2	24	938	14	2024-09-06 07:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1095	1233	2	19	939	32	2024-09-05 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1090	1228	2	23	934	28	2024-09-05 22:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1021	1156	1	16	874	\N	2024-11-21 21:09:35+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1143	1285	2	13	982	59	2024-10-09 21:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1108	1247	2	25	950	29	2024-09-22 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1097	1235	2	27	941	51	2024-09-06 06:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1099	1237	2	18	943	13	2024-09-08 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1100	1238	2	29	944	26	2024-09-05 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1127	1266	2	13	968	59	2024-09-24 06:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1101	1239	1	30	945	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1102	1240	3	27	946	38	2024-09-05 21:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1136	1275	1	7	975	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1166	1310	\N	45	1002	\N	2024-11-21 21:09:35+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1086	1224	2	19	930	25	2024-09-04 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1103	1242	2	18	947	13	2024-09-08 23:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1145	1287	6	5	984	21	2024-09-26 01:00:00+00	on-hold	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1098	1236	2	27	942	51	2024-09-23 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1104	1243	2	23	948	28	2024-09-09 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1106	1245	1	4	949	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1107	1246	3	27	925	38	2024-09-18 21:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1110	1249	2	24	952	60	2024-09-18 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1111	1250	2	29	953	39	2024-09-18 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1112	1251	1	32	954	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1113	1252	1	23	955	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1114	1253	2	23	956	28	2024-09-18 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1115	1254	2	8	957	24	2024-09-18 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1116	1255	2	17	958	53	2024-09-18 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1117	1256	1	21	959	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1118	1257	2	23	960	28	2024-09-19 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1119	1258	2	23	961	28	2024-09-22 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1120	1259	2	18	962	13	2024-09-19 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1121	1260	2	18	963	13	2024-09-22 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1122	1261	2	13	964	59	2024-09-22 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1141	1283	2	19	980	25	2024-09-24 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1124	1263	2	39	966	26	2024-09-22 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1171	1317	1	45	1007	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1125	1264	1	32	629	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1128	1267	2	29	969	26	2024-09-23 23:00:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1129	1268	2	23	970	28	2024-09-24 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1164	1308	2	21	1000	57	2024-09-29 22:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1131	1270	1	17	972	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1165	1309	2	17	1001	53	2024-09-30 22:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1134	1273	3	8	957	22	2024-09-23 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1135	1274	2	18	974	13	2024-09-25 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1137	1276	1	7	976	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
567	654	2	22	504	45	2024-06-12 00:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1138	1278	2	8	977	24	2024-09-25 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1105	1244	3	27	941	38	2024-09-06 06:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1158	1301	2	28	996	32	2024-09-25 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1130	1269	2	25	971	29	2024-09-23 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1146	1288	6	5	985	21	2024-09-25 06:30:00+00	on-hold	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1147	1289	5	8	957	33	2024-09-26 06:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1148	1290	2	19	986	32	2024-09-26 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1149	1291	2	25	987	29	2024-09-26 22:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1150	1292	2	19	988	25	2024-09-25 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1151	1293	2	21	989	56	2024-09-26 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1152	1294	2	22	990	39	2024-09-26 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1153	1295	2	18	991	13	2024-09-25 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1154	1296	2	23	992	28	2024-09-25 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1155	1297	2	18	993	13	2024-09-26 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1156	1298	2	18	994	13	2024-09-26 22:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1157	1299	2	29	995	26	2024-09-25 22:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1123	1262	2	21	965	56	2024-09-22 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1159	1302	1	38	997	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1126	1265	1	32	967	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1163	1307	3	13	982	22	2024-09-25 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1132	1271	2	19	973	25	2024-09-23 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1168	1312	2	24	1004	14	2024-10-02 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1142	1284	2	19	981	32	2024-09-24 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1170	1316	1	7	1006	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1144	1286	2	23	983	28	2024-09-24 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1096	1234	2	13	940	59	2024-09-05 05:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1173	1319	1	45	1009	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1174	1320	2	14	1010	59	2024-09-29 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1175	1321	1	25	1011	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1169	1315	2	19	1005	32	2024-09-29 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1172	1318	1	45	1008	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1140	1282	1	38	979	\N	2024-11-21 21:09:35+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1202	1352	3	22	504	37	2024-10-02 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1209	1361	2	18	1041	13	2024-10-03 23:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1182	1329	1	17	1018	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1109	1248	2	21	951	57	2024-09-22 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1200	1350	2	7	975	51	2024-10-03 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1191	1339	1	25	1027	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1177	1323	2	39	1013	26	2024-09-26 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1178	1324	1	21	1014	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1219	1372	2	18	1049	13	2024-10-07 22:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1213	1366	1	25	1044	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1207	1359	2	23	1039	28	2024-10-06 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1181	1328	2	17	1017	53	2024-10-03 01:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1184	1331	2	28	1020	32	2024-10-02 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1185	1332	2	28	1021	32	2024-10-03 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1186	1333	2	41	1022	26	2024-10-01 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1187	1334	2	23	1023	28	2024-10-07 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1188	1335	2	21	1024	56	2024-10-03 22:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1189	1336	2	22	1025	39	2024-10-02 06:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1167	1311	2	21	1003	56	2024-09-26 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1204	1355	1	21	1036	\N	2024-11-21 21:09:35+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1192	1340	1	25	1028	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1193	1341	2	18	1029	13	2024-10-03 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1194	1342	2	18	1030	13	2024-09-02 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1195	1343	2	23	1031	28	2024-10-02 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1196	1344	2	13	1032	59	2024-10-04 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1197	1345	1	23	1033	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1198	1346	2	24	1034	60	2024-09-30 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1199	1347	2	23	1035	28	2024-10-02 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1139	1281	2	18	978	13	2024-09-23 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1190	1338	1	17	1026	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1206	1357	2	18	1038	13	2024-10-02 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1201	1351	2	7	976	51	2024-09-30 21:30:00+00	on-hold	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1205	1356	2	40	1037	26	2024-10-03 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1133	1272	2	23	955	28	2024-09-22 21:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1180	1327	2	19	1016	25	2024-09-30 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1208	1360	2	18	1040	13	2024-10-03 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1210	1362	2	13	1042	59	2024-10-08 07:00:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1250	1405	2	22	1077	39	2024-10-09 05:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1251	1406	3	2	999	30	2024-10-09 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1214	1367	2	29	1045	39	2024-10-04 05:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1215	1368	2	29	1046	26	2024-10-06 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1216	1369	3	2	998	30	2024-10-07 07:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1243	1397	2	32	1070	34	2024-10-14 02:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1220	1373	2	27	1050	51	2024-10-07 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1221	1374	2	18	1051	13	2024-10-07 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1222	1375	2	22	1052	39	2024-10-04 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1223	1376	2	18	1053	13	2024-10-03 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1224	1377	2	21	1054	34	2024-10-07 04:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1225	1378	2	25	1055	36	2024-10-03 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1226	1379	2	40	1056	26	2024-10-07 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1227	1380	2	7	1057	61	2024-10-04 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1228	1381	3	14	1010	22	2024-10-07 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1229	1382	2	22	1058	39	2024-10-04 06:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1230	1383	2	39	1059	26	2024-10-06 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1231	1384	2	7	1006	61	2024-10-09 05:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1232	1385	1	38	1060	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1233	1386	2	22	1061	27	2024-10-07 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1235	1388	2	19	1063	25	2024-10-07 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1236	1389	2	27	1060	51	2024-10-08 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1238	1391	1	32	1065	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1239	1392	2	22	1066	39	2024-10-08 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1240	1393	2	21	1067	56	2024-10-06 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1241	1394	2	25	1068	36	2024-10-06 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1217	1370	2	18	1047	13	2024-10-08 23:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1218	1371	2	18	1048	13	2024-10-07 21:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1244	1398	2	33	1071	48	2024-10-09 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1245	1399	2	28	1072	37	2024-10-09 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1246	1400	2	19	1073	32	2024-10-08 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1247	1401	2	18	1074	13	2024-10-08 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1248	1402	2	22	1075	39	2024-10-07 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1249	1403	2	13	1076	59	2024-10-08 06:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1211	1363	2	1	1033	38	2024-10-06 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1212	1365	2	28	1043	26	2024-10-03 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1252	1407	2	27	1078	51	2024-10-09 06:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1253	1408	3	28	1020	26	2024-10-08 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1242	1396	2	29	1069	39	2024-10-07 05:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1176	1322	2	13	1012	59	2024-09-26 07:00:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1264	1419	\N	38	1086	\N	2024-11-21 21:09:36+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1273	1431	2	17	1095	53	2024-10-11 01:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1260	1415	2	28	1083	32	2024-10-07 20:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1272	1430	1	30	1094	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1323	1490	2	14	1137	59	2024-10-17 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1328	1496	2	18	1142	13	2024-10-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1282	1440	2	25	1101	29	2024-10-09 04:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1325	1492	2	22	1139	39	2024-10-18 05:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1275	1433	2	23	1097	28	2024-10-09 23:45:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1258	1413	2	18	1081	13	2024-10-09 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1259	1414	2	21	1082	56	2024-10-07 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1278	1436	1	21	1098	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1277	1435	2	30	1088	53	2024-10-09 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1261	1416	3	29	1069	26	2024-10-14 05:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1262	1417	2	18	1084	13	2024-10-08 23:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1263	1418	2	29	1085	39	2024-10-09 05:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1265	1420	1	30	1087	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1266	1421	1	30	1088	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1267	1422	2	45	1089	22	2024-10-08 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1268	1423	2	19	1090	25	2024-10-08 23:00:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1183	1330	2	28	1019	26	2024-10-02 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1324	1491	2	14	1138	59	2024-10-16 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1329	1497	2	22	1143	39	2024-10-17 05:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1326	1493	2	24	1140	14	2024-10-17 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1256	1411	1	17	1079	53	2024-10-16 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1270	1428	2	19	1092	32	2024-10-09 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1311	1474	2	21	1127	56	2024-10-13 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1280	1438	1	21	1099	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1313	1476	2	22	1129	39	2024-10-14 05:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1283	1441	2	29	1102	39	2024-10-09 04:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1284	1442	2	17	1103	53	2024-10-13 22:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1285	1443	2	18	1104	13	2024-10-08 22:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1286	1444	2	21	1105	56	2024-10-09 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1287	1445	2	18	1106	13	2024-10-10 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1288	1446	2	25	1107	29	2024-10-10 04:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1289	1447	2	29	1108	39	2024-10-10 04:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1290	1448	2	18	1109	13	2024-10-09 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1292	1450	2	13	1111	59	2024-10-15 06:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1293	1451	2	18	1112	13	2024-10-10 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1295	1453	2	28	1114	32	2024-10-14 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1296	1454	3	28	1021	26	2024-10-13 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1297	1455	2	8	1115	24	2024-10-13 20:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1298	1456	3	19	1116	26	2024-10-10 23:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1299	1457	2	18	1117	13	2024-10-14 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1300	1458	1	30	1118	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1301	1459	2	30	1094	53	2024-10-13 22:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1302	1461	2	21	1119	56	2024-10-10 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1303	1462	2	18	1120	13	2024-10-10 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1304	1463	2	22	1121	39	2024-10-11 05:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1305	1464	2	23	1122	28	2024-10-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1306	1465	1	3	1123	\N	2024-11-21 21:09:36+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1307	1466	2	17	1124	53	2024-10-14 22:30:00+00	on-hold	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1308	1467	2	17	1125	53	2024-10-16 01:30:00+00	on-hold	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1279	1437	3	7	975	26	2024-10-10 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1312	1475	2	18	1128	13	2024-10-14 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1281	1439	2	18	1100	13	2024-10-08 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1314	1477	2	23	1130	28	2024-10-15 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1315	1478	2	18	1131	13	2024-10-13 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1316	1479	2	18	1132	13	2024-10-13 23:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1317	1480	2	23	1133	28	2024-10-13 23:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1271	1429	2	19	1093	32	2024-10-10 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1318	1482	3	19	1093	26	2024-10-14 22:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1274	1432	1	38	1096	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
790	904	1	4	682	\N	2024-11-21 21:09:35+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1320	1485	1	4	1135	\N	2024-11-21 21:09:36+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1321	1486	1	4	1136	\N	2024-11-21 21:09:36+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1269	1425	2	22	1091	37	2024-10-10 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1257	1412	1	17	1080	\N	2024-11-21 21:09:36+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1237	1390	2	27	1064	51	2024-10-07 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1203	1353	3	39	1013	26	2024-10-02 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1327	1495	2	21	1141	56	2024-10-16 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1319	1483	2	27	1134	51	2024-10-14 06:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1234	1387	2	19	1062	25	2024-10-03 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1322	1487	3	7	1006	26	2024-10-14 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1179	1326	2	24	1015	14	2024-09-30 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1343	1513	3	17	1095	54	2024-10-15 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1351	1521	2	18	1160	13	2024-10-17 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1330	1498	2	32	1144	34	2024-10-17 02:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1346	1516	2	25	1156	62	2024-10-21 22:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1398	1575	1	35	1197	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1364	1538	6	40	1056	63	2024-10-22 20:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1365	1539	2	21	1170	57	2024-10-22 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1357	1530	6	2	998	63	2024-10-16 20:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1359	1532	2	37	1165	26	2024-10-20 22:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1335	1504	1	14	1148	59	2024-10-17 06:30:00+00	sourced	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1361	1535	1	3	1167	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1294	1452	2	19	1113	25	2024-10-10 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1341	1511	3	27	1134	38	2024-10-15 00:00:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1331	1499	2	16	815	63	2024-10-27 20:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1332	1500	2	18	1145	13	2024-10-15 21:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1333	1501	2	18	1146	13	2024-10-14 22:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1291	1449	2	23	1110	28	2024-10-09 23:45:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1360	1534	1	21	1166	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1336	1505	1	3	1149	\N	2024-11-21 21:09:36+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1337	1506	1	3	1150	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1338	1507	1	4	1151	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1339	1508	1	4	1152	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
764	876	2	25	663	29	2024-06-30 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1390	1566	1	30	1190	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1342	1512	3	17	1094	54	2024-10-16 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1396	1573	1	3	1195	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1345	1515	2	25	1155	36	2024-10-16 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1373	1547	2	13	1175	59	2024-10-23 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1348	1518	3	18	1048	26	2024-10-15 22:00:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1276	1434	2	30	1087	53	2024-10-09 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1334	1503	2	25	1147	62	2024-10-28 21:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1352	1522	2	22	1161	39	2024-10-21 05:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1353	1523	2	23	1162	28	2024-10-21 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1354	1524	2	23	1163	28	2024-10-16 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1355	1525	2	18	1164	13	2024-10-17 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1349	1519	2	13	1158	59	2024-10-21 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1350	1520	2	21	1159	57	2024-10-21 21:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1356	1528	3	30	1088	54	2024-10-23 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1309	1471	2	25	1126	62	2024-10-15 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1340	1510	2	22	1153	27	2024-10-17 21:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1363	1537	2	18	1169	13	2024-10-20 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1404	1583	1	3	1203	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1366	1540	2	18	1171	13	2024-10-21 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1367	1541	2	22	1172	39	2024-10-22 05:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1369	1543	2	16	1174	63	2024-10-24 20:30:00+00	on-hold	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1370	1544	6	18	1048	63	2024-10-20 20:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1378	1553	2	18	1179	13	2024-10-22 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1371	1545	6	18	1145	63	2024-10-21 20:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1347	1517	2	35	1157	13	2024-10-16 23:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1374	1548	3	30	1125	54	2024-10-18 00:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1375	1549	1	16	1176	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1376	1550	2	27	1177	51	2024-10-25 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1377	1551	2	27	1178	51	2024-10-29 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1310	1473	2	25	1044	62	2024-10-16 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1379	1554	2	13	1180	59	2024-10-22 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1380	1555	2	19	1181	25	2024-10-20 23:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1381	1556	2	34	1182	48	2024-10-22 05:00:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1382	1557	1	4	1183	\N	2024-11-21 21:09:36+00	sourced	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1383	1558	1	16	1184	\N	2024-11-21 21:09:36+00	sourced	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1384	1559	1	3	1185	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1386	1561	2	27	1186	51	2024-10-24 05:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1387	1562	1	11	1187	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1388	1563	2	18	1188	13	2024-10-24 21:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1389	1564	1	4	1189	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
887	1011	1	4	765	\N	2024-11-21 21:09:35+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1391	1567	3	30	1087	54	2024-10-24 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1392	1568	2	18	1191	13	2024-10-23 23:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1393	1569	2	13	1192	59	2024-10-24 06:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1394	1570	1	16	1193	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1395	1571	2	27	1194	51	2024-10-23 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1344	1514	2	25	1154	62	2024-10-20 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1397	1574	2	23	1196	28	2024-10-21 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1399	1576	2	18	1198	13	2024-10-28 21:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1400	1577	2	13	1199	59	2024-11-06 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1401	1578	1	16	1200	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1402	1579	1	4	1201	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1403	1580	2	7	1202	51	2024-10-24 22:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1362	1536	2	18	1168	13	2024-10-20 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1405	1584	1	4	1204	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1368	1542	2	29	1173	26	2024-10-21 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1421	1601	1	16	1216	\N	2024-11-21 21:09:36+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1424	1604	1	18	1219	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1431	1615	1	4	1225	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1161	1304	2	2	999	55	2024-09-29 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1408	1588	2	18	1206	13	2024-10-23 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1447	1633	2	27	1239	51	2024-11-04 06:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1438	1622	1	18	1232	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1423	1603	2	6	1218	23	2024-10-24 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1452	1640	1	35	1243	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1453	1641	1	18	1244	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1358	1531	6	2	999	63	2024-10-17 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1409	1589	2	25	1207	36	2024-10-24 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1410	1590	2	13	1208	59	2024-10-22 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1411	1591	2	29	1209	26	2024-10-23 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1412	1592	1	11	1210	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1413	1593	1	16	1211	\N	2024-11-21 21:09:36+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1414	1594	5	30	1088	33	2024-10-29 06:00:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1415	1595	2	35	1212	13	2024-11-04 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1416	1596	2	25	1213	36	2024-11-04 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1417	1597	2	18	1214	13	2024-10-29 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1418	1598	2	29	1215	26	2024-10-29 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1422	1602	2	33	1217	48	2024-10-25 06:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1425	1607	3	7	1202	26	2024-11-05 00:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1406	1585	2	27	1205	51	2024-10-24 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1426	1608	1	18	1220	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1427	1609	1	4	1221	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1428	1610	2	14	1222	59	2024-11-04 21:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1429	1611	1	17	1223	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1430	1612	2	27	1224	51	2024-10-29 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1160	1303	2	2	998	55	2024-09-25 23:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1432	1616	1	17	1226	\N	2024-11-21 21:09:36+00	sourced	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1433	1617	2	21	1227	57	2024-11-05 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1434	1618	2	22	1228	39	2024-11-06 06:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1435	1619	2	23	1229	28	2024-11-06 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1436	1620	2	23	1230	28	2024-10-28 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1446	1632	2	27	1238	51	2024-11-07 06:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1439	1623	1	18	1233	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1440	1624	3	23	1230	38	2024-10-29 22:00:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1442	1626	3	25	1147	54	2024-11-04 21:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1443	1627	1	18	1235	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1444	1628	1	4	1236	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1445	1629	2	23	1237	28	2024-11-06 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1451	1639	2	19	1242	32	2024-11-06 06:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1448	1634	1	18	548	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1449	1635	2	19	1240	25	2024-11-05 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1450	1636	2	25	1241	62	2024-11-07 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1437	1621	2	43	1231	26	2024-10-31 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1454	1642	2	22	1245	27	2024-11-04 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1455	1643	2	27	1246	51	2024-11-06 06:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1456	1644	2	35	1247	64	2024-11-04 19:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1457	1645	2	21	1248	57	2024-11-07 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1458	1646	1	35	1249	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1459	1647	2	22	1250	39	2024-11-07 05:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1460	1648	2	22	1251	39	2024-11-08 05:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1461	1649	1	38	1252	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1462	1650	1	4	1253	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1463	1651	2	4	1225	23	2024-11-10 20:30:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1464	1652	2	16	1193	63	2024-11-05 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1465	1653	5	25	1147	33	2024-11-06 06:00:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1466	1654	2	16	1254	63	2024-11-18 20:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1467	1655	2	16	1255	63	2024-11-17 20:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1468	1656	2	35	1256	64	2024-11-05 19:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1469	1657	2	33	1257	48	2024-11-07 05:00:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1470	1658	2	33	1258	48	2024-11-06 05:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1471	1659	1	18	1259	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1472	1660	2	27	1260	51	2024-11-07 06:30:00+00	back-off	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1474	1662	1	7	1261	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1475	1663	2	19	1262	25	2024-11-11 06:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1476	1664	2	27	1263	51	2024-11-06 21:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1477	1665	2	4	1264	23	2024-11-18 06:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1478	1666	2	13	1265	59	2024-11-07 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1479	1667	1	16	1266	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1480	1668	2	39	1267	26	2024-11-10 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1481	1669	2	28	1268	26	2024-11-07 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1482	1670	2	5	1269	23	2024-11-06 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1483	1671	2	23	1270	28	2024-11-06 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1484	1672	3	16	815	35	2024-11-06 20:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1485	1673	2	4	1201	23	2024-11-07 20:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1499	1688	1	16	1281	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1500	1689	1	4	1282	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1488	1676	1	3	1273	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1495	1684	1	4	1278	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1489	1677	2	43	1274	26	2024-11-07 23:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1519	1710	2	29	1297	26	2024-11-13 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1496	1685	2	22	1279	39	2024-11-08 05:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1486	1674	1	11	1271	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1487	1675	2	24	1272	14	2024-11-07 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1504	1695	2	9	1285	33	2024-11-12 06:00:00+00	on-hold	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1521	1712	2	21	1299	57	2024-11-17 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1441	1625	2	25	1234	62	2024-10-31 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1491	1680	1	38	1275	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1505	1696	2	9	1286	33	2024-11-13 06:45:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1492	1681	1	38	1276	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1493	1682	3	21	1159	34	2024-11-08 04:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1494	1683	3	38	1277	34	2024-11-12 04:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1497	1686	3	4	1183	63	2024-11-07 20:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1498	1687	2	35	1280	64	2024-11-07 19:30:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1506	1697	2	9	1287	33	2024-11-13 06:00:00+00	back-off	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1552	1745	2	35	1327	64	2024-11-14 20:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1490	1678	3	22	1245	26	2024-11-07 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1503	1694	2	35	1284	64	2024-11-11 19:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1507	1698	2	9	1288	33	2024-11-14 06:00:00+00	on-hold	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1508	1699	2	19	1289	26	2024-11-13 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1509	1700	2	33	1290	48	2024-11-18 05:00:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1511	1702	2	35	1291	64	2024-11-11 21:00:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1512	1703	2	3	1203	38	2024-11-11 21:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1514	1705	1	18	1292	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1515	1706	2	19	1293	32	2024-11-11 20:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1545	1737	2	33	1320	48	2024-11-13 06:00:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1517	1708	1	38	1295	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1518	1709	1	38	1296	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1520	1711	2	22	1298	39	2024-11-12 06:00:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1522	1713	2	23	1300	28	2024-11-11 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1523	1714	2	21	1301	57	2024-11-13 21:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1524	1715	3	22	1250	26	2024-11-14 23:00:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1525	1716	2	33	1302	48	2024-11-14 05:00:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1526	1717	2	13	1303	59	2024-11-25 06:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1527	1718	2	13	1304	59	2024-11-18 06:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1528	1719	2	24	1305	65	2024-11-18 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1529	1720	2	13	1306	59	2024-11-13 06:30:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1530	1721	2	33	1307	48	2024-11-12 21:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1535	1726	2	22	1312	39	2024-11-13 05:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1536	1727	2	25	1313	36	2024-11-12 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1538	1729	2	22	1314	39	2024-11-14 06:00:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1539	1730	2	22	1315	39	2024-11-13 06:00:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1540	1731	2	23	1316	28	2024-11-12 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1541	1732	6	3	1203	63	2024-11-17 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1542	1733	2	23	1317	28	2024-11-14 00:45:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1543	1734	2	27	1318	51	2024-11-14 06:30:00+00	on-hold	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1544	1735	2	19	1319	26	2024-11-12 23:00:00+00	back-off	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1516	1707	2	19	1294	25	2024-11-11 23:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1502	1692	2	29	1283	26	2024-11-11 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1548	1741	1	21	1323	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1549	1742	1	45	1324	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1550	1743	2	19	1325	32	2024-11-18 01:00:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1551	1744	2	24	1326	65	2024-11-17 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1553	1746	2	35	1328	64	2024-11-14 21:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1554	1747	2	27	1329	51	2024-11-19 06:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1555	1748	2	33	1330	48	2024-11-20 05:00:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1556	1749	1	45	1331	\N	2024-11-21 21:09:36+00	sourced	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1557	1750	2	22	1332	39	2024-11-15 05:30:00+00	back-off	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1558	1751	2	19	1333	25	2024-11-13 20:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1559	1752	2	21	1334	57	2024-11-19 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1560	1753	1	18	564	\N	2024-11-21 21:09:36+00	sourced	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1561	1754	2	27	1335	51	2024-11-18 06:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1562	1755	3	22	1315	37	2024-11-14 21:30:00+00	done	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1563	1757	2	27	1336	51	2024-11-15 06:30:00+00	done	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1564	1758	2	33	1337	48	2024-11-21 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1565	1759	2	19	1338	25	2024-11-14 00:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1566	1760	2	19	1339	25	2024-11-14 23:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1571	1765	2	19	1344	26	2024-11-13 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1577	1775	2	33	1350	48	2024-11-20 05:00:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1611	1812	2	38	1378	34	2024-11-18 04:30:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1570	1764	2	19	1343	25	2024-11-14 23:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1594	1795	3	19	1310	26	2024-11-18 23:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1618	1821	\N	33	1383	\N	2024-11-21 21:09:36+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1573	1767	2	25	1346	36	2024-11-14 22:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1622	1826	\N	24	1386	\N	2024-11-21 21:09:36+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1586	1784	2	5	1357	23	2024-11-15 00:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1593	1793	3	33	1307	22	2024-11-20 07:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1614	1817	2	14	1380	59	2024-11-20 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1578	1776	2	45	1351	67	2024-11-14 22:00:00+00	rejected	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1546	1738	2	33	1321	48	2024-11-14 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1641	1849	\N	33	1404	\N	2024-11-21 21:09:36+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1569	1763	2	33	1342	48	2024-11-13 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1532	1723	2	19	1309	32	2024-11-13 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1568	1762	2	2	1341	66	2024-11-15 01:15:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1591	1790	2	33	1362	48	2024-11-19 05:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1612	1815	2	45	1324	22	2024-11-17 23:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1620	1824	3	33	1290	22	2024-11-25 06:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1574	1768	2	33	1347	48	2024-11-14 01:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1575	1769	2	35	1348	64	2024-11-13 19:30:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1576	1770	1	35	1349	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1533	1724	2	19	1310	32	2024-11-12 20:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1613	1816	2	27	1379	51	2024-11-18 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1579	1777	2	27	1352	51	2024-11-20 06:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1580	1778	2	9	1353	33	2024-11-19 06:00:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1581	1779	3	33	1302	22	2024-11-19 07:00:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1582	1780	1	11	572	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1583	1781	2	14	1354	59	2024-11-21 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1584	1782	1	18	1355	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1534	1725	2	24	1311	14	2024-11-13 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1587	1785	2	22	1358	39	2024-11-18 05:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1588	1786	2	19	1359	32	2024-11-18 20:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1589	1787	2	19	1360	32	2024-11-19 20:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1590	1788	2	23	1361	28	2024-11-14 21:30:00+00	rejected	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1513	1704	2	4	1204	23	2024-11-13 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1642	1850	3	19	1325	26	2024-11-21 22:30:00+00	done	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1531	1722	2	33	1308	48	2024-11-14 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1595	1796	2	19	1364	25	2024-11-17 23:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1596	1797	2	29	1365	26	2024-11-21 23:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1597	1798	2	13	1366	68	2024-11-18 07:00:00+00	rejected	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1598	1799	2	33	1367	48	2024-11-21 01:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1599	1800	2	21	1368	56	2024-11-22 00:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1600	1801	2	22	1369	39	2024-11-21 05:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1601	1802	2	19	1370	32	2024-11-20 20:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1602	1803	2	27	1371	51	2024-11-17 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1603	1804	2	21	1372	56	2024-11-21 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1604	1805	2	38	1373	34	2024-11-20 04:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1605	1806	2	27	1374	51	2024-11-21 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1606	1807	3	27	1336	38	2024-11-17 21:00:00+00	rejected	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1607	1808	1	3	1375	\N	2024-11-21 21:09:36+00	sourced	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1608	1809	2	14	1376	59	2024-11-21 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1547	1739	2	33	1322	48	2024-11-15 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1635	1842	2	27	1398	51	2024-11-19 20:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1616	1819	2	24	1381	65	2024-11-21 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1617	1820	2	33	1382	48	2024-11-21 05:00:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1619	1822	2	35	1384	64	2024-11-19 19:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1572	1766	2	40	1345	26	2024-11-17 22:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1621	1825	2	9	1385	33	2024-11-19 06:45:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1623	1827	2	21	1387	56	2024-11-18 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1624	1828	2	23	1388	28	2024-11-21 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1625	1829	2	27	1389	51	2024-11-18 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1626	1830	2	27	1390	51	2024-11-19 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1627	1831	6	16	815	21	2024-11-18 23:15:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1628	1832	2	19	1391	25	2024-11-18 23:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1629	1833	2	29	1392	39	2024-11-19 05:30:00+00	done	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1630	1834	2	27	1393	51	2024-11-18 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1631	1835	1	17	1394	\N	2024-11-21 21:09:36+00	sourced	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1632	1836	2	33	1395	48	2024-11-21 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1633	1837	2	23	1396	28	2024-11-20 01:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1634	1838	2	21	1397	56	2024-11-20 00:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1585	1783	2	40	1356	26	2024-11-17 23:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1636	1843	2	41	1399	26	2024-11-19 22:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1637	1844	2	19	1400	26	2024-11-19 23:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1638	1845	2	21	1401	57	2024-11-21 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1640	1847	2	31	1403	51	2024-11-26 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1592	1791	2	33	1363	48	2024-11-20 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1645	1853	\N	17	1407	\N	2024-11-21 21:09:37+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1646	1854	\N	35	1408	\N	2024-11-21 21:09:37+00	null	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1643	1851	2	35	1405	64	2024-11-18 19:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1644	1852	2	35	1406	64	2024-11-19 21:30:00+00	pending	\N	7	\N	\N	0	\N	0	\N	\N	\N	\N
1647	1855	2	21	1409	56	2024-11-20 21:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1648	1856	2	19	1410	32	2024-11-20 20:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1650	1858	2	22	1411	39	2024-11-22 05:30:00+00	pending	\N	3	\N	\N	0	\N	0	\N	\N	\N	\N
1651	1859	2	38	1412	34	2024-11-25 04:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1652	1860	2	34	1413	48	2024-11-25 06:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1653	1861	3	33	1362	22	2024-11-22 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1654	1862	2	29	1414	39	2024-11-25 05:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1655	1863	2	22	1415	27	2024-11-25 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1567	1761	2	2	1340	66	2024-11-19 04:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1639	1846	2	2	1402	66	2024-11-19 05:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1656	1866	2	14	1416	59	2024-11-27 06:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1615	1818	2	38	1296	34	2024-11-19 05:00:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1609	1810	2	24	1377	14	2024-11-18 21:30:00+00	pending	\N	5	\N	\N	0	\N	0	\N	\N	\N	\N
1657	1869	2	21	1417	34	2024-11-21 01:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1658	1870	2	31	1418	51	2024-11-20 21:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1659	1871	2	22	1419	39	2024-11-21 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1660	1872	2	22	1420	39	2024-11-20 05:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1661	1873	2	40	1421	26	2024-11-21 23:00:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
1662	1874	2	13	1422	68	2024-11-21 00:30:00+00	pending	\N	6	\N	\N	0	\N	0	\N	\N	\N	\N
\.


--
-- Data for Name: reqServices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqServices" ("sericeId", "sericeName") FROM stdin;
1	Associate Software Engineer Trainee
2	Associate Software Engineer
3	Software Engineer
4	Senior Software Engineer
\.


--
-- Data for Name: reqSkills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqSkills" (id, "skillName", "typeId", type) FROM stdin;
1	Python	2	tech
2	R	2	tech
3	Scala	2	tech
4	SQL	2	tech
5	NoSQL	2	tech
6	Deep learning	2	tech
8	Computer vision	2	tech
9	Expert system	2	tech
11	NLP	2	tech
12	generative models	2	tech
13	TensorFlow	2	tech
14	PyTorch	2	tech
15	MxNET	2	tech
16	Scikit-learn	2	tech
17	Pandas	2	tech
18	NumPy	2	tech
19	CNN	2	tech
20	RNN	2	tech
21	Q-learning	2	tech
22	SVM	2	tech
23	Logistic Regression	2	tech
24	Random Forest	2	tech
25	Ensemble Methods	2	tech
26	Data Modeling	2	tech
27	Predictive Analytics	2	tech
28	Cloud Architecture	2	tech
29	AI/ML Architecture Patterns	2	tech
30	Advanced Computing	2	tech
31	SDLC Process	2	tech
32	Data Analytics	2	tech
33	Expert Systems	2	tech
34	Continuous Code Integration and Deployment	2	tech
35	AWS	2	tech
36	Azure	2	tech
37	GCP	2	tech
38	Django	2	tech
39	Flask	2	tech
40	FastAPI	2	tech
41	asyncio	2	tech
42	concurrent.futures	2	tech
43	Docker	2	tech
44	Kubernetes	2	tech
45	Lambda	2	tech
46	Cloud Functions	2	tech
47	Jenkins	2	tech
48	GitLab CI	2	tech
49	CircleCI	2	tech
50	Terraform	2	tech
51	Ansible	2	tech
52	PostgreSQL	2	tech
53	MySQL	2	tech
54	MongoDB	2	tech
55	Redis	2	tech
56	RESTful APIs	2	tech
57	GraphQL	2	tech
58	OpenAPI/Swagger	2	tech
59	Git	2	tech
60	GitHub	2	tech
61	GitLab	2	tech
62	GitFlow	2	tech
63	PyJWT	2	tech
64	OAuth2	2	tech
65	Scrum	2	tech
66	Kanban	2	tech
67	Scrapy	2	tech
68	ReactJS	2	tech
69	Angular	2	tech
70	HTML5	2	tech
71	CSS	2	tech
72	JavaScript	2	tech
73	jQuery	2	tech
74	Linux	2	tech
75	Deployment Architecture	2	tech
76	DigitalOcean	2	tech
77	Source Control Management	2	tech
81	Communication Skills	1	soft
82	Interpersonal Skills	1	soft
83	Presentation Skills	1	soft
84	Self-motivation	1	soft
85	Organizational Skills	1	soft
86	Transfer Learning	1	soft
87	Analytical Skills	1	soft
88	Research Skills	1	soft
89	LinkedIn Knowledge	1	soft
90	Teamwork	1	soft
91	Independence	1	soft
92	Time Management	1	soft
93	Motivation	1	soft
94	Proactivity	1	soft
95	Business Analysis	1	soft
96	Stakeholder Management	1	soft
97	Documentation Skills	1	soft
98	Technical Skills	2	tech
99	Reporting and Presentation	1	soft
100	Microsoft Word	2	tech
101	Microsoft Excel	2	tech
102	Microsoft Outlook	2	tech
103	Planning Skills	1	soft
104	Team Leadership	1	soft
105	Project Management	1	soft
106	Marketing Collateral Development	1	soft
109	SRS (Software Requirements Specification)	1	soft
110	SOW (Statement of Work)	1	soft
113	Capability Documentation	1	soft
114	Case Studies	1	soft
119	Presales Documentation Skills	1	soft
120	Social Media Marketing	1	soft
121	Content Marketing	1	soft
124	Relationship Management	1	soft
125	Team Collaboration	1	soft
126	Results-Driven Mindset	1	soft
127	Open Source Development	1	soft
128	Mobile Development	2	tech
129	Agile Project Management	2	tech
130	Emerging Technologies Knowledge	2	tech
131	Problem-Solving Skills	1	soft
132	Manual Testing	2	tech
133	SDLC	2	tech
134	JIRA	2	tech
135	Written Communication Skills	1	soft
136	Verbal Communication Skills	1	soft
137	Multitasking	1	soft
139	Mobile Application Testing	2	tech
140	Automated Testing	2	tech
141	ISTQB Certification	2	tech
142	PHP	2	tech
143	Data Structures and Algorithms	2	tech
144	Object-Oriented Programming (OOP)	2	tech
145	Logical Thinking and Problem-Solving Skills	1	soft
146	UI/UX Principles	2	tech
147	RESTful APIs and Web Services Integration	2	tech
148	MSSQL	2	tech
149	Learning New Technologies	1	soft
150	Continuous Self-Improvement	1	soft
151	Laravel	2	tech
152	React	2	tech
153	Vue.js	2	tech
154	Positive Attitude	1	soft
155	Ability to Work Independently	1	soft
156	Team Player	1	soft
157	Adaptability	1	soft
158	Logical thinking and problem-solving abilities.	1	soft
159	task prioritization	1	soft
160	Android Development	2	tech
161	Kotlin	2	tech
162	Java	2	tech
163	Android SDK	2	tech
164	APIs	2	tech
165	UI/UX	2	tech
166	Jetpack	2	tech
167	MVVM	2	tech
168	MVP	2	tech
169	Android Studio	2	tech
170	Debugging Tools	2	tech
171	Event-Driven Programming	2	tech
172	RXJS	2	tech
173	CSS3	2	tech
174	Cross-Browser Layout	2	tech
175	Responsive Design	2	tech
176	Attention to Detail	1	soft
177	D3	2	tech
178	Technical Guidance	1	soft
179	Mentoring	1	soft
180	Performance Management	1	soft
181	Code Reviews	1	soft
182	.NET Core	2	tech
183	MS SQL	2	tech
184	Project Requirements Translation	1	soft
185	Troubleshooting	1	soft
186	Project Task Management	1	soft
187	Unit Testing	2	tech
188	Integration Testing	2	tech
189	ASP.NET MVC	2	tech
190	TypeScript	2	tech
191	Azure DevOps	2	tech
192	Odoo	2	tech
193	Bitbucket	2	tech
194	Cloud Servers	2	tech
195	Odoo APIs	2	tech
196	Custom Module Development	2	tech
197	Configuration	2	tech
198	Research	1	soft
199	Team Training	1	soft
200	Business Process Analysis	1	soft
201	GoLang	2	tech
202	RDBMS	2	tech
203	Core PHP	2	tech
204	CodeIgniter	2	tech
205	Full Stack Development	2	tech
206	Vanilla JavaScript	2	tech
207	Ajax	2	tech
208	Symfony	2	tech
209	SVN	2	tech
210	Bootstrap	2	tech
211	XML	2	tech
212	Node.js	2	tech
213	React.js	2	tech
214	React Native	2	tech
215	Spring	2	tech
216	Relational Databases	2	tech
217	Non-Relational Databases	2	tech
218	Unix/Linux	2	tech
219	Shell Scripts	2	tech
220	Express	2	tech
221	Babel	2	tech
222	Compatibility	1	soft
223	Technical Solution Presentation	1	soft
224	Leadership	1	soft
225	Mentorship	1	soft
226	Spring Boot	2	tech
227	DevOps	2	tech
228	Cloud Deployment	2	tech
229	CI/CD Pipelines	2	tech
230	Test Driven Development (TDD)	2	tech
231	Web API	2	tech
232	NET MVC	2	tech
233	dotnet	2	tech
234	Azure App Service	2	tech
235	Azure Functions	2	tech
237	Individual contributor	1	soft
238	Excel	2	tech
239	JMeter	2	tech
240	Postman	2	tech
241	SOAPUI	2	tech
242	Bugzilla	2	tech
243	Web application security	2	tech
244	STLC	2	tech
245	Test estimation	2	tech
246	Test scenarios identification	2	tech
247	Cross-browser	2	tech
248	Mobile Device Testing	2	tech
249	Test strategizing	2	tech
250	Selenium	2	tech
251	Appium	2	tech
252	JUnit	2	tech
253	TestNG	2	tech
254	Cucumber	2	tech
255	C-Sharp	2	tech
\.


--
-- Data for Name: reqStations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqStations" ("stationId", "stationName") FROM stdin;
1	Screening
6	Management
2	Technical 1
3	Technical 2
4	Technical 3
5	HR Manager
\.


--
-- Data for Name: reqTasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqTasks" ("taskId", "taskName", "taskServiceId", "taskUserId", "taskDate", "createdAt", "updatedAt", "taskStatus") FROM stdin;
\.


--
-- Data for Name: reqTeams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqTeams" ("teamId", "teamName") FROM stdin;
1	Accounts
2	.Net
3	Administration
4	Business
5	Cloud
6	Coldfusion
7	Java
8	Javascript
9	Mobile
10	Testing
11	Python
12	UI/UX
13	Ruby & Rails
14	Odoo
15	PHP
16	Golang
17	HR
\.


--
-- Data for Name: reqUserRoles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqUserRoles" ("roleId", "roleName", "roleUserId") FROM stdin;
\.


--
-- Data for Name: reqUsers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqUsers" ("userId", "userfirstName", "userlastName", "userEmail", "userDOB", "userPassword", "userWorkStation", "userRole", "userType", "userStatus", "createdAt", "updatedAt", "userOtp", "useOtpExpire") FROM stdin;
1	admin	admin	admin@techversantinfotech.com	1987-01-04 18:30:00+00	$2a$10$/3VSB./u.2DV3UBkMRbkVewiaoRWHpxl1fkUF3R01h3FEzjuGy2ci	1	talent	admin	active	2024-07-22 11:26:57.7124+00	2024-07-22 11:26:57.7124+00	\N	\N
14	Vishnu Pramod M V	 	vishnupramodmv@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
15	Terick Sebastian	 	tericksebastian@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
16	Parvathi Raveendran	 	parvathiraveendran@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
17	Janarish Saju	 	janarishsaju@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
18	Jomy John	 	jomyjohn@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
19	Renjith M	 	renjithm@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
20	Miljo Thomas	 	miljothomas@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
24	Pratheesh P C	 	pratheeshpc@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
25	Ajosh D	 	ajoshd@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
27	Vijay A	 	vijaya@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
28	Mohammed Ajmal	 	mohammedajmal@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
29	Udayan K S & Deepak Jose	 	udayanksdeepakjose@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
31	Udayan K S	 	udayanks@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
32	Safal P Pillai	 	safalppillai@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
34	Vijay K	 	vijayk@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
35	Deepak Jose & Udayan K S	 	deepakjoseudayanks@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
36	Vidhyasree T S	 	vidhyasreets@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
37	Mathew John	 	mathewjohn@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
39	Arun R S	 	arunrs@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
41	Ranjith K R	 	ranjithkr@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
42	Raju Pavithran	 	rajupavithran@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
43	Renu P	 	renup@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
44	Renu P & Midhun M Nair	 	renupmidhunmnair@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
45	Girish Nair	 	girishnair@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
46	Vishnu C S	 	vishnucs@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
47	Sreerag S	 	sreerags@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
48	Aravind K V	 	aravindkv@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
49	Arun Antony & Vijay K	 	arunantonyvijayk@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
50	Nikky	 	nikky@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
51	Sayooj P S	 	sayoojps@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
52	Deepak Jose & Quilo	 	deepakjosequilo@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
53	Vishnu M A & Reema	 	vishnumareema@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
55	Deepa P S	 	deepaps@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
56	Shajahan M	 	shajahanm@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
57	Biji Jacob	 	bijijacob@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
58	Vijay K	 	vijayk@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
59	Vishnu Soman S	 	vishnusomans@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
60	Anju Mary Paul	 	anjumarypaul@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
61	Rejeesh K V	 	rejeeshkv@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
62	Vishnu M A & Sruthi Vijayan	 	vishnumasruthivijayan@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
63	Milton F Emmatty	 	miltonfemmatty@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
65	Anoop Ben	 	anoopben@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
66	Ali Mahroof	 	alimahroof@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
67	Sayuj S	 	sayujs@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
3	Maloo	Vijayan	maloovijayan@techversantinfotech.com	\N	$2a$10$jE6B2BYA0dPq5IubfbI3sOjCckJpePNekIFXC3Duo/JMP/AiooX6O	1	talent	user	active	2024-11-19 06:23:31.352+00	2024-11-19 06:23:31.352+00	\N	\N
2	Geethu	Angel	geethu@techversantinfotech.com	\N	$2a$10$WNk0XftHI8mPOO56dUfUTO8tjWqVN1pdSm.3GOoUiLFISAlPK3AzO	1	talent	user	active	2024-11-19 06:23:00.749+00	2024-11-19 06:23:00.749+00	\N	\N
5	Neenu	Hormis	neenu@techversantinfotech.com	\N	$2a$10$CTq89zCpOWRX38KYdY6qNuNGv/bfM9rtbqpcgcNf8dYhZ2OKKdG1G	1	talent	user	active	2024-11-19 06:24:06.539+00	2024-11-19 06:24:06.539+00	\N	\N
6	Parvathy	M	parvathy.m@techversantinfo.com	\N	$2a$10$WB4mWZEsk0fRRmmoaPVpo.uwNDgr5IGeIDD3rFHUisoqOUbET0RTC	1	talent	user	active	2024-11-19 06:24:24.655+00	2024-11-19 06:24:24.655+00	\N	\N
7	Shreya	Elza Shibu	shreyaelzashibu@techversantinfotech.com	\N	$2a$10$crG8y.soKrNhhZ4JGTOsY.zaKGLgNAkZdKu.7ABpu/5Zmji6fYva2	1	talent	user	active	2024-11-19 06:24:42.155+00	2024-11-19 06:24:42.155+00	\N	\N
13	super	Admin	superadmin@techversantinfotech.com	\N	$2a$10$Q9SHI6tjoBY1f67wlsJqz.UAxv.LSCA04LlCbPBX4EVe5NJne8HOW	3	super-admin	super-admin	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
33	Manoj Madhavan	 	manojmadhavan@mail.com	\N	xx	4	manager	user	inactive	2023-11-20 18:30:00+00	2024-12-31 05:25:45.856+00	\N	\N
30	Vinayak C S	 	vinayak.cs@techversantinfo.com	\N	xx	4	manager	user	active	2023-11-20 18:30:00+00	2024-12-31 05:50:36.717+00	\N	\N
22	Lajin M	 	lajin.mohan@techversantinfotech.com	\N	xx	4	manager	user	active	2023-11-20 18:30:00+00	2024-12-31 05:48:20.91+00	\N	\N
26	Arun Antony	 	arunantony@mail.com	\N	xx	4	manager	user	inactive	2023-11-20 18:30:00+00	2024-12-31 05:31:56.349+00	\N	\N
21	Quilo Soman	 	quilosoman@mail.com	\N	xx	4	manager	user	inactive	2023-11-20 18:30:00+00	2024-12-30 12:43:33.735+00	\N	\N
68	Rehnasha		rehnasha@mail.com	\N	xx	3	panel	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
84	Arun	Antony	arun@techversantinfo.com	\N	$2a$10$zEY1V.gceAuudFLSiKwrcuKYkOkAvWJqAn1WbWzjmp64/O8Byaz62	4	manager	user	active	2024-12-31 05:31:27.002+00	2024-12-31 05:31:27.002+00	\N	\N
70	super	Admin	superadmin@techversantinfotech.com	\N	$2a$10$Q9SHI6tjoBY1f67wlsJqz.UAxv.LSCA04LlCbPBX4EVe5NJne8HOW	1	super-admin	super-admin	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
71	Amrutha 	Ravi	amrutha.ravi@techversantinfo.com	\N	$2a$10$coe0jLhnXmDqL.LS2lCmLesBDJNTcxm4T1NDjbkgFCipyVl8y2t/C	1	talent	user	active	2024-12-20 07:08:18.186+00	2024-12-20 07:08:18.186+00	\N	\N
4	Jiji	George	jijigeorge@techversantinfotech.com	\N	$2a$10$sqL77U4jk0fo9I1S0tBIFOxRfcuej21v7a1DU5PP8Nqc4nacWImTS	4	manager	user	active	2024-11-19 06:23:49.48+00	2024-12-04 07:27:54.562+00	\N	\N
23	Renjith P N	 	renjithpn@mail.com	\N	xx	4	manager	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
54	Ashok Kumar T	 	ashokkumart@mail.com	\N	xx	4	manager	user	active	2023-11-20 18:30:00+00	2023-11-20 18:30:00+00	\N	\N
72	Joby 	John	joby.john@techversantinfotech.com	\N	$2a$10$AwgPZ4HDOWoSKLVzHnV7M.Rr78LxEjL9cYuiWbpfpfS7J8OYwoAue	4	manager	user	active	2024-12-30 11:12:38.662+00	2024-12-30 11:12:38.662+00	\N	\N
73	Rino	Raj	rino.raj@techversantinfotech.com	\N	$2a$10$FZKW9VKsd6D6Ks5LRns1VOhiJ1XKNVdVumss3Xx8Ghhu5Dhhv.3em	4	manager	user	active	2024-12-30 11:17:44.456+00	2024-12-30 11:21:13.009+00	\N	\N
80	Quilo 	Soman	quilo@techversantinfotech.com	\N	$2a$10$QWH.bQEJr0qCFL0FsX2JEevtu4aBGkD0qzgU3v/lSY2C9d6/amsci	4	manager	user	active	2024-12-30 12:45:58.649+00	2024-12-31 05:22:04.901+00	\N	\N
79	Milton Francis 	Emmatty	miltonfemmatty@techversantinfotech.com	\N	$2a$10$Zj1k66DjGe9yiCEYq05fEeGDZEgvM1i7kq0.ZlP8GD/oFzHbi3fHq	4	manager	user	active	2024-12-30 12:03:46.843+00	2024-12-31 05:22:11.251+00	\N	\N
78	Renjith 	Mohanakumar	renjith.m@techversantinfotech.com	\N	$2a$10$AQ2vaa4ALU9Yhr1IOkFW6.dU1MFf701MSjJNxEK06yrPe7nlV2nQC	4	manager	user	active	2024-12-30 11:28:48.579+00	2024-12-31 05:22:15.519+00	\N	\N
77	Arun Somasekharan 	Nair	arun.somasekharan@techversantinfotech.com	\N	$2a$10$e1FEh4AjkjRr04DEnwpv6O94lpDIa1sJO2OaBjVzAzF06a/sL6/3a	4	manager	user	active	2024-12-30 11:27:35.893+00	2024-12-31 05:22:20.092+00	\N	\N
76	Bibin 	Suresh	bibin.suresh@techversantinfotech.com	\N	$2a$10$6OhjFYTQXnWqYyIS2gY9JOfYGXZ8hTWRFEOxSqTVbY.ALdVfjZ6P.	4	manager	user	active	2024-12-30 11:26:33.517+00	2024-12-31 05:22:30.382+00	\N	\N
75	Renjith	 P N	renjith.pn@techversantinfo.com	\N	$2a$10$Glqm9002twd6w0JpjHLVbuUp5pZVolPYXeuStbhfVtaV/Zpz5Wy2.	4	manager	user	active	2024-12-30 11:25:14.753+00	2024-12-31 05:22:35.091+00	\N	\N
74	Ashok Kumar 	T	ashokkumart@techversantinfotech.com	\N	$2a$10$ABhAH/pzI0p6hBipWKwwvudCXYgZ24QeErorTqyQ492QXdcU9sgSy	4	manager	user	active	2024-12-30 11:23:36.918+00	2024-12-31 05:22:40.124+00	\N	\N
81	Deepak	Jose	deepak.jose@techversantinfotech.com	\N	$2a$10$M5m.i35OGLb.Zep0v0HwnOzMTIi4ppMGT8NKxlAI9lQLR0o2qNY3e	4	manager	user	active	2024-12-31 05:24:48.376+00	2024-12-31 05:24:48.376+00	\N	\N
82	Manoj	Madhavan	manoj@techversantinfotech.com	\N	$2a$10$XDT.gYc.WqOw7K7gat2Keuh2tHQNffzqe4cIMJI.X0PP3KedB5HhO	4	manager	user	active	2024-12-31 05:26:41.28+00	2024-12-31 05:26:41.28+00	\N	\N
40	Deepak Jose	 	deepakjose@mail.com	\N	xx	4	manager	user	inactive	2023-11-20 18:30:00+00	2024-12-31 05:27:21.117+00	\N	\N
83	Shanavas	S	shanavas@techversantinfo.com	\N	$2a$10$O5c15IHplk5hJtMhuyABa.dGiSzvGaQ5bg1kYzk1uNYqOblIJzoQK	4	manager	user	active	2024-12-31 05:28:47.036+00	2024-12-31 05:28:47.036+00	\N	\N
38	Shanavas S	 	shanavass@mail.com	\N	xx	4	manager	user	inactive	2023-11-20 18:30:00+00	2024-12-31 05:29:13.063+00	\N	\N
\.


--
-- Data for Name: reqinterviewDetails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqinterviewDetails" (id, "serviceId", "interviewLocation", "interviewMode", "interviewStatus", "candidateStatus", "rescheduleStatus", "createdAt", "updatedAt", "preferMode", "revlentExperience", "totalExperience") FROM stdin;
\.


--
-- Data for Name: reqreqruiterStationReports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqreqruiterStationReports" (id, "position", station, "user", "screenRejected", "writtenReject", "techOneReject", "techTwoReject", "managementReject", "hrReject", "offerReleased", hired, date, "technicalTotalSelected", "totalSourced") FROM stdin;
\.


--
-- Data for Name: reqworkModes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reqworkModes" (id, "modeName") FROM stdin;
1	Online
2	Remote
3	Hybrid
\.


--
-- Name: reqAccessTokens_accessId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqAccessTokens_accessId_seq"', 1, false);


--
-- Name: reqCandidateComments_commentId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqCandidateComments_commentId_seq"', 1, false);


--
-- Name: reqCandidateLogs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqCandidateLogs_id_seq"', 4, true);


--
-- Name: reqCandidateProgresses_progressId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqCandidateProgresses_progressId_seq"', 1, false);


--
-- Name: reqCandidateResumeSources_sourceId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqCandidateResumeSources_sourceId_seq"', 5, true);


--
-- Name: reqCandidateSkills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqCandidateSkills_id_seq"', 1, false);


--
-- Name: reqCandidates_candidateId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqCandidates_candidateId_seq"', 1424, true);


--
-- Name: reqDesignations_designationId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqDesignations_designationId_seq"', 1, false);


--
-- Name: reqExperienceReports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqExperienceReports_id_seq"', 41, true);


--
-- Name: reqFeedbacks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqFeedbacks_id_seq"', 3, true);


--
-- Name: reqHrReviews_reviewedId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqHrReviews_reviewedId_seq"', 1, false);


--
-- Name: reqIntervieModes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqIntervieModes_id_seq"', 3, true);


--
-- Name: reqLogs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqLogs_id_seq"', 1, false);


--
-- Name: reqMultipleRoleAccesses_roleAccessId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqMultipleRoleAccesses_roleAccessId_seq"', 1, false);


--
-- Name: reqOfferAttachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqOfferAttachments_id_seq"', 1, false);


--
-- Name: reqProgressSkills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqProgressSkills_id_seq"', 1, false);


--
-- Name: reqQuestionBoxes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqQuestionBoxes_id_seq"', 1, false);


--
-- Name: reqQuestions_questionId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqQuestions_questionId_seq"', 1, false);


--
-- Name: reqRejectReasons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqRejectReasons_id_seq"', 3, true);


--
-- Name: reqReports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqReports_id_seq"', 1011, true);


--
-- Name: reqServiceFlows_flowId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqServiceFlows_flowId_seq"', 1, false);


--
-- Name: reqServiceRequests_requestId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqServiceRequests_requestId_seq"', 47, true);


--
-- Name: reqServiceSequencesAcitves_serviceActiveId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqServiceSequencesAcitves_serviceActiveId_seq"', 1664, true);


--
-- Name: reqServiceSequences_serviceId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqServiceSequences_serviceId_seq"', 1876, true);


--
-- Name: reqServices_sericeId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqServices_sericeId_seq"', 4, true);


--
-- Name: reqSkills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqSkills_id_seq"', 255, true);


--
-- Name: reqStations_stationId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqStations_stationId_seq"', 1, false);


--
-- Name: reqTasks_taskId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqTasks_taskId_seq"', 1, false);


--
-- Name: reqTeams_teamId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqTeams_teamId_seq"', 17, true);


--
-- Name: reqUserRoles_roleId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqUserRoles_roleId_seq"', 1, false);


--
-- Name: reqUsers_userId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqUsers_userId_seq"', 84, true);


--
-- Name: reqinterviewDetails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqinterviewDetails_id_seq"', 1, false);


--
-- Name: reqreqruiterStationReports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqreqruiterStationReports_id_seq"', 1, false);


--
-- Name: reqworkModes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reqworkModes_id_seq"', 3, true);


--
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- Name: reqAccessTokens reqAccessTokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqAccessTokens"
    ADD CONSTRAINT "reqAccessTokens_pkey" PRIMARY KEY ("accessId");


--
-- Name: reqCandidateComments reqCandidateComments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidateComments"
    ADD CONSTRAINT "reqCandidateComments_pkey" PRIMARY KEY ("commentId");


--
-- Name: reqCandidateLogs reqCandidateLogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidateLogs"
    ADD CONSTRAINT "reqCandidateLogs_pkey" PRIMARY KEY (id);


--
-- Name: reqCandidateProgresses reqCandidateProgresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidateProgresses"
    ADD CONSTRAINT "reqCandidateProgresses_pkey" PRIMARY KEY ("progressId");


--
-- Name: reqCandidateResumeSources reqCandidateResumeSources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidateResumeSources"
    ADD CONSTRAINT "reqCandidateResumeSources_pkey" PRIMARY KEY ("sourceId");


--
-- Name: reqCandidateSkills reqCandidateSkills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidateSkills"
    ADD CONSTRAINT "reqCandidateSkills_pkey" PRIMARY KEY (id);


--
-- Name: reqCandidates reqCandidates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidates"
    ADD CONSTRAINT "reqCandidates_pkey" PRIMARY KEY ("candidateId");


--
-- Name: reqDesignations reqDesignations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqDesignations"
    ADD CONSTRAINT "reqDesignations_pkey" PRIMARY KEY ("designationId");


--
-- Name: reqExperienceReports reqExperienceReports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqExperienceReports"
    ADD CONSTRAINT "reqExperienceReports_pkey" PRIMARY KEY (id);


--
-- Name: reqFeedbacks reqFeedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqFeedbacks"
    ADD CONSTRAINT "reqFeedbacks_pkey" PRIMARY KEY (id);


--
-- Name: reqHrReviews reqHrReviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqHrReviews"
    ADD CONSTRAINT "reqHrReviews_pkey" PRIMARY KEY ("reviewedId");


--
-- Name: reqIntervieModes reqIntervieModes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqIntervieModes"
    ADD CONSTRAINT "reqIntervieModes_pkey" PRIMARY KEY (id);


--
-- Name: reqLogs reqLogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqLogs"
    ADD CONSTRAINT "reqLogs_pkey" PRIMARY KEY (id);


--
-- Name: reqMultipleRoleAccesses reqMultipleRoleAccesses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqMultipleRoleAccesses"
    ADD CONSTRAINT "reqMultipleRoleAccesses_pkey" PRIMARY KEY ("roleAccessId");


--
-- Name: reqOfferAttachments reqOfferAttachments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqOfferAttachments"
    ADD CONSTRAINT "reqOfferAttachments_pkey" PRIMARY KEY (id);


--
-- Name: reqProgressSkills reqProgressSkills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqProgressSkills"
    ADD CONSTRAINT "reqProgressSkills_pkey" PRIMARY KEY (id);


--
-- Name: reqQuestionBoxes reqQuestionBoxes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqQuestionBoxes"
    ADD CONSTRAINT "reqQuestionBoxes_pkey" PRIMARY KEY (id);


--
-- Name: reqQuestions reqQuestions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqQuestions"
    ADD CONSTRAINT "reqQuestions_pkey" PRIMARY KEY ("questionId");


--
-- Name: reqRejectReasons reqRejectReasons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqRejectReasons"
    ADD CONSTRAINT "reqRejectReasons_pkey" PRIMARY KEY (id);


--
-- Name: reqReports reqReports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqReports"
    ADD CONSTRAINT "reqReports_pkey" PRIMARY KEY (id);


--
-- Name: reqServiceFlows reqServiceFlows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceFlows"
    ADD CONSTRAINT "reqServiceFlows_pkey" PRIMARY KEY ("flowId");


--
-- Name: reqServiceRequests reqServiceRequests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceRequests"
    ADD CONSTRAINT "reqServiceRequests_pkey" PRIMARY KEY ("requestId");


--
-- Name: reqServiceSequencesAcitves reqServiceSequencesAcitves_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceSequencesAcitves"
    ADD CONSTRAINT "reqServiceSequencesAcitves_pkey" PRIMARY KEY ("serviceActiveId");


--
-- Name: reqServiceSequences reqServiceSequences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceSequences"
    ADD CONSTRAINT "reqServiceSequences_pkey" PRIMARY KEY ("serviceId");


--
-- Name: reqServices reqServices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServices"
    ADD CONSTRAINT "reqServices_pkey" PRIMARY KEY ("sericeId");


--
-- Name: reqSkills reqSkills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqSkills"
    ADD CONSTRAINT "reqSkills_pkey" PRIMARY KEY (id);


--
-- Name: reqStations reqStations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqStations"
    ADD CONSTRAINT "reqStations_pkey" PRIMARY KEY ("stationId");


--
-- Name: reqTasks reqTasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqTasks"
    ADD CONSTRAINT "reqTasks_pkey" PRIMARY KEY ("taskId");


--
-- Name: reqTeams reqTeams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqTeams"
    ADD CONSTRAINT "reqTeams_pkey" PRIMARY KEY ("teamId");


--
-- Name: reqUserRoles reqUserRoles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqUserRoles"
    ADD CONSTRAINT "reqUserRoles_pkey" PRIMARY KEY ("roleId");


--
-- Name: reqUsers reqUsers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqUsers"
    ADD CONSTRAINT "reqUsers_pkey" PRIMARY KEY ("userId");


--
-- Name: reqinterviewDetails reqinterviewDetails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqinterviewDetails"
    ADD CONSTRAINT "reqinterviewDetails_pkey" PRIMARY KEY (id);


--
-- Name: reqreqruiterStationReports reqreqruiterStationReports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqreqruiterStationReports"
    ADD CONSTRAINT "reqreqruiterStationReports_pkey" PRIMARY KEY (id);


--
-- Name: reqworkModes reqworkModes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqworkModes"
    ADD CONSTRAINT "reqworkModes_pkey" PRIMARY KEY (id);


--
-- Name: reqServiceSequences after_insert_req_service_sequences; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_insert_req_service_sequences AFTER INSERT ON public."reqServiceSequences" FOR EACH ROW EXECUTE FUNCTION public.handle_req_service_sequences();


--
-- Name: reqServiceSequences after_update_req_service_sequences; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_update_req_service_sequences AFTER UPDATE ON public."reqServiceSequences" FOR EACH ROW EXECUTE FUNCTION public.handle_req_service_sequences();


--
-- Name: reqCandidates reqCandidates_candidateStation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidates"
    ADD CONSTRAINT "reqCandidates_candidateStation_fkey" FOREIGN KEY ("candidateStation") REFERENCES public."reqStations"("stationId");


--
-- Name: reqCandidates reqCandidates_candidatesAddingAgainst_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidates"
    ADD CONSTRAINT "reqCandidates_candidatesAddingAgainst_fkey" FOREIGN KEY ("candidatesAddingAgainst") REFERENCES public."reqServiceRequests"("requestId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reqCandidates reqCandidates_resumeSourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqCandidates"
    ADD CONSTRAINT "reqCandidates_resumeSourceId_fkey" FOREIGN KEY ("resumeSourceId") REFERENCES public."reqCandidateResumeSources"("sourceId");


--
-- Name: reqLogs reqLogs_fromStation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqLogs"
    ADD CONSTRAINT "reqLogs_fromStation_fkey" FOREIGN KEY ("fromStation") REFERENCES public."reqStations"("stationId");


--
-- Name: reqLogs reqLogs_serviceRequest_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqLogs"
    ADD CONSTRAINT "reqLogs_serviceRequest_fkey" FOREIGN KEY ("serviceRequest") REFERENCES public."reqServiceRequests"("requestId");


--
-- Name: reqLogs reqLogs_toStation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqLogs"
    ADD CONSTRAINT "reqLogs_toStation_fkey" FOREIGN KEY ("toStation") REFERENCES public."reqStations"("stationId");


--
-- Name: reqMultipleRoleAccesses reqMultipleRoleAccesses_roleAccessRoleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqMultipleRoleAccesses"
    ADD CONSTRAINT "reqMultipleRoleAccesses_roleAccessRoleId_fkey" FOREIGN KEY ("roleAccessRoleId") REFERENCES public."reqUserRoles"("roleId");


--
-- Name: reqServiceFlows reqServiceFlows_flowServiceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceFlows"
    ADD CONSTRAINT "reqServiceFlows_flowServiceId_fkey" FOREIGN KEY ("flowServiceId") REFERENCES public."reqServices"("sericeId");


--
-- Name: reqServiceFlows reqServiceFlows_flowStationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceFlows"
    ADD CONSTRAINT "reqServiceFlows_flowStationId_fkey" FOREIGN KEY ("flowStationId") REFERENCES public."reqStations"("stationId");


--
-- Name: reqServiceRequests reqServiceRequests_requestServiceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceRequests"
    ADD CONSTRAINT "reqServiceRequests_requestServiceId_fkey" FOREIGN KEY ("requestServiceId") REFERENCES public."reqServices"("sericeId");


--
-- Name: reqServiceRequests reqServiceRequests_requestTeam_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceRequests"
    ADD CONSTRAINT "reqServiceRequests_requestTeam_fkey" FOREIGN KEY ("requestTeam") REFERENCES public."reqTeams"("teamId");


--
-- Name: reqServiceSequencesAcitves reqServiceSequencesAcitves_serviceServiceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceSequencesAcitves"
    ADD CONSTRAINT "reqServiceSequencesAcitves_serviceServiceId_fkey" FOREIGN KEY ("serviceServiceId") REFERENCES public."reqServices"("sericeId");


--
-- Name: reqServiceSequencesAcitves reqServiceSequencesAcitves_serviceServiceRequst_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceSequencesAcitves"
    ADD CONSTRAINT "reqServiceSequencesAcitves_serviceServiceRequst_fkey" FOREIGN KEY ("serviceServiceRequst") REFERENCES public."reqServiceRequests"("requestId");


--
-- Name: reqServiceSequencesAcitves reqServiceSequencesAcitves_serviceStation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceSequencesAcitves"
    ADD CONSTRAINT "reqServiceSequencesAcitves_serviceStation_fkey" FOREIGN KEY ("serviceStation") REFERENCES public."reqStations"("stationId");


--
-- Name: reqServiceSequences reqServiceSequences_serviceServiceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceSequences"
    ADD CONSTRAINT "reqServiceSequences_serviceServiceId_fkey" FOREIGN KEY ("serviceServiceId") REFERENCES public."reqServices"("sericeId");


--
-- Name: reqServiceSequences reqServiceSequences_serviceServiceRequst_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceSequences"
    ADD CONSTRAINT "reqServiceSequences_serviceServiceRequst_fkey" FOREIGN KEY ("serviceServiceRequst") REFERENCES public."reqServiceRequests"("requestId");


--
-- Name: reqServiceSequences reqServiceSequences_serviceStation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqServiceSequences"
    ADD CONSTRAINT "reqServiceSequences_serviceStation_fkey" FOREIGN KEY ("serviceStation") REFERENCES public."reqStations"("stationId");


--
-- Name: reqinterviewDetails reqinterviewDetails_preferMode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqinterviewDetails"
    ADD CONSTRAINT "reqinterviewDetails_preferMode_fkey" FOREIGN KEY ("preferMode") REFERENCES public."reqworkModes"(id);


--
-- Name: reqreqruiterStationReports reqreqruiterStationReports_position_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqreqruiterStationReports"
    ADD CONSTRAINT "reqreqruiterStationReports_position_fkey" FOREIGN KEY ("position") REFERENCES public."reqServiceRequests"("requestId");


--
-- Name: reqreqruiterStationReports reqreqruiterStationReports_station_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reqreqruiterStationReports"
    ADD CONSTRAINT "reqreqruiterStationReports_station_fkey" FOREIGN KEY (station) REFERENCES public."reqStations"("stationId");


--
-- PostgreSQL database dump complete
--

