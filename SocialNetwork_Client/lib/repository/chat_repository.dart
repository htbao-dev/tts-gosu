// import 'dart:typed_data';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:social_network_client/config.dart';
// import 'package:http/http.dart' as http;

// import '../exception/token_expired_exception.dart';
// import 'auth_repository.dart';

// class ChatRepository {
//   final _authRepo = AuthRepository();
//   Future<Uint8List> getImage(String roomId, String image) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? accessToken = prefs.getString('accessToken');
//     var url = '$apiUrl/chat/get-image?roomId=$roomId&image=$image';
//     var headers = {
//       'Authorization': 'Bearer $accessToken',
//     };

//     final response = await http.get(Uri.parse(url), headers: headers);

//     if (response.statusCode == 200) {
//       return response.bodyBytes;
//     } else if (response.statusCode == 403) {
//       final isOK = await _authRepo.refreshAccessToken();

//       if (isOK) {
//         return getImage(roomId, image);
//       } else {
//         throw RefreshTokenExpiredException("Refreshtoken expired");
//       }
//     } else {
//       throw Exception(response.statusCode);
//     }
//   }
// }
