import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/solicitacao_os/controllers/solicitacao_os_consulta_controller.dart';
import 'package:gpp/src/views/solicitacao_os/views/widgets/solicitacao_os_consulta_desktop.dart';
import 'package:gpp/src/views/solicitacao_os/views/widgets/solicitacao_os_consulta_mobile.dart';

class SolicitacaoOSConsultaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(SolicitacaoOSConsultaController());

    if (Dispositivo.mobile(context.width)) {
      return SolicitacaoOSConsultaMobile();
    } else {
      return SolicitacaoOSConsultaDesktop();
    }
  }
}
