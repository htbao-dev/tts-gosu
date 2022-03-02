part of 'socket_bloc.dart';

@immutable
abstract class SocketEvent extends Equatable {}

class SocketReceiveMessageEvent extends SocketEvent {
  final Message message;
  SocketReceiveMessageEvent(this.message);
  @override
  List<Object> get props => [message];
}

class SocketSendMessageEvent extends SocketEvent {
  final Message message;
  SocketSendMessageEvent(this.message);
  @override
  List<Object> get props => [message];
}
