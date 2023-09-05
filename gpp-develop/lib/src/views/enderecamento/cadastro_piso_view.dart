import 'package:flutter/material.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/enderecamento/widgets/cadastro_piso_view_desktop.dart';
import 'package:gpp/src/views/enderecamento/widgets/cadastro_piso_view_mobile.dart';
import 'package:get/get.dart';

class CadastroPisoView extends StatelessWidget {
  const CadastroPisoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return CadastroPisoViewMobile();
    } else {
      return CadastroPisoViewDesktop();
    }
  }
}
