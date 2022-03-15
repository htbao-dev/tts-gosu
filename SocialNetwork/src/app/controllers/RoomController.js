const Room = require("../models/Room");
const User = require("../models/User");
const mongoose = require("mongoose");
class RoomController {
  createRoomByListMember(req, res, next) {
    const listId = req.body.userId;
    // console.log(listId);
    if (!listId) {
      return res.status(400).send({
        message: "listId is required",
      });
    }
    if (listId.length < 2) {
      return res.status(400).send({
        message: "listId must have at least 2 members",
      });
    }
    Room.findOne({
      $and: [
        { members: { $all: listId } },
        { members: { $size: listId.length } },
      ],
    })
      .then((room) => {
        if (room === [] || room === null) {
          const newRoom = new Room({
            members: listId,
          });
          newRoom.save().then((room) => {
            res.status(200).send({
              room: room,
            });
          });
        } else {
          res.status(200).send({
            room: room,
          });
        }
      })
      .catch((err) => {
        console.log(err);
        next(err);
      });
  }

  async getListRoom(req, res, next) {
    const userId = req.userId;
    try {
      const rooms = await Room.find(
        {
          members: { $in: mongoose.Types.ObjectId(userId) },
        },
        {
          _id: 1,
          name: 1,
        }
      );
      res.status(200).send(rooms);
    } catch (err) {
      console.log(err);
      next(err);
    }
  }

  async getInboxRoom(req, res) {
    const contactId = req.query.contactId;
    const userId = req.userId;
    try {
      const rooms = await Room.find(
        {
          members: {
            $all: [
              mongoose.Types.ObjectId(userId),
              mongoose.Types.ObjectId(contactId),
            ],
            $size: 2,
          },
        },
        {
          _id: 1,
          name: 1,
        }
      );
      if (rooms.length === 0) {
        const newRoom = new Room({
          members: [
            mongoose.Types.ObjectId(userId),
            mongoose.Types.ObjectId(contactId),
          ],
        });
        await newRoom.save();
        return res.status(200).send(newRoom);
      }
      return res.status(200).send(rooms[0]);
    } catch (err) {
      console.log(err);
      return res.status(500).send(err);
    }
  }

  async getRoomDetail(req, res, next) {
    const roomId = req.query.roomId;
    try {
      const room = await Room.findById(roomId).populate({
        path: "members",
        select: "name _id username",
      });
      room.messages.sort((a, b) => {
        return b.date - a.date;
      });
      res.status(200).send(room);
    } catch (err) {
      console.log(err);
      next(err);
    }
  }
}

module.exports = new RoomController();
