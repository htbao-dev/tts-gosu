import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:social_network_client/models/User.dart';
import 'package:social_network_client/models/room.dart';
import 'package:social_network_client/repository/room_repository.dart';
import 'package:social_network_client/repository/socket_repository.dart';
import 'dart:core';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SocketRepository socketRepo;
  // final UserRepository userRepo;
  final RoomRepository roomRepo;
  List<User> listFriends = List.empty(growable: true);
  HomeBloc(
      {
      // required this.userRepo,
      required this.socketRepo,
      required this.roomRepo})
      : super(HomeInitial());
}
