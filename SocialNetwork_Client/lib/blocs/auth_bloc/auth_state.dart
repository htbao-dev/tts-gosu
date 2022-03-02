part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

class LoginInitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginFailureState extends AuthState {
  final String error;

  LoginFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class LoginPasswordChangedState extends AuthState {
  final String password;

  LoginPasswordChangedState({required this.password});

  @override
  List<Object> get props => [password];
}

class LoginUsernameChangedState extends AuthState {
  final String username;

  LoginUsernameChangedState({required this.username});

  @override
  List<Object> get props => [username];
}

class LogoutState extends AuthState {
  @override
  List<Object> get props => [];
}

class CheckLoginState extends AuthState {
  @override
  List<Object> get props => [];
}

class ShowLoginPageState extends AuthState {
  @override
  List<Object> get props => [];
}

class ShowRegisterPageState extends AuthState {
  @override
  List<Object> get props => [];
}

class RegisterStatusState extends AuthState {
  @override
  List<Object?> get props => [];
}

class RegisterLoadingState extends RegisterStatusState {
  @override
  List<Object> get props => [];
}

class RegisterSuccessState extends RegisterStatusState {
  @override
  List<Object> get props => [];
}

class RegisterFailureState extends RegisterStatusState {
  final String error;

  RegisterFailureState({required this.error});

  @override
  List<Object> get props => [error];
}
