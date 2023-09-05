import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/avaria/views/controller/detalhes_produto_avaria_controller.dart';
import 'package:gpp/src/views/avaria/views/widgets/detalhes_produto_avaria_desktop.dart';
import 'package:gpp/src/views/avaria/views/widgets/detalhes_produto_avaria_mobile.dart';

class DetalhesProdutoAvariaView extends StatelessWidget {
  final int id;

  DetalhesProdutoAvariaView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Get.put(DetalhesProdutoAvariaController(id));

    if (Dispositivo.mobile(context.width)) {
      return DetalhesProdutoAvariaMobile();
    } else {
      return DetalhesProdutoAvariaDesktop();
    }
  }
}
