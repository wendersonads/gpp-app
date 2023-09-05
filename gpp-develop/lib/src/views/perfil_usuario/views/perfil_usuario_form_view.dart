// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/perfil_usuario/controllers/perfil_usuario_controller.dart';
import 'package:gpp/src/views/perfil_usuario/views/widgets/perfil_usuario_form_mobile.dart';
import 'package:gpp/src/views/perfil_usuario/views/widgets/perfil_usuario_form_desktop.dart';

class PerfilUsuarioFormView extends StatelessWidget {
  const PerfilUsuarioFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PerfilUsuarioController());

    if (Dispositivo.mobile(context.width)) {
      return PerfilUsuarioFormMobile();
    } else {
      return PerfilUsuarioFormDesktop();
    }
  }
}
