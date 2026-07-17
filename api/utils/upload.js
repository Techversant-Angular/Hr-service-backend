const express = require('express');
const router = express.Router();

const candidateController = require('../controller/candidate.controller');
const commonController = require('../controller/common.controller');
const uploadResume = require('../middleware/uploadResume');

exports.routerInterceptor = async (req, res, next) => {
  if (req.headers['x-api-env'] === 'live') {
    return commonController.generatePresignedUrl(req, res, next);
  } else {
    uploadResume.single("candidateResume")(req, res, (err) => {
      if (err) {
        return res.status(400).json({
          result: false,
          message: err.message,
        });
      }

      return candidateController.uploadResume(req, res);
    });
  }
};