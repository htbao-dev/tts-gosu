part of 'room_bloc.dart';

@immutable
abstract class RoomEvent extends Equatable {}

class GetListRoomEvent extends RoomEvent {
  final String keySearch;

  GetListRoomEvent(this.keySearch);
  @override
  List<Object> get props => [];
}

class JoinRoomEvent extends RoomEvent {
  final Room room;

  JoinRoomEvent(this.room);
  @override
  List<Object> get props => [];
}
