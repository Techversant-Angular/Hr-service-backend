const { generateFromFile } = require("./gemini.service");
const { ResumeAnalyserPrompt } = require("../prompts/resume.prompt");

async function analyseResume(filePath, mimeType) {
  return generateFromFile(
    filePath,
    mimeType,
    ResumeAnalyserPrompt
  );
}

module.exports = {
  analyseResume,
};