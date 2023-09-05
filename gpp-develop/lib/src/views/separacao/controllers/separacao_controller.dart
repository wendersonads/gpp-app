import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/pedido_saida_model.dart';

import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:intl/intl.dart';

import '../../../repositories/pedido_saida_repository.dart';
import '../../../utils/notificacao.dart';

class SeparacaoController extends GetxController {
  String pesquisar = '';
  var carregando = true.obs;
  late PedidoSaidaRepository pedidoSaidaRepository;
  late List<PedidoSaidaModel> pedidosSaida;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PaginaModel pagina;
  late MaskFormatter maskFormatter = MaskFormatter();
  var filtro = false.obs;
  int marcados = 0;
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  late TextEditingController controllerIdPedido;
  DateTime? dataInicio;
  DateTime? dataFim;

  SeparacaoController() {
    pedidoSaidaRepository = PedidoSaidaRepository();
    pedidosSaida = <PedidoSaidaModel>[].obs;
    pagina = PaginaModel(atual: 1, total: 0);
    controllerIdPedido = TextEditingController();
  }

  limparFiltros() {
    controllerIdPedido.clear();
    dataInicio = null;
    dataFim = null;
  }

  @override
  void onInit() async {
    buscarPedidosSaidaSeparacao();
    super.onInit();
  }

  buscarPedidosSaidaSeparacao() async {
    try {
      carregando(true);

      var retorno = await pedidoSaidaRepository.buscarPedidosSaidaSeparacao(
        this.pagina.atual,
        idPedido: controllerIdPedido.text != '' ? int.parse(controllerIdPedido.text) : null,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );

      this.pedidosSaida = retorno[0];
      this.pagina = retorno[1];
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      update();
    }
  }
}
