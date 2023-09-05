import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/usuarios/controllers/usuario_controller.dart';
import 'package:gpp/src/views/usuarios/views/widgets/usuarios_desktop.dart';
import 'package:gpp/src/views/usuarios/views/widgets/usuarios_mobile.dart';

class UsuariosView extends StatelessWidget {
  const UsuariosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UsuarioController2());

    if (Dispositivo.mobile(context.width)) {
      return UsuariosMobile();
    } else {
      return UsuariosDesktop();
    }
  }
}
