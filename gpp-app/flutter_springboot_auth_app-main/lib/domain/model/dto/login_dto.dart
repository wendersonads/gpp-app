import 'dart:convert';

class LoginDTO {
  String username;
  String password;

  LoginDTO({
    required this.username,
    required this.password,
  });

  LoginDTO copyWith({
    String? username,
    String? password,
  }) {
    return LoginDTO(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, String> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory LoginDTO.fromMap(Map<String, dynamic> map) {
    return LoginDTO(
      username: map['username'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'LoginDTO(username: $username, password: $password)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginDTO &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode => username.hashCode ^ password.hashCode;
}
