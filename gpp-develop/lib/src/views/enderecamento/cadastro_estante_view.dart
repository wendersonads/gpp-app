import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/enderecamento/widgets/cadastro_estante_view_desktop.dart';
import 'package:gpp/src/views/enderecamento/widgets/cadastro_estante_view_mobile.dart';

// ignore: must_be_immutable
class CadastroEstanteView extends StatelessWidget {
  String? idCorredor;
  CadastroEstanteView({this.idCorredor});

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return CadastroEstanteViewMobile(idCorredor: this.idCorredor);
    } else {
      return CadastroEstanteViewDesktop(idCorredor: this.idCorredor);
    }
  }
}
