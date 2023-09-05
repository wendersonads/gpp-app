import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/main.dart';
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

class SeparacaoDesktop extends StatelessWidget {
  const SeparacaoDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SeparacaoController());

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: NavbarWidget(),
        drawer: Sidebar(),
        body: Row(
          children: [
            context.width > 576 ? Sidebar() : Container(),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    width: context.width,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
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
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              Container(
                                width: context.width < 576 ? context.width : 320,
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
                                width: context.width < 576 ? context.width : 120,
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
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  Container(
                                    width: context.width < 576 ? context.width : 320,
                                    child: InputComponent(
                                      inputFormatter: [controller.maskFormatter.dataFormatter()],
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
                                        controller.dataInicio = DateFormat("dd/MM/yyyy").parse(value);
                                      },
                                      hintText: 'DD/MM/AAAA',
                                    ),
                                  ),
                                  Container(
                                    width: context.width < 576 ? context.width : 320,
                                    child: InputComponent(
                                      inputFormatter: [controller.maskFormatter.dataFormatter()],
                                      label: '',
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
                                        controller.dataFim = DateFormat("dd/MM/yyyy").parse(value);
                                      },
                                      hintText: 'DD/MM/AAAA',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
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
                                      width: 8,
                                    ),
                                    ButtonComponent(
                                        onPressed: () async {
                                          if (controller.formKey.currentState!.validate()) {
                                            controller.formKey.currentState!.save();
                                            await controller.buscarPedidosSaidaSeparacao();
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
                                return context.width > 576
                                    ? Container(
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                        child: CardWidget(
                                          color: controller.pedidosSaida[index].pedidoSaidaEvento?.length != 0
                                              ? HexColor(controller
                                                      .pedidosSaida[index].pedidoSaidaEvento?.last.eventoStatus?.statusCor ??
                                                  '#040491')
                                              : primaryColor,
                                          widget: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(children: [
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
                                                          'Nome',
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: TextComponent(
                                                          'Data de abertura',
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: TextComponent(
                                                          'CPF/CNPJ',
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                    // Expanded(
                                                    //     flex: 2,
                                                    //     child: TextComponent(
                                                    //       'Situação',
                                                    //       fontWeight: FontWeight.bold,
                                                    //     )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: TextComponent(
                                                          'Valor total',
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                    Expanded(
                                                        flex: 3,
                                                        child: TextComponent(
                                                          'Status',
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                    Expanded(
                                                      flex: 2,
                                                      child: TextComponent(
                                                        'Ações',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Divider(),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          SelectableText(
                                                            controller.pedidosSaida[index].idPedidoSaida.toString(),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: SelectableText(
                                                          controller.pedidosSaida[index].cliente?.nome.toString().capitalize ??
                                                              ''),
                                                    ),
                                                    Expanded(
                                                        flex: 2,
                                                        child: SelectableText(
                                                          DateFormat('dd/MM/yyyy')
                                                              .format(controller.pedidosSaida[index].dataEmissao!),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: SelectableText(
                                                          controller.maskFormatter
                                                              .cpfCnpjFormatter(
                                                                  value: controller.pedidosSaida[index].cpfCnpj.toString())!
                                                              .getMaskedText(),
                                                        )),
                                                    // Expanded(
                                                    //     flex: 2,
                                                    //     child: TextComponent(controller.pedidosSaida[index].situacao.toString())),
                                                    Expanded(
                                                        flex: 2,
                                                        child: SelectableText(
                                                            controller.formatter.format(controller.pedidosSaida[index].valorTotal)
                                                            // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                                            )),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Row(
                                                        children: [
                                                          EventoStatusWidget(
                                                            color: controller.pedidosSaida[index].pedidoSaidaEvento?.length != 0
                                                                ? HexColor(controller.pedidosSaida[index].pedidoSaidaEvento?.last
                                                                        .eventoStatus?.statusCor ??
                                                                    '#040491')
                                                                : null,
                                                            texto: controller.pedidosSaida[index].pedidoSaidaEvento?.length != 0
                                                                ? controller.pedidosSaida[index].pedidoSaidaEvento?.last
                                                                        .eventoStatus?.descricao ??
                                                                    ''
                                                                : 'Aguardando status',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: ButtonAcaoWidget(
                                                        detalhe: () {
                                                          Get.toNamed(
                                                              '/separacao/${controller.pedidosSaida[index].idPedidoSaida}');

                                                          Get.delete<SeparacaoDetalheController>();
                                                        },
                                                      ),
                                                      // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                                    )
                                                  ],
                                                )
                                              ])),
                                        ))
                                    : Container(
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                        width: context.width,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.2),
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 2), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: context.width,
                                              child: Wrap(
                                                alignment: WrapAlignment.spaceBetween,
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                  EventoStatusWidget(
                                                    color: controller.pedidosSaida[index].pedidoSaidaEvento?.length != 0
                                                        ? HexColor(controller.pedidosSaida[index].pedidoSaidaEvento?.last
                                                                .eventoStatus?.statusCor ??
                                                            '#040491')
                                                        : null,
                                                    texto: controller.pedidosSaida[index].pedidoSaidaEvento?.length != 0
                                                        ? controller.pedidosSaida[index].pedidoSaidaEvento?.last.eventoStatus
                                                                ?.descricao ??
                                                            ''
                                                        : 'Aguardando status',
                                                  ),
                                                  Container(
                                                    height: 70,
                                                    width: 70,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(50),
                                                      child: Image.network(
                                                          'https://as1.ftcdn.net/v2/jpg/01/71/25/36/1000_F_171253635_8svqUJc0BnLUtrUOP5yOMEwFwA8SZayX.jpg'),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Divider(),
                                            Wrap(
                                              spacing: 10,
                                              direction: Axis.vertical,
                                              children: [
                                                SelectableText(
                                                  'ID: ${controller.pedidosSaida[index].idPedidoSaida.toString()}',
                                                  style: textStyleTexto,
                                                ),
                                                SelectableText(
                                                  'Nome: ${controller.pedidosSaida[index].cliente?.nome.toString().capitalize ?? ''}',
                                                  style: textStyleTexto,
                                                ),
                                                SelectableText(
                                                  "Data de abertura: ${DateFormat('dd/MM/yyyy').format(controller.pedidosSaida[index].dataEmissao!)}",
                                                  style: textStyleTexto,
                                                ),
                                                SelectableText(
                                                  'CPF/CNPJ: ${controller.maskFormatter.cpfCnpjFormatter(value: controller.pedidosSaida[index].cpfCnpj.toString())!.getMaskedText()}',
                                                  style: textStyleTexto,
                                                ),
                                                SelectableText(
                                                  'Valor total: ${controller.formatter.format(controller.pedidosSaida[index].valorTotal)}',
                                                  style: textStyleTexto,
                                                ),
                                                Container(
                                                  width: context.width,
                                                  padding: EdgeInsets.symmetric(vertical: 16),
                                                  child: Wrap(
                                                    children: [
                                                      Container(
                                                        width: context.width / 3,
                                                        child: ButtonComponent(
                                                            onPressed: () {
                                                              Get.toNamed(
                                                                  '/separacao/${controller.pedidosSaida[index].idPedidoSaida}');

                                                              Get.delete<SeparacaoDetalheController>();
                                                            },
                                                            text: 'Visualizar'),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                              },
                            ),
                          )
                        : LoadingComponent()),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
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
            )),
          ],
        ));
  }
}
