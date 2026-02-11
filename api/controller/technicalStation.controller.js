const fs = require("fs");
const path = require("path");
const moment = require("moment");
const { Op } = require("sequelize");
const formidable = require("formidable");
let mailFunction = require("../utils/nodeMail");
const { tryCatch } = require("../utils/trycatch");
let commonFunction = require("../utils/commonFunction");
let { excelGenerator } = require('../utils/excelGenerator');
let { updateReportData, logFunction, addExperiencInterviewScheduled, isRequestionClosed, meetingLinkReplace } = require('../utils/commonFunction');
let { reqServiceSequence, reqServiceRequest, reqCandidates,
  reqCandidateProgress, reqServiceSequencesAcitve, sequelize,reqTeam,
  Sequelize, reqCandidateComments, reqProgressSkill
} = require("../../models");

exports.list = tryCatch(async (req, res) => {
  let report = req.query.report;
  let statusFilter = req.query.status_filter;
  let ids = req.query.ids;
  let position = req.query.position;
  let search = req.query.search;
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  let experience = req.query.experience;

  let fromDate = req.query.fromDate
    ? new Date(moment(req.query.fromDate).format("YYYY-MM-DD"))
    : "";
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
  let where = { serviceStation: 3 };
  if (statusFilter) where.serviceStatus = statusFilter;
  if (position) where.serviceServiceRequst = position;
  if (ids?.length) {
    ids = Array.isArray(ids) ? ids : [ids];
    where.serviceId = { [Op.in]: ids }
  }
  let searchCondition = {};
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
  if (fromDate && toDate)
    where.serviceDate = { [Op.between]: [fromDate, toDate] };

  if (search) {
    searchCondition = {
      [Op.or]: [
        { candidateFirstName: { [Op.iLike]: `${search}%` } },
        { candidateLastName: { [Op.iLike]: `${search}%` } },
        { candidateEmail: { [Op.iLike]: `${search}%` } },
      ],
    };
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
      message: "Technical Candidates Found",
      candidates,
      totalCount,
    });
  return res
    .status(401)
    .json({ result: false, message: "Technical Candidates Not Found" });

});

exports.addProgress = tryCatch(async (req, res) => {
  const form = new formidable.IncomingForm();
  form.parse(req, async (err, fields, files) => {
    if (err) {
      return res.status(500).json({ error: "Error parsing form data" });
    }
    let {
      progressAssignee,
      progressSkill,
      progressServiceId,
      progressDescription,
    } = fields;
    if (!progressAssignee?.[0])
      return res
        .status(400)
        .json({ result: false, message: "ProgressAssignee required" });

    if (!progressServiceId?.[0])
      return res
        .status(400)
        .json({ result: false, message: "ProgressServiceId required" });

    if (!progressDescription?.[0])
      return res
        .status(400)
        .json({ result: false, message: "ProgressDescription required" });

    let fileStoragePath = "";
    if (Object.keys(files).length !== 0) {
      let currentTime = moment().format("YYYY_MM_DD_HH_mm_ss");
      let fileExt = files.file[0].originalFilename.split(".").pop();
      fileStoragePath = `/uploads/${progressServiceId}_${progressAssignee}_${currentTime}.${fileExt}`;
      let newPath = path.resolve(__dirname, "../..") + fileStoragePath;

      let oldPath = files.file[0].filepath;
      let rawData = fs.readFileSync(oldPath);

      fs.writeFile(newPath, rawData, function (err) {
        if (err) throw new err();
      });
    }

    let defaultData = {
      // progressScore: progressScore[0],
      progressStation: 2,
      progressVerifiedBy: progressAssignee[0],
      progressDescription: progressDescription[0],
      progressServiceSequence: progressServiceId[0],
      // progressQuestion: progressSkillTest[0],

      progressFile: fileStoragePath,
    }
    if (!progressSkill?.[0]) {
      defaultData.progressSkills = progressSkill[0];
    }
    const [progress, created] = await reqCandidateProgress.findOrCreate({
      where: {
        progressStation: 2,
        progressServiceSequence: progressServiceId[0],
      },
      defaults: defaultData,
    });
    if (created) {
      return res
        .status(200)
        .json({ result: true, message: "Technical Progress added" });
    } else {
      return res
        .status(401)
        .json({ result: false, message: "Technical Progress already found" });
    }
  });

});

exports.addProgressV1 = tryCatch(async (req, res) => {
  let {
    progressAssignee,
    progressSkill,
    progressServiceId,
    progressScore,
    progressDescription, progressComment,
    progressRejectReason,
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
    progressStation: 3,
    progressVerifiedBy: progressAssignee,
    progressDescription: progressDescription,
    progressServiceSequence: progressServiceId,
  }
  if (progressSkill.length) {
    const formattedSkills = progressSkill.map(skill => ({ ...skill, serviceSeqId: progressServiceId }));
    await reqProgressSkill.bulkCreate(formattedSkills);
  }
  if (file) {
    defaultData.progressFile = file;
  }

  if (progressScore) {
    defaultData.progressScore = progressScore;
  }

  const [progress, created] = await reqCandidateProgress.findOrCreate({
    where: {
      progressStation: 3,
      progressServiceSequence: progressServiceId,
    },
    defaults: defaultData
  });
  await reqCandidateComments.create({
    commentSeqenceId: progressServiceId,
    commentComment: progressComment,
    commentUserId: progressAssignee,
  });
  if (created) {
    let candidate = await reqServiceSequence.findOne({ attributes: ['serviceCandidate'], where: { serviceId: progressServiceId } });
    logFunction(candidate.serviceCandidate, progressAssignee, 'Scores and Feedback added in technical 1', 3);
    return res
      .status(200)
      .json({ result: true, message: "Technical Progress added" });
  } else {
    return res
      .status(401)
      .json({ result: false, message: "Technical Progress already found" });
  }

});

exports.progressDetail = tryCatch(async (req, res) => {
  let serviceId = req.query.serviceId;
  if (!serviceId) {
    return res
      .status(401)
      .json({ result: false, message: "Service should be mandatory" });
  }
  let candidates = await reqServiceSequence.findOne({
    attributes: [
      "serviceId",
      "serviceStation",
      "serviceServiceRequst",
      "serviceCandidate",
      "serviceAssignee",
      [
        sequelize.literal(`(SELECT COUNT(*)
                  FROM "reqCandidateProgresses" AS "progress" WHERE "progress"."progressServiceSequence"="reqServiceSequence"."serviceId")`),
        "progressStatus",
      ],
      [
        sequelize.literal(`(SELECT "stationName" FROM "reqServiceSequences" AS "sequence" INNER JOIN "reqStations" ON "stationId" = "serviceStation" 
                                                                WHERE "sequence"."serviceCandidate" = "reqServiceSequence"."serviceCandidate" ORDER BY "serviceId" DESC LIMIT 1)`), "currentStation"
      ],
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
      { model: reqCandidateComments },
      { model: reqCandidateProgress, as: "progress" },
      {
        model: reqCandidates,
        attributes: {
          exclude: [
            "createdAt",
            "updatedAt",
            "candidateStatus",
            "candidateCreatedby"
          ],
        },
        as: "candidate",
        required: true,
      },
    ],
    raw: true,
    where: { serviceStation: 3, serviceId },
  });


  if (candidates) {

    let [skills, metadata] = await sequelize.query(`SELECT *  FROM "reqCandidateSkills" INNER JOIN "reqSkills" ON "candidateSkillId"="reqSkills"."id" WHERE "candidateId"=:candidateId `, { replacements: { candidateId: candidates.serviceCandidate } });
    let [skillScore, scoreMetadata] = await sequelize.query(`SELECT *  FROM "reqProgressSkills" INNER JOIN "reqSkills" ON "reqProgressSkills"."skillId"="reqSkills"."id" WHERE "serviceSeqId"=:serviceId `, { replacements: { serviceId: serviceId } });
    candidates.skills = skills;
    candidates.skillScore = skillScore;
    return res.status(200).json({
      result: true,
      message: "Technical Candidates Found",
      candidates,
    });
  }
  return res
    .status(401)
    .json({ result: false, message: "Technical Candidates Not Found" });

});

exports.approve = tryCatch(async (req, res) => {
  let {
    serviceSeqId,
    feedBack,
    feedBackBy,
    feedBackCc,
    feedBackMailTemp,
    feedBackSubject,
    feedBackBcc,
    attachmentArray, date, pannelUser, interviewMode
  } = req.body;

  let requestionActive = await isRequestionClosed(serviceSeqId);
  if (!requestionActive) return res
    .status(400)
    .json({ result: false, message: "Requestion is closed No action Can be taken." })

  // date = moment(date, 'MM/DD/YYYY').toDate()
  let serviceSeqence = await reqServiceSequence.findOne({
    where: {
      serviceId: serviceSeqId,
      serviceStatus: "pending",
      serviceStation: 3,
    },
    include: [{ model: reqCandidates, as: 'candidate', required: true, attributes: ['candidateEmail'] }],
    raw: true,
  });

  if (!serviceSeqence)
    return res
      .status(401)
      .json({ result: false, message: "This candidate not available" });
  await reqCandidateComments.create({
    commentSeqenceId: serviceSeqId,
    commentComment: feedBack,
    commentUserId: feedBackBy,
  });

  let userId = pannelUser;
  serviceSeqence.interviewMode = interviewMode;

  //store the serviceScequence to view in next station and update current station candidate station
  let nextStationSequeence = await commonFunction.nextStationSequence(
    userId,
    [serviceSeqence],
    date, feedBackBy
  );
  if (nextStationSequeence === false)
    return res
      .status(401)
      .json({ result: false, message: "This is the last station" });

  let interviewCcAttendee = Array.isArray(feedBackCc) && feedBackCc.length > 0
    ? feedBackCc.map(el => ({ email: el }))
    : [];
  let interviewBccAttendee = Array.isArray(feedBackBcc) && feedBackBcc.length > 0
    ? feedBackBcc.map(el => ({ email: el }))
    : [];

  // Merging all attendees into one array, handling empty arrays
  let attendees = [{ email: serviceSeqence['candidate.candidateEmail'] }, ...interviewCcAttendee, ...interviewBccAttendee];
  feedBackMailTemp = await meetingLinkReplace(feedBackMailTemp, date, attendees);

  if (nextStationSequeence)
    await mailFunction.sendEmail(
      serviceSeqence['candidate.candidateEmail'],
      feedBackSubject,
      feedBackMailTemp, feedBackCc, feedBackBcc, attachmentArray
    );
  await updateReportData('interviewConducted', feedBackBy, serviceSeqence.serviceServiceRequst);
  // await updateReportData('interviewScheduled', feedBackBy, serviceSeqence.serviceServiceRequst);
  await addExperiencInterviewScheduled(serviceSeqence.serviceServiceRequst, 1);
  return res.status(200).json({
    result: true,
    message: "Candidates Approve and Move to next station",
  });

});
