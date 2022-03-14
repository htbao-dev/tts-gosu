part of 'contact_bloc.dart';

@immutable
abstract class ContactState extends Equatable {}

class ContactInitial extends ContactState {
  @override
  List<Object> get props => [];
}

class ContactLoadedState extends ContactState {
  final List<UserWithFriendstatus> contacts;
  final String userId;

  ContactLoadedState(this.contacts, this.userId);

  @override
  List<Object> get props => [contacts];
}

class ContactErrorState extends ContactState {
  @override
  List<Object?> get props => [];
}
