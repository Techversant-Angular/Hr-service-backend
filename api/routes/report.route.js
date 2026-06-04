const express = require('express');
const router = express.Router();
let controller = require('../controller/report.controller');
let { authenticate } = require('../middleware/auth');

router.get('/report-list', authenticate, controller.reportDailyReport);

router.get('/month-report-data', authenticate, controller.monthlyReportData);

router.get('/over-all-interview-status', authenticate, controller.overAllInterviewReportExperience);

// router.get("/downloadExcel", authenticate, controller.excelExport);


module.exports = router;
