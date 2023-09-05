import 'package:flutter/material.dart';
import 'package:gpp/src/models/departament_model.dart';
import 'package:gpp/src/models/subfuncionalidade.dart';
import 'package:gpp/src/repositories/DepartamentoRepository.dart';
import 'package:gpp/src/shared/enumeration/departament_enum.dart';

class DepartamentController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DepartamentoRepository repository;
  DepartamentoModel departament = DepartamentoModel();
  List<DepartamentoModel> departaments = [];
  List<SubFuncionalidadeModel> subFuncionalities = [];
  DepartamentEnum state = DepartamentEnum.notDepartament;

  DepartamentController(
    this.repository,
  );

  Future<void> fetch(String id) async {
    departament = await repository.fetch(id);
  }

  Future<void> fetchAll() async {
    departaments.clear();
    departaments = await repository.buscarTodos();
  }

  Future<bool> updateDepartamentSubFuncionalities() async {
    return await repository.updateDepartmentSubFuncionalities(
        departament, subFuncionalities);
  }

  Future<void> changeDepartamentSubFuncionalities(
      DepartamentoModel departament) async {
    subFuncionalities = await repository.fetchSubFuncionalities(departament);
  }

  // Future<bool> insertOrUpdate(DepartamentoModel departament) async {
  //   if (departament.id == null) {
  //     return create(departament);
  //   } else {
  //     return update(departament);
  //   }
  // }

  Future<bool> create() async {
    if (formKey.currentState!.validate()) {
      return await repository.criar(departament);
    }

    return false;
  }

  Future<bool> update() async {
    return await repository.update(departament);
  }

  Future<bool> delete(DepartamentoModel departament) async {
    return await repository.excluir(departament);
  }

  // List<UserModel> usersSearch = [];

  // UserEnum state = UserEnum.notUser;

  // Future<void> changeUser() async {
  //   users = await repository.fetchUser();
  // }

  // void search(String value) {
  //   usersSearch = users
  //       .where((user) =>
  //           (user.name!.toLowerCase().contains(value.toLowerCase()) ||
  //               user.uid!.toLowerCase().contains(value.toLowerCase())))
  //       .toList();
  // }
  validate(value) {
    if (value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
}
