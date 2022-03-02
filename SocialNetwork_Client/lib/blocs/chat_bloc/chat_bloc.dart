import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network_client/models/message.dart';
import 'package:social_network_client/models/room.dart';
import 'package:social_network_client/repository/room_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late final List<Message> listMessage;
  final RoomRepository roomRepo;
  // final ChatRepository chatRepo;
  final ImagePicker _picker = ImagePicker();
  // final UserRepository userRepo;
  ChatBloc({
    required this.roomRepo,
    // required this.chatRepo,
  }) : super(ChatInitial()) {
    on<ChatSendMessageEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Message _msg = Message(
          id: null,
          roomId: event.roomId,
          message: event.message,
          date: DateTime.now(),
          isYourMessage: true,
          senderId: prefs.getString('userId'));

      emit(ChatSendingMessageState(_msg));

      // emit(ChatSendMessageState(listMessage));
      emit(OnChangeMessageState(""));
    });

    on<GetRoomInfo>((event, emit) async {
      emit(GetRoomInfoLoading());
      RoomDetail room = await roomRepo.getRoomDetail(event.roomId);
      // List<User> users = await userRepo.getUsersMessage(room.listMember);
      listMessage = room.listMessage;
      emit(GetRoomInfoLoaded(roomDetail: room));
    });
    on<OnChangeMessageEvent>((event, emit) {
      emit(OnChangeMessageState(event.message));
    });
    on<ChatReceiveMessageEvent>((event, emit) async {
      Message _message = event.data;
      Room _room = event.room;
      if (_message.roomId! == _room.id) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _message.isYourMessage = _message.senderId == prefs.getString('userId');
        listMessage.insert(0, _message);
        emit(ChatReceiveMessageState(listMessage));
      }
    });

    on<ChatSendMessageErrorEvent>((event, emit) {
      emit(ChatSendMessageErrorState());
    });

    on<ChatSendMessageSuccessEvent>((event, emit) {
      listMessage.insert(0, event.message);
      emit(ChatSendMessageSuccessState(listMessage));
    });

    on<ChatGetImageEvent>((event, emit) async {
      try {
        var bytes = await roomRepo.getImage(event.roomId, event.fileName);
        var listImg = listMessage[event.index].images;
        for (var img in listImg) {
          if (img.fileName == event.fileName) {
            img.file = bytes;
          }
        }
        emit(ChatGetImageSuccessState(bytes, event.fileName));
      } catch (e) {
        // ignore: avoid_print
        print(e);
        emit(ChatGetImageErrorState(event.fileName));
      }
    });

    on<ChatChooseImageGalleryEvent>((event, emit) async {
      try {
        final images = await _picker.pickMultiImage();
        List<File> listImage = [];
        for (var item in images ?? []) {
          listImage.add(File(item.path));
        }
        roomRepo.postImageMessage(
            event.roomId, "test send from emulator", listImage);
        // emit(ChatChooseImageSuccessState(image));
      } catch (e) {
        // ignore: avoid_print
        print(e);
        // emit(ChatChooseImageErrorState());
      }
    });

    on<ChatChooseImageCameraEvent>((event, emit) async {
      try {
        await _picker.pickImage(source: ImageSource.camera);
        // emit(ChatChooseImageSuccessState(image));
      } catch (e) {
        // ignore: avoid_print
        print(e);
        // emit(ChatChooseImageErrorState());
      }
    });
  }
}
