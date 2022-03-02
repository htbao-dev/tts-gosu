import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network_client/models/user.dart';
import 'package:social_network_client/config.dart';

enum LoginStatus {
  userNotFound,
  passwordIncorrect,
  loginSuccess,
  tokenNotFound,
  unknownError,
}

enum LocalData {
  userId,
  accessToken,
  refreshToken,
  username,
  name,
}

enum RegisterStatus {
  userAlreadyExists,
  registerSuccess,
  unknownError,
}

class AuthRepository {
  Future<LoginStatus> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/login'),
        body: {
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        final refreshToken = responseJson['refreshToken'];
        final accessToken = responseJson['accessToken'];
        final userInfo = User.fromJson(responseJson['userInfo']);
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('userId', userInfo.id);
        prefs.setString('username', userInfo.username);
        prefs.setString('name', userInfo.name);
        prefs.setString('refreshToken', refreshToken);
        prefs.setString('accessToken', accessToken);

        return LoginStatus.loginSuccess;
      } else if (response.statusCode == 401) {
        // print(response.body);
        var body = jsonDecode(response.body);
        if (body['message'] == 'USER_NOT_FOUND') {
          return LoginStatus.userNotFound;
        } else if (body['message'] == 'PASSWORD_INCORRECT') {
          return LoginStatus.passwordIncorrect;
        } else {
          return LoginStatus.tokenNotFound;
        }
      } else {
        return LoginStatus.unknownError;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return LoginStatus.unknownError;
    }
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse('$apiUrl/auth/logout'), headers: {
        'Authorization': 'Bearer ${prefs.getString('accessToken')}',
      }, body: {
        'refreshToken': prefs.getString('refreshToken'),
      });

      prefs.remove('refreshToken');
      prefs.remove('accessToken');
      prefs.remove('userId');
      prefs.remove('username');
      prefs.remove('name');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return false;
    }
  }

  Future<bool> refreshAccessToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');
      final response = await http.post(
        Uri.parse('$apiUrl/auth/refresh-token'),
        body: {
          'refreshToken': refreshToken ?? '',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        final accessToken = responseJson['accessToken'];
        prefs.setString('accessToken', accessToken);
        return true;
      } else {
        return false;
      }
    } on TimeoutException catch (_) {
      throw TimeoutException("Timeout");
    } on SocketException catch (_) {
      throw const SocketException("SocketException");
    }
  }

  Future<RegisterStatus> register(
      String username, String password, String name) async {
    try {
      final response =
          await http.post(Uri.parse('$apiUrl/auth/register'), body: {
        'username': username,
        'password': password,
        'name': name,
      });
      if (response.statusCode == 200) {
        return RegisterStatus.registerSuccess;
      } else if (response.statusCode == 409) {
        return RegisterStatus.userAlreadyExists;
      } else {
        return RegisterStatus.unknownError;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return RegisterStatus.unknownError;
    }
  }
}
