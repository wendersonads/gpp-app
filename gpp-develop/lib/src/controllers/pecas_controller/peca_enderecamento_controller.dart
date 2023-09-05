import 'package:flutter/cupertino.dart';
import 'package:gpp/src/models/PaginaModel.dart';

import 'package:gpp/src/models/pecas_model/peca_enderecamento_model.dart';
import 'package:gpp/src/models/pecas_model/pecas_estoque_model.dart';

import 'package:gpp/src/repositories/pecas_repository/peca_estoque_repository.dart';

class PecaEnderecamentoController {
  List<PecaEnderacamentoModel> pecas_enderecamento = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PaginaModel pagina = PaginaModel(total: 1, atual: 1);
  bool isLoading = false;

  late final PecaEstoqueRepository pecaEstoqueRepository =
      PecaEstoqueRepository();

  //late final PecaEnderecamentoRepository pecasEnderecamentoRepository = PecaEnderecamentoRepository();

  /*Future<bool> buscarTodos(int pagina_atual, int? id_filial, int? id_fornecedor, int? id_produto, int? id_peca, int? id_piso,
      int? id_corredor, int? id_estante, int? id_prateleira, int? id_box) async {
    List lista = await pecasEnderecamentoRepository.buscarTodos(
        pagina_atual, id_filial, id_fornecedor, id_produto, id_peca, id_piso, id_corredor, id_estante, id_prateleira, id_box);
    pecas_enderecamento = lista[0];
    pagina = lista[1];
    return true;
  }

  Future<bool> create(PecaEnderacamentoModel pe) async {
    return await pecasEnderecamentoRepository.create(pe);
  }

  Future<bool> editar(PecaEnderacamentoModel pe) async {
    return await pecasEnderecamentoRepository.editar(pe);
  }

  Future<bool> excluir(PecaEnderacamentoModel pe) async {
    return await pecasEnderecamentoRepository.excluir(pe);
  } */

  Future<bool> alterar(PecasEstoqueModel pe) async {
    return await pecaEstoqueRepository.alterarEstoque(pe);
  }
}
