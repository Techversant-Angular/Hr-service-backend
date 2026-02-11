const express = require("express");
const router = express.Router();
let controller = require("../controller/hrStation.controller");
let {createScreening}=require('../validation/hrStation.validate');
let { authenticate } = require('../middleware/auth');

router.get("/list",authenticate, controller.list);

router.post("/myTask", require('../controller/common.controller').userTasks);

router.get('/candidateDetail', authenticate,controller.fetchFinalCandidte);

router.post('/candidateOffer', createScreening,authenticate, controller.candidateOffers);

router.post('/candidateToUser',authenticate,controller.candidateToUser);

router.post('/add-progress', authenticate, controller.addProgress);

router.get('/progressDetail', authenticate, controller.progressDetail);

module.exports = router;
