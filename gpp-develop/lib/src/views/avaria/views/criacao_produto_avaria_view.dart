import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/avaria/views/widgets/criacao_produto_avaria_desktop.dart';
import 'package:gpp/src/views/avaria/views/widgets/criacao_produto_avaria_mobile.dart';

class CriacaoProdutoAvariaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return CriacaoProdutoAvariaMobile();
    } else {
      return CriacaoProdutoAvariaDesktop();
    }
  }
}
