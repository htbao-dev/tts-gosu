const authRouter = require("./router.auth");
const userRouter = require("./router.user");
const roomRouter = require("./router.room");
const chatRouter = require("./router.chat");
const authMiddleware = require("../middlewares/AuthMiddleware");
const express = require("express");
const chatMiddleware = require("../middlewares/ChatMiddleware");
function route(app) {
  app.use("/api/auth", authRouter);
  app.use("/api/user", userRouter);
  app.use("/api/room", roomRouter);
  app.use("/api/chat", chatRouter);
  // app.use(
  //   "/uploads",
  //   [authMiddleware.verifyToken, chatMiddleware.checkUserIsInRoomChat],
  //   express.static(process.cwd() + "/uploads")
  // );
  app.use(function (req, res) {
    res.status(404).send({ url: req.originalUrl + " not found" });
  });
}

module.exports = route;
