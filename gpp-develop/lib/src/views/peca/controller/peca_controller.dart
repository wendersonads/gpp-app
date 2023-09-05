import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/repositories/PecaRepository.dart';
import 'package:gpp/src/shared/enumeration/estoque_enum.dart';

import '../../../utils/notificacao.dart';

class PecaController extends GetxController {
  late List<PecasModel> pecas;
  String idProduto = '';
  var carregando = true.obs;
  var filtro = false.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PecaRepository pecaRepository;
  late PaginaModel pagina;
  String buscar = '';

  PecaController() {
    pecas = <PecasModel>[].obs;
    pecaRepository = PecaRepository();
    pagina = PaginaModel(atual: 1, total: 0);
  }

  @override
  void onInit() async {
    await buscarPecas();
    super.onInit();
  }

  buscarPecas() async {
    try {
      carregando(true);
      var resposta = await pecaRepository.buscarPecas(pagina.atual, buscar: buscar, idProduto: idProduto);
      pecas = resposta[0];
      pagina = resposta[1];
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
      buscar = '';
      idProduto = '';
      pecas.clear();
      formKey.currentState!.reset();
    } finally {
      carregando(false);
      update();
    }
  }

  verificarEstoque(PecasModel peca) {
    var saldoDisponivel = 0;
    var quantidadeMinima = 0;

    if (peca.estoque!.length == 0) {
      return EstoqueEnum.SEM_ESTOQUE;
    }

    peca.estoque!.forEach((element) {
      saldoDisponivel += element.saldoDisponivel;
      quantidadeMinima += element.quantidadeMinima!;
    });

    if (saldoDisponivel > quantidadeMinima) {
      return EstoqueEnum.ESTOQUE_REGULAR;
    } else {
      return EstoqueEnum.ESTOQUE_MINIMO;
    }
  }
}
