import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/auth_bloc/auth_bloc.dart';
import 'package:social_network_client/pages/widgets/auth_widget.dart';
import 'package:social_network_client/until/validation.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _txtUsername = TextEditingController();
  final _txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _txtPassword.text = "admin";
    _txtUsername.text = "admin";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        // listenWhen: (previous, current) => current is LoginLoadingState,
        listener: (context, state) {
          if (state is LoginLoadingState) {
            showDialog(
                useRootNavigator: false,
                barrierDismissible: false,
                context: context,
                builder: (context) => const SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ));
          } else if (state is LoginSuccessState || state is LoginFailureState) {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFFDEC4FC), Color(0xFF91C6FC)],
            ),
          ),
          child: Stack(children: [
            _loginForm(),
            Align(
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.amber),
                    ),
                    child: const Text("Đăng ký"),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context)
                          .add(ShowRegisterPageEvent());
                    }),
                alignment: Alignment.bottomCenter),
          ]),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UsernameField(
                key: const Key("username"),
                controller: _txtUsername,
                validator: validationUsername,
                onChanged: (value) {
                  BlocProvider.of<AuthBloc>(context).add(
                      LoginUsernameChangedEvent(username: _txtUsername.text));
                },
              ),
              PasswordField(
                controller: _txtPassword,
                validator: validationPassword,
                // onChanged: (value) {}
              ),
              if (state is LoginFailureState)
                Text(
                  state.error,
                  style: const TextStyle(color: Colors.red),
                ),
              _loginButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('Đăng nhập'),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          context.read<AuthBloc>().add(LoginSubmitEvent(
                username: _txtUsername.text,
                password: _txtPassword.text,
              ));
        }
      },
    );
  }
}
