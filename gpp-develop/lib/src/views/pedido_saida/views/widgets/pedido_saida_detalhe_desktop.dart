import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/views/pedido_saida/views/widgets/TimeLine.dart';

import 'package:gpp/src/views/separacao/controllers/separacao_controller.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/GerarPedidoSaidaPDF.dart';

import 'package:gpp/src/views/pedido_saida/controllers/pedido_saida_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';

import 'package:gpp/src/views/widgets/sidebar_widget.dart';

import '../../../../enums/pedido_saida_status_enum.dart';

class PedidoSaidaDetalheDesktop extends StatelessWidget {
  const PedidoSaidaDetalheDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PedidoSaidaDetalheController>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: NavbarWidget(),
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              color: Colors.white,
              child: Obx(() => !controller.carregando.value
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TitleComponent('Ordem de saída'),
                              EventoStatusWidget(
                                color: controller.pedidoSaida.pedidoSaidaEvento
                                            ?.length !=
                                        0
                                    ? HexColor(controller
                                            .pedidoSaida
                                            .pedidoSaidaEvento
                                            ?.last
                                            .eventoStatus
                                            ?.statusCor ??
                                        '#040491')
                                    : null,
                                texto: controller.pedidoSaida.pedidoSaidaEvento
                                            ?.length !=
                                        0
                                    ? controller.pedidoSaida.pedidoSaidaEvento
                                            ?.last.eventoStatus?.descricao ??
                                        ''
                                    : 'Aguardando status',
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InputComponent(
                                  readOnly: true,
                                  label: 'Código da ordem de saída',
                                  initialValue: controller
                                      .pedidoSaida.idPedidoSaida
                                      .toString(),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                  readOnly: true,
                                  label: 'Nº Documento Fiscal',
                                  initialValue: controller
                                      .pedidoSaida.numDocFiscal
                                      .toString(),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                  readOnly: true,
                                  label: 'Série Documento Fiscal',
                                  initialValue:
                                      controller.pedidoSaida.serieDocFiscal,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                  readOnly: true,
                                  label: 'CPF/CNPJ',
                                  initialValue: controller.maskFormatter
                                      .cpfCnpjFormatter(
                                          value: controller.pedidoSaida.cpfCnpj
                                              .toString())!
                                      .getMaskedText(),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                  readOnly: true,
                                  label: 'Filial de venda',
                                  initialValue: controller
                                      .pedidoSaida.filial_registro
                                      .toString(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InputComponent(
                                  readOnly: true,
                                  label: 'Data de emissão',
                                  initialValue: controller.maskFormatter
                                      .dataFormatterAmericano(
                                          value: controller
                                              .pedidoSaida.dataEmissao
                                              .toString())
                                      .getMaskedText(),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                    readOnly: true,
                                    label: 'Valor total R\$',
                                    initialValue: controller.formatter.format(
                                        controller.pedidoSaida.valorTotal)),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [TitleComponent('Asteca')],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InputComponent(
                                    readOnly: true,
                                    label: 'Código da asteca',
                                    initialValue: controller
                                                .pedidoSaida.asteca!.idAsteca ==
                                            null
                                        ? ''
                                        : controller
                                            .pedidoSaida.asteca!.idAsteca
                                            .toString()),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                    readOnly: true,
                                    label: 'Cliente',
                                    initialValue: controller
                                        .pedidoSaida.cliente!.nome
                                        .toString()
                                        .capitalize),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
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
                                          '')),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Obx(
                              //   () => !controller.carregandoEmail.value
                              //       ? ButtonComponent(
                              //           color: secundaryColor,
                              //           colorHover: secundaryColorHover,
                              //           icon: Icon(
                              //             Icons.email,
                              //             color: Colors.white,
                              //           ),
                              //           onPressed: () async {
                              //             await controller.enviarEmailPedidoSaida();
                              //           },
                              //           text: 'Enviar e-mail')
                              //       : LoadingComponent(),
                              // ),
                              SizedBox(
                                width: 8,
                              ),
                              ButtonComponent(
                                icon: Icon(
                                  Icons.wysiwyg_outlined,
                                  color: Colors.white,
                                ),
                                color: secundaryColor,
                                onPressed: () {
                                  Get.toNamed(
                                      '/astecas/${controller.pedidoSaida.asteca!.idAsteca}');
                                },
                                text: 'Ver mais',
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [TitleComponent('Itens do pedido')],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  color: Colors.grey.shade200,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        'Valor R\$',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          child: TextComponent(
                                        'Subtotal R\$',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          child: TextComponent(
                                        'Endereço',
                                        fontWeight: FontWeight.bold,
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              child: Column(
                            children: controller.pedidoSaida.itemsPedidoSaida!
                                .map<Widget>((e) {
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
                                      child: SelectableText(
                                        e.idItemPedidoSaida.toString(),
                                      ),
                                    ),
                                    Expanded(
                                      child: SelectableText(
                                        e.peca!.id_peca.toString(),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: SelectableText(
                                          e.peca?.descricao
                                                  ?.toString()
                                                  .capitalize ??
                                              '',
                                        )),
                                    Expanded(
                                        child: SelectableText(
                                      e.quantidade.toString(),
                                    )),
                                    Expanded(
                                      child: SelectableText(
                                          controller.formatter.format(e.valor)),
                                    ),
                                    Expanded(
                                        child: SelectableText(
                                      controller.formatter
                                          .format((e.valor * e.quantidade)),
                                    )),
                                    Expanded(
                                        child: SelectableText(
                                      e.pecaEstoque?.endereco ?? '',
                                    )),
                                  ],
                                ),
                              );
                            }).toList(),
                          )),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                TitleComponent('Rastreio do pedido'),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: context.width,
                            child: ProcessTimelinePage(
                                evento:
                                    controller.pedidoSaida.pedidoSaidaEvento!),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            height: Get.height * 0.40,
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    color: Colors.grey.shade200,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextComponent(
                                            'ID do evento',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            'Status',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            'Descrição',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            'Data',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            'Hora',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            'Funcionário',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: controller.pedidoSaida
                                          .pedidoSaidaEvento!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color:
                                                          Colors.grey.shade100),
                                                  left: BorderSide(
                                                      color:
                                                          Colors.grey.shade100),
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey.shade100),
                                                  right: BorderSide(
                                                      color: Colors
                                                          .grey.shade100))),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: SelectableText(controller
                                                        .pedidoSaida
                                                        .pedidoSaidaEvento?[
                                                            index]
                                                        .idPedidoSaidaEvento
                                                        .toString() ??
                                                    ''),
                                              ),
                                              Expanded(
                                                child: SelectableText(controller
                                                        .pedidoSaida
                                                        .pedidoSaidaEvento?[
                                                            index]
                                                        .eventoStatus
                                                        ?.descricao
                                                        .toString() ??
                                                    ''),
                                              ),
                                              Expanded(
                                                child: SelectableText(controller
                                                        .pedidoSaida
                                                        .pedidoSaidaEvento?[
                                                            index]
                                                        .eventoStatus
                                                        ?.mensagemPadrao
                                                        .toString() ??
                                                    ''),
                                              ),
                                              Expanded(
                                                  child: SelectableText(
                                                controller
                                                            .pedidoSaida
                                                            .pedidoSaidaEvento?[
                                                                index]
                                                            .dataEvento !=
                                                        null
                                                    ? DateFormat('dd/MM/yyyy')
                                                        .format(controller
                                                            .pedidoSaida
                                                            .pedidoSaidaEvento![
                                                                index]
                                                            .dataEvento!)
                                                    : '',
                                              )),
                                              Expanded(
                                                  child: SelectableText(
                                                controller
                                                            .pedidoSaida
                                                            .pedidoSaidaEvento?[
                                                                index]
                                                            .dataEvento !=
                                                        null
                                                    ? DateFormat('HH:mm')
                                                        .format(controller
                                                            .pedidoSaida
                                                            .pedidoSaidaEvento![
                                                                index]
                                                            .dataEvento!)
                                                    : '',
                                              )),
                                              Expanded(
                                                child: SelectableText(controller
                                                        .pedidoSaida
                                                        .pedidoSaidaEvento?[
                                                            index]
                                                        .funcionario
                                                        ?.clienteFunc
                                                        ?.cliente
                                                        ?.nome
                                                        .toString()
                                                        .capitalize ??
                                                    ''),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ButtonComponent(
                                  color: primaryColor,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  text: 'Voltar'),
                              Row(
                                children: [
                                  Obx(() => !controller
                                          .carregandoSeparacao.value
                                      ? controller.pedidoSaida
                                              .pedidoSaidaEvento!.isNotEmpty
                                          ? controller
                                                      .pedidoSaida
                                                      .pedidoSaidaEvento!
                                                      .last
                                                      .eventoStatus!
                                                      .id_evento_status ==
                                                  PedidoSaidaStatusEnum
                                                      .AGUARDANDO_FORNECEDOR
                                              ? controller.pedidoSaida
                                                      .verificaEstoque!
                                                  ? ButtonComponent(
                                                      color: primaryColor,
                                                      colorHover:
                                                          primaryColorHover,
                                                      onPressed: () async {
                                                        await controller
                                                            .encaminharSeparacao();
                                                        Get.delete<
                                                            PedidoSaidaDetalheController>();

                                                        Get.delete<
                                                            SeparacaoController>();
                                                      },
                                                      text:
                                                          'Encaminhar para separação',
                                                    )
                                                  : SizedBox.shrink()
                                              : SizedBox.shrink()
                                          : SizedBox.shrink()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(right: 100),
                                          child: LoadingComponent(),
                                        )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  // controller.pedidoSaida.pedidoSaidaEvento != null &&
                                  //         controller.pedidoSaida.pedidoSaidaEvento!.length != 0 &&
                                  //         controller.pedidoSaida.pedidoSaidaEvento!.last.idEventoStatus !=
                                  //             PedidoSaidaStatusEnum.CANCELADO &&
                                  //         controller.pedidoSaida.pedidoSaidaEvento!.last.idEventoStatus !=
                                  //             PedidoSaidaStatusEnum.CONCLUIDO
                                  //     ? ButtonComponent(
                                  //         color: vermelhoColor,
                                  //         colorHover: vermelhoColorHover,
                                  //         onPressed: () async {
                                  //           // await controller.cancelarPedidoSaida(controller.pedidoSaida.idPedidoSaida);
                                  //         },
                                  //         text: 'Cancelar pedido')
                                  //     : Container(),
                                  // SizedBox(
                                  //   width: 8,
                                  // ),
                                  ButtonComponent(
                                      color: secundaryColor,
                                      colorHover: secundaryColorHover,
                                      icon: Icon(
                                        Icons.print,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        GerarPedidoSaidaPDF(
                                                pedido: controller.pedidoSaida)
                                            .imprimirPDF();
                                      },
                                      text: 'Imprimir')
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  : LoadingComponent()),
            ),
          ),
        ],
      ),
    );
  }
}
