const express = require('express');
const router = express.Router();
let controller = require('../controller/user/user.controller');
let authController = require('../controller/user/auth.controller');
let commonController = require('../controller/common.controller');
let { authenticate, verifyAdmin } = require('../middleware/auth');
let { updateUser, changePswd, flows, skipStation } = require('../validation/user.validate');

router.post('/login', authController.login);

router.post('/changePassword', changePswd, authenticate, authController.changePassword);

router.post("/forgotPassword", authController.forgotPassword);

router.post("/resetPassword", authController.resetPassword);

router.post('/create', authenticate, verifyAdmin, controller.createUser);

router.post('/delete', authenticate, verifyAdmin, controller.deleteUser);

router.get('/lists', authenticate, controller.listUsers);

router.put('/update', updateUser, authenticate, verifyAdmin, controller.UpdateUser);

router.get('/stations', authenticate, commonController.stations);

router.get('/reqUsersList/:id', authenticate, controller.reqUsersList);

router.post('/station-switch', skipStation, authenticate, commonController.skipCurrentStation);

router.get('/s3-credential', authenticate, commonController.s3Credential);

router.get('/filter-status', authenticate, commonController.statusFilter);

router.get('/work-modes', authenticate, commonController.workModeList);

router.get('/preffer-location', authenticate, commonController.prefferedList);

router.post('/edit-progress',authenticate,commonController.editProgressV1);


module.exports = router;
