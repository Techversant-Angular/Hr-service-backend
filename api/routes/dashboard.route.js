const express = require("express");
const router = express.Router();
let controller = require("../controller/dashboard.controller");
let commonController = require('../controller/common.controller');
let { authenticate } = require('../middleware/auth');

router.get('/resume-source', authenticate, controller.resumeSourceData);

router.get('/recruiter-list', authenticate, commonController.recruiterList);

router.get('/interview-count', authenticate, controller.interViewCounts);

router.get('/six-month-count', authenticate, controller.sixMonthDepartmentCount);

router.get('/department-daily-application', authenticate, controller.dailyApplicationDepartment);

router.get('/requirement-report', authenticate, controller.myRequirementReport);

router.get('/recruiter-requirement-report', authenticate, controller.requriterHiringData);

router.get('/card-data', authenticate, controller.dashBoardCard);

router.get('/candidate-by-status', authenticate, commonController.getCandidatesByCard);

router.get('/recruiter-chart', authenticate, controller.recruiterChart);

router.get('/department-chart', authenticate, controller.departmentChart);

router.post('/send-feedback-reminderMail', authenticate, controller.sendFeedbackReminder);


module.exports = router;
