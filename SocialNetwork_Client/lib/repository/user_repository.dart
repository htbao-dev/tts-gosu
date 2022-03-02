import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network_client/exception/token_expired_exception.dart';
import 'package:social_network_client/config.dart';
import 'package:social_network_client/models/user.dart';
import 'package:social_network_client/repository/auth_repository.dart';

class UserRepository {
  final AuthRepository _authRepo = AuthRepository();

  ///throw RefreshTokenExpiredException if token is expired and Exception if error
  Future<List<UserWithFriendstatus>> searchUser(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final response =
        await http.get(Uri.parse('$apiUrl/user/search?query=$query'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });
    if (response.statusCode == 200) {
      List<UserWithFriendstatus> users =
          userWithFriendshipFromJson(response.body);
      return users;
    } else if (response.statusCode == 403) {
      final isOK = await _authRepo.refreshAccessToken();

      if (isOK) {
        return searchUser(query);
      } else {
        throw RefreshTokenExpiredException("Refreshtoken expired");
      }
    } else {
      throw Exception(response.statusCode);
    }
  }
}
