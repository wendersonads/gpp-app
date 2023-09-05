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

class MenuMapaCargaMobile extends StatelessWidget {
  final int? idMapa;
  MenuMapaCargaMobile({Key? key, this.idMapa}) : super(key: key);
  final controller = Get.put(MenuMapaCargaController());
  final controllerMapaCarga = Get.put(MapaCargaController());

  @override
  Widget build(BuildContext context) {
    /* if (Get.currentRoute == '/mapa-carga-consultar') {
      controller.selected.value = 2;
    } else {
      controller.selected.value = 1;
    } */
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Get.width / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping),
                  SizedBox(
                    width: 8,
                  ),
                  const TitleComponent(
                    'Mapa de Carga',
                  ),
                ],
              ),
            ),
            Obx(() => _entradaMenu()),
            Expanded(child: Obx(() => _entradaNavigator(idMapa: this.idMapa))),
            Obx(
              () => controller.selected.value == 1
                  ? Container(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
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
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: LoadingComponent()))
                              : Container(),
                          Expanded(child: SizedBox()),
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
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: LoadingComponent())),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }

  _entradaMenu() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
        //CRIAR
        return MapaCargaView(idMapa: idMapa ?? null);
      case 2:
        //CONSULTAR
        return MapaCargaConsultaView();
    }
  }
}
