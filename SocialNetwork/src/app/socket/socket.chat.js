const User = require("../models/User");
const Room = require("../models/Room");
module.exports = (io, client) => {
  client.on("send-message", (data) => {
    const { roomId, senderId, message } = data;
    console.log(data);
    Room.findById(roomId).then((room) => {
      if (room) {
        const data = {
          senderId: senderId,
          message: message,
          date: new Date(),
        };
        room.messages.push(data);
        room.save().then(() => {
          data.roomId = roomId;
          client.to(roomId).emit("receive-message", data);
        });
      }
    });
  });
};
