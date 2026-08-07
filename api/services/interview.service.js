const { generateFromFile } = require("./gemini.service");
const { generateInterviewPromptBasic } = require("../prompts/interview.prompt");

async function generateInterviewQuestions(filePath, mimeType) {
  return generateFromFile(
    filePath,
    mimeType,
    generateInterviewPromptBasic
  );
}

module.exports = {
  generateInterviewQuestions,
};