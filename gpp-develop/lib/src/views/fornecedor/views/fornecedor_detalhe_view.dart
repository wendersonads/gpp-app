import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/fornecedor/controllers/fornecedor_detalhe_controller.dart';

import 'package:gpp/src/views/fornecedor/views/widgets/fornecedor_detalhe_desktop.dart';
import 'package:gpp/src/views/fornecedor/views/widgets/fornecedor_detalhe_mobile.dart';

class FornecedorDetalheView extends StatelessWidget {
  final int id;
  const FornecedorDetalheView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FornecedorDetalheController(id));

    if (Dispositivo.mobile(context.width)) {
      return FornecedorDetalheMobile();
    } else {
      return FornecedorDetalheDesktop();
    }
  }
}
