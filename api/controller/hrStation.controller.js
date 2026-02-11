let moment = require('moment');
let { Op } = require('sequelize');
let mailFunction = require('../utils/nodeMail');
const { tryCatch } = require("../utils/trycatch");
let { excelGenerator, } = require('../utils/excelGenerator');
let { reqServiceSequence, reqCandidates, reqServiceRequest,
  reqUser, reqHrReview, reqServices, reqCandidateComments,
  sequelize, Sequelize, reqReport, reqServiceSequencesAcitve,
  reqCandidateProgress, reqProgressSkill, reqOfferAttachments,reqTeam } = require("../../models");
let { updateReportData, logFunction, reqestionStatusUpdate, reqcuriterReport, isRequestionClosed } = require('../utils/commonFunction');
const e = require('express');

exports.list = tryCatch(async (req, res) => {
  let report = req.query.report;
  let search = req.query.search;
  let statusFilter = req.query.status_filter;
  let position = req.query.position;
  let ids = req.query.ids;
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  let experience = req.query.experience;
  let fromDate = req.query.fromDate ? new Date(moment(req.query.fromDate).format('YYYY-MM-DD')) : "";
  let toDate = req.query.toDate;
  if (toDate) {
    // Parse the toDate using Moment.js
    let momentDate = moment(toDate);

    // Set the time to 12 PM
    momentDate.set({
      hour: 23,
      minute: 59,
      second: 59,
      millisecond: 0,
    })

    toDate = momentDate.toDate();
  } else {
    toDate = '';
  }
  offset = offset == 1 ? 0 : offset;
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }

  let where = { serviceStation: 5 };
  if (fromDate && toDate) where.serviceDate = { [Op.between]: [fromDate, toDate] }
  if (statusFilter) where.serviceStatus = statusFilter;
  if (position) where.serviceServiceRequst = position;
  let searchCondition = {};
  if (ids?.length) {
    ids = Array.isArray(ids) ? ids : [ids];
    where.serviceId = { [Op.in]: ids }
  }
  if (experience) {
    // searchCondition.candidateRevlentExperience = { [Op.lte]: experience };
    searchCondition.candidateTotalExperience = {
      [Sequelize.Op.and]: [
        Sequelize.where(
          Sequelize.cast(Sequelize.col('candidateTotalExperience'), 'FLOAT'),
          { [Op.gte]: experience }
        )
      ]
    };
  }
  if (search) {
    searchCondition = {
      [Op.or]: [{ candidateFirstName: { [Op.iLike]: `${search}%` } },
      { candidateLastName: { [Op.iLike]: `${search}%` } },
      { candidateEmail: { [Op.iLike]: `${search}%` } }]
    }

  }

  let include = [
    {
      model: reqServiceRequest,
      as: "serviceRequest",
      required: true,
    },
    {
      model: reqCandidates,
      attributes: {
        exclude: [
          "createdAt",
          "updatedAt",
          "candidateStatus",
          "candidateCreatedby",
        ],
      },
      as: "candidate",
      required: true, where: searchCondition
    },
  ]

  let candidates = await reqServiceSequencesAcitve.findAll({
    attributes: {
      include: [
        [
          sequelize.literal(`(SELECT COUNT(*)
            FROM "reqHrReviews" AS "progress" WHERE "progress"."reviewedServiceId"="reqServiceSequencesAcitve"."serviceId")`), 'progressStatus'
        ], [
          sequelize.literal(`(SELECT "stationName"
                    FROM "reqServiceSequencesAcitves" AS "sequence" INNER JOIN "reqStations" ON "stationId"="serviceStation" WHERE "sequence"."serviceCandidate"="reqServiceSequencesAcitve"."serviceCandidate" ORDER BY "serviceId" DESC LIMIT 1)`),
          "currentStation",
        ],

        [
          sequelize.literal(`(SELECT COUNT(*)
                    FROM "reqCandidateProgresses" AS "review" WHERE "review"."progressServiceSequence"="reqServiceSequencesAcitve"."serviceId" AND "review"."progressStation"=5)`),
          "reviewStatus",
        ]]
    },
    include,
    raw: true, limit, offset,
    where, order: [['serviceId', 'DESC']]
  });
  let totalCount = await reqServiceSequencesAcitve.count({ where, include });

  if (report == 'true' && candidates) {
    let head = [{ header: "Request Name", key: "requestName", width: 10 },
    { header: "Candidate First Name", key: "candidateFirstName", width: 25 },
    { header: "Candidate Last Name", key: "candidateLastName", width: 15 },
    { header: "Candidate Experience", key: "candidateExperience", width: 15 },
    { header: "Candidate Email", key: "candidateEmail", width: 25 },
    { header: "Candidate Mobile", key: "candidateMobileNo", width: 25 },
    { header: "Candidate Prev Org", key: "candidatePreviousOrg", width: 25 },
    {
      header: "Candidate Designation",
      key: "candidatePreviousDesignation",
      width: 25,
    },
    {
      header: "Candidate Interview Status",
      key: "candidateInterviewStatus",
      width: 25,
    },
    {
      header: "Candidate Current Station",
      key: "candidateCurrentStation",
      width: 25,
    },
    { header: "Candidate Station Status", key: "candidateStationStatus", width: 10 }];

    let body = candidates.map((le) => {
      return {
        requestName: le['serviceRequest.requestName'],
        candidateFirstName: le['candidate.candidateFirstName'],
        candidateLastName: le['candidate.candidateLastName'],
        candidateExperience: le['candidate.candidateExperience'],
        candidateEmail: le['candidate.candidateEmail'],
        candidateMobileNo: le['candidate.candidateMobileNo'],
        candidatePreviousOrg: le['candidate.candidatePreviousOrg'],
        candidatePreviousDesignation: le['candidate.candidatePreviousDesignation'],
        candidateInterviewStatus: le['candidate.candidateInterviewStatus'],
        candidateCurrentStation: le['currentStation'],
        candidateStationStatus: le['serviceStatus']
      };
    });
    let name = `candidates_technical_1_${moment().format('yyyymmddHHMMSS')}`;
    excelGenerator(req, res, head, body, name);
    return;
  }
  if (candidates)
    return res.status(200).json({
      result: true,
      message: "HR Candidates Found",
      candidates, totalCount
    });
  return res
    .status(401)
    .json({ result: false, message: "HR Candidates Not Found" });
});


exports.fetchFinalCandidte = tryCatch(async (req, res) => {
  let serviceId = req.query.serviceId;
  let hrReviewInclude = { model: reqHrReview };
  if (req.userRole == 'visitor') {
    hrReviewInclude.attributes = { exclude: ["reviewedSalary"] };
  }

  let candidates = await reqServiceSequence.findOne({
    attributes: [
      "serviceId",
      "serviceStation",
      "serviceServiceRequst",
      "serviceCandidate",
      "serviceAssignee",
      [
        Sequelize.literal(`(
        SELECT CONCAT("userfirstName", ' ', "userlastName") FROM "reqUsers" WHERE "userId"="serviceAssignee" )`),
        "pannelName"
      ],
      ["serviceDate", "interviewTime"],
      [
        Sequelize.literal(`CASE WHEN "interviewRescheduled" IS NULL THEN 'scheduled' ELSE 'rescheduled' END`),
        "interviewstatus"
      ],
      "interviewMode",
      "serviceStatus",
      "serviceServiceId",
      "serviceScheduledBy",
      "previousCurrentStation",
      "interviewCount",
      "interviewRescheduledCount",
      "interviewLocation",
      "interviewMail",
      "interviewMailType"
    ],
    include: [
      {
        model: reqCandidates,
        as: "candidate",
        include: [
          {
            model: reqUser,
            as: "createdBy",
            attributes: ["userfirstName", "userlastName", "userEmail"],
          },
        ],
        attributes: {
          exclude: ["createdAt", "updatedAt", "candidateStatus"],
        },
      },
      { model: reqCandidateProgress, as: "progress" },
      {
        model: reqServiceRequest,
        as: "serviceRequest",
        required: true,
      },
      hrReviewInclude,
    ],
    where: { serviceId },
  });
  //here we have to add last station review also----------------------------------

  if (candidates) {
    let candidateComments = await reqCandidateComments.findOne({ where: { offerReleaseReject: 1, commentSeqenceId: serviceId } });
    const [skills] = await sequelize.query(
      `SELECT * FROM "reqCandidateSkills"
       INNER JOIN "reqSkills" ON "candidateSkillId"="reqSkills"."id"
       WHERE "candidateId"=:candidateId`,
      { replacements: { candidateId: candidates.serviceCandidate } }
    );

    const [skillScore] = await sequelize.query(
      `SELECT * FROM "reqProgressSkills"
       INNER JOIN "reqSkills" ON "reqProgressSkills"."skillId"="reqSkills"."id"
       WHERE "serviceSeqId"=:serviceId`,
      { replacements: { serviceId: serviceId } }
    );

    // Convert the candidates to a plain object before modifying it
    const plainCandidates = candidates.get({ plain: true });

    // Add skills and skillScore to the plain object
    plainCandidates.skills = skills; // Add skills to candidates
    plainCandidates.skillScore = skillScore; // Add skillScore to candidates
    plainCandidates.reqCandidateComments = candidateComments;

    return res.status(200).json({
      result: true,
      message: "HR Candidates Found",
      candidates: plainCandidates // Return the modified plain candidates object
    });
  }

  return res
    .status(401)
    .json({ result: false, message: "HR Candidates Not Found" });
});



exports.candidateOffers = tryCatch(async (req, res) => {
  let { offerServiceSeqId, offerSalary, offerRleasedBy, offerDescription, offerJoinDate, offerMailTemp, offerMailSubject, offerMailBackCc, offerMailBackBcc, attachmentArray } = req.body;

  let requestionActive = await isRequestionClosed(offerServiceSeqId);
  if (!requestionActive) return res
    .status(400)
    .json({ result: false, message: "Requestion is closed No action Can be taken." })

  let serviceSeq = await reqServiceSequence.findOne({ where: { serviceId: offerServiceSeqId } });
  if (!serviceSeq) return res.status(401).json({ result: false, message: "offerServiceSeqId Not Found" });

  const [progress, created] = await reqHrReview.findOrCreate({
    where: { reviewedServiceId: offerServiceSeqId },
    defaults: {
      reviewedServiceId: offerServiceSeqId,
      reviewedSalary: offerSalary,
      reviewedDescription: offerDescription,
      reviewedJoiningDate: offerJoinDate
    }
  });

  await updateReportData('offerReleased', offerRleasedBy, serviceSeq.serviceServiceRequst);
  let getCandidateMail = await reqCandidates.findOne({ where: { candidateId: serviceSeq.serviceCandidate } });
  if (getCandidateMail) {

    await mailFunction.sendEmail(
      getCandidateMail.candidateEmail,
      offerMailSubject,
      offerMailTemp, offerMailBackCc, offerMailBackBcc, attachmentArray
    );
  }
  let attachmentsData = attachmentArray.map(el => {
    return {
      candidateId: serviceSeq.serviceCandidate,
      attachmentPath: el.filename,
      updatedBy: offerRleasedBy,
      station: 5
    }
  });

  await reqOfferAttachments.bulkCreate(attachmentsData);
  await reqCandidateComments.create({
    commentSeqenceId: offerServiceSeqId,
    commentComment: offerDescription,
    commentUserId: offerRleasedBy,

  });

  logFunction(serviceSeq.serviceCandidate, offerRleasedBy, `Offer Released`, 5);

  reqcuriterReport(serviceSeq.serviceServiceRequst, moment().format("YYYY-MM-DD"), offerRleasedBy, 'offerReleased');
  if (created) return res.status(200).json({ result: true, message: "Offer  details added" });
  return res.status(401).json({ result: false, message: "this offer already exists" });

});


exports.candidateToUser = tryCatch(async (req, res) => {
  let toDate = moment().format('YYYY-MM-DD');
  let { serviceSeqId, feedBack, feedBackBy } = req.body;

  let requestionActive = await isRequestionClosed(serviceSeqId);
  if (!requestionActive) return res
    .status(400)
    .json({ result: false, message: "Requestion is closed No action Can be taken." })

  let getCandidateService = await reqServiceSequence.findOne({
    where: { serviceId: serviceSeqId, serviceStatus: 'pending' },
    include: [{ model: reqCandidates, as: 'candidate', required: true }, { model: reqServices }]
  });

  if (!getCandidateService) return res.status(401).json({ result: false, message: "There's nothing to add as user" });
  await reqCandidateComments.create({ commentSeqenceId: serviceSeqId, commentComment: feedBack, commentUserId: feedBackBy, offerReleaseReject: 1 });
  let userData = {
    userfirstName: getCandidateService.candidate.candidateFirstName,
    userlastName: getCandidateService.candidate.candidateLastName,
    userEmail: getCandidateService.candidate.candidateEmail,
    userDOB: getCandidateService.candidate.candidateDoB,
    userWorkStation: 0,
    userType: 'user',
    userRole: 'employee',
    userPassword: getCandidateService.candidate.candidateEmail//mail is hashed as password
  };

  await offerAccepetedCount(getCandidateService.serviceCandidate, feedBackBy);
  logFunction(getCandidateService.candidate.candidateId, feedBackBy, `Offer Accepted`, 5);
  let subject = 'Onboard';
  let message = 'You had joined as an Employee in Techversant Infotech';
  mailFunction.sendEmail(getCandidateService.candidate.candidateEmail, subject, message);
  await sequelize.query(`UPDATE "reqCandidates" SET "candidateInterviewStatus"='hired' WHERE "candidateId"=${getCandidateService.candidate.candidateId}`);
  await reqUser.create(userData);//add candidate to user
  await reqServiceSequence.update({ serviceStatus: 'done', insertOrUpdateDate: toDate }, { where: { serviceId: serviceSeqId } });
  await reqHrReview.update({ reviewedStatus: 'employed' }, { where: { reviewedServiceId: serviceSeqId } });
  reqcuriterReport(
    getCandidateService.serviceServiceRequst,
    moment().format("YYYY-MM-DD"),
    feedBackBy,
    'hired'
  );
  await reqestionStatusUpdate(getCandidateService.serviceServiceRequst);
  return res.send({ result: true, message: `Candidate ${userData.userfirstName} ${userData.userlastName} become an Employee` });
});


async function offerReleasedCount(candidateId, date) {
  try {
    let getUserAddedCandidate = await reqCandidates.findOne({ where: { candidateId: candidateId } });
    if (!getUserAddedCandidate) return
    let date = moment().format("YYYY-MM-DD");
    let position = getUserAddedCandidate.candidatesAddingAgainst;
    let userId = getUserAddedCandidate.candidateCreatedby;
    let targetDate = new Date(date);
    let where = {
      recruiter: userId, position: position, date: {
        [Op.between]: [targetDate, new Date(targetDate.getTime() + 24 * 60 * 60 * 1000)]
      }
    }
    let offerReleasedCount = await reqReport.findOne({
      attributes: ['offerReleased'], raw: true,
      where
    });
    if (offerReleasedCount?.offerReleased > -1) {
      let totalScheduledCount = offerReleasedCount.offerReleased + 1;
      let updatedReport = await sequelize.query(`UPDATE "reqReports" SET "offerReleased"=${totalScheduledCount} WHERE "position"=${position} AND "recruiter"=${userId} AND
        "date" >= '${targetDate.toISOString()}' AND "date" <= '${new Date(targetDate.getTime() + 24 * 60 * 60 * 1000).toISOString()}';`);
    } else {
      await sequelize.query(`INSERT INTO "reqReports"  ("offerReleased","position","recruiter","date") VALUES(${1},${position},${userId},'${targetDate.toISOString()}')`);
    }
  } catch (error) {
    console.log(error);
  }
}


async function offerAccepetedCount(candidateId, userId) {
  try {
    let getUserAddedCandidate = await reqCandidates.findOne({ where: { candidateId: candidateId } });
    if (!getUserAddedCandidate) return
    let date = moment().format("YYYY-MM-DD");
    let position = getUserAddedCandidate.candidatesAddingAgainst;
    let targetDate = new Date(date);
    let where = {
      recruiter: userId, position: position, date: {
        [Op.between]: [targetDate, new Date(targetDate.getTime() + 24 * 60 * 60 * 1000)]
      }
    }
    let offerAccepetedCount = await reqReport.findOne({
      attributes: ['offerAccepeted'], raw: true,
      where
    });
    if (offerAccepetedCount?.offerAccepeted > -1) {
      let totalOfferAcceptedCount = offerAccepetedCount.offerAccepeted + 1;
      let updatedReport = await sequelize.query(`UPDATE "reqReports" SET "offerAccepeted"=${totalOfferAcceptedCount} WHERE "position"=${position} AND "recruiter"=${userId} AND
        "date" >= '${targetDate.toISOString()}' AND "date" <= '${new Date(targetDate.getTime() + 24 * 60 * 60 * 1000).toISOString()}';`);
    } else {
      await sequelize.query(`INSERT INTO "reqReports"  ("offerAccepeted","position","recruiter","date") VALUES(${1},${position},${userId},'${targetDate.toISOString()}')`);
    }
  } catch (error) {
    console.log(error);
  }
}

exports.addProgress = tryCatch(async (req, res) => {
  let {
    progressAssignee,
    progressSkill,
    progressServiceId,
    progressScore,
    progressDescription,
    file,
  } = req.body;
  if (!progressAssignee)
    return res
      .status(400)
      .json({ result: false, message: "ProgressAssignee required" });

  if (!progressServiceId)
    return res
      .status(400)
      .json({ result: false, message: "ProgressServiceId required" });

  if (!progressDescription)
    return res
      .status(400)
      .json({ result: false, message: "ProgressDescription required" });

  let requestionActive = await isRequestionClosed(progressServiceId);
  if (!requestionActive) return res
    .status(400)
    .json({ result: false, message: "Requestion is closed No action Can be taken." })

  let defaultData = {

    progressStation: 5,
    progressVerifiedBy: progressAssignee,
    progressDescription: progressDescription,
    progressServiceSequence: progressServiceId,
    progressScore
  }
  if (progressSkill.length) {
    const formattedSkills = progressSkill.map(skill => ({ ...skill, serviceSeqId: progressServiceId }));
    await reqProgressSkill.bulkCreate(formattedSkills);
  }

  if (file) { defaultData.progressFile = file; }

  if (progressScore) {
    defaultData.progressScore = progressScore;
  }

  const [progress, created] = await reqCandidateProgress.findOrCreate({
    where: {
      progressStation: 5,
      progressServiceSequence: progressServiceId,
    },
    defaults: defaultData
  });

  await reqCandidateComments.create({
    commentSeqenceId: progressServiceId,
    commentComment: progressDescription,
    commentUserId: progressAssignee,
  });
  if (created) {
    let candidate = await reqServiceSequence.findOne({ attributes: ['serviceCandidate'], where: { serviceId: progressServiceId } });
    logFunction(candidate.serviceCandidate, progressAssignee, 'Scores and Feedback added in HR Station', 3);
    return res
      .status(200)
      .json({ result: true, message: "Technical Progress added" });
  }
  return res
    .status(401)
    .json({ result: false, message: "Technical Progress already found" });

});

exports.progressDetail = tryCatch(async (req, res) => {
  const serviceId = req.query.serviceId;
  if (!serviceId) {
    return res
      .status(401)
      .json({ result: false, message: "Service should be mandatory" });
  }

  const candidates = await reqServiceSequence.findOne({
    attributes: [
      "serviceId",
      "serviceStation",
      "serviceServiceRequst",
      "serviceCandidate",
      "serviceAssignee",
      [
        sequelize.literal(`(
          SELECT COUNT(*)
          FROM "reqCandidateProgresses" AS "progress"
          WHERE "progress"."progressServiceSequence"="reqServiceSequence"."serviceId"
        )`),
        "progressStatus"
      ],
      [
        sequelize.literal(`(
          SELECT CONCAT("userfirstName", ' ', "userlastName")
          FROM "reqUsers"
          WHERE "userId"="serviceAssignee"
        )`),
        "pannelName"
      ],
      ["serviceDate", "interviewTime"],
      [
        sequelize.literal(`
          CASE WHEN "interviewRescheduled" IS NULL THEN 'scheduled' ELSE 'rescheduled' END
        `),
        "interviewstatus"
      ],
      "interviewMode",
      "serviceStatus",
      "serviceServiceId",
      "serviceScheduledBy",
      "previousCurrentStation",
      "interviewCount",
      "interviewRescheduledCount",
      "interviewLocation",
      "interviewMail",
      "interviewMailType"
    ],
    include: [
      {
        model: reqServiceRequest,
        as: "serviceRequest",
        required: true,
         include: [
          {
            model: reqTeam,
            as: "team"
          },
        ],
      },
      { model: reqCandidateProgress, as: "progress" },
      { model: reqCandidateComments },
      {
        model: reqCandidates,
        attributes: {
          exclude: [
            "createdAt",
            "updatedAt",
            "candidateStatus",
            "candidateCreatedby"
          ]
        },
        as: "candidate",
        required: true
      }
    ],
    where: { serviceStation: 5, serviceId },
    raw: true
  });

  if (candidates) {
    const [skills] = await sequelize.query(
      `SELECT * FROM "reqCandidateSkills"
       INNER JOIN "reqSkills" ON "candidateSkillId"="reqSkills"."id"
       WHERE "candidateId"=:candidateId`,
      { replacements: { candidateId: candidates.serviceCandidate } }
    );

    const [skillScore] = await sequelize.query(
      `SELECT * FROM "reqProgressSkills"
       INNER JOIN "reqSkills" ON "reqProgressSkills"."skillId"="reqSkills"."id"
       WHERE "serviceSeqId"=:serviceId`,
      { replacements: { serviceId: serviceId } }
    );

    candidates.skills = skills;
    candidates.skillScore = skillScore;

    return res.status(200).json({
      result: true,
      message: "Technical Candidates Found",
      candidates
    });
  }

  return res
    .status(401)
    .json({ result: false, message: "Technical Candidates Not Found" });
});
