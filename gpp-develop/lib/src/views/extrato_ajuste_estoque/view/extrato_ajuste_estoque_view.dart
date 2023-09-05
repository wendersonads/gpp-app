import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/extrato_ajuste_estoque/view/widgets/extrato_ajuste_estoque_desktop.dart';
import 'package:gpp/src/views/extrato_ajuste_estoque/view/widgets/extrato_ajuste_estoque_mobile.dart';

class ExtratoAjusteEstoque extends StatelessWidget {
  const ExtratoAjusteEstoque({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return ExtratoAjusteEstoqueMobileListView();
    } else {
      return ExtratoAjusteEstoqueDesktopListView();
    }
  }
}
