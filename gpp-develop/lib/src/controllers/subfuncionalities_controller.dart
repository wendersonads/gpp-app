import 'package:flutter/cupertino.dart';
import 'package:gpp/src/models/FuncionalidadeModel.dart';
import 'package:gpp/src/models/subfuncionalidade.dart';
import 'package:gpp/src/repositories/SubFuncionalidadeRepository.dart';
import 'package:gpp/src/shared/enumeration/subfuncionalities_enum.dart';

class SubFuncionalitiesController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final SubFuncionalidadeRepository repository =
      SubFuncionalidadeRepository();

  List<SubFuncionalidadeModel> subFuncionalities = [];

  SubFuncionalidadeModel subFuncionalitie = SubFuncionalidadeModel();
  SubFuncionalitiesEnum state = SubFuncionalitiesEnum.notChange;
  // bool groupValue = false;

  SubFuncionalitiesController();

  Future<void> fetch(String id) async {
    subFuncionalities = await repository.fetch(id);
  }

  void setSubFuncionalitieName(value) {
    subFuncionalitie.nome = value;
  }

  void setSubFuncionalitieRoute(value) {
    subFuncionalitie.rota = value;
  }

  void setSubFuncionalitieActive(value) {
    subFuncionalitie.situacao = value;
  }

  // //Validação
  validate(value) {
    if (value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  Future<bool> create(String id) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    formKey.currentState!.save();

    return await repository.create(id, subFuncionalitie);
  }

  Future<bool> update(SubFuncionalidadeModel subFuncionalitie) async {
    return await repository.update(subFuncionalitie);
  }

  Future<bool> delete(FuncionalidadeModel funcionalidade,
      SubFuncionalidadeModel subFuncionalitie) async {
    return await repository.delete(funcionalidade, subFuncionalitie);
  }
}
