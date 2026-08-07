const fs = require("fs");
const { ai, GEMINI_MODEL } = require("../../config/gemini");

/**
 * Generate AI response from resume file
 */
async function generateFromFile(filePath, mimeType, prompt) {
  const fileBuffer = fs.readFileSync(filePath);
  const base64Data = fileBuffer.toString("base64");

  const response = await ai.models.generateContent({
    model: GEMINI_MODEL,
    contents: [
      {
        role: "user",
        parts: [
          {
            text: prompt,
          },
          {
            inlineData: {
              mimeType,
              data: base64Data,
            },
          },
        ],
      },
    ],
  });

  const rawText = response.text
    ?.replace(/```json/g, "")
    .replace(/```/g, "")
    .trim();

  if (!rawText) {
    throw new Error("AI returned an empty response.");
  }

  return JSON.parse(rawText);
}

/**
 * Generate AI response from plain text
 */
async function generateFromText(prompt, text) {
  const response = await ai.models.generateContent({
    model: GEMINI_MODEL,
    contents: [
      {
        role: "user",
        parts: [
          {
            text: `${prompt}\n\n${text}`,
          },
        ],
      },
    ],
  });

  const rawText = response.text
    ?.replace(/```json/g, "")
    .replace(/```/g, "")
    .trim();

  if (!rawText) {
    throw new Error("AI returned an empty response.");
  }

  return JSON.parse(rawText);
}

module.exports = {
  generateFromFile,
  generateFromText,
};