const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { format } = require('date-fns');

// Shared upload directory
const uploadDir = path.resolve(__dirname, '../../../../../development_hosting/nodejs/qa_uploads_docs');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const timestamp = format(new Date(), 'yyyy_MM_dd_HH_mm_ss');
    const ext = path.extname(file.originalname);
    const baseName = path.basename(file.originalname, ext).replace(/\s+/g, '_');
    cb(null, `${baseName}_${timestamp}${ext}`);
  }
});

const attachmentFileFilter = (req, file, cb) => {
  const allowedTypes = ['.pdf', '.doc', '.docx', '.jpg', '.jpeg', '.png', '.xls', '.xlsx', '.csv'];
  const ext = path.extname(file.originalname).toLowerCase();
  
  if (allowedTypes.includes(ext)) {
    cb(null, true);
  } else {
    cb(new Error(`Invalid file type. Allowed: ${allowedTypes.join(', ')}`), false);
  }
};

const uploadAttachment = multer({
  storage,
  fileFilter: attachmentFileFilter,
  limits: { fileSize: 5 * 1024 * 1024 } // 5 MB
});

module.exports = uploadAttachment;