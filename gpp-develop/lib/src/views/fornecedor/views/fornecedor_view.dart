import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/views/fornecedor/controllers/fornecedor_controller.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/fornecedor/views/widgets/fornecedor_desktop.dart';
import 'package:gpp/src/views/fornecedor/views/widgets/fornecedor_mobile.dart';

class FornecedorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(FornecedorController());

    if (Dispositivo.mobile(context.width)) {
      return FornecedorMobile();
    } else {
      return FornecedorDesktop();
    }
  }
}
