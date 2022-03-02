import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  const PasswordField(
      {Key? key, this.controller, this.validator, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Mật khẩu',
        hintText: 'Nhập mật khẩu',
        icon: Icon(Icons.lock),
      ),
      obscureText: true,
    );
  }
}

class UsernameField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  const UsernameField(
      {Key? key, this.controller, this.validator, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // key: GlobalKey(),
      // focusNode: FocusNode(),
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Tên đăng nhập',
        hintText: 'Tên đăng nhập của bạn',
        icon: Icon(Icons.person),
      ),
    );
  }
}
