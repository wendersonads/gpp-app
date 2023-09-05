import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/peca/views/widgets/peca_view_desktop.dart';
import 'package:gpp/src/views/peca/views/widgets/peca_view_mobile.dart';

class PecaView extends StatelessWidget {
  const PecaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return PecaViewMobile();
    } else {
      return PecaViewDesktop();
    }
  }
}
