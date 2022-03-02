part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {}

class LoginUsernameChangedEvent extends AuthEvent {
  final String username;

  LoginUsernameChangedEvent({required this.username});

  @override
  List<Object> get props => [username];
}

class LoginPasswordChangedEvent extends AuthEvent {
  final String password;

  LoginPasswordChangedEvent({required this.password});

  @override
  List<Object> get props => [password];
}

class LoginSubmitEvent extends AuthEvent {
  final String username;
  final String password;

  LoginSubmitEvent({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class LogoutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class CheckLoginEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class ShowRegisterPageEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class ShowLoginPageEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class RegisterSubmitEvent extends AuthEvent {
  final String username;
  final String password;
  final String name;

  RegisterSubmitEvent(
      {required this.username, required this.password, required this.name});

  @override
  List<Object> get props => [username, password, name];
}
