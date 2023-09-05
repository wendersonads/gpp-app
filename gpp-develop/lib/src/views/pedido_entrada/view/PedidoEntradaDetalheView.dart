import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/pedido_entrada/view/widgets/pedido_entrada_detalhe_desktop.dart';
import 'package:gpp/src/views/pedido_entrada/view/widgets/pedido_entrada_detalhe_mobile.dart';

class PedidoEntradaDetalheView extends StatelessWidget {
  final int id;

  PedidoEntradaDetalheView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return PedidoEntradaDetalheMobile(id: id);
    } else {
      return PedidoEntradaDetalheDesktop(id: id);
    }
  }
}
