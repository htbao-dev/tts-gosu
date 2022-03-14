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
  "/unfriend",
  [authMiddleware.verifyToken, friendMiddleware.checkExistsAndValid],
  userController.unfriend
);
api.get(
  "/get-list-friend",
  [authMiddleware.verifyToken],
  userController.getListFriend
);

module.exports = api;
