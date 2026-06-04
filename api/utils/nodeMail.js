//const nodemailer = require("nodemailer");
//const fs = require("fs").promises;
//let { logFunction } = require('../utils/commonFunction');
exports.sendEmail = async (mailId, subject, message, cc, bcc, attachmentArray, logData = {}) => {
//  try {
//    return true 
//    const transporter = nodemailer.createTransport({
//      // service:'yahoo',
//      host: "smtp.gmail.com",
//      port: 587,
//      auth: {
//        user: "techversant.hr@gmail.com",
//        pass: "cpso rnqo gcol ulud",
//      },
//    });
//    let info = await transporter.sendMail({
//      from: "techversant.hr@gmail.com",
//      to: mailId,
//      cc: cc, //[cc,'jeremiya.s@techversantinfotech.com'],
//      subject: subject,
//      bcc,
//      html: message,
//      attachments: attachmentArray
//    });
//    if (Object.keys(logData)) {
//      logFunction(logData.reciverId, logData.senderId, logData.type, logData.station);
//    }
    return true;
//  } catch (error) {
//    console.error("Error sending email:", error);
//  }
};
