import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/auth_bloc/auth_bloc.dart';
import 'package:social_network_client/blocs/socket_bloc/socket_bloc.dart';
import 'package:social_network_client/pages/app_navigator.dart';
import 'package:social_network_client/repository/auth_repository.dart';
import 'package:social_network_client/repository/socket_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialNetwork',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => AuthRepository(),
          ),
          RepositoryProvider(
            create: (context) => SocketRepository(),
          ),
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider(
            create: (context) => AuthBloc(
                authRepo: RepositoryProvider.of<AuthRepository>(context),
                socketRepo: RepositoryProvider.of<SocketRepository>(context)),
          ),
          BlocProvider(
            create: (context) => SocketBloc(
                socketRepo: RepositoryProvider.of<SocketRepository>(context),
                authRepo: RepositoryProvider.of<AuthRepository>(context)),
          ),
        ], child: const AppNavigator()),
      ),
    );
  }
}
