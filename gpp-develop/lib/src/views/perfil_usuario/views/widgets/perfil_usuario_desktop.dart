import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/perfil_usuario/controllers/perfil_usuario_controller.dart';
import 'package:gpp/src/views/perfil_usuario/controllers/perfil_usuario_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class PerfilUsuarioDesktop extends StatelessWidget {
  const PerfilUsuarioDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PerfilUsuarioController>();

    return Scaffold(
      appBar: NavbarWidget(),
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Sidebar(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Expanded(child: TitleComponent('Perfil de usuários')),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                    child: InputComponent(
                                  hintText: 'Buscar',
                                  // onChanged: (value) =>
                                  //     produtoController.pesquisar = value,
                                  // onFieldSubmitted: (value) {
                                  //   produtoController.buscarProdutos();
                                  // },
                                ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonComponent(
                              onPressed: () {
                                Get.toNamed('/perfil-usuario/registrar');
                              },
                              text: 'Adicionar')
                        ],
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => !controller.carregando.value
                            ? Container(
                                child: ListView.builder(
                                  itemCount: controller.perfisUsuarios.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      child: CardWidget(
                                        widget: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      TextComponent(
                                                        'Código do perfil de usuário',
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
                                                        '${controller.perfisUsuarios[index].idPerfilUsuario.toString()}',
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child: SelectableText(
                                                  controller
                                                          .perfisUsuarios[index]
                                                          .descricao
                                                          .toString()
                                                          .capitalize ??
                                                      '',
                                                )),
                                                Expanded(
                                                  child: ButtonAcaoWidget(
                                                    deletar: () async {
                                                      await controller
                                                          .deletarPerfilUsuario(
                                                              controller
                                                                  .perfisUsuarios[
                                                                      index]
                                                                  .idPerfilUsuario!);
                                                    },
                                                    detalhe: () {
                                                      Get.delete<
                                                          PerfilUsuarioDetalheController>();

                                                      Get.toNamed(
                                                          '/perfil-usuario/' +
                                                              controller
                                                                  .perfisUsuarios[
                                                                      index]
                                                                  .idPerfilUsuario
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
                    // Container(
                    //   margin:
                    //       const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                    //   child: GetBuilder<ProdutoController>(
                    //     builder: (_) => PaginacaoComponent(
                    //       total: produtoController.pagina.total,
                    //       atual: produtoController.pagina.atual,
                    //       primeiraPagina: () {
                    //         produtoController.pagina.primeira();
                    //         produtoController.buscarProdutos();
                    //       },
                    //       anteriorPagina: () {
                    //         produtoController.pagina.anterior();
                    //         produtoController.buscarProdutos();
                    //       },
                    //       proximaPagina: () {
                    //         produtoController.pagina.proxima();
                    //         produtoController.buscarProdutos();
                    //       },
                    //       ultimaPagina: () {
                    //         produtoController.pagina.ultima();
                    //         produtoController.buscarProdutos();
                    //       },
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
