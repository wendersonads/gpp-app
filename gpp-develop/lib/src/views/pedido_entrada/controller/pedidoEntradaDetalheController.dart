import 'package:gpp/src/models/pedido_entrada_model.dart';
import 'package:gpp/src/repositories/pedido_entrada_repository.dart';

import 'package:gpp/src/utils/notificacao.dart';
import 'package:get/get.dart';

class PedidoEntradaDetalheController extends GetxController {
  var carregandoEmail = false.obs;
  late PedidoEntradaRepository pedidoEntradaRepository;

  PedidoEntradaDetalheController() {
    pedidoEntradaRepository = PedidoEntradaRepository();
  }

  enviarEmailPedidoEntrada(PedidoEntradaModel pedidoConfirmacao) async {
    carregandoEmail(true);
    try {
      if (await pedidoEntradaRepository.enviarEmailFornecedor(pedidoConfirmacao.idPedidoEntrada!, pedidoConfirmacao)) {
        Notificacao.snackBar('E-mail enviado com sucesso');
        //await Future.delayed(Duration(seconds: 3));
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoEmail(false);
    }
  }
}
