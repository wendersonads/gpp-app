import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/mapa_carga/controller/mapa_carga_controller.dart';
import 'package:gpp/src/views/mapa_carga/widgets/mapa_carga_view_desktop.dart';
import 'package:gpp/src/views/mapa_carga/widgets/mapa_carga_view_mobile.dart';

class MapaCargaView extends StatelessWidget {
  final int? idMapa;
  MapaCargaView({Key? key, this.idMapa}) : super(key: key);

  final controller = Get.put(MapaCargaController());

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return MapaCargaViewMobile(
        idMapa: this.idMapa,
      );
    } else {
      return MapaCargaViewDesktop(
        idMapa: this.idMapa,
      );
    }
  }
}
