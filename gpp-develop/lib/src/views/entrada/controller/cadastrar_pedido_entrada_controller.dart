import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/pecas_controller/fornecedor_controller.dart';
import 'package:gpp/src/controllers/pedido_entrada_controller.dart';
import 'package:gpp/src/models/item_pedido_entrada_model.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/models/pedido_entrada_model.dart';
import 'package:gpp/src/models/produto_peca_model.dart';
import 'package:gpp/src/repositories/PecaRepository.dart';
import 'package:gpp/src/repositories/pecas_repository/produto_repositoy.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/GerarPedidoEntradaPDF.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:get/get.dart';

class CadastrarPedidoEntradaController extends GetxController {
  late GlobalKey<FormState> filtroFormKey;

  List<String> pedidos = [];

  late TextEditingController controllerIdFornecedor;
  late TextEditingController controllerNomeFornecedor;
  late FornecedorController fornecedorController;
  late List<PecasModel> pecasBusca;
  late List<PecasEntradaManual> pecasPopUp;
  late PecaRepository pecaRepository;
  late ProdutoRepository produtoRepository;
  var carregandoFornecedor = false.obs;
  var carregandoPecas = false.obs;
  var carregandoEntrada = false.obs;
  var carregandoPecasEntrada = false.obs;
  var carregandoEmail = false.obs;
  // late List<ItemMovimentoEntradaModel> listaMovimento;
  late List<ItemPedidoEntradaModel> listaItemPedido;
  var marcados = 0;

  late TextEditingController controllerIdProduto;
  late TextEditingController controllerIdPeca;

  late TextEditingController controllerNotaFiscal;
  late TextEditingController controllerSerie;

  // late MovimentoEntradaController movimentoEntradaController;
  late PedidoEntradaController pedidoEntradaController;

  bool error = false;
  BuildContext? context;

  CadastrarPedidoEntradaController() {
    controllerIdFornecedor = TextEditingController();
    controllerNomeFornecedor = TextEditingController();
    controllerIdProduto = TextEditingController();
    controllerIdPeca = TextEditingController();
    fornecedorController = FornecedorController();
    filtroFormKey = GlobalKey<FormState>();
    pecaRepository = PecaRepository();
    pecasPopUp = <PecasEntradaManual>[].obs;
    pecasBusca = <PecasModel>[].obs;
    // listaMovimento = <ItemMovimentoEntradaModel>[].obs;
    listaItemPedido = <ItemPedidoEntradaModel>[].obs;

    produtoRepository = ProdutoRepository();
    controllerNotaFiscal = TextEditingController();
    controllerSerie = TextEditingController();
    // movimentoEntradaController = MovimentoEntradaController();
    pedidoEntradaController = PedidoEntradaController();
  }

  buscarFornecedor() async {
    try {
      carregandoFornecedor(true);
      await fornecedorController.buscar(controllerIdFornecedor.text);
      controllerNomeFornecedor.text = fornecedorController.fornecedorModel.cliente?.nome.toString() ?? '';
      pedidoEntradaController.pedidoEntrada.idFornecedor = fornecedorController.fornecedorModel.idFornecedor;
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoFornecedor(false);
      update();
    }
  }

  buscarPecas() async {
    pecasBusca.clear();
    if (controllerIdPeca.text.toString() == '' || controllerIdProduto.text.toString() == '') {
      if (controllerIdPeca.text != '') {
        await buscarPecasPorId();
      } else if (controllerIdProduto.text != '') {
        await buscarPecasPorProduto();
      }
    } else {
      Notificacao.snackBar("Somente um filtro de pesquisa por vez!");
    }
    controllerIdPeca.text = '';
    controllerIdProduto.text = '';
    update();
  }

  buscarPecasPorProduto() async {
    try {
      carregandoPecas(true);
      if (controllerIdProduto.text != '' && controllerIdFornecedor.text != '') {
        List<ProdutoPecaModel> produtoPeca = await produtoRepository.buscarProdutoPecasFornecedor(
            int.parse(controllerIdProduto.text), int.parse(controllerIdFornecedor.text));

        for (var item in produtoPeca) {
          item.peca!.produto = item.produto ?? null;
          pecasBusca.add(item.peca!);
        }
      }
      gerarPecas();
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoPecas(false);
      update();
    }
  }

  buscarPecasPorId() async {
    try {
      carregandoPecas(true);
      if (controllerIdPeca.text != '' && controllerIdFornecedor.text != '') {
        pecasBusca.add(
            await pecaRepository.buscarPecaFornecedor(int.parse(controllerIdPeca.text), int.parse(controllerIdFornecedor.text)));
      }
      gerarPecas();
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoPecas(false);
      update();
    }
  }

  gerarPecas() {
    pecasBusca.forEach((element) {
      pecasPopUp.add(PecasEntradaManual(marcado: false, peca: element));
    });
  }

  marcarTodosCheckbox(bool value) {
    if (value) {
      marcados = pecasBusca.length;
    } else {
      marcados = 0;
    }
    for (var itemPedido in pecasPopUp) {
      itemPedido.marcado = value;
    }
  }

  marcarCheckbox(index, value) {
    if (value) {
      marcados++;
    } else {
      marcados--;
    }
    pecasPopUp[index].marcado = value;
  }

  adicionarPecasParaEntrada() {
    carregandoPecasEntrada(true);
    bool notifica = true;

    for (var item in pecasPopUp) {
      if (item.marcado!) {
        if (listaItemPedido.any((element) => element.peca!.id_peca == item.peca!.id_peca)) {
          notifica = false;
        } else {
          // ItemMovimentoEntradaModel itemMovimento = new ItemMovimentoEntradaModel();
          // itemMovimento.pecaModel = item.peca!;
          // listaMovimento.add(itemMovimento);
          ItemPedidoEntradaModel itemPedido = new ItemPedidoEntradaModel();
          itemPedido.peca = item.peca!;
          listaItemPedido.add(itemPedido);
        }
      }
    }

    Get.back();
    notifica ? Container() : Notificacao.snackBar("Algumas peças não foram adicionadas porque já estão na lista");
    carregandoPecasEntrada(false);
    update();
  }

  removerPecasEntrada(ItemPedidoEntradaModel item) {
    carregandoPecasEntrada(true);
    listaItemPedido.remove(item);
    // Notificacao.snackBar("Peça Removida com sucesso!");
    carregandoPecasEntrada(false);
    update();
  }

  CriarPedidoEntrada() async {
    carregandoEntrada(true);
    bool success = false;
    if (listaItemPedido.isEmpty) {
      Notificacao.snackBar('É necessário adicionar as peças para criar uma ordem de entrada!');
    } else {
      success = pedidoEntradaController.ItensEntradaToItensEntrada(listaItemPedido);
      if (success) {
        try {
          if (await pedidoEntradaController.criarPedidoManual()) {
            Notificacao.snackBar('Ordem de entrada criada com sucesso');
            exibirComprovantePedidoEntrada(pedidoEntradaController.pedidoEntradaCriadoModel, context!);
          }
        } catch (e) {
          Notificacao.snackBar(e.toString());
        }
      } else {
        Notificacao.snackBar('Existem peças com a quantidade necessária não informada!');
      }
    }
    carregandoEntrada(false);

    update();
    return success;
  }

  myShowDialog(String text) {
    return showDialog(
        context: context!,
        builder: (context) {
          return AlertDialog(actions: <Widget>[
            Padding(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber, color: Colors.amber, size: 45.0),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        TextComponent(
                          text,
                          fontSize: 20.0,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonComponent(
                            color: primaryColor,
                            colorHover: primaryColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: 'Ok'),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    )
                  ],
                ),
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0))
          ]);
        });
  }

  enviarEmailPedidoEntrada(PedidoEntradaModel pedidoEntrada) async {
    try {
      carregandoEmail(true);
      if (await pedidoEntradaController.repository.enviarEmailFornecedor(pedidoEntrada.idPedidoEntrada!, pedidoEntrada)) {
        myShowDialog('E-mail enviado com sucesso');
        //await Future.delayed(Duration(seconds: 3));
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoEmail(false);
    }
  }

  exibirComprovantePedidoEntrada(PedidoEntradaModel pedidoEntrada, BuildContext context) {
    //Notificação
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(actions: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextComponent(
                    'Nº Ordem de Entrada: #${pedidoEntrada.idPedidoEntrada}',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Wrap(
                    children: [
                      TextComponent(
                          'Nome do fornecedor: ${pedidoEntrada.itensPedidoEntrada?.first.peca?.produtoPeca?.first.produto?.fornecedores?.first.cliente?.nome.toString() ?? ''}'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                ButtonComponent(
                    color: primaryColor,
                    colorHover: primaryColorHover,
                    onPressed: () async {
                      Get.delete<CadastrarPedidoEntradaController>();
                      Get.delete<CadastrarPedidoEntradaController>();
                      Get.offAndToNamed('/ordens-entrada');
                    },
                    text: 'Ok'),
                SizedBox(
                  width: 8,
                ),
                ButtonComponent(
                    color: secundaryColor,
                    colorHover: secundaryColorHover,
                    icon: Icon(
                      Icons.print,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      GerarPedidoEntradaPDF(pedidoEntrada: pedidoEntrada).imprimirPDF();
                    },
                    text: 'Imprimir'),
                SizedBox(
                  width: 8,
                ),
                Obx(
                  () => !carregandoEmail.value
                      ? ButtonComponent(
                          color: secundaryColor,
                          colorHover: secundaryColorHover,
                          icon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await enviarEmailPedidoEntrada(pedidoEntrada);
                          },
                          text: 'Enviar e-mail')
                      : LoadingComponent(),
                ),
              ],
            )
          ]);
        });
  }
}

class PecasEntradaManual {
  bool? marcado = false;
  late PecasModel? peca;
  PecasEntradaManual({
    this.marcado,
    this.peca,
  });
}
