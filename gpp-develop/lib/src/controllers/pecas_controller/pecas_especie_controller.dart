import 'package:flutter/material.dart';
import 'package:gpp/src/models/pecas_model/pecas_especie_model.dart';
import 'package:gpp/src/repositories/pecas_repository/pecas_especie_repository.dart';

class PecasEspecieController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final PecasEspecieRepository pecasEspecieRepository =
      PecasEspecieRepository();
  PecasEspecieModel pecasEspecieModel = PecasEspecieModel();

  Future<bool> create() async {
    return await pecasEspecieRepository.create(pecasEspecieModel);
  }

  Future<List<PecasEspecieModel>> buscarTodos() async {
    return await pecasEspecieRepository.buscarTodos();
  }

  Future<bool> excluir(PecasEspecieModel pecasEspecieModel) async {
    return await pecasEspecieRepository.excluir(pecasEspecieModel);
  }

  Future<bool> editar() async {
    return await pecasEspecieRepository.editar(pecasEspecieModel);
  }
}
