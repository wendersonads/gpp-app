import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/controllers/pedido_entrada_controller.dart';
import 'package:gpp/src/models/pedido_entrada_model.dart';
import 'package:gpp/src/models/produto/fornecedor_model.dart';
import 'package:gpp/src/shared/components/DropdownButtonFormFieldComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/utils/GerarRelOrdemEntradaAberta.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:gpp/src/controllers/responsive_controller.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';

class PedidoEntrada_Desktop extends StatefulWidget {
  const PedidoEntrada_Desktop({Key? key}) : super(key: key);

  @override
  _PedidoEntrada_DesktopState createState() => _PedidoEntrada_DesktopState();
}

class _PedidoEntrada_DesktopState extends State<PedidoEntrada_Desktop> {
  final ResponsiveController _responsive = ResponsiveController();

  late final PedidoEntradaController controller;
  late MaskFormatter maskFormatter;

  buscarTodas() async {
    try {
      setState(() {
        controller.carregado = false;
      });

      List retorno = await controller.repository.buscarPedidosEntrada(
        controller.pagina.atual,
        idFornecedor: controller.idFornecedor,
        idPedido: controller.idPedidoEntrada,
        dataInicio: controller.dataInicioRelatorio,
        dataFim: controller.dataFimRelatorio,
        situacao: controller.selecionado?.id ?? null,
      );

      controller.pedidosEntrada = retorno[0];
      controller.pagina = retorno[1];

      //Atualiza o status para carregado
      setState(() {
        controller.carregado = true;
      });
    } catch (e) {
      setState(() {
        controller.pedidosEntrada = [];
        controller.carregado = true;
      });
      Notificacao.snackBar(e.toString());
    }
  }

  buscarRelEntradas() async {
    try {
      setState(() {
        controller.carregandoGerarRelatorio = true;
      });

      controller.relPedidosEntrada =
          await controller.repository.buscarRelEntradasPorFornecedor(
        idFornecedor: controller.idFornecedor,
        dataInicioFiltro: controller.dataInicioRelatorio,
        dataFimFiltro: controller.dataFimRelatorio,
      );

      setState(() {
        controller.carregandoGerarRelatorio = false;
      });
    } catch (e) {
      setState(() {
        controller.relPedidosEntrada = [];
        controller.carregandoGerarRelatorio = false;
      });
      Notificacao.snackBar(e.toString());
    }
  }

  _buildSituacaoPedido(value) {
    if (value == 1) {
      return TextComponent(
        'Em aberto',
        color: Colors.blue,
      );
    } else if (value == 2) {
      return TextComponent(
        'Pendente',
        color: Colors.orange,
      );
    } else if (value == 3) {
      return TextComponent(
        'Concluído',
        color: Colors.green,
      );
    } else if (value == 4) {
      return TextComponent(
        'Cancelado',
        color: Colors.red,
      );
    }
  }

  @override
  initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    //Iniciliza o controlador de pedido
    controller = PedidoEntradaController();
    //Inicializa mask formatter
    maskFormatter = MaskFormatter();

    //Função responsável por buscar a lista de pedidos
    buscarTodas();
  }

  situacao(DateTime data) {
    int diasEmAtraso = DateTime.now().difference(data).inDays;
    //Se os dias em atraso for menor que 15 dias, situação = verde
    if (diasEmAtraso < 15) {
      return Colors.green;
    }
    //Se os dias em atraso for maior que 15 e menor que 30, situação = amarela
    if (diasEmAtraso > 15 && diasEmAtraso < 30) {
      return Colors.yellow;
    }
    //Se os dias em atraso for maior que 30, situação = vermelha

    return Colors.red;
  }

  tipoAsteca(int? tipoAsteca) {
    switch (tipoAsteca) {
      case 1:
        return 'Cliente';
      case 2:
        return 'Estoque';
      default:
        return 'Aguardando tipo de asteca';
    }
  }

  Widget _buildList() {
    Widget widget = LayoutBuilder(
      builder: (context, constraints) {
        if (_responsive.isMobile(constraints.maxWidth)) {
          return ListView.builder(
              itemCount: controller.pedidosEntrada.length,
              itemBuilder: (context, index) {
                return _buildListItem(
                    controller.pedidosEntrada, index, context);
              });
        }

        return ListView.builder(
            itemCount: controller.pedidosEntrada.length,
            itemBuilder: (context, index) {
              return _buildListItem(controller.pedidosEntrada, index, context);
            });
      },
    );

    return Container(color: Colors.white, child: widget);
  }

  Widget _buildListItem(
      List<PedidoEntradaModel> pedido, int index, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_responsive.isMobile(constraints.maxWidth)) {
          // return GestureDetector(
          //   onTap: () {
          //     Navigator.pushNamed(
          //         context, '/asteca/' + pedido[index].idPedidoSaida.toString());
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Column(
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Expanded(
          //               child: Text(
          //                 pedido[index].idPedidoSaida.toString(),
          //                 style: textStyle(
          //                     color: Colors.black,
          //                     fontWeight: FontWeight.w900,
          //                     fontSize: 18.0),
          //               ),
          //             ),
          //             Align(
          //               alignment: Alignment.centerLeft,
          //               child: Text(
          //                 'ID: ' + pedido[index].idPedidoSaida.toString(),
          //                 style: textStyle(
          //                     color: Colors.black, fontWeight: FontWeight.w700),
          //               ),
          //             ),
          //           ],
          //         ),
          //         Divider(),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Expanded(
          //               child: TextComponent('Nota Fiscal: ' +
          //                   controller
          //                       .astecas[index].documentoFiscal!.numDocFiscal
          //                       .toString()),
          //             ),
          //             Align(
          //               alignment: Alignment.centerLeft,
          //               child: TextComponent('Serie: ' +
          //                   controller.astecas[index].documentoFiscal!
          //                       .serieDocFiscal!),
          //             ),
          //           ],
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Expanded(
          //               child: TextComponent(
          //                 'Filial de Venda: ' +
          //                     controller
          //                         .astecas[index].documentoFiscal!.idFilialVenda
          //                         .toString(),
          //               ),
          //             ),
          //             Align(
          //               alignment: Alignment.centerLeft,
          //               child: TextComponent(
          //                 'Data de Abertura: ' +
          //                     DateFormat('dd-MM-yyyy').format(
          //                         controller.astecas[index].dataEmissao!),
          //               ),
          //             ),
          //           ],
          //         ),
          //         Padding(padding: const EdgeInsets.all(8.0)),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Expanded(
          //               child: TextComponent(
          //                 'Defeito: ' +
          //                     asteca[index].defeitoEstadoProd.toString(),
          //               ),
          //             ),
          //           ],
          //         ),
          //         Padding(padding: const EdgeInsets.all(4.0)),
          //       ],
          //     ),
          //   ),
          // );
        }

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: CardWidget(
            widget: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          TextComponent(
                            'ID',
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: TextComponent(
                          'Fornecedor',
                          fontWeight: FontWeight.bold,
                        )),
                    Expanded(
                        flex: 2,
                        child: TextComponent(
                          'Data de abertura',
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                        flex: 2,
                        child: TextComponent(
                          'CPF/CNPJ',
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                        flex: 2,
                        child: TextComponent(
                          'Situação',
                          fontWeight: FontWeight.bold,
                        )),
                    Expanded(
                        flex: 2,
                        child: TextComponent(
                          'Valor total',
                          fontWeight: FontWeight.bold,
                        )),
                    Expanded(
                        flex: 2,
                        child: TextComponent(
                          'Tipo',
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                        flex: 2,
                        child: TextComponent(
                          'Ações',
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          pedido[index].idPedidoEntrada != null
                              ? SelectableText(
                                  '#' +
                                      pedido[index].idPedidoEntrada.toString(),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: SelectableText(
                          pedido[index]
                                  .asteca
                                  ?.compEstProd
                                  ?.first
                                  .produto
                                  ?.fornecedores
                                  ?.first
                                  .cliente
                                  ?.nome
                                  .toString() ??
                              pedido[index]
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
                        )),
                    Expanded(
                        flex: 2,
                        child: pedido[index].dataEmissao != null
                            ? SelectableText(
                                DateFormat('dd/MM/yyyy')
                                    .format(pedido[index].dataEmissao!),
                              )
                            : Container()),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                        flex: 2,
                        child: SelectableText(
                          pedido[index]
                                      .asteca
                                      ?.compEstProd
                                      ?.first
                                      .produto
                                      ?.fornecedores
                                      ?.first
                                      .cliente
                                      ?.cpfCnpj !=
                                  null
                              ? maskFormatter
                                  .cpfCnpjFormatter(
                                      value: pedido[index]
                                          .asteca!
                                          .compEstProd!
                                          .first
                                          .produto!
                                          .fornecedores!
                                          .first
                                          .cliente!
                                          .cpfCnpj
                                          .toString())!
                                  .getMaskedText()
                              : pedido[index]
                                          .itensPedidoEntrada
                                          ?.first
                                          .peca
                                          ?.produtoPeca
                                          ?.first
                                          .produto
                                          ?.fornecedores
                                          ?.first
                                          .cliente
                                          ?.cpfCnpj
                                          .toString() !=
                                      null
                                  ? maskFormatter
                                      .cpfCnpjFormatter(
                                          value: pedido[index]
                                              .itensPedidoEntrada
                                              ?.first
                                              .peca
                                              ?.produtoPeca
                                              ?.first
                                              .produto
                                              ?.fornecedores
                                              ?.first
                                              .cliente
                                              ?.cpfCnpj
                                              .toString())!
                                      .getMaskedText()
                                  : '',
                        )),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                        flex: 2,
                        child:
                            _buildSituacaoPedido(pedido[index].situacao) != null
                                ? _buildSituacaoPedido(pedido[index].situacao)
                                : Container()),
                    Expanded(
                        flex: 2,
                        child: SelectableText(pedido[index].valorTotal != null
                            ? controller.formatter
                                .format(pedido[index].valorTotal)
                            : controller.formatter.format(0))),
                    Expanded(
                      flex: 2,
                      child: EventoStatusWidget(
                        texto: pedido[index].asteca?.idAsteca != null
                            ? 'Asteca'
                            : 'Manual',
                        color: pedido[index].asteca?.idAsteca != null
                            ? HexColor('#040491')
                            : HexColor('#0DE8A6'),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 20)),
                    Expanded(
                      flex: 2,
                      child: ButtonAcaoWidget(
                        detalhe: () {
                          Get.toNamed('/ordens-entrada/' +
                              pedido[index].idPedidoEntrada.toString());
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Expanded(child: TitleComponent('Ordens de Entrada')),
                          Expanded(
                            child: Form(
                              key: controller.filtroFormKey,
                              child: InputComponent(
                                maxLines: 1,
                                onFieldSubmitted: (value) {
                                  controller.idPedidoEntrada =
                                      int.tryParse(value);
                                  //Limpa o formúlario
                                  controller.filtroFormKey.currentState!
                                      .reset();
                                  buscarTodas();
                                },
                                prefixIcon: Icon(
                                  Icons.search,
                                ),
                                hintText: 'Buscar',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          ButtonComponent(
                            icon: Icon(Icons.add, color: Colors.white),
                            color: secundaryColor,
                            onPressed: () {
                              setState(() {
                                controller.abrirFiltro =
                                    !(controller.abrirFiltro);
                              });
                            },
                            text: 'Adicionar filtro',
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      color: Colors.grey.shade50,
                      height: controller.abrirFiltro ? null : 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Form(
                              key: controller.filtroExpandidoFormKey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextComponent('Situação'),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            DropdownButtonFormFieldComponent(
                                                hint: TextComponent(controller
                                                        .selecionado
                                                        ?.descricao ??
                                                    'Selecione a situação'),
                                                items: <Situacao>[
                                                  Situacao(
                                                      id: 1,
                                                      descricao: 'Em aberto'),
                                                  Situacao(
                                                      id: 2,
                                                      descricao: 'Pendente'),
                                                  Situacao(
                                                      id: 3,
                                                      descricao: 'Concluído'),
                                                  Situacao(
                                                      id: 4,
                                                      descricao: 'Cancelado')
                                                ].map<
                                                        DropdownMenuItem<
                                                            Situacao>>(
                                                    (Situacao value) {
                                                  return DropdownMenuItem<
                                                      Situacao>(
                                                    value: value,
                                                    child: TextComponent(
                                                        value.descricao!),
                                                  );
                                                }).toList(),
                                                onChanged: (Situacao? value) {
                                                  controller.selecionado =
                                                      value!;
                                                })
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                            // height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextFormField(
                                              controller: controller
                                                  .controllerIdFornecedor,
                                              onFieldSubmitted: (value) async {
                                                await controller
                                                    .buscarFornecedor();
                                                controller.idFornecedor =
                                                    controller
                                                        .controllerIdFornecedor
                                                        .text;
                                              },
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: 'ID',
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    top: 15,
                                                    bottom: 10,
                                                    left: 10),
                                                suffixIcon: IconButton(
                                                  onPressed: () async {
                                                    await controller
                                                        .buscarFornecedor();
                                                    controller.idFornecedor =
                                                        controller
                                                            .controllerIdFornecedor
                                                            .text;
                                                  },
                                                  icon: Icon(Icons.search),
                                                ),
                                              ),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Obx(
                                        () => !controller
                                                .carregandoFornecedor.value
                                            ? Flexible(
                                                flex: 3,
                                                child: Container(
                                                  // height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: DropdownSearch<
                                                      FornecedorModel?>(
                                                    mode: Mode.MENU,
                                                    showSearchBox: true,
                                                    searchDelay:
                                                        Duration(seconds: 1),
                                                    isFilteredOnline: true,
                                                    itemAsString: (FornecedorModel?
                                                            value) =>
                                                        '${value!.cliente?.idCliente} - ${value.cliente?.nome}',
                                                    onFind:
                                                        (String? filter) async {
                                                      return await controller
                                                          .buscarFornecedores(
                                                              filter);
                                                    },
                                                    selectedItem: controller
                                                        .fornecedorController
                                                        .fornecedorModel,
                                                    searchFieldProps:
                                                        TextFieldProps(
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        labelText:
                                                            'Nome do Fornecedor',
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                    onChanged: (fornecedor) {
                                                      controller
                                                              .fornecedorController
                                                              .fornecedorModel =
                                                          fornecedor
                                                              as FornecedorModel;
                                                      controller
                                                              .controllerIdFornecedor
                                                              .text =
                                                          fornecedor
                                                              .idFornecedor
                                                              .toString();
                                                      controller.idFornecedor =
                                                          fornecedor
                                                              .idFornecedor
                                                              .toString();
                                                    },
                                                    dropdownSearchDecoration:
                                                        InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 8,
                                                              bottom: 8),
                                                      border: InputBorder.none,
                                                    ),
                                                    dropdownBuilder:
                                                        (context, value) {
                                                      return Text(
                                                          '${value!.cliente?.nome ?? 'Fornecedor'}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ));
                                                    },
                                                    emptyBuilder:
                                                        (context, value) {
                                                      return Center(
                                                          child: TextComponent(
                                                        'Nenhum fornecedor encontrado',
                                                        textAlign:
                                                            TextAlign.center,
                                                        color: Colors
                                                            .grey.shade400,
                                                      ));
                                                    },
                                                  ),
                                                ),
                                              )
                                            : LoadingComponent(),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: InputComponent(
                                          inputFormatter: [
                                            maskFormatter.dataFormatter()
                                          ],
                                          label: 'Período:',
                                          maxLines: 1,
                                          onSaved: (value) {
                                            if (value.length == 10) {
                                              controller.dataInicio =
                                                  DateFormat("dd/MM/yyyy")
                                                      .parse(value);
                                              controller.dataInicioRelatorio =
                                                  value;
                                            }
                                          },
                                          hintText: 'DD/MM/AAAA',
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: InputComponent(
                                          inputFormatter: [
                                            maskFormatter.dataFormatter()
                                          ],
                                          label: '',
                                          maxLines: 1,
                                          onSaved: (value) {
                                            if (value.length == 10) {
                                              controller.dataFim =
                                                  DateFormat("dd/MM/yyyy")
                                                      .parse(value);
                                              controller.dataFimRelatorio =
                                                  value;
                                            }
                                          },
                                          hintText: 'DD/MM/AAAA',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  controller.carregandoGerarRelatorio
                                      ? LoadingComponent()
                                      : ButtonComponent(
                                          onPressed: () async {
                                            controller.filtroExpandidoFormKey
                                                .currentState!
                                                .save();
                                            controller.filtroExpandidoFormKey
                                                .currentState!
                                                .reset();
                                            controller.fornecedorController
                                                    .fornecedorModel =
                                                FornecedorModel();
                                            await buscarRelEntradas();
                                            GerarRelOrdemEntradaAberta(
                                              pedidos:
                                                  controller.relPedidosEntrada,
                                              periodoDataInicio: controller
                                                  .dataInicioRelatorio,
                                              periodoDataFim:
                                                  controller.dataFimRelatorio,
                                            ).imprimirPDF();
                                          },
                                          text: 'Gerar Relatório',
                                        ),
                                  Padding(padding: EdgeInsets.only(right: 10)),
                                  ButtonComponent(
                                    onPressed: () {
                                      controller
                                          .filtroExpandidoFormKey.currentState!
                                          .save();
                                      controller
                                          .filtroExpandidoFormKey.currentState!
                                          .reset();
                                      controller.fornecedorController
                                          .fornecedorModel = FornecedorModel();
                                      buscarTodas();

                                      setState(() {
                                        controller.abrirFiltro = false;
                                      });
                                    },
                                    text: 'Pesquisar',
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: controller.carregado
                          ? _buildList()
                          : LoadingComponent(),
                    ),
                    PaginacaoComponent(
                      total: controller.pagina.getTotal(),
                      atual: controller.pagina.getAtual(),
                      primeiraPagina: () {
                        controller.pagina.primeira();
                        buscarTodas();
                        setState(() {});
                      },
                      anteriorPagina: () {
                        controller.pagina.anterior();
                        buscarTodas();
                        setState(() {});
                      },
                      proximaPagina: () {
                        controller.pagina.proxima();
                        buscarTodas();
                        setState(() {});
                      },
                      ultimaPagina: () {
                        controller.pagina.ultima();
                        buscarTodas();
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
