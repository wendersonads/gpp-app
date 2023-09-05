import 'package:get/get.dart';
import 'package:gpp/src/controllers/entrada/movimento_entrada_controller.dart';
import 'package:gpp/src/models/item_pedido_entrada_model.dart';
import 'package:gpp/src/models/entrada/movimento_entrada_model.dart';
import 'package:gpp/src/models/pedido_entrada_model.dart';
import 'package:gpp/src/repositories/entrada/movimento_entrada_repository.dart';

class EntradaHistoricoDetalheController extends GetxController {
  late MovimentoEntradaModel movimentoEntradaModel;
  late MovimentoEntradaController movimentoEntradaController;
  late MovimentoEntradaRepository repository;
  late var carregandoRelatorio = false.obs;
  late MovimentoEntradaModel relatorio;
  late List<ItemPedidoEntradaModel> itensPedidos;
  late int idMovimento;
  var carregandoMovimento = false.obs;

  EntradaHistoricoDetalheController(int idMovimento) {
    repository = MovimentoEntradaRepository();
    itensPedidos = <ItemPedidoEntradaModel>[].obs;
    this.idMovimento = idMovimento;
    this.movimentoEntradaModel = MovimentoEntradaModel();
    this.movimentoEntradaController = MovimentoEntradaController();
    relatorio = MovimentoEntradaModel();
  }

  @override
  void onInit() async {
    await buscarHistoricoMovimentoEntrada();
    super.onInit();
  }

  buscarHistoricoMovimentoEntrada() async {
    try {
      carregandoMovimento(true);
      this.movimentoEntradaModel = await movimentoEntradaController.buscar(this.idMovimento);
    } catch (e) {
      var error = e.toString();
      throw error;
    } finally {
      carregandoMovimento(false);
    }
  }

  carregarRelatorioPedidosMovimento() async {
    try {
      carregandoRelatorio(true);
      relatorio = await repository.relPedidosMovimento(this.idMovimento);
    } catch (e) {
      var error = e.toString();
      throw error;
    } finally {
      carregandoRelatorio(false);
    }
  }

  List<ItemPedidoEntradaModel> itensPedidosToList(List<PedidoEntradaModel>? pedidos) {
    pedidos?.forEach((element) {
      element.itensPedidoEntrada?.forEach((element) {
        itensPedidos.add(element);
      });
    });
    return itensPedidos;
  }
}
