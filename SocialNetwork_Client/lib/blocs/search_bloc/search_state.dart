part of 'search_bloc.dart';

@immutable
abstract class SearchState extends Equatable {}

class SearchInitial extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchLoadingState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchLoaded extends SearchState {
  final List<UserWithFriendstatus> users;
  final String myId;
  SearchLoaded(this.users, this.myId);

  @override
  List<Object?> get props => [users];
}

class SearchErrorState extends SearchState {
  final String message;
  SearchErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

abstract class FriendRequestState extends SearchState {
  static const alreadyFriendStatus = 2;
  static const receiverStatus = 1;
  static const senderStatus = 0;
  final String friendId;
  final int? friendStatus;
  FriendRequestState({required this.friendId, required this.friendStatus});
}

class SendFriendRequestSuccessState extends FriendRequestState {
  SendFriendRequestSuccessState(friendId, friendStatus)
      : super(
          friendId: friendId,
          friendStatus: friendStatus,
        );

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class SendFriendRequestErrorState extends FriendRequestState {
  SendFriendRequestErrorState(friendId, friendStatus)
      : super(
          friendId: friendId,
          friendStatus: friendStatus,
        );

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class CancelFriendRequestSuccessState extends FriendRequestState {
  CancelFriendRequestSuccessState(friendId, friendStatus)
      : super(
          friendId: friendId,
          friendStatus: friendStatus,
        );

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class AcceptFriendRequestSuccessState extends FriendRequestState {
  AcceptFriendRequestSuccessState(friendId, friendStatus)
      : super(
          friendId: friendId,
          friendStatus: friendStatus,
        );

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class AcceptFriendRequestErrorState extends FriendRequestState {
  AcceptFriendRequestErrorState(String friendId, int? friendStatus)
      : super(friendId: friendId, friendStatus: friendStatus);

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class RejectFriendRequestSuccessState extends FriendRequestState {
  RejectFriendRequestSuccessState(friendId, friendStatus)
      : super(
          friendId: friendId,
          friendStatus: friendStatus,
        );

  @override
  List<Object?> get props => [friendId, friendStatus];
}

class RejectFriendRequestErrorState extends FriendRequestState {
  RejectFriendRequestErrorState(String friendId, int? friendStatus)
      : super(friendId: friendId, friendStatus: friendStatus);

  @override
  List<Object?> get props => [friendId, friendStatus];
}
