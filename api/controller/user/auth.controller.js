let { reqUser, reqAccessToken, Sequelize } = require('../../../models');
let { jwtToken } = require('../../utils/jwt');
const bcrypt = require('bcryptjs');
let { jwtDecode } = require('jwt-decode');
let mailFunction = require("../../utils/nodeMail");
const { Op } = require('sequelize');
const admin = require("../../../config/firebase");

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
        let userData = {
            userId: user.userId,
            userFullName: user.userFullName,
            userEmail: user.userEmail,
            userDOB: user.userDOB,
            userType: user.userType,
            userRole: user.userRole
        };

        let token = await jwtToken(userData);
        return res.status(200).json({
            token,
            user,
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
        let { userName } = req.body;
        let isValidUser = await reqUser.findOne({ where: { userEmail: userName, userStatus: 'active' } });

        if (!isValidUser) {
            return res.status(400).json({ status: false, message: 'Not a Valid User' });
        }
        let userId = isValidUser.userId;
        let userMail = isValidUser.userEmail;
        const otpExpier = new Date();
        otpExpier.setMinutes(otpExpier.getMinutes() + 1);

        const otp = Math.floor(1000 + Math.random() * 9000);
        let otpStored = await reqUser.update({ userOtp: otp, useOtpExpire: otpExpier }, { where: { userId } });
        let mailSubject = `Re-set Password`;
        let mailBody = `<div><h3>OTP:${otp}</h3><br><h4>Otp will Expire in One minute</h4></div>`
        await mailFunction.sendEmail(
            userMail,
            mailSubject,
            mailBody,
            "",
            "",
            [], {}
        );

        if (otpStored) return res.status(200).json({ status: true, message: 'Otp Mail Send Successfully' });

    } catch (error) {
        next(error);
    }
}

exports.resetPassword = async (req, res, next) => {
    try {
        let { otp, password, confirmPassword } = req.body;
        if (password.localeCompare(confirmPassword) != 0) return res.status(400).json({ result: false, message: 'passwords are not equal' });


        // OTP expiration to be fixed.

        let isValidOtp = await reqUser.findOne({
            where: {
                userOtp: otp,
                // useOtpExpire: {
                //     [Op.gt]: new Date()
                // }
            }
        });
        if (!isValidOtp) return res.status(400).json({ status: false, message: 'Otp Not Valid' });
        const hashedNewPassword = await bcrypt.hash(confirmPassword, 10);
        let isCanged = await reqUser.update({
            userPassword: hashedNewPassword, userOtp: null, useOtpExpire
                : null
        }, { where: { userOtp: otp } });
        if (isCanged) return res.status(200).json({ status: true, message: 'Password Changed Successfully' });
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
        let user = await reqUser.findOne({ where: { userEmail: email } });

        if (user && user.userStatus !== 'active') {
            return res.status(403).json({
                result: false,
                message: "Unauthorized: Your account is inactive. Please contact administrator."
            });
        }

        if (!user) {
            return res.status(404).json({
                result: false,
                message: "User not found"
            });
        }

        // Generate JWT token (same as regular login flow)
        let userData = {
            userId: user.userId,
            userFullName: user.userFullName,
            userEmail: user.userEmail,
            userDOB: user.userDOB,
            userType: user.userType,
            userRole: user.userRole
        };

        let token = await jwtToken(userData);

        return res.status(200).json({
            result: true,
            message: "Google login successful",
            token,
            data: user
        });
    } catch (err) {
        console.error("Firebase auth error:", err);
        return res.status(401).json({ message: "Unauthorized: Invalid or expired token" });
    }
};
