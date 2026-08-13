require("dotenv").config();
// const jwt = require('jwt-simple');
const jwt = require("jsonwebtoken");
const crypto = require('crypto');

let secret = 'xxx';

// Generate short-lived access token
// exports.jwtToken = async (userObj) => {
//     const token = jwt.sign(userObj, dotenv.TOKEN_SECRET, {
//         expiresIn: dotenv.TOKEN_EXPIRY || '1h'
//     });
//     return token;
// }
exports.jwtToken = async (userObj) => {
    const token = jwt.sign(userObj, process.env.TOKEN_SECRET, {
        expiresIn: process.env.ACCESS_TOKEN_EXPIRY || process.env.TOKEN_EXPIRY || '15m'
    });
    return token;
}

// Generate long-lived refresh token
exports.jwtRefreshToken = async (userId) => {
    if (!process.env.REFRESH_TOKEN_SECRET) {
        throw new Error('REFRESH_TOKEN_SECRET must be configured.');
    }
    return jwt.sign(
        { userId, tokenType: 'refresh', jti: crypto.randomUUID() },
        process.env.REFRESH_TOKEN_SECRET,
        { expiresIn: process.env.REFRESH_TOKEN_EXPIRY || '7d' }
    );
}

// Verify access token
exports.jwtVerifyToken = async (token) => {
    try {
        const verified = jwt.verify(token, process.env.TOKEN_SECRET);
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

exports.jwtVerifyRefreshToken = async (token) => {
    try {
        if (!process.env.REFRESH_TOKEN_SECRET) {
            throw new Error('REFRESH_TOKEN_SECRET must be configured.');
        }
        const verified = jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);
        if (verified.tokenType !== 'refresh') {
            const error = new Error('Invalid refresh token.');
            error.code = 'INVALID_REFRESH_TOKEN';
            throw error;
        }
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
