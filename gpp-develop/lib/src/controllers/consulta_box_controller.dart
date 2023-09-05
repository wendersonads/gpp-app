import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/CapacidadeEstoqueModel.dart';
import 'package:gpp/src/models/PaginaModel.dart';

import 'package:gpp/src/repositories/CapacidadeEstoqueRepository.dart';

import 'package:gpp/src/utils/notificacao.dart';

class ConsultaBoxController extends GetxController {
  String pesquisar = '';
  var carregando = true.obs;
  late CapacidadeEstoqueRepository capacidadeEstoqueRepository;
  late List<CapacidadeEstoqueModel> boxes;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PaginaModel pagina;

  int marcados = 0;

  ConsultaBoxController() {
    capacidadeEstoqueRepository = CapacidadeEstoqueRepository();
    boxes = <CapacidadeEstoqueModel>[].obs;
    pagina = PaginaModel(atual: 1, total: 0);
  }

  @override
  void onInit() async {
    buscarBoxes();
    super.onInit();
  }

  buscarBoxes() async {
    try {
      carregando(true);

      var retorno = await capacidadeEstoqueRepository
          .consultaCapacidade(this.pagina.atual, pesquisar: this.pesquisar);

      this.boxes = retorno[0];
      this.pagina = retorno[1];
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      update();
    }
  }

  // buscarProdutos() async {
  //   try {
  //     carregando(true);

  //     var retorno = await produtoRepository.buscarProdutos(this.pagina.atual,
  //         pesquisar: this.pesquisar);

  //     this.produtos = retorno[0];
  //     this.pagina = retorno[1];
  //   } catch (e) {
  //     Notificacao.snackBar(e.toString(),
  //         tipoNotificacao: TipoNotificacaoEnum.error);
  //   } finally {
  //     carregando(false);
  //     update();
  //   }
  // }

}
