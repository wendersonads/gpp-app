import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/solicitacao_os/controllers/solicitacao_os_detalhe_controller.dart';
import 'package:gpp/src/views/solicitacao_os/views/widgets/solicitacao_os_detalhe_desktop.dart';
import 'package:gpp/src/views/solicitacao_os/views/widgets/solicitacao_os_detalhe_mobile.dart';

class SolicitacaoOSDetalheView extends StatelessWidget {
  final int id;

  SolicitacaoOSDetalheView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Get.put(SolicitacaoOSDetalheController(id));

    if (Dispositivo.mobile(context.width)) {
      return SolicitacaoOSDetalheMobile();
    } else {
      return SolicitacaoOSDetalheDesktop();
    }
  }
}
