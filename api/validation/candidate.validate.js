const { body, query, validationResult } = require('express-validator');
const formidable = require('formidable');
const createHttpError = require('http-errors');
const validateRequest = require('../utils/validationHelper');

// The candidate wizard submits values grouped by form step, while the candidate
// model and controller use one flat object. Normalize only the /records payload
// before its validation runs; the existing /create endpoint keeps its API shape.
exports.normalizeCandidateRecord = (req, res, next) => {
    const {
        candidateForm,
        candidateDetailsForm,
        candidatePersonalDetailsForm,
        candidateProfessionalDetailsForm,
        candidateSkillsForm
    } = req.body || {};

    const normalizeDate = (dateVal) => {
        if (!dateVal || typeof dateVal !== 'string') return dateVal;
        const match = dateVal.match(/^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})$/);
        if (match) {
            const day = match[1].padStart(2, '0');
            const month = match[2].padStart(2, '0');
            const year = match[3];
            return `${year}-${month}-${day}`;
        }
        return dateVal;
    };

    // A flat payload is still supported for API clients using the old contract.
    if (!candidateForm && !candidateDetailsForm && !candidatePersonalDetailsForm &&
        !candidateProfessionalDetailsForm && !candidateSkillsForm) {
        if (req.body && req.body.candidateDoB) {
            req.body.candidateDoB = normalizeDate(req.body.candidateDoB);
        }
        return next();
    }

    const sourceName = candidateForm?.applicationSource;
    const sourceIds = {
        naukri: 1,
        linkedin: 2,
        indeed: 3,
        candidate: 4,
        reference: 5
    };
    const skillIds = (skills) => Array.isArray(skills)
        ? skills.map((skill) => typeof skill === 'object' ? skill.id : skill).filter(Boolean)
        : skills;

    req.body = {
        ...candidateForm,
        ...candidateDetailsForm,
        ...candidatePersonalDetailsForm,
        ...candidateProfessionalDetailsForm,
        candidateDoB: normalizeDate(candidateDetailsForm?.candidateDoB),
        candidatePreferlocation: candidateForm?.preferredLocation,
        // Accept either an existing numeric source ID or the display name sent by the UI.
        resumeSourceId: Number.isInteger(Number(sourceName))
            ? Number(sourceName)
            : sourceIds[String(sourceName || '').trim().toLowerCase()],
        candidatePrimarySkills: skillIds(candidateSkillsForm?.technicalSkills),
        candidateSecondarySkills: skillIds(candidateSkillsForm?.softSkills),
        // Never accept the creator ID from the browser.
        candidateCreatedby: req.userId
    };

    next();
};

exports.createRemove = [
    body('candidateId').notEmpty().isInt(),
    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
];


exports.createCandidate = [
    body('candidateFirstName').isString().withMessage('First name must be a string').notEmpty().withMessage('First name is required'),
    body('candidateLastName').isString().withMessage('Last name must be a string').notEmpty().withMessage('Last name is required'),
    body('candidateEmail').isEmail().withMessage('Invalid email address'),
    body('candidateMobileNo').isMobilePhone().withMessage('Invalid mobile number'),
    body('candidatePreviousOrg').isString().withMessage('Previous organization must be a string').optional({ nullable: true }),
    body('candidatePreviousDesignation').isString().withMessage('Previous designation must be a string').optional({ nullable: true }),
    body('candidateEducation').isString().withMessage('Education must be a string').optional({ nullable: true }),
    body('candidateCurrentSalary').isInt().withMessage('Current salary must be a Number').optional({ nullable: true }),
    body('candidateExpectedSalary').isInt().withMessage('Expected salary must be a Number').optional({ nullable: true }),
    body('candidateAddress').isString().withMessage('Address must be a string').optional({ nullable: true }),
    body('candidateCreatedby').isInt().withMessage('Created by must be a numeric user ID').optional({ nullable: true }),
    body('candidatePrimarySkills').isArray().withMessage('Primary skills must be an array').optional({ nullable: true }),
    body('candidateSecondarySkills').isArray().withMessage('Secondary skills must be an array').optional({ nullable: true }),
    body('resumeSourceId').isInt().withMessage('Resume source ID must be an integer').optional({ nullable: true }),
    body('candidateGender').isString().withMessage('Gender must be a string').isIn(['Male', 'Female', 'Others']).withMessage('Invalid gender').optional({ nullable: true }),
    body('candidateCity').isString().withMessage('City must be a string').optional({ nullable: true }),
    body('candidateDistrict').isString().withMessage('District must be a string').optional({ nullable: true }),
    body('candidateState').isString().withMessage('State must be a string').optional({ nullable: true }),
    body('candidateResume').isString().withMessage('Resume must be a URL string').optional({ nullable: true }),
    body('candidatePreferlocation').isString().withMessage('Prefered Location is mandatory').optional({ nullable: true }),
    body('candidateRevlentExperience').isString().withMessage('candidate Revlent Experience is mandatory').optional({ nullable: true }),
    body('candidateTotalExperience').isString().withMessage('candidate Total Experience is mandatory').optional({ nullable: true }),
    body('candidateNoticePeriodByDays').isString().withMessage('candidate Notice Period is mandatory'),


    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
];

exports.candidateEdit = [

    body('candidateId').isInt().withMessage('Candidates Id against must be a Number').optional({ nullable: true }),


    (req, res, next) => {
        const normalizeDate = (dateVal) => {
            if (!dateVal || typeof dateVal !== 'string') return dateVal;
            const match = dateVal.match(/^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})$/);
            if (match) {
                const day = match[1].padStart(2, '0');
                const month = match[2].padStart(2, '0');
                const year = match[3];
                return `${year}-${month}-${day}`;
            }
            return dateVal;
        };

        if (req.body && req.body.candidateDoB) {
            req.body.candidateDoB = normalizeDate(req.body.candidateDoB);
        }

        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
];


exports.candidateHistoryFetch = [
    query('email').isEmail().withMessage('Invalid email address'),
    // query('requestId').isInt().withMessage('Invalid request ID'),
    validateRequest
]

exports.submitApplicationValidate = [
    body('candidateFirstName').notEmpty().withMessage('First Name is required').isString().withMessage('First Name must be a string'),
    body('candidateLastName').notEmpty().withMessage('Last Name is required').isString().withMessage('Last Name must be a string'),
    body('candidateEmail').notEmpty().withMessage('Email is required').isEmail().withMessage('Invalid email address'),
    body('candidateMobileNo').notEmpty().withMessage('Phone number is required').isMobilePhone().withMessage('Invalid phone number'),
    body('appliedPosition').notEmpty().withMessage('Please select a job position'),
    // body('candidateCoverLetter').notEmpty().withMessage('Cover letter is required').isLength({ min: 50 }).withMessage('Cover letter must be at least 50 characters'),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }
        next();
    }
];
