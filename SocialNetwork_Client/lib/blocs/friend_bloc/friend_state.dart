part of 'friend_bloc.dart';

@immutable
abstract class FriendState extends Equatable {
  static const alreadyFriendStatus = 2;
  static const receiverStatus = 1;
  static const senderStatus = 0;
  final String friendId;
  final int? friendStatus;

  const FriendState({required this.friendId, required this.friendStatus});
}

class FriendInitial extends FriendState {
  const FriendInitial() : super(friendId: "", friendStatus: null);

  @override
  List<Object?> get props => [];
}

class SendFriendRequestSuccessState extends FriendState {
  const SendFriendRequestSuccessState(friendId, friendStatus)
      : super(
          friendId: friendId,
          friendStatus: friendStatus,
        );

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class SendFriendRequestErrorState extends FriendState {
  const SendFriendRequestErrorState(friendId, friendStatus)
      : super(
          friendId: friendId,
          friendStatus: friendStatus,
        );

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class CancelFriendRequestSuccessState extends FriendState {
  const CancelFriendRequestSuccessState(friendId, friendStatus)
      : super(
          friendId: friendId,
          friendStatus: friendStatus,
        );

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class CancelFriendRequestErrorState extends FriendState {
  const CancelFriendRequestErrorState(friendId, friendStatus)
      : super(
          friendId: friendId,
          friendStatus: friendStatus,
        );

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class AcceptFriendRequestSuccessState extends FriendState {
  const AcceptFriendRequestSuccessState(friendId, friendStatus)
      : super(
          friendId: friendId,
          friendStatus: friendStatus,
        );

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class AcceptFriendRequestErrorState extends FriendState {
  const AcceptFriendRequestErrorState(String friendId, int? friendStatus)
      : super(friendId: friendId, friendStatus: friendStatus);

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class RejectFriendRequestSuccessState extends FriendState {
  const RejectFriendRequestSuccessState(friendId, friendStatus)
      : super(
          friendId: friendId,
          friendStatus: friendStatus,
        );

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class RejectFriendRequestErrorState extends FriendState {
  const RejectFriendRequestErrorState(String friendId, int? friendStatus)
      : super(friendId: friendId, friendStatus: friendStatus);

  @override
  List<Object?> get props => [friendId, friendStatus];
}
