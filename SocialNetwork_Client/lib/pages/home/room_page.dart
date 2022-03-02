import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/room_bloc/room_bloc.dart';
import 'package:social_network_client/pages/home/chat_page.dart';
import 'package:social_network_client/repository/room_repository.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomBloc(
        roomRepo: RepositoryProvider.of<RoomRepository>(context),
      ),
      child: BlocConsumer<RoomBloc, RoomState>(
        listenWhen: (previous, current) => current is JoinRoomState,
        buildWhen: (previous, current) => current is! JoinRoomState,
        listener: (context, state) {
          if (state is JoinRoomState) {
            Navigator.pushNamed(context, ChatPage.routeName,
                arguments: state.room);
          }
        },
        builder: (context, state) {
          if (state is RoomInitial) {
            BlocProvider.of<RoomBloc>(context).add(GetListRoomEvent(""));
          }
          if (state is GetListRoomLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetListRoomLoaded) {
            var rooms = state.listRoom;
            return Row(children: [
              Expanded(
                child: ListView.builder(
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
                ),
              ),
            ]);
          }
          return Container();
        },
      ),
    );
  }
}
