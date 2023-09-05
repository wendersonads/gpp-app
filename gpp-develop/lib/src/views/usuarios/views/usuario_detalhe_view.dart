import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';

import 'package:gpp/src/views/usuarios/controllers/usuario_detalhe_controller.dart';
import 'package:gpp/src/views/usuarios/views/widgets/usuario_detalhe_desktop.dart';
import 'package:gpp/src/views/usuarios/views/widgets/usuario_detalhe_mobile.dart';

class UsuarioDetalheView extends StatelessWidget {
  final int id;
  const UsuarioDetalheView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UsuarioDetalheController(id));

    if (Dispositivo.mobile(context.width)) {
      return UsuarioDetalheMobile();
    } else {
      return UsuarioDetalheDesktop();
    }
  }
}
