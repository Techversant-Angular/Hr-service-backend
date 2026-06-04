const { body, validationResult } = require('express-validator');

exports.addProgress = [
    body('progressAssignee').notEmpty(),
    body('progressServiceId').notEmpty(),
    body('progressScore').notEmpty(),

    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    },
];

exports.approve = [
    body('serviceSeqId').notEmpty().isInt(),
    body('interviewMode').notEmpty().isString(),
    body('feedBackBy').notEmpty(),
    body('feedBackCc').notEmpty(),
    body('feedBackMailTemp').notEmpty(), body('date').notEmpty(),
    body('feedBackSubject').notEmpty(), body('pannelUser').notEmpty(),

    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    },
];