import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../shared/components/TextComponent.dart';
import '../utils/dispositivo.dart';
import 'styles.dart';

class SituacaoSolicitacaoWidget extends StatelessWidget {
  final int? situacao;

  const SituacaoSolicitacaoWidget({
    Key? key,
    required this.situacao,
  }) : super(key: key);

  String getText() {
    switch (situacao) {
      case 1:
        return 'Em Aberto';

      case 2:
        return 'Em Execução';
      case 3:
        return 'Cancelada';
      case 4:
        return 'Finalizada';
      default:
        return 'Em Aberto';
    }
  }

  Color getColor() {
    switch (situacao) {
      case 1:
        return primaryColor;
      case 2:
        return primaryColorHover;
      case 3:
        return HexColor('#F44336');
      case 4:
        return HexColor('#00CF80');
      default:
        return primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 140, maxWidth: 140),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: getColor(),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextComponent(
        getText(),
        fontSize: context.textScaleFactor * 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        textAlign: Dispositivo.mobile(context.width) ? TextAlign.center : null,
      ),
    );
  }
}
