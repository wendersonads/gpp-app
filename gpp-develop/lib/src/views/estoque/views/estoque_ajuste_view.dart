import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/estoque/controllers/estoque_ajuste_controller.dart';
import 'package:gpp/src/views/estoque/views/widgets/estoque_ajuste_view_desktop.dart';
import 'package:gpp/src/views/estoque/views/widgets/estoque_ajuste_view_mobile.dart';

class EstoqueAjusteView extends StatelessWidget {
  final int id;
  const EstoqueAjusteView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.put(EstoqueAjusteController(id));
    if (Dispositivo.mobile(context.width)) {
      return EstoqueAjusteViewMobile(id: id);
    } else {
      return EstoqueAjusteViewDesktop(id: id);
    }
  }
}
