import 'package:flutter/material.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/TextComponentMenu.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/entrada/controller/entrada_manual_controller.dart';
import 'package:gpp/src/views/entrada/controller/entrada_pedido_controller.dart';
import 'package:gpp/src/views/entrada/entrada_historico_view.dart';
import 'package:gpp/src/views/entrada/entrada_manual_view.dart';
import 'package:gpp/src/views/entrada/entrada_pedido_view.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MenuEntradaViewDesktop extends StatefulWidget {
  @override
  _MenuEntradaViewDesktopState createState() => _MenuEntradaViewDesktopState();
}

class _MenuEntradaViewDesktopState extends State<MenuEntradaViewDesktop> {
  final controller = Get.find<EntradaPedidoController>();
  final controllerManul = Get.find<EntradaManualController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: NavbarWidget(),
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: const TitleComponent(
                        'Entrada',
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                _entradaMenu(),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                _entradaNavigator(),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                controller.selected == 1
                    ? Obx(
                        () => !controller.carregandoEntrada.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5)),
                                  Container(
                                    child: ButtonComponent(
                                      onPressed: () async {
                                        bool valida =
                                            await controller.lancarEntrada();
                                        if (valida) {
                                          Get.delete<EntradaManualController>();
                                          Get.delete<EntradaPedidoController>();
                                          Get.offAndToNamed('/estoque-entrada');
                                        }
                                      },
                                      text: 'Lançar Entrada',
                                      color: primaryColor,
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(right: 20)),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const LoadingComponent(),
                                  const Padding(
                                      padding: EdgeInsets.only(right: 20)),
                                ],
                              ),
                      )
                    : SizedBox.shrink(),
                controller.selected == 2
                    ? Obx(
                        () => !controllerManul.carregandoEntrada.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5)),
                                  Container(
                                    child: ButtonComponent(
                                      onPressed: () async {
                                        controllerManul
                                            .notaFiscalForm.currentState!
                                            .save();
                                        bool valida = await controllerManul
                                            .lancarEntrada();
                                        if (valida) {
                                          Get.delete<EntradaManualController>();
                                          Get.delete<EntradaPedidoController>();
                                          Get.offAndToNamed('/estoque-entrada');
                                        }
                                      },
                                      text: 'Lançar Entrada Manual',
                                      color: primaryColor,
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(right: 20)),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const LoadingComponent(),
                                  const Padding(
                                      padding: EdgeInsets.only(right: 20)),
                                ],
                              ),
                      )
                    : const SizedBox.shrink(),
                Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
              ],
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
                setState(() {
                  controller.selected = 1;
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: controller.selected == 1
                          ? secundaryColor
                          : Colors.grey.shade200,
                      width: controller.selected == 1 ? 4 : 1,
                    ),
                  ),
                ),
                child: TextComponentMenu(
                  "Por pedido",
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  controller.selected = 2;
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: controller.selected == 2
                          ? secundaryColor
                          : Colors.grey.shade200,
                      width: controller.selected == 2 ? 4 : 1,
                    ),
                  ),
                ),
                child: TextComponentMenu(
                  "Manual",
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  controller.selected = 3;
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: controller.selected == 3
                          ? secundaryColor
                          : Colors.grey.shade200,
                      width: controller.selected == 3 ? 4 : 1,
                    ),
                  ),
                ),
                child: TextComponentMenu(
                  "Histórico",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _entradaNavigator() {
    switch (controller.selected) {
      case 1:
        return EntradaPedidoView();
      case 2:
        return EntradaManualView();
      case 3:
        return EntradaHistoricoView();
    }
  }
}
