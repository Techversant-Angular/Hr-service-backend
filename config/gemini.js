require('dotenv').config();
const { GoogleGenAI } = require('@google/genai');

if (!process.env.GOOGLE_AI_API_KEY) {
  throw new Error('GOOGLE_AI_API_KEY is missing in .env');
}

const ai = new GoogleGenAI({
  apiKey: process.env.GOOGLE_AI_API_KEY,
});

// const GEMINI_MODEL = 'gemini-flash-latest';
const GEMINI_MODEL = 'gemini-3.1-flash-lite';
// const GEMINI_MODEL = 'gemini-3.5-flash';

module.exports = {
  ai,
  GEMINI_MODEL,
};