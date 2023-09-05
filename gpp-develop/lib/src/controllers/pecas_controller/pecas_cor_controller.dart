import 'package:flutter/material.dart';
import 'package:gpp/src/models/pecas_model/pecas_cor_model.dart';
import 'package:gpp/src/repositories/pecas_repository/pecas_cor_repository.dart';

class PecasCorController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final PecasCorRepository pecasCorRepository = PecasCorRepository();
  PecasCorModel pecasCorModel = PecasCorModel();

  List<PecasCorModel> listaPecasCorModel = [];

  Future<bool> create() async {
    return await pecasCorRepository.create(pecasCorModel);
  }

  Future<bool> editar() async {
    return await pecasCorRepository.editar(pecasCorModel);
  }

  Future<List<PecasCorModel>> buscarTodos() async {
    return await pecasCorRepository.buscarTodos();
  }

  Future<void> buscarTodos2() async {
    listaPecasCorModel = await pecasCorRepository.buscarTodos();
  }

  Future<bool> excluir(PecasCorModel pecasCorModel) async {
    return await pecasCorRepository.excluir(pecasCorModel);
  }
}
