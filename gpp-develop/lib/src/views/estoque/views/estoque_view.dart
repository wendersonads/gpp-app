import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/estoque/controllers/estoque_controller.dart';
import 'package:gpp/src/views/estoque/views/widgets/estoque_view_desktop.dart';
import 'package:gpp/src/views/estoque/views/widgets/estoque_view_mobile.dart';

class EstoqueView extends StatelessWidget {
  const EstoqueView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.put(EstoqueController());
    if (Dispositivo.mobile(context.width)) {
      return EstoqueViewMobile();
    }
    return EstoqueViewDesktop();
  }
}
