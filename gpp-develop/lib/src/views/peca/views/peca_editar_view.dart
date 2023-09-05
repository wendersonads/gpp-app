import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';

import 'package:gpp/src/views/peca/views/widgets/peca_detalhe_view_desktop.dart';
import 'package:gpp/src/views/peca/views/widgets/peca_editar_view_mobile.dart';

class PecaEditarView extends StatelessWidget {
  final int id;
  PecaEditarView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return PecaEditarViewMobile(id: id);
    } else {
      return PecaDetalheViewDesktop(id: id);
    }
  }
}
