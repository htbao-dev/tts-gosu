part of 'chat_bloc.dart';

@immutable
abstract class ChatState extends Equatable {}

class ChatInitial extends ChatState {
  @override
  List<Object> get props => [];
}

class GetRoomInfoLoading extends ChatState {
  @override
  List<Object> get props => [];
}

class GetRoomInfoLoaded extends ChatState {
  final RoomDetail roomDetail;
  GetRoomInfoLoaded({required this.roomDetail});
  @override
  List<Object> get props => [roomDetail];
}

class OnChangeMessageState extends ChatState {
  final String message;
  OnChangeMessageState(this.message);
  @override
  List<Object> get props => [message];
}

class ChatReceiveMessageState extends ChatState {
  final List<Message> listMessage;
  ChatReceiveMessageState(this.listMessage);
  @override
  List<Object> get props => [listMessage, DateTime.now()];
}

class ChatSendingMessageState extends ChatState {
  final Message message;
  ChatSendingMessageState(this.message);
  @override
  List<Object> get props => [message, DateTime.now()];
}

class ChatSendMessageState extends ChatState {
  final List<Message> listMessage;
  ChatSendMessageState(this.listMessage);

  @override
  List<Object?> get props => [listMessage];
}

class ChatSendMessageSuccessState extends ChatState {
  final List<Message> listMessage;
  ChatSendMessageSuccessState(this.listMessage);
  @override
  List<Object> get props => [listMessage];
}

class ChatSendMessageErrorState extends ChatState {
  @override
  List<Object> get props => [];
}

// class ChatGettingMessageState extends ChatState {
//   @override
//   List<Object> get props => [];
// }

class ChatGetImageState extends ChatState {
  final String image;

  ChatGetImageState(this.image);
  @override
  List<Object> get props => [];
}

class ChatGetImageSuccessState extends ChatGetImageState {
  final Uint8List bytes;
  ChatGetImageSuccessState(this.bytes, image) : super(image);
  @override
  List<Object> get props => [image];
}

class ChatGetImageErrorState extends ChatGetImageState {
  ChatGetImageErrorState(image) : super(image);

  @override
  List<Object> get props => [];
}
