const { extractResumeText } = require("../utils/resumeParser");
const { parseResume } = require("../services/resumeAI.service");
const { parseResumeText } = require("../services/resumeManualParser.service");
const { analyseResume } = require("../services/atsAnalysis.service");
const { generateInterviewQuestions } = require("../services/interview.service");
const { syncSkills } = require("../services/skillSync.service");


/**
 * Parse Resume using AI
 * POST /resume/parse
 */
exports.parseResume = async (req, res) => {
  try {
    // Check uploaded file
    if (!req.file) {
      return res.status(400).json({
        result: false,
        message: "Please upload a resume.",
      });
    }

    // Extract text from resume
    const resumeText = await extractResumeText(req.file.path);

    if (!resumeText || !resumeText.trim()) {
      return res.status(400).json({
        result: false,
        message: "Unable to extract text from the uploaded resume.",
      });
    }

    // Send to Gemini
    const candidateData = await parseResume(resumeText);
    await syncSkills(candidateData.skills);

    return res.status(200).json({
      result: true,
      message: "Resume parsed successfully.",
      data: candidateData,
    });
  } catch (error) {
    console.error("Resume Controller Error:", error);

    return res.status(500).json({
      result: false,
      message: "Resume parsing failed.",
      error: error.message,
    });
  }
};

exports.uploadResumePdf = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        result: false,
        message: "Please upload a resume.",
      });
    }

    const resumeText = await extractResumeText(req.file.path);

    const resumeData = parseResumeText(resumeText, req.file.originalname);

    return res.status(200).json({
      result: true,
      message: "Resume parsed successfully.",
      data: resumeData,
    });
  } catch (error) {
    console.error("Resume Parser Error:", error);

    return res.status(500).json({
      result: false,
      message: "Resume parsing failed.",
      error: error.message,
    });
  }
};

exports.analyseResume = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        result: false,
        message: "Please upload a resume.",
      });
    }

    const atsResult = await analyseResume(req.file.path, req.file.mimetype);

    return res.status(200).json({
      result: true,
      message: "ATS analysis completed successfully.",
      data: atsResult,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      result: false,
      message: "ATS analysis failed.",
      error: err.message,
    });
  }
};

exports.generateInterviewQuestions = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        result: false,
        message: "Please upload a resume.",
      });
    }

    const interviewQuestions = await generateInterviewQuestions(
      req.file.path,
      req.file.mimetype
    );

    return res.status(200).json({
      result: true,
      message: "Interview questions generated successfully.",
      data: interviewQuestions,
    });

  } catch (err) {
    console.error("Interview Generation Error:", err);

    return res.status(500).json({
      result: false,
      message: "Failed to generate interview questions.",
      error: err.message,
    });
  }
};
