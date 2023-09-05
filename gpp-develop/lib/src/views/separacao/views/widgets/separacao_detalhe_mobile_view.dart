import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/separacao/controllers/separacao_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

import '../../../../shared/components/TextComponent.dart';

class SeparacaoDetalheMobileView extends StatelessWidget {
  SeparacaoDetalheMobileView({Key? key}) : super(key: key);

  final controller = Get.find<SeparacaoDetalheController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      backgroundColor: Colors.white,
      drawer: Sidebar(),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          child: TextComponent(
                            'Separação de pedidos',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => !controller.carregando.value
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextComponent(
                                  controller.pedidoSaida.pedidoSaidaEvento
                                              ?.length !=
                                          0
                                      ? controller
                                              .pedidoSaida
                                              .pedidoSaidaEvento
                                              ?.last
                                              .eventoStatus
                                              ?.mensagemPadrao ??
                                          ''
                                      : 'Aguardando status',
                                  fontSize: context.textScaleFactor * 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Container()),
                      ],
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
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: controller.etapa == 1
                                            ? secundaryColor
                                            : Colors.grey.shade200,
                                        width: controller.etapa == 1 ? 4 : 1))),
                            child: TextComponent(
                                'Informações da ordem de serviço')),
                      ),
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: () {
                          controller.etapa(2);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: controller.etapa == 2
                                          ? secundaryColor
                                          : Colors.grey.shade200,
                                      width: controller.etapa == 2 ? 4 : 1)),
                            ),
                            child: TextComponent('Separar peças')),
                      ),
                    )
                  ],
                ),
              ),
              Obx(() => controller.etapa == 1
                  ? Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(() => !controller.carregando.value
                                      ? Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: InputComponent(
                                                      readOnly: true,
                                                      label: 'ID',
                                                      initialValue: controller
                                                          .pedidoSaida
                                                          .idPedidoSaida
                                                          .toString(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: InputComponent(
                                                      readOnly: true,
                                                      label: 'Cliente',
                                                      initialValue: controller
                                                              .pedidoSaida
                                                              .cliente
                                                              ?.nome
                                                              .toString()
                                                              .capitalize ??
                                                          '',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // SizedBox(
                                              //   height: 1,
                                              // ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: InputComponent(
                                                      readOnly: true,
                                                      label: 'Produto',
                                                      initialValue: controller
                                                              .pedidoSaida
                                                              .asteca
                                                              ?.compEstProd
                                                              ?.first
                                                              .produto
                                                              ?.resumida
                                                              .toString()
                                                              .capitalize ??
                                                          '',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: InputComponent(
                                                      readOnly: true,
                                                      label: 'Data de emissão',
                                                      initialValue: DateFormat(
                                                              'dd/MM/yyyy')
                                                          .format(controller
                                                              .pedidoSaida
                                                              .dataEmissao!),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
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
                      ),
                    )
                  : Container()),
              Obx(() => controller.etapa == 2
                  ? Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          child: Form(
                            key: controller.formKey,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
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
                                  child: ButtonComponent(
                                      onPressed: () {}, text: 'Separar'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Obx(() => !controller.carregando.value
                              ? ListView.builder(
                                  controller: new ScrollController(),
                                  shrinkWrap: true,
                                  itemCount: controller
                                      .pedidoSaida.itemsPedidoSaida!.length,
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
                                                  color:
                                                      Colors.grey.shade100))),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 8),
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            // Expanded(
                                            //   child: TextComponent(
                                            //       'ID do item:  ${controller.pedidoSaida.itemsPedidoSaida?[index].idItemPedidoSaida.toString() ?? ''}'),
                                            // ),
                                            // SizedBox(
                                            //   width: 16,
                                            // ),
                                            Expanded(
                                              flex: 2,
                                              child: TextComponent(
                                                  'ID da peça: ${controller.pedidoSaida.itemsPedidoSaida?[index].peca?.id_peca.toString() ?? ''}'),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: TextComponent(
                                                  'Quantidade: ${controller.pedidoSaida.itemsPedidoSaida?[index].quantidade.toString() ?? ''}'),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextComponent(
                                                  'Status da separação: ${controller.pedidoSaida.itemsPedidoSaida?[index].separado ?? 0} / ${controller.pedidoSaida.itemsPedidoSaida?[index].quantidade}'),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Obx(
                                                      () => !controller
                                                              .carregandoBotaoSeparar
                                                              .value
                                                          ? ButtonComponent(
                                                              color:
                                                                  primaryColor,
                                                              colorHover:
                                                                  primaryColorHover,
                                                              onPressed:
                                                                  () async {
                                                                if (controller
                                                                        .pedidoSaida
                                                                        .itemsPedidoSaida![
                                                                            index]
                                                                        .quantidade !=
                                                                    controller
                                                                        .pedidoSaida
                                                                        .itemsPedidoSaida![
                                                                            index]
                                                                        .separado) {
                                                                  await controller.separarItemPedidoSaidaPeca(
                                                                      controller
                                                                          .pedidoSaida
                                                                          .itemsPedidoSaida![
                                                                              index]
                                                                          .idItemPedidoSaida!,
                                                                      controller
                                                                          .pedidoSaida
                                                                          .itemsPedidoSaida![
                                                                              index]
                                                                          .peca!
                                                                          .id_peca!);
                                                                }
                                                              },
                                                              text: 'Separar')
                                                          : LoadingComponent(),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    ButtonComponent(
                                                        color: vermelhoColor,
                                                        colorHover:
                                                            vermelhoColorHover,
                                                        onPressed: () async {
                                                          if (controller
                                                                  .pedidoSaida
                                                                  .itemsPedidoSaida![
                                                                      index]
                                                                  .separado !=
                                                              0) {
                                                            await controller.cancelarItemPedidoSaidaPeca(
                                                                controller
                                                                    .pedidoSaida
                                                                    .itemsPedidoSaida![
                                                                        index]
                                                                    .idItemPedidoSaida!,
                                                                controller
                                                                    .pedidoSaida
                                                                    .itemsPedidoSaida![
                                                                        index]
                                                                    .peca!
                                                                    .id_peca!);
                                                          }
                                                        },
                                                        text: 'Cancelar'),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ]),
                                    );
                                  },
                                )
                              : LoadingComponent()),
                        ),
                      ],
                    )
                  : Container()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 95,
        child: Column(
          children: [
            Container(
              // height: context.height * 0.10,
              child: Obx(() => !controller.carregando.value
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: TextComponent(
                                'Total de itens aguardando separação: ${controller.pedidoSaida.itemsPedidoSaida!.length}'),
                          ),
                        ],
                      ),
                    )
                  : Container()),
            ),
            Container(
              child: Obx(() => !controller.carregando.value
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonComponent(
                              color: vermelhoColor,
                              colorHover: vermelhoColorHover,
                              onPressed: () {
                                Get.back();
                              },
                              text: 'Cancelar'),
                          SizedBox(
                            width: 8,
                          ),
                          controller.pedidoSaida.pedidoSaidaEvento!.last
                                      .idEventoStatus ==
                                  2
                              ? Obx(() => !controller.iniciandoSeparacao.value
                                  ? ButtonComponent(
                                      onPressed: () {
                                        controller.alterarPedidoSaidaEvento(3);
                                      },
                                      text: 'Iniciar Separação')
                                  : Container(
                                      width: 100,
                                      child: Center(child: LoadingComponent())))
                              : Container(),
                          SizedBox(
                            width: 8,
                          ),
                          controller.pedidoSaida.pedidoSaidaEvento!.last
                                      .idEventoStatus ==
                                  3
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
                                          : Container(
                                              width: 100,
                                              child: Center(
                                                  child: LoadingComponent())))
                                      : ButtonComponent(
                                          color: Colors.grey.shade500,
                                          onPressed: () {},
                                          text: 'Finalizar separação'),
                                )
                              : Container()
                        ],
                      ),
                    )
                  : Container()),
            ),
          ],
        ),
      ),
    );
  }
}
