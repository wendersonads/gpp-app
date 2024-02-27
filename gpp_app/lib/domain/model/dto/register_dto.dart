import 'dart:convert';

import 'package:auth_migration/base/model/abstract_dto.dart';

class RegisterDTO extends AbstractDTO {
  String name;
  String username;
  String password;

  RegisterDTO({
    required this.name,
    required this.username,
    required this.password,
  });

  RegisterDTO copyWith({
    String? name,
    String? username,
    String? password,
  }) {
    return RegisterDTO(
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  Map<String, String> toMap() {
    return {
      'name': name,
      'username': username,
      'password': password,
    };
  }

  factory RegisterDTO.fromMap(Map<String, dynamic> map) {
    return RegisterDTO(
      name: map['name'],
      username: map['username'],
      password: map['password'],
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory RegisterDTO.fromJson(String source) =>
      RegisterDTO.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterDTO && other.username == username && other.password == password && other.name == name;
  }

  @override
  int get hashCode => username.hashCode ^ password.hashCode ^ name.hashCode;
}
