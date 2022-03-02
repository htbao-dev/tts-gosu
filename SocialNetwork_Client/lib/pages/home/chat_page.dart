import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/chat_bloc/chat_bloc.dart';
import 'package:social_network_client/blocs/socket_bloc/socket_bloc.dart';
import 'package:social_network_client/models/message.dart';
import 'package:social_network_client/models/room.dart';
import 'package:social_network_client/models/user.dart';
import 'package:social_network_client/repository/room_repository.dart';

class ChatPage extends StatelessWidget {
  static const String routeName = '/chat';
  final _txtChatController = TextEditingController();
  final Room room;
  final Map<String, User> members = {};
  ChatPage({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        roomRepo: RepositoryProvider.of<RoomRepository>(context),
        // chatRepo:
      ),
      child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatSendingMessageState) {
              BlocProvider.of<SocketBloc>(context)
                  .add(SocketSendMessageEvent(state.message));
            }
          },
          child: Scaffold(appBar: _appBar(), body: _body())),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(room.name),
      actions: [
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () {
            // ignore: avoid_print
            print("call");
          },
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {
            // ignore: avoid_print
            print("video");
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // ignore: avoid_print
            print("more");
          },
        ),
      ],
    );
  }

  Widget _body() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [Expanded(child: _listviewMessage()), _chatField()],
      ),
    );
  }

  Widget _listviewMessage() {
    return BlocListener<SocketBloc, SocketState>(
      listenWhen: (previous, current) =>
          current is SocketReceiveMessageState ||
          current is SocketSendMessageErrorState ||
          current is SocketSendMessageSuccessState,
      listener: (context, state) {
        if (state is SocketReceiveMessageState) {
          BlocProvider.of<ChatBloc>(context).add(
            ChatReceiveMessageEvent(data: state.message, room: room),
          );
        }
        if (state is SocketSendMessageErrorState) {
          BlocProvider.of<ChatBloc>(context).add(
            ChatSendMessageErrorEvent(),
          );
        }
        if (state is SocketSendMessageSuccessState) {
          BlocProvider.of<ChatBloc>(context).add(
            ChatSendMessageSuccessEvent(state.message),
          );
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) =>
            current is ChatReceiveMessageState ||
            current is GetRoomInfoLoaded ||
            current is ChatSendMessageSuccessState,
        builder: (context, state) {
          var _chatBloc = BlocProvider.of<ChatBloc>(context);
          if (state is ChatInitial) {
            _chatBloc.add(GetRoomInfo(room.id));
          }
          if (state is GetRoomInfoLoaded ||
              state is ChatReceiveMessageState ||
              state is ChatSendMessageSuccessState) {
            List<Message> listMessage = List.empty();
            if (state is GetRoomInfoLoaded) {
              for (var element in state.roomDetail.listMember) {
                members[element.id] = element;
              }
              listMessage = state.roomDetail.listMessage;
            } else if (state is ChatReceiveMessageState) {
              listMessage = state.listMessage;
            } else if (state is ChatSendMessageSuccessState) {
              listMessage = state.listMessage;
            }
            return Scrollbar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  reverse: true,
                  itemCount: listMessage.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListViewItem(
                        message: listMessage[index],
                        index: index,
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _chatField() {
    return Builder(builder: (context) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.image_rounded),
            onPressed: () {
              BlocProvider.of<ChatBloc>(context)
                  .add(ChatChooseImageGalleryEvent(room.id));
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_rounded),
            onPressed: () {
              BlocProvider.of<ChatBloc>(context)
                  .add(ChatChooseImageCameraEvent());
            },
          ),
          Expanded(
              child: TextFormField(
            controller: _txtChatController,
            decoration: const InputDecoration(
              hintText: "Type a message",
              border: InputBorder.none,
            ),
            onChanged: (value) {
              BlocProvider.of<ChatBloc>(context)
                  .add(OnChangeMessageEvent(value));
            },
          )),
          BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (previous, current) => current is OnChangeMessageState,
            builder: (context, state) {
              if (state is OnChangeMessageState && state.message.isNotEmpty) {
                return IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    BlocProvider.of<ChatBloc>(context).add(
                      ChatSendMessageEvent(
                        message: _txtChatController.text,
                        roomId: room.id,
                      ),
                    );
                    _txtChatController.clear();
                  },
                );
              }
              return Container();
            },
          ),
        ],
      );
    });
  }
}

class ListViewItem extends StatefulWidget {
  final Message message;
  final int index;
  const ListViewItem({Key? key, required this.message, required this.index})
      : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListViewItem>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: widget.message.isYourMessage
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        // Text(members[message.senderId]!.name),
        Container(
          decoration: BoxDecoration(
            color: widget.message.isYourMessage ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.message.message!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        _listImage(widget.message, widget.message.roomId!),
        Text(widget.message.formattedDate),
      ],
    );
  }

  Widget _listImage(Message message, String roomId) {
    if (message.images.isEmpty) {
      return Container();
    } else {
      return Directionality(
        textDirection:
            message.isYourMessage ? TextDirection.rtl : TextDirection.ltr,
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 90,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) =>
                _displayImage(roomId, message.images[index]),
            itemCount: message.images.length),
      );
    }
  }

  Widget _displayImage(String roomId, ImageMessage imageMessage) {
    if (imageMessage.file == null) {
      BlocProvider.of<ChatBloc>(context)
          .add(ChatGetImageEvent(roomId, widget.index, imageMessage.fileName));
      return BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) =>
            current is ChatGetImageState &&
            current.image == imageMessage.fileName,
        builder: (context, state) {
          if (state is ChatGetImageSuccessState) {
            return _img(state.bytes);
          } else if (state is ChatGetImageErrorState) {
            return const Text(
              "Error",
              style: TextStyle(color: Colors.red),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    } else {
      return _img(imageMessage.file!);
    }
  }

  Widget _img(Uint8List bytes) {
    return Image.memory(
      bytes,
      width: 60,
      fit: BoxFit.cover,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
