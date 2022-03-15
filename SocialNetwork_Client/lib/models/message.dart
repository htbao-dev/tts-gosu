import 'dart:typed_data';
import 'package:intl/intl.dart';

// List<Message> userFromJson(String str) =>
//     List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

class Message {
  String? roomId;
  String? id;
  String? senderId;
  String? message;
  List<ImageMessage> images;
  DateTime? date;
  String get formattedDate => DateFormat('dd/MM/yyyy HH:mm').format(date!);
  bool isYourMessage;
  Message(
      {required this.roomId,
      required this.id,
      required this.senderId,
      required this.message,
      this.date,
      this.images = const [],
      this.isYourMessage = false});

  factory Message.fromJson(Map<String, dynamic> json) {
    var images = json['images'];
    List<ImageMessage> imagesList = [];
    if (images != []) {
      imagesList =
          List<ImageMessage>.from(images.map((x) => ImageMessage(fileName: x)));
    }

    return Message(
      roomId: json["roomId"],
      id: json["id"] ?? json["_id"],
      senderId: json["senderId"] ?? json['sender'],
      message: json["message"],
      images: imagesList,
      date: DateTime.parse(json["date"].toString()),
    );
  }
}

class ImageMessage {
  String fileName;
  Uint8List? file;
  bool isUploaded;

  ImageMessage({required this.fileName, this.file, this.isUploaded = false});
}
