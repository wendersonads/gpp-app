import 'package:auth_migration/shared/components/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/components/TextComponent.dart';
import '../utils/dispositivo.dart';

class EventoStatusWidget extends StatelessWidget {
  final String texto;
  final Color? color;
  const EventoStatusWidget({
    Key? key,
    required this.texto,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 260,
      constraints: BoxConstraints(minWidth: 140, maxWidth: 140),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(color: color ?? primaryColor, borderRadius: BorderRadius.circular(5)),
      child: TextComponent(
        texto,
        fontSize: context.textScaleFactor * 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        textAlign: Dispositivo.mobile(context.width) ? TextAlign.center : null,
      ),
    );
  }
}
