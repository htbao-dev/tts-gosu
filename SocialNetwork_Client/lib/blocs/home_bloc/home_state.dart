part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class GetListRoomLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class GetListRoomLoaded extends HomeState {
  final List<RoomDetail> listRoom;

  GetListRoomLoaded({required this.listRoom});

  @override
  List<Object> get props => [listRoom];
}

class JoinRoomState extends HomeState {
  final RoomDetail room;

  JoinRoomState({required this.room});

  @override
  List<Object> get props => [room];
}
