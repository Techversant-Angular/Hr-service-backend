const express = require('express');
const router = express.Router();
let controller = require('../controller/writtenStation.controller');
let { approve } = require('../validation/writtenStation.validate');
let { authenticate } = require('../middleware/auth');

router.get('/list', authenticate, controller.list);

router.post('/add-progress', authenticate, controller.addProgress);

router.post('/add-progress/v1', authenticate, controller.addProgressV1);

router.post('/approve', approve, authenticate, controller.approve);

router.get('/progressDetail', authenticate, controller.progressDetail);

router.put('/update-progress/v1/:progressServiceId', authenticate, controller.updateProgressV1);

module.exports = router;
