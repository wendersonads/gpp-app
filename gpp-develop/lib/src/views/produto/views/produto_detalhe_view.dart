import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/produto/controllers/produto_detalhe_controller.dart';
import 'package:gpp/src/views/produto/views/widgets/produto_detalhe_view_desktop.dart';
import 'package:gpp/src/views/produto/views/widgets/produto_detalhe_view_mobile.dart';

class ProdutoDetalheView extends StatelessWidget {
  final int id;
  const ProdutoDetalheView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProdutoDetalheController(id));

    if (Dispositivo.mobile(context.width)) {
      return ProdutoDetalheViewMobile(id: this.id);
    } else {
      return ProdutoDetalheViewDesktop(
        id: this.id,
      );
    }
  }
}
