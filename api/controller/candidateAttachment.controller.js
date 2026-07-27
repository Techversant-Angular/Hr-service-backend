const { reqCandidateAttachment, reqCandidates, reqUser } = require('../../models');
const { tryCatch } = require('../utils/trycatch');
const { ALLOWED_ATTACHMENT_TYPES } = require('../validation/candidateAttachment.validate');
const { jwtVerifyToken } = require('../utils/jwt');

exports.getAttachmentTypes = tryCatch(async (req, res) => {
  return res.status(200).json({
    result: true,
    message: 'Attachment types retrieved successfully',
    data: ALLOWED_ATTACHMENT_TYPES
  });
});

exports.createAttachment = tryCatch(async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ result: false, message: 'File is required' });
  }

  const { candidateId, attachmentType, notes } = req.body;

  // Extract and decode token to get the logged-in user ID
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ result: false, message: 'Authorization header missing' });
  }
  const token = authHeader.split(' ')[1];
  const decoded = await jwtVerifyToken(token);
  const userId = decoded.userId;

  const user = await reqUser.findOne({ where: { userId } });
  if (!user) {
    return res.status(401).json({ result: false, message: 'Unauthorized! User not found' });
  }

  const actionBy = user.userId;

  const candidate = await reqCandidates.findOne({ where: { candidateId } });
  if (!candidate) {
    return res.status(404).json({ result: false, message: 'Candidate not found' });
  }

  const relativePath = `qa_uploads_docs/${req.file.filename}`;
  const protocol = req.headers['x-forwarded-proto'] || req.protocol;
  const host = req.headers['x-forwarded-host'] || req.get('host');
  const fileUrl = `${protocol}://${host}/${relativePath}`;

  const attachment = await reqCandidateAttachment.create({
    candidateId,
    attachmentType,
    fileName: req.file.filename,
    originalFileName: req.file.originalname,
    filePath: req.file.path,
    mimeType: req.file.mimetype,
    fileSize: req.file.size,
    notes: notes || null,
    createdBy: actionBy,
    updatedBy: actionBy,
    status: true
  });

  return res.status(201).json({
    result: true,
    message: 'Candidate attachment uploaded successfully',
    data: {
      ...attachment.toJSON(),
      filePath: relativePath,
      fileUrl: fileUrl,
      creator: {
        userId: user.userId,
        userfirstName: user.userfirstName,
        userlastName: user.userlastName
      }
    }
  });
});

exports.getAttachments = tryCatch(async (req, res) => {
  const { candidateId } = req.query;

  const candidate = await reqCandidates.findOne({ where: { candidateId } });
  if (!candidate) {
    return res.status(404).json({ result: false, message: 'Candidate not found' });
  }

  let attachments = await reqCandidateAttachment.findAll({
    where: { candidateId, status: true },
    include: [
      { 
        model: reqUser, 
        as: 'creator',
        attributes: ['userId', 'userfirstName', 'userlastName'] 
      }
    ],
    order: [['createdAt', 'DESC']]
  });
  

  const protocol = req.headers['x-forwarded-proto'] || req.protocol;
  const host = req.headers['x-forwarded-host'] || req.get('host');

  // Attach dynamically generated URL
  attachments = attachments.map(att => {
    const data = att.toJSON();
    data.filePath = `qa_uploads_docs/${data.fileName}`;
    data.fileUrl = `${protocol}://${host}/${data.filePath}`;
    return data;
  });

  return res.status(200).json({
    result: true,
    message: 'Candidate attachments retrieved successfully',
    data: attachments
  });
});

exports.deleteAttachment = tryCatch(async (req, res) => {
  const { attachmentId } = req.params;

  // Extract and decode token to get the logged-in user ID
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ result: false, message: 'Authorization header missing' });
  }
  const token = authHeader.split(' ')[1];
  const decoded = await jwtVerifyToken(token);
  const userId = decoded.userId;

  const user = await reqUser.findOne({ where: { userId } });
  if (!user) {
    return res.status(401).json({ result: false, message: 'Unauthorized! User not found' });
  }

  const actionBy = user.userId;

  const attachment = await reqCandidateAttachment.findOne({
    where: { id: attachmentId, status: true }
  });

  if (!attachment) {
    return res.status(404).json({ result: false, message: 'Attachment not found or already deleted' });
  }

  await reqCandidateAttachment.update(
    { status: false, updatedBy: actionBy },
    { where: { id: attachmentId } }
  );

  return res.status(200).json({
    result: true,
    message: 'Attachment deleted successfully'
  });
});