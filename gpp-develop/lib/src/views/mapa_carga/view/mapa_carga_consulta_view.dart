// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/mapa_carga/controller/mapa_carga_consulta_controller.dart';
import 'package:gpp/src/views/mapa_carga/widgets/mapa_carga_consulta_view_desktop.dart';
import 'package:gpp/src/views/mapa_carga/widgets/mapa_carga_consulta_view_mobile.dart';

class MapaCargaConsultaView extends StatelessWidget {
  MapaCargaConsultaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapaCargaConsultaController());
    if (Dispositivo.mobile(context.width)) {
      return MapaCargaConsultaViewMobile();
    } else {
      return MapaCargaConsultaViewDesktop();
    }
  }
}
