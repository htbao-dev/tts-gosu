import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network_client/exception/token_expired_exception.dart';
import 'package:social_network_client/models/room.dart';
import 'package:social_network_client/config.dart';
import 'package:social_network_client/repository/auth_repository.dart';

class RoomRepository {
  final AuthRepository _authRepo = AuthRepository();
  Future<List<Room>> getListRoom(String keySearch) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? userId = prefs.getString('userId');
    final response = await http.get(
        Uri.parse(
            '$apiUrl/room/get-list-room?userId=$userId&keySearch=$keySearch'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode == 200) {
      List<Room> rooms = roomsFromJson(response.body);
      return rooms;
    } else if (response.statusCode == 403) {
      final isOK = await _authRepo.refreshAccessToken();

      if (isOK) {
        return getListRoom(userId!);
      } else {
        throw RefreshTokenExpiredException("Refreshtoken expired");
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<RoomDetail> getRoomDetail(String roomId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? userId = prefs.getString('userId');
    final response = await http.get(
        Uri.parse('$apiUrl/room/get-room-detail?roomId=$roomId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        });

    if (response.statusCode == 200) {
      RoomDetail roomDetail = roomDetailFromJson(response.body);
      for (var element in roomDetail.listMessage) {
        element.isYourMessage = element.senderId == userId;
        element.roomId = roomDetail.id;
        // if (element.images != null) {
        //   for (var image in element.images!) {
        //     image.file = await getImage(roomDetail.id, image.fileName);
        //     // print("asd");
        //     // print(image.file!.path);
        //   }
        // }
      }
      return roomDetail;
    } else if (response.statusCode == 403) {
      final isOK = await _authRepo.refreshAccessToken();

      if (isOK) {
        return getRoomDetail(roomId);
      } else {
        throw RefreshTokenExpiredException("Refreshtoken expired");
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<Uint8List> getImage(String roomId, String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    var url = '$apiUrl/chat/get-image?roomId=$roomId&image=$image';
    var headers = {
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else if (response.statusCode == 403) {
      final isOK = await _authRepo.refreshAccessToken();

      if (isOK) {
        return getImage(roomId, image);
      } else {
        throw RefreshTokenExpiredException("Refreshtoken expired");
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<bool> postImageMessage(
      String roomId, String contentMessage, List<File> listImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    var uri = Uri.parse('$apiUrl/chat/send-image-message');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.fields['roomId'] = roomId;
    request.fields['message'] = contentMessage;
    for (var _image in listImage) {
      var stream = http.ByteStream(_image.openRead());
      var length = await _image.length();
      var multipartFile =
          http.MultipartFile('images', stream, length, filename: _image.path);
      request.files.add(multipartFile);
    }

    var response = await request.send();
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 403) {
      final isOK = await _authRepo.refreshAccessToken();

      if (isOK) {
        return postImageMessage(roomId, contentMessage, listImage);
      } else {
        throw RefreshTokenExpiredException("Refreshtoken expired");
      }
    } else {
      throw Exception(response.statusCode.toString());
    }

    // request.files.add();
  }

  Future<Room> getInboxRoom(String contactId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? userId = prefs.getString('userId');
    final response = await http.get(
        Uri.parse('$apiUrl/room/get-inbox-room?contactId=$contactId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode == 200) {
      Room room = Room.fromJson(json.decode(response.body));
      return room;
    } else if (response.statusCode == 403) {
      final isOK = await _authRepo.refreshAccessToken();

      if (isOK) {
        return getInboxRoom(contactId);
      } else {
        throw RefreshTokenExpiredException("Refreshtoken expired");
      }
    } else {
      throw Exception(response.statusCode);
    }
  }
}
