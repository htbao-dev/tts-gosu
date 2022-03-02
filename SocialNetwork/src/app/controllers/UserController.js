const mongoose = require("mongoose");
const User = require("../models/User");

class UserController {
  async searchUserByName(req, res) {
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

    const users = await User.find(
      {
        $or: [
          { username: { $regex: regex, $options: "i" } },
          { name: { $regex: query, $options: "i" } },
        ],
      },
      {
        username: 1,
        name: 1,
      }
    );
    if (myFriends.friends[0].user == null) myFriends.friends = [];
    const result = myFriends.friends;
    users.forEach((user) => {
      result.push({ user });
    });
    res.status(200).json(result);
  }
}

module.exports = new UserController();
