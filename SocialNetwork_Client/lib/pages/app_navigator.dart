import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/auth_bloc/auth_bloc.dart';
import 'package:social_network_client/pages/home/home_navigator.dart';
import 'package:social_network_client/pages/login_register/login_page.dart';
import 'package:social_network_client/pages/login_register/register_page.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(CheckLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          current is LoginSuccessState ||
          current is LogoutState ||
          current is ShowLoginPageState ||
          current is ShowRegisterPageState,
      builder: (context, state) {
        if (state is LoginSuccessState) {
          return HomeNavigator();
        } else if (state is LogoutState || state is ShowLoginPageState) {
          return LoginPage();
        } else if (state is ShowRegisterPageState) {
          return RegisterPage();
        } else {
          return Scaffold(body: Container());
        }
      },
    );
  }
}
