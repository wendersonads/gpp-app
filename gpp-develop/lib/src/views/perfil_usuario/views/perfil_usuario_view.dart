// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/perfil_usuario/controllers/perfil_usuario_controller.dart';
import 'package:gpp/src/views/perfil_usuario/views/widgets/perfi_usuario_mobile.dart';
import 'package:gpp/src/views/perfil_usuario/views/widgets/perfil_usuario_desktop.dart';

class PerfilUsuarioView extends StatelessWidget {
  const PerfilUsuarioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PerfilUsuarioController());

    if (Dispositivo.mobile(context.width)) {
      return PerfilUsuarioMobile();
    } else {
      return PerfilUsuarioDesktop();
    }
  }
}
