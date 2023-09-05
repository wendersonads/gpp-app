// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/mapa_carga/controller/mapa_carga_detalhe_controller.dart';
import 'package:gpp/src/views/mapa_carga/widgets/mapa_carga_detalhe_view_desktop.dart';
import 'package:gpp/src/views/mapa_carga/widgets/mapa_carga_detalhe_view_mobile.dart';

class MapaCargaDetalheView extends StatelessWidget {
  final int id;
  const MapaCargaDetalheView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapaCargaDetalheController(id));
    if (Dispositivo.mobile(context.width)) {
      return MapaCargaDetalheViewMobile(id: id);
    } else {
      return MapaCargaDetalheViewDesktop(id: id);
    }
  }
}
