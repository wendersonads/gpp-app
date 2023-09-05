import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/produto/controllers/produto_controller.dart';
import 'package:gpp/src/views/produto/views/widgets/produto_view_desktop.dart';
import 'package:gpp/src/views/produto/views/widgets/produto_view_mobile.dart';

class ProdutoView extends StatelessWidget {
  const ProdutoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProdutoController());

    if (Dispositivo.mobile(context.width)) {
      return ProdutoViewMobile();
    } else {
      return ProdutoViewDesktop();
    }
  }
}
