const express = require('express');
const router = express.Router();
let controller = require('../controller/technicalStationtwo.controller');
let { approve } = require('../validation/technicalStation.validate');
let { authenticate } = require('../middleware/auth');

router.get('/list', authenticate, controller.list);

router.post('/add-progress', authenticate, controller.addProgress);

router.post('/add-progress/v1', authenticate, controller.addProgressV1);

router.post('/approve', approve, authenticate, controller.approve);

router.get('/progressDetail', authenticate, controller.progressDetail);

module.exports = router;
