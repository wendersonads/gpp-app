import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/avaria/views/widgets/consulta_produto_avaria_desktop.dart';
import 'package:gpp/src/views/avaria/views/widgets/consulta_produto_avaria_mobile.dart';

class ProdutoAvariaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return ConsultaProdutoAvariaMobile();
    } else {
      return ConsultaProdutoAvariaDesktop();
    }
  }
}
