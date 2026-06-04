const { body, query, validationResult } = require('express-validator');

exports.updateUser = [
    query('userId').notEmpty().isInt(),
    body('userEmail').isEmail().optional({ nullable: true }),
    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        next();
    }
];

// exports.changePswd = [

//     body('userCurrentPassword').notEmpty(),
//     body('userNewPassword').notEmpty().custom(async (value, { req }) => {
//         if (value !== req.body.userConfirmPassword) throw new Error('Password and confirm Possword Not matched');

//     }),
//     body('userConfirmPassword', "Please enter a password at least 8 character and contain At least one uppercase.At least one lower case.At least one special character. ").notEmpty().isStrongPassword({
//         minLength: 8,
//         minLowercase: 1,
//         minUppercase: 1,
//         minNumbers: 1,
//         minSymbols: 1
//     }).notEmpty().custom(async (value, { req }) => {
//         if (value == req.body.userCurrentPassword) throw new Error('Both passwords are same try with new password');

//     }),
//     (req, res, next) => {
//         const errors = validationResult(req);

//         if (!errors.isEmpty()) {
//             return res.status(400).json({ errors: errors.array() });
//         }

//         next();
//     }
// ];

//added on 20-sep-24. functionality same as above. refactored code and changed messages.
exports.changePswd = [
    body('userCurrentPassword').notEmpty().withMessage('Current password is required'),
    body('userNewPassword').notEmpty().withMessage('New password is required')
        .isStrongPassword({
            minLength: 8,
            minLowercase: 1,
            minUppercase: 1,
            minNumbers: 1,
            minSymbols: 1
        }).withMessage("Please enter a password at least 8 characters and contain at least one uppercase, one lowercase, one special character, and one number.")
        .custom(async (value, { req }) => {
            if (value === req.body.userCurrentPassword) {
                throw new Error('Both passwords are the same; try with a new password');
            }
        }),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }
        next();
    }
];


exports.skipStation=[
    body('serviceId').notEmpty().isInt(),
    body('stationId').notEmpty().isInt(),
    body('assigneeId').notEmpty().isInt(),
    body('date').notEmpty(),
    body('currentStation').notEmpty().isInt(),

    (req, res, next) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }
        next();
    }
];