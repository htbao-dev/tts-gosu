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
            buildWhen: (previous, current) => current is! AddFriendState,
            builder: (context, state) {
              if (state is SearchLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SearchLoaded) {
                var users = state.users;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) => _listViewTile(users[index]),
                );
              }
              return Container();
            },
          ),
        );
      }),
    );
  }

  Widget _listViewTile(UserWithFriendstatus item) {
    return ListTile(
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(user.avatarUrl),
        // ),
        title: Text(item.user.name),
        trailing: _listViewTileTrailing(item.status, item.user.id));
  }

  Widget _listViewTileTrailing(int? status, String userId) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: ((previous, current) =>
          current is AddFriendState && current.userId == userId),
      builder: (context, state) {
        if (state is FriendRequestSuccessState) {
          return TextButton.icon(
              onPressed: () {
                // BlocProvider.of<SearchBloc>(context)
                //     .add(FriendRequestEvent(userId));
              },
              icon: const Icon(Icons.person_add_disabled),
              label: const Text("Huỷ kết bạn"));
        } else {
          if (status != null) {
            return Text("status $status");
          }
          return TextButton.icon(
              onPressed: () {
                BlocProvider.of<SearchBloc>(context)
                    .add(FriendRequestEvent(userId));
              },
              icon: const Icon(Icons.person_add_alt),
              label: const Text("Kết bạn"));
        }
      },
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
}
