import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/motivo_ajuste_estoque/widgets/motivo_ajuste_estoque_view_desktop.dart';
import 'package:gpp/src/views/motivo_ajuste_estoque/widgets/motivo_ajuste_estoque_view_mobile.dart';

class MotivoAjusteEstoqueView extends StatelessWidget {
  MotivoAjusteEstoqueView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return MotivoAjusteEstoqueViewMobile();
    } else {
      return MotivoAjusteEstoqueViewDesktop();
    }
  }
}
