import 'package:flutter/material.dart';

import 'package:gpp/src/utils/dispositivo.dart';

import 'package:gpp/src/views/mapa_carga/widgets/menu_mapa_carga_view_desktop.dart';
import 'package:gpp/src/views/mapa_carga/widgets/menu_mapa_carga_view_mobile.dart';
import 'package:get/get.dart';

class MenuMapaCarga extends StatelessWidget {
  final int? idMapa;

  MenuMapaCarga({Key? key, this.idMapa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return MenuMapaCargaMobile(
        idMapa: idMapa,
      );
    } else {
      return MenuMapaCargaDesktop(
        idMapa: idMapa,
      );
    }
  }
}
