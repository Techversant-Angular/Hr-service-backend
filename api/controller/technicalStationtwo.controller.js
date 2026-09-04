const fs = require("fs");
const path = require("path");
const { format, set } = require("date-fns");
const { Op } = require("sequelize");
const formidable = require("formidable");
const mailFunction = require("../utils/nodeMail");
const { tryCatch } = require("../utils/trycatch");
const commonFunction = require("../utils/commonFunction");
const { excelGenerator } = require('../utils/excelGenerator');
const { updateReportData, logFunction, addExperiencInterviewScheduled, isRequestionClosed, meetingLinkReplace } = require('../utils/commonFunction');
const {
  reqServiceSequence, reqServiceRequest, Sequelize,
  sequelize, reqCandidates, reqCandidateProgress,
  reqServiceSequencesAcitve, reqUser, reqCandidateComments,reqTeam,
  reqProgressSkill,reqServiceFlow
} = require("../../models");
const response = require("../../api/utils/responseMessages");

exports.list = tryCatch(async (req, res) => {
  const report = req.query.report;
  const search = req.query.search;
  const statusFilter = req.query.status_filter;
  const position = req.query.position;
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  let ids = req.query.ids;

  const fromDate = req.query.fromDate
    ? new Date(format(new Date(req.query.fromDate), "yyyy-MM-dd"))
    : "";
  let toDate = req.query.toDate;
  if (toDate) {
    toDate = set(new Date(toDate), {
      hours: 23,
      minutes: 59,
      seconds: 59,
      milliseconds: 0,
    });
  } else {
    toDate = '';
  }

  offset = offset == 1 ? 0 : offset;
  const experience = req.query.experience;
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }

  const where = { serviceStation: 4 };
  if (req.userId && req.userRole !== '1' && req.userRole !== '6') {
    where.serviceAssignee = req.userId;
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
  if (ids?.length) {
    ids = Array.isArray(ids) ? ids : [ids];
    where.serviceId = { [Op.in]: ids }
  }
  if (statusFilter) where.serviceStatus = statusFilter;
  if (position) where.serviceServiceRequst = position;
  let candidates = await reqServiceSequencesAcitve.findAll({
    attributes: {
      include: [
        [
          sequelize.literal(`(SELECT COUNT(*)
                    FROM "reqCandidateProgresses" AS "progress" WHERE "progress"."progressServiceSequence"="reqServiceSequencesAcitve"."serviceId" AND (LOWER(TRIM("progress"."progressDescription")) != 'hold' OR "progress"."progressDescription" IS NULL))`),
          "progressStatus",
        ],
        [
          sequelize.literal(`(SELECT "stationName"
                                FROM "reqServiceSequencesAcitves" AS "sequence" INNER JOIN "reqStations" ON "stationId"="serviceStation" 
                                WHERE "sequence"."serviceCandidate"="reqServiceSequencesAcitve"."serviceCandidate" AND "sequence"."serviceServiceRequst"="reqServiceSequencesAcitve"."serviceServiceRequst" ORDER BY "serviceId" DESC LIMIT 1)`),
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
  const totalCount = await reqServiceSequencesAcitve.count({ where });

  if (candidates) {
    candidates = candidates.map((c) => {
      c['candidate.candidateInterviewStatus'] = c.serviceStatus == "pending"
        ? "inprogress"
        : c.serviceStatus == "done"
          ? "shorted"
          : c.serviceStatus;

      c.serviceStatus = c.serviceStatus == "sourced" ? "pending" : c.serviceStatus;
      c.serviceAssignee = c.serviceAssignee;
      return c;
    });
  }
// Fetch flows for all unique requisitions
if (candidates.length) {
  const requestIds = [
    ...new Set(
      candidates.map(
        (candidate) => candidate["serviceRequest.requestServiceId"]
      )
    ),
  ];

  const flows = await reqServiceFlow.findAll({
    where: {
      flowServiceId: {
        [Op.in]: requestIds,
      },
    },
    raw: true,
  });

  // Group flows by requisition
  const flowMap = {};

  flows.forEach((flow) => {
    if (!flowMap[flow.flowServiceId]) {
      flowMap[flow.flowServiceId] = [];
    }
    flowMap[flow.flowServiceId].push(flow);
  });

  // Attach corresponding flow to each candidate
  candidates = candidates.map((candidate) => ({
    ...candidate,
    flows:
      flowMap[candidate["serviceRequest.requestServiceId"]] || [],
  }));
}
  if (report == 'true' && candidates) {
    const head = [{ header: "Request Name", key: "requestName", width: 10 },
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
    { header: "Candidate Assignee", key: "serviceAssignee", width: 20 },
    { header: "Candidate Station Status", key: "candidateStationStatus", width: 10 }];

    const body = candidates.map((le) => {
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
        serviceAssignee: le.serviceAssignee,
        candidateStationStatus: le['serviceStatus']
      };
    });
    const name = `candidates_technical_1_${format(new Date(), 'yyyyMMddHHmmss')}`;
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
    .json({ result: false, message: response.TECHNICAL_CANDIDATES_NOT_FOUND });

});

exports.addProgress = tryCatch(async (req, res) => {
  const form = new formidable.IncomingForm();
  form.parse(req, async (err, fields, files) => {
    if (err) {
      return res.status(500).json({ error: "Error parsing form data" });
    }
    const {
      progressAssignee,
      // progressSkillTest,
      progressSkill,
      progressServiceId,
      progressScore,
      progressDescription,
    } = fields;
    if (!progressAssignee?.[0])
      return res
        .status(400)
        .json({ result: false, message: response.PROGRESS_ASSIGNEE_REQUIRED });

    if (!progressSkill?.[0])
      return res
        .status(400)
        .json({ result: false, message: "ProgressSkill required" });
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
      const currentTime = format(new Date(), "yyyy_MM_dd_HH_mm_ss");
      const fileExt = files.file[0].originalFilename.split(".").pop();
      fileStoragePath = `/uploads/${progressServiceId}_${progressAssignee}_${currentTime}.${fileExt}`;
      const newPath = path.resolve(__dirname, "../..") + fileStoragePath;

      const oldPath = files.file[0].filepath;
      const rawData = fs.readFileSync(oldPath);

      fs.writeFile(newPath, rawData, function (err) {
        if (err) throw new err();
      });
    }

    const [progress, created] = await reqCandidateProgress.findOrCreate({
      where: {
        progressStation: 4,
        progressServiceSequence: progressServiceId[0],
      },
      defaults: {
        progressStation: 4,
        progressVerifiedBy: progressAssignee[0],
        progressDescription: progressDescription[0],
        progressServiceSequence: progressServiceId[0],
        progressSkills: progressSkill[0],
        progressFile: fileStoragePath,
      },
    });

    if (created) {
      return res
        .status(200)
        .json({ result: true, message: response.TECHNICAL_PROGRESS_ADDED });
    } else {
      return res
        .status(401)
        .json({ result: false, message: response.TECHNICAL_PROGRESS_ALREADY_FOUND });
    }
  });

});

exports.addProgressV1 = tryCatch(async (req, res) => {
  const {
    progressAssignee,
    progressSkill,
    progressServiceId,
    progressScore,
    progressDescription,
    holdDescription,
    progressComment,
    file,
  } = req.body;
  if (!progressAssignee)
    return res
      .status(400)
      .json({ result: false, message: response.PROGRESS_ASSIGNEE_REQUIRED });

  if (!progressServiceId)
    return res
      .status(400)
      .json({ result: false, message: "ProgressServiceId required" });

  if (!progressDescription)
    return res
      .status(400)
      .json({ result: false, message: "ProgressDescription required" });

  const requestionActive = await isRequestionClosed(progressServiceId);
  if (!requestionActive) return res
    .status(400)
    .json({ result: false, message: "Requestion is closed No action Can be taken." })

  const isOnHold = String(progressDescription).trim().toLowerCase() === 'hold';
  const defaultData = {
    progressStation: 4,
    progressVerifiedBy: progressAssignee,
    progressDescription: progressDescription,
    progressServiceSequence: progressServiceId,
    progressScore,
    holdDescription: isOnHold ? holdDescription : null,
  }
  // if (progressSkill.length) {
  //   const formattedSkills = progressSkill.map(skill => ({ ...skill, serviceSeqId: progressServiceId }));
  //   await reqProgressSkill.bulkCreate(formattedSkills);
  // }

  if (file) { defaultData.progressFile = file; }

  if (isOnHold) {
    await reqServiceSequence.update(
      { serviceStatus: 'hold' },
      { where: { serviceId: progressServiceId } }
    );

    await reqCandidateProgress.create(defaultData);
    
    await reqCandidateComments.create({
      commentSeqenceId: progressServiceId,
      commentComment: holdDescription,
      commentUserId: progressAssignee,
    });
    return res.status(200).json({
      result: true,
      message: "Technical 1 Progress put on hold",
    });
  }

  const [progress, created] = await reqCandidateProgress.findOrCreate({
    where: {
      progressStation: 4,
      progressServiceSequence: progressServiceId,
    },
    defaults: defaultData
  });

    if (!created) {
    await progress.update(defaultData);
  }

  if (Array.isArray(progressSkill)) {
    // Skills belong to this interview stage. Replace them on an edit so old
    // scores do not remain alongside the newly submitted ones.
    await reqProgressSkill.destroy({ where: { serviceSeqId: progressServiceId } });
    if (progressSkill.length) {
      const formattedSkills = progressSkill.map(skill => ({ ...skill, serviceSeqId: progressServiceId }));
      await reqProgressSkill.bulkCreate(formattedSkills);
    }
  }

  await reqCandidateComments.create({
    commentSeqenceId: progressServiceId,
    commentComment: progressComment,
    commentUserId: progressAssignee,
  });
  if (created) {
    const candidate = await reqServiceSequence.findOne({ attributes: ['serviceCandidate','serviceServiceRequst','serviceStation'], where: { serviceId: progressServiceId } });
    if(candidate.serviceStation == 3){
      logFunction(candidate.serviceCandidate, progressAssignee, 'Scores and Feedback added Technical 2', 3,candidate.serviceServiceRequst);
    }else{
      logFunction(candidate.serviceCandidate, progressAssignee, 'Scores and Feedback added Technical 3', 4,candidate.serviceServiceRequst);
    }
    return res
      .status(200)
      .json({ result: true, message: response.TECHNICAL_PROGRESS_ADDED });
  }
  return res
    .status(401)
    .json({ result: false, message: response.TECHNICAL_PROGRESS_ALREADY_FOUND });

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
        sequelize.literal(`(SELECT COUNT(*)
                  FROM "reqCandidateProgresses" AS "progress" WHERE "progress"."progressServiceSequence"="reqServiceSequence"."serviceId" AND (LOWER(TRIM("progress"."progressDescription")) != 'hold' OR "progress"."progressDescription" IS NULL))`),
        "progressStatus",
      ],
      [
        sequelize.literal(`(SELECT "holdDescription"
                  FROM "reqCandidateProgresses" AS "progress"
                  WHERE "progress"."progressServiceSequence" = "reqServiceSequence"."serviceId"
                    AND "progress"."progressStation" = 4
                  ORDER BY "progress"."progressId" DESC
                  LIMIT 1)`),
        "holdDescription",
      ],
      [
        sequelize.literal(`(SELECT "stationName" FROM "reqServiceSequences" AS "sequence" INNER JOIN "reqStations" ON "stationId" = "serviceStation" 
                                                                WHERE "sequence"."serviceCandidate" = "reqServiceSequence"."serviceCandidate" AND "sequence"."serviceServiceRequst" = "reqServiceSequence"."serviceServiceRequst" ORDER BY "serviceId" DESC LIMIT 1)`), "currentStation"
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
      { model: reqCandidateProgress, as: "progress" },
      { model: reqCandidateComments },
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
        required: true,
      },
    ],
    order: [
      [reqCandidateComments, 'commentId', 'DESC']
    ],
    raw: true,
    where: { serviceStation: 4, serviceId },
  });

  if (candidates) {
    const [skills, metadata] = await sequelize.query(
      `SELECT *  FROM "reqCandidateSkills" INNER JOIN "reqSkills" ON "candidateSkillId"="reqSkills"."id" 
      WHERE "candidateId"=:candidateId `, { replacements: { candidateId: candidates.serviceCandidate } });
    const [skillScore, scoreMetadata] = await sequelize.query(`SELECT *  FROM "reqProgressSkills" INNER JOIN "reqSkills" ON "reqProgressSkills"."skillId"="reqSkills"."id" WHERE "serviceSeqId"=:serviceId `, { replacements: { serviceId: serviceId } });
    candidates.skills = skills;
    candidates.skillScore = skillScore;
    return res.status(200).json({
      result: true,
      message: response.TECHNICAL_CANDIDATES_FOUND,
      candidates,
    });
  }
  return res
    .status(401)
    .json({ result: false, message: response.TECHNICAL_CANDIDATES_NOT_FOUND });

});

exports.approve = tryCatch(async (req, res) => {
  const {
    serviceSeqId,
    feedBack,
    feedBackBy,
    feedBackCc, feedBackBcc,
    feedBackSubject, attachmentArray, date, pannelUser, interviewMode, recruiterId
  } = req.body;
  let feedBackMailTemp = req.body.feedBackMailTemp;

  const requestionActive = await isRequestionClosed(serviceSeqId);
  if (!requestionActive) return res
    .status(400)
    .json({ result: false, message: "Requestion is closed No action Can be taken." })

  // date = moment(date, 'MM/DD/YYYY').toDate();
  const serviceSeqence = await reqServiceSequence.findOne({
    include: [
      {
        model: reqCandidates,
        as: "candidate",
        required: true,
        attributes: ['candidateEmail'],
      },
    ],
    where: {
      serviceId: serviceSeqId,
      serviceStatus: {
        [Op.in]: ["pending", "hold"],
      },
      serviceStation: 4,

    },
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

  const getUsers = await reqUser.findOne({
    attributes: ["userId", "userEmail", "userRole", "userWorkStation"],
    where: { userWorkStation: 4, userStatus: "active" },
    raw: true,
  });


  const userId = pannelUser;
  serviceSeqence.interviewMode = interviewMode;

  //store the serviceScequence to view in next station and update current station candidate station
  const nextStationSequeence = await commonFunction.nextStationSequence(
    userId,
    [serviceSeqence],
    date, feedBackBy
  );
  if (nextStationSequeence === false)
    return res
      .status(401)
      .json({ result: false, message: "This is the last station" });

  const interviewCcAttendee = Array.isArray(feedBackCc) && feedBackCc.length > 0
    ? feedBackCc.map(el => ({ email: el }))
    : [];
  const interviewBccAttendee = Array.isArray(feedBackBcc) && feedBackBcc.length > 0
    ? feedBackBcc.map(el => ({ email: el }))
    : [];

  // Merging all attendees into one array, handling empty arrays
  const attendees = [{ email: serviceSeqence['candidate.candidateEmail'] }, ...interviewCcAttendee, ...interviewBccAttendee];
  feedBackMailTemp = await meetingLinkReplace(feedBackMailTemp, date, attendees);


  if (nextStationSequeence)
    await mailFunction.sendEmail(
      serviceSeqence["candidate.candidateEmail"],
      feedBackSubject,
      feedBackMailTemp,
      feedBackCc, attachmentArray
    );
  await updateReportData('interviewConducted', feedBackBy, serviceSeqence.serviceServiceRequst, serviceSeqence.serviceCandidate);
  // await updateReportData('interviewScheduled', feedBackBy, serviceSeqence.serviceServiceRequst);
  await addExperiencInterviewScheduled(serviceSeqence.serviceServiceRequst, 1);
    const candidate =
    await reqServiceSequence.findOne({
      attributes: [
        'serviceCandidate',
        'serviceServiceRequst'
      ],
      where: {
        serviceId: serviceSeqId
      }
    });

  logFunction(
    candidate.serviceCandidate,
    feedBackBy,
    'Interview Scheduled in HR station',
    5,
    candidate.serviceServiceRequst,
  );
  return res.status(200).json({
    result: true,
    message: "Candidates Approve and Move to next station",
  });

});
