const express = require('express');
const router = express.Router();
let controller = require('../controller/serviceRequest.controller');
let candidateController = require('../controller/candidate.controller.js');
let { createServiceValidation, editeServiceValidation ,activeServiceValidation} = require('../validation/serviceRequest.validate');
let commonController = require('../controller/common.controller.js');
let { authenticate } = require('../middleware/auth');

router.post('/create', createServiceValidation, authenticate, controller.createService);

router.post('/create-jobOpenings', createServiceValidation, controller.createJobOpening);

router.post('/edit', authenticate, controller.editService);

router.post('/activateRequest', authenticate,activeServiceValidation, controller.requestActive);

router.post('/delete', authenticate, controller.deleteService);

router.get('/view', authenticate, controller.viewService);

router.get('/list', authenticate, controller.listServices);

router.get('/exp-year/list', authenticate, controller.yearList);

router.get('/team', authenticate, commonController.teamList);

router.get('/active/list', controller.activeServicesList);

router.get('/services', authenticate, controller.servicesList);

router.get('/designation/list', authenticate, commonController.designationList);

// designation CRUD
router.get('/designation-management/list', authenticate, commonController.designationManagementList)
router.post('/designation/create', authenticate, commonController.createDesignation);
router.put('/designation/update/:designationId', authenticate, commonController.updateDesignation);
router.delete('/designation/delete/:designationId', authenticate, commonController.deleteDesignation);
router.put('/department/status/:teamId', authenticate, commonController.toggleDepartmentStatus
);
// department CRUD
router.get('/department/list', authenticate, commonController.departmentList);
router.post('/department/create', authenticate, commonController.createDepartment);
router.put('/department/update/:teamId', authenticate, commonController.updateDepartment);
router.delete('/department/delete/:teamId', authenticate, commonController.deleteDepartment);
router.put('/designation/status/:designationId', authenticate, commonController.toggleDesignationStatus
);

// used to edit after candidate added to requestion
router.patch('/edit-requestion/:requestionId',  authenticate, controller.partialServiceEdit);

module.exports = router;
