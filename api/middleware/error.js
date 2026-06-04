const ApiError = require('../utils/ApiError');

/**
 * Error handling middleware
 */
const errorHandler = (err, req, res, next) => {
    let error = err;

    // Convert unknown errors to ApiError if they aren't already
    if (!(error instanceof ApiError)) {
        const statusCode = error.statusCode || error.status || (error.name?.startsWith('Sequelize') ? 400 : 500);
        const message = error.message || 'Internal Server Error';
        error = new ApiError(statusCode, message, false, err.stack);
    }

    const { statusCode, message } = error;

    // Log error for debugging
    console.error(`[Error] ${req.method} ${req.path}:`, err);

    const response = {
        result: false,
        error_message: message,
        // Include specific validation errors if present
        ...(err.errors && { errors: err.errors }),
        // Include full error and stack in non-production environments
        // ...(process.env.NODE_ENV !== 'production' && {
        //     error: err,
        //     stack: err.stack
        // })
    };

    res.status(statusCode).send(response);
};

module.exports = errorHandler;