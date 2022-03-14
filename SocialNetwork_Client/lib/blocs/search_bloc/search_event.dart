part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {}

class SearchFieldChangedEvent extends SearchEvent {
  final String query;

  SearchFieldChangedEvent(this.query);

  @override
  List<Object> get props => [query];
}

class SearchLoadedEvent extends SearchEvent {
  final List<UserWithFriendstatus> users;

  SearchLoadedEvent(this.users);

  @override
  List<Object> get props => [users];
}

class SearchErrorEvent extends SearchEvent {
  final String error;

  SearchErrorEvent(this.error);

  @override
  List<Object> get props => [error];
}
