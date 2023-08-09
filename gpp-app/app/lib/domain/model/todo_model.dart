import 'dart:convert';

import 'package:auth_migration/base/model/abstract_entity.dart';

class ToDo implements AbstractEntity {
  @override
  int id;

  String title;
  bool done;

  @override
  bool enabled;

  @override
  DateTime creation;

  ToDo({
    required this.title,
    required this.done,
    required this.id,
    required this.enabled,
    required this.creation,
  });

  ToDo copyWith({
    String? title,
    bool? done,
    int? id,
    bool? enabled,
    DateTime? creation,
  }) {
    return ToDo(
      title: title ?? this.title,
      done: done ?? this.done,
      id: id ?? this.id,
      enabled: enabled ?? this.enabled,
      creation: creation ?? this.creation,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'done': done,
      'id': id,
      'enabled': enabled,
      'creation': creation.millisecondsSinceEpoch,
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      title: map['title'],
      done: map['done'],
      id: map['id'],
      enabled: map['enabled'],
      creation: DateTime.parse(map['creation']),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ToDo.fromJson(String source) => ToDo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ToDo(title: $title, done: $done, id: $id, enabled: $enabled, creation: $creation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ToDo &&
        other.title == title &&
        other.done == done &&
        other.id == id &&
        other.enabled == enabled &&
        other.creation == creation;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        done.hashCode ^
        id.hashCode ^
        enabled.hashCode ^
        creation.hashCode;
  }
}
