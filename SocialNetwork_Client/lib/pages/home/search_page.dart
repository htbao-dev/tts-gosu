import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/search_bloc/search_bloc.dart';
import 'package:social_network_client/pages/widgets/user_widget.dart';
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
            buildWhen: (previous, current) =>
                !(current is SearchEmptyState && previous is SearchLoaded),
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
                      ListViewUserTile(users[index], myId),
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
}
