part of 'friend_bloc.dart';

@immutable
abstract class FriendEvent extends Equatable {
  final String friendId;

  const FriendEvent(this.friendId);
}

class SendFriendRequestEvent extends FriendEvent {
  const SendFriendRequestEvent(friendId) : super(friendId);

  @override
  List<Object> get props => [friendId];
}

class CancelFriendRequestEvent extends FriendEvent {
  const CancelFriendRequestEvent(friendId) : super(friendId);

  @override
  List<Object> get props => [friendId];
}

class AcceptFriendRequestEvent extends FriendEvent {
  const AcceptFriendRequestEvent(friendId) : super(friendId);

  @override
  List<Object> get props => [friendId];
}

class RejectFriendRequestEvent extends FriendEvent {
  const RejectFriendRequestEvent(friendId) : super(friendId);

  @override
  List<Object> get props => [friendId];
}

class UnfriendEvent extends FriendEvent {
  const UnfriendEvent(friendId) : super(friendId);

  @override
  List<Object> get props => [friendId];
}
