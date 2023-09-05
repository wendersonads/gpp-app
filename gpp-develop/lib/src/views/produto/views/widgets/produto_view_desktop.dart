import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';

import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/produto/controllers/produto_controller.dart';
import 'package:gpp/src/views/produto/controllers/produto_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';

import 'package:gpp/src/views/widgets/situacao_widget.dart';

import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class ProdutoViewDesktop extends StatelessWidget {
  const ProdutoViewDesktop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProdutoController>();

    return Scaffold(
      appBar: NavbarWidget(),
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Sidebar(),
            Expanded(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(child: TitleComponent('Produtos')),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                  child: InputComponent(
                                hintText: 'Buscar',
                                onFieldSubmitted: (value) {
                                  controller.pesquisar = value;
                                  controller.buscarProdutos();
                                },
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => !controller.carregando.value
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: ListView.builder(
                                itemCount: controller.produtos.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: CardWidget(
                                      widget: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    TextComponent(
                                                      'ID Produto',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: TextComponent(
                                                'Descrição',
                                                fontWeight: FontWeight.bold,
                                              )),
                                              Expanded(
                                                  child: TextComponent(
                                                'Fornecedor',
                                                fontWeight: FontWeight.bold,
                                              )),
                                              Expanded(
                                                  child: TextComponent(
                                                'Situação',
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    SelectableText(
                                                      '${controller.produtos[index].idProduto.toString()}',
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: SelectableText(
                                                controller.produtos[index]
                                                        .resumida
                                                        .toString()
                                                        .capitalize ??
                                                    '',
                                              )),
                                              Expanded(
                                                  child: SelectableText(
                                                controller
                                                        .produtos[index]
                                                        .fornecedores!
                                                        .first
                                                        .cliente!
                                                        .nome
                                                        .toString()
                                                        .capitalize ??
                                                    '',
                                              )),
                                              Expanded(
                                                  child: Row(
                                                children: [
                                                  SituacaoWidget(
                                                      situacao: controller
                                                          .produtos[index]
                                                          .situacao!),
                                                ],
                                              )),
                                              Expanded(
                                                child: ButtonAcaoWidget(
                                                  detalhe: () {
                                                    Get.delete<
                                                        ProdutoDetalheController>();
                                                    // Get.keys[1]!.currentState!
                                                    //     .pushNamed(
                                                    //         '/produtos/${produtoController.produtos[index].idProduto}');
                                                    Get.toNamed('/produtos/' +
                                                        controller
                                                            .produtos[index]
                                                            .idProduto
                                                            .toString());
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
                              ),
                            )
                          : LoadingComponent(),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                    child: GetBuilder<ProdutoController>(
                      builder: (_) => PaginacaoComponent(
                        total: controller.pagina.getTotal(),
                        atual: controller.pagina.getAtual(),
                        primeiraPagina: () {
                          controller.pagina.primeira();
                          controller.buscarProdutos();
                        },
                        anteriorPagina: () {
                          controller.pagina.anterior();
                          controller.buscarProdutos();
                        },
                        proximaPagina: () {
                          controller.pagina.proxima();
                          controller.buscarProdutos();
                        },
                        ultimaPagina: () {
                          controller.pagina.ultima();
                          controller.buscarProdutos();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
