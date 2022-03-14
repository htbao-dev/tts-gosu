const mongoose = require("mongoose");
const Common = require("../common/Common");
const User = require("../models/User");
const friendRequestStatus = require("../common/friendRequestStatus");
// class UserController {
async function searchUserByName(req, res) {
  const query = req.query.query;
  const regex = `.*${query}.*`;

  const myFriends = await User.findById(mongoose.Types.ObjectId(req.userId), {
    friends: 1,
    _id: 0,
  })
    .populate({
      path: "friends.user",
      select: "name _id username",
      match: {
        $or: [
          { name: { $regex: regex, $options: "i" } },
          { username: { $regex: regex, $options: "i" } },
        ],
      },
    })
    .exec();

  let result = await User.aggregate([
    {
      $match: {
        $or: [
          { username: { $regex: regex, $options: "i" } },
          { name: { $regex: query, $options: "i" } },
        ],
      },
    },
    {
      $addFields: {
        status: {
          $getField: {
            field: "status",
            input: {
              $first: {
                $filter: {
                  input: myFriends.friends,
                  as: "friend",
                  cond: {
                    $eq: ["$$friend.user", "$_id"],
                  },
                },
              },
            },
          },
        },
      },
    },
    {
      $project: {
        _id: 0,
        status: 1,
        user: {
          _id: "$_id",
          username: "$username",
          name: "$name",
        },
      },
    },
  ]);
  console.log(result);
  res.status(200).json(result);
}

async function sendFriendRequest(req, res) {
  const userId = req.userId;
  const friendId = req.body.friendId;
  const io = Common.io;
  let user = await User.findById(userId);
  let friend = await User.findById(friendId);
  if (checkExistsInListFriend(user.friends, friendId)) {
    return res.status(400).json(friendRequestStatus.alreadyFriendError);
  }
  if (checkExistsInListFriend(friend.friends, userId)) {
    return res.status(400).json(friendRequestStatus.alreadyFriendError);
  }
  user.friends.push({ user: friendId, status: 0 });
  friend.friends.push({ user: userId, status: 1 });
  await user.save();
  await friend.save();
  const friendSocketId = friend.socketId;
  if (friendSocketId) {
    io.to(friendSocketId).emit("recieve-friend-request", {
      userId: userId,
      name: user.name,
    });
  }
  res.status(200).json(friendRequestStatus.friendRequestSuccess);
}

async function acceptFriendRequest(req, res) {
  const userId = req.userId;
  const friendId = req.body.friendId;
  let user = await User.findById(userId);
  let friend = await User.findById(friendId);
  const _friend = checkExistsInListFriend(user.friends, friendId);
  if (!_friend) {
    return res
      .status(400)
      .json(friendRequestStatus.friendRequestNotExistsError);
  }
  switch (_friend.status) {
    case 2:
      return res.status(400).json(friendRequestStatus.alreadyFriendError);
    case 0:
      return res
        .status(400)
        .json(friendRequestStatus.notFriendReqeustReceiverError);
    default:
      break;
  }
  const _user = checkExistsInListFriend(friend.friends, userId);
  if (!_user) {
    removeFromListFriendOf(userId, friendId);
    return res
      .status(400)
      .json(friendRequestStatus.notFriendReqeustReceiverError);
  }
  switch (_user.status) {
    case 1:
      return res
        .status(400)
        .json(friendRequestStatus.notFriendReqeustReceiverError);
    default: {
      await User.updateOne(
        { _id: userId, "friends.user": friendId },
        { $set: { "friends.$.status": 2 } }
      );
      await User.updateOne(
        { _id: friendId, "friends.user": userId },
        { $set: { "friends.$.status": 2 } }
      );
      const friendSocketId = friend.socketId;
      if (friendSocketId) {
        io.to(friendSocketId).emit("accept-friend-request", {
          userId: userId,
          name: user.name,
        });
      }
      res.status(200).json(friendRequestStatus.acceptFriendRequestSuccess);
    }
  }
}

async function rejectFriendRequest(req, res) {
  const userId = req.userId;
  const friendId = req.body.friendId;
  let user = await User.findById(userId);
  let friend = await User.findById(friendId);
  const _friend = checkExistsInListFriend(user.friends, friendId);
  if (!_friend) {
    return res
      .status(400)
      .json(friendRequestStatus.friendRequestNotExistsError);
  } else {
    switch (_friend.status) {
      case 2:
        return res.status(400).json(friendRequestStatus.alreadyFriendError);
      case 0:
        return res
          .status(400)
          .json(friendRequestStatus.notFriendReqeustReceiverError);
      default: {
        const _user = checkExistsInListFriend(friend.friends, userId);
        if (!_user) {
          removeFromListFriendOf(userId, friendId);
          return res
            .status(400)
            .json(friendRequestStatus.notFriendReqeustReceiverError);
        } else {
          switch (_user.status) {
            case 2:
              return res
                .status(400)
                .json(friendRequestStatus.alreadyFriendError);
            case 1: {
              removeFromListFriendOf(userId, friendId);
              removeFromListFriendOf(friendId, userId);
              return res
                .status(400)
                .json(friendRequestStatus.notFriendReqeustReceiverError);
            }
            case 0: {
              console.log(`userid ${userId} friendid ${friendId}`);
              removeFromListFriendOf(userId, friendId);
              removeFromListFriendOf(friendId, userId);
              return res
                .status(200)
                .json(friendRequestStatus.rejectFriendRequestSuccess);
            }
          }
        }
      }
    }
  }
}

async function cancelFriendRequest(req, res) {
  const userId = req.userId;
  const friendId = req.body.friendId;
  let user = await User.findById(userId);
  let friend = await User.findById(friendId);
  const _friend = checkExistsInListFriend(user.friends, friendId);
  if (!_friend) {
    return res
      .status(400)
      .json(friendRequestStatus.friendRequestNotExistsError);
  } else {
    switch (_friend.status) {
      case 2:
        return res.status(400).json(friendRequestStatus.alreadyFriendError);

      case 1:
        return res
          .status(400)
          .json(friendRequestStatus.notFriendRequesterError);

      case 0: {
        const _user = checkExistsInListFriend(friend.friends, userId);
        if (!_user) {
          removeFromListFriendOf(userId, friendId);
          return res
            .status(400)
            .json(friendRequestStatus.notFriendReqeustReceiverError);
        } else {
          switch (_user.status) {
            case 0:
              return res
                .status(400)
                .json(friendRequestStatus.notFriendRequesterError);
            default: {
              removeFromListFriendOf(userId, friendId);
              removeFromListFriendOf(friendId, userId);
              return res
                .status(200)
                .json(friendRequestStatus.cancelFriendRequestSuccess);
            }
          }
        }
      }
    }
  }
}

async function unfriend(req, res) {}

async function getListFriend(req, res) {
  const userId = req.userId;
  let listFriend = await User.aggregate([
    {
      $match: { _id: mongoose.Types.ObjectId(userId) },
    },
    {
      $sort: {
        friends: -1,
      },
    },
    {
      $lookup: {
        from: "users",
        localField: "friends.user",
        foreignField: "_id",
        as: "friends",
      },
    },
    {
      $project: {
        friends: 1,
        _id: 0,
      },
    },
  ]);
  // listFriend[0].friends.populate("user", "name username _id");
  console.log(listFriend[0].friends[0].status);
  res.status(200).json(listFriend[0]);
}

async function removeFromListFriendOf(userId, friendId) {
  await User.updateOne(
    {
      _id: userId,
    },
    {
      $pull: {
        friends: {
          user: friendId,
        },
      },
    }
  );
}

function checkExistsInListFriend(friends, friendId) {
  const exsits = (fr) => fr.user.toString() === friendId;
  return friends.find(exsits);
}

module.exports = {
  searchUserByName,
  sendFriendRequest,
  acceptFriendRequest,
  rejectFriendRequest,
  cancelFriendRequest,
  unfriend,
  getListFriend,
};
