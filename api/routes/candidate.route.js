const express = require('express');
const router = express.Router();
let controller = require('../controller/candidate.controller.js');
let commonController = require('../controller/common.controller');
let { createRemove, createCandidate, candidateEdit, candidateHistoryFetch, submitApplicationValidate } = require('../validation/candidate.validate');
let { candidateForms, candidateFormsEdit } = require('../middleware/formData');
let uploadResume = require('../middleware/uploadResume');
let { authenticate,verifyAdmin } = require('../middleware/auth');
let commonFunction = require('../utils/commonFunction.js');

router.get('/list', authenticate, controller.listCandidates);

router.get('/list/:candidateId', authenticate, controller.viewCandidate);

router.post('/create', authenticate, createCandidate, controller.createCandidate);

router.post('/edit', candidateEdit, authenticate, controller.editCandidate);

router.get('/skills/list', authenticate, commonController.skillsList);

router.post('/add/skill', verifyAdmin, controller.addNewSkill); 

router.delete('/delete/skill/:id', verifyAdmin, controller.deleteSkill);

router.get('/resume-source/list', authenticate, controller.resumeSourceList);

router.get('/search/list', authenticate, controller.candiateMailList);

router.post('/remove-candidate', createRemove, authenticate, controller.removeCandidate);

router.get('/mail/template', authenticate, commonFunction.fetchMail);

router.post('/send-mail', authenticate, commonFunction.sendMail);

router.get('/candidate-history', authenticate,candidateHistoryFetch, controller.candidateHistory);

router.post('/upload-cv', authenticate, uploadResume.single('candidateCV'), controller.uploadCandidateCV);

router.post('/submit-application', uploadResume.single('candidateResume'), submitApplicationValidate, controller.submitApplication);

module.exports = router;

