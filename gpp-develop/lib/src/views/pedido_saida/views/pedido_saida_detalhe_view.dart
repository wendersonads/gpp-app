import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/pedido_saida/views/widgets/pedido_saida_detalhe_desktop.dart';
import 'package:gpp/src/views/pedido_saida/views/widgets/pedido_saida_detalhe_mobile.dart';

import 'package:gpp/src/views/pedido_saida/controllers/pedido_saida_detalhe_controller.dart';

class PedidoSaidaDetalheView extends StatelessWidget {
  final int id;
  const PedidoSaidaDetalheView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PedidoSaidaDetalheController(id));

    if (Dispositivo.mobile(context.width)) {
      return PedidoSaidaDetalheMobile();
    } else {
      return PedidoSaidaDetalheDesktop();
    }
  }
}
