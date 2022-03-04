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
        _id: 1,
        username: 1,
        name: 1,
        status: 1,
      },
    },
  ]);
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

async function acceptFriendRequest(req, res) {}

async function rejectFriendRequest(req, res) {}

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
          user.friends.pull({ user: friendId });
          await user.save();
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
              user.friends.pull({ user: friendId });
              friend.friends.pull({ user: userId });
              await user.save();
              await friend.save();
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

async function removeFriend(req, res) {}
// }

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
  removeFriend,
};
