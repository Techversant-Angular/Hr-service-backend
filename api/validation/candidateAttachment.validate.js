const { body, query, param } = require('express-validator');
const validateRequest = require('../utils/validationHelper'); // Your custom error formatting helper

const ALLOWED_ATTACHMENT_TYPES = [
  'CV', 
  'PAN Card', 
  'Aadhar', 
  'Driving Licence', 
  'Passport', 
  'Experience Certificates', 
  'Payslips', 
  'Form 16', 
  'Relieving Letter', 
  'Others'
];

exports.ALLOWED_ATTACHMENT_TYPES = ALLOWED_ATTACHMENT_TYPES;

exports.createAttachmentValidate = [
  body('candidateId')
    .notEmpty().withMessage('Candidate ID is required')
    .isInt({ gt: 0 }).withMessage('Candidate ID must be a positive integer'),
  body('attachmentType')
    .notEmpty().withMessage('Attachment type is required')
    .isIn(ALLOWED_ATTACHMENT_TYPES).withMessage(`Allowed types: ${ALLOWED_ATTACHMENT_TYPES.join(', ')}`),
  body('notes')
    .optional({ nullable: true })
    .isString().withMessage('Notes must be text'),
  body('uploadedBy')
    .optional({ nullable: true })
    .isInt({ gt: 0 }).withMessage('uploadedBy must be a valid User ID'),
  validateRequest
];

exports.listAttachmentsValidate = [
  query('candidateId')
    .notEmpty().withMessage('Candidate ID is required in query params')
    .isInt({ gt: 0 }).withMessage('Candidate ID must be a positive integer'),
  validateRequest
];

exports.deleteAttachmentValidate = [
  param('attachmentId')
    .notEmpty().withMessage('Attachment ID parameter is required')
    .isInt({ gt: 0 }).withMessage('Attachment ID must be a positive integer'),
  body('updatedBy')
    .optional({ nullable: true })
    .isInt({ gt: 0 }).withMessage('updatedBy must be a valid User ID'),
  validateRequest
];