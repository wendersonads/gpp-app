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

class FornecedorMobile extends StatelessWidget {
  const FornecedorMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FornecedorController>();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: NavbarWidget(),
        drawer: Sidebar(),
        body: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextComponent('Fornecedores',
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.width / 2,
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
                    Expanded(
                      flex: 2,
                      child: ButtonComponent(
                          onPressed: () async {
                            await controller.buscarFornecedores();
                          },
                          text: 'Buscar'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
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
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: TextComponent(
                                                'ID Fornecedor',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SelectableText(
                                              controller.fornecedores[index]
                                                  .idFornecedor
                                                  .toString(),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: TextComponent(
                                                'Nome',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SelectableText(controller
                                                    .fornecedores[index]
                                                    .cliente
                                                    ?.nome
                                                    .toString()
                                                    .capitalize ??
                                                ''),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: TextComponent(
                                                'CPF/CNPJ',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SelectableText(
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
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: TextComponent(
                                                'Ações',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            ButtonAcaoWidget(detalhe: () {
                                              Get.delete<
                                                  FornecedorDetalheController>();
                                              Get.toNamed(
                                                  '/fornecedores/${controller.fornecedores[index].idFornecedor}');

                                              Get.delete<
                                                  SeparacaoDetalheController>();
                                            })
                                            // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                          ],
                                        ),
                                      ])),
                                ));
                          },
                        ),
                      )
                    : LoadingComponent()),
              ),
              Container(
                // margin:
                //     const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
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
        ));
  }
}
