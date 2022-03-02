import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network_client/config.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  late Socket _socket;
  SocketRepository() {
    _socket = io(
        baseUrl,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .setExtraHeaders({'foo': 'bar'}) // optional
            // .enableAutoConnect()
            .enableReconnection()
            .disableAutoConnect()
            .build());
    _socket.onDisconnect((data) {
      print(data);
      // _socket.connect();
    });
    _socket.onReconnect((data) => print('reconnected'));
  }

  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? accessToken = prefs.getString('accessToken');
    _socket.opts!['extraHeaders'] = {
      'userId': userId,
      'accessToken': accessToken,
    };
    _socket = _socket.connect();
  }

  void disconnect() {
    _socket.disconnect();
  }

  void on(String event, Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  void onRecieveMessage(Function(dynamic) callback) {
    _socket.on('receive-message', callback);
  }

  void emitSendMessage(dynamic mesasge) {
    _socket.emit('send-message', mesasge);
  }

  void emit(String event, dynamic data) {
    _socket.emit(event, data);
  }
}
