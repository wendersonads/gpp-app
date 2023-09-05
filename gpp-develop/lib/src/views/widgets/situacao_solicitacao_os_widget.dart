import 'package:flutter/material.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../shared/components/TextComponent.dart';

class SituacaoSolicitacaoOSWidget extends StatelessWidget {
  final int? situacao;

  const SituacaoSolicitacaoOSWidget({
    Key? key,
    required this.situacao,
  }) : super(key: key);

  String getText() {
    switch (situacao) {
      case 1:
        return 'Aguardando Aprovação';
      
      case 2:
        return 'Aprovada';
      case 3:
        return 'Reprovada';
      default:
        return 'Aguardando Aprovação';
    }
  }

  Color getColor() {
    switch (situacao) {
      case 1:
        return primaryColor;
      case 2:
        return HexColor('#00CF80');
      case 3:
        return HexColor('#F44336');
      default:
        return primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 140, maxWidth: 140),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
