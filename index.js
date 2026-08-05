require('dotenv').config();

const express = require('express');
const cors = require('cors');
const path = require('path');
const helmet = require('helmet');
const errorHandler = require('./api/middleware/error');
const { loadSecretToEnv } = require('./api/utils/secretManager');

const app = express();

app.use(cors({
  origin: '*',  // Allow all domains
  methods: ['GET', 'POST', 'PUT', 'DELETE','PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization', 'x-api-env']
}));

app.use(express.json());
app.use(helmet());

async function startServer() {
  // Load secrets from AWS Secrets Manager into process.env before anything else
  try {
    await loadSecretToEnv();
  } catch (err) {
    console.warn('[Startup] Could not load secrets from AWS Secrets Manager. Continuing with existing .env values:', err.message);
  }

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/qa_uploads_docs', express.static(path.join(__dirname, '../../../development_hosting/nodejs/qa_uploads_docs')));
  const port = process.env.APP_PORT;

  const sampleData = {
    message: 'Hello, this is a sample API!',
    timestamp: new Date().toISOString(),
  };

  require('./api/utils/gmeetConfiguration');

  app.get('/', (req, res) => {
    res.json(sampleData);
  });

  app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

  app.use('/user', require('./api/routes/users.route'));
  app.use('/candidate', require('./api/routes/candidate.route'));
  app.use('/service-request', require('./api/routes/serviceRequest.route'));
  app.use('/screening-station', require('./api/routes/screeningStation.route'));
  app.use('/written-station', require('./api/routes/writtenStation.route'));
  app.use('/technical-station', require('./api/routes/technicalStation.route'));
  app.use('/technical-station-two', require('./api/routes/technicalStationTwo.route'));
  app.use('/management-station', require('./api/routes/management.route'));
  app.use('/dashboard', require('./api/routes/dashboard.route'));
  app.use('/report', require('./api/routes/report.route'));
  app.use('/hr-station', require('./api/routes/hrStation.route'));

  app.all('*', (req, res) => {
    return res.status(404).json({ result: false, message: `Can't find this ${req.originalUrl} on the server!` });
  });

  app.use(errorHandler);

  app.listen(port, () => {
    console.log(`Server Running on Port ${port}-aws`);
  });
}

startServer();
