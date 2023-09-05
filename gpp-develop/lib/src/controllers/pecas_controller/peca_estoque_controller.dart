import 'package:flutter/cupertino.dart';
import 'package:gpp/src/models/PaginaModel.dart';

import 'package:gpp/src/models/pecas_model/pecas_estoque_model.dart';
import 'package:gpp/src/repositories/pecas_repository/peca_estoque_repository.dart';

class PecaEstoqueController {
  List<PecasEstoqueModel?> pecas_estoque = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PaginaModel paginaModel = PaginaModel(atual: 1, total: 1);
  bool isLoading = false;

  late final PecaEstoqueRepository pecasEstoqueRepository =
      PecaEstoqueRepository();

  Future<PecasEstoqueModel?> buscarEstoque(
      String id_peca, int? id_filial) async {
    return pecasEstoqueRepository.buscarEstoque(id_peca, id_filial.toString());
  }

  Future<bool> consultarEstoque(
      int paginaAtual,
      String filial,
      String id_peca,
      String id_produto,
      String id_fornecedor,
      bool? endereco,
      bool disponivel,
      bool reservado,
      bool transferencia,
      String desc_corredor,
      String desc_estante,
      String desc_prateleira,
      String desc_box) async {
    List lista = await pecasEstoqueRepository.consultarEstoque(
        paginaAtual,
        filial,
        id_peca,
        id_produto,
        id_fornecedor,
        endereco,
        disponivel,
        reservado,
        transferencia,
        desc_corredor,
        desc_estante,
        desc_prateleira,
        desc_box);
    pecas_estoque = lista[0];
    paginaModel = lista[1];
    return true;
  }
}
