
const moment = require("moment");
const { Op } = require("sequelize");
const toDate = moment().format("YYYY-MM-DD");

const mailFunction = require("../utils/nodeMail");
const { tryCatch } = require("../utils/trycatch");
const candidateStation = require("../utils/commonFunction");
const jsonData = require("../utils/userRignts.json");
const { excelGenerator } = require("../utils/excelGenerator");

// Models
const {
  reqServiceSequence,
  reqServiceRequest,
  reqCandidates,
  reqServiceSequencesAcitve,
  sequelize,
  Sequelize,
  reqCandidateComments,
  reqStation,
  reqUser,
  reqReport,
  reqIntervieMode,
  reqTeam,
  reqExperienceReport,
  reqCandidateRequestion
} = require("../../models");

// Utility Functions
const {
  getNextStation,
  logFunction,
  updateReportData,
  profileSourceReport,
  reqcuriterReport,
  addExperiencInterviewScheduled,
  meetingLinkReplace,
} = require("../utils/commonFunction");


//assign the service and candidate to the screening station
exports.groupCandidate = tryCatch(async (req, res) => {
  let { serviceStation = 1, serviceServiceRequst, serviceCandidates, serviceAssignee, serviceDate, } = req.body;
  let toDate = moment().format("YYYY-MM-DD");

  let service = await reqServiceRequest.findOne({
    where: { requestId: serviceServiceRequst },
    raw: true,
  });

  if (!service)
    return res
      .status(401)
      .json({ result: false, message: "Not a valid request Id" });
  let serviceServiceId = service.requestServiceId;
  await Promise.all(
    serviceCandidates.map(async (element) => {
      let reqSequence = await reqServiceSequence.findOne({
        where: {
          serviceStation,
          serviceServiceRequst,
          serviceCandidate: element,
          serviceServiceId,
        },
      });
      if (!reqSequence) {
        await reqServiceSequence.create({
          serviceStation,
          serviceServiceRequst,
          serviceCandidate: element,
          serviceAssignee,
          serviceDate,
          serviceServiceId,
          insertOrUpdateDate: toDate,
        });
      }
    })
  );
  await candidateStation.updateCandidateStations(
    serviceStation,
    serviceCandidates
  );
  return res
    .status(200)
    .json({ result: true, message: "Candidates assigned to requirements" });

});

//--------------------------------------
exports.groupListsv1 = tryCatch(async (req, res) => {
  const { report, search, isActive, ids, priority, date } = req.query;
  const limit = parseInt(req.query.limit, 10) || 10;
  const page = parseInt(req.query.page, 10) || 1;
  const offset = (page - 1) * limit;

  const conditions = [];
  const replacements = {};

  if (ids) {
    conditions.push(`"requestId" IN (:ids)`);
    replacements.ids = ids.split(",");
  }

  if (isActive) {
    const statusMap = {
      active: `'active'`,
      pending: `'pending'`,
      closed: `'closed'`,
    };
    if (statusMap[isActive]) {
      conditions.push(`"requestStatus" = ${statusMap[isActive]}`);
    }
  }

  if (priority) {
    const priorityMap = {
      critical: `'critical'`,
      high: `'high'`,
      medium: `'medium'`,
      low: `'low'`,
    };
    if (priorityMap[priority]) {
      conditions.push(`"requestPriority" = ${priorityMap[priority]}`);
    }
  }

  if (search) {
    conditions.push(`(
      "requestName" ILIKE :search OR 
      "requestCode" ILIKE :search
    )`);
    replacements.search = `%${search}%`;
  }

  const orderBy = date === "false"
    ? `"requestDate" ASC`
    : date === "true"
      ? `"requestDate" DESC`
      : `CASE 
        WHEN "requestPriority" = 'critical' THEN 1 
        WHEN "requestPriority" = 'high' THEN 2 
        WHEN "requestPriority" = 'medium' THEN 3
        WHEN "requestPriority" = 'low' THEN 4
        ELSE 5
      END`;

  const whereClause = conditions.length ? `WHERE ${conditions.join(" AND ")}` : "";

  const query = `
    WITH requestion_filter AS (
      SELECT 
        "requestId", "requestName", "requestSkills", "requestDate", 
        "requestTeam", "requestCode", "teamId", "teamName",
        "requestStatus" AS "status", "requestVacancy", "requestHiredCount",
        CONCAT("userfirstName", ' ', "userlastName") AS assignTo,
        "requestPriority",
        (
          SELECT COUNT("candidateId") 
          FROM "reqCandidates" 
          INNER JOIN "reqServiceSequences" ON "serviceCandidate" = "candidateId" 
          WHERE "serviceServiceRequst" = "requestId" 
          AND ("serviceStation" = '1' OR "serviceStation" IS NULL)
        ) AS "candidatesCount"
      FROM "reqServiceRequests" AS "service"
      INNER JOIN "reqTeams" ON "service"."requestTeam" = "teamId"
      LEFT JOIN "reqServiceSequences" AS "sequence" ON "sequence"."serviceServiceRequst" = "service"."requestId"
      LEFT JOIN "reqUsers" ON "reqUsers"."userId" = "service"."requestAssignTo" 
      ${whereClause}
      GROUP BY "requestId", "requestName", "requestSkills", "requestTeam", 
               "requestCode", "requestDate", "teamId", "teamName",
               "requestStatus", "requestVacancy", "requestHiredCount", 
               "userfirstName", "userlastName", "requestPriority"
      ORDER BY ${orderBy}
    )
    SELECT *, COUNT(*) OVER() AS total_count FROM requestion_filter  
    ${report === "true" ? "" : `LIMIT :limit OFFSET :offset`};
  `;

  if (report !== "true") {
    replacements.limit = limit;
    replacements.offset = offset;
  }

  const [candidates] = await sequelize.query(query, { replacements });

  if (report === "true" && candidates.length) {
    const headers = [
      { header: "Id", key: "requestId", width: 5 },
      { header: "Name", key: "requestName", width: 10 },
      { header: "Team", key: "teamName", width: 15 },
      { header: "Status", key: "status", width: 15 },
      { header: "No. Vacancy", key: "requestVacancy", width: 25 },
      { header: "Hired Count", key: "requestHiredCount", width: 25 },
      { header: "Assign To", key: "assignTo", width: 25 },
      { header: "Priority", key: "requestPriority", width: 25 },
      { header: "Candidate Count", key: "candidatesCount", width: 25 },
    ];

    const body = candidates.map((candidate) => ({
      requestId: candidate.requestId,
      requestName: candidate.requestName,
      teamName: candidate.teamName,
      status: candidate.status,
      requestVacancy: candidate.requestVacancy,
      requestHiredCount: candidate.requestHiredCount,
      assignTo: candidate.assignTo,
      requestPriority: candidate.requestPriority,
      candidatesCount: candidate.candidatesCount,
    }));

    const fileName = `requestion_report_${moment().format("YYYYMMDD_HHmmss")}`;
    return excelGenerator(req, res, headers, body, fileName);
  }

  return res.status(200).json({
    result: true,
    message: candidates.length ? "Station One Candidates Found" : "No Candidates Found",
    candidates,
    totalCount: candidates[0]?.total_count || 0,
  });
});

//verifiy and move the service to next station
exports.acceptCandidateService = tryCatch(async (req, res) => {

  let toDayDate = moment().format("YYYY-MM-DD");
  let { serviceIds, requestId } = req.body;
  let serviceIndex = serviceIds.length - 1;
  let userId = req.userId;
  let numberOfCandidates = serviceIds.length;
  await interviewScheduledCount(
    userId,
    requestId,
    toDate,
    numberOfCandidates
  );
  for (let index in serviceIds) {
    let serviceId = serviceIds[index];
    let serviceSeqence = await reqServiceSequence.findOne({
      where: { serviceId, serviceStatus: "pending" },
      raw: true,
    });
    if (!serviceSeqence)
      return res
        .status(401)
        .json({ result: false, message: "Service request Not found" });

    delete serviceSeqence.serviceId;
    let updatedData = await reqServiceSequence.update(
      { serviceStatus: "done", insertOrUpdateDate: toDayDate },
      { where: { serviceId } }
    );
    serviceSeqence.serviceStation = await getNextStation(
      serviceSeqence.serviceStation,
      serviceSeqence.serviceServiceId
    );
    serviceSeqence.insertOrUpdateDate = toDayDate;
    if (updatedData[0]) {
      let nextStationSequeence = await reqServiceSequence.create(
        serviceSeqence
      );
      if (nextStationSequeence && index == serviceIndex)
        return res.status(200).json({
          result: true,
          message: "Approve and Move to next station",
        });
    }
  }
});

exports.batchCandidates = tryCatch(async (req, res) => {

  let requestId = req.params.requestId;
  let search = req.query.search;
  let station = req.query.station || 1;
  let limit = req.query.limit || 10;
  let offset = req.query.page || 0;
  let experience = req.query.experience;

  let candidateWhere = { where: {} };
  if (experience) candidateWhere.where = { candidateExperience: experience };
  offset = offset == 1 ? 0 : offset;
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }
  let where = { serviceServiceRequst: requestId };
  if (station == 2) {
    where.serviceStation = station;
  } else {
    where[Op.or] = [{ serviceStation: station }, { serviceStation: { [Op.is]: null } }];
  }
  if (search) {
    candidateWhere.where = {
      [Op.or]: [
        { candidateFirstName: { [Op.iLike]: `${search}%` } },
        { candidateEmail: { [Op.iLike]: `${search}%` } },
        { candidateMobileNo: { [Op.iLike]: `${search}%` } },
        { candidatePreviousOrg: { [Op.iLike]: `${search}%` } },
      ],
    };
  }

  if (station == 2) {
    where.serviceId = {
      [Sequelize.Op.notIn]: Sequelize.literal(
        '(SELECT "progressServiceSequence" From "reqCandidateProgresses" WHERE "progressStation"=2)'
      ),
    };
  }

  let candidates = await reqCandidates.findAll({
    attributes: [
      "candidateId",
      "candidateFirstName",
      "candidateLastName",
      "candidateExperience",
      "candidatePreviousOrg",
      "candidatePreviousDesignation",
      "candidateResume",
      "candidateGender",
      "candidateInterviewStatus",
      "candidateEmail",
      "candidatesAddingAgainst",
      "candidateCity",
      "candidateEducation",
      "candidateTotalExperience",
      "candidateRevlentExperience",
      "candidateNoticePeriodByDays"
    ],
    include: [
      {
        model: reqServiceSequence,
        as: "serviceSequence",
        required: true,
        where,
        attributes: [
          "serviceId",
          "serviceCandidate",
          "serviceStation",
          "serviceStatus",
          // "interviewRescheduledCount",
          [
            sequelize.literal(
              '(SELECT SUM("interviewRescheduledCount") FROM "reqServiceSequences" WHERE "serviceCandidate"="serviceSequence"."serviceCandidate")'
            ),
            "interviewRescheduledCount",
          ],
        ],
        order: [["serviceId", "DESC"]],
        include: [{
          model: reqServiceRequest,
          attributes: ["requestName"],
          as: "serviceRequest",
          include: { model: reqTeam, as: "team", attributes: ["teamName"] },
        },]
      },

    ],
    raw: true,
    where: candidateWhere.where,
    limit,
    offset,

  });

  let candidateCount = await reqCandidates.count({
    include: [
      {
        model: reqServiceSequence,
        as: "serviceSequence",
        required: true,
        where,
      },
      {
        model: reqServiceRequest,
        include: { model: reqTeam, as: "team" },
      },
    ],
    where: candidateWhere.where,
  });

  candidates = await Promise.all(
    candidates.map(async (element) => {
      element.serviceId = element["serviceSequence.serviceId"];
      element.serviceStatus =
        element["serviceSequence.serviceStatus"] == "sourced"
          ? "pending"
          : element["serviceSequence.serviceStatus"];
      element.requestName = element["reqServiceRequest.requestName"];
      element.rescheduledCount =
        element["serviceSequence.interviewRescheduledCount"];
      element.interviewStatus = "scheduled";
      let [data, metadata] = await sequelize.query(
        `SELECT *  FROM "reqCandidateSkills" INNER JOIN "reqSkills" ON "candidateSkillId"="reqSkills"."id" WHERE "candidateId"=${element.candidateId}`
      );
      element.candidateSkills = data;
      return element;
    })
  );
  if (candidates)
    return res.status(200).json({
      result: true,
      message: "batch candidates",
      candidates: candidates,
      candidateCount,
    });
  return res
    .status(401)
    .json({ result: false, message: "batch candidates Not Found" });
});

exports.interviewDetail = tryCatch(async (req, res) => {
  let { recruiterId, candidateId, noticePeriod, location, interviewTime, interViewPanel,
    interviewMode, rescheduleStatus, comments, position, serviceId, workMode, station,
    interviewCc, interviewMailTemp, interviewSubject, interviewBcc, attachmentArray } = req.body;

  let todate = moment().format("YYYY-MM-DD");
  let logData = {
    station,
    senderId: recruiterId,
    reciverId: candidateId,
    type: "",
  };
  let status = "shorted";
  let serviceRequest = position;
  let candidate = await reqCandidates.findOne({
    where: { candidateId: candidateId },
  });
  if (!candidate)
    return res
      .status(401)
      .json({ result: false, message: "Candidate Not found" });
  let service = await reqServiceRequest.findOne({
    where: { requestId: position },
    raw: true,
  });
  if (!service)
    return res
      .status(401)
      .json({ result: false, message: "Not a valid position Id" });

  let interviewCcAttendee = Array.isArray(interviewCc) && interviewCc.length > 0
    ? interviewCc.map(el => ({ email: el }))
    : [];

  let interviewBccAttendee = Array.isArray(interviewBcc) && interviewBcc.length > 0
    ? interviewBcc.map(el => ({ email: el }))
    : [];

  // Merging all attendees into one array, handling empty arrays
  let attendees = [{ email: candidate.candidateEmail }, ...interviewCcAttendee, ...interviewBccAttendee];

  interviewMailTemp = await meetingLinkReplace(interviewMailTemp, interviewTime, attendees);
  if (serviceId) {
    //if true update interview //for already updated candidate
    await updateExperiencInterviewReScheduled(position, 1); //for experience count
    position = service.requestServiceId;
    let interviewDetail = await reqServiceSequence.update(
      {
        serviceAssignee: interViewPanel,
        serviceDate: interviewTime,
        serviceServiceRequst: serviceRequest,
        serviceServiceId: position,
        serviceStation: station,
        serviceScheduledBy: recruiterId,
        interviewLocation: location,
        interviewMode,
        interviewRescheduled: true,
        interviewRescheduledCount: Sequelize.literal(
          '"interviewRescheduledCount" + 1'
        ),
        interviewMail: true,
        interviewMailType: "re-scheduled-mail",
        insertOrUpdateDate: todate,
      },
      { where: { serviceCandidate: candidateId, serviceId: serviceId } }
    );

    await interviewReScheduledCountfn(recruiterId, position, toDate, 1);
    //to add comment on creating interview
    if (comments) {
      await reqCandidateComments.update(
        { commentComment: comments },
        { where: { commentSeqenceId: serviceId } }
      );
    }
    let updateQueryString = "";
    let replacementValue = {
      status,
      candidateId,
    };
    if (noticePeriod) {
      updateQueryString = ' "candidateNoticePeriodByDays"=:noticePeriod ';
      replacementValue.noticePeriod = noticePeriod;
    }
    if (workMode) {
      updateQueryString = updateQueryString + `,"workMode"=:workMode`;
      replacementValue.workMode = workMode;
    }
    let updatedStation = await sequelize.query(
      `UPDATE "reqCandidates" SET ${updateQueryString ? updateQueryString + "," : ""
      } "candidateInterviewStatus"=:status WHERE "candidateId"=:candidateId`,
      {
        replacements: replacementValue,
      }
    );
    logData.type = `Interview Re-Scheduled Mail send in ${jsonData.stationList[station]}`;
    await mailFunction.sendEmail(
      candidate.candidateEmail,
      interviewSubject,
      interviewMailTemp,
      interviewCc,
      interviewBcc,
      attachmentArray,
      logData
    );
    await updateReportData("interviewReScheduled", recruiterId, position);
    logFunction(candidateId, recruiterId, `Interview Re-Scheduled in ${jsonData.stationList[station]}`, station);
    return res
      .status(200)
      .json({ result: true, message: "interview Re-Scheduled" });
  } else {
    await updateReportData("candidateContacted", recruiterId, position);
    await updateReportData("candidatesIntrested", recruiterId, position);
    let sequenceWIthoutStation = await reqServiceSequence.findOne({
      where: {
        serviceCandidate: candidateId,
        serviceStatus: { [Op.notIn]: ["done", "rejected"] },
        serviceStation: { [Op.is]: null },
      },
      raw: true,
    });

    if (sequenceWIthoutStation) {
      await updateReportData("interviewScheduled", recruiterId, position);
      // await interviewScheduledCount(recruiterId, position, toDate, 1);
      await addExperiencInterviewScheduled(position, 1);
      position = service.requestServiceId;

      //update the soursed candidates sequence status to done
      var interviewDetail = await reqServiceSequence.update(
        {
          serviceAssignee: interViewPanel,
          serviceDate: interviewTime,
          serviceServiceRequst: serviceRequest,
          serviceServiceId: position,
          serviceStation: 1,
          serviceScheduledBy: recruiterId,
          serviceStatus: "done",
          interviewLocation: location,
          interviewMode,
          insertOrUpdateDate: todate,
        },
        { where: { serviceId: sequenceWIthoutStation.serviceId } }
      );

      if (comments) {
        await reqCandidateComments.create({
          commentSeqenceId: sequenceWIthoutStation.serviceId,
          commentComment: comments,
          commentUserId: recruiterId,
        });
      }

      let nextStation = await getNextStation(1, position);
      //create the next station entry in sequence
      if (interviewDetail)
        await reqServiceSequence.create({
          serviceCandidate: candidateId,
          serviceAssignee: interViewPanel,
          serviceDate: interviewTime,
          serviceServiceRequst: serviceRequest,
          serviceServiceId: position,
          serviceStation: nextStation,
          serviceScheduledBy: recruiterId,
          interviewLocation: location,
          interviewMode,
          interviewRescheduled: rescheduleStatus,
          interviewMail: true,
          interviewMailType: "scheduled-mail",
          insertOrUpdateDate: todate,
        });

      let updatedStation = await sequelize.query(
        `UPDATE "reqCandidates" SET "candidateNoticePeriodByDays"=:noticePeriod,"candidateStation"=:candidateStation,"candidateInterviewStatus"=:status,"workMode"=:workMode  WHERE "candidateId"=:candidateId`,
        {
          replacements: {
            noticePeriod,
            candidateStation: nextStation,
            status,
            workMode,
            candidateId,
          },
        }
      );
      logData.type = `Interview Scheduled Mail send in ${jsonData.stationList[station]}`;
      await mailFunction.sendEmail(
        candidate.candidateEmail,
        interviewSubject,
        interviewMailTemp,
        interviewCc,
        interviewBcc,
        attachmentArray,
        logData
      );
      logFunction(
        candidateId,
        recruiterId,
        `Interview Scheduled in ${jsonData.stationList[station]}`,
        station
      );

      if (updatedStation)
        return res
          .status(200)
          .json({ result: true, message: "interview Added" });
    } else {
      return res
        .status(401)
        .json({ result: false, message: "already sheduled" });
    }
  }
});

exports.interviewDetailCandidatesList = tryCatch(async (req, res) => {
  let scheduleStatus = req.query.scheduleStatus;

  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  let experience = req.query.exprience;
  let search = req.query.search;
  let serviceRequestId = req.query.serviceRequestId;
  if (!serviceRequestId)
    return res
      .status(401)
      .json({ result: false, message: "serviceRequestId is mandatory" });
  let where = {};
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }
  where.candidatesAddingAgainst = { [Op.eq]: serviceRequestId };
  if (scheduleStatus == "true") {
    where.candidateInterviewStatus = "pending";
  } else {
    where.candidateInterviewStatus != "done";
    where.candidateStation = { [Op.or]: [null, 1, 2] };
  }
  if (experience) {
    if (experience == 0) {
      where.candidateExperience = { [Op.eq]: experience };
    } else {
      where.candidateExperience = { [Op.gte]: experience };
    }
  }

  if (search) {
    where[Op.or] = [
      { candidateFirstName: { [Op.iLike]: `${search}%` } },
      { candidateEmail: { [Op.iLike]: `${search}%` } },
      { candidateMobileNo: { [Op.iLike]: `${search}%` } },
      { candidatePreviousOrg: { [Op.iLike]: `${search}%` } },
    ];
  }
  let candidateCount = await reqCandidates.count({ where });
  let candidates = await reqCandidates.findAll({
    attributes: [
      "candidateId",
      "candidateFirstName",
      "candidateLastName",
      "candidateEmail",
      "candidateMobileNo",
      "candidateExperience",
    ],
    where,
    limit: limit,
    offset: offset,
    order: [["candidateId", "DESC"]],
  });
  if (candidates)
    return res.status(200).json({
      result: true,
      message: "Candidates found",
      candidateCount,
      candidates,
    });
  throw new Error("Candidates not found");
});

exports.interviewDetailCandidateView = tryCatch(async (req, res) => {
  let candidateId = req.query.candidateId;
  let serviceId = req.query.serviceId;

  if (!candidateId) {
    return res
      .status(401)
      .json({ result: false, message: "candidateId field is mandatory" });
  }
  let candidateStatus = await reqServiceSequence.findAll({
    include: [
      { model: reqStation },
      { model: reqCandidateComments, attributes: ["commentComment"] },
      { model: reqUser, attributes: [["userfirstName", "pannelName"]] }
    ], //{ model: reqinterviewDetail, attributes: ['interviewLocation', 'interviewMode', 'interviewStatus', 'candidateStatus', 'rescheduleStatus'] }],
    where: { serviceCandidate: candidateId, serviceId },
    order: [["serviceStation", "DESC"]],
    raw: true,
    limit: 1,
  });

  candidateStatus = await Promise.all(
    candidateStatus.map(async (el) => {
      let status = "Not yet Schedule";
      if (el["interviewRescheduled"]) {
        status = "re-scheduled";
      } else {
        status = "scheduled";
      }
      el.interviewStatus = status;
      el.comment = el["reqCandidateComment.commentComment"];

      return el;
    })
  );
  let [candidate, metadata] = await sequelize.query(`SELECT
        "reqCandidates"."candidateId",
        "reqCandidates"."candidateFirstName" ||' '|| "reqCandidates"."candidateLastName" AS "candidateName",
        "reqCandidates"."candidateFirstName",
        "reqCandidates"."candidateLastName",
        "reqCandidates"."candidateExperience",
        "reqCandidates"."candidatePreviousOrg",
        "reqCandidates"."candidatePreviousDesignation",
        "reqCandidates"."candidateEmail",
        "reqCandidates"."candidateStation",
        "reqCandidates"."candidateNoticePeriodByDays",
        "reqCandidates"."candidateRevlentExperience",
        "reqCandidates"."candidateTotalExperience"
      FROM
        "reqCandidates" AS "reqCandidates"
      WHERE 
      "reqCandidates"."candidateId"=${candidateId}
      GROUP BY
        "reqCandidates"."candidateId",
        "candidateName",
        "reqCandidates"."candidateFirstName",
        "reqCandidates"."candidateLastName",
        "reqCandidates"."candidateExperience",
        "reqCandidates"."candidatePreviousOrg",
        "reqCandidates"."candidatePreviousDesignation",
        "reqCandidates"."candidateEmail",
        "reqCandidates"."candidateStation",
        "reqCandidates"."candidateNoticePeriodByDays",
        "reqCandidates"."candidateRevlentExperience",
        "reqCandidates"."candidateTotalExperience"`);
  if (candidate)
    return res.status(200).json({
      result: true,
      message: "Candidates found",
      candidate,
      candidateStatus,
    });
  return res
    .status(401)
    .json({ result: true, message: "Candidates not found" });
});

async function interviewScheduledCount(
  userId,
  position,
  date,
  numberOfCandidates
) {
  try {
    let targetDate = new Date(date);
    let where = {
      recruiter: userId,
      position: position,
      date: {
        [Op.between]: [
          targetDate.toISOString(),
          new Date(targetDate.getTime() + 24 * 60 * 60 * 1000).toISOString(),
        ],
      },
    };

    let getIntervieExistCount = await reqReport.findOne({
      attributes: ["interviewScheduled", "id"],
      raw: true,
      where,
    });
    if (getIntervieExistCount?.interviewScheduled > -1) {
      let totalScheduledCount =
        getIntervieExistCount.interviewScheduled + numberOfCandidates;
      let updatedReport =
        await sequelize.query(`UPDATE "reqReports" SET "interviewScheduled"=${totalScheduledCount},"interviewConducted"=${totalScheduledCount} WHERE "position"=${position} AND "recruiter"=${userId} AND
            "id"=${getIntervieExistCount.id};`);
    } else {
      await sequelize.query(
        `INSERT INTO "reqReports"("interviewScheduled","position","recruiter","date") VALUES(${1},${position},${userId},${targetDate.toISOString()})`
      );
    }
  } catch (error) {
    console.log(error);
  }
}

async function updateExperiencInterviewReScheduled(position, count) {
  try {
    let getPosition = await reqExperienceReport.findOne({
      where: { technology: position },
    });
    if (getPosition) {
      await reqExperienceReport.update(
        { rescheduleStatusCount: count + getPosition.rescheduleStatusCount },
        { where: { technology: position } }
      );
    } else {
      await reqExperienceReport.create({
        technology: position,
        rescheduleStatusCount: 1,
      });
    }
  } catch (error) {
    console.log(error);
  }
}


async function interviewReScheduledCountfn(
  userId,
  position,
  date,
  numberOfCandidates
) {
  try {
    let targetDate = new Date(date);
    let where = {
      recruiter: userId,
      position: position,
      date: {
        [Op.between]: [
          targetDate.toISOString(),
          new Date(targetDate.getTime() + 24 * 60 * 60 * 1000).toISOString(),
        ],
      },
    };
    let getIntervieExistCount = await reqReport.findOne({
      attributes: ["interviewReScheduled"],
      where,
      raw: true,
    });
    if (getIntervieExistCount?.interviewReScheduled > -1) {
      let totalReScheduledCount =
        getIntervieExistCount.interviewReScheduled + numberOfCandidates;
      let updatedReport =
        await sequelize.query(`UPDATE "reqReports" SET "interviewReScheduled"=${totalReScheduledCount} WHERE "position"=${position} AND "recruiter"=${userId} AND
            "date" >= '${targetDate.toISOString()}' AND "date" <= '${new Date(
          targetDate.getTime() + 24 * 60 * 60 * 1000
        ).toISOString()}';`);
    }
  } catch (error) {
    console.log(error);
  }
}

exports.interviewModeList = tryCatch(async (req, res) => {
  let interviewModeList = await reqIntervieMode.findAll({ raw: true });
  return res.status(200).json({
    result: true,
    message: "data retrived",
    data: interviewModeList,
  });
});


exports.candidateMapRequirement = tryCatch(async (req, res) => {
  let candidatesId = req.body.candidatesId;
  let requiementId = req.body.requirementId;
  let candidateCreatedby = req.body.userId;
  let resumeSourceId = req.body.resumeSource;

  let addCandidateRequirement = await reqCandidates.update(
    { candidatesAddingAgainst: requiementId },
    { where: { candidateId: { [Op.in]: candidatesId } } }
  );
  await reqServiceSequence.update(
    { serviceServiceRequst: requiementId, serviceStatus: "pending", serviceStation: 1, serviceScheduledBy: candidateCreatedby },
    { where: { serviceCandidate: { [Op.in]: candidatesId } } }
  );
  if (addCandidateRequirement) {
    await profileSourceReport(
      candidateCreatedby,
      requiementId,
      resumeSourceId, moment().format("YYYY-MM-DD")
    );
    candidatesId.forEach((element) => {
      logFunction(element, candidateCreatedby, `Candidate mapped `, 1);
      reqcuriterReport(
        requiementId,
        moment().format("YYYY-MM-DD"),
        candidateCreatedby,
        "totalSourced"
      );
    });
    return res.status(200).json({
      result: true,
      message: "Requirement maped against candidate's",
    });
  }
  return res.status(401).json({
    result: false,
    message: "something went wrong on mapping requirement",
  });
});


exports.candidateMapRequirementv1 = tryCatch(async (req, res) => {
  let today = moment().format("YYYY-MM-DD");
  const sixMonthsAgo = moment().add(6, "months").toDate();

  let bypassing = req.body.bypassing || false;
  let candidates = req.body.candidates;
  let requiementId = req.body.requirementId;
  let candidateCreatedby = req.body.userId;

  const candidatesAginstRequest = [];
  const candidatesIds = [];
  const existingCandidateRequestions = [];
  const newMappings = [];

  for (let el of candidates) {

    const lastMapping = await reqServiceSequence.findOne({
      where: {
        serviceCandidate: el.candidatesId,
        serviceServiceRequst: requiementId
      },
      order: [["insertOrUpdateDate", "DESC"]]
    });

    const existingCandidateRequestion = await reqCandidateRequestion.findOne({
      where: {
        candidateId: el.candidatesId,
        serviceRequest: requiementId
      }, raw: true
    });

    if (!lastMapping) {
      newMappings.push({
        serviceCandidate: el.candidatesId,
        serviceServiceRequst: requiementId,
        serviceAssignee: candidateCreatedby,
        serviceStatus: "pending",
        insertOrUpdateDate: today,
        serviceSourceDate: today
      })
    }

    let allowMapping = false;

    if (bypassing) {
      allowMapping = true;
    }
    else if (
      !lastMapping ||
      moment(lastMapping.insertOrUpdateDate).add(6, "months").isBefore(today)
    ) {
      allowMapping = true;
    }

    if (allowMapping) {
      candidatesAginstRequest.push({
        candidateId: el.candidatesId,
        serviceRequest: requiementId
      });
      existingCandidateRequestion && existingCandidateRequestions.push(existingCandidateRequestion);
      candidatesIds.push(el.candidatesId);
    }
  }

  const existingCandidateIds = existingCandidateRequestions.map(
    e => e?.candidateId
  );

  const insertedItems = await reqCandidateRequestion.bulkCreate(
    candidatesAginstRequest.filter(({ candidateId }) => !existingCandidateIds.includes(candidateId)),
    { raw: true }
  );

  const addCandidateRequirement = [...insertedItems, ...existingCandidateRequestions];

  const insertedCandidatesIds = addCandidateRequirement
    .filter(item => item.candidateRequestId != null)
    .map(item => item.candidateId);

  await reqServiceSequence.update(
    {
      // serviceServiceRequst: requiementId,
      serviceStatus: "pending",
      insertOrUpdateDate: today,
      serviceScheduledBy: candidateCreatedby
    },
    { where: { serviceCandidate: { [Op.in]: candidatesIds }, serviceServiceRequst: requiementId } }
  );

  if (newMappings.length) {
    await reqServiceSequence.destroy({
      where: {
        serviceCandidate: { [Op.in]: candidatesIds },
        serviceServiceRequst: { [Op.is]: null },
        serviceStatus: "sourced"
      }
    });
    await reqServiceSequence.bulkCreate(newMappings);
  }

  if (insertedCandidatesIds.length) {
    let reSourcesIds = [];
    await insertedCandidatesIds.map(async (element) => {
      logFunction(
        element.candidatesId,
        candidateCreatedby,
        `Candidate mapped `,
        1
      );
      reSourcesIds.push(element.resumeSource);
    });
    await profileSourceReport(candidateCreatedby, requiementId, reSourcesIds);

    reqcuriterReport(
      requiementId,
      moment().format("YYYY-MM-DD"),
      candidateCreatedby,
      "totalSourced",
      insertedCandidatesIds.length
    );

    return res.status(200).json({
      result: true,
      message: "Requirement mapped against candidates"
    });

  } else {
    return res.status(401).json({
      result: false,
      message: "Candidates cannot be mapped within 6 months"
    });
  }
});

exports.toDateInterviewList = tryCatch(async (req, res) => {

  let { fromDateData, toDateData, search, status_filter: statusFilter, position, limit = 100, offset = 0, ids, experience } = req.query;

  let fromDate = `${fromDateData} 00:00:00+05:30`;
  let toDate = `${toDateData} 23:59:59+05:30`;

  // let fromDate = moment().subtract(7, 'days').format("YYYY-MM-DD 00:00:00+05:30"); // 7 days before today

  // Handle pagination
  offset = offset == 1 || offset == 0 ? 0 : (offset - 1) * limit;

  let where = {};
  let searchCondition = {};

  // Filter by experience
  if (experience) {
    searchCondition.candidateRevlentExperience = { [Op.lte]: experience };
    searchCondition.candidateTotalExperience = { [Op.gte]: experience };
  }

  // Filter by date
  where.serviceDate = { [Op.between]: [fromDate, toDate] };


  // Filter by search
  if (search) {
    searchCondition[Op.or] = [
      { candidateFirstName: { [Op.iLike]: `${search}%` } },
      { candidateLastName: { [Op.iLike]: `${search}%` } },
      { candidateEmail: { [Op.iLike]: `${search}%` } },
    ];
  }

  // Filter by ids
  if (ids?.length) {
    ids = Array.isArray(ids) ? ids : [ids];
    where.serviceScheduledBy = { [Op.in]: ids };
  }

  // Filter by status and position
  if (statusFilter) where.serviceStatus = statusFilter;
  if (position) where.serviceServiceRequst = position;
  let candidates = await reqServiceSequencesAcitve.findAll({
    attributes: {
      include: [
        [
          sequelize.literal(`(SELECT COUNT(*)
                    FROM "reqCandidateProgresses" AS "progress" WHERE "progress"."progressServiceSequence"="reqServiceSequencesAcitve"."serviceId")`),
          "progressStatus",
        ],
        [
          sequelize.literal(`(SELECT "stationName"
                                FROM "reqServiceSequencesAcitves" AS "sequence" INNER JOIN "reqStations" ON "stationId"="serviceStation" WHERE "sequence"."serviceCandidate"="reqServiceSequencesAcitve"."serviceCandidate" ORDER BY "serviceId" DESC LIMIT 1)`),
          "currentStation",
        ],
      ],
    },
    include: [
      {
        model: reqServiceRequest,
        as: "serviceRequest",
        required: true,
      }, { model: reqUser, as: "scheduledBy", attributes: ["userfirstName", "userlastName"] },
      {
        model: reqCandidates,
        attributes: {
          exclude: [
            "createdAt",
            "updatedAt",
            "candidateStatus",
            "candidateCreatedby",
            "candidateStation",
            "candidateHireRole",
            "resumeSourceId",
          ],
        },
        as: "candidate",
        required: true,
        where: searchCondition,
      },
    ],
    raw: true,
    limit: limit,
    offset: offset,
    where,
    order: [["serviceId", "DESC"]],
  });

  let totalCount = await reqServiceSequencesAcitve.count({ where });

  if (candidates)
    return res.status(200).json({
      result: true,
      message: "Candidates Found",
      candidates,
      totalCount,
    });
  return res
    .status(401)
    .json({ result: false, message: "Candidates Not Found" });
});

exports.removeAfterMapped = tryCatch(async (req, res) => {
  let serviceId = req.query.serviceId;
  let candidateId = req.query.candidateId;

  let isServiceSquence = await reqServiceSequence.findOne({ where: { serviceId, serviceCandidate: candidateId, serviceStatus: { [Op.ne]: null } } });
  if (!isServiceSquence) res
    .status(400)
    .json({ result: false, message: "Candidates Not Found" });

  await reqServiceSequence.update(
    {
      serviceStatus: null,
      serviceServiceRequst: null,
      serviceAssignee: null,
      serviceScheduledBy: null
    },
    { where: { serviceId } }
  );
  let addCandidateRequirement = await reqCandidates.update(
    { candidatesAddingAgainst: null },
    { where: { candidateId: candidateId } }
  );

  if (addCandidateRequirement) return res
    .status(201)
    .json({ result: true, message: "Candidate removed from mapping list" });

});

exports.candidatesPrgressList = tryCatch(async (req, res) => {
  let candidateId = req.query.candidateId;
  if (!candidateId) return res
    .status(400)
    .json({ result: false, message: "Candidate id is Mandatory" });
  let excludeData = ["createdAt",
    "updatedAt",
    "candidateStatus",
    "candidateCreatedby",
    "candidateStation",
    "candidateHireRole",
    "resumeSourceId"];
  if (req.userRole == 'visitor') {
    excludeData.push("candidateCurrentSalary", "candidateExpectedSalary");
  }
  let candidates = await reqServiceSequencesAcitve.findAll({
    attributes: {
      include: [
        [
          sequelize.literal(`(SELECT COUNT(*)
                    FROM "reqCandidateProgresses" AS "progress" WHERE "progress"."progressServiceSequence"="reqServiceSequencesAcitve"."serviceId")`),
          "progressStatus",
        ],
        [
          sequelize.literal(`(SELECT "stationName"
                    FROM "reqServiceSequencesAcitves" AS "sequence" INNER JOIN "reqStations" ON "stationId"="serviceStation" WHERE "sequence"."serviceCandidate"="reqServiceSequencesAcitve"."serviceCandidate" ORDER BY "serviceId" DESC LIMIT 1)`),
          "currentStation",
        ],
        [
          sequelize.literal(`(SELECT "stationName" AS "name"
                    FROM "reqStations" INNER JOIN "reqServiceSequencesAcitves" ON "stationId"="serviceStation" WHERE "reqServiceSequencesAcitve"."serviceId"="serviceId")`),
          "stationNam",
        ],
        [
          sequelize.literal(`(SELECT COUNT(*)
                    FROM "reqCandidateProgresses" AS "review" WHERE "review"."progressServiceSequence"="reqServiceSequencesAcitve"."serviceId" AND "review"."progressStation"=5)`),
          "reviewStatus",
        ]
      ],
    },
    include: [
      {
        model: reqServiceRequest,
        as: "serviceRequest",
        required: true,
      },
      {
        model: reqCandidates,
        attributes: {
          exclude: excludeData,
        },
        as: "candidate",
        required: true,
      },
    ],
    raw: true,
    where: { serviceCandidate: candidateId },
    order: [["serviceId", "DESC"]],
  });

  if (candidates)
    return res.status(200).json({
      result: true,
      message: "Candidate Deatail Found",
      candidates,
    });
  return res
    .status(401)
    .json({ result: false, message: "Technical Candidates Not Found" });
});
