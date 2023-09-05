import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/solicitacao_os/controllers/solicitacao_os_criacao_controller.dart';
import 'package:gpp/src/views/solicitacao_os/views/widgets/solicitacao_os_criacao_desktop.dart';
import 'package:gpp/src/views/solicitacao_os/views/widgets/solicitacao_os_criacao_mobile.dart';

class SolicitacaoOSCriacaoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(SolicitacaoOSCriacaoController());

    if (Dispositivo.mobile(context.width)) {
      return SolicitacaoOSCriacaoMobile();
    } else {
      return SolicitacaoOSCriacaoDesktop();
    }
  }
}
