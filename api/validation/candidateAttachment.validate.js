const { body, query, param } = require("express-validator");
const validateRequest = require("../utils/validationHelper");

const ALLOWED_ATTACHMENT_TYPES = [
  { id: 1, name: "CV", status: true },
  { id: 2, name: "PAN Card", status: true },
  { id: 3, name: "Aadhar", status: true },
  { id: 4, name: "Driving Licence", status: true },
  { id: 5, name: "Passport", status: true },
  { id: 6, name: "Experience Certificates", status: true },
  { id: 7, name: "Payslips", status: true },
  { id: 8, name: "Form 16", status: true },
  { id: 9, name: "Relieving Letter", status: true },
  { id: 10, name: "Others", status: true },
];

exports.ALLOWED_ATTACHMENT_TYPES = ALLOWED_ATTACHMENT_TYPES;

exports.createAttachmentValidate = [
  body("candidateId")
    .notEmpty()
    .withMessage("Candidate ID is required")
    .isInt({ gt: 0 })
    .withMessage("Candidate ID must be a positive integer"),

  body("attachmentTypeId")
    .notEmpty()
    .withMessage("Attachment type is required")
    .isInt({ gt: 0 })
    .withMessage("Attachment type must be a valid ID")
    .custom((value) => {
      const exists = ALLOWED_ATTACHMENT_TYPES.some(
        (type) => type.id === Number(value),
      );

      if (!exists) {
        throw new Error("Invalid attachment type");
      }

      return true;
    }),

  body("notes")
    .optional({ nullable: true })
    .isString()
    .withMessage("Notes must be text"),

  body("uploadedBy")
    .optional({ nullable: true })
    .isInt({ gt: 0 })
    .withMessage("uploadedBy must be a valid User ID"),

  validateRequest,
];

exports.listAttachmentsValidate = [
  query("candidateId")
    .notEmpty()
    .withMessage("Candidate ID is required in query params")
    .isInt({ gt: 0 })
    .withMessage("Candidate ID must be a positive integer"),

  validateRequest,
];

exports.deleteAttachmentValidate = [
  param("attachmentId")
    .notEmpty()
    .withMessage("Attachment ID parameter is required")
    .isInt({ gt: 0 })
    .withMessage("Attachment ID must be a positive integer"),

  body("updatedBy")
    .optional({ nullable: true })
    .isInt({ gt: 0 })
    .withMessage("updatedBy must be a valid User ID"),

  validateRequest,
];
