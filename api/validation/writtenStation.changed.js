const { body, validationResult } = require('express-validator');


exports.assignQuestions = [
    // body('questionAssignee').notEmpty().isInt(),
    body('questionId').notEmpty().isInt(),
    // body('questionBoxId').notEmpty().isInt(),
    body('questionServiceId').notEmpty().isInt().custom(async (value) => {

        if (value?.length <= 0) throw new Error(`Atleast one candidate's service required`);
    }),
    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
]


exports.viewDetail = [
    body('candidateServiceId').notEmpty().isInt(),
    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
];

exports.approve = [

];
