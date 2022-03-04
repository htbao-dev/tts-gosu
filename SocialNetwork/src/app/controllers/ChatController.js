const Common = require("../common/Common");
const multer = require("multer");
const Room = require("../models/Room");
const fs = require("fs");
const Mongoose = require("mongoose");

var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const roomId = req.body.roomId;
    const path = Common.uploadsFolder + "/" + roomId;
    if (!fs.existsSync(path)) {
      fs.mkdirSync(path);
    }
    cb(null, path);
  },
  filename: function (req, file, cb) {
    let ext = file.originalname.substring(
      file.originalname.lastIndexOf("."),
      file.originalname.length
    );
    cb(null, Date.now() + ext);
  },
});
var upload = multer({
  storage: storage,
  fileFilter: function (req, file, cb) {
    if (!req.isChecked) {
      req.isChecked = true;
      const userId = req.userId;
      const roomId = req.body.roomId;
      Room.findById(roomId, (err, room) => {
        if (!room || err) {
          return cb(new Error("Room not found"));
        }
        if (room.members.indexOf(userId) === -1) {
          return cb(new Error("User is not in room"));
        }
      });
    }
    cb(null, true);
  },
});

var uploadImage = upload.array("images");

class ChatController {
  sendImageMessage(req, res) {
    uploadImage(req, res, (err) => {
      if (err) {
        return res.status(404).json({
          message: err.message,
          error: err,
        });
      }
      const files = req.files;
      if (!files || files.length === 0) {
        res.status(400).send("No files were uploaded.");
      } else {
        const userId = req.userId;
        const roomId = req.body.roomId;
        const message = req.body.message;
        const listFilePath = files.map((file) => file.filename);
        const data = {
          senderId: userId,
          message: message,
          images: listFilePath,
          date: new Date(),
        };
        Room.findById(roomId, (err, room) => {
          room.messages.push(data);
          room.save((err) => {
            if (err) {
              return res.status(404).json({
                message: err.message,
                error: err,
              });
            }
            res.status(200).json({
              message: "Success",
              listFilePath: listFilePath,
              message: message,
            });
            data.roomId = roomId;
            Common.io.in(roomId).emit("receive-message", data);
          });
        });
      }
    });
  }

  getImage(req, res) {
    const image = req.query.image;
    const roomId = req.query.roomId;
    const filePath = Common.uploadsFolder + `/${roomId}/${image}`;
    // console.log(filePath);
    if (fs.existsSync(filePath)) {
      res.sendFile(filePath);
    } else {
      res.status(404).send("File not found");
    }
    // res.sendFile(process.cwd() + "/uploads/" + image);
  }
}

module.exports = new ChatController();
