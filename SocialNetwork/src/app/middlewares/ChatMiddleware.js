const Room = require("../models/Room");

function checkUserIsInRoomChat(req, res, next) {
  const userId = req.userId;
  const roomId = req.query.roomId;
  // console.log(userId, roomId);
  Room.findById(roomId, (err, room) => {
    if (!room || err) {
      return res.status(404).send({
        message: "Room not found",
      });
    }
    if (room.members.indexOf(userId) === -1) {
      return res.status(404).send({
        message: "User is not in room",
      });
    }
    next();
  });
}

module.exports = { checkUserIsInRoomChat };
