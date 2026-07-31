const {
  reqCandidateAttachment,
  reqCandidates,
  reqUser,
} = require("../../models");
const { tryCatch } = require("../utils/trycatch");
const {
  ALLOWED_ATTACHMENT_TYPES,
} = require("../validation/candidateAttachment.validate");
const { jwtVerifyToken } = require("../utils/jwt");

exports.getAttachmentTypes = tryCatch(async (req, res) => {
  return res.status(200).json({
    result: true,
    message: "Attachment types retrieved successfully",
    data: ALLOWED_ATTACHMENT_TYPES,
  });
});

exports.createAttachment = tryCatch(async (req, res) => {
  const {
    candidateId,
    attachmentTypeId,
    notes,
    fileName,
    originalFileName,
    mimeType,
    fileSize,
    filePath,
    fileUrl,
  } = req.body;
  const attachmentTypeObj = ALLOWED_ATTACHMENT_TYPES.find(
    (item) => item.id === Number(attachmentTypeId)
  );
  if (!attachmentTypeObj) {
    return res.status(400).json({
      result: false,
      message: "Invalid attachment type",
    });
  }
  const attachmentType = attachmentTypeObj.name;
  if (!fileName || !originalFileName) {
    return res.status(400).json({
      result: false,
      message: "File details (fileName, originalFileName) are required",
    });
  }

  const fileData = {
    fileName,
    originalFileName,
    filePath: filePath || fileName,
    mimeType: mimeType || "application/octet-stream",
    fileSize: fileSize || 0,
  };

  // Extract logged-in user
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({
      result: false,
      message: "Authorization header missing",
    });
  }

  const token = authHeader.split(" ")[1];
  const decoded = await jwtVerifyToken(token);

  const user = await reqUser.findOne({
    where: { userId: decoded.userId },
  });

  if (!user) {
    return res.status(401).json({
      result: false,
      message: "Unauthorized! User not found",
    });
  }

  const candidate = await reqCandidates.findOne({
    where: { candidateId },
  });

  if (!candidate) {
    return res.status(404).json({
      result: false,
      message: "Candidate not found",
    });
  }

  const actionBy = user.userId;

  const responseFilePath = filePath || fileData.filePath;
  const responseFileUrl = fileUrl || responseFilePath;

  const attachment = await reqCandidateAttachment.create({
    candidateId,
    attachmentType,
    fileName: fileData.fileName,
    originalFileName: fileData.originalFileName,
    filePath: responseFilePath,
    mimeType: fileData.mimeType,
    fileSize: fileData.fileSize,
    notes: notes || null,
    createdBy: actionBy,
    updatedBy: actionBy,
    status: true,
  });

  return res.status(201).json({
    result: true,
    message: "Candidate attachment uploaded successfully",
    data: {
      id: attachment.id,
      candidateId: attachment.candidateId,
      attachmentType: attachment.attachmentType,
      fileName: attachment.fileName,
      filePath: attachment.filePath,
      notes: attachment.notes,
      status: attachment.status,
      creator: {
        userId: user.userId,
        userfirstName: user.userfirstName,
        userlastName: user.userlastName,
      },
    },
  });
});

exports.getAttachments = tryCatch(async (req, res) => {
  const { candidateId } = req.query;

  const candidate = await reqCandidates.findOne({ where: { candidateId } });
  if (!candidate) {
    return res
      .status(404)
      .json({ result: false, message: "Candidate not found" });
  }

  let attachments = await reqCandidateAttachment.findAll({
    where: { candidateId, status: true },
    attributes: {
      exclude: [
        "originalFileName",
        "fileSize",
        "createdBy",
        "updatedBy",
        "createdAt",
        // "updatedAt",
        // 'filePath'
      ],
    },
    include: [
      {
        model: reqUser,
        as: "creator",
        attributes: ["userId", "userfirstName", "userlastName"],
      },
    ],
    order: [["createdAt", "DESC"]],
  });

  return res.status(200).json({
    result: true,
    message: "Candidate attachments retrieved successfully",
    data: attachments,
  });
});

exports.deleteAttachment = tryCatch(async (req, res) => {
  const { attachmentId } = req.params;

  // Extract and decode token to get the logged-in user ID
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res
      .status(401)
      .json({ result: false, message: "Authorization header missing" });
  }
  const token = authHeader.split(" ")[1];
  const decoded = await jwtVerifyToken(token);
  const userId = decoded.userId;

  const user = await reqUser.findOne({ where: { userId } });
  if (!user) {
    return res
      .status(401)
      .json({ result: false, message: "Unauthorized! User not found" });
  }

  const actionBy = user.userId;

  const attachment = await reqCandidateAttachment.findOne({
    where: { id: attachmentId, status: true },
  });

  if (!attachment) {
    return res.status(404).json({
      result: false,
      message: "Attachment not found or already deleted",
    });
  }

  await reqCandidateAttachment.update(
    { status: false, updatedBy: actionBy },
    { where: { id: attachmentId } },
  );

  return res.status(200).json({
    result: true,
    message: "Attachment deleted successfully",
  });
});
