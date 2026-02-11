const { body, query, validationResult } = require('express-validator');


exports.createScreening = [
    body('serviceServiceRequst').notEmpty().isInt(),
    body('serviceCandidates').isArray().custom(async (value) => {

        if (value.length <= 0) throw new Error('Atleast one candidate required');
    }),
    body('serviceDate').notEmpty().isDate(),
    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
];

exports.requirementMapping = [
    body('requirementId').notEmpty().trim().isInt().withMessage('Service Id must contain a number'),
    body('userId').notEmpty().trim().isInt().withMessage('Service Id must contain a number'),
    body('candidatesId').isArray().custom(async (value) => {

        if (value.length <= 0) throw new Error('Atleast one candidate required');
    }),
    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
];

exports.acceptCandidateService = [
    body('serviceIds').isArray().custom(async (value) => {

        if (value.length <= 0) throw new Error('Atleast one candidate required');
    }),
    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
]

exports.interViewDetail = [
    body('recruiterId').notEmpty().trim().isInt().withMessage('recruiterId Id must contain a number'),
    body('candidateId').notEmpty().trim().isInt().withMessage('candidateId Id must contain a number'),
    body('location').notEmpty().trim().isString().withMessage('location Id is manadatory'),
    body('interviewTime').notEmpty().trim().isString().withMessage('interviewTime Id is manadatory'),
    body('interViewPanel').notEmpty().trim().isInt().withMessage('interViewPanel Id is manadatory'),
    body('interviewMode').notEmpty().trim().isString().withMessage('interviewMode Id is manadatory'),
    body('position').notEmpty().trim().isInt().withMessage('position Id is manadatory'),
    body('serviceId').notEmpty().trim().isInt().withMessage('serviceId Id is manadatory'),
    body('station').notEmpty().trim().isInt().withMessage('station Id is manadatory'),

    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
]

exports.rejectCandidate = [
    body('serviceId').notEmpty().trim().isInt().withMessage('Service Id must contain a number'),
    body('stationId').notEmpty().trim().isInt().withMessage('Station Id must contain a number'),
    body('status').notEmpty().trim().custom(async (value) => {
        if (value == 'selected' || value == 'rejected' || value == 'back-off' || value == 'pannel-rejection' || value == 'cancelled') {

        } else {
            throw new Error('Status Should be either selected Or rejected');
        }
    }),

    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
]

exports.interviewDetailValidation = [
    body('recruiterId').notEmpty().trim().isInt().withMessage('recruiterId Id must contain a number'),
    body('candidateId').notEmpty().trim().isInt().withMessage('candidateId Id must contain a number'),
    body('position').notEmpty().trim().isInt().withMessage('position Id must contain a number'),
    body('location').notEmpty().trim().withMessage('location is required'),
    body('noticePeriod').notEmpty().trim().withMessage('noticePeriod is required'),
    body('interViewPanel').notEmpty().trim().withMessage('interViewPanel is required'),
    body('interviewMode').notEmpty().trim().withMessage('interviewMode is required'),
    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
]

exports.removeUpdateCandidate = [
    query('commentId').notEmpty().isInt(),
    query('commentSeqenceId').notEmpty().isInt(),
    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
]