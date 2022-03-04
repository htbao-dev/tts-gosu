import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network_client/config.dart';
import 'package:social_network_client/exception/token_expired_exception.dart';
import 'package:social_network_client/repository/auth_repository.dart';
import 'package:http/http.dart' as http;

class FriendRepository {
  final AuthRepository _authRepo = AuthRepository();
  Future<FriendRequestStatus> sendFriendRequest(String friendId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final response = await http
        .post(Uri.parse('$apiUrl/user/send-friend-request'), headers: {
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    }, body: {
      'friendId': friendId,
    });
    if (response.statusCode == 403) {
      final isOK = await _authRepo.refreshAccessToken();
      if (isOK) {
        return sendFriendRequest(friendId);
      } else {
        throw RefreshTokenExpiredException("Refreshtoken expired");
      }
    } else {
      try {
        var body = json.decode(response.body);
        FriendRequestStatus status = FriendRequestStatus.fromJson(body);
        return status;
      } catch (_) {
        throw Exception(response.body);
      }
    }
  }

  Future<FriendRequestStatus> cancelFriendRequest(String friendId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final response = await http
        .post(Uri.parse('$apiUrl/user/cancel-friend-request'), headers: {
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    }, body: {
      'friendId': friendId,
    });
    if (response.statusCode == 403) {
      final isOK = await _authRepo.refreshAccessToken();

      if (isOK) {
        return cancelFriendRequest(friendId);
      } else {
        throw RefreshTokenExpiredException("Refreshtoken expired");
      }
    } else {
      try {
        var body = json.decode(response.body);
        FriendRequestStatus status = FriendRequestStatus.fromJson(body);
        return status;
      } catch (_) {
        throw Exception(response.body);
      }
    }
  }
}

class FriendRequestStatus {
  final String message;
  late final int? errorCode;

  FriendRequestStatus(this.message, this.errorCode);

  factory FriendRequestStatus.fromJson(Map<String, dynamic> json) {
    return FriendRequestStatus(
        json['message'] as String, json['errorCode'] as int?);
  }

  final userNotFoundError = 1;
  final friendNotFoundError = 2;
  final coincidesIdError = 3;
  final alreadyFriendError = 4;
  final friendRequestNotExistsError = 5;
  final notFriendRequesterError = 6;
  final notFriendReqeustReceiverError = 7;
  // final cancelFriendRequestSuccess
  final success = 0;
}
