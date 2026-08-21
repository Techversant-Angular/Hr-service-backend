const { reqServiceSequence, reqCandidates, reqServiceRequest,
  reqUser, reqHrReview, reqServices, reqCandidateComments,reqTeam, sequelize, Sequelize, reqCandidateProgress, reqProgressSkill,reqServiceFlow
} = require("../../models");
const { format, addDays, subDays } = require('date-fns');
const { Op } = require('sequelize');
const mailFunction = require('../utils/nodeMail');
const { tryCatch } = require("../utils/trycatch");
const { excelGenerator } = require('../utils/excelGenerator');
const { reqestionStatusUpdate, logFunction, updateCandidateStations, updateReportData, addExperiencInterviewScheduled, isRequestionClosed, meetingLinkReplace } = require('../utils/commonFunction');
const response = require("../../api/utils/responseMessages");


exports.list = tryCatch(async (req, res) => {

  const report = req.query.report;
  const search = req.query.search;
  const statusFilter = req.query.status_filter;
  const position = req.query.position;
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  const experience = req.query.experience;
  const fromDate = req.query.fromDate ? subDays(
    new Date(format(new Date(req.query.fromDate), 'yyyy-MM-dd')),
    5
  )
    : ""; const toDate = req.query.toDate ? addDays(new Date(format(new Date(req.query.toDate), 'yyyy-MM-dd')), 5)
      : ""; offset = offset == 1 ? 0 : offset;
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }
  const where = { serviceStation: 6 };
  if (fromDate && toDate) where.serviceDate = { [Op.between]: [fromDate, toDate] }
  if (statusFilter) where.serviceStatus = statusFilter;
  if (position) where.serviceServiceRequst = position;
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
  if (search) {
    searchCondition = {
      [Op.or]: [{ candidateFirstName: { [Op.iLike]: `${search}%` } },
      { candidateLastName: { [Op.iLike]: `${search}%` } },
      { candidateEmail: { [Op.iLike]: `${search}%` } }]
    }
  }
  const include = [
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

  let candidates = await reqServiceSequence.findAll({
    attributes: {
      include: [
        [
          sequelize.literal(`(SELECT COUNT(*)
            FROM "reqCandidateProgresses" AS "progress" WHERE "progress"."progressServiceSequence"="reqServiceSequence"."serviceId")`), 'progressStatus'
        ], [
          sequelize.literal(`(SELECT "stationName"
            FROM "reqServiceSequences" AS "sequence" INNER JOIN "reqStations" ON "stationId"="serviceStation" WHERE "sequence"."serviceCandidate"="reqServiceSequence"."serviceCandidate" AND "sequence"."serviceServiceRequst"="reqServiceSequence"."serviceServiceRequst" ORDER BY "serviceId" DESC LIMIT 1)`),
          "currentStation",
        ]]
    },
    include,
    raw: true, limit, offset,
    where, order: [['serviceId', 'DESC']]
  });
  const totalCount = await reqServiceSequence.count({ where, include });

  if (candidates) {
    candidates = candidates.map((c) => {
      c['candidate.candidateInterviewStatus'] = c.serviceStatus == "pending"
        ? "inprogress"
        : c.serviceStatus == "done"
          ? "shorted"
          : c.serviceStatus;

      c.serviceStatus = c.serviceStatus == "sourced" ? "pending" : c.serviceStatus;
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
        candidateStationStatus: le['serviceStatus']
      };
    });
    const name = `candidates_Management_1_${format(new Date(), 'yyyyMMddHHmmss')}`;
    excelGenerator(req, res, head, body, name);
    return;
  }
  if (candidates)
    return res.status(200).json({
      result: true,
      message: "Management Candidates Found",
      candidates, totalCount
    });
  return res
    .status(401)
    .json({ result: false, message: "Management Candidates Not Found" });
});


exports.fetchFinalCandidte = tryCatch(async (req, res) => {
  const serviceId = req.query.serviceId;
  console.log(serviceId);
  const candidates = await reqServiceSequence.findOne({
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
      }, { model: reqCandidateComments },
      { model: reqHrReview }
    ],
    where: { serviceId },
  });
  //here we have to add last station review also----------------------------------
  if (candidates) {
    const [skills, metadata] = await sequelize.query(`SELECT *  FROM "reqCandidateSkills" INNER JOIN "reqSkills" ON "candidateSkillId"="reqSkills"."id" WHERE "candidateId"=:candidateId `, { replacements: { candidateId: candidates.serviceCandidate } });
    const [skillScore, scoreMetadata] = await sequelize.query(`SELECT *  FROM "reqProgressSkills" INNER JOIN "reqSkills" ON "reqProgressSkills"."skillId"="reqSkills"."id" WHERE "serviceSeqId"=:serviceId `, { replacements: { serviceId: serviceId } });
    candidates.skills = skills;
    candidates.skillScore = skillScore;
    return res.status(200).json({
      result: true,
      message: "Management Candidates Found",
      candidates,
    });
  }
  return res
    .status(401)
    .json({ result: false, message: "Management Candidates Not Found" });
});



exports.candidateOffers = tryCatch(async (req, res) => {
  const { offerServiceSeqId, offerSalary, offerDescription, attachmentArray, offerJoinDate, offerMailTemp, offerMailSubject, offerMailBackCc } = req.body;

  const serviceSeq = await reqServiceSequence.findOne({ where: { serviceId: offerServiceSeqId } });//, serviceStatus: 'pending' } });
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

  await offerReleasedCount(serviceSeq.serviceCandidate);
  const getCandidateMail = await reqCandidates.findOne({ where: { candidateId: serviceSeq.serviceCandidate } });
  if (getCandidateMail) {

    await mailFunction.sendEmail(
      getCandidateMail.candidateEmail,
      offerMailSubject,
      offerMailTemp, offerMailBackCc, attachmentArray
    );

  }
  if (created) return res.status(200).json({ result: true, message: "Offer  details added" });

  return res.status(401).json({ result: false, message: "this offer already exists" });
});

exports.candidateToUser = tryCatch(async (req, res) => {
  const { serviceSeqId, feedBack, feedBackBy } = req.body;
  const toDate = format(new Date(), 'yyyy-MM-dd');
  const getCandidateService = await reqServiceSequence.findOne({
    where: { serviceId: serviceSeqId, serviceStatus: 'pending' },
    include: [{ model: reqCandidates, as: 'candidate', required: true }, { model: reqServices }]
  });

  if (!getCandidateService) return res.status(401).json({ result: false, message: "There's nothing to add as user" });
  await reqCandidateComments.create({ commentSeqenceId: serviceSeqId, commentComment: feedBack, commentUserId: feedBackBy });
  const userData = {
    userfirstName: getCandidateService.candidate.candidateFirstName,
    userlastName: getCandidateService.candidate.candidateLastName,
    userEmail: getCandidateService.candidate.candidateEmail,
    userDOB: getCandidateService.candidate.candidateDoB,
    userWorkStation: 0,
    userType: 'user',
    userRole: getCandidateService.reqService.sericeName,
    userPassword: getCandidateService.candidate.candidateEmail//mail is hashed as password
  };

  await offerAccepetedCount(getCandidateService.serviceCandidate);
  const subject = 'Onboard';
  const message = 'You had joined as an Employee in Techversant Infotech';
  mailFunction.sendEmail(getCandidateService.candidate.candidateEmail, subject, message);
  await sequelize.query(`UPDATE "reqCandidates" SET "candidateInterviewStatus"='hired' WHERE "candidateId"=${getCandidateService.candidate.candidateId}`);
  await reqUser.create(userData);//add candidate to user
  await reqServiceSequence.update({ serviceStatus: 'done', insertOrUpdateDate: toDate }, { where: { serviceId: serviceSeqId } });
  await reqHrReview.update({ reviewedStatus: 'employed' }, { where: { reviewedServiceId: serviceSeqId } });
  await reqestionStatusUpdate(getCandidateService.serviceServiceRequst);

  return res.send({ result: true, message: `Candidate ${userData.userfirstName} ${userData.userlastName} become an Employee` });

});


async function offerReleasedCount(candidateId) {
  try {
    const getUserAddedCandidate = await reqCandidates.findOne({ where: { candidateId: candidateId } });
    if (!getUserAddedCandidate) return

    const position = getUserAddedCandidate.candidatesAddingAgainst;
    const userId = getUserAddedCandidate.candidateCreatedby;
    const targetDate = new Date(date);
    const where = {
      recruiter: userId, position: position, date: {
        [Op.between]: [targetDate, new Date(targetDate.getTime() + 24 * 60 * 60 * 1000)]
      }
    }
    const offerReleasedCount = await reqReport.findOne({
      attributes: ['offerReleased'], raw: true,
      where
    });
    if (offerReleasedCount?.offerReleased > -1) {
      const totalScheduledCount = offerReleasedCount.offerReleased + 1;
      const updatedReport = await sequelize.query(`UPDATE "reqReports" SET "offerReleased"=${totalScheduledCount} WHERE "position"=${position} AND "recruiter"=${userId} AND
        "date" >= '${targetDate.toISOString()}' AND "date" <= '${new Date(targetDate.getTime() + 24 * 60 * 60 * 1000).toISOString()}';`);
    } else {
      await sequelize.query(`INSERT INTO "reqReports"  ("offerReleased","position","recruiter","date") VALUES(${1},${position},${userId},'${targetDate.toISOString()}')`);
    }
  } catch (error) {
    console.log(error);
  }
}



async function offerAccepetedCount(candidateId) {
  try {
    const getUserAddedCandidate = await reqCandidates.findOne({ where: { candidateId: candidateId } });
    if (!getUserAddedCandidate) return

    const position = getUserAddedCandidate.candidatesAddingAgainst;
    const userId = getUserAddedCandidate.candidateCreatedby;
    const targetDate = new Date(date);
    const where = {
      recruiter: userId, position: position, date: {
        [Op.between]: [targetDate, new Date(targetDate.getTime() + 24 * 60 * 60 * 1000)]
      }
    }
    const offerAccepetedCount = await reqReport.findOne({
      attributes: ['offerAccepeted'], raw: true,
      where
    });
    if (offerAccepetedCount?.offerAccepeted > -1) {
      const totalOfferAcceptedCount = offerAccepetedCount.offerAccepeted + 1;
      const updatedReport = await sequelize.query(`UPDATE "reqReports" SET "offerAccepeted"=${totalOfferAcceptedCount} WHERE "position"=${position} AND "recruiter"=${userId} AND
        "date" >= '${targetDate.toISOString()}' AND "date" <= '${new Date(targetDate.getTime() + 24 * 60 * 60 * 1000).toISOString()}';`);
    } else {
      await sequelize.query(`INSERT INTO "reqReports"  ("offerAccepeted","position","recruiter","date") VALUES(${1},${position},${userId},'${targetDate.toISOString()}')`);
    }
  } catch (error) {
    console.log(error);
  }
}


exports.progressDetail = async (req, res) => {
  try {
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
          Sequelize.literal(`(
        SELECT CONCAT("userfirstName", ' ', "userlastName") FROM "reqUsers" WHERE "userId"="serviceAssignee" )`),
          "pannelName"
        ], [
          sequelize.literal(`(SELECT COUNT(*)
            FROM "reqCandidateProgresses" AS "progress" WHERE "progress"."progressServiceSequence"="reqServiceSequence"."serviceId")`), 'progressStatus'
        ],
        [
        sequelize.literal(`(SELECT "holdDescription"
                  FROM "reqCandidateProgresses" AS "progress"
                  WHERE "progress"."progressServiceSequence" = "reqServiceSequence"."serviceId"
                    AND "progress"."progressStation" = 6
                  ORDER BY "progress"."progressId" DESC
                  LIMIT 1)`),
        "holdDescription",
      ],
        [
          sequelize.literal(`(SELECT "stationName" FROM "reqServiceSequences" AS "sequence" INNER JOIN "reqStations" ON "stationId" = "serviceStation" 
                                                                WHERE "sequence"."serviceCandidate" = "reqServiceSequence"."serviceCandidate" AND "sequence"."serviceServiceRequst" = "reqServiceSequence"."serviceServiceRequst" ORDER BY "serviceId" DESC LIMIT 1)`), "currentStation"
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
          // required: true,
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
      order: [
        [reqCandidateComments, 'commentId', 'DESC']
      ],
      raw: true,
      where: { serviceStation: 6, serviceId },
    });

    console.log(serviceId, "service***********************************************************", candidates.serviceCandidate);


    if (candidates) {

      const [skills, metadata] = await sequelize.query(`SELECT *  FROM "reqCandidateSkills" INNER JOIN "reqSkills" ON "candidateSkillId"="reqSkills"."id" WHERE "candidateId"=:candidateId `, { replacements: { candidateId: candidates.serviceCandidate } });
      const [skillScore, scoreMetadata] = await sequelize.query(`SELECT *  FROM "reqProgressSkills" INNER JOIN "reqSkills" ON "reqProgressSkills"."skillId"="reqSkills"."id" WHERE "serviceSeqId"=:serviceId `, { replacements: { serviceId: serviceId } });
      candidates.skills = skills;
      candidates.skillScore = skillScore;
      return res.status(200).json({
        result: true,
        message: "Management Candidates Found",
        candidates,
      });
    }
    return res
      .status(401)
      .json({ result: false, message: "Management Candidates Not Found" });
  } catch (error) {
    next(error);
  }
};

exports.addProgressV1 = async (req, res, next) => {
  try {
    const {
      progressAssignee,
      progressSkill,
      progressServiceId,
      progressScore,
      progressDescription,
      holdDescription,
      file, progressComment
    } = req.body;

    if (!progressAssignee)
      return res.status(400).json({ result: false, message: response.PROGRESS_ASSIGNEE_REQUIRED });

    if (!progressServiceId)
      return res.status(400).json({ result: false, message: "ProgressServiceId required" });

    if (!progressDescription)
      return res.status(400).json({ result: false, message: "ProgressDescription required" });

    const requestionActive = await isRequestionClosed(progressServiceId);
    if (!requestionActive)
      return res.status(400).json({ result: false, message: "Requestion is closed. No action can be taken." });

    const isOnHold = String(progressDescription).trim().toLowerCase() === 'hold';
    const defaultData = {
      progressStation: 6,
      progressVerifiedBy: progressAssignee,
      progressDescription: progressDescription,
      progressServiceSequence: progressServiceId,
      progressScore,
      holdDescription: isOnHold ? holdDescription : null,
    };
    // if (progressSkill.length) {
    //   const formattedSkills = progressSkill.map(skill => ({ ...skill, serviceSeqId: progressServiceId }));
    //   await reqProgressSkill.bulkCreate(formattedSkills);
    // }

    if (file) {
      defaultData.progressFile = file;
    }

    if (isOnHold) {
      await reqServiceSequence.update(
        { serviceStatus: 'hold' },
        { where: { serviceId: progressServiceId } }
      );
    }

    if (progressScore) {
      defaultData.progressScore = progressScore;
    }

    const [progress, created] = await reqCandidateProgress.findOrCreate({
      where: {
        progressStation: 6,
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
      const candidate = await reqServiceSequence.findOne({
        attributes: ['serviceCandidate'],
        where: { serviceId: progressServiceId }
      });
      logFunction(candidate.serviceCandidate, progressAssignee, 'Scores and Feedback added in Management', 6);
      return res.status(200).json({ result: true, message: "Management Progress added" });
    }

    return res.status(401).json({ result: false, message: "Management Progress already found" });
  } catch (error) {
    next(error); // Passes the error to the error-handling middleware
  }
};


// exports.approve = async (req, res) => {

//   try {
//     let {
//       serviceSeqId, feedBack, feedBackBy,
//       feedBackCc, feedBackMailTemp, feedBackSubject,
//       attachmentArray, date, pannelUser, interviewMode
//     } = req.body;

//     let toDate = moment().format("YYYY-MM-DD");
//     let serviceSeqence = await reqServiceSequence.findOne({
//       include: [
//         {
//           model: reqCandidates,
//           as: "candidate",
//           required: true,
//           attributes: ['candidateEmail'],
//         },
//       ],
//       where: {
//         serviceId: serviceSeqId,
//         serviceStatus: "pending",
//         serviceStation: 6,

//       },
//       raw: true,
//     });

//     if (!serviceSeqence)
//       return res
//         .status(401)
//         .json({ result: false, message: "This candidate not available" });
//     await reqCandidateComments.create({
//       commentSeqenceId: serviceSeqId,
//       commentComment: feedBack,
//       commentUserId: feedBackBy,
//     });

//     let userId = pannelUser;
//     serviceSeqence.interviewMode = interviewMode;

//     //store the serviceScequence to view in next station and update current station candidate station

//     let nextStationSequeence = await reqServiceSequence.create(
//       {
//         serviceServiceRequst: serviceSeqence.serviceServiceRequst,
//         serviceCandidate: serviceSeqence.serviceCandidate,
//         serviceStation: 5,
//         serviceAssignee: userId,
//         serviceDate: date,
//         serviceServiceId: serviceSeqence.serviceServiceId,
//         serviceScheduledBy: feedBackBy,
//         insertOrUpdateDate: toDate,
//       }
//     );
//     //candidate station update
//     await updateCandidateStations(5, serviceSeqence.serviceCandidate);
//     //update the current one
//     await reqServiceSequence.update(
//       { serviceStatus: "done", insertOrUpdateDate: toDate },
//       {
//         where: {
//           serviceId: serviceSeqence.serviceId
//         },
//       }
//     );
//     logFunction(
//       elem.serviceCandidate,
//       assigneeId,
//       `Interview Scheduled in ${jsonData.stationList[5]}`,
//       5
//     );
//     await mailFunction.sendEmail(
//       serviceSeqence["candidate.candidateEmail"],
//       feedBackSubject,
//       feedBackMailTemp,
//       feedBackCc, attachmentArray
//     );
//     await updateReportData('interviewConducted', feedBackBy, serviceSeqence.serviceServiceRequst);
//     // await updateReportData('interviewScheduled', feedBackBy, serviceSeqence.serviceServiceRequst);
//     await addExperiencInterviewScheduled(serviceSeqence.serviceServiceRequst, 1);
//     return res.status(200).json({
//       result: true,
//       message: "Candidates Approve and Move to next station",
//     });
//   } catch (error) {
//     next(error);
//   }
// };


exports.approve = async (req, res, next) => {
  //fixed next error and code improvements ,original is commented above without any changes
  try {
    const {
      serviceSeqId, feedBack, feedBackBy,
      feedBackCc, feedBackSubject, feedBackBcc,
      attachmentArray, date, pannelUser, interviewMode
    } = req.body;
    let feedBackMailTemp = req.body.feedBackMailTemp

    const requestionActive = await isRequestionClosed(serviceSeqId);
    if (!requestionActive) return res
      .status(400)
      .json({ result: false, message: "Requestion is closed No action Can be taken." })

    const toDate = format(new Date(), "yyyy-MM-dd");
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
        serviceStation: 6,
      },
      raw: true,
    });

    if (!serviceSeqence) {
      return res
        .status(401)
        .json({ result: false, message: "This candidate not available" });
    }

    await reqCandidateComments.create({
      commentSeqenceId: serviceSeqId,
      commentComment: feedBack,
      commentUserId: feedBackBy,
    });

    const userId = pannelUser;
    serviceSeqence.interviewMode = interviewMode;

    // Define station list here if not dynamically fetched
    const stationList = [
      "Screening",
      "Interview Round 1",
      "Technical Round",
      "HR Interview",
      "Final Approval",
      "Onboarding",
    ];

    // Store the service sequence to view in the next station and update current station candidate station
    const nextStationSequeence = await reqServiceSequence.create({
      serviceServiceRequst: serviceSeqence.serviceServiceRequst,
      serviceCandidate: serviceSeqence.serviceCandidate,
      serviceStation: 5,
      serviceAssignee: userId,
      serviceDate: date,
      serviceServiceId: serviceSeqence.serviceServiceId,
      serviceScheduledBy: feedBackBy,
      insertOrUpdateDate: toDate,
    });

    // Update candidate station
    await updateCandidateStations(5, serviceSeqence.serviceCandidate);

    // Update the current one
    await reqServiceSequence.update(
      { serviceStatus: "done", insertOrUpdateDate: toDate },
      { where: { serviceId: serviceSeqence.serviceId } }
    );

    logFunction(
      serviceSeqence.serviceCandidate,
      userId,
      `Interview Scheduled in ${stationList[5]}`,  // replaced jsonData.stationList with stationList
      5
    );

    const interviewCcAttendee = Array.isArray(feedBackCc) && feedBackCc.length > 0
      ? feedBackCc.map(el => ({ email: el }))
      : [];
    const interviewBccAttendee = Array.isArray(feedBackBcc) && feedBackBcc.length > 0
      ? feedBackBcc.map(el => ({ email: el }))
      : [];

    // Merging all attendees into one array, handling empty arrays
    const attendees = [{ email: serviceSeqence['candidate.candidateEmail'] }, ...interviewCcAttendee, ...interviewBccAttendee];
    feedBackMailTemp = await meetingLinkReplace(feedBackMailTemp, date, attendees);

    await mailFunction.sendEmail(
      serviceSeqence["candidate.candidateEmail"],
      feedBackSubject,
      feedBackMailTemp,
      feedBackCc, attachmentArray
    );

    await updateReportData('interviewConducted', feedBackBy, serviceSeqence.serviceServiceRequst,serviceSeqence.serviceCandidate);

    await addExperiencInterviewScheduled(serviceSeqence.serviceServiceRequst, 1);

    return res.status(200).json({
      result: true,
      message: "Candidate approved and moved to next station",
    });
  } catch (error) {
    next(error);
  }
};
