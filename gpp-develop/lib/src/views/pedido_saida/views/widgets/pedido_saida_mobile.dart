// ignore_for_file: unused_field, unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/models/evento_status_model.dart';
import 'package:gpp/src/shared/components/DropdownButtonFormFieldComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';

import 'package:gpp/src/views/pedido_saida/controllers/pedido_saida_controller.dart';
import 'package:gpp/src/views/pedido_saida/controllers/pedido_saida_detalhe_controller.dart';
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
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';

class PedidoSaidaMobile extends StatefulWidget {
  const PedidoSaidaMobile({Key? key}) : super(key: key);

  @override
  _PedidoSaidaMobileState createState() => _PedidoSaidaMobileState();
}

class _PedidoSaidaMobileState extends State<PedidoSaidaMobile> {
  final ResponsiveController _responsive = ResponsiveController();
  late MaskFormatter maskFormatter;

  final controller = Get.put(PedidoSaidaController());

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
        color: secundaryColor,
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

    //Inicializa mask formatter
    maskFormatter = MaskFormatter();
  }

  situacao(DateTime data) {
    int diasEmAtraso = DateTime.now().difference(data).inDays;
    //Se os dias em atraso for menor que 15 dias, situação = verde
    if (diasEmAtraso < 15) {
      return secundaryColor;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextComponent(
                  'Ordens de Saída',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: 16,
                ),
                Obx(
                  (() => Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          GestureDetector(
                            onTap: () async {
                              controller.selected(1);
                              controller.buscarPedidosSaidaMenu();
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: controller.selected.value == 1 ? secundaryColor : Colors.grey.shade200,
                                        width: controller.selected.value == 1 ? 4 : 1),
                                  ),
                                ),
                                child: TextComponent('Todas')),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.selected(3);
                              controller.buscarPedidosSaidaMenu();
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: controller.selected.value == 3 ? secundaryColor : Colors.grey.shade200,
                                            width: controller.selected.value == 3 ? 4 : 1))),
                                child: TextComponent('Em atendimento')),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.selected(4);
                              controller.buscarPedidosSaidaMenu();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: controller.selected.value == 4 ? secundaryColor : Colors.grey.shade200,
                                      width: controller.selected.value == 4 ? 4 : 1),
                                ),
                              ),
                              child: TextComponent('Criado por mim'),
                            ),
                          ),
                        ]),
                      )),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Form(
                        key: controller.filtroFormKey,
                        child: InputComponent(
                          maxLines: 1,
                          onFieldSubmitted: (value) async {
                            controller.pesquisar = value;
                            controller.buscarPedidosSaidaMenu();
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
                    Expanded(
                      child: ButtonComponent(
                        icon: Icon(Icons.tune_rounded, color: Colors.white),
                        color: secundaryColor,
                        onPressed: () {
                          setState(() {
                            controller.abrirFiltro(!controller.abrirFiltro.value);
                          });
                        },
                        text: 'Filtrar',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: controller.abrirFiltro.value ? null : 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: controller.filtroExpandidoFormKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextComponent('Status'),
                            SizedBox(
                              height: 2,
                            ),
                            Obx(() => !controller.carregandoEventosPedidoSaida.value
                                ? Container(
                                    child: DropdownButtonFormFieldComponent(
                                        hint: TextComponent(controller.eventoSelecionado?.descricao ?? 'Selecione o status'),
                                        items: controller.eventosPedidoSaida
                                            .map<DropdownMenuItem<EventoStatusModel>>((EventoStatusModel value) {
                                          return DropdownMenuItem<EventoStatusModel>(
                                            value: value,
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: HexColor(value.statusCor ?? '#040491'),
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(2),
                                                        topRight: Radius.circular(2),
                                                        bottomLeft: Radius.circular(2),
                                                        bottomRight: Radius.circular(2)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                TextComponent(value.descricao!),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          controller.eventoSelecionado = value;
                                        }),
                                  )
                                : DropdownButtonFormFieldComponent(
                                    hint: TextComponent(controller.eventoSelecionado?.descricao ?? 'Selecione o status'),
                                    items: controller.eventosPedidoSaida
                                        .map<DropdownMenuItem<EventoStatusModel>>((EventoStatusModel value) {
                                      return DropdownMenuItem<EventoStatusModel>(
                                        value: value,
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: HexColor(value.statusCor ?? '#040491'),
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(2),
                                                    topRight: Radius.circular(2),
                                                    bottomLeft: Radius.circular(2),
                                                    bottomRight: Radius.circular(2)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            TextComponent(value.descricao!),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      // controller.pedidoController
                                      //     .selecionado = value;
                                    }))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InputComponent(
                                inputFormatter: [maskFormatter.dataFormatter()],
                                label: 'Período:',
                                maxLines: 1,
                                onSaved: (value) {
                                  if (value.length == 10) {
                                    controller.dataInicio = DateFormat("dd/MM/yyyy").parse(value);
                                  }
                                },
                                hintText: 'DD/MM/AAAA',
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: InputComponent(
                                inputFormatter: [maskFormatter.dataFormatter()],
                                label: '',
                                maxLines: 1,
                                onSaved: (value) {
                                  if (value.length == 10) {
                                    controller.dataFim = DateFormat("dd/MM/yyyy").parse(value);
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

                  // padding: const EdgeInsets.symmetric(vertical: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonComponent(
                          color: vermelhoColor,
                          onPressed: () {
                            controller.limparFiltro();
                          },
                          text: 'Limpar'),
                      SizedBox(
                        width: 8,
                      ),
                      ButtonComponent(
                          onPressed: () {
                            controller.buscarPedidosSaidaMenu();
                          },
                          text: 'Pesquisar')
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListarPedidosSaida(),
        ],
      ),
    );
  }

  ListarPedidosSaida() {
    Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        GestureDetector(
          onTap: () async {
            controller.selected(1);
            controller.buscarPedidosSaidaMenu();
          },
          child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: controller.selected.value == 1 ? secundaryColor : Colors.grey.shade200,
                          width: controller.selected.value == 1 ? 4 : 1))),
              child: TextComponent('Todas')),
        ),
        // GestureDetector(
        //   onTap: () async {
        //     controller.selected(2);
        //     controller.buscarPedidosSaidaMenu();
        //   },
        //   child: Container(
        //       padding: EdgeInsets.symmetric(
        //           vertical: 8, horizontal: 16),
        //       decoration: BoxDecoration(
        //           border: Border(
        //               bottom: BorderSide(
        //                   color:
        //                       controller.selected.value ==
        //                               2
        //                           ? secundaryColor
        //                           : Colors.grey.shade200,
        //                   width:
        //                       controller.selected.value ==
        //                               2
        //                           ? 4
        //                           : 1))),
        //       child: TextComponent('Em aberto')),
        // ),
        GestureDetector(
          onTap: () {
            controller.selected(3);
            controller.buscarPedidosSaidaMenu();
          },
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: controller.selected.value == 3 ? secundaryColor : Colors.grey.shade200,
                          width: controller.selected.value == 3 ? 4 : 1))),
              child: TextComponent('Em atendimento')),
        ),
        GestureDetector(
          onTap: () {
            controller.selected(4);
            controller.buscarPedidosSaidaMenu();
          },
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: controller.selected.value == 4 ? secundaryColor : Colors.grey.shade200,
                          width: controller.selected.value == 4 ? 4 : 1))),
              child: TextComponent('Criado por mim')),
        ),
      ]),
    );
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() => !controller.carregando.value
                    ? ListView.builder(
                        itemCount: controller.pedidos.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: CardWidget(
                              color: controller.pedidos[index].pedidoSaidaEvento?.length != 0
                                  ? HexColor(
                                      controller.pedidos[index].pedidoSaidaEvento?.last.eventoStatus?.statusCor ?? '#040491')
                                  : primaryColor,
                              widget: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextComponent(
                                          'ID',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SelectableText('#' + controller.pedidos[index].idPedidoSaida.toString()),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextComponent(
                                          'Nome',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SelectableText(controller.pedidos[index].cliente?.nome?.toString().capitalize ?? ''),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextComponent(
                                          'Data de abertura',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SelectableText(DateFormat('dd/MM/yyyy').format(controller.pedidos[index].dataEmissao!)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextComponent(
                                          'CPF/CNPJ',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SelectableText(maskFormatter
                                            .cpfCnpjFormatter(value: controller.pedidos[index].cpfCnpj.toString())!
                                            .getMaskedText()),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextComponent(
                                          'Valor total',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SelectableText(controller.formatter.format(controller.pedidos[index].valorTotal)
                                            // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                            ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextComponent(
                                          'Status',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        EventoStatusWidget(
                                          color: controller.pedidos[index].pedidoSaidaEvento?.length != 0
                                              ? HexColor(
                                                  controller.pedidos[index].pedidoSaidaEvento?.last.eventoStatus?.statusCor ??
                                                      '#040491')
                                              : null,
                                          texto: controller.pedidos[index].pedidoSaidaEvento?.length != 0
                                              ? controller.pedidos[index].pedidoSaidaEvento?.last.eventoStatus?.descricao ?? ''
                                              : 'Aguardando status',
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextComponent(
                                          'Ações',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        ButtonAcaoWidget(
                                          detalhe: () {
                                            Get.delete<PedidoSaidaDetalheController>();
                                            Get.toNamed('/ordens-saida/${controller.pedidos[index].idPedidoSaida}');
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                //   Divider(),
                                //   Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       // Expanded(
                                //       //   child: Row(
                                //       //     children: [
                                //       //       SelectableText('#' +
                                //       //           controller.pedidos[index]
                                //       //               .idPedidoSaida
                                //       //               .toString())
                                //       //     ],
                                //       //   ),
                                //       // ),
                                //       // Expanded(
                                //       //     flex: 2,
                                //       //     child: SelectableText(controller
                                //       //             .pedidos[index]
                                //       //             .cliente
                                //       //             ?.nome
                                //       //             ?.toString()
                                //       //             .capitalize ??
                                //       //         '')),
                                //       // Expanded(
                                //       //     flex: 2,
                                //       //     child: SelectableText(
                                //       //         DateFormat('dd/MM/yyyy').format(
                                //       //             controller.pedidos[index]
                                //       //                 .dataEmissao!))),
                                //       // Expanded(
                                //       //     flex: 2,
                                //       //     child: SelectableText(maskFormatter
                                //       //         .cpfCnpjFormatter(
                                //       //             value: controller
                                //       //                 .pedidos[index].cpfCnpj
                                //       //                 .toString())!
                                //       //         .getMaskedText())),
                                //       // Expanded(
                                //       //     child: SelectableText(controller
                                //       //             .formatter
                                //       //             .format(controller
                                //       //                 .pedidos[index]
                                //       //                 .valorTotal)
                                //       //         // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                //       //         )),
                                //       Expanded(
                                //         flex: 2,
                                //         child: Row(
                                //           children: [
                                //             // EventoStatusWidget(
                                //             //   color: controller
                                //             //               .pedidos[index]
                                //             //               .pedidoSaidaEvento
                                //             //               ?.length !=
                                //             //           0
                                //             //       ? HexColor(controller
                                //             //               .pedidos[index]
                                //             //               .pedidoSaidaEvento
                                //             //               ?.last
                                //             //               .eventoStatus
                                //             //               ?.statusCor ??
                                //             //           '#040491')
                                //             //       : null,
                                //             //   texto: controller
                                //             //               .pedidos[index]
                                //             //               .pedidoSaidaEvento
                                //             //               ?.length !=
                                //             //           0
                                //             //       ? controller
                                //             //               .pedidos[index]
                                //             //               .pedidoSaidaEvento
                                //             //               ?.last
                                //             //               .eventoStatus
                                //             //               ?.descricao ??
                                //             //           ''
                                //             //       : 'Aguardando status',
                                //             // ),
                                //           ],
                                //         ),
                                //       ),
                                //       // Expanded(child: ButtonAcaoWidget(
                                //       //   detalhe: () {
                                //       //     Get.delete<
                                //       //         PedidoSaidaDetalheController>();
                                //       //     Get.toNamed(
                                //       //         '/ordens-saida/${controller.pedidos[index].idPedidoSaida}');
                                //       //   },
                                //       // )
                                //       // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                //       //)
                                //     ],
                                //   ),
                              ),
                            ), // ],
                          );
                        },
                      )
                    : LoadingComponent())),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: GetBuilder<PedidoSaidaController>(
              builder: (_) => PaginacaoComponent(
                total: controller.pagina.getTotal(),
                atual: controller.pagina.getAtual(),
                primeiraPagina: () async {
                  controller.pagina.primeira();
                  await controller.buscarPedidosSaidaMenu();
                },
                anteriorPagina: () async {
                  controller.pagina.anterior();
                  await controller.buscarPedidosSaidaMenu();
                },
                proximaPagina: () async {
                  controller.pagina.proxima();
                  await controller.buscarPedidosSaidaMenu();
                },
                ultimaPagina: () async {
                  controller.pagina.ultima();
                  await controller.buscarPedidosSaidaMenu();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
