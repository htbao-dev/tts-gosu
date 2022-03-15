import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/contact_bloc/contact_bloc.dart';
import 'package:social_network_client/blocs/nav_bloc/nav_bloc.dart';
import 'package:social_network_client/blocs/room_bloc/room_bloc.dart';
import 'package:social_network_client/models/room.dart';
import 'package:social_network_client/pages/home/chat_page.dart';
import 'package:social_network_client/pages/home/home_page.dart';
import 'package:social_network_client/pages/home/search_page.dart';
import 'package:social_network_client/repository/friend_repository.dart';
import 'package:social_network_client/repository/room_repository.dart';
import 'package:social_network_client/repository/user_repository.dart';

class HomeNavigator extends StatelessWidget {
  HomeNavigator({Key? key}) : super(key: key);
  final GlobalKey<NavigatorState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) => RoomRepository(),
        ),
        RepositoryProvider(
          create: (context) => FriendRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NavBloc(),
          ),
          BlocProvider(
            create: (context) => RoomBloc(
              roomRepo: RepositoryProvider.of<RoomRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ContactBloc(
                userRepo: RepositoryProvider.of<UserRepository>(context),
                roomRepo: RepositoryProvider.of<RoomRepository>(context),
                roomBloc: BlocProvider.of<RoomBloc>(context)),
          )
        ],
        child: WillPopScope(
          onWillPop: () async {
            if (_key.currentState!.canPop()) {
              _key.currentState!.pop();
              return false;
            } else {
              return true;
            }
          },
          child: Navigator(
            key: _key,
            initialRoute: HomePage.routeName,
            onGenerateRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                settings: settings,
                builder: (context) {
                  switch (settings.name) {
                    case HomePage.routeName:
                      return const HomePage();
                    case ChatPage.routeName:
                      return ChatPage(room: settings.arguments as Room);
                    case SearchPage.routeName:
                      return const SearchPage();
                    default:
                      return Scaffold(
                        body: Center(
                          child: Text('No route defined for ${settings.name}'),
                        ),
                      );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
