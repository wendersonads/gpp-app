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

class EntradaPedidoViewDesktop extends StatefulWidget {
  const EntradaPedidoViewDesktop({Key? key}) : super(key: key);

  @override
  _EntradaPedidoViewState createState() => _EntradaPedidoViewState();
}

class _EntradaPedidoViewState extends State<EntradaPedidoViewDesktop> {
  final controller = Get.put(EntradaPedidoController());

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        controller: new ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  flex: 4,
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
                            EdgeInsets.only(top: 15, bottom: 10, left: 10),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 30)),
                Flexible(
                  flex: 3,
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
                const Padding(padding: EdgeInsets.only(left: 30)),
                Flexible(
                  flex: 2,
                  child: Obx(
                    () => !controller.carregandoPedidos.value
                        ? ButtonComponent(
                            color: primaryColor,
                            colorHover: primaryColorHover,
                            onPressed: () {
                              exibirPedidos(context);
                            },
                            text: 'Adicionar Pedidos',
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
              margin: EdgeInsets.only(right: 18),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              color: Colors.grey.shade200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: const TextComponent(
                      'ID. Peça',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: const TextComponent(
                      'Descrição Peça',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: const TextComponent(
                      'ID Pedido Entrada',
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: const TextComponent(
                      'Qtd. Pedida',
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: const TextComponent(
                      'Qtd. Recebida',
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: const TextComponent(
                      'Valor Unitário',
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: const TextComponent(
                      'Ações',
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => !controller.carregando.value
                  ? Center(
                      child: Container(
                        margin: EdgeInsets.only(right: 18),
                        height: media.height / 2,
                        child: ListView.builder(
                          primary: false,
                          itemCount: controller.movimentoEntradaController
                              .listaItensSomados.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey.shade100),
                                      left: BorderSide(
                                          color: Colors.grey.shade100),
                                      bottom: BorderSide(
                                          color: Colors.grey.shade100),
                                      right: BorderSide(
                                          color: Colors.grey.shade100))),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextComponent(
                                      controller
                                              .movimentoEntradaController
                                              .listaItensSomados[index]
                                              .peca
                                              ?.id_peca
                                              .toString() ??
                                          '-',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextComponent(
                                      controller
                                              .movimentoEntradaController
                                              .listaItensSomados[index]
                                              .peca
                                              ?.descricao ??
                                          '-',
                                    ),
                                  ),
                                  Expanded(
                                    child: TextComponent(
                                      controller
                                              .movimentoEntradaController
                                              .listaItensSomados[index]
                                              .id_pedido_entrada
                                              ?.toString() ??
                                          '-',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextComponent(
                                      controller.movimentoEntradaController
                                          .listaItensSomados[index].quantidade
                                          .toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Qtd',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 5,
                                              right: 5),
                                        ),
                                        onChanged: (value) {
                                          if (value == '')
                                            controller
                                                .movimentoEntradaController
                                                .listaItensSomados[index]
                                                .quantidade_recebida = null;
                                          else
                                            controller
                                                    .movimentoEntradaController
                                                    .listaItensSomados[index]
                                                    .quantidade_recebida =
                                                int.parse(value);
                                        },
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5)),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
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
                                          contentPadding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 5,
                                              right: 5),
                                          prefixText: 'R\$ ',
                                        ),
                                        onChanged: (value) {
                                          if (value == '')
                                            controller
                                                .movimentoEntradaController
                                                .listaItensSomados[index]
                                                .custo = 0;
                                          else
                                            controller
                                                    .movimentoEntradaController
                                                    .listaItensSomados[index]
                                                    .custo =
                                                (double.parse(value
                                                    .replaceAll('.', '')
                                                    .replaceAll(',', '.')));
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
                                            color: Colors.grey.shade400,
                                          ),
                                          onPressed: () async {
                                            try {
                                              if (await Notificacao.confirmacao(
                                                  'Deseja remover a entrada da peça ${controller.movimentoEntradaController.listaItensSomados[index].peca?.descricao}?')) {
                                                setState(() {
                                                  controller
                                                      .movimentoEntradaController
                                                      .listaItensSomados
                                                      .removeAt(index);
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
                            );
                          },
                        ),
                      ),
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
                      size: 32,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const TitleComponent('Pedidos para Entrada'),
                  ],
                ),
                content: Container(
                  width: media.size.width * 0.80,
                  height: media.size.height * 0.80,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const TextComponent(
                              'Selecione uma ou mais Pedidos para realizar a entrada de peças',
                              letterSpacing: 0.15,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     vertical: 8.0,
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       const SizedBox.shrink(),
                      //       ButtonComponent(
                      //         color: secundaryColor,
                      //         colorHover: secundaryColorHover,
                      //         icon: Icon(Icons.tune_rounded, color: Colors.white),
                      //         onPressed: () {
                      //           setState(() {
                      //             controller.abrirFiltro(controller.abrirFiltro.value == true ? false : true);
                      //           });
                      //         },
                      //         text: 'Adicionar filtro',
                      //       )
                      //     ],
                      //   ),
                      // ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Form(
                            key: controller.filtroFormKey,
                            child: Row(
                              children: [
                                Expanded(
                                  child: InputComponent(
                                    controller: controller.controllerIdPedido,
                                    onSaved: (value) {
                                      controller.controllerIdPedido.text =
                                          value;
                                    },
                                    hintText: 'ID Ordem Entrada',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: InputComponent(
                                    controller:
                                        controller.controllerIdFornecedor,
                                    onSaved: (value) {
                                      controller.controllerIdFornecedor.text =
                                          value;
                                    },
                                    hintText: 'ID Fornecedor',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: InputComponent(
                                    controller:
                                        controller.controllerNomeFornecedor,
                                    onSaved: (value) {
                                      controller.controllerNomeFornecedor.text =
                                          value;
                                    },
                                    hintText: 'Nome Fornecedor',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                ButtonComponent(
                                  color: secundaryColor,
                                  colorHover: secundaryColorHover,
                                  icon: Icon(Icons.search, color: Colors.white),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        color: Colors.grey.shade200,
                        child: Row(
                          children: [
                            CheckboxComponent(
                              value: controller.marcados ==
                                  controller.pedidosEntradaBusca.length,
                              onChanged: (bool value) {
                                setState(() {
                                  controller.marcarTodosCheckbox(value);
                                });
                              },
                            ),
                            Expanded(
                              flex: 2,
                              child: const TextComponent(
                                'ID Ordem Entrada',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: const TextComponent(
                                'ID Asteca',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: const TextComponent(
                                'ID Fornecedor',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: const TextComponent(
                                'Nome Fornecedor',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => !controller.carregandoPedidos.value
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: controller.itemsPopUpPedidos.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey.shade100),
                                            left: BorderSide(
                                                color: Colors.grey.shade100),
                                            bottom: BorderSide(
                                                color: Colors.grey.shade100),
                                            right: BorderSide(
                                                color: Colors.grey.shade100))),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 12),
                                    child: Row(
                                      children: [
                                        CheckboxComponent(
                                            value: controller
                                                .itemsPopUpPedidos[index]
                                                .marcado!,
                                            onChanged: (bool value) => {
                                                  setState(() {
                                                    controller.marcarCheckbox(
                                                        index, value);
                                                  })
                                                }),
                                        Expanded(
                                          flex: 2,
                                          child: TextComponent(controller
                                                  .pedidosEntradaBusca[index]
                                                  .idPedidoEntrada
                                                  ?.toString() ??
                                              ''),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TextComponent(controller
                                                  .pedidosEntradaBusca[index]
                                                  .asteca
                                                  ?.idAsteca
                                                  .toString() ??
                                              ''),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TextComponent(controller
                                                  .pedidosEntradaBusca[index]
                                                  .asteca
                                                  ?.compEstProd
                                                  ?.first
                                                  .produto
                                                  ?.fornecedores
                                                  ?.first
                                                  .idFornecedor
                                                  .toString() ??
                                              controller
                                                  .pedidosEntradaBusca[index]
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
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: TextComponent(controller
                                                  .pedidosEntradaBusca[index]
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
                                                  .pedidosEntradaBusca[index]
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
                                              ''),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Expanded(child: Center(child: LoadingComponent()))),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => !controller.carregandoPedidos.value
                                ? TextComponent(
                                    'Total de Ordens selecionadas: ${controller.marcados}')
                                : LoadingComponent(),
                          ),
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
