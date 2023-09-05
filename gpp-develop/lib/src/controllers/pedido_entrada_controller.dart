import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/controllers/pecas_controller/fornecedor_controller.dart';
import 'package:gpp/src/models/item_pedido_entrada_model.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/pedido_entrada_model.dart';
import 'package:gpp/src/repositories/pedido_entrada_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:intl/intl.dart';

class Situacao {
  int? id;
  String? descricao;
  Situacao({
    this.id,
    this.descricao,
  });
}

class PedidoEntradaController extends GetxController {
  int? idPedidoEntrada;
  bool pedidoEntradaCriado = false;
  DateTime? dataInicio;
  DateTime? dataFim;
  String? dataInicioRelatorio;
  String? dataFimRelatorio;
  String? idFornecedor;
  late TextEditingController controllerIdFornecedor = TextEditingController();

  Situacao? selecionado;
  PedidoEntradaRepository repository = PedidoEntradaRepository();
  bool carregado = false;
  bool carregandoGerarRelatorio = false;
  var carregandoFornecedor = false.obs;
  List<PedidoEntradaModel> pedidosEntrada = [];
  List<PedidoEntradaModel> relPedidosEntrada = [];
  PedidoEntradaModel pedidoEntrada = PedidoEntradaModel();
  PedidoEntradaModel pedidoEntradaCriadoModel = PedidoEntradaModel();
  GlobalKey<FormState> filtroFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> filtroExpandidoFormKey = GlobalKey<FormState>();
  bool abrirFiltro = false; // false
  bool abrirRelatorio = false; // false
  PaginaModel pagina = PaginaModel(total: 0, atual: 1);
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  FornecedorController fornecedorController = FornecedorController();

  List<ItemPedidoEntradaModel> listaItensPedido = [];

  bool ItensEntradaToItensEntrada(List<ItemPedidoEntradaModel> list) {
    listaItensPedido = list;
    bool sucess = true;

    pedidoEntrada.funcionario = null;
    pedidoEntrada.situacao = 1;
    pedidoEntrada.valorTotal = 0;
    listaItensPedido.forEach((element) {
      if (element.quantidade == null) {
        sucess = false;
      } else {
        pedidoEntrada.valorTotal = (pedidoEntrada.valorTotal! +
            ((element.custo ?? 0.00) * element.quantidade!));
      }
    });

    return sucess;
  }

  Future<bool> criarPedidoManual() async {
    try {
      pedidoEntrada.itensPedidoEntrada = listaItensPedido;
      pedidoEntradaCriadoModel = await repository.criar(pedidoEntrada);
      return true;
    } catch (e) {
      var error = e.toString();
      throw error;
    }
  }

  buscarFornecedores(String? nome) async {
    try {
      List<dynamic> fornecedores =
          await fornecedorController.buscarFornecedores(nome);

      return fornecedores[0];
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      update();
    }
  }

  buscarFornecedor() async {
    try {
      carregandoFornecedor(true);
      await fornecedorController.buscar(controllerIdFornecedor.text);
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoFornecedor(false);
      update();
    }
  }
}
