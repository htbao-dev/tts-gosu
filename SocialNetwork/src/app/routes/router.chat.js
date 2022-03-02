const express = require("express");
const api = express.Router();
const authMiddleware = require("../middlewares/AuthMiddleware");
const chatController = require("../controllers/ChatController");
const chatMiddleware = require("../middlewares/ChatMiddleware");

api.post(
  "/send-image-message",
  authMiddleware.verifyToken,
  // upload.array("images"),
  chatController.sendImageMessage
);

api.get(
  "/get-image",
  [authMiddleware.verifyToken, chatMiddleware.checkUserIsInRoomChat],
  chatController.getImage
);

module.exports = api;
