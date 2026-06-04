const express = require('express');
const router = express.Router();
let controller = require('../controller/management.controller');
let { createScreening } = require('../validation/managementStation.validate');
let { authenticate } = require('../middleware/auth');

router.get("/list", authenticate, controller.list);

// router.post("/myTask", require('../controller/common.controller').userTasks);

router.get('/candidateDetail', authenticate, controller.fetchFinalCandidte);

router.post('/candidateOffer', createScreening, authenticate, controller.candidateOffers);

router.post('/candidateToUser', authenticate, controller.candidateToUser);

router.get('/progressDetail', authenticate, controller.progressDetail);

router.post('/add-progress/v1', authenticate, controller.addProgressV1);

router.post('/approve',  authenticate, controller.approve);

module.exports = router;
