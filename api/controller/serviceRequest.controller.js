const moment = require("moment");
let { Op } = require("sequelize");
const { tryCatch } = require("../utils/trycatch");
let {
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
} = require("../../models");

exports.createService = tryCatch(async (req, res) => {
  let toDate = moment().format("YYYY-MM-DD");
  const transformedObject = {
    ...req.body,
    requestSkills: req.body.requestSkills.join(","),
  };
  console.log(req.userRole, "req.userRole");
  if (req.userRole != "manager" && req.userRole != "admin" &&req.userType!='admin')
    return res
      .status(401)
      .json({
        result: false,
        message: "Only manager or Admin can create requstion",
      });

  let requestFlowStations = req.body.requestFlowStations;
  let requestDesignation = req.body.requestDesignation;
  let service;
  let responseMessage = "";
  let team = await reqTeam.findOne({
    where: { teamId: transformedObject.requestTeam },
    raw: true,
  });
  let serviceRequestName = transformedObject.requestName;
  transformedObject.requestName = serviceRequestName;
  let esistingServiceRequest = await reqServiceRequest.findOne({
    where: { requestName: transformedObject.requestName },
  });
  //create designtion  if string
  if (/^\d+$/.test(requestDesignation) == false) {
    let designation = await reqDesignation.create({
      designationName: requestDesignation,
    });
    transformedObject.requestDesignation = designation.designationId;
  }
  //keep entry in service table
  let esistingService = await reqServices.findOne({
    where: { sericeName: transformedObject.requestName },
  });
  let serviceId = null;
  if (esistingService) {
    let [servicedata, metaData] = await sequelize.query(
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
  let flowObject = {
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

exports.listServices = tryCatch(async (req, res) => {
  let search = req.query.search;
  let where = {
    requestStatus: {
        [Op.in]: ["active"]
    }
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
    .json({ result: false, message: "data not found", data: services });
});

exports.yearList = tryCatch(async (req, res) => {
  let yearData = await reqCandidates.findAll({
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
    .json({ status: true, message: "data retrived", data: yearData });
});

exports.servicesList = tryCatch(async (req, res) => {
  let services = await reqServices.findAll({
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
      .json({ result: true, message: "data found", data: services });
  return res.status(401).json({ result: false, message: "data not found" });
});

async function scheduleStations(flowObject) {
  try {
    let { flowServiceId, flowStations } = flowObject;
    console.log(flowStations, "stationsssss");
    let flowWithRequest = await reqServiceFlow.findOne({
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
    let stations = await reqStation.findAll({
      where: {
        stationId: { [Op.in]: flowStations },
      },
      raw: true,
      order: [["stationId", "ASC"]],
    });
    let serviceFlows = stations.map((el) => {
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
  let requestId = req.body.requestId;
  if (!requestId)
    return res
      .status(400)
      .json({ result: false, message: "request  id mandatory" });
  let selectQuery = `SELECT DISTINCT("requestId"),(SELECT COUNT(*) FROM "reqServiceSequences" INNER JOIN "reqCandidates" ON "candidateId"="reqServiceSequences"."serviceCandidate" WHERE "reqServiceSequences"."serviceServiceRequst"= ?) AS "candidateCount"
        FROM "reqServiceRequests" as "service" INNER JOIN "reqTeams" ON "service"."requestTeam" = "teamId"
            WHERE "service"."requestId"=?`;
  let [data, metadata] = await sequelize.query(selectQuery, {
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

  let toDate = moment().format("YYYY-MM-DD");
  const transformedObject = {
    ...req.body,
    requestSkills: req.body.requestSkills.join(","),
  };
  let requestFlowStations = req.body.requestFlowStations;
  let requestDesignation = req.body.requestDesignation;
  let service;

  let serviceRequestName = transformedObject.requestName; // + "-" + team.teamName + "-" + toDate;
  transformedObject.requestName = serviceRequestName;
  let esistingServiceRequest = await reqServiceRequest.findOne({
    where: { requestId },
  });

  //keep entry in service table
  let esistingService = await reqServices.findOne({
    where: { sericeId: esistingServiceRequest.requestServiceId },
  });
  let [servicedata, metaData] = await sequelize.query(
    `UPDATE "reqServices" SET "sericeName"=:sericeName 
            WHERE "sericeName"=:sericeName RETURNING "sericeId"`,
    {
      replacements: {
        sericeName: esistingService.sericeName,
      },
    }
  );
  if (typeof requestDesignation === "string") {
    let designation = await reqDesignation.create({
      designationName: requestDesignation,
    });
    transformedObject.requestDesignation = designation.designationId;
  }
  let serviceId = servicedata[0]?.sericeId;
  transformedObject.requestServiceId = serviceId;
  service = await esistingServiceRequest.update(transformedObject);
  let flowObject = {
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
  let requestId = req.body.requestId;
  if (!requestId)
    return res
      .status(400)
      .json({ result: false, message: "request  id mandatory" });
  let selectQuery = `SELECT DISTINCT("requestId"),"requestServiceId",(SELECT COUNT(*) FROM "reqServiceSequences" INNER JOIN "reqCandidates" ON "candidateId"="reqServiceSequences"."serviceCandidate" WHERE "reqServiceSequences"."serviceServiceRequst"= ?) AS "candidateCount"
        FROM "reqServiceRequests" as "service" INNER JOIN "reqTeams" ON "service"."requestTeam" = "teamId"
            WHERE "service"."requestId"=?`;

  let [data, metadata] = await sequelize.query(selectQuery, {
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
  let deletedService = await reqServiceRequest.destroy({
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
  let requestId = req.query.requestId;
  let validRequest = await reqServiceRequest.findOne({
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
  let requestServiceId = validRequest.requestServiceId;
  let flows = await reqServiceFlow.findAll({
    where: { flowServiceId: requestServiceId },
  });
  if (!validRequest)
    return res
      .status(404)
      .send({ result: false, message: "request id not found" });
  return res.status(200).json({
    result: true,
    message: "data retrived",
    data: validRequest,
    flows,
  });
});

exports.partialServiceEdit = tryCatch(async (req, res) => {
  const { requestionId } = req.params;
  const { requestSkills, requestFlowStations,requestServiceId, ...updateFields } = req.body;
  const requestDesignation=req.body.requestDesignation;

  // Check if the request exists
  const existingRequest = await reqServiceRequest.findOne({ where: { requestId: requestionId } });
  if (!existingRequest) {
    return res.status(404).json({ result: false, message: "Request not found" });
  }

  // Update requestFlowStations if provided
  if (Array.isArray(requestFlowStations) && requestFlowStations.length > 0 &&requestServiceId) {
    await scheduleStations({ flowServiceId: requestServiceId, flowStations: requestFlowStations });
  }
  
  // Prepare the update payload
  const updatePayload = {
    ...updateFields,
    ...(requestSkills ? { requestSkills: requestSkills.join(",") } : {})
  };

  //create designtion  if string
  if (/^\d+$/.test(requestDesignation) == false&&requestDesignation!=undefined) {
    let designation = await reqDesignation.create({
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

