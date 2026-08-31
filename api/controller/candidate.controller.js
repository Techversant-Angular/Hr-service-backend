const fs = require('fs');
let {
  reqCandidates, reqCandidateResumeSource, reqUser,
  reqCandidateSkill, sequelize, Sequelize,
  reqSkill, reqStation, reqServiceRequest,
  reqCandidateComments, reqServiceSequence, reqCandidateRequestion,
  reqJobApplicants, reqJobOpening, reqServiceRequestsJobOpenings
} = require("../../models");
const response = require("../../api/utils/responseMessages");
const { format, addMonths, isAfter } = require("date-fns");
const { Op, where } = require("sequelize");
let { excelGenerator } = require("../utils/excelGenerator");
let { logFunction, profileSourceReport, reqcuriterReport } = require("../utils/commonFunction");
let jsonData = require("../utils/userRignts.json");
const { tryCatch } = require("../utils/trycatch");

exports.createCandidate = tryCatch(async (req, res) => {
  const { ...parameter } = req.body;
  const {
    candidateEmail,
    candidateCreatedby,
    candidatesAddingAgainst,
    resumeSourceId,
  } = parameter;

  const sourcedString = `Candidate Sourced From ${jsonData.sourceList[resumeSourceId]}`;
  const candidateIspresent = await reqCandidates.findOne({
    where: {
      candidateStatus: "active",
      [Op.or]: [
        { candidateEmail },
        { candidateMobileNo: parameter.candidateMobileNo },
        
      ],
    },
  });

  if(candidateIspresent) {
    return res.status(401).json({
      status: false,
      message: "Candidate already exists",
    });
  } else {
    const candiate = await reqCandidates.create(parameter);
    const candidateId = candiate.candidateId;
    await addSkills(candidateId, parameter);
    // if (candidatesAddingAgainst) await profileSourceReport(candidateCreatedby, candidatesAddingAgainst, [resumeSourceId]);

    logFunction(candidateId, candidateCreatedby, sourcedString, 1);
    await entryInSequence(
      candidatesAddingAgainst,
      candidateId,
      candidateCreatedby
    ); //keep entry in sequence table
    return res
      .status(200)
      .json({ status: true, message: "Candidate Created Successfully" });
  }
});

exports.createCandidateRecords = tryCatch(async (req, res) => {
  const { ...parameter } = req.body;
  const {
    candidateEmail,
    candidateCreatedby,
    candidatesAddingAgainst,
    resumeSourceId,
  } = parameter;

  const sourcedString = `Candidate Sourced From ${jsonData.sourceList[resumeSourceId]}`;
  const candidateIspresent = await reqCandidates.findOne({
    where: {
      candidateStatus: "active",
      [Op.or]: [
        { candidateEmail },
        { candidateMobileNo: parameter.candidateMobileNo },
        
      ],
    },
  });

  if(candidateIspresent) {
    return res.status(401).json({
      status: false,
      message: "Candidate already exists",
    });
  } else {
    const candiate = await reqCandidates.create(parameter);
    const candidateId = candiate.candidateId;
    await addSkills(candidateId, parameter);
    // if (candidatesAddingAgainst) await profileSourceReport(candidateCreatedby, candidatesAddingAgainst, [resumeSourceId]);

    logFunction(candidateId, candidateCreatedby, sourcedString, 1);
    await entryInSequence(
      candidatesAddingAgainst,
      candidateId,
      candidateCreatedby
    ); //keep entry in sequence table
    return res
      .status(200)
      .json({ status: true, message: "Candidate Created Successfully" });
  }
});

exports.editCandidate = tryCatch(async (req, res) => {
  const { ...parameter } = req.body;
  const { candidateId } = parameter;

  const candidateIspresent = await reqCandidates.findOne({
    where: {
      candidateId,
      candidateStatus: "active",
    },
  });
  if (!candidateIspresent)
    return res
      .status(401)
      .json({ status: false, message: response.CANDIDATE_NOT_FOUND });
  const updatedCandidate = await reqCandidates.update(parameter, {
    where: { candidateId },
  });
  await addSkills(candidateId, parameter);
  if (updatedCandidate[0])
    return res
      .status(200)
      .json({ status: true, message: "Candidate Updated Successfully" });
  return res
    .status(401)
    .json({ status: false, message: "something went wrong" });
});

exports.listCandidates = tryCatch(async (req, res) => {
  const report = req.query.report;
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  const experience = req.query.exprience;
  let ids = req.query.ids;

  const search = req.query.search ? decodeURIComponent(req.query.search) : req.query.search;
  const skills = req.query.skills;
  const recuriter = req.query.recuriter;
  const serviceRequestId = req.query.serviceRequestId;
  const where = {
    candidateStatus: "active",
  };
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }
  // this statement is used to filter candidates in service request
  const data = req.url.split("/");
  const urlCandidates = data.includes("candidates");
  if (urlCandidates) {
    where.candidateStation = {
      [Op.is]: null,
    };
  }
  if (serviceRequestId)
    where.candidatesAddingAgainst = { [Op.eq]: serviceRequestId };
  if (experience) {
    if (experience == 0) {
      where.candidateExperience = { [Op.eq]: experience };
    } else {
      where.candidateExperience = { [Op.gte]: experience };
    }
  }
  if (ids?.length) {
    ids = Array.isArray(ids)
      ? ids.flatMap(id => String(id).split(','))
      : String(ids).split(',');
    ids = ids.map(id => id.trim()).filter(id => id);
  }
  if (search) {
    const searchLower = search.toLowerCase();
    where[Op.or] = [
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidateFirstName')), { [Op.like]: `%${searchLower}%` }),
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidateLastName')), { [Op.like]: `%${searchLower}%` }),
      Sequelize.where(
        Sequelize.fn('LOWER', Sequelize.fn("concat", Sequelize.col("candidateFirstName"), " ", Sequelize.col("candidateLastName"))),
        { [Op.like]: `%${searchLower}%` }
      ),
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidateEmail')), { [Op.like]: `%${searchLower}%` }),
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidateMobileNo')), { [Op.like]: `%${searchLower}%` }),
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidatePreviousOrg')), { [Op.like]: `%${searchLower}%` }),
    ];
  }
  const recuriterCondition = { where: {} };
  if (recuriter) {
    recuriterCondition.where = { userId: recuriter };
  }
  const candidateSkill = {};
  if (skills) {
    candidateSkill.candidateSkillId = skills;
  }
  const include = [
    { model: reqServiceRequest, attributes: ["requestName", "requestId"] },
    {
      model: reqCandidateRequestion,as: "candidateReqst",
      include: [{ model: reqServiceRequest,as:'serviceRequestion', attributes: ["requestName", "requestId"] }]
    },
    {
      model: reqUser,
      as: "createdBy",
      required: false,
      where: recuriterCondition.where,
      attributes: ['userEmail', 'userFullName', 'userfirstName', 'userlastName'],
    },
    {
      model: reqCandidateSkill,
      as: "candidateSkill",
      required: false,
      attributes: ["candidateSkillType", "candidateSkillId"],
      where: candidateSkill,
      include: { model: reqSkill, as: "skills" },
    },
  ];

  const subQuery = `SELECT MAX("candidateId") as "candidateId" FROM "reqCandidates" GROUP BY "candidateEmail"`;

  const [results] = await sequelize.query(subQuery);

  const dedupIds = results.map((result) => result.candidateId);

  // If specific ids were requested, intersect with dedup results
  if (ids?.length) {
    const requestedIds = ids.map(Number);
    where.candidateId = {
      [Op.in]: dedupIds.filter(id => requestedIds.includes(id)),
    };
  } else {
    where.candidateId = {
      [Op.in]: dedupIds,
    };
  }

  const candidateCount = await reqCandidates.count({
    include,
    where,
    distinct: true,
  });

  const candidates = await reqCandidates.findAll({
    include,
    // attributes: { exclude: ["candidateExpectedSalary"] },
    where,
    ...(report == "true" ? {} : {
      limit: limit,
      offset: offset
    }),
    distinct: true,
    order: [["candidateId", "DESC"]],
  });

  if (report == "true" && candidates) {
    const head = [
      { header: "Candidate Id", key: "candidateId", width: 10 },
      {
        header: "Candidate First Name",
        key: "candidateFirstName",
        width: 25,
      },
      { header: "Candidate Middle Name", key: "candidateMiddleName", width: 15 },
      { header: "Candidate Last Name", key: "candidateLastName", width: 15 },
      // {
      //   header: "Candidate Experience",
      //   key: "candidateExperience",
      //   width: 15,
      // },
      {
        header: "Candidate Relevant Experience",
        key: "candidateRevlentExperience",
        width: 15,
      },
            {
        header: "Candidate Total Experience",
        key: "candidateTotalExperience",
        width: 15,
      },
      { header: "Candidate Email", key: "candidateEmail", width: 25 },
      { header: "Candidate Mobile", key: "candidateMobileNo", width: 25 },
      {
        header: "Candidate Prev Org",
        key: "candidatePreviousOrg",
        width: 25,
      },
      {
        header: "Candidate Designation",
        key: "candidatePreviousDesignation",
        width: 25,
      },
      {
        header: "Candidate Current Salary",
        key: "candidateCurrentSalary",
        width: 25,
      },
      {
        header: "Candidate Expected Salary",
        key: "candidateExpectedSalary",
        width: 25,
      },
      {
        header: "Candidate Summary",
        key: "candidateSummary",
        width: 25,
      },
      {
        header: "Candidate Linkedin Url",
        key: "candidateLinkedinUrl",
        width: 25,
      },
      {
        header: "Candidate Github Url",
        key: "candidateGithubUrl",
        width: 25,
      },
      {
        header: "Candidate Marital Status",
        key: "candidateMaritalStatus",
        width: 25
      },
      { header: "Candidate Immidiate Joiner", key: "candidateImmidiateJoiner", width: 25 },
      { header: "candidate City", key: "candidateCity", width: 10 },
      { header: "candidate Education", key: "candidateEducation", width: 10 },
    ];

    const body = candidates.map((le) => {
      return {
        candidateId: le.candidateId,
        candidateFirstName: le.candidateFirstName,
        candidateMiddleName: le.candidateMiddleName,
        candidateLastName: le.candidateLastName,
        candidateExperience: le.candidateExperience,
        candidateSummary: le.candidateSummary,
        candidateLinkedinUrl: le.candidateLinkedinUrl,
        candidateGithubUrl: le.candidateGithubUrl,
        candidateMaritalStatus: le.candidateMaritalStatus,
        candidateImmidiateJoiner: le.candidateImmidiateJoiner,
        candidateRevlentExperience: le.candidateRevlentExperience,
        candidateTotalExperience: le.candidateTotalExperience,
        candidateEmail: le.candidateEmail,
        candidateMobileNo: le.candidateMobileNo,
        candidatePreviousOrg: le.candidatePreviousOrg,
        candidatePreviousDesignation: le.candidatePreviousDesignation,
        candidateCurrentSalary: le.candidateCurrentSalary,
        candidateExpectedSalary: le.candidateExpectedSalary,
        candidateCity: le.candidateCity,
        candidateEducation: le.candidateEducation,
      };
    });
    const name = `candidates${format(new Date(), "yyyyMMddHHmmss")}`;
    excelGenerator(req, res, head, body, name);
    return;
  }
  if (candidates)
    return res.status(200).json({
      result: true,
      message: "Candidates found",
      candidateCount,
      candidates: candidates.map((el) => {
        // Convert reqServiceRequest to an array and merge with candidateReqst
        const serviceRequests = [
          ...(Array.isArray(el.candidateReqst) ? el.candidateReqst.map(req => req.serviceRequestion) : []),
        ];
        return {
          ...el.toJSON(),
          reqServiceRequest: serviceRequests
        };
      }),
    });
  throw new Error(response.CANDIDATES_NOTFOUND);
});

exports.candidateCompareList = tryCatch(async (req, res) => {
  const report = req.query.report;
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  const experience = req.query.exprience;
  const search = req.query.search ? decodeURIComponent(req.query.search) : req.query.search;
  const skills = req.query.skills;
  const recuriter = req.query.recuriter;
  const serviceRequestId = req.query.serviceRequestId;
  const where = { candidateStatus: "active" };
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }
  // this statement is used to filter candidates in service request
  const data = req.url.split("/");
  const urlCandidates = data.includes("candidates");
  if (urlCandidates) {
    where.candidateStation = {
      [Op.is]: null,
    };
  }
  if (serviceRequestId)
    where.candidatesAddingAgainst = { [Op.eq]: serviceRequestId };
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
      { candidateLastName: { [Op.iLike]: `${search}%` } },
      Sequelize.where(
        Sequelize.fn("concat", Sequelize.col("candidateFirstName"), " ", Sequelize.col("candidateLastName")),
        { [Op.iLike]: `${search}%` }
      ),
      { candidateEmail: { [Op.iLike]: `${search}%` } },
      { candidateMobileNo: { [Op.iLike]: `${search}%` } },
      { candidatePreviousOrg: { [Op.iLike]: `${search}%` } },
    ];
  }
  const recuriterCondition = { where: {} };
  if (recuriter) {
    recuriterCondition.where = { userId: recuriter };
  }
  const candidateSkill = {};
  if (skills) {
    candidateSkill.candidateSkillId = skills;
  }
  const include = [
    {
      model: reqUser,
      as: "createdBy",
      where: recuriterCondition.where,
      attributes: {
        exclude: ["createdAt", "updatedAt", "userPassword", "userDOB"],
      },
    },
    {
      model: reqCandidateSkill,
      as: "candidateSkill",
      attributes: ["candidateSkillType", "candidateSkillId"],
      where: candidateSkill,
      include: { model: reqSkill, as: "skills" },
    },
  ];

  const candidateCount = await reqCandidates.count({
    include,
    where,
    distinct: true,
  });

  const candidates = await reqCandidates.findAll({
    include,
    attributes: { exclude: ["createdAt", "updatedAt", "candidateCurrentSalary", "candidateExpectedSalary"] },
    where,
    limit: limit,
    offset: offset,
    order: [["candidateId", "DESC"]],
  });
  if (report && candidates) {
    const head = [
      { header: "Candidate Id", key: "candidateId", width: 10 },
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
      { header: "Candidate Email", key: "candidateEmail", width: 25 },
      { header: "Candidate Mobile", key: "candidateMobileNo", width: 25 },
      {
        header: "Candidate Prev Org",
        key: "candidatePreviousOrg",
        width: 25,
      },
      {
        header: "Candidate Designation",
        key: "candidatePreviousDesignation",
        width: 25,
      },
      {
        header: "Candidate Current Salary",
        key: "candidateCurrentSalary",
        width: 25,
      },
      {
        header: "Candidate Expected Salary",
        key: "candidateExpectedSalary",
        width: 25,
      },
      { header: "candidate City", key: "candidateCity", width: 10 },
      { header: "candidate Education", key: "candidateEducation", width: 10 },
    ];

    const body = candidates.map((le) => {
      return {
        candidateId: le.candidateId,
        candidateFirstName: le.candidateFirstName,
        candidateLastName: le.candidateLastName,
        candidateExperience: le.candidateExperience,
        candidateEmail: le.candidateEmail,
        candidateMobileNo: le.candidateMobileNo,
        candidatePreviousOrg: le.candidatePreviousOrg,
        candidatePreviousDesignation: le.candidatePreviousDesignation,
        candidateCurrentSalary: le.candidateCurrentSalary,
        candidateExpectedSalary: le.candidateExpectedSalary,
        candidateCity: le.candidateCity,
        candidateEducation: le.candidateEducation,
      };
    });
    const name = `candidates${format(new Date(), "yyyyMMddHHmmss")}`;
    excelGenerator(req, res, head, body, name);
    return;
  }
  if (candidates)
    return res.status(200).json({
      result: true,
      message: "Candidates found",
      candidateCount,
      candidates,
    });
  throw new Error(response.CANDIDATES_NOTFOUND);
});

exports.viewCandidate = tryCatch(async (req, res) => {

  const candidateId = req.params.candidateId;
  if (!candidateId) {
    return res
      .status(401)
      .json({ result: false, message: "candidateId field is mandatory" });
  }
  let comments = [];
  let candidateStatus = [];
  let conditionString = "";
  if (!Number(candidateId)) {
    conditionString = `"reqCandidates"."candidateEmail" = '${candidateId}'`;
  } else {
    conditionString = `"reqCandidates"."candidateId" = ${candidateId}`;
    candidateStatus = await reqServiceSequence.findAll({
      include: [{ model: reqStation }],
      where: { serviceCandidate: candidateId },
      order: [["serviceStation", "ASC"]],
      raw: true,
    });
    var hiddenField = '';
    if (req.userRole == 'super-admin' || req.userRole == 'admin' || req.userRole == 'talent'|| req.userRole == 'visitor') {
      hiddenField = `    "reqCandidates"."candidateCurrentSalary",
            "reqCandidates"."candidateExpectedSalary", `;
    }
    if (req.userRole !== 'panel' && req.userRole !== 'manager' && candidateStatus[0]) {
      comments = await reqCandidateComments.findAll({
        include: [
          {
            model: reqServiceSequence,
            include: [
              {
                model: reqUser,
                attributes: [
                  "userEmail",
                  [
                    Sequelize.fn(
                      "concat",
                      Sequelize.col("userfirstName"),
                      Sequelize.col("userlastName")
                    ),
                    "userName",
                  ],
                ],
              },
              { model: reqStation },
            ],
            raw: true,
          },
        ],
        where: {
          commentSeqenceId: {
            [Op.in]: candidateStatus.map((el) => {
              return el.serviceId;
            }),
          },
        },
        raw: true,
      });
      candidateStatus = candidateStatus.map((el) => {
        let statusString = ` Scheduled`;
        if (el.serviceStatus == "done") statusString = ` Completed`;
        if (el.serviceStatus == "rejected") statusString = ` Rejected`;

        return {
          interviewStationName: el["reqStation.stationName"],
          interViewStatus: statusString,
        };
      });
    } else {
      comments = [];
    }
  }
  const candidate = await sequelize.query(`SELECT
        "reqCandidates"."candidateId",
        "reqCandidates"."candidateFirstName",
        "reqCandidates"."candidateLastName",
        "reqCandidates"."candidateDoB",
        "reqCandidates"."candidateExperience",
        "reqCandidates"."candidatePreviousOrg",
        "reqCandidates"."candidatePreviousDesignation",
        "reqCandidates"."candidateEducation",
    ${hiddenField}
        "reqCandidates"."candidateAddress",
        "reqCandidates"."candidateEmail",
        "reqCandidates"."candidateMobileNo",
        "reqCandidates"."candidateGender",
        "reqCandidates"."candidateTotalExperience",
        "reqCandidates"."candidateRevlentExperience",
        "reqCandidates"."candidatePreferlocation",
        "reqCandidates"."candidateCity",
        "reqCandidates"."candidateDistrict",
        "reqCandidates"."candidateState",
        "reqCandidates"."candidateInterviewStatus",
        "reqCandidates"."candidateCurrentSalary",
        "reqCandidates"."candidateExpectedSalary",
        "reqCandidates"."candidateResume",(SELECT "stationName" FROM "reqServiceSequences"  INNER JOIN "reqStations" ON "serviceStation"="stationId" WHERE "serviceCandidate"= "reqCandidates"."candidateId" ORDER BY "serviceId" DESC LIMIT 1) AS "currentStation",
        (SELECT "sourceName" FROM "reqCandidateResumeSources" WHERE "sourceId"="reqCandidates"."resumeSourceId") AS "resumeSourecd",
        "reqServiceRequests"."requestName"  AS "position",
        jsonb_agg(
          jsonb_build_object('skillType', "reqSkills"."skillName",'skillId', "reqSkills"."id")
        ) FILTER (WHERE "reqCandidateSkills"."candidateSkillType" = 'primary') AS "candidatePrimarySkills",
        jsonb_agg(
          jsonb_build_object('skillType', "reqSkills"."skillName",'skillId', "reqSkills"."id")
        ) FILTER (WHERE "reqCandidateSkills"."candidateSkillType" = 'secondary') AS "candidateSecondarySkills"
      FROM
        "reqCandidates"
      LEFT JOIN 
        "reqCandidateSkills" ON "reqCandidateSkills"."candidateId" = "reqCandidates"."candidateId"
      LEFT JOIN
        "reqSkills" ON "reqSkills"."id" = "reqCandidateSkills"."candidateSkillId"
      LEFT JOIN 
        "reqServiceRequests" ON "reqCandidates"."candidatesAddingAgainst"="reqServiceRequests"."requestId"    
      WHERE 
        ${conditionString}
      GROUP BY
        "reqCandidates"."candidateId",
        "reqCandidates"."candidateFirstName",
        "reqCandidates"."candidateLastName",
        "reqCandidates"."candidateDoB",
        "reqCandidates"."candidateExperience",
        "reqCandidates"."candidatePreviousOrg",
        "reqCandidates"."candidatePreviousDesignation",
        "reqCandidates"."candidateEducation",
    ${hiddenField}
        "reqCandidates"."candidateAddress",
        "reqCandidates"."candidateEmail",
        "reqCandidates"."candidateMobileNo",
        "reqCandidates"."candidateResume",
        "reqCandidates"."candidateInterviewStatus",
        "reqCandidates"."candidateGender",
        "reqCandidates"."candidateTotalExperience",
        "reqCandidates"."candidateRevlentExperience",
        "reqCandidates"."candidatePreferlocation",
        "reqCandidates"."candidateCity",
        "reqCandidates"."candidateDistrict",
        "reqCandidates"."candidateState",
        "position","resumeSourecd","requestStatus"`);

  if (candidate[0].length == 0) {
    return res
      .status(401)
      .json({ result: false, message: response.CANDIDATE_NOT_FOUND });
  }

  const candidateData = await Promise.all(
    candidate[0].map(async (elm, i) => {
      elm.candidateStatus = candidateStatus;
      // Fetch positions for each candidate using their specific email
      const positions = await reqCandidates.findAll({
        attributes: ["candidatesAddingAgainst"],
        where: { candidateEmail: elm.candidateEmail }, // Use elm.candidateEmail here
        include: [
          {
            model: reqServiceRequest,
            attributes: ["requestId", "requestName", "requestStatus"],
          },
        ],
      });

      // Attach positions to the candidate
      elm.position = positions;
      return elm;
    })
  );

  return res.send({
    result: true,
    message: response.DATA_RETRIEVED,
    data: candidateData,
    comments,
  });
});

function getSixthMonthDate(inputDate) {
  return format(addMonths(new Date(inputDate), 6), "yyyy-MM-dd");
}

async function addSkills(candidateId, parameter) {
  let skills = [];
  //delete previous skills if exist
  let existSkillsCandidate = await reqCandidateSkill.destroy({
    where: { candidateId }
  });
  if (parameter.candidatePrimarySkills) {
    let primarySkills = parameter.candidatePrimarySkills; //.split(",");
    primarySkills.forEach((element) => {
      skills.push({
        candidateId,
        candidateSkillType: "primary",
        candidateSkillId: element,
      });
    });
  }

  if (parameter.candidateSecondarySkills) {
    let secondarySkills = parameter.candidateSecondarySkills; //.split(",");
    secondarySkills.forEach((element) => {
      skills.push({
        candidateId,
        candidateSkillType: "secondary",
        candidateSkillId: element,
      });
    });
  }

  if (skills.length > 0) {
    await reqCandidateSkill.bulkCreate(skills);
  }
}

exports.resumeSourceList = tryCatch(async (req, res) => {

  const sources = await reqCandidateResumeSource.findAll({});
  return res
    .status(200)
    .json({ result: true, message: response.DATA_RETRIEVED, data: sources });

});

async function entryInSequence(requrestId, candidateId, createdBy) {
  try {
    let toDate = format(new Date(), "yyyy-MM-dd");
    let createSequence = await reqServiceSequence.create({
      serviceServiceRequst: requrestId,
      serviceCandidate: candidateId,
      serviceAssignee: createdBy,
      serviceStatus: "sourced",
      insertOrUpdateDate: toDate, //,serviceStation:1
      serviceSourceDate: toDate
    });
  } catch (error) {
    console.log(error);
  }
}

exports.candiateMailList = tryCatch(async (req, res, next) => {

  const search = req.query.search ? decodeURIComponent(req.query.search) : req.query.search;
  const where = { candidateStatus: "active" };
  if (search) {
    const searchLower = search.toLowerCase();
    where[Op.or] = [
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidateFirstName')), { [Op.like]: `%${searchLower}%` }),
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidateLastName')), { [Op.like]: `%${searchLower}%` }),
      Sequelize.where(
        Sequelize.fn('LOWER', Sequelize.fn("concat", Sequelize.col("candidateFirstName"), " ", Sequelize.col("candidateLastName"))),
        { [Op.like]: `%${searchLower}%` }
      ),
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidateEmail')), { [Op.like]: `%${searchLower}%` }),
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidateMobileNo')), { [Op.like]: `%${searchLower}%` }),
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidatePreviousOrg')), { [Op.like]: `%${searchLower}%` }),
    ];
  }

  const candidatesMail = await reqCandidates.findAll({
    attributes: [
      "candidateId",
      "candidateFirstName",
      "candidateLastName",
      "candidateEmail",
      "candidateMobileNo",
      "candidatePreviousOrg",
    ],
    where,
  });

  if (candidatesMail)
    return res
      .status(200)
      .json({ result: true, message: response.DATA_RETRIEVED, data: candidatesMail });
});

exports.removeCandidate = tryCatch(async (req, res, next) => {

  const candidateId = req.body.candidateId;
  const getInterviewStatus = await reqServiceSequence.findAll({
    where: {
      serviceCandidate: candidateId,
      serviceStation: { [Op.is]: null },
    },
    order: [["serviceId", "ASC"]],
    limit: 1,
  });
  if (!getInterviewStatus[0])
    return res.status(401).json({
      result: false,
      message:
        "This candidate is already associated with a requisition and cannot be deleted."
    });
  const candidate = await reqCandidates.findOne({
    where: { candidateId: candidateId, candidateStatus: "active" },
  });
  if (!candidate)
    return res
      .status(401)
      .json({ result: false, message: "candidate not found with this id" });
  if (!candidate.candidateStation == null)
    return res.status(401).json({
      result: false,
      message:
        "cannot delete candidate because candidate moved to interview slots",
    });

  const removedCandidate = await reqCandidates.update(
    { candidateStatus: "inactive" },
    { where: { candidateId: candidateId } }
  );
  if (removedCandidate[0])
    return res.status(200).json({
      result: true,
      message: `candidate ${candidate.candidateFirstName + " " + candidate.candidateLastName
        } removed`,
    });
});

exports.addNewSkill = tryCatch(async (req, res) => {

  let { skillName } = req.query;
  const { typeId } = req.query;

  if (!skillName)
    return res
      .status(401)
      .json({ result: false, message: "skill name is mandatery" });
  if (!typeId)
    return res
      .status(401)
      .json({ result: false, message: "skill Type id is mandatery" });
  // Trim any extra spaces
  skillName = skillName.trim();

  // Find skill case-insensitively
  let skill = await reqSkill.findOne({
    where: {
      skillName: {
        [Op.iLike]: skillName, // Case-insensitive search
      },
    },
  });

  if (!skill) {
    // Skill not found, create it
    skill = await reqSkill.create({ skillName: skillName, typeId: typeId, type: typeId == 1 ? 'soft' : 'tech' });

    return res.status(201).json({
      result: true,
      message: "Skill created",
      skill: skill,
    });
  } else {
    // Skill already exists
    return res.status(400).json({
      result: false,
      message: "Skill already exists",
      skill: skill,
    });
  }
});

exports.deleteSkill = tryCatch(async (req, res, next) => {
  const skillId = req.params.id;

  if (!skillId) {
    return res.status(400).json({
      result: false,
      message: "Skill ID is mandatory"
    });
  }

  const skillRemoved = await reqSkill.destroy({ where: { id: skillId } });

  if (skillRemoved) {
    return res.status(200).json({
      result: true,
      message: "Skill successfully removed"
    });
  }

  return res.status(404).json({
    result: false,
    message: "Skill not found"
  });
});

exports.candidateHistory = tryCatch(async (req, res) => {

  const email = req.query.email;
  const userRole = req.userRole

  const query = `
SELECT  
    "reqCandidates"."candidateId",  
    "reqCandidates"."candidateFirstName",
    "reqCandidates"."candidateLastName",
    "reqCandidates"."candidateEmail",
    "requestName" AS "positionName",
    "requestId" AS "positionId",
 
    jsonb_agg(
        jsonb_build_object(
            'interviewDate', "serviceDate",
            'interviewScheduledBy', "interviewer"."userfirstName",
            'interviewBy', "panelInterviewer"."userfirstName",
            'station', "stationName",
            'interviewType', "interviewRescheduledCount",
            'status', "serviceStatus"
        ) ORDER BY "reqServiceSequences"."serviceId" DESC
    ) AS "interviewDetail"
 
FROM "reqCandidates"
 
LEFT JOIN "reqCandidateRequestions"
    ON "reqCandidates"."candidateId" = "reqCandidateRequestions"."candidateId"
 
LEFT JOIN "reqServiceRequests"
    ON "reqServiceRequests"."requestId" = "reqCandidateRequestions"."serviceRequest"
 
INNER JOIN "reqServiceSequences"
    ON "reqServiceSequences"."serviceCandidate" = "reqCandidates"."candidateId"
    AND "reqServiceSequences"."serviceServiceRequst" = "reqServiceRequests"."requestId"
 
LEFT JOIN "reqUsers" "interviewer"
    ON "interviewer"."userId" = "serviceScheduledBy"
 
LEFT JOIN "reqUsers" "panelInterviewer"
    ON "panelInterviewer"."userId" = "serviceAssignee"
 
LEFT JOIN "reqStations"
    ON "stationId" = "serviceStation"
 
WHERE "reqCandidates"."candidateEmail" = :email
 
GROUP BY  
    "reqCandidates"."candidateId",
    "reqCandidates"."candidateFirstName",
    "reqCandidates"."candidateLastName",
    "reqCandidates"."candidateEmail",
    "requestName",
    "requestId";
`;
  const [data] = await sequelize.query(query, { replacements: { email } });

  const candidateId = data[0]?.candidateId;
  if (!candidateId) return res.status(200).json({ history: data });

  for (let i = 0; i < data.length; i++) {
    const positionId = data[i].positionId;

    /*
    ATTACHMENTS QUERY
    */

    const query2 = `
    SELECT
        "stationName" AS "station",
        "progressFile" AS "uploadedFile",
        "progressCreatedAt" AS "uploadedDate",
        "scheduledBy"."userfirstName" AS "scheduledByName",
        "interviewedBy"."userfirstName" AS "uploadedBy"
   
    FROM "reqServiceSequences"
   
    INNER JOIN "reqUsers" "scheduledBy"
        ON "scheduledBy"."userId"="serviceScheduledBy"
   
    INNER JOIN "reqUsers" "interviewedBy"
        ON "interviewedBy"."userId"="serviceAssignee"
   
    INNER JOIN "reqStations"
        ON "stationId"="serviceStation"
   
    INNER JOIN "reqCandidateProgresses"
        ON "progressServiceSequence"="serviceId"
   
    WHERE
        "progressFile" IS NOT NULL
        AND "serviceCandidate" = :candidateId
        AND "serviceServiceRequst" = :positionId
   
    UNION
   
    SELECT
        "stationName" AS "station",
        "reqOfferAttachments"."attachmentPath" AS "uploadedFile",
        "reqOfferAttachments"."createdAt" AS "uploadedDate",
        "scheduledBy"."userfirstName" AS "scheduledByName",
        "interviewedBy"."userfirstName" AS "uploadedBy"
   
    FROM "reqOfferAttachments"
   
    INNER JOIN "reqUsers" "scheduledBy"
        ON "scheduledBy"."userId"="updatedBy"
   
    INNER JOIN "reqUsers" "interviewedBy"
        ON "interviewedBy"."userId"="updatedBy"
   
    INNER JOIN "reqStations"
        ON "stationId"="station"
   
    WHERE "candidateId" = :candidateId
    `;

    const [attachedData] = await sequelize.query(query2, {
      replacements: { candidateId, positionId },
    });

    data[i].attachedData = attachedData;

    /*
    HISTORY DETAILS
    */

    const [historyDetail] = await sequelize.query(
      `
      SELECT
          "action" AS "historyType",
          "date" AS "historyDate",
          "reqUsers"."userfirstName" AS "historyBy",
          "stationName" AS "station"
   
      FROM "reqCandidateLogs"
   
      INNER JOIN "reqUsers"
          ON "actionBy"="userId"
   
      LEFT JOIN "reqStations"
          ON "stationId"="station"
   
      WHERE "candidateId"=:candidateId
        AND "reqCandidateLogs"."requestId" = :positionId
        AND "action" != 'Candidate Sourced From Indeed'
   
      ORDER BY "id" DESC
      `,
      { replacements: { candidateId, positionId } }
    );

    data[i].historyDetail = historyDetail.map((el) => {
      el.station = !el.station ? "screening" : el.station;
      return el;
    });

    /*
    FEEDBACK DETAILS
    */

    if (req.userRole !== 4 && req.userRole !== 2) {
      const [feedbackDetail] = await sequelize.query(
        `
        SELECT
            "commentComment" AS "feedbackMessage",
            "stationName" AS "station",
            "userfirstName" AS "feedbackBy",
            "commentDate" AS "feedbackDate"
   
        FROM "reqCandidateComments"
   
        INNER JOIN "reqServiceSequences"
            ON "serviceId"="commentSeqenceId"
   
        LEFT JOIN "reqStations"
            ON "serviceStation"="stationId"
   
        INNER JOIN "reqUsers"
            ON "userId"="commentUserId"
   
        WHERE "serviceCandidate"=:candidateId
          AND "reqServiceSequences"."serviceServiceRequst"=:positionId
   
        ORDER BY "commentId" DESC
        `,
        { replacements: { candidateId, positionId } }
      );

      data[i].feedbackDetail = feedbackDetail.map((el) => {
        el.station = !el.station ? "screening" : el.station;
        return el;
      })
    }
  }

  return res.status(200).json({ history: data });
});

exports.submitApplication = tryCatch(async (req, res) => {
  const { candidateFirstName, candidateLastName, candidateEmail, candidateMobileNo, appliedPosition } = req.body;

  // Resolve position: accept either requestId (number) or requestName (string)
  let positionId = appliedPosition;
  if (isNaN(appliedPosition)) {
    const position = await reqServiceRequest.findOne({
      where: { requestName: appliedPosition },
      attributes: ['requestId'],
    });
    if (!position) {
      if (req.file) {
        fs.unlinkSync(req.file.path);
      }
      return res.status(400).json({ status: false, message: "Invalid position. Please select a valid job position." });
    }
    positionId = position.requestId;
  }

  // Get the uploaded resume file path
  if (!req.file) {
    return res.status(400).json({ status: false, message: "CV/Resume file is required" });
  }
  const candidateResume = `/uploads/images/${req.file.filename}`;

  // Check if candidate already applied with same email for the same position
  const existingCandidate = await reqCandidates.findOne({
    where: {
      candidateEmail,
      candidatesAddingAgainst: positionId,
      candidateStatus: "active",
    },
  });

  if (existingCandidate) {
    if (req.file) {
      fs.unlinkSync(req.file.path);
    }
    return res.status(409).json({
      status: false,
      message: "You have already applied for this position",
    });
  }

  // Check if email already exists
  const emailExists = await reqCandidates.findOne({
    where: {
      candidateEmail,
      candidateStatus: "active",
    },
  });

  if (emailExists) {
    if (req.file) {
      fs.unlinkSync(req.file.path);
    }
    return res.status(409).json({
      status: false,
      message: "Email already exists",
    });
  }
    const phNumberExists = await reqCandidates.findOne({
    where: {
      candidateMobileNo,
      candidateStatus: "active",
    },
  });

  if (phNumberExists) {
    if (req.file) {
      fs.unlinkSync(req.file.path);
    }
    return res.status(409).json({
      status: false,
      message: "Phone number already exists",
    });
  }

  // Create the candidate record
  const candidate = await reqCandidates.create({
    candidateFirstName,
    candidateLastName,
    candidateEmail,
    candidateMobileNo,
    candidatesAddingAgainst: positionId,
    // candidateCoverLetter,
    candidateResume,
    candidateStatus: "active",
    candidateInterviewStatus: "inprogress"
  });

  const candidateId = candidate.candidateId;
  const today = format(new Date(), "yyyy-MM-dd");

  // Add to candidate requestion table for visibility in list API
  await reqCandidateRequestion.create({
    candidateId: candidateId,
    serviceRequest: positionId,
    interviewStatus: "inprogress"
  });

  // Create the sequence entry for station 1 (Screening)
  const sequenceData = {
    serviceCandidate: candidateId,
    serviceServiceRequst: positionId,
    serviceStatus: "pending",
    insertOrUpdateDate: today,
    serviceScheduledBy: null // Since it's a website application
  };
  await reqServiceSequence.create(sequenceData);

  const sourcedString = "Candidate Applied via Website";
  // Log the application
  logFunction(candidateId, null, sourcedString, 1, positionId);

  // Update reports
  await profileSourceReport(null, positionId, [4], today, candidateId);

  reqcuriterReport(
    positionId,
    today,
    null,
    "totalSourced",
    1
  );

  return res.status(201).json({
    status: true,
    message: "Application submitted successfully",
    data: {
      candidateId: candidate.candidateId,
      name: `${candidateFirstName} ${candidateLastName}`,
      email: candidateEmail,
      position: positionId,
    },
  });
});

exports.jobApply = tryCatch(async (req, res) => {
  const { candidateFirstName, candidateLastName, candidateEmail, candidateMobileNo, appliedPosition } = req.body;

  // Resolve position: accept either requestId (number) or requestName (string)
  let positionId;
  if (isNaN(appliedPosition)) {
    // Lookup by name in reqJobOpenings
    const position = await reqJobOpening.findOne({
      where: { requestName: appliedPosition },
      attributes: ['requestId'],
    });
    if (!position) {
      if (req.file) {
        fs.unlinkSync(req.file.path);
      }
      return res.status(400).json({ result: false, message: "Invalid position. Please select a valid job position." });
    }
    positionId = position.requestId;
  } else {
    // Validate numeric ID actually exists in reqJobOpenings
    const position = await reqJobOpening.findOne({
      where: { requestId: appliedPosition },
      attributes: ['requestId'],
    });
    if (!position) {
      if (req.file) {
        fs.unlinkSync(req.file.path);
      }
      return res.status(400).json({ result: false, message: "Invalid position. Please select a valid job position." });
    }
    positionId = position.requestId;
  }

  // Get the uploaded resume file path
  if (!req.file) {
    return res.status(400).json({ status: false, message: "CV/Resume file is required" });
  }
  const candidateResume = `/uploads/images/${req.file.filename}`;

  // Check if candidate already applied with same email for the same position
  const existingCandidate = await reqJobApplicants.findOne({
    where: {
      candidateEmail,
      candidatesAddingAgainst: positionId,
      candidateStatus: "active",
    },
  });

  if (existingCandidate) {
    if (req.file) {
      fs.unlinkSync(req.file.path);
    }
    return res.status(409).json({
      status: false,
      message: "Already applied for this position",
    });
  }

  // Check if email already exists
  // const emailExists = await reqJobApplicants.findOne({
  //   where: {
  //     candidateEmail,
  //     candidateStatus: "active",
  //   },
  // });

  // if (emailExists) {
  //   if (req.file) {
  //     fs.unlinkSync(req.file.path);
  //   }
  //   return res.status(409).json({
  //     status: false,
  //     message: "Email already exists",
  //   });
  // }
  //   const phNumberExists = await reqJobApplicants.findOne({
  //   where: {
  //     candidateMobileNo,
  //     candidateStatus: "active",
  //   },
  // });

  // if (phNumberExists) {
  //   if (req.file) {
  //     fs.unlinkSync(req.file.path);
  //   }
  //   return res.status(409).json({
  //     status: false,
  //     message: "Phone number already exists",
  //   });
  // }

  // Create the candidate record
  const candidate = await reqJobApplicants.create({
    candidateFirstName,
    candidateLastName,
    candidateEmail,
    candidateMobileNo,
    candidatesAddingAgainst: positionId,
    // candidateCoverLetter,
    candidateResume,
    candidateStatus: "active",
    candidateInterviewStatus: "sourced"
  });

  const candidateId = candidate.candidateId;
  const today = format(new Date(), "yyyy-MM-dd");

  // Add to candidate requestion table for visibility in list API

  // await reqCandidateRequestion.create({
  //   candidateId: candidateId,
  //   serviceRequest: positionId,
  //   interviewStatus: "inprogress"
  // });

  // Create the sequence entry for station 1 (Screening)

  // const sequenceData = {
  //   serviceCandidate: candidateId,
  //   serviceServiceRequst: positionId,
  //   serviceStatus: "pending",
  //   insertOrUpdateDate: today,
    serviceScheduledBy: null // Since it's a website application
  // };

  // await reqServiceSequence.create(sequenceData);

  const sourcedString = "Candidate Applied via Website";
  // Log the application
  logFunction(candidateId, null, sourcedString, 1, positionId);

  // Update reports
  await profileSourceReport(null, positionId, [4], today, candidateId);

  reqcuriterReport(
    positionId,
    today,
    null,
    "totalSourced",
    1
  );

  return res.status(201).json({
    status: true,
    message: "Application submitted successfully",
    data: {
      candidateId: candidate.candidateId,
      name: `${candidateFirstName} ${candidateLastName}`,
      email: candidateEmail,
      position: positionId,
    },
  });
});

exports.uploadResume = async (req, res) => {
  try {
    // Check if a file was uploaded
    if (!req.file) {
      return res.status(400).json({ 
        result: false,
        message: "Please upload a resume (.pdf, .doc, .docx)."
      });
    }

    const protocol = req.headers['x-forwarded-proto'] || req.protocol;
    const host = req.headers['x-forwarded-host'] || req.get('host');
    const relativePath = `qa_uploads_docs/${req.file.filename}`;
    const fileUrl = `${protocol}://${host}/${relativePath}`;

    return res.status(200).json({
      result: true,
      message: "Resume uploaded successfully.",
      data: {
        fileName: req.file.filename,
        filePath: relativePath,
        fileUrl: fileUrl
      }
    });
  } catch (error) {
    console.error("Resume Upload Error:", error);

    return res.status(500).json({
      result: false,
      message: "Failed to upload resume.",
      error: error.message
    });
  }
};

exports.sourcedCandidates = tryCatch(async (req, res) => {
  const report = req.query.report;
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  const experience = req.query.exprience;
  let ids = req.query.ids;

  const search = req.query.search ? decodeURIComponent(req.query.search) : req.query.search;
  const skills = req.query.skills;
  const recuriter = req.query.recuriter;
  const serviceRequestId = req.query.serviceRequestId;
  const where = {
    candidateStatus: "active",
    candidateInterviewStatus: "sourced",
  };
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }
  // this statement is used to filter candidates in service request
  const data = req.url.split("/");
  const urlCandidates = data.includes("candidates");
  if (urlCandidates) {
    where.candidateStation = {
      [Op.is]: null,
    };
  }
  if (serviceRequestId)
    where.candidatesAddingAgainst = { [Op.eq]: serviceRequestId };
  if (experience) {
    if (experience == 0) {
      where.candidateExperience = { [Op.eq]: experience };
    } else {
      where.candidateExperience = { [Op.gte]: experience };
    }
  }
  if (ids?.length) {
    ids = Array.isArray(ids) ? ids : [ids];
    where.candidateId = { [Op.in]: ids };
  }
  if (search) {
    const searchLower = search.toLowerCase();
    where[Op.or] = [
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidateFirstName')), { [Op.like]: `%${searchLower}%` }),
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidateLastName')), { [Op.like]: `%${searchLower}%` }),
      Sequelize.where(
        Sequelize.fn('LOWER', Sequelize.fn("concat", Sequelize.col("candidateFirstName"), " ", Sequelize.col("candidateLastName"))),
        { [Op.like]: `%${searchLower}%` }
      ),
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidateEmail')), { [Op.like]: `%${searchLower}%` }),
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidateMobileNo')), { [Op.like]: `%${searchLower}%` }),
      Sequelize.where(Sequelize.fn('LOWER', Sequelize.col('candidatePreviousOrg')), { [Op.like]: `%${searchLower}%` }),
    ];
  }
  const recuriterCondition = { where: {} };
  if (recuriter) {
    recuriterCondition.where = { userId: recuriter };
  }
  const candidateSkill = {};
  if (skills) {
    candidateSkill.candidateSkillId = skills;
  }
  const include = [
    { model: reqServiceRequest, attributes: ["requestName", "requestId"] },
    {
      model: reqCandidateRequestion,as: "candidateReqst",
      include: [{ model: reqServiceRequest,as:'serviceRequestion', attributes: ["requestName", "requestId"] }]
    },
    {
      model: reqUser,
      as: "createdBy",
      required: false,
      where: recuriterCondition.where,
      attributes: ['userEmail', 'userFullName', 'userfirstName', 'userlastName'],
    },
    {
      model: reqCandidateSkill,
      as: "candidateSkill",
      required: false,
      attributes: ["candidateSkillType", "candidateSkillId"],
      where: candidateSkill,
      include: { model: reqSkill, as: "skills" },
    },
  ];

  const subQuery = `SELECT MAX("candidateId") as "candidateId" FROM "reqCandidates" GROUP BY "candidateEmail"`;

  const [results] = await sequelize.query(subQuery);

  where.candidateId = {
    [Op.in]: results.map((result) => result.candidateId),
  };

  const candidateCount = await reqCandidates.count({
    include,
    where,
    distinct: true,
  });

  const pageCount =
  report === "true"
    ? 1
    : Math.ceil(candidateCount / Number(limit));

  const candidates = await reqCandidates.findAll({
    include,
    attributes: { exclude: ["candidateCurrentSalary", "candidateExpectedSalary"] },
    where,
    ...(report == "true" ? {} : {
      limit: limit,
      offset: offset
    }),
    distinct: true,
    order: [["candidateId", "DESC"]],
  });

  if (report == "true" && candidates) {
    const head = [
      { header: "Candidate Id", key: "candidateId", width: 10 },
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
      { header: "Candidate Email", key: "candidateEmail", width: 25 },
      { header: "Candidate Mobile", key: "candidateMobileNo", width: 25 },
      {
        header: "Candidate Prev Org",
        key: "candidatePreviousOrg",
        width: 25,
      },
      {
        header: "Candidate Designation",
        key: "candidatePreviousDesignation",
        width: 25,
      },
      {
        header: "Candidate Current Salary",
        key: "candidateCurrentSalary",
        width: 25,
      },
      {
        header: "Candidate Expected Salary",
        key: "candidateExpectedSalary",
        width: 25,
      },
      { header: "candidate City", key: "candidateCity", width: 10 },
      { header: "candidate Education", key: "candidateEducation", width: 10 },
    ];

    const body = candidates.map((le) => {
      return {
        candidateId: le.candidateId,
        candidateFirstName: le.candidateFirstName,
        candidateLastName: le.candidateLastName,
        candidateExperience: le.candidateExperience,
        candidateEmail: le.candidateEmail,
        candidateMobileNo: le.candidateMobileNo,
        candidatePreviousOrg: le.candidatePreviousOrg,
        candidatePreviousDesignation: le.candidatePreviousDesignation,
        candidateCurrentSalary: le.candidateCurrentSalary,
        candidateExpectedSalary: le.candidateExpectedSalary,
        candidateCity: le.candidateCity,
        candidateEducation: le.candidateEducation,
      };
    });
    const name = `candidates${format(new Date(), "yyyyMMddHHmmss")}`;
    excelGenerator(req, res, head, body, name);
    return;
  }
  if (candidates)
    return res.status(200).json({
      result: true,
      message: "Candidates found",
      candidateCount,
      pageCount,
      candidates: candidates.map((el) => {
        // Convert reqServiceRequest to an array and merge with candidateReqst
        const serviceRequests = [
          ...(Array.isArray(el.candidateReqst) ? el.candidateReqst.map(req => req.serviceRequestion) : []),
        ];
        return {
          ...el.toJSON(),
          reqServiceRequest: serviceRequests
        };
      }),
    });
  throw new Error(response.CANDIDATES_NOTFOUND);
});

exports.jobOpeningCareers = tryCatch(async (req, res) => {
  let limit = Number(req.query.limit) || 100;
  let page = Number(req.query.page) || 1;
  const report = req.query.report;

  const offset = (page - 1) * limit;

  const { count, rows: jobOpenings } = await reqJobOpening.findAndCountAll({
    ...(report === "true"
      ? {}
      : {
          limit,
          offset,
        }),
    order: [["requestId", "DESC"]],
  });

  const totalPages = report === "true" ? 1 : Math.ceil(count / limit);

  if (jobOpenings.length) {
    // Fetch all mappings for the current page's job openings in one query
    const jobOpeningIds = jobOpenings.map((j) => j.requestId);
    const mappings = await reqServiceRequestsJobOpenings.findAll({
      where: { jobOpeningId: { [Op.in]: jobOpeningIds } },
      attributes: ["jobOpeningId", "requisitionId"],
      raw: true,
    });

    // Build a lookup map: jobOpeningId -> requisitionId
    const mappingMap = {};
    mappings.forEach((m) => {
      mappingMap[m.jobOpeningId] = m.requisitionId;
    });

    const data = jobOpenings.map((job) => {
      const jobJson = job.toJSON();
      const requisitionId = mappingMap[job.requestId];
      return {
        ...jobJson,
        isAssigned: requisitionId !== undefined,
        assignedRequisitionId: requisitionId ?? null,
      };
    });

    return res.status(200).json({
      result: true,
      message: response.DATA_RETRIEVED,
      totalCount: count,
      totalPages,
      currentPage: report === "true" ? 1 : page,
      pageSize: limit,
      data,
    });
  }

  throw new Error(response.JOB_OPENINGS_NOT_FOUND);
});

exports.jobCareerApplications = tryCatch(async (req, res) => {
  try {
    let limit = Number(req.query.limit) || 100;
    let page = Number(req.query.page) || 1;
    const report = req.query.report;
    const search = req.query.search;

    const offset = (page - 1) * limit;

    const whereCondition = {
      candidateInterviewStatus: "sourced",
    };

    if (search && search.trim() !== "") {
      const searchPattern = `%${search.trim()}%`;
      whereCondition[Op.or] = [
        { candidateFirstName: { [Op.iLike]: searchPattern } },
        { candidateLastName: { [Op.iLike]: searchPattern } },
        Sequelize.where(
          Sequelize.fn("concat", Sequelize.col("candidateFirstName"), " ", Sequelize.col("candidateLastName")),
          { [Op.iLike]: searchPattern }
        ),
        { candidateEmail: { [Op.iLike]: searchPattern } },
        { candidateMobileNo: { [Op.iLike]: searchPattern } },
        { candidatePreviousOrg: { [Op.iLike]: searchPattern } },
        { candidatePreviousDesignation: { [Op.iLike]: searchPattern } },
      ];
    }

const { count, rows: jobApplicants } = await reqJobApplicants.findAndCountAll({
  where: whereCondition,
  include: [
    {
      model: reqJobOpening,
      as: "jobOpening",
      attributes: ["requestName"],
      required: false,
    },
  ],
  ...(report === "true"
    ? {}
    : {
        limit,
        offset,
      }),
  order: [["candidateId", "DESC"]],
});

  const totalPages =
    report === "true" ? 1 : Math.ceil(count / limit);

    const data = jobApplicants.map((item) => {
  const applicant = item.toJSON();

  return {
    ...applicant,
    requisitionName: applicant.jobOpening?.requestName || null,
  };
});

  if (jobApplicants.length) {
    return res.status(200).json({
      result: true,
      message: response.DATA_RETRIEVED,
      totalCount: count,
      totalPages,
      currentPage: report === "true" ? 1 : page,
      pageSize: limit,
      data
    });
  } else {
    return res.status(404).json({
      result: false,
      message: "No job career applications found.",
    });
  }
} catch (error) {
  console.error("Error fetching job career applications:", error);
  return res.status(500).json({
    result: false,
    message: "An error occurred while fetching job career applications.",
  });
}
});