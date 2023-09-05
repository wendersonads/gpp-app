import 'package:flutter/material.dart';
import 'package:gpp/src/models/pecas_model/pecas_material_model.dart';
import 'package:gpp/src/repositories/pecas_repository/pecas_material_repository.dart';

class PecasMaterialController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final PecasMaterialRepository pecasMaterialRepository =
      PecasMaterialRepository();
  PecasMaterialModel pecasMaterialModel = PecasMaterialModel();

  Future<bool> inserir() async {
    return await pecasMaterialRepository.inserir(pecasMaterialModel);
  }

  Future<List<PecasMaterialModel>> buscarTodos() async {
    return await pecasMaterialRepository.buscarTodos();
  }

  Future<bool> excluir(PecasMaterialModel pecasMaterialModel) async {
    return await pecasMaterialRepository.excluir(pecasMaterialModel);
  }

  Future<bool> editar() async {
    return await pecasMaterialRepository.editar(pecasMaterialModel);
  }
}
