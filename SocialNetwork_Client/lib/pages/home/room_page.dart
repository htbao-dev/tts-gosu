import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/room_bloc/room_bloc.dart';
import 'package:social_network_client/pages/home/chat_page.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RoomBloc>(context).add(GetListRoomEvent(""));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoomBloc, RoomState>(
      listenWhen: (previous, current) => current is JoinRoomState,
      buildWhen: (previous, current) => current is! JoinRoomState,
      listener: (context, state) {
        if (state is JoinRoomState) {
          Navigator.pushNamed(context, ChatPage.routeName,
              arguments: state.room);
        }
      },
      builder: (context, state) {
        if (state is GetListRoomLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetListRoomLoaded) {
          var rooms = state.listRoom;
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  BlocProvider.of<RoomBloc>(context)
                      .add(JoinRoomEvent(rooms[index]));
                },
                title: Text(rooms[index].name),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
