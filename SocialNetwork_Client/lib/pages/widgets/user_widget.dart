import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/contact_bloc/contact_bloc.dart';
import 'package:social_network_client/blocs/friend_bloc/friend_bloc.dart';
import 'package:social_network_client/models/user.dart';
import 'package:social_network_client/repository/friend_repository.dart';

class ListViewUserTile extends StatelessWidget {
  final UserWithFriendstatus item;
  final String userId;
  const ListViewUserTile(
    this.item,
    this.userId, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.user.id == userId) {
      return const SizedBox();
    }
    return BlocProvider(
        create: (context) => FriendBloc(
              friendRepo: RepositoryProvider.of<FriendRepository>(context),
            ),
        child: BlocBuilder<FriendBloc, FriendState>(
          buildWhen: ((previous, current) {
            return current.friendId == item.user.id;
          }),
          builder: (BuildContext context, state) {
            if (state.friendId == item.user.id) {
              item.status = state.friendStatus;
            }
            return ListTile(
                // leading: CircleAvatar(
                //   backgroundImage: NetworkImage(user.avatarUrl),
                // ),
                onTap: () {
                  BlocProvider.of<ContactBloc>(context)
                      .add(TapContactEvent(contactId: item.user.id));
                },
                title: Text(item.user.name),
                subtitle: Text(item.user.username),
                trailing: SizedBox(
                    width: 200, child: _listViewTileTrailing(context)));
          },
        ));
  }

  Widget _listViewTileTrailing(BuildContext context) {
    if (item.status != null) {
      switch (item.status) {
        case FriendState.senderStatus:
          return TextButton.icon(
              onPressed: () {
                BlocProvider.of<FriendBloc>(context)
                    .add(CancelFriendRequestEvent(item.user.id));
              },
              icon: const Icon(Icons.person_add_disabled),
              label: const Text("Huỷ yêu cầu"));
        case FriendState.receiverStatus:
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.yellow),
                  ),
                  onPressed: () {
                    BlocProvider.of<FriendBloc>(context)
                        .add(AcceptFriendRequestEvent(item.user.id));
                  },
                  child: const Text("Xác nhận")),
              TextButton(
                onPressed: () {
                  BlocProvider.of<FriendBloc>(context)
                      .add(RejectFriendRequestEvent(item.user.id));
                },
                child: const Text("Từ chối"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                ),
              ),
            ],
          );
        case FriendState.alreadyFriendStatus:
          return TextButton.icon(
              onPressed: () {
                BlocProvider.of<FriendBloc>(context)
                    .add(UnfriendEvent(item.user.id));
              },
              icon: const Icon(
                Icons.person_add_disabled,
                color: Colors.redAccent,
              ),
              label: const Text(
                "Bỏ kết bạn",
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ));
        default:
          return const SizedBox();
      }
    } else {
      return TextButton.icon(
          onPressed: () {
            BlocProvider.of<FriendBloc>(context)
                .add(SendFriendRequestEvent(item.user.id));
          },
          icon: const Icon(
            Icons.person_add_alt,
          ),
          label: const Text("Kết bạn"));
    }
  }
}
