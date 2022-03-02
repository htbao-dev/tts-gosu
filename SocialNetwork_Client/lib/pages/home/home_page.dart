import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/auth_bloc/auth_bloc.dart';
import 'package:social_network_client/blocs/nav_bloc/nav_bloc.dart';
import 'package:social_network_client/pages/home/room_page.dart';
import 'package:social_network_client/pages/home/search_page.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, SearchPage.routeName);
                },
                icon: const Icon(Icons.search)),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SearchPage.routeName);
                },
                child: const Text(
                  'Tìm kiếm bạn bè',
                  style: TextStyle(color: Colors.white54),
                )),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
            ),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<NavBloc, NavState>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: "chat",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "contact",
              ),
            ],
            currentIndex: state.index,
            onTap: (index) {
              BlocProvider.of<NavBloc>(context).add(NavSelectEvent(index));
            },
          );
        },
      ),
      body: BlocBuilder<NavBloc, NavState>(
        builder: (context, state) {
          if (state.index == 0) {
            return const RoomPage();
          } else {
            return const Center(child: Text("contact"));
          }
        },
      ),
    );
  }
}
