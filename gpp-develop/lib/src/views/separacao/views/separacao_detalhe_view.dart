import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/separacao/views/widgets/separacao_detalhe_desktop_view.dart';
import 'package:gpp/src/views/separacao/controllers/separacao_detalhe_controller.dart';
import 'package:gpp/src/views/separacao/views/widgets/separacao_detalhe_mobile_view.dart';

import '../../../shared/components/TextComponent.dart';

class SeparacaoDetalheView extends StatelessWidget {
  final int id;
  const SeparacaoDetalheView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SeparacaoDetalheController(id));

    if (Dispositivo.mobile(context.width)) {
      return SeparacaoDetalheMobileView();
    } else {
      return SeparacaoDetalheDesktopView();
    }
  }
}

class ButtonSeparacaoWidget extends StatelessWidget {
  final bool separado;
  final Function onPressed;
  const ButtonSeparacaoWidget({
    Key? key,
    required this.separado,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!separado) {
      return GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          color: Colors.grey.shade500,
          width: 120,
          padding: EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Center(
            child: TextComponent(
              'Não separado',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          width: 120,
          color: Colors.lightGreenAccent.shade700,
          padding: EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Center(
            child: TextComponent(
              'Separado',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }
}
