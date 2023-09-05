import 'package:get/get.dart';
import 'package:gpp/src/controllers/asteca_controller.dart';

import 'package:gpp/src/controllers/pedido_entrada_controller.dart';
import 'package:gpp/src/models/cancelamentoModel.dart';

import 'package:gpp/src/models/pecas_model/pecas_estoque_model.dart';
import 'package:gpp/src/models/pedido_entrada_model.dart';
import 'package:gpp/src/models/pedido_saida_model.dart';
import 'package:gpp/src/repositories/AstecaRepository.dart';

import 'package:gpp/src/repositories/pecas_repository/peca_estoque_repository.dart';

import 'package:gpp/src/utils/notificacao.dart';

class AstecaDetalheController extends GetxController {
  var carregando = false.obs;
  var carregandoFinalizacao = false.obs;
  var carregandoEmail = false.obs;
  var cancelando = false.obs;
  late PecaEstoqueRepository pecaEstoqueRepository;
  late List<PecasEstoqueModel> pecaEstoquesAsteca;
  late AstecaRepository astecaRepository;
  late AstecaController astecaControllerGet;
  late PedidoEntradaController pedidoEntracaControllerGet;
  String? idProduto;

  int marcados = 0;

  AstecaDetalheController() {
    pecaEstoquesAsteca = [];
    pecaEstoqueRepository = PecaEstoqueRepository();
    astecaControllerGet = AstecaController();
    pedidoEntracaControllerGet = PedidoEntradaController();
    astecaRepository = AstecaRepository();
  }

  @override
  void onInit() async {
    await buscarPecaEstoquesAsteca();
    super.onInit();
  }

  finalizarPedidoSaida(PedidoSaidaModel pedido) async {
    PedidoSaidaModel pedidoRetorno = PedidoSaidaModel();
    try {
      carregandoFinalizacao(true);
      pedidoRetorno = await astecaControllerGet.pedidoSaidaRepository.criar(pedido);
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoFinalizacao(false);
      update();
      return pedidoRetorno;
    }
  }

  finalizarPedidoEntrada(PedidoEntradaModel pedido) async {
    PedidoEntradaModel pedidoRetorno = PedidoEntradaModel();
    try {
      carregandoFinalizacao(true);
      pedidoRetorno = await pedidoEntracaControllerGet.repository.criar(pedido);
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoFinalizacao(false);
      update();
      return pedidoRetorno;
    }
  }

  Future<void> buscarPecaEstoquesAsteca() async {
    try {
      carregando(true);

      this.pecaEstoquesAsteca = await pecaEstoqueRepository.buscarPecaEstoquesAsteca(idProduto: this.idProduto);
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      update();
    }
  }

  cancelarPedidosAsteca(int idAsteca) async {
    try {
      cancelando(true);

      if (await Notificacao.confirmacao("Deseja realizar o cancelamento dos pedidos vinculados a asteca ${idAsteca}")) {
        CancelamentoModel retorno = await astecaRepository.cancelarPedidosAsteca(idAsteca);

        if (retorno.retorno!) {
          return retorno;
        }
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      cancelando(false);
    }
  }
}
