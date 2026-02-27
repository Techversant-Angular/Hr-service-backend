const { validationResult } = require('express-validator');
const createHttpError = require('http-errors');

/**
 * Common validation result handler for express-validator
 */
const validateRequest = (req, res, next) => {
    const errors = validationResult(req);

    if (!errors.isEmpty()) {
        const errorMessages = errors.array().map(err => err.msg).join(', ');
        const error = new createHttpError.BadRequest(`Validation Error: ${errorMessages}`);
        error.errors = errors.array();
        return next(error);
    }

    next();
};

module.exports = validateRequest;
