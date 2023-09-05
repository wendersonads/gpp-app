// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/enderecamento/widgets/cadastro_box_view_desktop.dart';
import 'package:gpp/src/views/enderecamento/widgets/cadastro_box_view_mobile.dart';

class CadastroBoxView extends StatelessWidget {
  String? idPrateleira;
  CadastroBoxView({this.idPrateleira});

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return CadastroBoxViewMobile(
        idPrateleira: this.idPrateleira,
      );
    } else {
      return CadastroBoxViewDesktop(
        idPrateleira: this.idPrateleira,
      );
    }
  }
}
