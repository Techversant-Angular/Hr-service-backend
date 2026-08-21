const express = require('express');
const router = express.Router();
let controller = require('../controller/candidate.controller.js');
let commonController = require('../controller/common.controller');
let attachmentController = require('../controller/candidateAttachment.controller.js');
const resumeController = require('../controller/resume.controller.js');
let { createRemove, createCandidate, candidateEdit, candidateHistoryFetch, submitApplicationValidate } = require('../validation/candidate.validate');
let { createAttachmentValidate, listAttachmentsValidate, deleteAttachmentValidate } = require('../validation/candidateAttachment.validate.js');
let { candidateForms, candidateFormsEdit } = require('../middleware/formData');
let uploadResume = require('../middleware/uploadResume');
let { authenticate, verifyAdmin } = require('../middleware/auth');
let commonFunction = require('../utils/commonFunction.js');

router.get('/list', authenticate, controller.listCandidates);

router.get('/list/:candidateId', authenticate, controller.viewCandidate);

router.post('/create', authenticate, createCandidate, controller.createCandidate);

router.post('/records', authenticate, createCandidate, controller.createCandidateRecords);


router.post('/edit', candidateEdit, authenticate, controller.editCandidate);

router.get('/skills/list', authenticate, commonController.skillsList);

router.post('/add/skill', verifyAdmin, controller.addNewSkill);

router.delete('/delete/skill/:id', verifyAdmin, controller.deleteSkill);

router.get('/resume-source/list', authenticate, controller.resumeSourceList);

router.get('/search/list', authenticate, controller.candiateMailList);

router.post('/remove-candidate', createRemove, authenticate, controller.removeCandidate);

router.get('/mail/template', authenticate, commonFunction.fetchMail);

router.post('/send-mail', authenticate, commonFunction.sendMail);

router.get('/candidate-history', authenticate, candidateHistoryFetch, controller.candidateHistory);

router.post('/submit-application', uploadResume.single('candidateResume'), submitApplicationValidate, controller.submitApplication);

router.post('/apply-job', uploadResume.single('candidateResume'), submitApplicationValidate, controller.jobApply);

router.post('/resume/upload', uploadResume.single('candidateResume'), controller.uploadResume);

router.get('/sourced-candidates', authenticate, controller.sourcedCandidates);

router.get('/careers/job/openings', controller.jobOpeningCareers);

// candidate attachments
router.get('/attachment/types', authenticate, attachmentController.getAttachmentTypes);
router.post('/attachment', authenticate, createAttachmentValidate, attachmentController.createAttachment);
router.get('/attachment', authenticate, listAttachmentsValidate, attachmentController.getAttachments);
router.delete('/attachment/:attachmentId', authenticate, deleteAttachmentValidate, attachmentController.deleteAttachment);


router.get('/careers/job/applications', controller.jobCareerApplications);


// AI-powered resume parsing using Google Gemini
router.post("/resume/ai-parse", uploadResume.single("candidateResume"), resumeController.parseResume);

// Extracts basic candidate details using regex and predefined logic
router.post("/resume/manual-parse", uploadResume.single("candidateResume"), resumeController.uploadResumePdf );

// AI-powered ATS analysis
router.post("/resume/ats-analysis", uploadResume.single("candidateResume"), resumeController.analyseResume );

// AI Interview Question Generation
router.post("/resume/interview-questions", uploadResume.single("candidateResume"), resumeController.generateInterviewQuestions);

module.exports = router;

