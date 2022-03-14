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

class SearchEmptyState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchErrorState extends SearchState {
  final String message;
  SearchErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
