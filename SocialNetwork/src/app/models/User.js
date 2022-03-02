const mongoose = require("mongoose");
const schema = mongoose.Schema;

const User = new schema({
  name: { type: String, required: true },
  username: { type: String, minlength: 5 },
  password: { type: String, minlength: 5 },
  refreshToken: { type: String },
  socketId: { type: String },
  friends: [
    {
      user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
      },
      status: {
        type: Number,
        enum: [
          0, //request
          1, //pendding
          2, //friend
        ],
      },
    },
  ],
});

module.exports = mongoose.model("User", User);
