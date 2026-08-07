const { generateFromText } = require("./gemini.service");
const { RESUME_PARSER_PROMPT } = require("../prompts/resume.prompt");

async function parseResume(resumeText) {
  return generateFromText(
    RESUME_PARSER_PROMPT,
    resumeText
  );
}

module.exports = {
  parseResume,
};