const userNotFoundError = {
  message: "User not found",
  errorCode: 1,
};

const friendNotFoundError = {
  message: "Friend not found",
  errorCode: 2,
};
const coincidesIdError = {
  message: "FriendId coincides with userId",
  errorCode: 3,
};
const alreadyFriendError = {
  message: "You are already friends",
  errorCode: 4,
};
const friendRequestNotExistsError = {
  message: "This friend request not exists",
  errorCode: 5,
};
const notFriendRequesterError = {
  message: "You are not requester",
  errorCode: 6,
};
const notFriendReqeustReceiverError = {
  message: "your friend don't send friend request",
  errorCode: 7,
};
const cancelFriendRequestSuccess = {
  message: "Cancel friend request success",
};
const friendRequestSuccess = {
  message: "Send friend request success",
};

module.exports = {
  userNotFoundError,
  friendNotFoundError,
  coincidesIdError,
  alreadyFriendError,
  friendRequestNotExistsError,
  notFriendRequesterError,
  notFriendReqeustReceiverError,
  cancelFriendRequestSuccess,
  friendRequestSuccess,
};
