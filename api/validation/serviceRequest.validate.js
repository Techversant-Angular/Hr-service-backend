const { body, validationResult } = require('express-validator');
let moment = require('moment');
let { reqServiceRequest } = require("../../models");

exports.createServiceValidation = [
    body('requestName').notEmpty().trim(),
    body('requestMinimumExperience').notEmpty().trim(),
    body('requestMaximumExperience').notEmpty().trim(),
    body('requestManager').notEmpty().trim(),
    body('requestSkills').isArray().withMessage('requestSkills must be an array'),
    body('requestDescription').notEmpty().isString(),
    body('requestDesignation').notEmpty().trim(),
    body('requestBaseSalary').notEmpty().isInt(),
    body('requestMaxSalary').notEmpty().isInt(),
    body('requestSalaryType').notEmpty().isInt().custom((value) => {

        if (value == 1 || value == 2) {
            return true;
        }
        throw new Error('requestSalaryType must be either 1 or 2 /month or year');
    }),
    body('requestTeam').notEmpty().trim(),
    body('requestVacancy').notEmpty().trim(),
    body('requestFlowStations').notEmpty().isArray().withMessage('requestFlowStations must be an array'),
    body('requestAssignTo').notEmpty().isInt(),
    body('requestPriority').notEmpty().trim().isIn(['critical', 'high', 'medium', 'low']).withMessage('requestPriority must be one of:critical, high, medium, low'),
    body('requestCode')
        .notEmpty().withMessage('Date is required')
        .custom(async (value) => {
            let jobCode = await reqServiceRequest.findOne({
                where: { requestCode: value },
            });
            if (jobCode) {
                throw new Error('Job code already exist');
            }
            return true;
        }),
    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    },
];

exports.editeServiceValidation = [
    body('requestMinimumExperience').notEmpty().trim(),
    body('requestMaximumExperience').notEmpty().trim(),
    body('requestManager').notEmpty().trim(),
    body('requestSkills').isArray().withMessage('requestSkills must be an array'),
    body('requestDesignation').notEmpty().trim(),
    body('requestBaseSalary').notEmpty().trim(),
    body('requestMaxSalary').notEmpty().trim(),
    body('requestVacancy').notEmpty().trim(),
    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    },
];

exports.activeServiceValidation = [
    body('requestionId').notEmpty().isInt(),
    body('approve').notEmpty().isBoolean(),

    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    },
];
