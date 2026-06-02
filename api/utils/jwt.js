const dotenv = (require("dotenv").config()).parsed
// const jwt = require('jwt-simple');
const jwt = require("jsonwebtoken");

let secret = 'xxx';

// Generate short-lived access token
// exports.jwtToken = async (userObj) => {
//     const token = jwt.sign(userObj, dotenv.TOKEN_SECRET, {
//         expiresIn: dotenv.TOKEN_EXPIRY || '1h'
//     });
//     return token;
// }
exports.jwtToken = async (userObj) => {
    const token = jwt.sign(userObj, dotenv.TOKEN_SECRET);
    return token;
}

// Generate long-lived refresh token
exports.jwtRefreshToken = async (userObj) => {
    const refreshToken = jwt.sign(
        { userId: userObj.userId },
        dotenv.REFRESH_TOKEN_SECRET,
        { expiresIn: dotenv.REFRESH_TOKEN_EXPIRY || '1h' }
    );
    return refreshToken;
}

// Verify access token
exports.jwtVerifyToken = async (token) => {
    try {
        const verified = jwt.verify(token, dotenv.TOKEN_SECRET);
        return verified;
    } catch (err) {
        if (err.name === 'TokenExpiredError') {
            const error = new Error('Token expired. Please re-login.');
            error.status = 401;
            error.code = 'TOKEN_EXPIRED';
            throw error;
        }
        if (err.name === 'JsonWebTokenError') {
            const error = new Error('Invalid token.');
            error.status = 403;
            error.code = 'INVALID_TOKEN';
            throw error;
        }
        throw err;
    }
}

// Verify refresh token
exports.jwtVerifyRefreshToken = async (token) => {
    try {
        const verified = jwt.verify(token, dotenv.REFRESH_TOKEN_SECRET || dotenv.TOKEN_SECRET);
        return verified;
    } catch (err) {
        if (err.name === 'TokenExpiredError') {
            const error = new Error('Refresh token expired. Please re-login.');
            error.status = 401;
            error.code = 'REFRESH_TOKEN_EXPIRED';
            throw error;
        }
        if (err.name === 'JsonWebTokenError') {
            const error = new Error('Invalid refresh token.');
            error.status = 403;
            error.code = 'INVALID_REFRESH_TOKEN';
            throw error;
        }
        throw err;
    }
}