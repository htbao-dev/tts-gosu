const mongoose = require("mongoose");
const schema = mongoose.Schema;
const User = require("../models/User");

const Room = new schema({
  name: String,
  members: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
  messages: [
    {
      sender: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
      message: { type: String, required: true },
      date: { type: Date, default: Date.now },
      images: [String],
    },
  ],
});

module.exports = mongoose.model("Room", Room);
