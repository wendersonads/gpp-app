import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/enderecamento/widgets/cadastro_prateleira_view_desktop.dart';
import 'package:gpp/src/views/enderecamento/widgets/cadastro_prateleira_view_mobile.dart';

// ignore: must_be_immutable
class CadastroPrateleiraView extends StatelessWidget {
  String? idEstante;
  CadastroPrateleiraView({this.idEstante});

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return CadastroPrateleiraViewMobile(idEstante: this.idEstante);
    } else {
      return CadastroPrateleiraViewDesktop(idEstante: this.idEstante);
    }
  }
}
