part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {}

class GetListRoomEvent extends HomeEvent {
  final String keySearch;
  GetListRoomEvent(this.keySearch);
  @override
  List<Object> get props => [keySearch];
}

class JoinRoomEvent extends HomeEvent {
  final RoomDetail room;
  JoinRoomEvent(this.room);
  @override
  List<Object> get props => [room];
}
