import 'dart:convert';

import 'package:social_network_client/models/message.dart';
import 'package:social_network_client/models/user.dart';

// List<RoomDetail> roomFromJson(String str) {
//   final jsonData = json.decode(str);
//   return List<RoomDetail>.from(
//       jsonData["rooms"].map((x) => RoomDetail.fromJson(x)));
// }

List<Room> roomFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Room>.from(jsonData.map((x) => Room.fromJson(x)));
}

RoomDetail roomDetailFromJson(String str) {
  final jsonData = json.decode(str);
  return RoomDetail.fromJson(jsonData);
}

class Room {
  String id;
  String name;
  Message? lastMessage;

  Room({
    required this.id,
    required this.name,
    this.lastMessage,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["_id"] ?? json["id"],
        name: json["name"] ?? "Chưa đặt tên",
        lastMessage: json["lastMessage"] == null
            ? null
            : Message.fromJson(json["lastMessage"]),
      );
}

class RoomDetail extends Room {
  List<User> listMember;
  List<Message> listMessage;
  RoomDetail(
      {required String id,
      required String name,
      required this.listMember,
      required this.listMessage})
      : super(id: id, name: name);

  factory RoomDetail.fromJson(Map<String, dynamic> json) => RoomDetail(
        id: json["id"] ?? json["_id"],
        name: json["name"] ?? "Chưa đặt tên",
        listMember:
            List<User>.from(json["members"].map((x) => User.fromJson(x))),
        listMessage: json["messages"] == null
            ? []
            : List<Message>.from(
                json["messages"].map((x) => Message.fromJson(x))),
      );
}
