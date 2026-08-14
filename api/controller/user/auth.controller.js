let { reqUser, Sequelize, reqUserRoleMapping, reqUserRole, reqAccessToken } = require('../../../models');
let { jwtToken, jwtRefreshToken, jwtVerifyRefreshToken } = require('../../utils/jwt');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
let { jwtDecode } = require('jwt-decode');
let mailFunction = require("../../utils/nodeMail");
const { Op } = require('sequelize');
const admin = require("../../../config/firebase");

const hashRefreshToken = (token) => crypto.createHash('sha256').update(token).digest('hex');
const setRefreshTokenCookie = (req, res, refreshToken) => {
    const isHttpsRequest = req.secure || req.headers['x-forwarded-proto'] === 'https';
    const shouldUseSecureCookie = process.env.COOKIE_SECURE === 'true'
        || (process.env.COOKIE_SECURE !== 'false' && (process.env.NODE_ENV === 'production' || isHttpsRequest));

    res.cookie('refreshToken', refreshToken, {
        httpOnly: true,
        secure: shouldUseSecureCookie,
        sameSite: isHttpsRequest ? 'none' : 'lax',
        path: '/',
        maxAge: 4 * 24 * 60 * 60 * 1000
    });
};

const getUserRoles = async (userId) => {
    const roles = await reqUserRoleMapping.findAll({
        where: { userId },
        include: [{ model: reqUserRole, as: 'role', required: true }]
    });
    return roles.map(({ role }) => role?.roleName).filter(Boolean);
};

const getTokenPayload = (user, userRole) => ({
    userId: user.userId,
    userFullName: user.userFullName,
    userEmail: user.userEmail,
    userDOB: user.userDOB,
    userType: user.userType,
    userRole
});

const issueTokens = async (user, userRole) => {
    const token = await jwtToken(getTokenPayload(user, userRole));
    const refreshToken = await jwtRefreshToken(user.userId);
    await reqAccessToken.create({ accessToken: hashRefreshToken(refreshToken) });
    return { token, refreshToken };
};

exports.login = async (req, res, next) => {
    try {
        let { userName, gmail, userPassword } = req.body;
        if (gmail) {
            const decodedToken = jwtDecode(gmail);
            userName = decodedToken.email;
        }
        let user = await reqUser.findOne({
            where: { userEmail: userName }
        });
        if (!user) {
            return res
                .status(401)
                .json({ status: false, message: 'Invalid user credentials.' });
        }
        if (!await user.validatePassword(userPassword)) return res
            .status(401)
            .json({ status: false, message: 'Invalid password' });

        const formattedRoles = await getUserRoles(user.userId);
        if (!formattedRoles.length) {
            return res.status(403).json({
                status: false,
                message: "User has no assigned roles"
            });
        }
        
        let userData = {
            userId: user.userId,
            userFullName: user.userFullName,
            userEmail: user.userEmail,
            userDOB: user.userDOB,
            userType: user.userType,
            userRole: formattedRoles,
            tokenVersion: Number(user.tokenVersion || 1)
        };

        let token = await jwtToken(userData);
        let refreshToken = await jwtRefreshToken(userData);

        // Store refresh token in database
        await reqAccessToken.create({ accessToken: refreshToken });
        setRefreshTokenCookie(req, res, refreshToken);

        let responseUser = user.toJSON();
        responseUser.userRole = formattedRoles;

        return res.status(200).json({
            token,
            // refreshToken,
            user: responseUser,
        });

    } catch (error) {
        next(error);
    }
}


exports.changePassword = async (req, res, next) => {
    try {
        let { userCurrentPassword, userNewPassword } = req.body;
        let userId = req.userId;

        let condition = { where: { userId: userId, userStatus: 'active' } };
        let user = await reqUser.findOne(condition);

        if (!user) return res.status(400).json({ status: false, message: 'User not exist' });

        const isValidPassword = await bcrypt.compare(userCurrentPassword, user.userPassword);

        if (!isValidPassword) return res.status(400).json({ status: false, message: 'Enter the Correct current Password' });

        const hashedNewPassword = await bcrypt.hash(userNewPassword, 10);
        await reqUser.update({ userPassword: hashedNewPassword }, condition);
        return res.json({ status: true, message: 'Password Successfully changed' });

    } catch (error) {
        next(error);
    }
}


exports.forgotPassword = async (req, res, next) => {
    try {
        const userEmail = req.body.userEmail?.trim().toLowerCase();
        const isValidUser = await reqUser.findOne({ where: { userEmail, userStatus: 'active' } });

        if (!isValidUser) {
            // Do not reveal whether an account exists for an email address.
            return res.status(200).json({ status: true, message: 'If an active account exists, an OTP has been sent.' });
        }
        const otpExpiry = new Date();
        otpExpiry.setMinutes(otpExpiry.getMinutes() + (Number(process.env.PASSWORD_RESET_OTP_MINUTES) || 10));
        const otp = crypto.randomInt(100000, 1000000).toString();
        const hashedOtp = await bcrypt.hash(otp, 10);

        await isValidUser.update({ userOtp: hashedOtp, useOtpExpire: otpExpiry });
        try {
            await mailFunction.sendEmail(
                isValidUser.userEmail,
                'Password reset OTP',
                `<p>Use this OTP to reset your password:</p><h2>${otp}</h2><p>This OTP expires in ${Number(process.env.PASSWORD_RESET_OTP_MINUTES) || 10} minutes. Do not share it with anyone.</p>`,
                '',
                '',
                []
            );
        } catch (mailError) {
            await isValidUser.update({ userOtp: null, useOtpExpire: null });
            throw mailError;
        }

        return res.status(200).json({ status: true, message: 'If an active account exists, an OTP has been sent.' });

    } catch (error) {
        next(error);
    }
}

exports.resetPassword = async (req, res, next) => {
    try {
        const { userEmail, otp, password, confirmPassword } = req.body;
        if (password !== confirmPassword) return res.status(400).json({ status: false, message: 'Passwords do not match.' });

        const isValidOtp = await reqUser.findOne({
            where: { userEmail, userStatus: 'active', useOtpExpire: { [Op.gt]: new Date() } }
        });
        if (!isValidOtp || !isValidOtp.userOtp || !await bcrypt.compare(String(otp), isValidOtp.userOtp)) {
            return res.status(400).json({ status: false, message: 'OTP is invalid or has expired.' });
        }
        const hashedNewPassword = await bcrypt.hash(confirmPassword, 10);
        await isValidOtp.update({ userPassword: hashedNewPassword, userOtp: null, useOtpExpire: null });
        return res.status(200).json({ status: true, message: 'Password changed successfully.' });
    } catch (error) {
        next(error);
    }
}

exports.googleLogin = async (req, res) => {
    try {
        const { idToken } = req.body;
        if (!idToken) {
            return res.status(400).json({ message: "ID token is required" });
        }

        // Verify Firebase Token
        const decodedToken = await admin.auth().verifyIdToken(idToken);
        const { email, name } = decodedToken;

        // Check if email domain is allowed
        const allowedDomainsStr = process.env.ALLOWED_EMAIL_DOMAINS;
        if (allowedDomainsStr && email) {
            const allowedDomains = allowedDomainsStr.split(',').map(d => d.trim().toLowerCase());
            const emailDomain = email.split('@')[1]?.toLowerCase();

            if (!emailDomain || !allowedDomains.includes(emailDomain)) {
                return res.status(403).json({
                    result: false,
                    message: "Unauthorized: Your email domain is not permitted."
                });
            }
        }

        // Check database for the user using Sequelize
        let user = await reqUser.findOne({
            where: { userEmail: email },
            order: [['createdAt', 'DESC']]
        });

        if (user && user.userStatus !== 'active') {
            return res.status(403).json({
                result: false,
                message: "No account is associated with this Google email address."
            });
        }

        if (!user) {
            return res.status(404).json({
                result: false,
                message: "User not found"
            });
        }
        const formattedRoles = await getUserRoles(user.userId);
        if (!formattedRoles.length) {
            return res.status(403).json({
                status: false,
                message: "User has no assigned roles"
            });
        }

        // Generate JWT token (same as regular login flow)
        let userData = {
            userId: user.userId,
            userFullName: user.userFullName,
            userEmail: user.userEmail,
            userDOB: user.userDOB,
            userType: user.userType,
            userRole: formattedRoles,
            tokenVersion: Number(user.tokenVersion || 1)
        };

        let token = await jwtToken(userData);
        let refreshToken = await jwtRefreshToken(userData);

        // Store refresh token in database
        await reqAccessToken.create({ accessToken: refreshToken });
        setRefreshTokenCookie(req, res, refreshToken);

        const responseUser = user.toJSON();
        responseUser.userRole = formattedRoles;
        return res.status(200).json({
            result: true,
            message: "Google login successful",
            token,
            // refreshToken,
            data: responseUser
        });
    } catch (err) {
        console.error("Firebase auth error:", err);
        return res.status(401).json({ message: "Unauthorized: Invalid or expired token" });
    }
};

exports.refreshToken = async (req, res, next) => {
    try {
        let refreshToken = req.body?.refreshToken || req.cookies?.refreshToken;
        if (!refreshToken) {
            return res.status(400).json({ status: false, message: 'Refresh token is required' });
        }

        const decoded = await jwtVerifyRefreshToken(refreshToken);
        
        // Check if token exists in database (not revoked)
        const storedToken = await reqAccessToken.findOne({
            where: { accessToken: refreshToken }
        });
        if (!storedToken) {
            return res.status(401).json({
                status: false,
                code: 'REVOKED_REFRESH_TOKEN',
                message: 'Refresh token has been revoked or logged out.'
            });
        }

        // Fetch the user information to generate a new access token
        const user = await reqUser.findOne({
            where: { userId: decoded.userId }
        });
        if (!user || user.userStatus !== 'active') {
            return res.status(401).json({
                status: false,
                message: 'User is inactive or not found.'
            });
        }

        // Get roles from roleMapping table
        let roles = await reqUserRoleMapping.findAll({
            where: { userId: user.userId },
            include: [{
                model: reqUserRole,
                as: 'role',
                required: true // INNER JOIN
            }]
        });

        let formattedRoles = roles.map(r =>
            r.role ? r.role.roleName : null
        ).filter(role => role !== null);

        let userData = {
            userId: user.userId,
            userFullName: user.userFullName,
            userEmail: user.userEmail,
            userDOB: user.userDOB,
            userType: user.userType,
            userRole: formattedRoles,
            tokenVersion: Number(user.tokenVersion || 1)
        };

        // Generate new access token
        let newAccessToken = await jwtToken(userData);

        // Security feature: Refresh Token Rotation
        // Generate new refresh token
        let newRefreshToken = await jwtRefreshToken(userData);

        // Delete old refresh token first, then save new refresh token
        await reqAccessToken.destroy({ where: { accessToken: refreshToken } });
        await reqAccessToken.create({ accessToken: newRefreshToken });
        setRefreshTokenCookie(req, res, newRefreshToken);

        return res.status(200).json({
            status: true,
            token: newAccessToken,
            // refreshToken: newRefreshToken
        });

    } catch (error) {
        if (error.code === 'REFRESH_TOKEN_EXPIRED') {
            return res.status(401).json({ status: false, code: error.code, message: error.message });
        }
        if (error.code === 'INVALID_REFRESH_TOKEN') {
            return res.status(403).json({ status: false, code: error.code, message: error.message });
        }
        return res.status(500).json({ status: false, message: error.message || 'Internal Server Error' });
    }
};
