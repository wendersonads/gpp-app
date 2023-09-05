import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/views/entrada/widgets/entrada_pedido_view_desktop.dart';
import 'package:gpp/src/views/entrada/widgets/entrada_pedido_view_mobile.dart';

import '../../utils/dispositivo.dart';

class EntradaPedidoView extends StatefulWidget {
  const EntradaPedidoView({Key? key}) : super(key: key);

  @override
  _EntradaPedidoViewState createState() => _EntradaPedidoViewState();
}

class _EntradaPedidoViewState extends State<EntradaPedidoView> {
  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return EntradaPedidoViewMobile();
    } else {
      return EntradaPedidoViewDesktop();
    }
  }
}
