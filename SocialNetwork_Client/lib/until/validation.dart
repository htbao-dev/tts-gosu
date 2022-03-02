String? validationUsername(String? username) {
  if (!(username!.isNotEmpty && username.length > 3)) {
    return 'Tên đăng nhập phải ít nhất 3 ký tự';
  }
  return null;
}

String? validationPassword(String? password) {
  if (!(password!.isNotEmpty && password.length > 3)) {
    return 'Mật khẩu phải ít nhất 3 ký tự';
  }
  return null;
}

String? validationName(String? name) {
  if (!(name!.isNotEmpty)) {
    return 'Tên không được rỗng';
  }
  return null;
}
