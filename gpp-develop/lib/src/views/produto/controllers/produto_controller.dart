import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/PaginaModel.dart';

import 'package:gpp/src/models/produto/produto_model.dart';

import 'package:gpp/src/repositories/pecas_repository/produto_repositoy.dart';

import '../../../utils/notificacao.dart';

class ProdutoController extends GetxController {
  String pesquisar = '';
  var carregando = true.obs;
  late ProdutoRepository produtoRepository;
  late List<ProdutoModel> produtos;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PaginaModel pagina;

  int marcados = 0;

  ProdutoController() {
    produtoRepository = ProdutoRepository();
    produtos = <ProdutoModel>[].obs;
    pagina = PaginaModel(atual: 1, total: 0);
  }

  @override
  void onInit() async {
    buscarProdutos();
    super.onInit();
  }

  buscarProdutos() async {
    try {
      carregando(true);

      var retorno = await produtoRepository.buscarProdutos(this.pagina.atual,
          pesquisar: this.pesquisar);

      this.produtos = retorno[0];
      this.pagina = retorno[1];
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      update();
    }
  }
}
