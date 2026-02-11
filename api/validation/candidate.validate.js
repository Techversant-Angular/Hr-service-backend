const { body, validationResult } = require('express-validator');
const formidable = require('formidable');

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
    body('candidateCreatedby').isString().withMessage('Created by must be a string').optional({ nullable: true }),
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

exports.candidateEdit=[
 
    body('candidateId').isInt().withMessage('Candidates Id against must be a Number').optional({ nullable: true }),
  

    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
];