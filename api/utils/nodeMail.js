const nodemailer = require('nodemailer');

const getTransporter = () => {
  const { SMTP_HOST, SMTP_PORT, SMTP_SECURE, SMTP_USER, SMTP_PASSWORD } = process.env;

  if (!SMTP_HOST || !SMTP_USER || !SMTP_PASSWORD) {
    throw new Error('Email is not configured. Set SMTP_HOST, SMTP_USER, and SMTP_PASSWORD.');
  }
  console.log("EMAIL:", process.env.SMTP_USER);
  console.log("PASSWORD:", process.env.SMTP_PASSWORD);
  return nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT),
    secure: process.env.SMTP_SECURE === "true",
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASSWORD,
    },
  });
};

exports.sendEmail = async (mailId, subject, message, cc, bcc, attachmentArray, logData = {}) => {
  return 0;
  const transporter = getTransporter();
  return transporter.sendMail({
    from: process.env.MAIL_FROM || process.env.SMTP_USER,
    to: mailId,
    cc: cc || undefined,
    bcc: bcc || undefined,
    subject,
    html: message,
    attachments: attachmentArray || [],
  });
};
