class AuthenticationException implements Exception {
  String message;

  AuthenticationException(this.message);

  @override
  String toString() {
    // ignore: todo
    // TODO: implement toString
    return message;
  }
}
