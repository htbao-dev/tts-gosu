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
  final String friendId;
  final int? status;
  FriendRequestState(this.friendId, this.status);
}

class SendFriendRequestSuccessState extends FriendRequestState {
  SendFriendRequestSuccessState(friendId, status) : super(friendId, status);

  @override
  List<Object?> get props => [friendId, status];
}

class SendFriendRequestErrorState extends FriendRequestState {
  SendFriendRequestErrorState(friendId, status) : super(friendId, status);

  @override
  List<Object?> get props => [friendId, status];
}

class CancelFriendRequestSuccessState extends FriendRequestState {
  CancelFriendRequestSuccessState(friendId, status) : super(friendId, status);

  @override
  List<Object?> get props => [friendId, status];
}
