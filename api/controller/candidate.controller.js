const fs = require('fs');
let {
  reqCandidates, reqCandidateResumeSource, reqUser,
  reqCandidateSkill, sequelize, Sequelize,
  reqSkill, reqStation, reqServiceRequest,
  reqCandidateComments, reqServiceSequence, reqCandidateRequestion
} = require("../../models");
const moment = require("moment");
const { Op, where } = require("sequelize");
let { excelGenerator } = require("../utils/excelGenerator");
let { logFunction, profileSourceReport } = require("../utils/commonFunction");
let jsonData = require("../utils/userRignts.json");
const { tryCatch } = require("../utils/trycatch");

exports.createCandidate = tryCatch(async (req, res) => {
  let { ...parameter } = req.body;
  let {
    candidateEmail,
    candidateCreatedby,
    candidatesAddingAgainst,
    resumeSourceId,
  } = parameter;

  let sourcedString = `Candidate Sourced From ${jsonData.sourceList[resumeSourceId]}`;
  const candidateIspresent = await reqCandidates.findOne({
    where: {
      candidateEmail,
      candidateStatus: "active",
    },
  });

  if (!candidateIspresent) {
    let candiate = await reqCandidates.create(parameter);
    let candidateId = candiate.candidateId;
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
  const sixthMonthDate = getSixthMonthDate(candidateIspresent.createdAt);
  const currentDate = moment();
  const currentDateGreaterThis = moment(sixthMonthDate);
  if (currentDate.isAfter(currentDateGreaterThis)) {
    let candidate = await reqCandidates.create(parameter);
    let candidateId = candidate.candidateId;
    // if (candidatesAddingAgainst) await profileSourceReport(candidateCreatedby, candidatesAddingAgainst, [resumeSourceId]);

    logFunction(candidateId, candidateCreatedby, sourcedString, 1);
    await entryInSequence(
      candidatesAddingAgainst,
      candidateId,
      candidateCreatedby
    );
    return res.status(200).json({
      status: true,
      message: "Candidate Created Successfully",
      data: candidate,
    });
  } else {
    return res.status(401).json({
      status: false,
      message:
        "This candidate is already in the pool. Eligible again six months after attendance date",
    });
  }
});

exports.editCandidate = tryCatch(async (req, res) => {
  let { ...parameter } = req.body;
  let { candidateId } = parameter;

  const candidateIspresent = await reqCandidates.findOne({
    where: {
      candidateId,
      candidateStatus: "active",
    },
  });
  if (!candidateIspresent)
    return res
      .status(401)
      .json({ status: false, message: "Candidate not found" });
  let updatedCandidate = await reqCandidates.update(parameter, {
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
  let report = req.query.report;
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  let experience = req.query.exprience;
  let ids = req.query.ids;

  let search = req.query.search ? decodeURIComponent(req.query.search) : req.query.search;
  let skills = req.query.skills;
  let recuriter = req.query.recuriter;
  let serviceRequestId = req.query.serviceRequestId;
  let where = {
    candidateStatus: "active",
  };
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }
  // this statement is used to filter candidates in service request
  let data = req.url.split("/");
  let urlCandidates = data.includes("candidates");
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
  let recuriterCondition = { where: {} };
  if (recuriter) {
    recuriterCondition.where = { userId: recuriter };
  }
  let candidateSkill = {};
  if (skills) {
    candidateSkill.candidateSkillId = skills;
  }
  let include = [
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

  let candidateCount = await reqCandidates.count({
    include,
    where,
    distinct: true,
  });

  let candidates = await reqCandidates.findAll({
    include,
    attributes: { exclude: ["candidateCurrentSalary", "candidateExpectedSalary"] },
    where,
    ...(report == "true" ? {} : {
      limit: limit,
      offset: offset
    }),
    distinct: true,
    order: [[Sequelize.literal('"candidatesAddingAgainst" IS NULL'), 'DESC'], ["candidateId", "DESC"]],
  });

  if (report == "true" && candidates) {
    let head = [
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

    let body = candidates.map((le) => {
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
    let name = `candidates${moment().format("yyyymmddHHMMSS")}`;
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
  throw new Error("Candidates not found");
});

exports.candidateCompareList = tryCatch(async (req, res) => {
  let report = req.query.report;
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  let experience = req.query.exprience;
  let search = req.query.search ? decodeURIComponent(req.query.search) : req.query.search;
  let skills = req.query.skills;
  let recuriter = req.query.recuriter;
  let serviceRequestId = req.query.serviceRequestId;
  let where = { candidateStatus: "active" };
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }
  // this statement is used to filter candidates in service request
  let data = req.url.split("/");
  let urlCandidates = data.includes("candidates");
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
  let recuriterCondition = { where: {} };
  if (recuriter) {
    recuriterCondition.where = { userId: recuriter };
  }
  let candidateSkill = {};
  if (skills) {
    candidateSkill.candidateSkillId = skills;
  }
  let include = [
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

  let candidateCount = await reqCandidates.count({
    include,
    where,
    distinct: true,
  });

  let candidates = await reqCandidates.findAll({
    include,
    attributes: { exclude: ["createdAt", "updatedAt", "candidateCurrentSalary", "candidateExpectedSalary"] },
    where,
    limit: limit,
    offset: offset,
    order: [["candidateId", "DESC"]],
  });
  if (report && candidates) {
    let head = [
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

    let body = candidates.map((le) => {
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
    let name = `candidates${moment().format("yyyymmddHHMMSS")}`;
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
  throw new Error("Candidates not found");
});

exports.viewCandidate = tryCatch(async (req, res) => {

  let candidateId = req.params.candidateId;
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
  let candidate = await sequelize.query(`SELECT
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
      .json({ result: false, message: "Candidate not found" });
  }

  let candidateData = await Promise.all(
    candidate[0].map(async (elm, i) => {
      elm.candidateStatus = candidateStatus;
      // Fetch positions for each candidate using their specific email
      let positions = await reqCandidates.findAll({
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
    message: "data retrived",
    data: candidateData,
    comments,
  });
});

function getSixthMonthDate(inputDate) {
  // Parse the input date using moment
  const date = moment(inputDate);

  // Add six months to the date
  date.add(6, "months");

  // Return the resulting date
  return moment(date.toDate()).format("YYYY-MM-DD");
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

  let sources = await reqCandidateResumeSource.findAll({});
  return res
    .status(200)
    .json({ result: true, message: "data retrived", data: sources });

});

async function entryInSequence(requrestId, candidateId, createdBy) {
  try {
    let toDate = moment().format("YYYY-MM-DD");
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

  let search = req.query.search ? decodeURIComponent(req.query.search) : req.query.search;
  let where = { candidateStatus: "active" };
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

  let candidatesMail = await reqCandidates.findAll({
    attributes: [
      "candidateId",
      "candidateFirstName",
      "candidateLastName",
      "candidateEmail",
      "candidateMobileNo",
    ],
    where,
  });

  if (candidatesMail)
    return res
      .status(200)
      .json({ result: true, message: "data retrived", data: candidatesMail });
});

exports.removeCandidate = tryCatch(async (req, res, next) => {

  let candidateId = req.body.candidateId;
  let getInterviewStatus = await reqServiceSequence.findAll({
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
        "candidte is not in screening station, So you are not able to Delte.j",
    });
  let candidate = await reqCandidates.findOne({
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

  let removedCandidate = await reqCandidates.update(
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

  let { skillName, typeId } = req.query;

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
  let skillId = req.params.id;

  if (!skillId) {
    return res.status(400).json({
      result: false,
      message: "Skill ID is mandatory"
    });
  }

  let skillRemoved = await reqSkill.destroy({ where: { id: skillId } });

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

  let email = req.query.email;

  let query = `
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
  let [data] = await sequelize.query(query, { replacements: { email } });

  let candidateId = data[0]?.candidateId;
  if (!candidateId) return res.status(200).json({ history: data });

  for (let i = 0; i < data.length; i++) {
    let positionId = data[i].positionId;

    /*
    ATTACHMENTS QUERY
    */

    let query2 = `
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

    let [attachedData] = await sequelize.query(query2, {
      replacements: { candidateId, positionId },
    });

    data[i].attachedData = attachedData;

    /*
    HISTORY DETAILS
    */

    let [historyDetail] = await sequelize.query(
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

    if (req.userRole !== "panel" && req.userRole !== "manager") {
      let [feedbackDetail] = await sequelize.query(
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
      });
    } else {
      data[i].feedbackDetail = [];
    }
  }

  return res.status(200).json({ history: data });
});

exports.submitApplication = tryCatch(async (req, res) => {
  const { candidateFirstName, candidateLastName, candidateEmail, candidateMobileNo, appliedPosition, candidateCoverLetter } = req.body;

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

  // Create the candidate record
  const candidate = await reqCandidates.create({
    candidateFirstName,
    candidateLastName,
    candidateEmail,
    candidateMobileNo,
    candidatesAddingAgainst: positionId,
    candidateCoverLetter,
    candidateResume,
  });

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