import 'dart:convert';

import 'package:auth_migration/base/model/abstract_entity.dart';

class Register implements AbstractEntity {
  @override
  DateTime creation;

  @override
  bool enabled;

  @override
  int id;

  String username;

  String password;

  Register({
    required this.creation,
    required this.enabled,
    required this.id,
    required this.username,
    required this.password,
  });

  Register copyWith({
    DateTime? creation,
    bool? enabled,
    int? id,
    String? username,
    String? password,
  }) {
    return Register(
      creation: creation ?? this.creation,
      enabled: enabled ?? this.enabled,
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'creation': creation.millisecondsSinceEpoch,
      'enabled': enabled,
      'id': id,
      'username': username,
      'password': password,
    };
  }

  factory Register.fromMap(Map<String, dynamic> map) {
    return Register(
      creation: DateTime.fromMillisecondsSinceEpoch(map['creation']),
      enabled: map['enabled'],
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Register.fromJson(String source) =>
      Register.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Register(creation: $creation, enabled: $enabled, id: $id, username: $username, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Register &&
        other.creation == creation &&
        other.enabled == enabled &&
        other.id == id &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode {
    return creation.hashCode ^
        enabled.hashCode ^
        id.hashCode ^
        username.hashCode ^
        password.hashCode;
  }
}
