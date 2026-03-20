const moment = require("moment");
const { Op, Sequelize } = require("sequelize");
let mailFunction = require("../utils/nodeMail");
const { tryCatch } = require("../utils/trycatch");
let { addContactedCount, logFunction, updateReportData, reqcuriterReport } = require("../utils/commonFunction");
let { reqServiceSequence, reqTask, reqCandidates, reqServiceRequest, reqTeam,
  reqSkill, sequelize, reqDesignation, reqUser, reqStation, reqCandidateComments,
  reqRejectReason, reqFeedbacks, reqProgressSkill
} = require("../../models");
const { sendFeedbackAcknowledgement } = require("../utils/commonFunction");

exports.secondGrafData = async (req, res, next) => {
  try {
    let startDate = req.query.fromDate + ' 00:00:00Z';
    let endDate = req.query.todate + ' 23:59:59Z';
    let arrayOfTeams = [];

    let [getcandidateRequirementQuery, meataData] = await sequelize.query(`SELECT DISTINCT("teamId") FROM "reqTeams"`);

    // await Promise.all( getcandidateRequirementQuery.forEach(async (el) => {
    for (let i = 0; i < getcandidateRequirementQuery.length; i++) {

      let [countTotal, TotalmeataData] = await sequelize.query(`select COUNT(DISTINCT("candidateId")) FROM "reqCandidates" INNER JOIN "reqServiceSequences" ON "serviceCandidate"="candidateId" WHERE ("serviceStation"=1 OR "serviceStation" IS NULL) AND "serviceServiceRequst" IN (SELECT DISTINCT("requestId") FROM "reqServiceRequests" WHERE "requestTeam"=${getcandidateRequirementQuery[i].teamId}) AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);

      let [countHired, meataData] = await sequelize.query(`SELECT COUNT(DISTINCT("serviceCandidate")) FROM  "reqServiceSequences" WHERE "serviceServiceRequst" IN (SELECT DISTINCT ("requestId") FROM "reqServiceRequests" WHERE "requestTeam"=${getcandidateRequirementQuery[i].teamId}) AND "serviceStation"=6 AND "serviceStatus"='done' AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);
      // console.log({ team: el.teamId, count: countTechSelect[0].count });

      let [countTechSelect, meataDataTech] = await sequelize.query(`SELECT COUNT(DISTINCT("serviceCandidate")) FROM  "reqServiceSequences" WHERE "serviceServiceRequst" IN (SELECT DISTINCT ("requestId") FROM "reqServiceRequests" WHERE "requestTeam"=${getcandidateRequirementQuery[i].teamId}) AND "serviceStation"=6 AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);
      // console.log({ team: el.teamId, count: countTechSelect[0].count });

      let [countTechoffer, meataDataOffer] = await sequelize.query(`SELECT COUNT(DISTINCT("serviceCandidate")) FROM  "reqServiceSequences" INNER JOIN "reqHrReviews" ON "serviceId"="reviewedServiceId" WHERE "serviceServiceRequst" IN (SELECT DISTINCT ("requestId") FROM "reqServiceRequests" WHERE "requestTeam"=${getcandidateRequirementQuery[i].teamId}) AND "serviceStation"=6 AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);
      arrayOfTeams.push({ team: getcandidateRequirementQuery[i].teamId, total_applicant: countTotal[0].count, hire_count: countHired[0].count, technical_selected_Count: countTechSelect[0].count, offered_Count: countTechoffer[0].count });

    }
    // )
    // );
    res.send(arrayOfTeams)
  } catch (error) {
    console.log(error);
  }
}

exports.feedbacksList = tryCatch(async (req, res) => {
  let feedBackes = await reqFeedbacks.findAll();
  return res.status(200).json({ result: true, message: "Data Found", data: feedBackes });
});

exports.rejectionList = tryCatch(async (req, res) => {
  let rejections = await reqRejectReason.findAll();
  return res.status(200).json({ result: true, message: "Data Found", data: rejections });
});

exports.taskAssign = tryCatch(async (req, res, next) => {
  let { assigneeId, stationId, serviceId } = req.body;

  let asigned = await reqServiceSequence.update(
    { serviceAssignee: assigneeId },
    {
      where: {
        serviceStation: stationId,
        serviceId: serviceId,
      },
    }
  );

  if (asigned[0])
    return res.status(200).json({ result: true, message: "Asignee Assigned" });
  return res
    .status(400)
    .json({ result: false, message: "Something went wrong" });
});

exports.userTasks = tryCatch(async (req, res, next) => {
  let { taskUserId, taskStationId } = req.body;
  console.log(taskUserId);
  let tasks = await reqTask.findAll({
    include: [
      {
        model: reqServiceSequence,
        as: "serviceSeq",
        include: [
          {
            model: reqCandidates,
            as: "candidate",
            attributes: [
              "candidateFirstName",
              "candidateLastName",
              "candidateEmail",
            ],
          },
          {
            model: reqServiceRequest,
            as: "serviceRequest",
            attributes: ["requestName", "requestTeam", "requestExperience"],
            include: [{ model: reqTeam, as: "team" }],
          },
        ],
        where: { serviceStation: taskStationId },
      },
    ],
    order: [["taskDate", "ASC"]],
    raw: true,
    where: { taskUserId: taskUserId },
  });

  console.log(tasks);
  if (tasks.length > 0)
    return res
      .status(200)
      .json({ result: true, message: "task found", datas: tasks });
  return res.status(400).json({ result: false, message: "Task not Found" });
});

exports.skillsList = tryCatch(async (req, res, next) => {
  let { search, typeId } = req.query;

  let condition = { raw: true };

  if (search) {
    condition.where = { skillName: { [Op.iLike]: `${search}%` } };
  }
  if (typeId) {
    condition.where = { typeId: typeId };
  }

  condition.attributes = [
    [Sequelize.fn("DISTINCT", Sequelize.col("skillName")), "skillName"],
    "id", "typeId", "type"
  ];
  let skills = await reqSkill.findAll(condition);
  if (skills.length > 0)
    return res
      .status(200)
      .json({ result: true, message: "data retrived", data: skills });
  return res
    .status(200)
    .json({ result: false, message: "data not found", data: skills });
});

exports.teamList = tryCatch(async (req, res, next) => {
  let teamList = await reqTeam.findAll({
    attributes: [
      [Sequelize.fn("DISTINCT", Sequelize.col("teamName")), "teamName"],
      "teamId",
    ],
    raw: true,
  });
  if (teamList.length > 0)
    return res
      .status(200)
      .json({ result: true, message: "data found", data: teamList });
  return res.status(401).json({ result: false, message: "data not found" });
});

exports.stations = tryCatch(async (req, res, next) => {
  let stations = await reqStation.findAll({
    attributes: [
      [Sequelize.fn("DISTINCT", Sequelize.col("stationName")), "stationName"],
      "stationId",
    ],
    raw: true,
    order: [["stationId", "ASC"]],
  });
  if (stations.length > 0)
    return res
      .status(200)
      .json({ result: true, message: "data found", data: stations });
  return res.status(401).json({ result: false, message: "data not found" });
});

exports.rejectCandidate = tryCatch(async (req, res, next) => {
  let {
    serviceId,
    stationId,
    status,
    feedBack,
    userId,
    rejectCc,
    rejectMailTemp,
    rejectSubject,
    rejectBcc,
    attachmentArray,
  } = req.body;
  let logData = {
    station: stationId,
    senderId: userId,
    type: "",
  };
  let currentDate = moment(moment(), "YYYY/MM/DD").format(
    "YYYY-MM-DDTHH:mm:ss.SSS[Z]"
  );
  let statusString = "pending";
  let updateingStaus = "rejected";
  let message = "Candidate rejected";

  if (status === "selected") {
    statusString = "rejected";
    updateingStaus = "pending";
    message = "Candidate Selected";
  } else if (status === "back-off") {
    statusString = "rejected";
    updateingStaus = "back-off";
    message = "Candidate back off";
  } else if (status === "pannel-rejection") {
    statusString = "rejected";
    updateingStaus = "pannel-rejection";
    message = "Candidate Pannel Rejected";
  } else if (status === "cancelled") {
    statusString = "cancelled";
    updateingStaus = "cancelled";
    message = "Candidate cancelled";
  }
  let sequence = await reqServiceSequence.findOne({
    where: {
      serviceId: serviceId,
    },
  });
  if (stationId == 1) {
    await updateReportData(
      "candidateContacted",
      userId,
      sequence.serviceServiceRequst
    );
    stationId = null;
    await reqServiceSequence.update({
      serviceStation: null,
    }, {
      where: {
        serviceId: serviceId,
      },
    });
  }

  let candidateStaion = await reqServiceSequence.findOne({
    include: [
      {
        model: reqServiceRequest,
        as: "serviceRequest",
        attributes: ["requestVacancy"],
      },
    ],
    where: {
      serviceId: serviceId,
      serviceStation: {
        [Op.or]: [stationId, null],
      },
    },
    raw: true,
  });
  let requestId=candidateStaion.serviceServiceRequst;
  logData.reciverId = candidateStaion.serviceCandidate;
  if (!candidateStaion)
    return res
      .status(404)
      .json({ result: false, message: "Candidate not found" });
  if (
    candidateStaion.serviceStatus == "done" ||
    candidateStaion.serviceStatus == "rejected"
  )
    return res.status(404).json({
      result: false,
      message: `Candidate Already Moved to Next Station Or Rejected`,
    });
  // if (updateingStaus == candidateStaion.serviceStatus) return res.status(404).json({ result: false, message: `Candidate Already ${status}` });
  await addContactedCount(
    userId,
    candidateStaion.serviceServiceRequst,
    candidateStaion["serviceRequest.requestVacancy"]
  );
  if (feedBack) {
    await reqCandidateComments.create({
      commentSeqenceId: serviceId,
      commentComment: feedBack,
      commentUserId: userId,
      offerReleaseReject: 1
    });
  }

  let rejectedCandidate = await reqServiceSequence.update(
    {
      serviceStatus: updateingStaus,
      serviceDate: currentDate,
      insertOrUpdateDate: currentDate,
    },
    {
      where: {
        serviceId: serviceId,
        serviceStation: stationId,
      },
    }
  );
  let getCandidateMail = await reqCandidates.findOne({
    where: { candidateId: candidateStaion.serviceCandidate },
  });
  let column_name = "";
  if (stationId == 1 || stationId == null) {
    column_name = "screenRejected";
  } else if (stationId == 2) {
    column_name = "writtenReject";
  } else if (stationId == 3) {
    column_name = "techOneReject";
  } else if (stationId == 4) {
    column_name = "techTwoReject";
  } else if (stationId == 5) {
    column_name = "hrReject";
  } else if (stationId == 6) {
    column_name = "managementReject";
  }
  const updateCandidateStatus = async (status) => {
    await reqCandidates.update(
      { candidateInterviewStatus: status },
      { where: { candidateId: candidateStaion.serviceCandidate } }
    );
  };

  if (["rejected", "pannel-rejection"].includes(updateingStaus)) {
    console.log("column_name", column_name, "stationId", stationId);
    reqcuriterReport(
      sequence.serviceServiceRequst,
      moment().format("YYYY-MM-DD"),
      userId,
      column_name
    );
    await updateCandidateStatus(updateingStaus);
  } else if (updateingStaus === "back-off") {
    await updateCandidateStatus("back-off");
  } else if (updateingStaus === "cancelled") {
    await updateCandidateStatus("cancelled");
  }

  logData.type = "Rejection Mail send ";
  if (getCandidateMail) {
    await mailFunction.sendEmail(
      getCandidateMail.candidateEmail,
      rejectSubject,
      rejectMailTemp,
      rejectCc,
      rejectBcc,
      attachmentArray,
      logData
    );
  }
  if (rejectedCandidate[0]) {
    logFunction(candidateStaion.serviceCandidate, userId, message, stationId,requestId);
    return res.status(200).json({ result: true, message: message });
  }
  return res.status(404).json({
    result: false,
    message: "something went wrong on rejection of candidates",
  });
});

exports.recruiterList = tryCatch(async (req, res, next) => {
  let search = req.query.search;
  let where;
  if (search) {
    where = {
      userStatus: "active",
      userRole: "talent",
      [Op.or]: [
        { userfirstName: { [Op.startsWith]: `${search}` } },
        { userEmail: { [Op.startsWith]: `${search}` } },
      ],
    };
  } else {
    where = {
      userStatus: "active",
      userRole: "talent",
    };
  }
  let recruiterList = await reqUser.findAll({
    attributes: [
      "userFullName",
      "userId",
      "userfirstName",
      "userlastName",
      "userEmail",
    ],
    where,
  });
  if (recruiterList)
    return res
      .status(200)
      .json({ result: true, message: "data retrived", data: recruiterList });
  return res.status(401).json({ result: false, message: "data not found" });
});

exports.candidateCommentsDelete = tryCatch(async (req, res, next) => {
  let commentId = req.query.commentId;
  let commentSeqenceId = req.query.commentSeqenceId;
  let dataExist = await reqCandidateComments.findOne({
    where: { commentId, commentSeqenceId },
  });
  if (!dataExist)
    return res
      .status(401)
      .json({ result: false, message: "data not found To delete" });
  let deleteComment = await reqCandidateComments.destroy({
    where: { commentId, commentSeqenceId },
  });
  if (deleteComment)
    return res
      .status(200)
      .json({ result: true, message: "data deleted Sucessfully" });
});

exports.candidateCommentsUpdate = tryCatch(async (req, res, next) => {
  let commentId = req.query.commentId;
  let commentSeqenceId = req.query.commentSeqenceId;
  let comment = req.body.comment;
  let dataExist = await reqCandidateComments.findOne({
    where: { commentId, commentSeqenceId },
  });
  if (!dataExist)
    return res
      .status(401)
      .json({ result: false, message: "data not found To delete" });
  let addData = await reqCandidateComments.update(
    { reqCandidateComments: comment },
    { where: { commentId, commentSeqenceId } }
  );
  if (addData)
    return res
      .status(200)
      .json({ result: true, message: "data Updated Sucessfully" });
  return res
    .status(200)
    .json({ result: false, message: "something went wrong on updating" });
});

exports.designationList = tryCatch(async (req, res, next) => {
  let { search } = req.query;
  let designations = await reqDesignation.findAll({ where: { designationName: { [Op.iLike]: `%${search}%` } } });
  if (designations)
    return res
      .status(200)
      .json({ result: true, message: "data retrived", data: designations });
  return res.status(401).json({ result: true, message: "data not found" });
});

exports.skipCurrentStation = tryCatch(async (req, res, next) => {
  let { serviceId, stationId, assigneeId, date, currentStation, comment,movedBy } =
    req.body;
  let sequenceData = await reqServiceSequence.findOne({
    where: { serviceId: { [Op.eq]: serviceId }, [Op.or]: [{ serviceStatus: 'on-hold' }, { serviceStatus: 'pending' }] }
  });
  date = moment(date, "YYYY/MM/DD").format("YYYY-MM-DDTHH:mm:ss.SSS[Z]");
  if (stationId == 1)
    return res
      .status(401)
      .json({ result: false, message: "cannot move to screening station" });
  if (!sequenceData)
    return res
      .status(401)
      .json({ result: false, message: "not a valid sequence" });

  // await updateCandidateStations(stationId, sequenceData.serviceCandidate);
  let chekPreviouslyAdded = await reqServiceSequence.findOne({
    where: {
      serviceServiceRequst: sequenceData.serviceServiceRequst,
      serviceCandidate: sequenceData.serviceCandidate,
      serviceServiceId: sequenceData.serviceServiceId,
      previousCurrentStation: currentStation,
      serviceStatus: "moved",
      serviceStation: { [Op.ne]: 5 },
    },
    order: [["serviceId", "DESC"]],
  });

  if (chekPreviouslyAdded)
    return res.status(401).json({
      result: false,
      message: "Already skip is done for particular station",
    });
  await reqServiceSequence.update(
    { serviceStatus: "moved", insertOrUpdateDate: date },
    { where: { serviceId: serviceId } }
  );
  let newStationSequence = {
    serviceServiceRequst: sequenceData.serviceServiceRequst,
    serviceCandidate: sequenceData.serviceCandidate,
    serviceStation: stationId,
    serviceAssignee: assigneeId,
    serviceScheduledBy:assigneeId,
    serviceDate: date,
    serviceServiceId: sequenceData.serviceServiceId,
    previousCurrentStation: currentStation,
    resonSwitchStation: comment,
    insertOrUpdateDate: date,
  };

  let nextStationSequeence = await reqServiceSequence.create(
    newStationSequence
  );
  logFunction(
    sequenceData.serviceCandidate,
    movedBy,
    "Candidate moved ",
    currentStation
  );
  if (nextStationSequeence)
    return res
      .status(200)
      .json({ result: true, message: "moved to the required station" });
  return res
    .status(401)
    .json({ result: true, message: "Something went wrong" });
});

exports.getCandidatesByCard = tryCatch(async (req, res, next) => {
  try {
    const { positionId, status, limit = 10, page = 1, fromDate, toDate } = req.query;
    const offset = (page - 1) * limit;

    if (!status) {
      return res.status(400).json({ result: false, message: "Status required" });
    }

    const validStatuses = ["total", "rejected", "shorted", "hired"];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        result: false,
        message: "Status should be total, rejected, shorted, or hired",
      });
    }

    let positionCondition = ` `;
    if (fromDate && toDate) {
      positionCondition += `  AND "insertOrUpdateDate" BETWEEN '${fromDate}' AND '${toDate}'`;
    }
    if (positionId) {
      positionCondition = `= ${positionId}`;
    }

    const baseQuery = `
      FROM public."reqCandidates"
      INNER JOIN "reqServiceSequences" ON "serviceCandidate" = "candidateId"
    `;

    let whereClause = '';
    if (status === "total") {
      whereClause = `WHERE ("serviceStation"=1 OR "serviceStation" IS NULL)  ${positionCondition}`;
    } else if (status === "shorted") {
      whereClause = `WHERE "serviceStatus" = 'done' AND "serviceStation" = 1  ${positionCondition}`;
    } else if (status === "rejected") {
      whereClause = `WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection')  ${positionCondition}`;
    } else if (status === "hired") {
      whereClause = `WHERE "serviceStation"=5 AND "serviceStatus"='done'  ${positionCondition}`;
    }

    const query = `
      SELECT "candidateId", "candidateFirstName", "candidateLastName", "candidateEducation", 
             "candidateExperience", "candidatePreviousOrg", "candidatePreviousDesignation", 
             "candidateCity", "candidateStatus", "candidateRevlentExperience", 
             "candidateTotalExperience",
             (SELECT "stationName" FROM "reqServiceSequences" 
              INNER JOIN "reqStations" ON "stationId" = "serviceStation" 
              WHERE "serviceCandidate" = "candidateId" 
              ORDER BY "serviceId" DESC LIMIT 1) AS "currentStation"
      ${baseQuery} ${whereClause}
      ORDER BY "candidateId" DESC LIMIT ${limit} OFFSET ${offset};
    `;

    const countQuery = `SELECT COUNT(*) AS count ${baseQuery} ${whereClause};`;

    const [candidates] = await sequelize.query(query);
    const [countResult] = await sequelize.query(countQuery);
    const totalCount = countResult[0].count;

    return res.status(200).json({
      result: true,
      message: "Data retrieved successfully",
      candidates,
      totalCount,
    });
  } catch (error) {
    return res.status(500).json({ result: false, message: "Server error", error });
  }
});


exports.s3Credential = tryCatch(async (req, res, next) => {
  let secretKey = process.env.S3_SECRET_KEY;
  let buckeName = process.env.S3_BUCKET_NAME;

  return res.status(200).json({
    result: true,
    message: "data retrived",
    data: { secretKey, buckeName },
  });
});

exports.statusFilter = tryCatch(async (req, res, next) => {
  let statusLists = [
    {
      status: "pending"
    },
    {
      status: "rejected"
    },
    {
      status: "done"
    },
    {
      status: "moved"
    },
    {
      status: "back-off"
    },
    {
      status: "pannel-rejection"
    },
    {
      status: "cancelled"
    }
  ];
  return res
    .status(200)
    .json({ result: true, message: "data retrived", data: statusLists });
});

exports.workModeList = tryCatch(async (req, res, next) => {

  let workModeLists = [
    { workMode: "Remote" },
    { workMode: "Onsite" },
    { workMode: "Hybrid" },
  ];
  return res
    .status(200)
    .json({ result: true, message: "data retrived", data: workModeLists });
});

exports.prefferedList = tryCatch(async (req, res, next) => {
  let locationLists = [{ location: "Trivandrum" }, { location: "Cochin" }, { location: "Cochin & Trivandrum" }];
  return res
    .status(200)
    .json({ result: true, message: "data retrived", data: locationLists });
});

exports.editProgressV1 = tryCatch(async (req, res) => {
  const {
    progressAssignee,
    progressSkill = [],
    progressServiceId,
    progressScore,
    progressDescription,
    progressComment,
    file,
  } = req.body;

  // Validate required fields
  if (!progressAssignee || !progressServiceId || !progressDescription) {
    return res.status(400).json({ result: false, message: "Missing required fields" });
  }

  // Check if the requestion is active
  if (!(await isRequestionClosed(progressServiceId))) {
    return res.status(400).json({ result: false, message: "Requestion is closed. No action can be taken." });
  }

  // Prepare progress update data
  const defaultData = {
    progressStation: 3,
    progressVerifiedBy: progressAssignee,
    progressDescription,
    progressServiceSequence: progressServiceId,
    ...(file && { progressFile: file }), // Conditionally add file if provided
    ...(progressScore && { progressScore }), // Conditionally add score if provided
  };

  // Upsert progress data
  await reqCandidateProgress.upsert(defaultData);

  // Delete and recreate progress skills
  if (progressSkill.length) {
    await reqProgressSkill.destroy({ where: { serviceSeqId: progressServiceId } });
    const formattedSkills = progressSkill.map(skill => ({ ...skill, serviceSeqId: progressServiceId }));
    await reqProgressSkill.bulkCreate(formattedSkills);
  }

  // Delete and create progress comment
  await reqCandidateComments.destroy({ where: { commentSeqenceId: progressServiceId } });
  await reqCandidateComments.create({
    commentSeqenceId: progressServiceId,
    commentComment: progressComment,
    commentUserId: progressAssignee,
  });

  // Send feedback acknowledgment email
  if (progressComment) {
    const candidateDetail = await reqCandidates.findOne({
      where: { candidateId: candidate.serviceCandidate },
    });
    const hrDetail = await reqUser.findOne({
      where: { userId: serviceScheduledBy },
    });

    if (candidateDetail && hrDetail) {
      await sendFeedbackAcknowledgement(hrDetail.userEmail, hrDetail.userfirstName, candidateDetail.candidateFirstName);
    }
  }

  // Log action
  const candidate = await reqServiceSequence.findOne({
    attributes: ["serviceCandidate"],
    where: { serviceId: progressServiceId },
  });
  logFunction(candidate.serviceCandidate, progressAssignee, "Progress edited in technical 1", 3);


  return res.status(200).json({ result: true, message: "Technical Progress Edited" });

});

