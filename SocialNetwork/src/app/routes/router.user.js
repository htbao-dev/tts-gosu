const express = require("express");
const api = express.Router();
const userController = require("../controllers/UserController");
const authMiddleware = require("../middlewares/AuthMiddleware");

api.get("/search", authMiddleware.verifyToken, userController.searchUserByName);

module.exports = api;
