let express = require('express');
var cors = require('cors')
let app = express();
let errorHandler = require("./api/middleware/error");
const path = require('path');
let helmet = require('helmet');

app.use(cors({
  origin: '*',  // Allow all domains
  methods: ['GET', 'POST', 'PUT', 'DELETE','PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

require('dotenv').config();
let port = process.env.APP_PORT;
app.use(express.json());
app.use(helmet());
const sampleData = {
  message: 'Hello, this is a sample API!',
  timestamp: new Date().toISOString(),
};

let gmeet = require("./api/utils/gmeetConfiguration");
app.get('/', (req, res) => {
  res.json(sampleData);
});

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

let userRoutes = require("./api/routes/users.route");
app.use("/user", userRoutes);

let candidateRoutes = require("./api/routes/candidate.route");
app.use("/candidate", candidateRoutes);

let serviceRequestRoutes = require("./api/routes/serviceRequest.route");
app.use("/service-request", serviceRequestRoutes);

let screeningStationRoute = require("./api/routes/screeningStation.route");
app.use("/screening-station", screeningStationRoute);

let writtenStationRoute = require("./api/routes/writtenStation.route");
app.use("/written-station", writtenStationRoute);

let technicalStationRoute = require("./api/routes/technicalStation.route");
app.use("/technical-station", technicalStationRoute);

let technicalStationTwoRoute = require("./api/routes/technicalStationTwo.route");
app.use("/technical-station-two", technicalStationTwoRoute);

let managementStationRoute = require("./api/routes/management.route");
app.use("/management-station", managementStationRoute);

let dashBoardRoute = require("./api/routes/dashboard.route");
app.use("/dashboard", dashBoardRoute);

let reportRoute = require("./api/routes/report.route");
app.use("/report", reportRoute);

app.use("/hr-station", require("./api/routes/hrStation.route"));

app.all('*', (req, res, next) => {
  return res.status(404).json({ result: false, message: `Can't find this ${req.originalUrl} on the server!` })
})

app.use(errorHandler);

app.listen(port, () => {
  console.log(`Server Running on Port ${port}-aws`);
});
