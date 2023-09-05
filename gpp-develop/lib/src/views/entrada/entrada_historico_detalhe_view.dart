import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/entrada/controller/entrada_historico_detalhe_controller.dart';
import 'package:gpp/src/views/entrada/responsive/entrada_historico_detalhe_view_desktop.dart';
import 'package:gpp/src/views/entrada/responsive/entrada_historico_detalhe_view_mobile.dart';

// ignore: must_be_immutable
class EntradaHistoricoDetalheView extends StatelessWidget {
  int id;
  EntradaHistoricoDetalheView({required this.id});

  MaskFormatter maskFormatter = MaskFormatter();

  @override
  Widget build(BuildContext context) {
    Get.delete<EntradaHistoricoDetalheController>();
    // ignore: unused_local_variable
    final EntradaHistoricoDetalheController controller = Get.put(EntradaHistoricoDetalheController(id));

    if (Dispositivo.mobile(context.width)) {
      return EntradaHistoricoDetalheViewMobile();
    } else {
      return EntradaHistoricoDetalheViewDesktop();
    }
  }
}
