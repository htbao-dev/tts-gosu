class RefreshTokenExpiredException implements Exception {
  String message;
  RefreshTokenExpiredException(this.message);
}
