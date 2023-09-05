import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/fornecedor/controllers/fornecedor_controller.dart';
import 'package:gpp/src/views/fornecedor/controllers/fornecedor_detalhe_controller.dart';
import 'package:gpp/src/views/separacao/controllers/separacao_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class FornecedorDesktop extends StatelessWidget {
  const FornecedorDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FornecedorController>();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: NavbarWidget(),
        body: Row(
          children: [
            Sidebar(),
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 32),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: TextComponent(
                              'Fornecedores',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: InputComponent(
                              hintText: 'Buscar',
                              onChanged: (value) {
                                controller.pesquisar = value;
                              },
                              onFieldSubmitted: (value) async {
                                controller.pesquisar = value;
                                await controller.buscarFornecedores();
                              }),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ButtonComponent(
                            onPressed: () async {
                              await controller.buscarFornecedores();
                            },
                            text: 'Buscar')
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() => !controller.carregando.value
                        ? Container(
                            child: ListView.builder(
                              itemCount: controller.fornecedores.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: CardWidget(
                                      widget: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      TextComponent(
                                                        'ID Fornecedor',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child: TextComponent(
                                                  'Nome',
                                                  fontWeight: FontWeight.bold,
                                                )),
                                                Expanded(
                                                    child: TextComponent(
                                                  'CPF/CNPJ',
                                                  fontWeight: FontWeight.bold,
                                                )),
                                                Expanded(
                                                    child: TextComponent(
                                                  'Ações',
                                                  fontWeight: FontWeight.bold,
                                                )),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      SelectableText(
                                                        controller
                                                            .fornecedores[index]
                                                            .idFornecedor
                                                            .toString(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SelectableText(
                                                      controller
                                                              .fornecedores[
                                                                  index]
                                                              .cliente
                                                              ?.nome
                                                              .toString()
                                                              .capitalize ??
                                                          ''),
                                                ),
                                                Expanded(
                                                    child: SelectableText(
                                                  controller.maskFormatter
                                                          .cpfCnpjFormatter(
                                                              value: controller
                                                                      .fornecedores[
                                                                          index]
                                                                      .cliente
                                                                      ?.cpfCnpj
                                                                      .toString() ??
                                                                  '')
                                                          ?.getMaskedText() ??
                                                      '',
                                                )),
                                                Expanded(child:
                                                        ButtonAcaoWidget(
                                                            detalhe: () {
                                                  Get.delete<
                                                      FornecedorDetalheController>();
                                                  Get.toNamed(
                                                      '/fornecedores/${controller.fornecedores[index].idFornecedor}');

                                                  Get.delete<
                                                      SeparacaoDetalheController>();
                                                })
                                                    // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                                    )
                                              ],
                                            )
                                          ])),
                                    ));
                              },
                            ),
                          )
                        : LoadingComponent()),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                    child: GetBuilder<FornecedorController>(
                      builder: (_) => PaginacaoComponent(
                        total: controller.pagina.getTotal(),
                        atual: controller.pagina.getAtual(),
                        primeiraPagina: () {
                          controller.pagina.primeira();
                          controller.buscarFornecedores();
                        },
                        anteriorPagina: () {
                          controller.pagina.anterior();
                          controller.buscarFornecedores();
                        },
                        proximaPagina: () {
                          controller.pagina.proxima();
                          controller.buscarFornecedores();
                        },
                        ultimaPagina: () {
                          controller.pagina.ultima();
                          controller.buscarFornecedores();
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
