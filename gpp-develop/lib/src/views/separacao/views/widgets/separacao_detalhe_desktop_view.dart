import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:intl/intl.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/separacao/controllers/separacao_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../shared/components/TextComponent.dart';

class SeparacaoDetalheDesktopView extends StatelessWidget {
  SeparacaoDetalheDesktopView({Key? key}) : super(key: key);

  final controller = Get.find<SeparacaoDetalheController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavbarWidget(),
        backgroundColor: Colors.white,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            context.width > 576 ? Sidebar() : Container(),
            Expanded(
                child: Container(
              height: context.height,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: context.width,
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Container(
                            width: context.width < 576 ? context.width : null,
                            child: TextComponent(
                              'Separação de pedidos',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            width: context.width < 576 ? context.width : null,
                            child: Obx(() => !controller.carregando.value
                                ? EventoStatusWidget(
                                    texto: controller.pedidoSaida.pedidoSaidaEvento?.length != 0
                                        ? controller.pedidoSaida.pedidoSaidaEvento?.last.eventoStatus?.mensagemPadrao ?? ''
                                        : 'Aguardando status',
                                  )
                                : Container()),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.etapa(1);
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: controller.etapa == 1 ? secundaryColor : Colors.grey.shade200,
                                              width: controller.etapa == 1 ? 4 : 1))),
                                  child: TextComponent('Informações da ordem de serviço')),
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.etapa(2);
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: controller.etapa == 2 ? secundaryColor : Colors.grey.shade200,
                                            width: controller.etapa == 2 ? 4 : 1)),
                                  ),
                                  child: TextComponent('Separar peças')),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Obx(() => controller.etapa == 1
                          ? Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Obx(() => !controller.carregando.value
                                            ? Container(
                                                width: context.width,
                                                margin: EdgeInsets.symmetric(vertical: 16),
                                                child: Wrap(runSpacing: 10, spacing: 10, children: [
                                                  Container(
                                                    width: context.width < 576 ? context.width : 320,
                                                    child: InputComponent(
                                                      readOnly: true,
                                                      label: 'Código da ordem de saída',
                                                      initialValue: controller.pedidoSaida.idPedidoSaida.toString(),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: context.width < 576 ? context.width : 320,
                                                    child: InputComponent(
                                                      readOnly: true,
                                                      label: 'Cliente',
                                                      initialValue:
                                                          controller.pedidoSaida.cliente?.nome.toString().capitalize ?? '',
                                                    ),
                                                  ),
                                                  Container(
                                                    width: context.width < 576 ? context.width : 320,
                                                    child: InputComponent(
                                                      readOnly: true,
                                                      label: 'Produto',
                                                      initialValue: controller
                                                              .pedidoSaida.asteca?.compEstProd?.first.produto?.resumida
                                                              .toString()
                                                              .capitalize ??
                                                          '',
                                                    ),
                                                  ),
                                                  Container(
                                                    width: context.width < 576 ? context.width : 320,
                                                    child: InputComponent(
                                                      readOnly: true,
                                                      label: 'Data de emissão',
                                                      initialValue:
                                                          DateFormat('dd/MM/yyyy').format(controller.pedidoSaida.dataEmissao!),
                                                    ),
                                                  ),
                                                ]),
                                              )
                                            : Container()),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    width: context.width,
                                    child: Wrap(
                                      children: [
                                        Container(
                                          width: context.width < 576 ? context.width : 255,
                                          child: ButtonComponent(
                                              color: primaryColor,
                                              onPressed: () {
                                                Get.offAllNamed('/separacao');
                                              },
                                              text: 'Voltar'),
                                        ),
                                      ],
                                    )),
                              ],
                            )
                          : Container()),
                    ),
                    Obx(() => controller.etapa == 2
                        ? Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  child: Form(
                                    key: controller.formKey,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: InputComponent(
                                            suffixIcon: Icon(
                                              Icons.qr_code_scanner_rounded,
                                            ),
                                            autofocus: true,
                                            hintText: 'Informe o código da peça',
                                            inputFormatter: [
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            onFieldSubmitted: (value) {
                                              controller.formKey.currentState!.reset();
                                              controller.separarPeca(int.parse(value));
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: ButtonComponent(onPressed: () {}, text: 'Separar'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  color: Colors.grey.shade200,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: TextComponent(
                                        'ID do item',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          child: TextComponent(
                                        'ID da peça',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          flex: 2,
                                          child: TextComponent(
                                            'Descrição',
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                          child: TextComponent(
                                        'Quantidade',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          child: TextComponent(
                                        'Endereço',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          child: TextComponent(
                                        'Separado',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          flex: 2,
                                          child: TextComponent(
                                            'Data de separação',
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                          child: TextComponent(
                                        'Hora de separação',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          child: TextComponent(
                                        'Separador',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                        child: TextComponent(
                                          'Status da separação',
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TextComponent(
                                                'Ações',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: context.height * 0.4,
                                  child: Obx(() => !controller.carregando.value
                                      ? ListView.builder(
                                          itemCount: controller.pedidoSaida.itemsPedidoSaida!.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      top: BorderSide(color: Colors.grey.shade100),
                                                      left: BorderSide(color: Colors.grey.shade100),
                                                      bottom: BorderSide(color: Colors.grey.shade100),
                                                      right: BorderSide(color: Colors.grey.shade100))),
                                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                              child: Row(children: [
                                                Expanded(
                                                  child: SelectableText(controller
                                                          .pedidoSaida.itemsPedidoSaida?[index].idItemPedidoSaida
                                                          .toString() ??
                                                      ''),
                                                ),
                                                Expanded(
                                                  child: SelectableText(
                                                      controller.pedidoSaida.itemsPedidoSaida?[index].peca?.id_peca.toString() ??
                                                          ''),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: SelectableText(controller
                                                          .pedidoSaida.itemsPedidoSaida?[index].peca?.descricao
                                                          .toString()
                                                          .capitalize ??
                                                      ''),
                                                ),
                                                Expanded(
                                                  child: SelectableText(
                                                      controller.pedidoSaida.itemsPedidoSaida?[index].quantidade.toString() ??
                                                          ''),
                                                ),
                                                Expanded(
                                                  child: SelectableText(
                                                      controller.pedidoSaida.itemsPedidoSaida?[index].endereco.toString() ?? ''),
                                                ),
                                                Expanded(
                                                    child: SelectableText(
                                                  controller.pedidoSaida.itemsPedidoSaida?[index].separado.toString() ?? '',
                                                )),
                                                Expanded(
                                                    flex: 2,
                                                    child: SelectableText(
                                                      controller.pedidoSaida.itemsPedidoSaida?[index].dataSeparacao != null
                                                          ? DateFormat('dd/MM/yyyy').format(
                                                              controller.pedidoSaida.itemsPedidoSaida![index].dataSeparacao!)
                                                          : '',
                                                    )),
                                                Expanded(
                                                    child: SelectableText(
                                                  controller.pedidoSaida.itemsPedidoSaida?[index].dataSeparacao != null
                                                      ? DateFormat('HH:mm')
                                                          .format(controller.pedidoSaida.itemsPedidoSaida![index].dataSeparacao!)
                                                      : '',
                                                )),
                                                Expanded(
                                                  child: SelectableText(
                                                    controller.pedidoSaida.itemsPedidoSaida?[index].separador?.clienteFunc
                                                            ?.cliente?.nome
                                                            .toString()
                                                            .capitalize ??
                                                        '',
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextComponent(
                                                    '${controller.pedidoSaida.itemsPedidoSaida?[index].separado ?? 0} / ${controller.pedidoSaida.itemsPedidoSaida?[index].quantidade}',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                // Expanded(
                                                //   child: LinearPercentIndicator(
                                                //     center: TextComponent(
                                                //       ((controller.pedidoSaida.itemsPedidoSaida![index].quantidade != null &&
                                                //                           controller.pedidoSaida.itemsPedidoSaida![index]
                                                //                                   .separado !=
                                                //                               null
                                                //                       ? (controller
                                                //                               .pedidoSaida.itemsPedidoSaida![index].separado! /
                                                //                           controller
                                                //                               .pedidoSaida.itemsPedidoSaida![index].quantidade)
                                                //                       : 0) *
                                                //                   100)
                                                //               .toStringAsFixed(2) +
                                                //           ' %',
                                                //       fontWeight: FontWeight.bold,
                                                //     ),
                                                //     lineHeight: 20.0,
                                                //     percent: controller.pedidoSaida.itemsPedidoSaida?[index].quantidade != null &&
                                                //             controller.pedidoSaida.itemsPedidoSaida?[index].separado != null
                                                //         ? (controller.pedidoSaida.itemsPedidoSaida?[index].separado! /
                                                //             controller.pedidoSaida.itemsPedidoSaida?[index].quantidade)
                                                //         : 0,
                                                //     backgroundColor: Colors.grey.shade200,
                                                //     progressColor: Colors.lightGreenAccent.shade700,
                                                //   ),
                                                // ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Obx(
                                                          () => !controller.carregandoBotaoSeparar.value
                                                              ? ButtonComponent(
                                                                  color: primaryColor,
                                                                  colorHover: primaryColorHover,
                                                                  onPressed: () async {
                                                                    if (controller
                                                                            .pedidoSaida.itemsPedidoSaida![index].quantidade !=
                                                                        controller
                                                                            .pedidoSaida.itemsPedidoSaida![index].separado) {
                                                                      await controller.separarItemPedidoSaidaPeca(
                                                                        controller.pedidoSaida.itemsPedidoSaida![index]
                                                                            .idItemPedidoSaida!,
                                                                        controller
                                                                            .pedidoSaida.itemsPedidoSaida![index].peca!.id_peca!,
                                                                      );
                                                                    }
                                                                  },
                                                                  text: 'Separar',
                                                                )
                                                              : LoadingComponent(),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        ButtonComponent(
                                                            color: vermelhoColor,
                                                            colorHover: vermelhoColorHover,
                                                            onPressed: () async {
                                                              if (controller.pedidoSaida.itemsPedidoSaida![index].separado != 0) {
                                                                await controller.cancelarItemPedidoSaidaPeca(
                                                                    controller
                                                                        .pedidoSaida.itemsPedidoSaida![index].idItemPedidoSaida!,
                                                                    controller
                                                                        .pedidoSaida.itemsPedidoSaida![index].peca!.id_peca!);
                                                              }
                                                            },
                                                            text: 'Cancelar'),
                                                      ],
                                                    )),
                                              ]),
                                            );
                                          },
                                        )
                                      : LoadingComponent()),
                                ),
                                Obx(() => !controller.carregando.value
                                    ? Container(
                                        margin: EdgeInsets.symmetric(vertical: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextComponent(
                                                'Total de itens aguardando separação: ${controller.pedidoSaida.itemsPedidoSaida!.length}'),
                                            Row(
                                              children: [
                                                ButtonComponent(
                                                    color: vermelhoColor,
                                                    colorHover: vermelhoColorHover,
                                                    onPressed: () {
                                                      Get.toNamed('/separacao');
                                                    },
                                                    text: 'Cancelar'),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                controller.pedidoSaida.pedidoSaidaEvento!.last.idEventoStatus == 2
                                                    ? Obx(() => !controller.iniciandoSeparacao.value
                                                        ? ButtonComponent(
                                                            onPressed: () {
                                                              controller.alterarPedidoSaidaEvento(3);
                                                            },
                                                            text: 'Iniciar Separação')
                                                        : Container(width: 100, child: Center(child: LoadingComponent())))
                                                    : Container(),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                controller.pedidoSaida.pedidoSaidaEvento!.last.idEventoStatus == 3
                                                    ? Container(
                                                        child: controller.separacaoCompleta.value
                                                            ? Obx(() => !controller.finalizando.value
                                                                ? ButtonComponent(
                                                                    color: secundaryColor,
                                                                    colorHover: secundaryColorHover,
                                                                    onPressed: () {
                                                                      controller.finalizarSeparacao();
                                                                    },
                                                                    text: 'Finalizar separação')
                                                                : Container(width: 100, child: Center(child: LoadingComponent())))
                                                            : ButtonComponent(
                                                                color: Colors.grey.shade500,
                                                                onPressed: () {},
                                                                text: 'Finalizar separação'),
                                                      )
                                                    : Container()
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : Container())
                              ],
                            ),
                          )
                        : Container()),
                  ],
                ),
              ),
            )),
          ],
        ));
  }
}
