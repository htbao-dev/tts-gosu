import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/contact_bloc/contact_bloc.dart';
import 'package:social_network_client/blocs/room_bloc/room_bloc.dart';
import 'package:social_network_client/pages/home/chat_page.dart';
import 'package:social_network_client/pages/widgets/user_widget.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listenWhen: (previous, current) => current is JoinRoomState,
      listener: (context, state) {
        if (state is JoinRoomState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatPage(
                room: state.room,
              ),
            ),
          );
        }
      },
      child: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state is ContactInitial) {
            BlocProvider.of<ContactBloc>(context).add(LoadContactsEvent());
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ContactLoadedState) {
            return ListView.builder(
                itemCount: state.contacts.length,
                itemBuilder: (context, index) =>
                    ListViewUserTile(state.contacts[index], state.userId));
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}
