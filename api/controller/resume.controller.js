const { extractResumeText } = require("../utils/resumeParser");
const { parseResume } = require("../services/resumeAI.service");
const { parseResumeText } = require("../services/resumeManualParser.service");
const { analyseResume } = require("../services/atsAnalysis.service");
const { generateInterviewQuestions } = require("../services/interview.service");
const { syncSkills } = require("../services/skillSync.service");
const progressTracker = require("../utils/progressTracker");

/**
 * Parse Resume using AI
 * POST /resume/ai-parse
 */
exports.parseResume = async (req, res) => {
  const uploadId = progressTracker.getOrGenerateUploadId(req);
  progressTracker.initProgress(uploadId, "Upload started");

  try {
    // Check uploaded file
    if (!req.file) {
      progressTracker.updateProgress(uploadId, 0, "error", "Please upload a resume.");
      return res.status(400).json({
        result: false,
        message: "Please upload a resume.",
        uploadId
      });
    }

    progressTracker.updateProgress(uploadId, 30, "uploaded", "Resume uploaded");
    progressTracker.updateProgress(uploadId, 50, "parsing", "Resume parsing");

    // Extract text from resume
    const resumeText = await extractResumeText(req.file.path);

    if (!resumeText || !resumeText.trim()) {
      progressTracker.updateProgress(uploadId, 0, "error", "Unable to extract text from the uploaded resume.");
      return res.status(400).json({
        result: false,
        message: "Unable to extract text from the uploaded resume.",
        uploadId
      });
    }

    // Send to Gemini AI
    const candidateData = await parseResume(resumeText);
    progressTracker.updateProgress(uploadId, 75, "processing", "Candidate data processing");
    await syncSkills(candidateData.skills);

    progressTracker.updateProgress(uploadId, 100, "completed", "Completed", candidateData);

    return res.status(200).json({
      result: true,
      message: "Resume parsed successfully.",
      uploadId,
      data: candidateData,
    });
  } catch (error) {
    console.error("Resume Controller Error:", error);
    progressTracker.updateProgress(uploadId, 0, "error", error.message || "Resume parsing failed.");

    return res.status(500).json({
      result: false,
      message: "Resume parsing failed.",
      uploadId,
      error: error.message,
    });
  }
};

/**
 * Manual Parse Resume using regex/rules
 * POST /resume/manual-parse
 */
exports.uploadResumePdf = async (req, res) => {
  const uploadId = progressTracker.getOrGenerateUploadId(req);
  progressTracker.initProgress(uploadId, "Upload started");

  try {
    if (!req.file) {
      progressTracker.updateProgress(uploadId, 0, "error", "Please upload a resume.");
      return res.status(400).json({
        result: false,
        message: "Please upload a resume.",
        uploadId
      });
    }

    progressTracker.updateProgress(uploadId, 30, "uploaded", "Resume uploaded");
    progressTracker.updateProgress(uploadId, 50, "parsing", "Resume parsing");

    const resumeText = await extractResumeText(req.file.path);

    progressTracker.updateProgress(uploadId, 75, "processing", "Candidate data processing");
    const resumeData = parseResumeText(resumeText, req.file.originalname);

    progressTracker.updateProgress(uploadId, 100, "completed", "Completed", resumeData);

    return res.status(200).json({
      result: true,
      message: "Resume parsed successfully.",
      uploadId,
      data: resumeData,
    });
  } catch (error) {
    console.error("Resume Parser Error:", error);
    progressTracker.updateProgress(uploadId, 0, "error", error.message || "Resume parsing failed.");

    return res.status(500).json({
      result: false,
      message: "Resume parsing failed.",
      uploadId,
      error: error.message,
    });
  }
};

/**
 * ATS Resume Analysis
 * POST /resume/ats-analysis
 */
exports.analyseResume = async (req, res) => {
  const uploadId = progressTracker.getOrGenerateUploadId(req);
  progressTracker.initProgress(uploadId, "Upload started");

  try {
    if (!req.file) {
      progressTracker.updateProgress(uploadId, 0, "error", "Please upload a resume.");
      return res.status(400).json({
        result: false,
        message: "Please upload a resume.",
        uploadId
      });
    }

    progressTracker.updateProgress(uploadId, 30, "uploaded", "Resume uploaded");
    progressTracker.updateProgress(uploadId, 50, "parsing", "Resume parsing");

    const atsResult = await analyseResume(req.file.path, req.file.mimetype);

    progressTracker.updateProgress(uploadId, 75, "processing", "Candidate data processing");
    progressTracker.updateProgress(uploadId, 100, "completed", "Completed", atsResult);

    return res.status(200).json({
      result: true,
      message: "ATS analysis completed successfully.",
      uploadId,
      data: atsResult,
    });
  } catch (err) {
    console.error("ATS Analysis Error:", err);
    progressTracker.updateProgress(uploadId, 0, "error", err.message || "ATS analysis failed.");

    return res.status(500).json({
      result: false,
      message: "ATS analysis failed.",
      uploadId,
      error: err.message,
    });
  }
};

/**
 * Generate Interview Questions from Resume
 * POST /resume/interview-questions
 */
exports.generateInterviewQuestions = async (req, res) => {
  const uploadId = progressTracker.getOrGenerateUploadId(req);
  progressTracker.initProgress(uploadId, "Upload started");

  try {
    if (!req.file) {
      progressTracker.updateProgress(uploadId, 0, "error", "Please upload a resume.");
      return res.status(400).json({
        result: false,
        message: "Please upload a resume.",
        uploadId
      });
    }

    progressTracker.updateProgress(uploadId, 30, "uploaded", "Resume uploaded");
    progressTracker.updateProgress(uploadId, 50, "parsing", "Resume parsing");

    const interviewQuestions = await generateInterviewQuestions(
      req.file.path,
      req.file.mimetype
    );

    progressTracker.updateProgress(uploadId, 75, "processing", "Candidate data processing");
    progressTracker.updateProgress(uploadId, 100, "completed", "Completed", interviewQuestions);

    return res.status(200).json({
      result: true,
      message: "Interview questions generated successfully.",
      uploadId,
      data: interviewQuestions,
    });

  } catch (err) {
    console.error("Interview Generation Error:", err);
    progressTracker.updateProgress(uploadId, 0, "error", err.message || "Failed to generate interview questions.");

    return res.status(500).json({
      result: false,
      message: "Failed to generate interview questions.",
      uploadId,
      error: err.message,
    });
  }
};
