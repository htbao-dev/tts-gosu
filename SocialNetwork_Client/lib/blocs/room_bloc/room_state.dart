part of 'room_bloc.dart';

@immutable
abstract class RoomState extends Equatable {}

class RoomInitial extends RoomState {
  @override
  List<Object> get props => [];
}

class GetListRoomLoading extends RoomState {
  @override
  List<Object> get props => [];
}

class GetListRoomLoaded extends RoomState {
  final List<Room> listRoom;
  GetListRoomLoaded({required this.listRoom});
  @override
  List<Object> get props => [listRoom];
}

class JoinRoomState extends RoomState {
  final Room room;
  JoinRoomState({required this.room});
  @override
  List<Object> get props => [room, DateTime.now()];
}
