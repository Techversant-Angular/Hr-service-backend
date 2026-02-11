let moment = require("moment");
let { Op } = require("sequelize");
const { tryCatch } = require("../utils/trycatch");
let { excelGenerator } = require('../utils/excelGenerator');
let { reqReport, reqUser, reqServiceRequest,
  sequelize, reqExperienceReport } = require("../../models");


exports.reportDailyReport = tryCatch(async (req, res) => {
  let {
    reportUserId,
    reportFromDate,
    reportToDate,
    reportPageNo,
    reportPageLimit, report
  } = req.query;
  if (reportFromDate == reportToDate) {
    let tomorrow = moment().add(1, 'day');
    reportToDate = tomorrow.format('YYYY-MM-DD');
  }
  reportToDate = reportToDate + " 23:59:59";
  reportPageNo = reportPageNo || 0;
  reportPageLimit = reportPageLimit || 10;
  if (reportPageLimit && reportPageNo) {
    reportPageLimit = reportPageLimit;
    reportPageNo = (reportPageNo - 1) * reportPageLimit;
  }
  reportPageLimit = report == 'true' ? 10000 : reportPageLimit;
  reportPageNo = report == 'true' ? 0 : reportPageNo;

  let where = reportUserId ? { recruiter: reportUserId } : {};
  reportFromDate
    ? (where.date = { [Op.between]: [reportFromDate, reportToDate] })
    : {};
  //joins query
  let include = [
    {
      model: reqUser,
      attributes: ["userfirstName", "userlastName", "userId"],
      as: "recruiterName",
    },
    {
      model: reqServiceRequest,
      required: true,
      as: "positionName",
      attributes: [["requestName", "Position Title"]],
    },
  ];
  let reportCount = await reqReport.count({ include, where });
  let reports = await reqReport.findAll({
    include,
    where,
    attributes: [['positionHc', 'Vacancy'], [sequelize.fn('SUM', sequelize.col('naukriResume')), 'Naukri Resume'], [sequelize.fn('SUM', sequelize.col('linkedinResume')), 'Linkedin Resume'],
    [sequelize.fn('SUM', sequelize.col('sourcedScreened')), 'Sourced Screened'], [sequelize.fn('SUM', sequelize.col('candidateContacted')), 'Candidate Contacted'], [sequelize.fn('SUM', sequelize.col('candidatesIntrested')), 'Candidates Intrested'],
    [sequelize.fn('SUM', sequelize.col('interviewScheduled')), 'Interview Scheduled'], [sequelize.fn('SUM', sequelize.col('offerReleased')), 'Offer Released'], [sequelize.fn('SUM', sequelize.col('interviewConducted')), 'Interview Conducted'],
    ['date', 'Date']], group: ['Vacancy', 'Date', "recruiterName.userfirstName", "recruiterName.userlastName", "recruiterName.userId", "positionName.requestName", "reqReport.id"],
    order: [["id", "DESC"]],
    raw: true,
    limit: reportPageLimit,
    offset: reportPageNo,
  });

  reports = await Promise.all(reports.map(async (element) => {
    element.Recruiter = element['recruiterName.userfirstName'] + ' ' + element['recruiterName.userlastName'];
    element['Position Title'] = element['positionName.Position Title'];
    delete element["recruiterName.userfirstName"];
    delete element["recruiterName.userlastName"];
    delete element["positionName.Position Title"];
    delete element["recruiterName.userId"];
    return element;
  }));

  if (report == 'true' && reports) {
    let head = [];
    let reportsObj = reports[0];
    for (const report in reportsObj) {
      let hedObject = {};
      hedObject.header = report;
      hedObject.key = report;
      head.push(hedObject);
    }

    let body = reports;
    let name = `report${moment().format('yyyymmddHHMMSS')}`;
    excelGenerator(req, res, head, body, name);
    return;
  }
  // return
  if (reports)
    return res
      .status(200)
      .json({ result: true, message: "data retrived", reportCount, data: reports });
  return res.status(401).json({ result: false, messge: "data not found" });
});


exports.monthlyReportData = tryCatch(async (req, res) => {
  let date = req.query.month;
  let recruiter = req.query.userId;
  let year = moment(date).format("YYYY");
  let month = moment(date).format("MM");
  let dataExistObj = {
    year,
    month
  };
  let dataExistQuery = '';
  if (recruiter) { dataExistObj.recruiter=recruiter;dataExistQuery=` AND "recruiter"=:recruiter ` }
  let [reportDataExist, reportMetadata] = await sequelize.query(
    `   SELECT COUNT("sourcedScreened") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month ${dataExistQuery}`,
    {
      replacements: dataExistObj
    }
  );
  if (reportDataExist[0].count == 0)
    return res.status(200).json({
      result: false,
      message: "data not found",
      data: []
    });
  let [monthReport, metadata] = await sequelize.query(
    `   SELECT 
        COALESCE((SELECT SUM("sourcedScreened") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month ${dataExistQuery}),0) AS "sourcedScreened",
        COALESCE((SELECT SUM("candidateContacted") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month ${dataExistQuery}),0) AS "candidateContacted",
        COALESCE((SELECT SUM("candidatesIntrested") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month ${dataExistQuery}),0) AS "candidatesIntrested",
        COALESCE((SELECT SUM("interviewScheduled") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month ${dataExistQuery}),0) AS "interviewScheduled",
        COALESCE((SELECT SUM("offerReleased") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month  ${dataExistQuery}),0) AS "offerReleased",
        COALESCE((SELECT SUM("offerAccepeted") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month  ${dataExistQuery}),0) AS "offerAccepeted"`,
    {
      replacements: dataExistObj,
    }
  );

  let [total, totalMetadata] = await sequelize.query(
    `   SELECT 
        COALESCE((SELECT SUM("sourcedScreened") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month ),0) AS "sourcedScreened",
        COALESCE((SELECT SUM("candidateContacted") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month ),0) AS "candidateContacted",
        COALESCE((SELECT SUM("candidatesIntrested") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month ),0) AS "candidatesIntrested",
        COALESCE((SELECT SUM("interviewScheduled") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month ),0) AS "interviewScheduled",
        COALESCE((SELECT SUM("offerReleased") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month),0) AS "offerReleased",
        COALESCE((SELECT SUM("offerAccepeted") FROM public."reqReports" WHERE 
        EXTRACT(YEAR FROM "date") = :year AND 
        EXTRACT(MONTH FROM "date") = :month),0) AS "offerAccepeted"`,
    {
      replacements: {
        year,
        month,
        recruiter
      },
    }
  );
  return res
    .status(200)
    .json({
      result: true,
      message: "data retrived",
      data: monthReport,
      totalReportMonth: total,
    });
});


exports.overAllInterviewReportExperience = tryCatch(async (req, res) => {
  let limit = req.query.limit || 100;
  let offset = req.query.page || 0;
  offset = offset == 1 ? 0 : offset;
  if (limit && offset) {
    limit = limit;
    offset = (offset - 1) * limit;
  }
  let include = { model: reqServiceRequest,required:true, attributes: ['requestName'] }
  let toatlCount = await reqExperienceReport.count({ include });
  let experienceInterviewCounts = await reqExperienceReport.findAll({
    include, limit, offset, order: [['id', 'DESC']]
  });
  experienceInterviewCounts = experienceInterviewCounts.filter(el => {
  
if(el.reqServiceRequest){
 el.technology = `${el.reqServiceRequest.requestName}`;
return el;
}
  })
  if (experienceInterviewCounts) return res
    .status(200)
    .json({
      result: true,
      message: "data retrived", toatlCount,
      data: experienceInterviewCounts
    });
  return res
    .status(401)
    .json({
      result: false,
      message: "data not found"
    });
});
