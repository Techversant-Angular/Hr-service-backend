const moment = require("moment");
let { Op } = require("sequelize");
const { tryCatch } = require("../utils/trycatch");
let { excelGenerator } = require("../utils/excelGenerator");
let { getLastSixMonths } = require("../utils/commonFunction");
let { reqCandidates, reqTeam, sequelize, reqUser, reqReport,
  reqServices, reqServiceSequence, reqServiceRequest } = require("../../models");
let { sendFeedbackReminder } = require("../utils/commonFunction");

exports.resumeSourceData = tryCatch(async (req, res) => {
  let request = req.query.requestId
    ? ` AND "candidatesAddingAgainst"=${req.query.requestId} `
    : "";
  let fromDate = req.query.fromDate || moment().format("YYYY-MM-DD");
  let toDate = req.query.toDate || moment().format("YYYY-MM-DD");
  toDate = toDate + " 23:59:59";
  let userId = req.userId;
  let userCondidtion = "";
  if (userId) {
    userCondidtion = ` AND "serviceScheduledBy"=${userId}	`;
  }
  // return
  let [results, metadata] =
    await sequelize.query(`SELECT  "sourceId","sourceName", COUNT("resumeSourceId") AS sourceCount FROM public."reqCandidateResumeSources" 
      INNER JOIN public."reqCandidates" ON "resumeSourceId" = "sourceId" INNER JOIN "reqServiceSequences" ON "serviceCandidate"="candidateId" 
      WHERE ("serviceStation"=1 OR "serviceStation" IS NULL) ${userCondidtion} AND  "insertOrUpdateDate" BETWEEN '${fromDate}' AND '${toDate}' ${request} 
      GROUP BY  "sourceId", "sourceName";`);
  return res
    .status(200)
    .json({ result: true, message: "data retrived", data: results });
});


exports.interViewCounts = tryCatch(async (req, res) => {
  if (!req.query.fromDate || !req.query.toDate)
    return res.status(401).json({
      result: false,
      message: "from date and to date are mandatory",
    });

  let userId = req.userId;


  let fromDate = new Date(moment(req.query.fromDate).format("YYYY-MM-DD"));
  let toDate = new Date(new Date(moment(req.query.toDate).format("YYYY-MM-DD")).getTime() + 24 * 60 * 60 * 1000);
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  offset = offset == 1 ? 0 : offset;
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }

  let where = { userRole: "talent", userStatus: "active" };
  if (userId) {
    where.userId = userId;
  }
  let include = [
    {
      model: reqReport,
      as: "reportData",
      attributes: [
        "recruiter",
        "interviewScheduled",
        "interviewConducted",
        "date",
        "position",
      ],
      where: { date: { [Op.between]: [fromDate, toDate] } },
      order: [["id", "ASC"]],
    },
  ];
  let totalCount = await reqUser.count({ where, include });
  let interviewCounts = await reqUser.findAll({
    where,
    attributes: [
      "userId",
      "userRole",
      "userfirstName",
      "userlastName",
      [
        sequelize.literal(
          'CONCAT("reqUser"."userfirstName", \' \', "reqUser"."userlastName")'
        ),
        "userFullName",
      ],
    ],
    include,
    raw: true,
    offset,
    limit,
  });

  if (!interviewCounts)
    return res.status(401).json({ result: false, message: "data not found" });
  interviewCounts = await Promise.all(
    interviewCounts.map(async (element) => {
      let getCandidatesActions = await reqServiceSequence.findAll({
        where: {
          serviceScheduledBy: element.userId,
          serviceDate: { [Op.between]: [fromDate, toDate] },
        },
      });
      console.log(getCandidatesActions);
      return {
        userRole: element.userRole,
        userfirstName: element.userfirstName,
        userlastName: element.userlastName,
        userFullName: element.userFullName,
        recruiter: !element["reportData.recruiter"]
          ? 0
          : element["reportData.recruiter"],
        interviewScheduled: !element["reportData.interviewScheduled"]
          ? 0
          : element["reportData.interviewScheduled"],
        interviewConducted: !element["reportData.interviewConducted"]
          ? 0
          : element["reportData.interviewConducted"],
        date: element["reportData.date"],
      };
    })
  );
  return res.status(200).json({ result: true, message: "data retrived", data: interviewCounts, totalCount, });
});

exports.sixMonthDepartmentCount = tryCatch(async (req, res) => {
  let team = req.query.team;
  let teamCondition = "";
  if (team) {
    teamCondition = ` "requestTeam" = ${team} AND`;
  }
  let sqlQuery = "SELECT ";
  for (let index = 0; index < 7; index++) {
    // Get the date six months ago from the current date
    const sixMonthsAgo = moment().subtract(index, "months");
    let year = sixMonthsAgo.format("YYYY");
    let month = sixMonthsAgo.format("MM");
    sqlQuery += `(SELECT COUNT("serviceId") FROM public."reqServiceSequences" 
                            INNER JOIN public."reqServiceRequests" ON "serviceServiceRequst" = "requestId" 
                            WHERE ${teamCondition}  EXTRACT(YEAR FROM "serviceDate") = '${year}' 
                            AND EXTRACT(MONTH FROM "serviceDate") = '${month}' 
                            AND "serviceStation"=1) AS "${year + "-" + month}"${index == 6 ? "" : ","}`;
  }

  let [departmentReport, metaData] = await sequelize.query(sqlQuery);
  return res
    .status(200)
    .json({ result: true, message: "data retrived", data: departmentReport });
});

exports.dailyApplicationDepartment = tryCatch(async (req, res) => {
  let limit = req.query.limit || 100;
  let offset = req.query.currentPage || 0;
  offset = offset == 1 ? 0 : offset;
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }
  let fromDate = req.query.fromDate || moment().format("YYYY-MM-DD");
  let toDate = req.query.toDate || moment().format("YYYY-MM-DD");
  let request = req.query.requestId
    ? ` AND "requestId"=${req.query.requestId}`
    : "";
  let dateCondition = "";

  dateCondition = ` WHERE  DATE("reqCandidates"."createdAt") BETWEEN '${fromDate}' AND '${toDate}' `;

  let [dailyReportDepartmentAppli, metadata] =
    await sequelize.query(`SELECT "reqServiceRequests"."requestName", "reqServiceRequests"."requestId", DATE("reqCandidates"."createdAt") AS "createdAt",
    COUNT("reqCandidates"."candidateId") AS "totalEntries" FROM  public."reqServiceRequests" LEFT JOIN  public."reqCandidates" ON  
    "reqServiceRequests"."requestId" = "reqCandidates"."candidatesAddingAgainst" ${request} ${dateCondition} GROUP BY  "reqServiceRequests"."requestName",
    "reqServiceRequests"."requestId", DATE("reqCandidates"."createdAt") ORDER BY DATE("createdAt") DESC,"reqServiceRequests"."requestId" 
    DESC LIMIT ${limit} OFFSET ${offset} `);

  let [dataCount, metadataCount] = await sequelize.query(
    `SELECT  "reqServiceRequests"."requestId" FROM  public."reqServiceRequests" LEFT JOIN  public."reqCandidates" ON  
    "reqServiceRequests"."requestId" = "reqCandidates"."candidatesAddingAgainst" ${request} ${dateCondition} GROUP BY 
    "reqServiceRequests"."requestName","reqServiceRequests"."requestId", DATE("reqCandidates"."createdAt") ORDER BY 
    DATE("createdAt") DESC,"reqServiceRequests"."requestId"`
  );
  return res.status(200).json({
    result: true,
    message: "data retrived",
    data: dailyReportDepartmentAppli,
    dataCount: metadataCount.rowCount,
  });
});

exports.myRequirementReport = tryCatch(async (req, res) => {
  let report = req.query.report;
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  let ids = req.query.ids;

  let recuriter = req.query.recuriter;
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }
  let recuriterCondition = { where: {} };
  if (recuriter) {
    recuriterCondition.where = { userId: recuriter };
  }
  let where = { serviceStation: 1 };
  if (ids?.length) {
    ids = Array.isArray(ids) ? ids : [ids];
    where.serviceId = { [Op.in]: ids };
  }
  let include = [
    { model: reqServices },
    {
      model: reqUser,
      attributes: ["userId", "userfirstName", "userlastName"],
    },
    {
      model: reqCandidates,
      attributes: [
        "candidateId",
        "candidateFirstName",
        "candidateLastName",
        "candidateExperience",
        "candidateNoticePeriodByDays",
        "candidatePreviousOrg",
      ],
      as: "candidate",
      include: {
        model: reqUser,
        as: "createdBy",
        where: recuriterCondition.where,
        attributes: ["userId", "userfirstName", "userlastName"],
      },
      required: true,
    },
  ];
  let userRequirementCount = await reqServiceSequence.count({
    include,
    where,
  });

  let userRequirementReport = await reqServiceSequence.findAll({
    attributes: [
      "serviceId",
      "serviceStation",
      "serviceCandidate",
      ["serviceDate", "interviewTime"],
      "interviewLocation",
      "interviewMode",
    ],
    include,
    limit: limit,
    offset: offset,
    raw: true,
    where,
    order: [["serviceId", "DESC"]],
  });

  if (report == "true" && userRequirementReport) {
    let head = [
      { header: "Recruiter Name", key: "createdByName", width: 10 },
      {
        header: "Candidate First Name",
        key: "candidateFirstName",
        width: 25,
      },
      { header: "Candidate Last Name", key: "candidateLastName", width: 15 },
      {
        header: "Candidate Experience",
        key: "candidateExperience",
        width: 15,
      },
      { header: "Candidate Recruite for", key: "sericeName", width: 25 },
      {
        header: "Candidate Notice Period",
        key: "candidateNoticePeriodByDays",
        width: 25,
      },
      {
        header: "Candidate Prev Org",
        key: "candidatePreviousOrg",
        width: 25,
      },
      {
        header: "Interview Mode",
        key: "interviewMode",
        width: 25,
      },
      {
        header: "Interview Location",
        key: "interviewLocation",
        width: 25,
      },
      {
        header: "Interview Time",
        key: "interviewTime",
        width: 25,
      },
    ];

    let body = userRequirementReport.map((le) => {
      return {
        createdByName: le["candidate.createdBy.userfirstName"],
        candidateFirstName: le["candidate.candidateFirstName"],
        candidateLastName: le["candidate.candidateLastName"],
        candidateExperience: le["candidate.candidateExperience"],
        sericeName: le["reqService.sericeName"],
        candidateNoticePeriodByDays:
          le["candidate.candidateNoticePeriodByDays"],
        candidatePreviousOrg: le["candidate.candidatePreviousOrg"],
        interviewMode: le["interviewMode"],
        interviewLocation: le["interviewLocation"],
        interviewTime: le["interviewTime"],
      };
    });
    let name = `candidates_report${moment().format("yyyymmddHHMMSS")}`;
    excelGenerator(req, res, head, body, name);
    return;
  }
  return res.status(200).json({
    status: true,
    message: "Data retrived",
    requirementCount: userRequirementCount,
    userRequirementReport,
  });
});

exports.requriterHiringData = tryCatch(async (req, res) => {
  let report = req.query.report;
  let start_date = req.query.start_date;
  let end_date = req.query.end_date;
  let dataBy = req.query.dataBy;
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  let ids = req.query.ids;

  let userId = req.userId;
  let userBased = ``;
  let userCondidtion = ` AND "serviceScheduledBy"="userId"	`;
  if (userId) {
    userBased = ` AND "userId"=${userId}`;
    userCondidtion = ` AND "serviceScheduledBy"=${userId}	`;
  }

  if (!dataBy || !dataBy == "position" || !dataBy == "user") {
    return res.status(400).json({
      result: false,
      message: "dataBy is either 'position' or 'user' ",
    });
  }
  if (!start_date || !end_date) {
    return res.status(400).json({
      result: false,
      message: "start date and end date is mandatory ",
    });
  }
  let adminQuery = '';
  if (req.userType == 'admin') {
    adminQuery = ` OR "userRole"='admin'`
  }
  if (req.userType == 'super-admin') {
    adminQuery = ` OR "userRole"='super-admin'`
  }
  start_date = start_date + "  00:00:00Z"
  end_date = end_date + " 23:59:59Z";
  let recuriter = req.query.recuriter;
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }

  let query = "";
  let countQuery = "";

  if (dataBy == "position") {
    let requestIdQueryCondition = ` AND "serviceServiceRequst"="requestId"`;
    userCondidtion = !userId ? ' ' : userCondidtion;
    query = `SELECT "requestName","requestId",(SELECT COUNT(DISTINCT("serviceCandidate")) FROM public."reqCandidates" INNER JOIN "reqServiceSequences" ON "serviceCandidate"="candidateId" WHERE ("serviceStation"=1 OR "serviceStation" IS NULL) ${userCondidtion} ${requestIdQueryCondition} AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_totalsourced",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} ${requestIdQueryCondition} AND ("serviceStation"=1 OR "serviceStation" IS NULL)  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_screenrejected",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} ${requestIdQueryCondition} AND "serviceStation"=2  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_techonereject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} ${requestIdQueryCondition} AND "serviceStation"=3  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_techtworeject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} ${requestIdQueryCondition} AND "serviceStation"=4  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_techthreereject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} ${requestIdQueryCondition} AND "serviceStation"=6  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_managementreject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} ${requestIdQueryCondition} AND "serviceStation"=5  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_hrreject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" INNER JOIN "reqHrReviews" ON "serviceId"="reviewedServiceId" WHERE ("serviceStatus"='done' OR "serviceStatus"='pending') ${userCondidtion} ${requestIdQueryCondition} AND "serviceStation"=5  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_offerreleased",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE  "serviceStation"=5 ${userCondidtion} ${requestIdQueryCondition} AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "hr_total_technicalselected"  ,
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences"  WHERE "serviceStatus"='done' ${userCondidtion} ${requestIdQueryCondition} AND "serviceStation"=5  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_hired"  ,
            ((SELECT COUNT(DISTINCT("serviceCandidate")) 
                FROM "reqServiceSequences" 
                WHERE "serviceStatus" = 'done' 
                ${userCondidtion} ${requestIdQueryCondition}
                AND "serviceStation" = 3  
                AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') +
              (SELECT COUNT(DISTINCT("serviceCandidate")) 
                FROM "reqServiceSequences" 
                WHERE  "serviceStatus" = 'done' ${userCondidtion} ${requestIdQueryCondition}
                AND "serviceStation" = 4 
                AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') +
              (SELECT COUNT(DISTINCT("serviceCandidate")) 
                FROM "reqServiceSequences" 
                WHERE "serviceStatus" = 'done' 
                ${userCondidtion} ${requestIdQueryCondition}
                AND "serviceStation" = 2  
                AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}')
              ) AS "total_technicalselected"
             FROM "reqServiceRequests"  ORDER BY "requestId" DESC ${report=="false" ?` OFFSET ${offset} LIMIT ${limit}`:""};`;

    countQuery = `SELECT "requestName", "requestId", (SELECT COUNT(DISTINCT("serviceCandidate")) FROM public."reqCandidates" INNER JOIN "reqServiceSequences" ON "serviceCandidate"="candidateId" 
                  WHERE ("serviceStation"=1 OR "serviceStation" IS NULL) ${userCondidtion} ${requestIdQueryCondition} AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_totalsourced",
                  (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} ${requestIdQueryCondition} AND "serviceStation" IN (1, 2, 3, 4, 5, 6) 
                  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_rejected",  
                  (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" INNER JOIN "reqHrReviews" ON "serviceId"="reviewedServiceId" WHERE ("serviceStatus"='done' OR "serviceStatus"='pending') 
                  ${userCondidtion} ${requestIdQueryCondition} AND "serviceStation"=5 AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_offerreleased", 
                  (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE "serviceStatus"='done' ${userCondidtion} ${requestIdQueryCondition} AND "serviceStation"=5 AND "insertOrUpdateDate" 
                  BETWEEN '${start_date}' AND '${end_date}' ) AS "total_hired",
                  ((SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE "serviceStatus" = 'done' ${userCondidtion} ${requestIdQueryCondition} AND "serviceStation" IN (2,3, 4)  
                  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}')) AS "total_technicalselected"FROM "reqServiceRequests"; `;
  }
  if (dataBy == "user") {
    query = `SELECT "userfirstName","userId",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM public."reqCandidates" INNER JOIN "reqServiceSequences" ON "serviceCandidate"="candidateId" WHERE ("serviceStation"=1 OR "serviceStation" IS NULL) ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_totalsourced",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "serviceStation"=1  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_screenrejected",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "serviceStation"=2  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_techonereject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "serviceStation"=3  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_techtworeject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "serviceStation"=4  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_techthreereject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "serviceStation"=6  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_managementreject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "serviceStation"=5  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_hrreject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" INNER JOIN "reqHrReviews" ON "serviceId"="reviewedServiceId" WHERE ("serviceStatus"='done' OR "serviceStatus"='pending') ${userCondidtion} AND "serviceStation"=5  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_offerreleased",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE  "serviceStation"=5 ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "hr_total_technicalselected"  ,
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences"  WHERE "serviceStatus"='done' ${userCondidtion} AND "serviceStation"=5  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_hired"  ,
            ((SELECT COUNT(DISTINCT("serviceCandidate")) 
                FROM "reqServiceSequences" 
                WHERE "serviceStatus" = 'done' 
                ${userCondidtion}
                AND "serviceStation" = 3  
                AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') +
              (SELECT COUNT(DISTINCT("serviceCandidate")) 
                FROM "reqServiceSequences" 
                WHERE  "serviceStatus" = 'done' ${userCondidtion}
                AND "serviceStation" = 4 
                AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') +
              (SELECT COUNT(DISTINCT("serviceCandidate")) 
                FROM "reqServiceSequences" 
                WHERE "serviceStatus" = 'done' ${userCondidtion} 
                AND "serviceStation" = 2  
                AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}')
              ) AS "total_technicalselected"
            FROM "reqUsers" WHERE  "userRole"='talent' ${adminQuery}  ${userBased} ${report=="false" ?` OFFSET ${offset} LIMIT ${limit}`:""} ;`;

    countQuery = `SELECT "userfirstName","userId",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM public."reqCandidates" INNER JOIN "reqServiceSequences" ON "serviceCandidate"="candidateId" WHERE ("serviceStation"=1 OR "serviceStation" IS NULL) ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_totalsourced",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "serviceStation"=1  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_screenrejected",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "serviceStation"=2  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_techonereject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "serviceStation"=3  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_techtworeject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "serviceStation"=4  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_techthreereject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "serviceStation"=6  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_managementreject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "serviceStation"=5  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_hrreject",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" INNER JOIN "reqHrReviews" ON "serviceId"="reviewedServiceId" WHERE ("serviceStatus"='done' OR "serviceStatus"='pending') ${userCondidtion} AND "serviceStation"=5  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_offerreleased",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE  "serviceStation"=5 ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "hr_total_technicalselected"  ,
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences"  WHERE "serviceStatus"='done' ${userCondidtion} AND "serviceStation"=5  AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') AS "total_hired"  ,
            ((SELECT COUNT(DISTINCT("serviceCandidate")) 
                FROM "reqServiceSequences" 
                WHERE "serviceStatus" = 'done' 
                ${userCondidtion}
                AND "serviceStation" = 3  
                AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}') +
              (SELECT COUNT(DISTINCT("serviceCandidate")) 
                FROM "reqServiceSequences" 
                WHERE  "serviceStatus" = 'done' ${userCondidtion}
                AND "serviceStation" = 4 
                AND "insertOrUpdateDate" BETWEEN '${start_date}' AND '${end_date}')
              ) AS "total_technicalselected"
            FROM "reqUsers" WHERE  "userRole"='talent' ${adminQuery} ${userBased}`;
  }

  let [reqReportData, metaData] = await sequelize.query(query);
  let [countData, countMetaData] = await sequelize.query(countQuery);
 if (report == "true" && reqReportData) {
    let head = [
      { header: "requestId", key: "requestId", width: 10 },
      {
        header: "requestName",
        key: "requestName",
        width: 25,
      },
      { header: "total_totalsourced", key: "total_totalsourced", width: 10 },
      {
        header: "total_screenrejected",
        key: "total_screenrejected",
        width: 10,
      },
      { header: "total_techonereject", key: "total_techonereject", width: 10 },
      { header: "total_techtworeject", key: "total_techtworeject", width: 10 },
      {
        header: "total_techthreereject",
        key: "total_techthreereject",
        width: 10,
      },
      {
        header: "total_managementreject",
        key: "total_managementreject",
        width: 10,
      },
      {
        header: "total_hrreject",
        key: "total_hrreject",
        width: 10,
      },
      {
        header: "total_offerreleased",
        key: "total_offerreleased",
        width: 10,
      },
      { header: "hr_total_technicalselected", key: "hr_total_technicalselected", width: 10 },
      { header: "total_hired", key: "total_hired", width: 10 },
      { header: "total_technicalselected", key: "total_technicalselected", width: 10 },

    ];

    let body = reqReportData.map((le) => {
      return {
        requestId: le.requestId,
        requestName: le.requestName,
        total_totalsourced: le.total_totalsourced,
        total_screenrejected: le.total_screenrejected,
        total_techonereject: le.total_techonereject,
        total_techtworeject: le.total_techtworeject,
        total_techthreereject: le.total_techthreereject,
        total_managementreject: le.total_managementreject,
        total_hrreject: le.total_hrreject,
        total_offerreleased: le.total_offerreleased,
        hr_total_technicalselected: le.hr_total_technicalselected,
        total_hired: le.total_hired,
        total_technicalselected: le.total_technicalselected,

      };
    });
    let name = `recruiter_report_${moment().format("yyyymmddHHMMSS")}`;
    excelGenerator(req, res, head, body, name);
    return;
  }
  // res.send(reqReportData);
  return res.status(200).json({
    result: true,
    message: "data retrived",
    data: reqReportData,
    total: countMetaData.rowCount,
  });
});

exports.dashBoardCard = tryCatch(async (req, res) => {
  let requestId = req.query.requestId;
  let fromDate = req.query.fromDate;
  let toDate = req.query.todate;
  let userId = req.userId;
  let userCondidtion = "";
  if (userId) {
    userCondidtion = ` AND "serviceScheduledBy"=${userId}	`;
  }
  if (!fromDate || !toDate)
    return res.status(400).json({
      result: false,
      message: "from date and to date are mandatory",
    });
  toDate = toDate + " 23:59:59Z";
  fromDate = fromDate + " 00:00:00Z";
  let query = "";
  if (requestId) {
    query = `
          SELECT "requestId","requestName","teamName","requestVacancy",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM public."reqCandidates" INNER JOIN "reqServiceSequences" ON "serviceCandidate"="candidateId" WHERE ("serviceStation"=1 OR "serviceStation" IS NULL) ${userCondidtion} AND  "serviceServiceRequst"=${requestId} AND "insertOrUpdateDate" BETWEEN '${fromDate}' AND '${toDate}') AS "totalApplicants",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE "serviceStatus"='done'  AND "serviceStation"=1 AND "serviceServiceRequst"=${requestId} ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${fromDate}' AND '${toDate}') AS "shortedListCandidates",
            ( SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE "serviceStation"=5 AND "serviceStatus"='done' AND "serviceServiceRequst"=${requestId} ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${fromDate}' AND '${toDate}') AS "hiredCandidates",
            (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') AND "serviceServiceRequst"=${requestId}  ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${fromDate}' AND '${toDate}') AS "rejectedCandidates"
        FROM public."reqServiceRequests" INNER JOIN "reqTeams" ON "teamId"="requestTeam" WHERE "requestId"=${requestId}`;
  } else {
    query = `
       SELECT COALESCE((SELECT SUM("requestVacancy") FROM public."reqServiceRequests" WHERE "requestStatus"='active' AND "requestDate" BETWEEN '${fromDate}' AND '${toDate}' ), 0) AS "requestVacancy",
(SELECT COUNT(DISTINCT("serviceCandidate")) FROM public."reqCandidates" INNER JOIN "reqServiceSequences" ON "serviceCandidate"="candidateId" WHERE ("serviceStation"=1 OR "serviceStation" IS NULL)  ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${fromDate}' AND '${toDate}')  AS "totalApplicants",
(SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE "serviceStatus"='done'  AND "serviceStation"=1 ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${fromDate}' AND '${toDate}') AS "shortedListCandidates",
( SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE "serviceStation"=5 AND "serviceStatus"='done' ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${fromDate}' AND '${toDate}' ) AS "hiredCandidates",
 (SELECT COUNT(DISTINCT("serviceCandidate")) FROM "reqServiceSequences" WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection') ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${fromDate}' AND '${toDate}' ) AS "rejectedCandidates"
 FROM public."reqServiceRequests" LIMIT 1;`;
  }

  let [gettotalRecords, metadata] = await sequelize.query(query);
  let objectData = gettotalRecords[0];
  let data = [];
  if (requestId) {
    for (const key in objectData) {
      if (
        key !== "requestId" &&
        key !== "requestName" &&
        key !== "teamName" &&
        key !== "requestVacancy"
      ) {
        console.log(objectData[key]);
        data.push({
          count: objectData[key],
          name:
            key.charAt(0).toUpperCase() +
            key
              .slice(1)
              .replace(/([A-Z])/g, " $1")
              .trim(),
          position: objectData["requestName"],
          team: objectData["teamName"],
          vacancy: objectData["requestVacancy"],
          totalApplicant: objectData["totalApplicants"],
        });
      }
    }
  } else {
    for (const key in objectData) {
      if (
        key !== "requestId" &&
        key !== "requestName" &&
        key !== "teamName" &&
        key !== "requestVacancy"
      ) {
        data.push({
          count: objectData[key],
          name:
            key.charAt(0).toUpperCase() +
            key
              .slice(1)
              .replace(/([A-Z])/g, " $1")
              .trim(),
          position: "All Active Requisition",
          team: "All",
          vacancy: objectData["requestVacancy"],
          totalApplicant: objectData["totalApplicants"],
        });
      }
    }
  }
  if (data)
    return res
      .status(200)
      .json({ result: true, message: "data retrived", data: data });
  return res.status(401).json({ result: false, message: "data not found" });
});


exports.recruiterChart = tryCatch(async (req, res) => {
  const { start_date, end_date, recruiter, position, last_six_month } =
    req.query;

  if (recruiter === "true" && (!start_date || !end_date)) {
    return res.status(400).json({
      result: false,
      message: "Start date and end date are mandatory "
    });
  }

  if (
    !last_six_month ||
    (last_six_month !== "true" && last_six_month !== "false")
  ) {
    return res.status(400).json({
      result: false,
      message: "last_six_month is mandatory and should be 'true' or 'false'",
    });
  }

  let userId = req.userId;
  let userCondidtion = "";
  if (userId) {
    userCondidtion = ` AND "userId"=${userId}	`;
  }

  let startDate = start_date + ' 00:00:00Z';
  let endDate = end_date + ' 23:59:59Z';

  if (last_six_month == "true") {
    const sixMonthsAgo = moment().subtract(6, 'months').format('YYYY-MM-DD');
    startDate = sixMonthsAgo + ' 00:00:00Z';
    endDate = moment().format('YYYY-MM-DD') + ' 23:59:59Z';
  }

  let [totalSourced, metadata] = await sequelize.query(`SELECT "userfirstName",COUNT(*) as total_totalSourced FROM public."reqCandidates" INNER JOIN "reqServiceSequences" ON "serviceCandidate" = "candidateId" INNER JOIN "reqUsers" ON "userId" = "serviceScheduledBy" WHERE ("serviceStation" = 1 OR "serviceStation" IS NULL) ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}' GROUP BY "userfirstName" ORDER BY total_totalSourced DESC;`);

  let [hiredSourced, hiredMetadata] = await sequelize.query(`SELECT "userfirstName",COUNT(*) as total_hired FROM  "reqServiceSequences" INNER JOIN "reqUsers" ON "userId" = "serviceScheduledBy" WHERE "serviceStation" = 5 AND "serviceStatus"='done' ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}' GROUP BY "userfirstName" ORDER BY total_hired DESC;`);

  let [offerSourced, offerMetadata] = await sequelize.query(`SELECT "userfirstName",COUNT(*) as total_offerReleased FROM public."reqCandidates" INNER JOIN "reqServiceSequences" ON "serviceCandidate" = "candidateId" INNER JOIN "reqHrReviews" ON "serviceId"="reviewedServiceId" INNER JOIN "reqUsers" ON "userId" = "serviceScheduledBy" WHERE "serviceStation" = 5  ${userCondidtion} AND  "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}' GROUP BY "userfirstName" ORDER BY total_offerReleased DESC;`);

  // Initialize a result array
  const result = [];

  // Function to find or create an entry in the result array
  function findOrCreateEntry(name) {
    let entry = result.find(item => item.userfirstName === name);
    if (!entry) {
      entry = {
        "userfirstName": name,
        "total_totalsourced": "0",
        "total_hired": "0",
        "total_offerreleased": "0"
      };
      result.push(entry);
    }
    return entry;
  }

  // Merge totalsourced data
  totalSourced.forEach(item => {
    const entry = findOrCreateEntry(item.userfirstName);
    entry.total_totalsourced = item.total_totalsourced;
  });

  // Merge totalhired data
  hiredSourced.forEach(item => {
    const entry = findOrCreateEntry(item.userfirstName);
    entry.total_hired = item.total_hired;
  });

  // Merge totalofferreleased data
  offerSourced.forEach(item => {
    const entry = findOrCreateEntry(item.userfirstName);
    entry.total_offerreleased = item.total_offerreleased;
  });

  return res
    .status(200)
    .json({ result: true, message: "data retrieved", data: result });
});


exports.departmentChart = tryCatch(async (req, res) => {
  let { teamId, start_date, end_date } = req.query;

  if (!start_date || !end_date) {
    return res.status(400).json({
      result: false,
      message: "start date and end date are mandatory ",
    });
  }
  let userId = req.userId;
  let userCondidtion = "";
  if (userId) {
    userCondidtion = ` AND "serviceScheduledBy"=${userId}	`;
  }
  let startDate = req.query.start_date + ' 00:00:00Z';
  let endDate = req.query.end_date + ' 23:59:59Z';
  let arrayOfTeams = [];
  let arrayOfRequestion = [];

  //while passing team id
  if (teamId) {
    let [getRequestionByTeam, meataData] = await sequelize.query(`SELECT "requestId","requestName" FROM "reqServiceRequests" WHERE "requestTeam"=${teamId} `);
    for (let i = 0; i < getRequestionByTeam.length; i++) {
      let [countTotal, TotalmeataData] = await sequelize.query(`select COUNT(DISTINCT("candidateId")) FROM "reqCandidates" INNER JOIN "reqServiceSequences" ON "serviceCandidate"="candidateId" WHERE ("serviceStation"=1 OR "serviceStation" IS NULL) ${userCondidtion} AND "serviceServiceRequst" =${getRequestionByTeam[i].requestId} AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);
      let [countHired, meataData] = await sequelize.query(`SELECT COUNT(DISTINCT("serviceCandidate")) FROM  "reqServiceSequences" WHERE "serviceServiceRequst" =${getRequestionByTeam[i].requestId} AND "serviceStation"=5 AND "serviceStatus"='done' ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);
      let [countTechSelect, meataDataTech] = await sequelize.query(`SELECT COUNT(DISTINCT("serviceCandidate")) FROM  "reqServiceSequences" WHERE "serviceServiceRequst" =${getRequestionByTeam[i].requestId} AND "serviceStation"=5 ${userCondidtion} AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);
      let [countTechoffer, meataDataOffer] = await sequelize.query(`SELECT COUNT(DISTINCT("serviceCandidate")) FROM  "reqServiceSequences" INNER JOIN "reqHrReviews" ON "serviceId"="reviewedServiceId" WHERE "serviceServiceRequst" =${getRequestionByTeam[i].requestId} ${userCondidtion} AND "serviceStation"=5 AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);

      let isValidCondition = parseInt(countTotal[0].count) + parseInt(countHired[0].count) + parseInt(countTechSelect[0].count) + parseInt(countTechoffer[0].count);
      if (isValidCondition) {
        arrayOfRequestion.unshift({ requestId: getRequestionByTeam[i].requestId, requestName: getRequestionByTeam[i].requestName, total_applicant: countTotal[0].count, hire_count: countHired[0].count, technical_selected_Count: countTechSelect[0].count, offered_Count: countTechoffer[0].count });
      } else {
        arrayOfRequestion.push({ requestId: getRequestionByTeam[i].requestId, requestName: getRequestionByTeam[i].requestName, total_applicant: countTotal[0].count, hire_count: countHired[0].count, technical_selected_Count: countTechSelect[0].count, offered_Count: countTechoffer[0].count });
      }
    }
    return res.send(arrayOfRequestion);
  }

  //all team datas while not passing team id
  let [getcandidateRequirementQuery, meataData] = await sequelize.query(`SELECT DISTINCT("teamId"),"teamName" FROM "reqTeams"`);

  for (let i = 0; i < getcandidateRequirementQuery.length; i++) {

    let [countTotal, TotalmeataData] = await sequelize.query(`select COUNT(DISTINCT("candidateId")) FROM "reqCandidates" INNER JOIN "reqServiceSequences" ON "serviceCandidate"="candidateId" WHERE ("serviceStation"=1 OR "serviceStation" IS NULL)${userCondidtion} AND "serviceServiceRequst" IN (SELECT DISTINCT("requestId") FROM "reqServiceRequests" WHERE "requestTeam"=${getcandidateRequirementQuery[i].teamId}) AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);
    let [countHired, meataData] = await sequelize.query(`SELECT COUNT(DISTINCT("serviceCandidate")) FROM  "reqServiceSequences" WHERE "serviceServiceRequst" IN (SELECT DISTINCT ("requestId") FROM "reqServiceRequests" WHERE "requestTeam"=${getcandidateRequirementQuery[i].teamId}) ${userCondidtion} AND "serviceStation"=5 AND "serviceStatus"='done' AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);
    let [countTechSelect, meataDataTech] = await sequelize.query(`SELECT COUNT(DISTINCT("serviceCandidate")) FROM  "reqServiceSequences" WHERE "serviceServiceRequst" IN (SELECT DISTINCT ("requestId") FROM "reqServiceRequests" WHERE "requestTeam"=${getcandidateRequirementQuery[i].teamId}) ${userCondidtion} AND "serviceStation"=5 AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);
    let [countTechoffer, meataDataOffer] = await sequelize.query(`SELECT COUNT(DISTINCT("serviceCandidate")) FROM  "reqServiceSequences" LEFT JOIN "reqHrReviews" ON "serviceId"="reviewedServiceId" WHERE "serviceServiceRequst" IN (SELECT DISTINCT ("requestId") FROM "reqServiceRequests" WHERE "requestTeam"=${getcandidateRequirementQuery[i].teamId}) ${userCondidtion} AND "serviceStation"=5 AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);

    let isValidCondition = parseInt(countTotal[0].count) + parseInt(countHired[0].count) + parseInt(countTechSelect[0].count) + parseInt(countTechoffer[0].count);
    if (isValidCondition) {
      arrayOfTeams.unshift({
        teamId: getcandidateRequirementQuery[i].teamId,
        teamName: getcandidateRequirementQuery[i].teamName,
        total_applicant: countTotal[0].count,
        hire_count: countHired[0].count,
        technical_selected_Count: countTechSelect[0].count,
        offered_Count: countTechoffer[0].count
      });
    } else {
      arrayOfTeams.push({
        teamId: getcandidateRequirementQuery[i].teamId,
        teamName: getcandidateRequirementQuery[i].teamName,
        total_applicant: countTotal[0].count,
        hire_count: countHired[0].count,
        technical_selected_Count: countTechSelect[0].count,
        offered_Count: countTechoffer[0].count
      });
    }

  }
  return res.send(arrayOfTeams);
});

exports.sendFeedbackReminder = tryCatch(async (req, res) => {

  try {
    const { userId, candidateId } = req.body;

    if(!userId || !candidateId) {
      return res.status(400).json({ message: 'User ID and Candidate ID is required' });
    }
    const user = await reqUser.findOne(
      { where: { userId } } 
    );
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const candidate = await reqCandidates.findOne(
      { where: { candidateId } }
    );
    if (!candidate) {
      return res.status(404).json({ message: 'Candidate not found' });
    }

    await sendFeedbackReminder(user.userEmail, user.userfirstName, candidate.candidateFirstName);
    res.status(200).json({ message: 'Reminder email sent successfully' });

  } catch (error) {
    console.error('Error sending feedback reminder mail:', error);
    res.status(500).json({ message: 'Failed to send reminder email' });
  }
});