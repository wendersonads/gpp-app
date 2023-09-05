import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';

import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/produto/controllers/produto_controller.dart';
import 'package:gpp/src/views/produto/controllers/produto_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';

import 'package:gpp/src/views/widgets/situacao_widget.dart';

import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class ProdutoViewMobile extends StatelessWidget {
  const ProdutoViewMobile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProdutoController>();

    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Produtos',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: Obx(
                      () => !controller.carregando.value
                          ? Container(
                              child: ListView.separated(
                                  itemCount: controller.produtos.length,
                                  separatorBuilder: ((context, index) {
                                    return SizedBox(
                                      height: 8,
                                    );
                                  }),
                                  itemBuilder: (context, index) {
                                    return CardWidget(
                                      widget: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const TextComponent(
                                                  'ID Produto:',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                TextComponent(
                                                  controller.produtos.last
                                                          .idProduto
                                                          ?.toString() ??
                                                      '',
                                                  textAlign: TextAlign.end,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                const TextComponent(
                                                  'Descrição:',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                TextComponent(
                                                  controller.produtos[index]
                                                          .resumida
                                                          .toString()
                                                          .capitalize ??
                                                      '',
                                                  textAlign: TextAlign.end,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                const TextComponent(
                                                  'Fornecedor',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                TextComponent(
                                                  controller
                                                          .produtos[index]
                                                          .fornecedores!
                                                          .first
                                                          .cliente!
                                                          .nome
                                                          .toString()
                                                          .capitalize ??
                                                      '',
                                                  textAlign: TextAlign.end,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: SituacaoWidget(
                                                      situacao: controller
                                                          .produtos[index]
                                                          .situacao!),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
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
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6),
                                                        child: Icon(
                                                          Icons
                                                              .visibility_rounded,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }))
                          : LoadingComponent(),
                    ),
                  ),
                  GetBuilder<ProdutoController>(
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
