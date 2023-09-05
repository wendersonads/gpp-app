import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/CheckboxComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/utils/CurrencyPtBrInputFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/entrada/controller/entrada_pedido_controller.dart';

import '../../../shared/components/TextComponent.dart';
import '../../../shared/components/TitleComponent.dart';
import '../../../shared/repositories/styles.dart';

class EntradaPedidoViewMobile extends StatefulWidget {
  const EntradaPedidoViewMobile({Key? key}) : super(key: key);

  @override
  _EntradaPedidoViewState createState() => _EntradaPedidoViewState();
}

class _EntradaPedidoViewState extends State<EntradaPedidoViewMobile> {
  final controller = Get.put(EntradaPedidoController());
  final List<TextEditingController> controllerQtdRecebida = [];
  final List<TextEditingController> controllerCustoPeca = [];

  @override
  Widget build(BuildContext context) {
    double FONTEBASE = 18;
    Size media = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        controller: new ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 10)),
                Flexible(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      controller: controller.controllerNotaFiscal,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nota Fiscal',
                        // labelText: 'Nota Fiscal',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(top: 15, bottom: 8, left: 8),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                Flexible(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      controller: controller.controllerSerie,
                      //maxLength: 2,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Série',
                        // labelText: 'Série',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(top: 15, bottom: 10, left: 10),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Flexible(
                  child: Obx(
                    () => !controller.carregandoPedidos.value
                        ? ButtonComponent(
                            color: primaryColor,
                            colorHover: primaryColorHover,
                            onPressed: () {
                              exibirPedidos(context);
                            },
                            text: 'Adicionar',
                          )
                        : LoadingComponent(),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 30)),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            Obx(() => !controller.carregando.value
                ? controller.pedidoEntradaController.pedidosEntrada.isEmpty
                    ? Container()
                    : Container(
                        height: 70,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller
                              .pedidoEntradaController.pedidosEntrada.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Container(
                                  width: 120,
                                  child: Card(
                                    color: secundaryColor,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Pedido\n' +
                                                controller
                                                    .pedidoEntradaController
                                                    .pedidosEntrada[index]
                                                    .idPedidoEntrada
                                                    .toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              //fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            onPressed: () {
                                              controller.removerPedido(
                                                  controller
                                                      .pedidoEntradaController
                                                      .pedidosEntrada[index]
                                                      .idPedidoEntrada);
                                            },
                                            hoverColor: Colors.transparent,
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                : Container()),
            Obx(
              () => !controller.carregando.value
                  ? Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 15)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.handyman,
                                size: 32,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              const TitleComponent('Peças'),
                              //new Spacer(),
                              //ButtonComponent(onPressed: () {}, text: 'Adicionar Peça'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: media.height / 3,
                          child: ListView.builder(
                            primary: false,
                            itemCount: controller.movimentoEntradaController
                                .listaItensSomados.length,
                            itemBuilder: (context, index) {
                              controllerQtdRecebida
                                  .add(new TextEditingController(text: ''));
                              controllerCustoPeca
                                  .add(new TextEditingController(text: ''));
                              return Card(
                                child: Container(
                                  // decoration: BoxDecoration(border: Border.all()),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  child: Column(
                                    children: [
                                      Container(
                                        //  decoration: BoxDecoration(border: Border.all()),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'ID Pedido: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: FONTEBASE),
                                                  ),
                                                  Text(
                                                    controller
                                                            .movimentoEntradaController
                                                            .listaItensSomados[
                                                                index]
                                                            .peca
                                                            ?.id_peca
                                                            .toString() ??
                                                        '-',
                                                    style: TextStyle(
                                                        fontSize: FONTEBASE),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        //  decoration: BoxDecoration(border: Border.all()),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Descrição ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: FONTEBASE),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      controller
                                                              .movimentoEntradaController
                                                              .listaItensSomados[
                                                                  index]
                                                              .peca
                                                              ?.descricao ??
                                                          '-',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: FONTEBASE),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // decoration: BoxDecoration(border: Border.all()),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Qtde. Pedida: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: FONTEBASE),
                                                  ),
                                                  Text(
                                                    controller
                                                            .movimentoEntradaController
                                                            .listaItensSomados[
                                                                index]
                                                            .id_pedido_entrada
                                                            ?.toString() ??
                                                        '-',
                                                    style: TextStyle(
                                                        fontSize: FONTEBASE),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // decoration: BoxDecoration(border: Border.all()),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Qtde. Recebida: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: FONTEBASE),
                                                  ),
                                                  Text(
                                                    controller
                                                        .movimentoEntradaController
                                                        .listaItensSomados[
                                                            index]
                                                        .quantidade
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: FONTEBASE),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // decoration: BoxDecoration(border: Border.all()),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: 'Qtd',
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            top: 5,
                                                            bottom: 5,
                                                            left: 5,
                                                            right: 5),
                                                  ),
                                                  controller:
                                                      controllerQtdRecebida[
                                                          index],
                                                  onChanged: (value) {
                                                    controller
                                                            .movimentoEntradaController
                                                            .listaItensSomados[
                                                                index]
                                                            .quantidade_recebida =
                                                        int.parse(
                                                            controllerQtdRecebida[
                                                                    index]
                                                                .text);

                                                    /* if (value == '')
                                                      controller.movimentoEntradaController.listaItensSomados[index]
                                                          .quantidade_recebida = null;
                                                    else
                                                      controller.movimentoEntradaController.listaItensSomados[index]
                                                          .quantidade_recebida = int.parse(value ?? ''); */
                                                  },
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5)),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    CurrencyPtBrInputFormatter()
                                                  ],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: '0,00',
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            top: 5,
                                                            bottom: 5,
                                                            left: 5,
                                                            right: 5),
                                                    prefixText: 'R\$ ',
                                                  ),
                                                  controller:
                                                      controllerCustoPeca[
                                                          index],
                                                  onChanged: (value) {
                                                    controller
                                                            .movimentoEntradaController
                                                            .listaItensSomados[
                                                                index]
                                                            .custo =
                                                        double.parse(
                                                            controllerCustoPeca[
                                                                    index]
                                                                .text
                                                                .replaceAll(
                                                                    ',', '.'));
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: IconButton(
                                                    tooltip: 'Excluir Item',
                                                    icon: Icon(
                                                      Icons.delete_outlined,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                    onPressed: () async {
                                                      try {
                                                        if (await Notificacao
                                                            .confirmacao(
                                                                'Deseja remover a entrada da peça ${controller.movimentoEntradaController.listaItensSomados[index].peca?.descricao}?')) {
                                                          setState(() {
                                                            controller
                                                                .movimentoEntradaController
                                                                .listaItensSomados
                                                                .removeAt(
                                                                    index);
                                                          });
                                                          Notificacao.snackBar(
                                                              'Item removido com sucesso!');
                                                        }
                                                      } catch (e) {
                                                        Notificacao.snackBar(
                                                            e.toString());
                                                      }
                                                    },
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  exibirPedidos(context) async {
    try {
      await controller.buscarPedidosEntrada();

      MediaQueryData media = MediaQuery.of(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const TitleComponent('Pedidos para Entrada'),
                  ],
                ),
                content: SingleChildScrollView(
                  controller: new ScrollController(),
                  child: Container(
                    width: media.size.width * 0.80,
                    height: media.size.height * 0.80,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Wrap(
                            children: [
                              const TextComponent(
                                'Selecione uma ou mais Pedidos para realizar a entrada de peças',
                                letterSpacing: 0.15,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Form(
                              key: controller.filtroFormKey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InputComponent(
                                          controller:
                                              controller.controllerIdPedido,
                                          onSaved: (value) {
                                            controller.controllerIdPedido.text =
                                                value;
                                          },
                                          hintText: 'Ord. Entrada',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: InputComponent(
                                          controller:
                                              controller.controllerIdFornecedor,
                                          onSaved: (value) {
                                            controller.controllerIdFornecedor
                                                .text = value;
                                          },
                                          hintText: 'ID Forn.',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  // Padding(padding: EdgeInsets.symmetric()),
                                  InputComponent(
                                    controller:
                                        controller.controllerNomeFornecedor,
                                    onSaved: (value) {
                                      controller.controllerNomeFornecedor.text =
                                          value;
                                    },
                                    hintText: 'Fornecedor',
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  ButtonComponent(
                                    color: secundaryColor,
                                    colorHover: secundaryColorHover,
                                    onPressed: () {
                                      setState(() {
                                        controller.itemsPopUpPedidos.clear();
                                        controller.buscarPedidosEntrada();
                                      });
                                    },
                                    text: 'Pesquisar',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                            child: Row(children: [
                          CheckboxComponent(
                            value: controller.pedidosEntradaBusca.length == 0
                                ? false
                                : controller.marcados ==
                                    controller.pedidosEntradaBusca.length,
                            onChanged: (bool value) {
                              setState(() {
                                controller.marcarTodosCheckbox(value);
                              });
                            },
                          ),
                          Text(
                            'Selecionar todos os pedidos',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ])),
                        Obx(() => !controller.carregandoPedidos.value
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      controller.itemsPopUpPedidos.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Container(
                                        width: Get.width,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 12),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CheckboxComponent(
                                                  value: controller
                                                      .itemsPopUpPedidos[index]
                                                      .marcado!,
                                                  onChanged: (bool value) => {
                                                        setState(() {
                                                          controller
                                                              .marcarCheckbox(
                                                                  index, value);
                                                        })
                                                      }),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(children: [
                                                    Text(
                                                      'Ordem Entrada: ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(controller
                                                            .pedidosEntradaBusca[
                                                                index]
                                                            .idPedidoEntrada
                                                            ?.toString() ??
                                                        ''),
                                                  ]),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'ID Asteca: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(controller
                                                              .pedidosEntradaBusca[
                                                                  index]
                                                              .asteca
                                                              ?.idAsteca
                                                              .toString() ??
                                                          ''),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'ID Fornecedor: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(controller
                                                              .pedidosEntradaBusca[
                                                                  index]
                                                              .asteca
                                                              ?.compEstProd
                                                              ?.first
                                                              .produto
                                                              ?.fornecedores
                                                              ?.first
                                                              .idFornecedor
                                                              .toString() ??
                                                          controller
                                                              .pedidosEntradaBusca[
                                                                  index]
                                                              .itensPedidoEntrada
                                                              ?.first
                                                              .peca
                                                              ?.produtoPeca
                                                              ?.first
                                                              .produto
                                                              ?.fornecedores
                                                              ?.first
                                                              .idFornecedor
                                                              .toString() ??
                                                          ''),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Nome Fornecedor: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          controller
                                                                  .pedidosEntradaBusca[
                                                                      index]
                                                                  .asteca
                                                                  ?.compEstProd
                                                                  ?.first
                                                                  .produto
                                                                  ?.fornecedores
                                                                  ?.first
                                                                  .cliente
                                                                  ?.nome
                                                                  .toString() ??
                                                              controller
                                                                  .pedidosEntradaBusca[
                                                                      index]
                                                                  .itensPedidoEntrada
                                                                  ?.first
                                                                  .peca
                                                                  ?.produtoPeca
                                                                  ?.first
                                                                  .produto
                                                                  ?.fornecedores
                                                                  ?.first
                                                                  .cliente
                                                                  ?.nome
                                                                  .toString() ??
                                                              '',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Expanded(
                                child: Center(child: LoadingComponent()))),
                        const Divider(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => !controller.carregandoPedidos.value
                                  ? TextComponent(
                                      'Total de Ordens selecionadas: ${controller.marcados}')
                                  : LoadingComponent(),
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            Row(
                              children: [
                                ButtonComponent(
                                    color: vermelhoColor,
                                    colorHover: vermelhoColorHover,
                                    onPressed: () {
                                      Get.back();
                                      controller.itemsPopUpPedidos.clear();
                                    },
                                    text: 'Cancelar'),
                                const SizedBox(
                                  width: 12,
                                ),
                                ButtonComponent(
                                    color: secundaryColor,
                                    colorHover: secundaryColorHover,
                                    onPressed: () async {
                                      await controller
                                          .adicionarPedidosParaEntrada();
                                      controller.itemsPopUpPedidos.clear();
                                    },
                                    text: 'Adicionar')
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
          });
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  myShowDialog(String text) {
    return showDialog(
        context: context,
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
}
