const User = require("../models/User");
const friendRequestStatus = require("../common/friendRequestStatus");
async function checkExistsAndValid(req, res, next) {
  const userId = req.userId;
  const friendId = req.body.friendId;
  let user = await User.findById(userId);
  if (!user) {
    return res.status(404).json(friendRequestStatus.userNotFoundError);
  }
  let friend = await User.findById(friendId);
  if (!friend) {
    return res.status(404).json(friendRequestStatus.friendNotFoundError);
  }
  if (userId === friendId) {
    return res.status(400).json(friendRequestStatus.coincidesIdError);
  }
  next();
}

module.exports = { checkExistsAndValid };
