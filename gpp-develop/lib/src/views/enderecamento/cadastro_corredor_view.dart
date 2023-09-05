import 'package:flutter/material.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/enderecamento/widgets/cadastro_corredor_view_desktop.dart';
import 'package:gpp/src/views/enderecamento/widgets/cadastro_corredor_view_mobile.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CadastroCorredorView extends StatelessWidget {
  String? idPiso;
  CadastroCorredorView({this.idPiso});

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return CadastroCorredorViewMobile(idPiso: this.idPiso);
    } else {
      return CadastroCorredorViewDesktop(idPiso: this.idPiso);
    }
  }
}
