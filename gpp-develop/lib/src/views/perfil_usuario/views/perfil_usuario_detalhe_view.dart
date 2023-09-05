import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/perfil_usuario/controllers/perfil_usuario_detalhe_controller.dart';
import 'package:gpp/src/views/perfil_usuario/views/widgets/perfil_usuario_detalhe_desktop.dart';
import 'package:gpp/src/views/perfil_usuario/views/widgets/perfil_usuario_detalhe_mobile.dart';

class PerfilUsuarioDetalheView extends StatelessWidget {
  final int id;
  const PerfilUsuarioDetalheView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PerfilUsuarioDetalheController(id));

    if (Dispositivo.mobile(context.width)) {
      return PerfilUsuarioDetalheMobile();
    } else {
      return PerfilUsuarioDetalheDesktop();
    }
  }
}
