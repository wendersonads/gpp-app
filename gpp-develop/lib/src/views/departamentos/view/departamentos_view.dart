import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/departamentos/view/widgets/departamentos_desktop.dart';
import 'package:gpp/src/views/departamentos/view/widgets/departamentos_mobile.dart';

class DepartamentosView extends StatelessWidget {
  DepartamentosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return DepartamentosMobile();
    } else {
      return DepartamentosDesktop();
    }
  }
}
