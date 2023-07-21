import 'package:auth_migration/base/service/abstract_service.dart';
import 'package:auth_migration/domain/model/dto/todo_dto.dart';
import 'package:auth_migration/domain/model/todo_model.dart';

class ToDoService extends AbstractService<ToDo, ToDoDTO> {
  ToDoService() : super('todo');

  @override
  ToDo fromJson(Map<String, dynamic> json) {
    return ToDo.fromMap(json);
  }
}
