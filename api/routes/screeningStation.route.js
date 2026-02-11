const express = require('express');
const router = express.Router();
let controller = require('../controller/screeningStation.controller');
let commonController = require('../../api/controller/common.controller');
let { createScreening, acceptCandidateService, rejectCandidate,
    removeUpdateCandidate, requirementMapping } = require('../validation/screenStation.validate');
let { authenticate } = require('../middleware/auth');

router.post('/create', createScreening, controller.groupCandidate);

router.post('/map-candidates', requirementMapping, authenticate, controller.candidateMapRequirement);
router.post('/map-candidates-v1', authenticate, controller.candidateMapRequirementv1);

router.get('/candidate/progress',authenticate,controller.candidatesPrgressList);

router.get('/list-batch/:requestId', authenticate, controller.batchCandidates);

router.put('/unmapp/candidate', authenticate, controller.removeAfterMapped);

router.get('/v1/list-all', authenticate, controller.groupListsv1);

router.post('/accept', authenticate, acceptCandidateService, controller.acceptCandidateService);

router.post('/reject/candidate', rejectCandidate, authenticate, commonController.rejectCandidate);

router.post('/interview-details', authenticate, controller.interviewDetail);

router.get('/interview-details/candidates-list', authenticate, controller.interviewDetailCandidatesList);

router.get('/interview-details/candidate-detail', authenticate, controller.interviewDetailCandidateView);

router.delete('/remove/candidate-comment', removeUpdateCandidate, authenticate, commonController.candidateCommentsDelete);

router.put('/update/candidate-comment', removeUpdateCandidate, authenticate, commonController.candidateCommentsUpdate);

router.get('/feedback-list', authenticate, commonController.feedbacksList);

router.get('/rejection-list', authenticate, commonController.rejectionList);

router.get('/interview-mode/list', authenticate, controller.interviewModeList);

router.get('/todays-interview-list', authenticate, controller.toDateInterviewList);


module.exports = router;
