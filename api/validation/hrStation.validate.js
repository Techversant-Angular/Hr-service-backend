const { body, validationResult } = require('express-validator');


exports.createScreening = [
    body('offerServiceSeqId').notEmpty().isInt(),
    body('offerSalary').notEmpty().isInt(),

    body('offerJoinDate').notEmpty().isDate(),
    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
];
