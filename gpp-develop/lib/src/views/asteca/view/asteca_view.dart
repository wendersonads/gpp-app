import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';

import 'package:gpp/src/views/asteca/controller/asteca_controller.dart';
import 'package:gpp/src/views/asteca/view/widgets/asteca_desktop.dart';
import 'package:gpp/src/views/asteca/view/widgets/asteca_mobile.dart';

class AstecaView extends StatelessWidget {
  AstecaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.put(AstecaController());

    if (Dispositivo.mobile(context.width)) {
      return AstecaMobile();
    } else {
      return AstecaDesktop();
    }
  }
}
