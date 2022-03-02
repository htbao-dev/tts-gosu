part of 'socket_bloc.dart';

@immutable
abstract class SocketState extends Equatable {}

class SocketInitial extends SocketState {
  @override
  List<Object> get props => [];
}

class SocketReceiveMessageState extends SocketState {
  final Message message;

  SocketReceiveMessageState(this.message);

  @override
  List<Object> get props => [message];
}

class SocketSendMessageState extends SocketState {
  final Message message;

  SocketSendMessageState(this.message);

  @override
  List<Object> get props => [message];
}

class SocketSendMessageSuccessState extends SocketState {
  final Message message;
  SocketSendMessageSuccessState(this.message);
  @override
  List<Object> get props => [message];
}

class SocketSendMessageErrorState extends SocketState {
  final String error;

  SocketSendMessageErrorState(this.error);

  @override
  List<Object> get props => [error];
}
