const { format } = require("date-fns");
const { Op } = require("sequelize");
const { tryCatch } = require("../utils/trycatch");
const response = require("../../api/utils/responseMessages");

const {
  reqServiceRequest,
  reqCandidates,
  reqStation,
  reqServiceFlow,
  reqTeam,
  sequelize,
  reqUser,
  reqServices,
  Sequelize,
  reqDesignation,
  reqJobOpening,
  reqServiceRequestsJobOpenings
} = require("../../models");

exports.createService = tryCatch(async (req, res) => {
  const toDate = format(new Date(), "yyyy-MM-dd");
  const requestSkills = Array.isArray(req.body.requestSkills)
    ? req.body.requestSkills.join(",")
    : req.body.requestSkills || "";

  const transformedObject = {
    ...req.body,
    requestSkills,
  };
  console.log(req.userRole, "req.userRole");
  if (req.userRole != "manager" && req.userRole != "admin" &&req.userType!='admin')
    return res
      .status(401)
      .json({
        result: false,
        message: "Only manager or Admin can create requstion",
      });

  const requestFlowStations = req.body.requestFlowStations;
  const requestDesignation = req.body.requestDesignation;
  let service;
  let responseMessage = "";
  const team = await reqTeam.findOne({
    where: { teamId: transformedObject.requestTeam },
    raw: true,
  });
  const serviceRequestName = transformedObject.requestName;
  transformedObject.requestName = serviceRequestName;
  const esistingServiceRequest = await reqServiceRequest.findOne({
    where: { requestName: transformedObject.requestName },
  });
  //create designtion  if string
  if (/^\d+$/.test(requestDesignation) == false) {
    const designation = await reqDesignation.create({
      designationName: requestDesignation,
    });
    transformedObject.requestDesignation = designation.designationId;
  }
  //keep entry in service table
  const esistingService = await reqServices.findOne({
    where: { sericeName: transformedObject.requestName },
  });
  let serviceId = null;
  if (esistingService) {
    const [servicedata, metaData] = await sequelize.query(
      `UPDATE "reqServices" SET "sericeName"=:sericeName 
                WHERE "sericeName"=:sericeName RETURNING "sericeId"`,
      {
        replacements: {
          sericeName: esistingService.sericeName,
        },
      }
    );
    serviceId = servicedata[0]?.sericeId;
  } else {
    serviceId = await reqServices.create({
      sericeName: transformedObject.requestName,
    });
    serviceId = serviceId.sericeId;
  }
  transformedObject.requestServiceId = serviceId;
  if (esistingServiceRequest) {
    service = await esistingServiceRequest.update(transformedObject);
    responseMessage = "Service Request Updated Successfully";
  } else {
    service = await reqServiceRequest.create(transformedObject);
    responseMessage = "Service Request Created Successfully";
  }
  const flowObject = {
    flowServiceId: serviceId,
    flowStations: requestFlowStations,
  };
  await scheduleStations(flowObject);
  if (service)
    return res.status(200).json({
      status: true,
      message: responseMessage,
      data: service,
    });
  throw new Error("Something went wrong while creating service request");
});

exports.createJobOpening = tryCatch(async (req, res) => {
  const toDate = format(new Date(), "yyyy-MM-dd");
  const requestSkills = Array.isArray(req.body.requestSkills)
    ? req.body.requestSkills.join(",")
    : req.body.requestSkills || "";

  const transformedObject = {
    ...req.body,
    requestSkills,
  };
  // console.log(req.userRole, "req.userRole");
  // if (req.userRole != "manager" && req.userRole != "admin" &&req.userType!='admin')
  //   return res
  //     .status(401)
  //     .json({
  //       result: false,
  //       message: "Only manager or Admin can create requstion",
  //     });

  // const requestFlowStations = req.body.requestFlowStations;
  // const requestDesignation = req.body.requestDesignation;
  let service;
  let responseMessage = "";

  // const team = await reqTeam.findOne({
  //   where: { teamId: transformedObject.requestTeam },
  //   raw: true,
  // });

  const serviceRequestName = transformedObject.requestName;
  transformedObject.requestName = serviceRequestName;
  const existingServiceRequest = await reqJobOpening.findOne({
    where: { requestName: transformedObject.requestName },
  });
  //create designtion  if string
  // if (/^\d+$/.test(requestDesignation) == false) {
  //   const designation = await reqDesignation.create({
  //     designationName: requestDesignation,
  //   });
  //   transformedObject.requestDesignation = designation.designationId;
  // }
  //keep entry in service table
  const existingService = await reqServices.findOne({
    where: { sericeName: transformedObject.requestName },
  });
  let serviceId = null;
  // if (existingService) {
  //   const [servicedata, metaData] = await sequelize.query(
  //     `UPDATE "reqServices" SET "sericeName"=:sericeName 
  //               WHERE "sericeName"=:sericeName RETURNING "sericeId"`,
  //     {
  //       replacements: {
  //         sericeName: existingService.sericeName,
  //       },
  //     }
  //   );
  //   serviceId = servicedata[0]?.sericeId;
  // } else {
  //   serviceId = await reqServices.create({
  //     sericeName: transformedObject.requestName,
  //   });
  //   serviceId = serviceId.sericeId;
  // }
  transformedObject.requestServiceId = serviceId;
  if (existingServiceRequest) {
    service = await existingServiceRequest.update(transformedObject);
    responseMessage = "Service Request Updated Successfully";
  } else {
    service = await reqJobOpening.create(transformedObject);
    responseMessage = "Service Request Created Successfully";
  }
  // const flowObject = {
  //   flowServiceId: serviceId,
  //   flowStations: requestFlowStations,
  // };
  // await scheduleStations(flowObject);
  if (service)
    return res.status(200).json({
      status: true,
      message: responseMessage,
      data: service,
    });
  throw new Error("Something went wrong while creating service request");
});

exports.listServices = tryCatch(async (req, res) => {
  let search = req.query.search;
  // const toDate = new Date();
  // const fromDate = new Date();
  // fromDate.setMonth(fromDate.getMonth() - 3);
  let where = {
    requestStatus: {
        [Op.in]: ["active"]
    },
    // requestDate: {
    //     [Op.between]: [fromDate, toDate],
    //   },
};
  if (search)
    where = {
      [Op.or]: [
        { requestName: { [Op.iLike]: `${search}%` } },
        // { requestCode: { [Op.iLike]: `${search}%` } },
      ],
    };
  let services = await reqServiceRequest.findAll({
    where,
    include: [{ model: reqTeam, as: "team" }],
    raw: true,
    order: [["requestId", "DESC"]],
  });
  if (services.length > 0) {
    services = services.map((service) => ({
      ...service,
      requestSalaryType:
        service.requestSalaryType === 1
          ? "month"
          : service.requestSalaryType === 2
          ? "year"
          : service.requestSalaryType,
    }));
    return res.status(200).json({
      status: true,
      message: "Service Request Retrived",
      data: services,
    });
  }
  return res
    .status(401)
    .json({ result: false, message: response.DATA_NOT_FOUND, data: services });
});

exports.yearList = tryCatch(async (req, res) => {
  const yearData = await reqCandidates.findAll({
    attributes: [
      [
        sequelize.fn("DISTINCT", sequelize.col("candidateExperience")),
        "candidateExperience",
      ],
    ],
    raw: true,
  });
  return res
    .status(200)
    .json({ status: true, message: response.DATA_RETRIEVED, data: yearData });
});

exports.servicesList = tryCatch(async (req, res) => {
  const services = await reqServices.findAll({
    attributes: [
      [Sequelize.fn("DISTINCT", Sequelize.col("sericeName")), "sericeName"],
      "sericeId",
    ],
    raw: true,
    order: [["sericeId", "ASC"]],
  });
  if (services.length > 0)
    return res
      .status(200)
      .json({ result: true, message: response.DATA_FOUND, data: services });
  return res.status(401).json({ result: false, message: response.DATA_NOT_FOUND });
});

async function scheduleStations(flowObject) {
  try {
    const { flowServiceId, flowStations } = flowObject;
    console.log(flowStations, "stationsssss");
    const flowWithRequest = await reqServiceFlow.findOne({
      where: {
        flowServiceId: flowServiceId,
      },
      raw: true,
    });
    if (flowWithRequest) {
      await reqServiceFlow.destroy({
        where: { flowServiceId: flowServiceId },
      });
    }
    const stations = await reqStation.findAll({
      where: {
        stationId: { [Op.in]: flowStations },
      },
      raw: true,
      order: [["stationId", "ASC"]],
    });
    const serviceFlows = stations.map((el) => {
      return {
        flowServiceId,
        flowStationId: el.stationId,
        flowStationName: el.stationName,
      };
    });
    console.log(serviceFlows);
    await reqServiceFlow.bulkCreate(serviceFlows);
  } catch (error) {
    console.log(error);
  }
}

exports.editService = tryCatch(async (req, res) => {
  const requestId = req.body.requestId;
  if (!requestId)
    return res
      .status(400)
      .json({ result: false, message: "request  id mandatory" });
  const selectQuery = `SELECT DISTINCT("requestId"),(SELECT COUNT(*) FROM "reqServiceSequences" INNER JOIN "reqCandidates" ON "candidateId"="reqServiceSequences"."serviceCandidate" WHERE "reqServiceSequences"."serviceServiceRequst"= ?) AS "candidateCount"
        FROM "reqServiceRequests" as "service" INNER JOIN "reqTeams" ON "service"."requestTeam" = "teamId"
            WHERE "service"."requestId"=?`;
  const [data, metadata] = await sequelize.query(selectQuery, {
    replacements: [requestId, requestId],
  });
  if (!data.length)
    return res
      .status(404)
      .send({ result: false, message: "request id not found" });
  if (data[0].candidateCount != 0)
    return res.status(404).send({
      result: false,
      message: "Not able to delete this requirement, because candidates added",
    });

  const toDate = format(new Date(), "yyyy-MM-dd");
  const transformedObject = {
    ...req.body,
    requestSkills: req.body.requestSkills.join(","),
  };
  const requestFlowStations = req.body.requestFlowStations;
  const requestDesignation = req.body.requestDesignation;
  let service;

  const serviceRequestName = transformedObject.requestName; // + "-" + team.teamName + "-" + toDate;
  transformedObject.requestName = serviceRequestName;
  const esistingServiceRequest = await reqServiceRequest.findOne({
    where: { requestId },
  });

  //keep entry in service table
  const esistingService = await reqServices.findOne({
    where: { sericeId: esistingServiceRequest.requestServiceId },
  });
  const [servicedata, metaData] = await sequelize.query(
    `UPDATE "reqServices" SET "sericeName"=:sericeName 
            WHERE "sericeName"=:sericeName RETURNING "sericeId"`,
    {
      replacements: {
        sericeName: esistingService.sericeName,
      },
    }
  );
  if (typeof requestDesignation === "string") {
    const designation = await reqDesignation.create({
      designationName: requestDesignation,
    });
    transformedObject.requestDesignation = designation.designationId;
  }
  const serviceId = servicedata[0]?.sericeId;
  transformedObject.requestServiceId = serviceId;
  service = await esistingServiceRequest.update(transformedObject);
  const flowObject = {
    flowServiceId: serviceId,
    flowStations: requestFlowStations,
  };
  await scheduleStations(flowObject);
  if (service)
    return res.status(200).json({
      status: true,
      message: "Service Request Updated Successfully",
      data: service,
    });
});

exports.deleteService = tryCatch(async (req, res) => {
  const requestId = req.body.requestId;
  if (!requestId)
    return res
      .status(400)
      .json({ result: false, message: "request  id mandatory" });
  const selectQuery = `SELECT DISTINCT("requestId"),"requestServiceId",(SELECT COUNT(*) FROM "reqServiceSequences" INNER JOIN "reqCandidates" ON "candidateId"="reqServiceSequences"."serviceCandidate" WHERE "reqServiceSequences"."serviceServiceRequst"= ?) AS "candidateCount"
        FROM "reqServiceRequests" as "service" INNER JOIN "reqTeams" ON "service"."requestTeam" = "teamId"
            WHERE "service"."requestId"=?`;

  const [data, metadata] = await sequelize.query(selectQuery, {
    replacements: [requestId, requestId],
  });
  if (!data.length)
    return res
      .status(404)
      .send({ result: false, message: "request id not found" });
  if (data[0].candidateCount != 0)
    return res.status(404).send({
      result: false,
      message: "Not able to delete this requirement, because candidates added",
    });

  await reqServiceFlow.destroy({
    where: { flowServiceId: data[0].requestServiceId },
  });
  const deletedService = await reqServiceRequest.destroy({
    where: { requestId },
  });

  if (deletedService) {
    await reqServices.destroy({
      where: { sericeId: data[0].requestServiceId },
    });
    return res
      .status(200)
      .json({ result: true, message: "Service request deleted" });
  }
  throw new Error("Something went wrong while deleting service request");
});

exports.viewService = tryCatch(async (req, res) => {
  const requestId = req.query.requestId;
  const validRequest = await reqServiceRequest.findOne({
    include: [
      {
        model: reqTeam,
        as: "team",
      },
      {
        model: reqUser,
        as: "reporting",
        attributes: {
          exclude: [
            "updatedAt",
            "createdAt",
            "userStatus",
            "userType",
            "userRole",
            "userWorkStation",
            "userPassword",
            "userDOB",
            "userEmail",
          ],
        },
      },
    ],
    where: { requestId },
    attributes: {
      include: [
        [
          Sequelize.literal(`(
                SELECT "designationName"
                FROM "reqDesignations"
                WHERE "reqDesignations"."designationId" = "reqServiceRequest"."requestDesignation"
              )`),
          "designationName",
        ],
        [
          Sequelize.literal(`(SELECT COUNT("candidateId") FROM "reqCandidates" 
          INNER JOIN "reqServiceSequences" ON "serviceCandidate"="candidateId" 
          WHERE "serviceServiceRequst"="requestId" AND ("serviceStation"='1' OR "serviceStation" IS NULL))`),
          "candidatesCount",
        ],
        [
          Sequelize.literal(`(
                SELECT CONCAT("userfirstName", ' ' ,"userlastName")
                FROM "reqUsers"
                WHERE "reqUsers"."userId" = "reqServiceRequest"."requestAssignTo"
              )`),
          "assignTo",
        ],
      ],
    },
  });
  const requestServiceId = validRequest.requestServiceId;
  const flows = await reqServiceFlow.findAll({
    where: { flowServiceId: requestServiceId },
  });
  if (!validRequest)
    return res
      .status(404)
      .send({ result: false, message: "request id not found" });
  return res.status(200).json({
    result: true,
    message: response.DATA_RETRIEVED,
    data: validRequest,
    flows,
  });
});


function parseDateString(dateStr) {
  if (!dateStr) return null;
  if (dateStr instanceof Date) return isNaN(dateStr.getTime()) ? null : dateStr;

  const str = String(dateStr).trim();

  // Try ISO format or standard Date parsing first (e.g., "2025-05-21" or "2025-05-21T00:00:00.000Z")
  if (/^\d{4}-\d{2}-\d{2}/.test(str)) {
    const d = new Date(str);
    if (!isNaN(d.getTime())) return d;
  }

  // Handle slash-delimited formats: MM/dd/yyyy or dd/MM/yyyy
  if (str.includes('/')) {
    const parts = str.split('/');
    if (parts.length === 3) {
      const a = parseInt(parts[0], 10);
      const b = parseInt(parts[1], 10);
      const year = parseInt(parts[2], 10);

      if (!isNaN(a) && !isNaN(b) && !isNaN(year)) {
        // Try MM/dd/yyyy first (frontend sends this format)
        if (a >= 1 && a <= 12 && b >= 1 && b <= 31) {
          const d = new Date(year, a - 1, b);
          if (!isNaN(d.getTime()) && d.getMonth() === a - 1) return d;
        }
        // Fallback to dd/MM/yyyy
        if (b >= 1 && b <= 12 && a >= 1 && a <= 31) {
          const d = new Date(year, b - 1, a);
          if (!isNaN(d.getTime()) && d.getMonth() === b - 1) return d;
        }
      }
    }
  }

  // Last resort: native Date parsing
  const fallback = new Date(str);
  return isNaN(fallback.getTime()) ? null : fallback;
}

exports.partialServiceEdit = tryCatch(async (req, res) => {
  const { requestionId } = req.params;
  const { requestSkills, requestFlowStations, requestServiceId, ...updateFields } = req.body;
  const requestDesignation = req.body.requestDesignation;

  // Check if the request exists
  const existingRequest = await reqServiceRequest.findOne({ where: { requestId: requestionId } });
  if (!existingRequest) {
    return res.status(404).json({ result: false, message: "Request not found" });
  }

  // Update requestFlowStations if provided
  if (Array.isArray(requestFlowStations) && requestFlowStations.length > 0 && requestServiceId) {
    await scheduleStations({ flowServiceId: requestServiceId, flowStations: requestFlowStations });
  }
  

  if (updateFields.requestPostingDate) {
    const parsed = parseDateString(updateFields.requestPostingDate);
    if (!parsed) {
      return res.status(400).json({ result: false, message: "Invalid posting date format. Expected MM/dd/yyyy." });
    }
    updateFields.requestPostingDate = parsed;
  }

  if (updateFields.requestClosingDate) {
    const parsed = parseDateString(updateFields.requestClosingDate);
    if (!parsed) {
      return res.status(400).json({ result: false, message: "Invalid closing date format. Expected MM/dd/yyyy." });
    }
    updateFields.requestClosingDate = parsed;
  }

  // Prepare the update payload
  const updatePayload = {
    ...updateFields,
    ...(requestSkills ? { requestSkills: requestSkills.join(",") } : {})
  };

  //create designtion  if string
  if (/^\d+$/.test(requestDesignation) == false && requestDesignation != undefined) {
    const designation = await reqDesignation.create({
      designationName: requestDesignation,
    });
    updatePayload.requestDesignation = designation.designationId;
  }

  // Update the request
  await reqServiceRequest.update(updatePayload, { where: { requestId: requestionId } });

  return res.status(200).json({ result: true, message: "Request updated successfully." });
});



exports.requestActive = tryCatch(async (req, res) => {
  const { requestionId, approve, reason } = req.body;

  if (req.userType !== 'admin') {
    return res.status(403).json({ result: false, message: "Only Admin has the rights." });
  }

  const request = await reqServiceRequest.findOne({ where: { requestId: requestionId } });

  if (!request) {
    return res.status(404).json({ result: false, message: "Request not found." });
  }

  if (request.requestStatus === 'closed') {
    return res.status(400).json({ result: false, message: "Request is closed. No action can be taken." });
  }

  const updateData = approve 
    ? { requestStatus: 'active' } 
    : { requestStatus: 'rejected', requestRejectReason: reason || 'No reason provided' };

  await request.update(updateData);

  return res.status(200).json({ 
    result: true, 
    message: approve ? "Request Activated." : "Request Rejected.",
  });
});

exports.activeServicesList = tryCatch(async (req, res) => {
  const search = req.query.search;
  const toDate = new Date();
  const fromDate = new Date();
  fromDate.setMonth(fromDate.getMonth() - 3);
  let where = {
    requestStatus: {
        [Op.in]: ["active"]
    },
    requestDate: {
        [Op.between]: [fromDate, toDate],
      },
};
  if (search)
    where = {
      [Op.or]: [
        { requestName: { [Op.iLike]: `${search}%` } },
        // { requestCode: { [Op.iLike]: `${search}%` } },
      ],
    };
  let services = await reqServiceRequest.findAll({
    where,
    include: [{ model: reqTeam, as: "team" }],
    raw: true,
    order: [["requestId", "DESC"]],
  });
  if (services.length > 0) {
    services = services.map((service) => ({
      ...service,
      requestSalaryType:
        service.requestSalaryType === 1
          ? "month"
          : service.requestSalaryType === 2
          ? "year"
          : service.requestSalaryType,
    }));
    return res.status(200).json({
      status: true,
      message: "Service Request Retrived",
      data: services,
    });
  }
  return res
    .status(401)
    .json({ result: false, message: response.DATA_NOT_FOUND, data: services });
});

exports.mapJobOpeningToRequisition = tryCatch(async (req, res) => {
  const { requisitionId, jobOpeningId } = req.body;

  if (!requisitionId || !jobOpeningId) {
    return res.status(400).json({
      result: false,
      message: 'requisitionId and jobOpeningId are required.',
    });
  }

  // Validate requisition exists and is active
  const requisition = await reqServiceRequest.findOne({
    where: { requestId: requisitionId, requestStatus: 'active' },
  });
  if (!requisition) {
    return res.status(404).json({
      result: false,
      message: 'Active requisition not found.',
    });
  }

  // Validate job opening exists
  const jobOpening = await reqJobOpening.findOne({
    where: { requestId: jobOpeningId },
  });
  if (!jobOpening) {
    return res.status(404).json({
      result: false,
      message: 'Job opening not found.',
    });
  }

  // Prevent duplicate mapping
  const existing = await reqServiceRequestsJobOpenings.findOne({
    where: { requisitionId, jobOpeningId },
  });
  if (existing) {
    return res.status(409).json({
      result: false,
      message: 'This job opening is already linked to the selected requisition.',
    });
  }

  const mapping = await reqServiceRequestsJobOpenings.create({
    requisitionId,
    jobOpeningId,
  });

  return res.status(200).json({
    result: true,
    message: 'Job opening linked to requisition successfully.',
    data: mapping,
  });
});

