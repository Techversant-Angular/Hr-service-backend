let {
  reqServiceFlow,
  reqServiceSequence,
  reqServiceRequest,
  reqTask,
  reqReport, reqExperienceReport,
  reqCandidateLog,
} = require("../../models");
const { Op, where } = require("sequelize");
let moment = require("moment");
let date = moment().format("YYYY-MM-DD");
const db = require("../../models/index");
let sequelize = db.sequelize;
let workingDays = require("./dateTime");
const msgTemplate = require("./mailTemplate.json");
let { googleMeetApi } = require("./gmeetConfiguration");
let jsonData = require("../utils/userRignts.json");
let { reqCandidates } = require("../../models");

async function updateCandidateStations(stationId, candidateIds) {
  try {
    let updatedStation = await sequelize.query(
      `UPDATE "reqCandidates" SET "candidateStation"=:stationId WHERE "candidateId" IN (:candidateIds)`,
      {
        replacements: {
          stationId,
          candidateIds: candidateIds,
        },
      }
    );
  } catch (error) {
    console.error("Error updating records:", error);
  }
}

async function getNextStation(currentStationId, serviceServiceId) {
  try {
    let subQuery = `(SELECT COUNT(*) FROM "reqServiceFlows" WHERE "flowServiceId"=:serviceServiceId)`;
    let nextStationCondition = {
      flowStationId: {
        [Op.gt]: currentStationId,
      },
    };
    let nextStation = await reqServiceFlow.findAll({
      attributes: [
        "flowId",
        "flowServiceId",
        "flowStationId",
        "flowStationName",
        [sequelize.literal(subQuery), "flowCount"],
      ],
      where: {
        flowServiceId: serviceServiceId,
        ...nextStationCondition,
      },
      limit: 1,
      raw: true,
      replacements: {
        serviceServiceId: serviceServiceId,
      },
    });
    return nextStation[0].flowStationId;
  } catch (error) {
    console.error("Error updating records:", error);
    throw error;
  }
}

async function storeTasks(taskDate, serviceCount, serviceSeqence, userId) {
  let dates = workingDays.getNextWorkingDays(taskDate, serviceCount);
  serviceSeqence.forEach(async (element, i) => {
    await reqTask.findOrCreate({
      where: { taskServiceId: element.serviceId, taskUserId: userId },
      default: {
        taskServiceId: element.serviceId,
        taskUserId: userId,
        taskDate: dates[i],
      },
    });
  });
  return dates;
}

let nextStationSequence = async (
  assigneeId,
  serviceSeqence,
  date,
  serviceScheduledBy
) => {
  try {
    let toDate = moment().format("YYYY-MM-DD");
    let serviceIds = [];
    let serviceSeqences = await Promise.all(
      serviceSeqence.map(async (elem, i) => {
        serviceIds.push(elem.serviceId);
        let serviceStationS = await getNextStation(
          elem.serviceStation,
          elem.serviceServiceId
        );
        //rejection record
        if (elem.serviceStation == 3 || elem.serviceStation == 4) {
          if (serviceStationS == 5) {
            reqcuriterReport(
              elem.serviceServiceRequst,
              moment().format("YYYY-MM-DD"),
              serviceScheduledBy,
              "technicalTotalSelected"
            );
          }
        }
        if (!serviceStationS) return false;
        logFunction(
          elem.serviceCandidate,
          serviceScheduledBy,
          `Interview Scheduled in ${jsonData.stationList[serviceStationS]}`,
          serviceStationS
        );
        await updateCandidateStations(serviceStationS, elem.serviceCandidate);

        return {
          serviceServiceRequst: elem.serviceServiceRequst,
          serviceCandidate: elem.serviceCandidate,
          serviceStation: serviceStationS,
          serviceAssignee: assigneeId,
          serviceDate: date,
          serviceServiceId: elem.serviceServiceId,
          serviceScheduledBy: serviceScheduledBy,
          insertOrUpdateDate: toDate,
          interviewMode: elem.interviewMode
        };
      })
    );
    console.log(serviceSeqences, 'serviceSeqences------------bulk');

    let nextStationSequeence = await reqServiceSequence.bulkCreate(
      serviceSeqences
    );

    await reqServiceSequence.update(
      { serviceStatus: "done", insertOrUpdateDate: toDate },
      {
        where: {
          serviceId: {
            [Op.in]: serviceIds,
          },
        },
      }
    );
    return nextStationSequeence;
  } catch (error) {
    console.error("Error updating records:", error);
    throw error;
  }
};

let addContactedCount = async (userId, serviceServiceRequst, positionHc) => {
  try {
    let targetDate = new Date(date);
    let where = {
      recruiter: userId,
      position: serviceServiceRequst,
      date: {
        [Op.between]: [
          targetDate,
          new Date(targetDate.getTime() + 24 * 60 * 60 * 1000),
        ],
      },
    };
    let getIntervieExistCount = await reqReport.findOne({
      attributes: ["candidateContacted"],
      where,
    });

    let totalScheduledCount = 1;
    if (getIntervieExistCount?.candidateContacted) {
      totalScheduledCount = getIntervieExistCount.candidateContacted + 1;
      await reqReport.update(
        { candidateContacted: totalScheduledCount },
        { where }
      );
    } else {
      //for every day report
      await reqReport.create({
        candidateContacted: totalScheduledCount,
        recruiter: userId,
        position: serviceServiceRequst,
        date,
        positionHc,
      });
    }
  } catch (error) {
    console.log(error);
  }
};

let fetchMail = async (req, res, next) => {
  try {
    let msgType = req.query.msgType;
    let candidateId = req.query.candidateId;

    if ((!msgType == "rejection" || !msgType == "offer", !msgType == "approve"))
      return res.status(401).json({
        result: false,
        message: "Message Type will be either rejection Or offer Or approve",
      });
    let candidate = await reqCandidates.findOne({
      where: { candidateId },
      attributes: ["candidateEmail", "candidateFirstName"],
    });
    let mailId = candidate.candidateEmail;
    let candidateName = candidate.candidateFirstName;
    let subject = msgType.charAt(0).toUpperCase();
    let messageTemplate = msgTemplate[msgType].message.replace(
      "CandidateName",
      candidateName
    );

    return res.status(200).json({
      result: false,
      message: "template recived",
      data: { subject, message: messageTemplate, toMail: mailId },
    });
  } catch (error) {
    next(error);
  }
};

let mailSend = require("./nodeMail");
let sendMail = async (req, res) => {
  try {
    let { mailId, subject, message, cc, bcc, attachmentArray } = req.body;
    if (!mailId || !message || !subject)
      return res
        .status(401)
        .send({ result: false, message: "Insuffecient Parameter" });
    let mailSended = await mailSend.sendEmail(
      mailId,
      subject,
      message,
      cc,
      bcc,
      attachmentArray
    );
    if (mailSended)
      return res
        .status(200)
        .json({ result: true, message: "mail send successfully" });
  } catch (error) {
    console.error("Error sending mail:", error);
  }
};

//profile source function
async function profileSourceReport(
  candidateCreatedby,
  candidatesAddingAgainst,
  resumeSourceId, date
) {
  try {
    let dateWithTz = moment(date).format("YYYY-MM-DD HH:mm:ssZ");
    let startDate = moment(date).format("YYYY-MM-DD 00:00:00Z");
    let endDate = moment(date).format("YYYY-MM-DD 23:59:59Z");

    let [reportExist, metaData] = await sequelize.query(
      `SELECT * FROM public."reqReports" 
      WHERE "date" BETWEEN '${startDate}' AND '${endDate}'
      AND "recruiter" = :recruiter 
      AND "position" = :position`,
      {
        replacements: {
          recruiter: candidateCreatedby,
          position: candidatesAddingAgainst,
        },
        type: sequelize.QueryTypes.SELECT,
      }
    );

    let positionCount = await reqServiceRequest.findOne({
      where: { requestId: candidatesAddingAgainst },
      raw: true,
    });
    let noOfVacancy = positionCount ? positionCount.requestVacancy : null;

    if (!reportExist) {
      //insert new report
      let reportData = {
        recruiter: candidateCreatedby,
        position: candidatesAddingAgainst,
        positionHc: noOfVacancy,
        date: dateWithTz,
      };
      reportData.sourcedScreened = resumeSourceId.length;
      let naukriResumeCount = 0;
      let linkedinResumeCount = 0;
      let indeedResumeCount = 0;
      let candidateResumeCount = 0;
      let inHouseResumeCount = 0;

      resumeSourceId.forEach((el) => {
        if (el == 1) {
          //NAUKRI
          naukriResumeCount = naukriResumeCount + 1;
        } else if (el == 2) {
          //LINKEDIN
          linkedinResumeCount = linkedinResumeCount + 1;
        } else if (el == 3) {
          //INDEED
          indeedResumeCount = indeedResumeCount + 1;
        } else if (el == 4) {
          //CANDIDATE
          candidateResumeCount = candidateResumeCount + 1;
        }
        else if (el == 5) {
          //INHOUSE
          inHouseResumeCount = inHouseResumeCount + 1;
        }
      });

      reportData.naukriResume = naukriResumeCount;
      reportData.linkedinResume = linkedinResumeCount;
      reportData.indeedResume = indeedResumeCount;
      reportData.candidateResume = candidateResumeCount;
      reportData.inHouseResume = inHouseResumeCount;
      reqReport.create(reportData);
    } else {
      //update on existing report
      let dataToUpdate = {
        naukriResume: reportExist.naukriResume,
        linkedinResume: reportExist.linkedinResume,
        indeedResume: reportExist.indeedResume,
        candidateResume: reportExist.candidateResume,
        inHouseResume: reportExist.inHouseResume,
        sourcedScreened: reportExist.sourcedScreened,
      };
      resumeSourceId.forEach((el) => {
        if (el == 1) {
          //NAUKRI
          dataToUpdate.naukriResume = dataToUpdate.naukriResume + 1;
          dataToUpdate.sourcedScreened = dataToUpdate.sourcedScreened + 1;
        } else if (el == 2) {
          //LINKEDIN
          dataToUpdate.linkedinResume = dataToUpdate.linkedinResume + 1;
          dataToUpdate.sourcedScreened = dataToUpdate.sourcedScreened + 1;
        } else if (el == 3) {
          //INDEED
          dataToUpdate.indeedResume = dataToUpdate.indeedResume + 1;
          dataToUpdate.sourcedScreened = dataToUpdate.sourcedScreened + 1;
        } else if (el == 4) {
          //CANDIDATE
          dataToUpdate.candidateResume = dataToUpdate.candidateResume + 1;
          dataToUpdate.sourcedScreened = dataToUpdate.sourcedScreened + 1;
        }
        else if (el == 5) {
          //INHOUSE
          dataToUpdate.inHouseResume = dataToUpdate.inHouseResume + 1;
          dataToUpdate.sourcedScreened = dataToUpdate.sourcedScreened + 1;
        }
      });

      await reqReport.update(dataToUpdate, {
        where: { id: reportExist.id },
      });
    }
  } catch (error) {
    console.log(error);
  }
}

async function updateReportData(
  actionType,
  candidateCreatedby,
  candidatesAddingAgainst,
  dateFrom
) {
  try {
    const dateWithTz = moment(dateFrom).format("YYYY-MM-DD HH:mm:ssZ");
    const date = moment(dateFrom).format("YYYY-MM-DD");

    const [reportExist, metaData] = await sequelize.query(`
      SELECT * FROM public."reqReports" WHERE DATE("date") ='${date}'
      AND "recruiter"=${candidateCreatedby} AND "position"=${candidatesAddingAgainst}`);

    const positionCount = await reqServiceRequest.findOne({
      where: { requestId: candidatesAddingAgainst },
      raw: true,
    });

    const noOfVacancy = positionCount ? positionCount.requestVacancy : null;
    let reportData;

    if (reportExist.length == 0) {
      reportData = {
        recruiter: candidateCreatedby,
        position: candidatesAddingAgainst,
        positionHc: noOfVacancy,
        date: dateWithTz,
        [actionType]: 1,
      };
      await reqReport.create(reportData);
    } else {
      const updatedCount = reportExist[0][actionType] + 1;
      await sequelize.query(
        `
          UPDATE "reqReports" 
          SET "${actionType}" = :updatedCount
          WHERE "recruiter" = :candidateCreatedby 
          AND "position" = :candidatesAddingAgainst 
          AND DATE("date") = :date`,
        {
          replacements: {
            updatedCount,
            candidateCreatedby,
            candidatesAddingAgainst,
            date,
          },
        }
      );
    }
  } catch (error) {
    console.error(error);
  }
}

async function logFunction(candidateId, actionBy, actionString, station) {
  try {
    // let serviceRequestId = await reqServiceSequence.findOne({ where: { serviceId }, attributes: ["serviceServiceRequst"] });
    let logData = { station, candidateId, actionBy, action: actionString };
    await reqCandidateLog.create(logData);
  } catch (error) {
    console.log(error);
  }
}

async function reqcuriterReport(
  position,
  date,
  user,
  column_name,
  noOfCandidate = 1
) {
  try {
    let query = "";
    let selectQuery = `SELECT "id" FROM "reqreqruiterStationReports" where "position"=:position AND "user"=:user AND DATE_TRUNC('day', "date"::timestamp) = DATE_TRUNC('day', '${date}'::timestamp);`;
    let [selectedData, metadata] = await sequelize.query(selectQuery, {
      replacements: {
        position: position,
        user,
        date,
      },
    });

    if (selectedData.length) {
      query = `UPDATE "reqreqruiterStationReports" SET "${column_name}" ="${column_name}"+ ${noOfCandidate} 
    WHERE DATE("date")='${date}' AND "position"='${position}' AND "user"='${user}'`;
    } else {
      query = `INSERT INTO "reqreqruiterStationReports"  ("${column_name}","date","position","user") VALUES(${noOfCandidate} ,'${date}',${position},${user})`;
    }

    let [reportData, data] = await sequelize.query(query);
  } catch (error) {
    console.log(error);
  }
}

const getLastSixMonths = async () => {
  const today = moment();
  let sixMonthQuery = "";
  for (let i = 0; i < 6; i++) {
    const startOfMonth = today.clone().subtract(i, "months").startOf("month");
    const endOfMonth = today.clone().subtract(i, "months").endOf("month");
    let month = startOfMonth.format("MMMM-YYYY");
    let startDate = startOfMonth.format("YYYY-MM-DD");
    let endDate = endOfMonth.format("YYYY-MM-DD");
    let monthQueryString = `SELECT  '${month}' AS month, COALESCE(SUM("totalSourced"), 0) AS total_totalSourced,COALESCE(SUM("offerReleased"), 0) AS total_offerReleased,COALESCE(SUM("hired"), 0) AS total_hired FROM "reqreqruiterStationReports" WHERE "date" BETWEEN '${startDate}' AND '${endDate}' ${i != 5 ? "UNION" : ""
      } `;
    sixMonthQuery = sixMonthQuery + monthQueryString;
  }
  return sixMonthQuery;
};

async function reqestionStatusUpdate(serviceRequestId) {
  // Fetch the service request data
  let getServiceRequest = await reqServiceRequest.findOne({
    where: {
      requestId: serviceRequestId,
    },
    attributes: ["requestVacancy", "requestHiredCount", "requestStatus"],
  });

  if (!getServiceRequest) {
    throw new Error(`Service request with ID ${serviceRequestId} not found`);
  }

  // Calculate the vacancy count and hired count
  let vacancyCount = getServiceRequest.requestVacancy;
  let hiredCount = getServiceRequest.requestHiredCount + 1;

  // Update the hired count and status in a single operation
  let updateValues = { requestHiredCount: hiredCount };

  if (hiredCount === vacancyCount) {
    updateValues.requestStatus = "closed";
  }
  await reqServiceRequest.update(updateValues, {
    where: {
      requestId: serviceRequestId,
    },
  });
}

async function addExperiencInterviewScheduled(position, count) {
  try {
    let getPosition = await reqExperienceReport.findOne({
      where: { technology: position },
    });
    if (getPosition) {
      await reqExperienceReport.update(
        { interviewStatusCount: count + getPosition.interviewStatusCount },
        { where: { technology: position } }
      );
    } else {
      await reqExperienceReport.create({
        interviewStatusCount: count,
        technology: position,
        rescheduleStatusCount: 0,
      });
    }
  } catch (error) {
    console.log(error);
  }
}

async function isRequestionClosed(serviceId) {
  let serviceSeqence = await reqServiceSequence.findOne({
    include: [{ model: reqServiceRequest, as: 'serviceRequest', where: { requestStatus: 'closed' } }],
    where: {
      serviceId: serviceId
    },
    raw: true,
  });
  const status = serviceSeqence ? false : true;
  return status;
}

const reader = require("xlsx");
const fs = require("fs");

async function extractCandidateDatas(params) {
  // Reading our test file
  const file = reader.readFile("./6-monthdata.xlsx");
  let data = [];
  const sheets = file.SheetNames;

  for (let i = 0; i < sheets.length; i++) {
    const temp = reader.utils.sheet_to_json(file.Sheets[file.SheetNames[i]]);
    temp.forEach((res) => {
      data.push(res);
    });
  }
}


async function meetingLinkReplace(mailTemplate, dateTime, attendees) {
  try {
    console.log(attendees, "attendees-----------------------");

    // Generate the Google Meet link
    const meetLink = await googleMeetApi(dateTime, attendees);
    console.log(meetLink, "meetLink----------------------------------------------");

    // Replace the placeholder in the mail template
    const addedLinkMailTemplate = mailTemplate.replace(
      `Meeting Link :`,
      `Meeting Link : ${meetLink}`
    );
    console.log(addedLinkMailTemplate, "addedLinkMailTemplate------------------------------");

    return addedLinkMailTemplate;
  } catch (error) {
    console.error("Error generating or replacing the meeting link:", error);
    throw error; // Propagate the error for further handling
  }
}

// Sent Feedback Reminder Mail

const sendFeedbackReminder = async (userEmail, userName, candidateName) => {
  const subject = `Reminder: Feedback Pending for Candidate ${candidateName}`;
  const html = `
    <p>Hi ${userName},</p>
    <p>This is a gentle reminder to provide your remarks/feedback for the candidate ${candidateName}.</p>
    <p>Please log in to the system and complete your feedback.</p>
    <p>Thanks,<br/>Recruitment Team</p>
  `;

  await sendMail({
    to: userEmail,
    subject,
    html,
  });
};

// Send Acknowledgement Mail

const sendFeedbackAcknowledgement = async (hrEmail, hrName, candidateName) => {
  const subject = `Update: Candidate ${candidateName}'s Interview Feedback Has Been Reviewed`;
  const html = `
    <p>Hi ${hrName},</p>
    <p>We wanted to inform you that our panel has reviewed candidate ${candidateName}'s interview feedback.</p>
    <p>Thank you!</p>
    <p>Recruitment Team</p>
  `;

  await sendMail({
    to: hrEmail,
    subject,
    html,
  });
};



module.exports = {
  storeTasks,
  profileSourceReport,
  reqcuriterReport,
  sendMail,
  fetchMail,
  getNextStation,
  updateCandidateStations,
  nextStationSequence,
  logFunction,
  addContactedCount,
  updateReportData,
  reqestionStatusUpdate,
  getLastSixMonths,
  addExperiencInterviewScheduled,
  isRequestionClosed,
  meetingLinkReplace,
  sendFeedbackReminder,
  sendFeedbackAcknowledgement,
};
