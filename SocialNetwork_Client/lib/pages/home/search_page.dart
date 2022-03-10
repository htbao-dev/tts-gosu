import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/search_bloc/search_bloc.dart';
import 'package:social_network_client/models/user.dart';
import 'package:social_network_client/repository/user_repository.dart';

class SearchPage extends StatelessWidget {
  static const String routeName = '/search';
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        userRepo: RepositoryProvider.of<UserRepository>(context),
      ),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: _appBar(context),
          body: BlocBuilder<SearchBloc, SearchState>(
            // buildWhen is used to test. Must implement buildWhen
            buildWhen: (previous, current) => current is! FriendRequestState,
            builder: (context, state) {
              if (state is SearchLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SearchLoaded) {
                var users = state.users;
                var myId = state.myId;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) =>
                      _listViewTile(users[index], myId),
                );
              }
              return Container();
            },
          ),
        );
      }),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(right: 20, top: 30, bottom: 30),
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            onChanged: (value) => BlocProvider.of<SearchBloc>(context)
                .add(SearchFieldChangedEvent(value)),
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm bạn bè',
              border: InputBorder.none,
              icon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listViewTile(UserWithFriendstatus item, String userId) {
    return ListTile(
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(user.avatarUrl),
        // ),

        title: Text(item.user.name),
        subtitle: Text(item.user.username),
        trailing: SizedBox(
            width: 200,
            child: _listViewTileTrailing(item.status, item.user.id, userId)));
  }

  Widget _listViewTileTrailing(
      int? friendStatus, String friendId, String userId) {
    if (friendId == userId) {
      return const SizedBox();
    }
    return BlocBuilder<SearchBloc, SearchState>(
        buildWhen: ((previous, current) =>
            current is FriendRequestState && current.friendId == friendId),
        builder: (context, state) {
          if (state is FriendRequestState) {
            friendStatus = state.friendStatus;
          }
          if (friendStatus != null) {
            switch (friendStatus) {
              case FriendRequestState.senderStatus:
                return TextButton.icon(
                    onPressed: () {
                      BlocProvider.of<SearchBloc>(context)
                          .add(CancelFriendRequestEvent(friendId));
                    },
                    icon: const Icon(Icons.person_add_disabled),
                    label: const Text("Huỷ yêu cầu"));
              case FriendRequestState.receiverStatus:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow),
                        ),
                        onPressed: () {
                          BlocProvider.of<SearchBloc>(context)
                              .add(AcceptFriendRequestEvent(friendId));
                        },
                        child: const Text("Xác nhận")),
                    TextButton(
                      onPressed: () {
                        BlocProvider.of<SearchBloc>(context)
                            .add(RejectFriendRequestEvent(friendId));
                      },
                      child: const Text("Huỷ"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[300]),
                      ),
                    ),
                  ],
                );
              case FriendRequestState.alreadyFriendStatus:
                return const Text("Bạn bè");
              // return TextButton.icon(
              //     onPressed: () {
              //       // BlocProvider.of<SearchBloc>(context)
              //       //     .add(FriendRequestEvent(friendId));
              //     },
              //     icon: const Icon(Icons.person_add_disabled),
              //     label: const Text("Huỷ kết bạn"));
              default:
                return const SizedBox();
            }
          } else {
            return TextButton.icon(
                onPressed: () {
                  BlocProvider.of<SearchBloc>(context)
                      .add(SendFriendRequestEvent(friendId));
                },
                icon: const Icon(Icons.person_add_alt),
                label: const Text("Kết bạn"));
          }
        });
  }
}
