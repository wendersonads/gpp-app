import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/perfil_usuario/controllers/perfil_usuario_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PerfilUsuarioDetalheDesktop extends StatelessWidget {
  const PerfilUsuarioDetalheDesktop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PerfilUsuarioDetalheController>();

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
                    Obx(() => !controller.carregando.value
                        ? Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TitleComponent(controller
                                        .perfilUsuario.descricao
                                        .toString()
                                        .capitalize!)),
                              ],
                            ),
                          )
                        : Container()),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                TextComponent(
                                  'Icone',
                                  fontWeight: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                TextComponent(
                                  'Código da funcionalidade',
                                  fontWeight: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 2,
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
                    ),
                    Expanded(
                      child: Obx(
                        () => !controller.carregandoFuncionalidades.value
                            ? Container(
                                child: ListView.builder(
                                  itemCount: controller.funcionalidades.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 16),
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Container(
                                                    child: Icon(IconData(
                                                        int.parse(controller
                                                            .funcionalidades[
                                                                index]
                                                            .icone!),
                                                        fontFamily:
                                                            'MaterialIcons'))),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                TextComponent(
                                                  '${controller.funcionalidades[index].idFuncionalidade.toString()}',
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: TextComponent(
                                                controller
                                                        .funcionalidades[index]
                                                        .nome
                                                        .toString()
                                                        .capitalize ??
                                                    '',
                                              )),
                                          Obx(() => !controller.carregando.value
                                              ? Expanded(
                                                  child: Row(
                                                    children: [
                                                      ToggleSwitch(
                                                        customWidths: [
                                                          90.0,
                                                          50.0
                                                        ],
                                                        cornerRadius: 20.0,
                                                        activeBgColors: [
                                                          [primaryColor],
                                                          [Colors.redAccent]
                                                        ],
                                                        activeFgColor:
                                                            Colors.white,
                                                        inactiveBgColor:
                                                            Colors.grey,
                                                        inactiveFgColor:
                                                            Colors.white,
                                                        totalSwitches: 2,
                                                        labels: ['Sim', ''],
                                                        icons: [
                                                          null,
                                                          Icons.close
                                                        ],
                                                        initialLabelIndex: controller
                                                            .verificarFuncionalidade(
                                                                controller
                                                                    .funcionalidades[
                                                                        index]
                                                                    .idFuncionalidade),
                                                        onToggle: (value) {
                                                          if (value == 0) {
                                                            controller.vincularPerfilUsuarioFuncionalidade(
                                                                controller
                                                                    .perfilUsuario
                                                                    .idPerfilUsuario!,
                                                                controller
                                                                    .funcionalidades[
                                                                        index]
                                                                    .idFuncionalidade!);
                                                          }
                                                          if (value == 1) {
                                                            controller.removerPerfilUsuarioFuncionalidade(
                                                                controller
                                                                    .perfilUsuario
                                                                    .idPerfilUsuario!,
                                                                controller
                                                                    .funcionalidades[
                                                                        index]
                                                                    .idFuncionalidade!);
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container())
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : LoadingComponent(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonComponent(
                                onPressed: () {
                                  Get.back();
                                },
                                text: 'Voltar')
                          ]),
                    )
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
