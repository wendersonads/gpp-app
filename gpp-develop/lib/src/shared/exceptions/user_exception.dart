class UserException implements Exception {
  String message;

  UserException(this.message);

  @override
  String toString() {
    // ignore: todo
    // TODO: implement toString
    return message;
  }
}
