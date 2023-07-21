import 'dart:convert';

import 'package:auth_migration/base/model/abstract_dto.dart';

class ToDoDTO extends AbstractDTO {
  String title;

  ToDoDTO({
    required this.title,
  });

  ToDoDTO copyWith({
    String? title,
  }) {
    return ToDoDTO(
      title: title ?? this.title,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }

  factory ToDoDTO.fromMap(Map<String, dynamic> map) {
    return ToDoDTO(
      title: map['title'],
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ToDoDTO.fromJson(String source) =>
      ToDoDTO.fromMap(json.decode(source));

  @override
  String toString() => 'ToDoDTO(title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ToDoDTO && other.title == title;
  }

  @override
  int get hashCode => title.hashCode;
}
