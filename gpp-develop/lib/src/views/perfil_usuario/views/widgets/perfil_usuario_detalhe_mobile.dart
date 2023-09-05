import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/perfil_usuario/controllers/perfil_usuario_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PerfilUsuarioDetalheMobile extends StatelessWidget {
  const PerfilUsuarioDetalheMobile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PerfilUsuarioDetalheController>();

    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() => !controller.carregando.value
                ? Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.perfilUsuario.descricao
                                .toString()
                                .capitalize!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()),
            Expanded(
              child: Obx(
                () => !controller.carregandoFuncionalidades.value
                    ? Container(
                        child: ListView.builder(
                          itemCount: controller.funcionalidades.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: Icon(
                                  IconData(
                                    int.parse(controller
                                        .funcionalidades[index].icone!),
                                    fontFamily: 'MaterialIcons',
                                  ),
                                  color: Colors.black,
                                ),
                                title: Text(controller
                                        .funcionalidades[index].nome
                                        .toString()
                                        .capitalize ??
                                    ''),
                                subtitle: Text(
                                    'Código: ${controller.funcionalidades[index].idFuncionalidade.toString()}'),
                                trailing: Obx(() => !controller.carregando.value
                                    ? ToggleSwitch(
                                        customWidths: [60.0, 40.0],
                                        cornerRadius: 20.0,
                                        activeBgColors: [
                                          [primaryColor],
                                          [Colors.redAccent]
                                        ],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey,
                                        inactiveFgColor: Colors.white,
                                        totalSwitches: 2,
                                        labels: ['Sim', ''],
                                        icons: [null, Icons.close],
                                        initialLabelIndex: controller
                                            .verificarFuncionalidade(controller
                                                .funcionalidades[index]
                                                .idFuncionalidade),
                                        onToggle: (value) {
                                          if (value == 0) {
                                            controller
                                                .vincularPerfilUsuarioFuncionalidade(
                                                    controller.perfilUsuario
                                                        .idPerfilUsuario!,
                                                    controller
                                                        .funcionalidades[index]
                                                        .idFuncionalidade!);
                                          }
                                          if (value == 1) {
                                            controller
                                                .removerPerfilUsuarioFuncionalidade(
                                                    controller.perfilUsuario
                                                        .idPerfilUsuario!,
                                                    controller
                                                        .funcionalidades[index]
                                                        .idFuncionalidade!);
                                          }
                                        },
                                      )
                                    : Container()),
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
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ButtonComponent(
                    color: primaryColor,
                    onPressed: () {
                      Get.offAllNamed('/perfil-usuario');
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
    );
  }
}
