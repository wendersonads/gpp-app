import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/asteca/view/widgets/asteca_detalhe_desktop.dart';
import 'package:gpp/src/views/asteca/view/widgets/asteca_detalhe_mobile.dart';

class AstecaDetalheView extends StatelessWidget {
  final int id;

  AstecaDetalheView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return AstecaDetalheMobile(id: id);
    } else {
      return AstecaDetalheDesktop(id: id);
    }
  }
}
