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
  SearchLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class SearchErrorState extends SearchState {
  final String message;
  SearchErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

abstract class AddFriendState extends SearchState {
  final String userId;
  AddFriendState(this.userId);
}

class FriendRequestSuccessState extends AddFriendState {
  FriendRequestSuccessState(userId) : super(userId);

  @override
  List<Object?> get props => [userId];
}
