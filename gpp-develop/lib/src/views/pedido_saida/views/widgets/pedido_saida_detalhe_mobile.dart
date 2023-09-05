// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/enums/pedido_saida_status_enum.dart';
import 'package:gpp/src/models/item_pedido_saida_model.dart';
import 'package:gpp/src/views/pedido_saida/views/widgets/TimeLine.dart';

import 'package:gpp/src/views/separacao/controllers/separacao_controller.dart';
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
import 'package:gpp/src/views/widgets/card_widget.dart';

import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class PedidoSaidaDetalheMobile extends StatelessWidget {
  PedidoSaidaDetalheMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PedidoSaidaDetalheController>();

    return Scaffold(
      appBar: NavbarWidget(),
      backgroundColor: backgroundColor,
      drawer: Sidebar(),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        color: Colors.white,
        child: Obx(() => !controller.carregando.value
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextComponent(
                          'Ordem de saída',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // width: 260,
                          constraints: BoxConstraints(minWidth: 140, maxWidth: 140),
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                              color: controller.pedidoSaida.pedidoSaidaEvento?.length != 0
                                  ? HexColor(controller.pedidoSaida.pedidoSaidaEvento?.last.eventoStatus?.statusCor ?? '#040491')
                                  : primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextComponent(
                            controller.pedidoSaida.pedidoSaidaEvento?.length != 0
                                ? controller.pedidoSaida.pedidoSaidaEvento?.last.eventoStatus?.descricao ?? ''
                                : 'Aguardando status',
                            fontSize: context.textScaleFactor * 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputComponent(
                            readOnly: true,
                            label: 'Código da ordem de saída',
                            initialValue: controller.pedidoSaida.idPedidoSaida.toString(),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: InputComponent(
                            readOnly: true,
                            label: 'Nº Documento Fiscal',
                            initialValue: controller.pedidoSaida.numDocFiscal.toString(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputComponent(
                            readOnly: true,
                            label: 'Série Documento Fiscal',
                            initialValue: controller.pedidoSaida.serieDocFiscal,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: InputComponent(
                            readOnly: true,
                            label: 'Filial de venda',
                            initialValue: controller.pedidoSaida.filial_registro.toString(),
                          ),
                        ),
                      ],
                    ),
                    InputComponent(
                      readOnly: true,
                      label: 'CPF/CNPJ',
                      initialValue: controller.maskFormatter
                          .cpfCnpjFormatter(value: controller.pedidoSaida.cpfCnpj.toString())!
                          .getMaskedText(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputComponent(
                            readOnly: true,
                            label: 'Data de emissão',
                            initialValue: controller.maskFormatter
                                .dataFormatterAmericano(value: controller.pedidoSaida.dataEmissao.toString())
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
                              initialValue: controller.formatter.format(controller.pedidoSaida.valorTotal)),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: TitleComponent('Asteca'),
                    ),
                    InputComponent(
                      readOnly: true,
                      label: 'Código da asteca',
                      initialValue: controller.pedidoSaida.asteca!.idAsteca == null
                          ? ''
                          : controller.pedidoSaida.asteca!.idAsteca.toString(),
                    ),
                    InputComponent(
                        readOnly: true,
                        label: 'Cliente',
                        initialValue: controller.pedidoSaida.cliente!.nome.toString().capitalize),
                    InputComponent(
                        readOnly: true,
                        label: 'Produto',
                        initialValue:
                            controller.pedidoSaida.asteca?.compEstProd?.first.produto?.resumida.toString().capitalize ?? ''),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                            Get.toNamed('/astecas/${controller.pedidoSaida.asteca!.idAsteca}');
                          },
                          text: 'Ver mais',
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: TitleComponent('Itens do pedido'),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.pedidoSaida.itemsPedidoSaida!.length,
                      itemBuilder: (context, index) {
                        List<ItemPedidoSaidaModel> itensPedido = controller.pedidoSaida.itemsPedidoSaida!;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CardWidget(
                            widget: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            TextComponent(
                                              'Código do item',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              itensPedido[index].idItemPedidoSaida.toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            TextComponent(
                                              'Código da peça',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              itensPedido[index].peca?.id_peca.toString() ?? '',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      TextComponent(
                                        'Descrição',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Flexible(
                                        child: Text(
                                          itensPedido[index].peca?.descricao.toString().capitalize ?? '',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            TextComponent(
                                              'Quantidade',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              itensPedido[index].quantidade.toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            TextComponent(
                                              'Endereço',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Flexible(
                                              child: Text(
                                                itensPedido[index].peca?.estoque?.first.endereco.toString() ?? '-',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            TextComponent(
                                              'Valor R\$',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              controller.formatter.format(itensPedido[index].valor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            TextComponent(
                                              'Subtotal R\$',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              controller.formatter.format(
                                                (itensPedido[index].valor * itensPedido[index].quantidade),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: TitleComponent('Rastreio do pedido'),
                    ),
                    SizedBox(
                      width: context.width,
                      child: ProcessTimelinePage(evento: controller.pedidoSaida.pedidoSaidaEvento!),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Container(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.pedidoSaida.pedidoSaidaEvento!.length,
                          itemBuilder: (context, index) {
                            List<ItemPedidoSaidaModel> itensPedido = controller.pedidoSaida.itemsPedidoSaida!;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: CardWidget(
                                widget: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                TextComponent(
                                                  'ID do evento',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  controller.pedidoSaida.pedidoSaidaEvento?[index].idPedidoSaidaEvento
                                                          .toString() ??
                                                      '',
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                TextComponent(
                                                  'Status',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    controller.pedidoSaida.pedidoSaidaEvento?[index].eventoStatus?.descricao
                                                            .toString() ??
                                                        '',
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          TextComponent(
                                            'Descrição',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Flexible(
                                            child: Text(
                                              controller.pedidoSaida.pedidoSaidaEvento?[index].eventoStatus?.mensagemPadrao
                                                      .toString() ??
                                                  '',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                TextComponent(
                                                  'Data',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  controller.pedidoSaida.pedidoSaidaEvento?[index].dataEvento != null
                                                      ? DateFormat('dd/MM/yyyy')
                                                          .format(controller.pedidoSaida.pedidoSaidaEvento![index].dataEvento!)
                                                      : '',
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                TextComponent(
                                                  'Hora',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    controller.pedidoSaida.pedidoSaidaEvento?[index].dataEvento != null
                                                        ? DateFormat('HH:mm')
                                                            .format(controller.pedidoSaida.pedidoSaidaEvento![index].dataEvento!)
                                                        : '',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          TextComponent(
                                            'Funcionário',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Flexible(
                                            child: Text(
                                              controller.pedidoSaida.pedidoSaidaEvento?[index].funcionario?.clienteFunc?.cliente
                                                      ?.nome
                                                      .toString()
                                                      .capitalize ??
                                                  '',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonComponent(
                              color: primaryColor,
                              onPressed: () {
                                Get.offAllNamed('/ordens-saida');
                              },
                              text: 'Voltar'),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: ButtonComponent(
                            color: secundaryColor,
                            colorHover: secundaryColorHover,
                            icon: Icon(
                              Icons.print,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              GerarPedidoSaidaPDF(pedido: controller.pedidoSaida).imprimirPDF();
                            },
                            text: 'Imprimir',
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => !controller.carregandoSeparacao.value
                          ? controller.pedidoSaida.pedidoSaidaEvento!.isNotEmpty
                              ? controller.pedidoSaida.pedidoSaidaEvento!.last.eventoStatus!.id_evento_status ==
                                      PedidoSaidaStatusEnum.AGUARDANDO_FORNECEDOR
                                  ? controller.pedidoSaida.verificaEstoque!
                                      ? Container(
                                          margin: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: ButtonComponent(
                                            color: primaryColor,
                                            colorHover: primaryColorHover,
                                            onPressed: () async {
                                              await controller.encaminharSeparacao();
                                              Get.delete<PedidoSaidaDetalheController>();

                                              Get.delete<SeparacaoController>();
                                            },
                                            text: 'Encaminhar para separação',
                                          ),
                                        )
                                      : SizedBox.shrink()
                                  : SizedBox.shrink()
                              : SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: LoadingComponent(),
                            ),
                    ),
                  ],
                ),
              )
            : Center(
                child: LoadingComponent(),
              )),
      ),
    );
  }
}
