part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent extends Equatable {}

class GetRoomInfo extends ChatEvent {
  final String roomId;
  GetRoomInfo(this.roomId);
  @override
  List<Object> get props => [roomId];
}

class ChatSendMessageEvent extends ChatEvent {
  final String roomId;
  final String message;
  ChatSendMessageEvent({required this.roomId, required this.message});
  @override
  List<Object> get props => [roomId, message];
}

class OnChangeMessageEvent extends ChatEvent {
  final String message;
  OnChangeMessageEvent(this.message);
  @override
  List<Object> get props => [message];
}

class ChatReceiveMessageEvent extends ChatEvent {
  final Message data;
  final Room room;
  ChatReceiveMessageEvent({required this.data, required this.room});
  @override
  List<Object> get props => [data];
}

class ChatSendMessageSuccessEvent extends ChatEvent {
  final Message message;
  ChatSendMessageSuccessEvent(this.message);
  @override
  List<Object> get props => [message];
}

class ChatSendMessageErrorEvent extends ChatEvent {
  ChatSendMessageErrorEvent();
  @override
  List<Object> get props => [];
}

class ChatGetImageEvent extends ChatEvent {
  final String fileName;
  final int index;
  final String roomId;
  ChatGetImageEvent(this.roomId, this.index, this.fileName);
  @override
  List<Object> get props => [index];
}

class ChatChooseImageGalleryEvent extends ChatEvent {
  final String roomId;

  ChatChooseImageGalleryEvent(this.roomId);
  @override
  List<Object> get props => [];
}

class ChatChooseImageCameraEvent extends ChatEvent {
  @override
  List<Object> get props => [];
}
