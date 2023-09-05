import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gpp/src/controllers/entrada/movimento_entrada_controller.dart';
import 'package:gpp/src/controllers/pedido_entrada_controller.dart';
import 'package:gpp/src/models/pedido_entrada_model.dart';
import 'package:gpp/src/utils/notificacao.dart';

class EntradaPedidoController extends GetxController {
  late PedidoEntradaController pedidoEntradaController;
  late MovimentoEntradaController movimentoEntradaController;
  late List<PedidoEntradaModel> pedidosEntradaBusca;
  late List<ItemPedidoEntrada> itemsPopUpPedidos;
  var carregando = true.obs;
  var carregandoEntrada = false.obs;
  var carregandoPedidos = false.obs;
  int selected = 1;
  var marcados = 0;
  var abrirFiltro = false.obs;

  late GlobalKey<FormState> filtroFormKey;

  late TextEditingController controllerNotaFiscal;
  late TextEditingController controllerSerie;

  late TextEditingController controllerIdPedido;
  late TextEditingController controllerIdFornecedor;
  late TextEditingController controllerNomeFornecedor;

  EntradaPedidoController() {
    pedidoEntradaController = PedidoEntradaController();
    pedidosEntradaBusca = <PedidoEntradaModel>[].obs;
    itemsPopUpPedidos = <ItemPedidoEntrada>[].obs;
    movimentoEntradaController = MovimentoEntradaController();
    filtroFormKey = GlobalKey<FormState>();

    controllerNotaFiscal = TextEditingController();
    controllerSerie = TextEditingController();

    controllerIdPedido = TextEditingController();
    controllerIdFornecedor = TextEditingController();
    controllerNomeFornecedor = TextEditingController();
  }

  @override
  void onInit() {
    super.onInit();
  }

  adicionarPedido(int numPedido) async {
    bool valida = false;
    PedidoEntradaModel pedidoEntradaBusca;

    try {
      carregando(true);
      pedidoEntradaBusca = await pedidosEntradaBusca.firstWhere((element) =>
          element.idPedidoEntrada ==
          numPedido); //await pedidoEntradaController.repository.buscarPedidoEntrada(numPedido);

      //Testa se fornecedor ja foi carregado e o carrega caso não
      if (movimentoEntradaController.id_fornecedor == null) {
        movimentoEntradaController.id_fornecedor = pedidoEntradaBusca
                .asteca
                ?.compEstProd
                ?.first
                .produto
                ?.fornecedores
                ?.first
                .idFornecedor ??
            pedidosEntradaBusca.first.itensPedidoEntrada?.first.peca
                ?.produtoPeca?.first.produto?.fornecedores?.first.idFornecedor;
      }

      //Testa se o fornecedor do pedido buscado é o mesmo do já indexado
      if (movimentoEntradaController.id_fornecedor ==
          (pedidoEntradaBusca.asteca?.compEstProd?.first.produto?.fornecedores
                  ?.first.idFornecedor ??
              pedidosEntradaBusca
                  .first
                  .itensPedidoEntrada
                  ?.first
                  .peca
                  ?.produtoPeca
                  ?.first
                  .produto
                  ?.fornecedores
                  ?.first
                  .idFornecedor)) {
        //Testa se o pedido ja foi adicionado
        if (pedidoEntradaController.pedidosEntrada.any((element) =>
            element.idPedidoEntrada == pedidoEntradaBusca.idPedidoEntrada)) {
          Notificacao.snackBar('Pedido já adicionado!');
          buscarPedidosEntrada();
        } else {
          pedidoEntradaController.pedidosEntrada.insert(
              pedidoEntradaController.pedidosEntrada.length,
              pedidoEntradaBusca);
          movimentoEntradaController.somarLista(
              pedidoEntradaController.pedidosEntrada.last.itensPedidoEntrada);
          movimentoEntradaController.movimentoEntradaModel?.id_pedido_entrada!
              .insert(
                  movimentoEntradaController
                      .movimentoEntradaModel!.id_pedido_entrada!.length,
                  pedidoEntradaBusca.idPedidoEntrada!);
          marcados = 0;
          valida = true;
        }
      } else {
        Notificacao.snackBar('Pedido não pertence ao mesmo fornecedor!');
        buscarPedidosEntrada();
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregando(false);
      update();
      return valida;
    }
  }

  removerPedido(int? id_pedido) {
    try {
      carregando(true);
      int index = pedidoEntradaController.pedidosEntrada.indexWhere((element) =>
          element.idPedidoEntrada == id_pedido); //Pega o indice do pedido
      movimentoEntradaController.subtrairLista(pedidoEntradaController
          .pedidosEntrada[index]
          .itensPedidoEntrada); //Subtrai o remove a quantidade dos itens
      pedidoEntradaController.pedidosEntrada.removeAt(index); //Remove o pedido

      Notificacao.snackBar('Pedido removido com sucesso!');

      //verifica se todos os pedidos foram excluidos e remove o fornecedor
      if (pedidoEntradaController.pedidosEntrada.length == 0) {
        movimentoEntradaController.id_fornecedor = null;
      }
    } catch (e) {
      Notificacao.snackBar('Erro ao remover pedido');
    } finally {
      carregando(false);
      update();
    }
  }

  buscarPedidosEntrada() async {
    try {
      carregandoPedidos(true);
      var resposta = await pedidoEntradaController.repository
          .buscarEntradaPedido(
              idPedido: controllerIdPedido.text == ''
                  ? null
                  : int.parse(controllerIdPedido.text),
              idFornecedor: controllerIdFornecedor.text == ''
                  ? null
                  : int.parse(controllerIdFornecedor.text),
              nomeFornecedor: controllerNomeFornecedor.text == ''
                  ? null
                  : controllerNomeFornecedor.text);

      pedidosEntradaBusca = resposta;

      gerarPedidosEntrada();
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoPedidos(false);
      marcados = 0;
      update();
    }
  }

  lancarEntrada() async {
    carregandoEntrada(true);
    bool success = false;
    if (controllerNotaFiscal.text == '' || controllerSerie.text == '') {
      Notificacao.snackBar('Numero da Nota Fiscal e Série são obrigatórios!');
    } else if (movimentoEntradaController.listaItensSomados.isEmpty) {
      Notificacao.snackBar(
          'É necessário adicionar as peças para dar a entrada!');
    } else {
      movimentoEntradaController.movimentoEntradaModel?.num_nota_fiscal =
          int.parse(controllerNotaFiscal.text);
      movimentoEntradaController.movimentoEntradaModel?.serie =
          controllerSerie.text;
      success = movimentoEntradaController.ItensPedidoToItensEntrada();
      if (success) {
        try {
          if (await movimentoEntradaController.create()) {
            Notificacao.snackBar('Entrada realizada com sucesso');
          }
        } catch (e) {
          Notificacao.snackBar(e.toString());
        }
      } else {
        Notificacao.snackBar(
            'Existem items com a quantidade recebida não informada!');
      }
    }
    carregandoEntrada(false);
    update();
    return success;
  }

  marcarTodosCheckbox(bool value) {
    if (value) {
      marcados = pedidosEntradaBusca.length;
    } else {
      marcados = 0;
    }
    for (var itemPedido in itemsPopUpPedidos) {
      itemPedido.marcado = value;
    }
  }

  marcarCheckbox(index, value) {
    if (value) {
      marcados++;
    } else {
      marcados--;
    }
    itemsPopUpPedidos[index].marcado = value;
  }

  gerarPedidosEntrada() {
    pedidosEntradaBusca.forEach((element) {
      itemsPopUpPedidos
          .add(ItemPedidoEntrada(marcado: false, pedidoEntrada: element));
    });
  }

  adicionarPedidosParaEntrada() async {
    bool valida = validaMesmoFornecedor();
    bool validaAdicao = false;
    if (valida) {
      for (var item in itemsPopUpPedidos) {
        if (item.marcado!) {
          validaAdicao =
              await adicionarPedido(item.pedidoEntrada!.idPedidoEntrada!);
        }
      }
      if (validaAdicao) {
        Get.back();
      }
    } else {
      Notificacao.snackBar("Todos os pedidos devem ser do mesmo Fornecedor");
      marcados = 0;
      buscarPedidosEntrada();
    }
    update();

    return valida;
  }

  validaMesmoFornecedor() {
    ItemPedidoEntrada ip = ItemPedidoEntrada();
    bool sucess = true;
    for (var item in itemsPopUpPedidos) {
      if (item.marcado!) {
        if (ip.pedidoEntrada != null) {
          if ((ip.pedidoEntrada?.asteca?.compEstProd?.first.produto
                      ?.fornecedores?.first.idFornecedor ??
                  ip.pedidoEntrada?.itensPedidoEntrada?.first.peca?.produtoPeca
                      ?.first.produto?.fornecedores?.first.idFornecedor) !=
              (item.pedidoEntrada?.asteca?.compEstProd?.first.produto
                      ?.fornecedores?.first.idFornecedor ??
                  item
                      .pedidoEntrada
                      ?.itensPedidoEntrada
                      ?.first
                      .peca
                      ?.produtoPeca
                      ?.first
                      .produto
                      ?.fornecedores
                      ?.first
                      .idFornecedor)) {
            sucess = false;
            break;
          }
        }
        ip = item;
      }
    }
    return sucess;
  }
}

class ItemPedidoEntrada {
  bool? marcado = false;
  late PedidoEntradaModel? pedidoEntrada;
  ItemPedidoEntrada({
    this.marcado,
    this.pedidoEntrada,
  });
}
