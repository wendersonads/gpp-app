import 'package:flutter/material.dart';
import 'package:gpp/src/models/pecas_model/pecas_grupo_model.dart';
import 'package:gpp/src/repositories/pecas_repository/pecas_grupo_repository.dart';

class PecasGrupoController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final PecasGrupoRepository pecasGrupoRepository = PecasGrupoRepository();
  PecasGrupoModel pecasGrupoModel = PecasGrupoModel();

  Future<bool> create() async {
    return await pecasGrupoRepository.create(pecasGrupoModel);
  }

  Future<List<PecasGrupoModel>> buscarTodos() async {
    return await pecasGrupoRepository.buscarTodos();
  }

  Future<bool> excluir(PecasGrupoModel pecasGrupoModel) async {
    return await pecasGrupoRepository.excluir(pecasGrupoModel);
  }

  Future<bool> editar() async {
    return await pecasGrupoRepository.editar(pecasGrupoModel);
  }
}
