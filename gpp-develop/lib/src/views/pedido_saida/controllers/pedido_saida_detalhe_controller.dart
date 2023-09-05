
import 'package:get/get.dart';

import 'package:gpp/src/models/pedido_saida_model.dart';
import 'package:gpp/src/repositories/AstecaRepository.dart';

import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:intl/intl.dart';

import '../../../repositories/pedido_saida_repository.dart';

class PedidoSaidaDetalheController extends GetxController {
  late int id;
  var selected = 1.obs;
  var carregandoEmail = false.obs;
  late PedidoSaidaRepository pedidoSaidaRepository;
  late AstecaRepository astecaRepository;
  late PedidoSaidaModel pedidoSaida;
  var carregando = false.obs;
  var carregandoSeparacao = false.obs;
  late MaskFormatter maskFormatter = MaskFormatter();
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  PedidoSaidaDetalheController(int id) {
    pedidoSaidaRepository = PedidoSaidaRepository();
    this.id = id;
    pedidoSaida = PedidoSaidaModel();
    astecaRepository = AstecaRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    await buscarPedidoSaida();
  }

  buscarPedidoSaida() async {
    try {
      carregando(true);
      this.pedidoSaida = await pedidoSaidaRepository.buscarPedidoSaida(id);
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
    }
  }

  encaminharSeparacao() async {
    try {
      carregandoSeparacao(true);
      await pedidoSaidaRepository.encaminharSeparacao(id);
      Get.toNamed('/separacao');
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoSeparacao(false);
    }
  }

  // cancelarPedidoSaida(int idAsteca) async {
  //   try {
  //     CancelamentoModel retorno = await astecaRepository.cancelarPedidosAsteca(idAsteca);
  //     if (retorno.retorno!) {
  //       Notificacao.snackBar('Ordem saída cancelada com sucesso!');

  //       await buscarPedidoSaida();
  //     }
  //   } catch (e) {
  //     Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
  //   } finally {}
  // }

  enviarEmailPedidoSaida() async {
    carregandoEmail(true);
    try {
      if (await pedidoSaidaRepository.enviarEmailFornecedor(pedidoSaida.idPedidoSaida!, pedidoSaida)) {
        Notificacao.snackBar('E-mail enviado com sucesso');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoEmail(false);
    }
  }
}
