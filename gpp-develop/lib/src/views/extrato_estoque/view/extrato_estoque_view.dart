import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/extrato_estoque/view/extrato_estoque_view_desktop.dart';
import 'package:gpp/src/views/extrato_estoque/view/extrato_estoque_view_mobile.dart';

class ExtratoEstoqueView extends StatelessWidget {
  const ExtratoEstoqueView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return ExtratoEstoqueViewMobile();
    } else {
      return ExtratoEstoqueViewDesktop();
    }
  }
}
