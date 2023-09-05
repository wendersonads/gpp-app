import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/entrada/controller/entrada_manual_controller.dart';
import 'package:gpp/src/views/entrada/controller/entrada_pedido_controller.dart';
import 'package:gpp/src/views/entrada/widgets/menu_entrada_view_desktop.dart';
import 'package:gpp/src/views/entrada/widgets/menu_entrada_view_mobile.dart';

class MenuEntradaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(EntradaPedidoController());
    Get.put(EntradaManualController());

    if (Dispositivo.mobile(context.width)) {
      return MenuEntradaViewMobile();
    } else {
      return MenuEntradaViewDesktop();
    }
  }
}
