import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/auth_bloc/auth_bloc.dart';
import 'package:social_network_client/pages/widgets/auth_widget.dart';
import 'package:social_network_client/until/validation.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _txtPassword = TextEditingController();
  final _txtUsername = TextEditingController();
  final _txtname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is RegisterStatusState,
      listener: (context, state) {
        if (state is RegisterLoadingState) {
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
        } else {
          _txtPassword.text = '';
          _txtUsername.text = '';
          Navigator.of(context).pop();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Stack(
          children: [
            _loginForm(),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context)
                        .add(ShowLoginPageEvent());
                  },
                  child: const Text(
                    'Huỷ',
                    style: TextStyle(fontSize: 18),
                  )),
            )
          ],
        ),
      ),
    ));
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
              _nameField(),
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: ((previous, current) =>
                    current is RegisterStatusState),
                builder: (context, state) {
                  if (state is RegisterSuccessState) {
                    return const Text(
                      "Đăng ký thành công",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    );
                  } else if (state is RegisterFailureState) {
                    return Text(
                      state.error,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              _registerButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('Đăng ký'),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          context.read<AuthBloc>().add(RegisterSubmitEvent(
                username: _txtUsername.text,
                password: _txtPassword.text,
                name: _txtname.text,
              ));
        }
      },
    );
  }

  Widget _nameField() {
    return TextFormField(
      controller: _txtname,
      decoration: const InputDecoration(
        labelText: 'Tên',
        hintText: 'Nhập tên',
        icon: Icon(Icons.person),
      ),
      validator: validationName,
    );
  }
}
