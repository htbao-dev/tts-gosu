const express = require("express");
const api = express.Router();
const userController = require("../controllers/UserController");
const authMiddleware = require("../middlewares/AuthMiddleware");
const friendMiddleware = require("../middlewares/FriendMiddleware");
api.get("/search", authMiddleware.verifyToken, userController.searchUserByName);
api.post(
  "/send-friend-request",
  [authMiddleware.verifyToken, friendMiddleware.checkExistsAndValid],
  userController.sendFriendRequest
);
api.post(
  "/accept-friend-request",
  [authMiddleware.verifyToken, friendMiddleware.checkExistsAndValid],
  userController.acceptFriendRequest
);
api.post(
  "/reject-friend-request",
  [authMiddleware.verifyToken, friendMiddleware.checkExistsAndValid],
  userController.rejectFriendRequest
);
api.post(
  "/cancel-friend-request",
  [authMiddleware.verifyToken, friendMiddleware.checkExistsAndValid],

  userController.cancelFriendRequest
);
api.post(
  "/remove-friend",
  [authMiddleware.verifyToken, friendMiddleware.checkExistsAndValid],
  userController.removeFriend
);

module.exports = api;
