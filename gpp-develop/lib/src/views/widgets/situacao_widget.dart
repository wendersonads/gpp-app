import 'package:flutter/material.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/repositories/styles.dart';

class SituacaoWidget extends StatelessWidget {
  final int situacao;
  const SituacaoWidget({
    Key? key,
    required this.situacao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (situacao) {
      case 1:
        return Container(
          width: 80,
          decoration: BoxDecoration(
              color: secundaryColor, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextComponent(
                'Ativo',
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      case 2:
        return Container(
          width: 80,
          decoration: BoxDecoration(
              color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextComponent(
                'Inativo',
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      case 3:
        return Container(
          width: 80,
          decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextComponent(
                'Pendente',
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

      default:
        return Container();
    }
  }
}
