import 'package:flutter/material.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';

import 'package:gpp/src/models/produto_peca_model.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';

import '../../repositories/PecaRepository.dart';
import '../../repositories/pecas_repository/produto_repositoy.dart';

class PecaController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<PecasModel> pecas = [];
  late final PecaRepository pecaRepository;
  late final ProdutoRepository produtoRepository;
  PecasModel pecasModel = PecasModel();
  List<PecasModel> listaPecas = [];
  PaginaModel pagina = PaginaModel(total: 0, atual: 1);

  bool carregado = false;
  late MaskFormatter maskFormatter = MaskFormatter();

  late ProdutoPecaModel produtoPecaModel;

  PecaController() {
    pecaRepository = PecaRepository();
    produtoRepository = ProdutoRepository();
    produtoPecaModel = ProdutoPecaModel();
  }

  Future<PecasModel> criarPeca() async {
    return await pecaRepository.criarPeca(pecasModel);
  }

  Future<bool> criarProdutoPeca() async {
    return await pecaRepository.criarProdutoPeca(produtoPecaModel);
  }

  Future<List> buscarTodos(int pagina) async {
    return await pecaRepository.buscarPecas(pagina);
  }

  Future<PecasModel> buscar(String codigo) async {
    return await pecaRepository.buscarPeca(int.parse(codigo));
  }

  Future<bool> excluir(PecasModel pecasModel) async {
    return await pecaRepository.excluir(pecasModel);
  }

  Future<bool> editar() async {
    return await pecaRepository.editar(pecasModel);
  }

  Future<bool> editarProdutoPeca() async {
    return await pecaRepository.editarProdutoPeca(produtoPecaModel);
  }
}
