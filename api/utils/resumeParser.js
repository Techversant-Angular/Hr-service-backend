const fs = require("fs");
const path = require("path");
const mammoth = require("mammoth");
const { PDFParse, VerbosityLevel } = require("pdf-parse");

const extractResumeText = async (filePath) => {
  if (!filePath) {
    throw new Error("Resume file path is required.");
  }

  if (!fs.existsSync(filePath)) {
    throw new Error("Resume file not found.");
  }

  const extension = path.extname(filePath).toLowerCase();

  let extractedText = "";

  switch (extension) {
    case ".pdf": {
      const fileBuffer = fs.readFileSync(filePath);

      const parser = new PDFParse({
        verbosity: VerbosityLevel.ERRORS,
        data: fileBuffer,
      });

      const pdfData = await parser.getText();

      extractedText = pdfData.text;
      break;
    }

    case ".doc":
    case ".docx": {
      const result = await mammoth.extractRawText({
        path: filePath,
      });

      extractedText = result.value;
      break;
    }

    default:
      throw new Error("Unsupported resume format.");
  }

  return normalizeResumeText(extractedText);
};

const normalizeResumeText = (text = "") => {
  return text
    .replace(/\r\n/g, "\n")
    .replace(/\r/g, "\n")
    .replace(/\t/g, " ")
    .replace(/[ ]{2,}/g, " ")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
};

module.exports = {
  extractResumeText,
};