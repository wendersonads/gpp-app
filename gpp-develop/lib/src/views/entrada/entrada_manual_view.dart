import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/entrada/widgets/entrada_manual_view_desktop.dart';
import 'package:gpp/src/views/entrada/widgets/entrada_manual_view_mobile.dart';

class EntradaManualView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return EntradaManualViewMobile();
    } else {
      return EntradaManualViewDesktop();
    }
  }
}
