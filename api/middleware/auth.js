/* eslint-disable no-else-return */
const jwt = require('jwt-simple');
const { reqUser } = require('../../models');
let { jwtVerifyToken } = require('../utils/jwt');



exports.authenticate = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader) {
            return res.status(401).send({ result: false, message: 'Authorization header missing' });
        }

        const token = authHeader.split(' ')[1];
        if (!token) {
            return res.status(401).send({ result: false, message: 'Token Undefined' });
        }

        const existToken = await jwtVerifyToken(token);
        if (!existToken) {
            return res.status(403).send({ result: false, message: 'Invalid Token, Re-login' });
        }

        const user = await reqUser.findOne({ where: { userId: existToken.userId } });
        if (!user) {
            return res.status(401).send({ result: false, message: 'Unauthorized! User not found' });
        }
        console.log(user.userType);
        // Only assign the userId if the user is not an admin
        if (user.userType !== 'admin' && user.userType !== 'super-admin') {
            req.userId = existToken.userId;
        }
        req.userType = user.userType;
        req.userRole = user.userRole;
        req.decodedToken = existToken;
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
        const authHeader = req.headers.authorization;
        if (!authHeader) {
            return res.status(401).send({ result: false, message: 'Authorization header missing' });
        }
        const token = authHeader.split(' ')[1];
        if (!token) throw new Error('Token Undefined');
        const existToken = await jwtVerifyToken(token);
        if (existToken.userType !== 'admin') return res.status(403).send({ result: false, message: 'Not an Admin' });
        next();
    } catch (error) {
        if (error.code === 'TOKEN_EXPIRED') {
            return res.status(401).json({ result: false, message: error.message, code: 'TOKEN_EXPIRED' });
        }
        if (error.code === 'INVALID_TOKEN') {
            return res.status(403).json({ result: false, message: error.message, code: 'INVALID_TOKEN' });
        }
        return next(error)
    }
}

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
