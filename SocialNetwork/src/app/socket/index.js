const socketio = require("socket.io");
const _ = require("underscore");
const authMiddleware = require("../middlewares/AuthMiddleware");
const clientSocketInit = require("./socket.init");
const clientSocketChat = require("./socket.chat");
const clientSocketConnection = require("./socket.connection");
function socket(server) {
  const io = socketio.listen(server);
  console.log("Socket started");

  _.each(io.nsps, function (nsp) {
    nsp.on("connect", function (socket) {
      if (!socket.auth) {
        delete nsp.connected[socket.id];
      }
    });
  });

  io.on("connection", (socket) => {
    socket.auth = false;
    const accessToken = socket.handshake.headers.accesstoken;
    const userId = socket.handshake.headers.userid;
    if (accessToken && userId) {
      const { statusVerify, res } =
        authMiddleware.verifyTokenSocket(accessToken);
      if (statusVerify == 200) {
        console.log("Authenticated socket ", socket.id);
        socket.auth = true;

        _.each(io.nsps, function (nsp) {
          if (_.findWhere(nsp.sockets, { id: socket.id })) {
            nsp.connected[socket.id] = socket;
          }
        });
        clientSocketInit(socket, userId);
        clientSocketConnection(socket);
        clientSocketChat(io, socket);
      }
    }
    setTimeout(function () {
      if (!socket.auth) {
        console.log("Disconnecting socket ", socket.id);
        // ack("not ok");
        socket.disconnect("unauthorized");
      }
    }, 5000);
  });
  return io;
}
module.exports = socket;
