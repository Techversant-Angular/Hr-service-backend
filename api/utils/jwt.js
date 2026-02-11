const dotenv = (require("dotenv").config()).parsed
// const jwt = require('jwt-simple');
const jwt = require("jsonwebtoken");

let secret = 'xxx';

exports.jwtToken = async (userObj) => {
    const token = jwt.sign(userObj, dotenv.TOKEN_SECRET);
    return token;
}

exports.jwtVerifyToken = async (token) => {
    const verified = jwt.verify(token, dotenv.TOKEN_SECRET);
    return verified;
}