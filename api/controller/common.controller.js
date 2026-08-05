const moment = require("moment");
const { Op, Sequelize, where } = require("sequelize");
let mailFunction = require("../utils/nodeMail");
const { tryCatch } = require("../utils/trycatch");
let { addContactedCount, logFunction, updateReportData, reqcuriterReport, isRequestionClosed } = require("../utils/commonFunction");
let { reqServiceSequence, reqTask, reqCandidates, reqServiceRequest, reqTeam,
  reqSkill, sequelize, reqDesignation, reqUser, reqStation, reqCandidateComments,
  reqRejectReason, reqFeedbacks, reqProgressSkill, reqCandidateProgress
} = require("../../models");
const response = require("../../api/utils/responseMessages");
const { sendFeedbackAcknowledgement } = require("../utils/commonFunction");
const { PutObjectCommand } = require("@aws-sdk/client-s3");
const { getSignedUrl } = require("@aws-sdk/s3-request-presigner");
const { s3Client } = require("../../config/config");

exports.secondGrafData = async (req, res, next) => {
  try {
    const startDate = req.query.fromDate + ' 00:00:00Z';
    const endDate = req.query.todate + ' 23:59:59Z';
    const arrayOfTeams = [];

    const [getcandidateRequirementQuery, meataData] = await sequelize.query(`SELECT DISTINCT("teamId") FROM "reqTeams"`);

    // await Promise.all( getcandidateRequirementQuery.forEach(async (el) => {
    for (let i = 0; i < getcandidateRequirementQuery.length; i++) {

      const [countTotal, TotalmeataData] = await sequelize.query(`select COUNT(DISTINCT("candidateId")) FROM "reqCandidates" INNER JOIN "reqServiceSequences" ON "serviceCandidate"="candidateId" WHERE ("serviceStation"=1 OR "serviceStation" IS NULL) AND "serviceServiceRequst" IN (SELECT DISTINCT("requestId") FROM "reqServiceRequests" WHERE "requestTeam"=${getcandidateRequirementQuery[i].teamId}) AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);

      const [countHired, meataData] = await sequelize.query(`SELECT COUNT(DISTINCT("serviceCandidate")) FROM  "reqServiceSequences" WHERE "serviceServiceRequst" IN (SELECT DISTINCT ("requestId") FROM "reqServiceRequests" WHERE "requestTeam"=${getcandidateRequirementQuery[i].teamId}) AND "serviceStation"=6 AND "serviceStatus"='done' AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);
      // console.log({ team: el.teamId, count: countTechSelect[0].count });

      const [countTechSelect, meataDataTech] = await sequelize.query(`SELECT COUNT(DISTINCT("serviceCandidate")) FROM  "reqServiceSequences" WHERE "serviceServiceRequst" IN (SELECT DISTINCT ("requestId") FROM "reqServiceRequests" WHERE "requestTeam"=${getcandidateRequirementQuery[i].teamId}) AND "serviceStation"=6 AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);
      // console.log({ team: el.teamId, count: countTechSelect[0].count });

      const [countTechoffer, meataDataOffer] = await sequelize.query(`SELECT COUNT(DISTINCT("serviceCandidate")) FROM  "reqServiceSequences" INNER JOIN "reqHrReviews" ON "serviceId"="reviewedServiceId" WHERE "serviceServiceRequst" IN (SELECT DISTINCT ("requestId") FROM "reqServiceRequests" WHERE "requestTeam"=${getcandidateRequirementQuery[i].teamId}) AND "serviceStation"=6 AND "insertOrUpdateDate" BETWEEN '${startDate}' AND '${endDate}'`);
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
  const feedBackes = await reqFeedbacks.findAll();
  return res.status(200).json({ result: true, message: response.DATA_FOUND, data: feedBackes });
});

exports.rejectionList = tryCatch(async (req, res) => {
  const rejections = await reqRejectReason.findAll();
  return res.status(200).json({ result: true, message: response.DATA_FOUND, data: rejections });
});

exports.taskAssign = tryCatch(async (req, res, next) => {
  const { assigneeId, stationId, serviceId } = req.body;

  const asigned = await reqServiceSequence.update(
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
  const { taskUserId, taskStationId } = req.body;
  console.log(taskUserId);
  const tasks = await reqTask.findAll({
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
  const { search, typeId } = req.query;

  const condition = { raw: true };

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
  const skills = await reqSkill.findAll(condition);
  if (skills.length > 0)
    return res
      .status(200)
      .json({ result: true, message: "data retrived", data: skills });
  return res
    .status(200)
    .json({ result: false, message: response.DATA_NOT_FOUND, data: skills });
});

exports.teamList = tryCatch(async (req, res, next) => {
  const teamList = await reqTeam.findAll({
    where:{
      status:true
    },
    attributes: [
      [Sequelize.fn("DISTINCT", Sequelize.col("teamName")), "teamName"],
      "teamId",
    ],
    raw: true,
  });
  teamList.sort((firstTeam, secondTeam) =>
    firstTeam.teamName.localeCompare(secondTeam.teamName, "en", { sensitivity: "base" })
  );
  if (teamList.length > 0)
    return res
      .status(200)
      .json({ result: true, message: "data found", data: teamList });
  return res.status(401).json({ result: false, message: response.DATA_NOT_FOUND });
});

exports.stations = tryCatch(async (req, res, next) => {
  const stations = await reqStation.findAll({
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
  return res.status(401).json({ result: false, message: response.DATA_NOT_FOUND });
});

exports.rejectCandidate = tryCatch(async (req, res, next) => {
  let { stationId } = req.body;
  const {
    serviceId,
    status,
    feedBack,
    userId,
    rejectCc,
    rejectMailTemp,
    rejectSubject,
    rejectBcc,
    attachmentArray,
  } = req.body;
  const logData = {
    station: stationId,
    senderId: userId,
    type: "",
  };
  const currentDate = moment(moment(), "YYYY/MM/DD").format(
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
  const sequence = await reqServiceSequence.findOne({
    where: {
      serviceId: serviceId,
    },
  });
  if (stationId == 1) {
    await updateReportData(
      "candidateContacted",
      userId,
      sequence.serviceServiceRequst,
      sequence.serviceCandidate
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

  const candidateStaion = await reqServiceSequence.findOne({
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
  const requestId=candidateStaion.serviceServiceRequst;
  logData.reciverId = candidateStaion.serviceCandidate;
  if (!candidateStaion)
    return res
      .status(404)
      .json({ result: false, message: response.CANDIDATE_NOT_FOUND });
  if (
    candidateStaion.serviceStatus == "done" ||
    candidateStaion.serviceStatus == "rejected"
  )
    return res.status(404).json({
      result: false,
      message: `Candidate Already Moved to Next Station Or Rejected`,
    });
  // if (updateingStaus == candidateStaion.serviceStatus) return res.status(404).json({ result: false, message: `Candidate Already ${status}` });
    // await addContactedCount(
    //   userId,
    //   candidateStaion.serviceServiceRequst,
    //   candidateStaion["serviceRequest.requestVacancy"],
    //   sequence.serviceCandidate
    // );


  if (feedBack) {
    await reqCandidateComments.create({
      commentSeqenceId: serviceId,
      commentComment: feedBack,
      commentUserId: userId,
      offerReleaseReject: 1
    });
  }

  const rejectedCandidate = await reqServiceSequence.update(
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
  const getCandidateMail = await reqCandidates.findOne({
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
  const search = req.query.search;
  let where;
  if (search) {
    where = {
      userStatus: "active",
      userRole: "6",
      [Op.or]: [
        { userfirstName: { [Op.startsWith]: `${search}` } },
        { userEmail: { [Op.startsWith]: `${search}` } },
      ],
    };
  } else {
    where = {
      userStatus: "active",
      userRole: "6",
    };
  }
  const recruiterList = await reqUser.findAll({
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
      .json({ result: true, message: response.DATA_RETRIEVED, data: recruiterList });
  return res.status(401).json({ result: false, message: response.DATA_NOT_FOUND });
});

exports.candidateCommentsDelete = tryCatch(async (req, res, next) => {
  const commentId = req.query.commentId;
  const commentSeqenceId = req.query.commentSeqenceId;
  const dataExist = await reqCandidateComments.findOne({
    where: { commentId, commentSeqenceId },
  });
  if (!dataExist)
    return res
      .status(401)
      .json({ result: false, message: "data not found To delete" });
  const deleteComment = await reqCandidateComments.destroy({
    where: { commentId, commentSeqenceId },
  });
  if (deleteComment)
    return res
      .status(200)
      .json({ result: true, message: "data deleted Sucessfully" });
});

exports.candidateCommentsUpdate = tryCatch(async (req, res, next) => {
  const commentId = req.query.commentId;
  const commentSeqenceId = req.query.commentSeqenceId;
  const comment = req.body.comment;
  const dataExist = await reqCandidateComments.findOne({
    where: { commentId, commentSeqenceId },
  });
  if (!dataExist)
    return res
      .status(401)
      .json({ result: false, message: "data not found To delete" });
  const addData = await reqCandidateComments.update(
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
  const { search } = req.query;
  const designations = await reqDesignation.findAll({ where: { designationName: { [Op.iLike]: `%${search}%` }, status: true } });
  if (designations)
    return res
      .status(200)
      .json({ result: true, message: response.DATA_RETRIEVED, data: designations });
  return res.status(401).json({ result: true, message: response.DATA_NOT_FOUND });
});

// designation CRUD 
exports.designationManagementList = tryCatch(async (req, res, next) => {
  const { search, page = 1, limit = 10 } = req.query;
  const where = {
    // status:true
  };

  if (search?.trim()) {
    where.designationName = {
      [Op.iLike]: `%${search.trim()}%`,
    };
  }

  const offset = (Number(page) - 1) * Number(limit);

  const { count, rows: designations } = await reqDesignation.findAndCountAll({
    where,
    limit: Number(limit),
    offset,
    order: [["designationName", "ASC"]]
  });

  return res.status(200).json({
    result: true,
    message: response.DATA_RETRIEVED,
    count,
    totalPages: Math.ceil(count / limit),
    currentPage: Number(page),
    data: designations
  });

});

exports.createDesignation = tryCatch(async (req, res) => {
  const { designationName } = req.body;

  if (!designationName?.trim()) {
    return res.status(400).json({
      result: false,
      message: "Designation name is required.",
    });
  }

  const existingDesignation = await reqDesignation.findOne({
    where: {
      designationName: {
        [Op.iLike]: designationName.trim(),
      },
    },
  });

  if (existingDesignation) {
    return res.status(409).json({
      result: false,
      message: existingDesignation.status
        ? "Designation already exists."
        : "An inactive Designation with this name already exists. Please activate it instead.",
    });
  }

  const designation = await reqDesignation.create({
    designationName: designationName.trim()
  });

  return res.status(201).json({
    result: true,
    message: "Designation created successfully.",
    data: designation,
  });
});

exports.updateDesignation = tryCatch(async (req, res) => {
  const { designationId } = req.params;
  const { designationName } = req.body;

  if (!designationName?.trim()) {
    return res.status(400).json({
      result: false,
      message: "Designation name is required."
    })
  }

  const designation = await reqDesignation.findByPk(designationId);

  if (!designation) {
    return res.status(404).json({
      result: false,
      message: "Designation not found."
    })
  }

  const existingDesignation = await reqDesignation.findOne({
    where: {
      designationName: {
        [Op.iLike]: designationName.trim()
      },
      designationId: {
        [Op.ne]: designationId
      }
    }
  })

  if (existingDesignation) {
    return res.status(409).json({
      result: false,
      message: existingDesignation.status
        ? "Designation already exists."
        : "An inactive designation with this name already exists. Please activate it instead.",
    })
  }

  designation.designationName = designationName.trim();
  await designation.save();

  return res.status(200).json({
    result: true,
    message: "Designation updated successfully.",
    data: designation
  })


});

exports.deleteDesignation = tryCatch(async (req, res) => {
  const { designationId } = req.params;
  const designation = await reqDesignation.findByPk(designationId);

  if (!designation) {
    return res.status(404).json({
      result: false,
      message: "Designation not found."
    })
  }
  if (!designation.status) {
    return res.status(400).json({
      result: false,
      message: "Designation is already inactive.",
    });
  }

  // const isDesignationInUse = await reqServiceRequest.findOne({
  //   where: {
  //     requestDesignation: designationId,
  //   },
  // });

  // if (isDesignationInUse) {
  //   return res.status(400).json({
  //     result: false,
  //     message:
  //       "Designation cannot be deleted because it is associated with one or more service requests.",
  //   });
  // }
  await designation.update({
    status: false,
  });
  return res.status(200).json({
    result: true,
    message: "Designation deactivated successfully."
  })

});

exports.toggleDesignationStatus = tryCatch(async (req, res) => {
  const { designationId } = req.params;
  const { status } = req.body;

  if (typeof status !== "boolean") {
    return res.status(400).json({
      result: false,
      message: "Status must be either true or false.",
    });
  }

  const designation = await reqDesignation.findByPk(designationId);

  if (!designation) {
    return res.status(404).json({
      result: false,
      message: "Designation not found.",
    });
  }

  await designation.update({ status });

  return res.status(200).json({
    result: true,
    message: status
      ? "Designation activated successfully."
      : "Designation deactivated successfully.",
  });
});

// department CRUD 
exports.departmentList = tryCatch(async (req, res) => {
  const { search, page = 1, limit = 10 } = req.query;
  const where = {
    // status:true
  };
  if (search?.trim()) {
    where.teamName = {
      [Op.iLike]: `%${search.trim()}%`,
    };
  }
  const offset = (Number(page) - 1) * Number(limit);
  const { count, rows: departments } = await reqTeam.findAndCountAll({
    where,
    limit: Number(limit),
    offset,
    order: [["teamName", "ASC"]],
  });
  return res.status(200).json({
    result: true,
    message: response.DATA_RETRIEVED,
    count,
    totalPages: Math.ceil(count / Number(limit)),
    currentPage: Number(page),
    data: departments,
  });
});

exports.createDepartment = tryCatch(async (req, res) => {
  const { departmentName } = req.body;
  if (!departmentName?.trim()) {
    return res.status(400).json({
      result: false,
      message: "Department name is required.",
    });
  }
  const existingDepartment = await reqTeam.findOne({
    where: {
      teamName: {
        [Op.iLike]: departmentName.trim(),
      }
    },
  });
  if (existingDepartment) {
    return res.status(409).json({
      result: false,
      message: existingDepartment.status
        ? "Department already exists."
        : "An inactive department with this name already exists. Please activate it instead.",
    });
  }
  const department = await reqTeam.create({
    teamName: departmentName.trim(),
  });
  return res.status(201).json({
    result: true,
    message: "Department created successfully.",
    data: department,
  });
});

exports.updateDepartment = tryCatch(async (req, res) => {
  const { teamId } = req.params;
  const { departmentName } = req.body;

  if (!departmentName?.trim()) {
    return res.status(400).json({
      result: false,
      message: "Department name is required.",
    });
  }
  const department = await reqTeam.findByPk(teamId);
  if (!department) {
    return res.status(404).json({
      result: false,
      message: "Department not found.",
    });
  }
  const existingDepartment = await reqTeam.findOne({
    where: {
      teamName: {
        [Op.iLike]: departmentName.trim(),
      },
      teamId: {
        [Op.ne]: teamId,
      }
    },
  });
  if (existingDepartment) {
    return res.status(409).json({
      result: false,
      message: existingDepartment.status
        ? "Department already exists."
        : "An inactive department with this name already exists. Please activate it instead.",
    });
  }

  department.teamName = departmentName.trim();
  await department.save();

  return res.status(200).json({
    result: true,
    message: "Department updated successfully.",
    data: department
  })

});

exports.deleteDepartment = tryCatch(async (req, res) => {
  const { teamId } = req.params;
  const department = await reqTeam.findByPk(teamId);

  if (!department) {
    res.status(404).json({
      result: false,
      message: "Department not found."
    })
  }
  if (!department.status) {
    return res.status(400).json({
      result: false,
      message: "Department is already inactive.",
    });
  }
  // const isDepartmentInUse = await reqServiceRequest.findOne({
  //   where: {
  //     requestTeam: teamId,
  //   },
  // });
  // if (isDepartmentInUse) {
  //   return res.status(400).json({
  //     result: false,
  //     message:
  //       "Department cannot be deleted because it is associated with one or more service requests.",
  //   });
  // }
  await department.update({
    status: false,
  });
  return res.status(200).json({
    result: true,
    message: 'Department deactivated successfully.'
  })

});

exports.toggleDepartmentStatus = tryCatch(async (req, res) => {
  const { teamId } = req.params;
  const { status } = req.body;

  if (typeof status !== "boolean") {
    return res.status(400).json({
      result: false,
      message: "Status must be either true or false."
    });
  }

  const department = await reqTeam.findByPk(teamId);

  if (!department) {
    return res.status(404).json({
      result: false,
      message: "Department not found."
    });
  }

  await department.update({ status });

  return res.status(200).json({
    result: true,
    message: status
      ? "Department activated successfully."
      : "Department deactivated successfully."
  });
});

exports.skipCurrentStation = tryCatch(async (req, res, next) => {
  let { date } = req.body;
  const { serviceId, stationId, assigneeId, currentStation, comment, movedBy } =
    req.body;
  const sequenceData = await reqServiceSequence.findOne({
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
  const chekPreviouslyAdded = await reqServiceSequence.findOne({
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
  const newStationSequence = {
    serviceServiceRequst: sequenceData.serviceServiceRequst,
    serviceCandidate: sequenceData.serviceCandidate,
    serviceStation: stationId,
    serviceAssignee: assigneeId,
    serviceScheduledBy: assigneeId,
    serviceDate: date,
    serviceServiceId: sequenceData.serviceServiceId,
    previousCurrentStation: currentStation,
    resonSwitchStation: comment,
    insertOrUpdateDate: date,
  };

  const nextStationSequeence = await reqServiceSequence.create(
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
    const currentDate = moment().format("YYYY-MM-DDTHH:mm:ss.SSS[Z]");

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

    let positionCondition = ``;
    let joiningDateCondition = `AND DATE("reviewedJoiningDate") <= '${currentDate}'`;

    if (fromDate && toDate) {
      const nextDate = moment(toDate)
        .add(1, "day")
        .format("YYYY-MM-DD");

      if (status === "hired") {
        joiningDateCondition = `
    AND DATE("reviewedJoiningDate") >= '${fromDate}'
    AND DATE("reviewedJoiningDate") < '${nextDate}'
  `;
      } else {
        positionCondition += `
    AND "insertOrUpdateDate" >= '${fromDate}'
    AND "insertOrUpdateDate" < '${nextDate}'
  `;
      }
    }

    if (positionId) {
      positionCondition += ` AND "serviceServiceRequst" = ${positionId}`;
    }

    const joinType = status === "hired" ? 'INNER JOIN' : 'LEFT JOIN';

    const baseQuery = `
      FROM public."reqCandidates"
      INNER JOIN "reqServiceSequences" ON "serviceCandidate" = "candidateId"
      INNER JOIN "reqServiceRequests" ON "serviceServiceRequst" = "requestId"
      INNER JOIN "reqTeams" ON "teamId" = "requestTeam"
      ${joinType} "reqHrReviews" ON "serviceId" = "reviewedServiceId"
      ${joiningDateCondition}
    `;

    let whereClause = '';
    if (status === "total") {
      whereClause = `WHERE ("serviceStation"=1 OR "serviceStation" IS NULL)  ${positionCondition}`;
    } else if (status === "shorted") {
      whereClause = `WHERE "serviceStation" IN (2,3,4)
        AND "serviceStatus" IN (
        'pending', 'moved'
    )  ${positionCondition}`;
    } else if (status === "rejected") {
      whereClause = `WHERE ("serviceStatus"='rejected' OR "serviceStatus"='pannel-rejection')  ${positionCondition}`;
    } else if (status === "hired") {
      whereClause = `WHERE "serviceStation"=5 AND "serviceStatus"='done'  ${positionCondition}`;
    }

    const useDistinct = ["total", "shorted", "hired"].includes(status);
    const selectKeyword = useDistinct
      ? (positionId || status === 'shorted'
        ? 'SELECT DISTINCT ON ("candidateId")'
        : 'SELECT DISTINCT ON ("candidateId", "requestTeam")')
      : 'SELECT';
    const orderBy = useDistinct
      ? (positionId
        ? 'ORDER BY "candidateId", "serviceId" DESC'
        : 'ORDER BY "candidateId", "requestTeam", "serviceId" DESC')
      : 'ORDER BY "candidateId" DESC';

    const query = `
      ${selectKeyword} "candidateId", "candidateFirstName", "candidateLastName", "candidateEducation",
             "candidateExperience", "candidatePreviousOrg", "candidatePreviousDesignation",
             "candidateCity", "candidateStatus", "candidateRevlentExperience",
             "candidateTotalExperience",
             (SELECT "stationName" FROM "reqServiceSequences"
              INNER JOIN "reqStations" ON "stationId" = "serviceStation"
              WHERE "serviceCandidate" = "candidateId"
              ORDER BY "serviceId" DESC LIMIT 1) AS "currentStation"
      ${baseQuery} ${whereClause}
      ${orderBy} LIMIT ${limit} OFFSET ${offset};
    `;

    const countQuery = useDistinct
      ? `SELECT COUNT(*) AS count FROM (
          SELECT DISTINCT ON ("candidateId", "requestTeam") "candidateId"
          ${baseQuery} ${whereClause}
          ORDER BY "candidateId" DESC, "requestTeam" DESC
        ) AS subquery;`
      : `SELECT COUNT(*) AS count ${baseQuery} ${whereClause};`;

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
  const secretKey = process.env.S3_SECRET_KEY;
  const buckeName = process.env.S3_BUCKET_NAME;

  return res.status(200).json({
    result: true,
    message: "data retrived",
    data: { secretKey, buckeName },
  });
});

exports.statusFilter = tryCatch(async (req, res, next) => {
  const statusLists = [
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
    .json({ result: true, message: response.DATA_RETRIEVED, data: statusLists });
});

exports.workModeList = tryCatch(async (req, res, next) => {

  const workModeLists = [
    { workMode: "Remote" },
    { workMode: "Onsite" },
    { workMode: "Hybrid" },
  ];
  return res
    .status(200)
    .json({ result: true, message: response.DATA_RETRIEVED, data: workModeLists });
});

exports.prefferedList = tryCatch(async (req, res, next) => {
  const locationLists = [{ location: "Trivandrum" }, { location: "Cochin" }, { location: "Cochin & Trivandrum" }];
  return res
    .status(200)
    .json({ result: true, message: response.DATA_RETRIEVED, data: locationLists });
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

exports.generatePresignedUrl = tryCatch(async (req, res, next) => {

  try {
    const fileName = req.query.fileName;
    const fileType = req.query.fileType;
    const BUCKET_NAME = process.env.AWS_BUCKET_NAME;
    const region = process.env.AWS_REGION
    if (!fileName || !fileType) {
      return res.status(400).json({ result: false, message: "fileName and fileType are required" });
    }
    if (!BUCKET_NAME) {
      return res.status(500).json({ error: 'AWS_S3_BUCKET_NAME is not ACCESS' });
    }

    // Define unique key to avoid overwrites
    const key = `${Date.now()}-${fileName.replace(/\s+/g, '-')}`;

    const command = new PutObjectCommand({
      Bucket: BUCKET_NAME,
      Key: key,
      ContentType: fileType,
    });

    // Generate URL valid for 5 minutes (300 seconds)
    const presignedUrl = await getSignedUrl(s3Client, command, { expiresIn: 300 });
    const publicUrl = `https://${BUCKET_NAME}.s3.${region}.amazonaws.com/${key}`;
    return res.status(200).json({
      result: true,
      message: "Presigned URL generated successfully",
      data: {
        uploadUrl: presignedUrl,
        publicUrl: publicUrl,
        fileName: key, // returning the generated S3 key to avoid losing it
        originalFileName: fileName,
        filePath: key,
        fileUrl: publicUrl
      }
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Error generating upload URL"
    });
  }
});
