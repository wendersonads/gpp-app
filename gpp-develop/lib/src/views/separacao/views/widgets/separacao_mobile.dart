import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/separacao/controllers/separacao_controller.dart';
import 'package:gpp/src/views/separacao/controllers/separacao_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class SeparacaoMobile extends StatelessWidget {
  const SeparacaoMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SeparacaoController());

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: NavbarWidget(),
        drawer: Sidebar(),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                width: context.width,
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Container(
                      child: SelectableText(
                        'Separação de pedidos',
                        style: textStyleTitulo,
                      ),
                    ),
                    Container(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          Container(
                            width: context.width,
                            child: InputComponent(
                              initialValue: controller.controllerIdPedido.text,
                              hintText: 'Buscar',
                              onFieldSubmitted: (value) async {
                                controller.controllerIdPedido.text = value;
                                await controller.buscarPedidosSaidaSeparacao();
                              },
                            ),
                          ),
                          Container(
                            width: context.width,
                            child: ButtonComponent(
                                color: secundaryColor,
                                colorHover: secundaryColorHover,
                                onPressed: () {
                                  controller.filtro(!controller.filtro.value);
                                },
                                text: 'Adicionar filtro'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Obx(
                () => AnimatedContainer(
                  height: controller.filtro.value ? null : 0,
                  duration: Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              Container(
                                width: context.width,
                                child: InputComponent(
                                  inputFormatter: [
                                    controller.maskFormatter.dataFormatter()
                                  ],
                                  label: 'Período:',
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Esse campo é obrigatório !';
                                    }
                                    if (value.length != 10) {
                                      return 'Formato de data inválido';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    controller.dataInicio =
                                        DateFormat("dd/MM/yyyy").parse(value);
                                  },
                                  hintText: 'DD/MM/AAAA',
                                ),
                              ),
                              Container(
                                width: context.width,
                                child: InputComponent(
                                  inputFormatter: [
                                    controller.maskFormatter.dataFormatter()
                                  ],
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Esse campo é obrigatório !';
                                    }
                                    if (value.length != 10) {
                                      return 'Formato de data inválido';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    controller.dataFim =
                                        DateFormat("dd/MM/yyyy").parse(value);
                                  },
                                  hintText: 'DD/MM/AAAA',
                                ),
                              ),
                              // const SizedBox(width: 4),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ButtonComponent(
                                    color: vermelhoColor,
                                    colorHover: vermelhoColorHover,
                                    onPressed: () async {
                                      controller.limparFiltros();
                                      controller.formKey.currentState!.reset();
                                    },
                                    text: 'Limpar'),
                                SizedBox(
                                  width: 4,
                                ),
                                ButtonComponent(
                                    onPressed: () async {
                                      if (controller.formKey.currentState!
                                          .validate()) {
                                        controller.formKey.currentState!.save();
                                        await controller
                                            .buscarPedidosSaidaSeparacao();
                                      }
                                    },
                                    text: 'Pesquisar'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() => !controller.carregando.value
                    ? Container(
                        child: ListView.builder(
                          itemCount: controller.pedidosSaida.length,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: CardWidget(
                                  color: controller.pedidosSaida[index]
                                              .pedidoSaidaEvento?.length !=
                                          0
                                      ? HexColor(controller
                                              .pedidosSaida[index]
                                              .pedidoSaidaEvento
                                              ?.last
                                              .eventoStatus
                                              ?.statusCor ??
                                          '#040491')
                                      : primaryColor,
                                  widget: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextComponent(
                                                  'ID',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                SelectableText(
                                                  controller.pedidosSaida[index]
                                                      .idPedidoSaida
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 48,
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextComponent(
                                                  'Data de abertura',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                SelectableText(
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(controller
                                                          .pedidosSaida[index]
                                                          .dataEmissao!),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextComponent(
                                            'Nome',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          SelectableText(controller
                                                  .pedidosSaida[index]
                                                  .cliente
                                                  ?.nome
                                                  .toString()
                                                  .capitalize ??
                                              ''),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextComponent(
                                            'CPF/CNPJ',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          SelectableText(
                                            controller.maskFormatter
                                                .cpfCnpjFormatter(
                                                    value: controller
                                                        .pedidosSaida[index]
                                                        .cpfCnpj
                                                        .toString())!
                                                .getMaskedText(),
                                          ),
                                        ],
                                      ),
                                      // Expanded(
                                      //     flex: 2,
                                      //     child: TextComponent(
                                      //       'Situação',
                                      //       fontWeight: FontWeight.bold,
                                      //     )),
                                      SizedBox(
                                        height: 12,
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextComponent(
                                            'Valor total',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          SelectableText(controller.formatter
                                                  .format(controller
                                                      .pedidosSaida[index]
                                                      .valorTotal)
                                              // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                              ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextComponent(
                                            'Status',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          EventoStatusWidget(
                                            color: controller
                                                        .pedidosSaida[index]
                                                        .pedidoSaidaEvento
                                                        ?.length !=
                                                    0
                                                ? HexColor(controller
                                                        .pedidosSaida[index]
                                                        .pedidoSaidaEvento
                                                        ?.last
                                                        .eventoStatus
                                                        ?.statusCor ??
                                                    '#040491')
                                                : null,
                                            texto: controller
                                                        .pedidosSaida[index]
                                                        .pedidoSaidaEvento
                                                        ?.length !=
                                                    0
                                                ? controller
                                                        .pedidosSaida[index]
                                                        .pedidoSaidaEvento
                                                        ?.last
                                                        .eventoStatus
                                                        ?.descricao ??
                                                    ''
                                                : 'Aguardando status',
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextComponent(
                                            'Ações',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          ButtonAcaoWidget(
                                            detalhe: () {
                                              Get.toNamed(
                                                  '/separacao/${controller.pedidosSaida[index].idPedidoSaida}');

                                              Get.delete<
                                                  SeparacaoDetalheController>();
                                            },
                                          ),
                                        ],
                                      )
                                    ],

                                    // Divider(),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Expanded(
                                    //       child: Row(
                                    //         children: [
                                    //           SelectableText(
                                    //             controller
                                    //                 .pedidosSaida[index]
                                    //                 .idPedidoSaida
                                    //                 .toString(),
                                    //           )
                                    //         ],
                                    //       ),
                                    //     ),
                                    //     Expanded(
                                    //       flex: 4,
                                    //       child: SelectableText(controller
                                    //               .pedidosSaida[index]
                                    //               .cliente
                                    //               ?.nome
                                    //               .toString()
                                    //               .capitalize ??
                                    //           ''),
                                    //     ),
                                    //     Expanded(
                                    //         flex: 2,
                                    //         child: SelectableText(
                                    //           DateFormat('dd/MM/yyyy')
                                    //               .format(controller
                                    //                   .pedidosSaida[index]
                                    //                   .dataEmissao!),
                                    //         )),
                                    //     Expanded(
                                    //         flex: 2,
                                    //         child: SelectableText(
                                    //           controller.maskFormatter
                                    //               .cpfCnpjFormatter(
                                    //                   value: controller
                                    //                       .pedidosSaida[
                                    //                           index]
                                    //                       .cpfCnpj
                                    //                       .toString())!
                                    //               .getMaskedText(),
                                    //         )),
                                    //     // Expanded(
                                    //     //     flex: 2,
                                    //     //     child: TextComponent(controller.pedidosSaida[index].situacao.toString())),
                                    //     Expanded(
                                    //         flex: 2,
                                    //         child: SelectableText(controller
                                    //                 .formatter
                                    //                 .format(controller
                                    //                     .pedidosSaida[index]
                                    //                     .valorTotal)
                                    //             // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                    //             )),
                                    //     Expanded(
                                    //       flex: 3,
                                    //       child: Row(
                                    //         children: [
                                    //           EventoStatusWidget(
                                    //             color: controller
                                    //                         .pedidosSaida[
                                    //                             index]
                                    //                         .pedidoSaidaEvento
                                    //                         ?.length !=
                                    //                     0
                                    //                 ? HexColor(controller
                                    //                         .pedidosSaida[
                                    //                             index]
                                    //                         .pedidoSaidaEvento
                                    //                         ?.last
                                    //                         .eventoStatus
                                    //                         ?.statusCor ??
                                    //                     '#040491')
                                    //                 : null,
                                    //             texto: controller
                                    //                         .pedidosSaida[
                                    //                             index]
                                    //                         .pedidoSaidaEvento
                                    //                         ?.length !=
                                    //                     0
                                    //                 ? controller
                                    //                         .pedidosSaida[
                                    //                             index]
                                    //                         .pedidoSaidaEvento
                                    //                         ?.last
                                    //                         .eventoStatus
                                    //                         ?.descricao ??
                                    //                     ''
                                    //                 : 'Aguardando status',
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //     Expanded(
                                    //       flex: 2,
                                    //       child: ButtonAcaoWidget(
                                    //         detalhe: () {
                                    //           Get.toNamed(
                                    //               '/separacao/${controller.pedidosSaida[index].idPedidoSaida}');

                                    //           Get.delete<
                                    //               SeparacaoDetalheController>();
                                    //         },
                                    //       ),
                                    //       // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                    //     )
                                    //   ],
                                    // )
                                  ),
                                ));
                          },
                        ),
                      )
                    : LoadingComponent()),
              ),
              Container(
                // margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                child: GetBuilder<SeparacaoController>(
                  builder: (_) => PaginacaoComponent(
                    total: controller.pagina.getTotal(),
                    atual: controller.pagina.getAtual(),
                    primeiraPagina: () {
                      controller.pagina.primeira();
                      controller.buscarPedidosSaidaSeparacao();
                    },
                    anteriorPagina: () {
                      controller.pagina.anterior();
                      controller.buscarPedidosSaidaSeparacao();
                    },
                    proximaPagina: () {
                      controller.pagina.proxima();
                      controller.buscarPedidosSaidaSeparacao();
                    },
                    ultimaPagina: () {
                      controller.pagina.ultima();
                      controller.buscarPedidosSaidaSeparacao();
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
