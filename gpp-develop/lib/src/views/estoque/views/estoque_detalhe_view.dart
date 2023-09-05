import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/estoque/controllers/estoque_detalhe_controller.dart';
import 'package:gpp/src/views/estoque/views/widgets/estoque_detalhe_view_desktop.dart';
import 'package:gpp/src/views/estoque/views/widgets/estoque_detalhe_view_mobile.dart';

class EstoqueDetalheView extends StatelessWidget {
  final int id;
  const EstoqueDetalheView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.put(EstoqueDetalheController(id));
    if (Dispositivo.mobile(context.width)) {
      return EstoqueDetalheViewMobile(id: id);
    }
    return EstoqueDetalheViewDesktop(
      id: id,
    );
  }
}
