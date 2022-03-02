const express = require("express");
const bodyParser = require("body-parser");
const morgan = require("morgan");
const route = require("./src/app/routes");
const socket = require("./src/app/socket");
const db = require("./src/config/db.config");
const Common = require("./src/app/common/Common");
const app = express();
const PORT = process.env.PORT || 3483;

db.connect();
require("dotenv").config();

app.use(morgan("combined"));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
// app.use("/uploads", express.static(__dirname + "/uploads"));

const server = app.listen(PORT);
Common.io = socket(server);
route(app);

console.log("RESTful API server started on: " + PORT);
