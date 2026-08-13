require("dotenv").config();
// const jwt = require('jwt-simple');
const jwt = require("jsonwebtoken");
const crypto = require('crypto');

let secret = 'xxx';

// Generate short-lived access token
exports.jwtToken = async (userObj) => {
    const token = jwt.sign(userObj, process.env.TOKEN_SECRET, {
        expiresIn: process.env.ACCESS_TOKEN_EXPIRY || process.env.TOKEN_EXPIRY || '15m'
    });
    return token;
}
// exports.jwtToken = async (userObj) => {
//     const token = jwt.sign(userObj, process.env.TOKEN_SECRET);
//     return token;
// }

// Generate long-lived refresh token
exports.jwtRefreshToken = async (userObj) => {
    const refreshToken = jwt.sign(
        { userId: userObj.userId },
        process.env.REFRESH_TOKEN_SECRET,
        { expiresIn: process.env.REFRESH_TOKEN_EXPIRY || '1h' }
    );
    return refreshToken;
}

// Verify access token
exports.jwtVerifyToken = async (token) => {
    try {
        const verified = jwt.verify(token, process.env.TOKEN_SECRET);
        // Ensure tokenVersion present for older tokens
        verified.tokenVersion = Number(verified.tokenVersion ?? 1);
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
        const verified = jwt.verify(token, process.env.REFRESH_TOKEN_SECRET || process.env.TOKEN_SECRET);
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
