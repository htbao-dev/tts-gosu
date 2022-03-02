// ignore: file_names

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str)['users'].map((x) => User.fromJson(x)));

List<UserWithFriendstatus> userWithFriendshipFromJson(String str) =>
    List<UserWithFriendstatus>.from(
        json.decode(str).map((x) => UserWithFriendstatus.fromJson(x)));

class User {
  String id;
  String name;
  String username;
  User({required this.id, required this.name, required this.username});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? json["_id"],
        name: json["name"],
        username: json["username"],
      );
}

class UserWithFriendstatus {
  int? status;
  User user;
  UserWithFriendstatus({required this.user, this.status});

  factory UserWithFriendstatus.fromJson(Map<String, dynamic> json) {
    User user = User.fromJson(json['user']);
    return UserWithFriendstatus(user: user, status: json['status']);
  }
}
