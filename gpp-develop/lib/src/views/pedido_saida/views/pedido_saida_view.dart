import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/pedido_saida/views/widgets/pedido_saida_desktop.dart';
import 'package:gpp/src/views/pedido_saida/views/widgets/pedido_saida_mobile.dart';

class PedidoSaidaListView extends StatelessWidget {
  const PedidoSaidaListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return PedidoSaidaMobile();
    } else {
      return PedidoSaidaDesktop();
    }
  }
}
