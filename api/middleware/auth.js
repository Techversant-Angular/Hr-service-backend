/* eslint-disable no-else-return */
const jwt = require('jwt-simple');
const { reqUser } = require('../../models');
let { jwtVerifyToken } = require('../utils/jwt');

const getBearerToken = (authHeader) => {
    if (!authHeader) return null;
    const parts = authHeader.split(' ');
    if (parts.length !== 2 || !parts[1]) return null;
    return parts[1];
};

const ensureFreshSession = async (tokenPayload, res) => {
    if (!tokenPayload || !tokenPayload.userId) {
        return null;
    }

    const user = await reqUser.findOne({ where: { userId: tokenPayload.userId } });
    if (!user) {
        res.status(401).json({ result: false, message: 'Unauthorized! User not found' });
        return null;
    }

    const currentVersion = Number(user.tokenVersion || 1);
    const tokenVersion = Number(tokenPayload.tokenVersion ?? currentVersion);

    if (tokenVersion !== currentVersion) {
        res.status(401).json({
            result: false,
            message: 'Session invalidated because your role changed. Please log in again.'
        });
        return null;
    }

    return user;
};

exports.authenticate = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader) {
            return res.status(401).send({ result: false, message: 'Authorization header missing' });
        }

        const token = getBearerToken(authHeader);
        if (!token) {
            return res.status(401).send({ result: false, message: 'Token Undefined' });
        }

        const existToken = await jwtVerifyToken(token);
        if (!existToken) {
            return res.status(403).send({ result: false, message: 'Invalid Token, Re-login' });
        }

        const user = await ensureFreshSession(existToken, res);
        if (!user) return;

        req.userId = user.userId;
        req.userType = user.userType;
        req.userRole = user.userRole;

        next();
    } catch (error) {
        if (error.code === 'TOKEN_EXPIRED') {
            return res.status(401).json({ result: false, message: error.message, code: 'TOKEN_EXPIRED' });
        }
        if (error.code === 'INVALID_TOKEN') {
            return res.status(403).json({ result: false, message: error.message, code: 'INVALID_TOKEN' });
        }
        next(error);
    }
};
 
 
let { jwtDecode } = require('../utils/jwt');
exports.verifyAdmin = async (req, res, next) => {
    try {
        // authenticate middleware must run before verifyAdmin
        if (!req.userId) {
            return res.status(401).send({
                result: false,
                message: 'Unauthorized'
            });
        }
 
        const user = await reqUser.findOne({
            where: { userId: req.userId }
        });
 
        if (!user) {
            return res.status(401).send({
                result: false,
                message: 'Unauthorized! User not found'
            });
        }
 
        if (user.userType !== 'admin') {
            return res.status(403).send({
                result: false,
                message: 'Access Denied. Admin privileges required.'
            });
        }
 
        next();
    } catch (error) {
        next(error);
    }
};
 
exports.verifyTalentTeam = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        const token = authHeader.split(' ')[1];
        if (!token) {
            throw new Error('Token Undefined');
        }
        //decode the token
        let userObj = await jwtDecode(token);
        if (userObj.userRole === 'talent') return next();
        if (existToken.userType !== 'talent') return res.status(403).send({ result: false, message: 'You Are Not From Talent Team, Only Talent Team can have rights to approve to Next Station' });
        return res.status(403).send({ result: false, message: 'You Are Not From Talent Team, Only Talent Team can have rights to approve to Next Station' });
    } catch (error) {
        if (error.code === 'TOKEN_EXPIRED') {
            return res.status(401).json({ result: false, message: error.message, code: 'TOKEN_EXPIRED' });
        }
        return next(error)
    }
}
 
 