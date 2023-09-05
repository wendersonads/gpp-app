import 'package:flutter/cupertino.dart';
import 'package:gpp/src/models/FuncionalidadeModel.dart';
import 'package:gpp/src/repositories/funcionalidade_repository.dart';
import 'package:gpp/src/shared/enumeration/funcionalities_enum.dart';

class FuncionalitiesController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final FuncionalidadeRepository repository = FuncionalidadeRepository();
  List<FuncionalidadeModel> funcionalities = [];
  FuncionalidadeModel funcionalitie = FuncionalidadeModel();
  FuncionalitiesEnum state = FuncionalitiesEnum.notChange;
  bool groupValue = false;

  FuncionalitiesController();

  Future<void> fetch(String id) async {
    funcionalitie = await repository.fetch(id);
  }

  Future<void> fetchAll() async {
    funcionalities = await repository.buscarFuncionalidades();
  }

  void setFuncionalitieName(value) {
    funcionalitie.nome = value;
  }

  void setFuncionalitieIcon(value) {
    funcionalitie.icone = value;
  }

  void setFuncionalitieActive(value) {
    funcionalitie.situacao = value;
  }

  //Validação
  validate(value) {
    if (value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  Future<bool> create() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    return await repository.create(funcionalitie);
  }

  Future<bool> update() async {
    return await repository.update(funcionalitie);
  }

  Future<bool> delete(FuncionalidadeModel funcionalitie) async {
    return await repository.delete(funcionalitie);
  }
}
