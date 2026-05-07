const multer = require('multer');
const path = require('path');
const fs = require('fs');
const moment = require('moment');

// Ensure the uploads/resumes directory exists
const uploadDir = path.resolve(__dirname, '../../../qa_uploads_docs');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// Configure multer storage
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const timestamp = moment().format('YYYY_MM_DD_HH_mm_ss');
    const ext = path.extname(file.originalname);
    const baseName = path.basename(file.originalname, ext).replace(/\s+/g, '_');
    cb(null, `${baseName}_${timestamp}${ext}`);
  }
});

// File filter to allow only .pdf, .doc, .docx
const fileFilter = (req, file, cb) => {
  const allowedTypes = ['.pdf', '.doc', '.docx'];
  const ext = path.extname(file.originalname).toLowerCase();
  if (allowedTypes.includes(ext)) {
    cb(null, true);
  } else {
    cb(new Error('Invalid file type. Only .pdf, .doc, .docx files are allowed.'), false);
  }
};

const uploadResume = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024 // Max 5MB
  }
});

module.exports = uploadResume;
