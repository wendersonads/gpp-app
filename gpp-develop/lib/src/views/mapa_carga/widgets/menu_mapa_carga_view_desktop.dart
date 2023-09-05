import 'package:flutter/material.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/TextComponentMenu.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';

import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/mapa_carga/controller/mapa_carga_controller.dart';

import 'package:gpp/src/views/mapa_carga/controller/menu_mapa_carga_controller.dart';
import 'package:gpp/src/views/mapa_carga/view/mapa_carga_consulta_view.dart';
import 'package:gpp/src/views/mapa_carga/view/mapa_carga_view.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:get/get.dart';

class MenuMapaCargaDesktop extends StatelessWidget {
  final int? idMapa;
  MenuMapaCargaDesktop({Key? key, this.idMapa}) : super(key: key);

  final controller = Get.put(MenuMapaCargaController());

  final controllerMapaCarga = Get.put(MapaCargaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.local_shipping),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Expanded(
                        child: const TitleComponent(
                          'Mapa de Carga',
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                  Obx(() => _entradaMenu()),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                  Obx(() => _entradaNavigator(idMapa: this.idMapa)),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                  Obx(
                    () => controller.selected.value == 1
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              controllerMapaCarga.isEdicao.value
                                  ? Obx(() => !controllerMapaCarga.carregandoFinalizacao.value
                                      ? Container(
                                          child: ButtonComponent(
                                            colorHover: vermelhoColor,
                                            onPressed: () async {
                                              Get.delete<MapaCargaController>();
                                              Get.delete<MenuMapaCargaController>();
                                              Get.toNamed('/mapa-carga');
                                            },
                                            text: 'Cancelar Edição',
                                            color: vermelhoColorHover,
                                          ),
                                          padding: EdgeInsets.only(bottom: 20, right: 30),
                                        )
                                      : Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: LoadingComponent()))
                                  : Container(),
                              Obx(() => !controllerMapaCarga.carregandoFinalizacao.value
                                  ? Container(
                                      child: ButtonComponent(
                                        onPressed: () async {
                                          if (controllerMapaCarga.isEdicao.value) {
                                            await controllerMapaCarga.finalizarMapaCargaEdicao();
                                            Get.delete<MapaCargaController>();
                                            Get.delete<MenuMapaCargaController>();
                                            Get.offAllNamed('/mapa-carga/${controllerMapaCarga.mapaCargaEdicao!.idMapaCarga!}');
                                          } else {
                                            if (controllerMapaCarga.FormKeyMapaCarga.currentState!.validate()) {
                                              await controllerMapaCarga.finalizarMapaCarga();
                                            }
                                          }
                                        },
                                        text: controllerMapaCarga.isEdicao.value ? 'Salvar Mapa Carga' : 'Criar Mapa Carga',
                                        color: primaryColor,
                                      ),
                                      padding: EdgeInsets.only(bottom: 20),
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: LoadingComponent())),
                              const Padding(
                                  padding: EdgeInsets.only(
                                right: 20,
                              )),
                            ],
                          )
                        : SizedBox.shrink(),
                  ),
                  // controller.selected == 2
                  //     ? Row(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         children: [
                  //           const Padding(padding: EdgeInsets.only(left: 5)),
                  //           Container(
                  //             child: ButtonComponent(
                  //               onPressed: () {},
                  //               text: 'Lançar Entrada Manual',
                  //               color: primaryColor,
                  //             ),
                  //           ),
                  //           const Padding(padding: EdgeInsets.only(right: 20)),
                  //         ],
                  //       )
                  //     : const SizedBox.shrink(),
                  // Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _entradaMenu() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                controller.selected(1);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: controller.selected.value == 1 ? secundaryColor : Colors.grey.shade200,
                      width: controller.selected.value == 1 ? 4 : 1,
                    ),
                  ),
                ),
                child: TextComponentMenu(
                  "Criar",
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                controller.selected(2);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: controller.selected.value == 2 ? secundaryColor : Colors.grey.shade200,
                      width: controller.selected.value == 2 ? 4 : 1,
                    ),
                  ),
                ),
                child: TextComponentMenu(
                  "Consultar",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _entradaNavigator({int? idMapa}) {
    switch (controller.selected.value) {
      case 1:
        return MapaCargaView(idMapa: idMapa ?? null);
      case 2:
        return MapaCargaConsultaView();
    }
  }
}
