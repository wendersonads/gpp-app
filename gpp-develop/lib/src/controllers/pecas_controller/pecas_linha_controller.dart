import 'package:flutter/material.dart';
import 'package:gpp/src/models/pecas_model/pecas_linha_model.dart';
import 'package:gpp/src/repositories/pecas_repository/pecas_linha_repository.dart';

class PecasLinhaController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final PecasLinhaRepository pecasLinhaRepository = PecasLinhaRepository();
  PecasLinhaModel pecasLinhaModel = PecasLinhaModel();

  List<PecasLinhaModel>? listaPecasLinhaModel;

  Future<bool> inserir() async {
    return await pecasLinhaRepository.inserir(pecasLinhaModel);
  }

  Future<List<PecasLinhaModel>> buscarTodos() async {
    return await pecasLinhaRepository.buscarTodos();
  }

  Future<List<PecasLinhaModel>> buscarEspecieVinculada(String codigo) async {
    return await pecasLinhaRepository.buscarEspecieVinculada(codigo);
  }

  Future<bool> excluir(PecasLinhaModel pecasLinhaModel) async {
    return await pecasLinhaRepository.excluir(pecasLinhaModel);
  }

  Future<bool> editar() async {
    return await pecasLinhaRepository.editar(pecasLinhaModel);
  }
}
