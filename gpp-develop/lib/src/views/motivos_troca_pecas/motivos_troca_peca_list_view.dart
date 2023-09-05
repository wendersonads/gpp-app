import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/motivos_troca_pecas/widgets/motivos_troca_pecas_desktop.dart';
import 'package:gpp/src/views/motivos_troca_pecas/widgets/motivos_troca_pecas_mobile.dart';

class MotivosTrocaPecasListView extends StatelessWidget {
  const MotivosTrocaPecasListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return MotivosTrocaPecasMobile();
    } else {
      return MotivosTrocaPecasDesktop();
    }
  }
}

class CardWidget extends StatelessWidget {
  final String texto;
  final String total;
  final Icon icon;
  final Color color;
  const CardWidget({
    Key? key,
    required this.texto,
    required this.total,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextComponent(
                      texto,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextComponent(
                      total,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: color),
                child: Center(
                  child: icon,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
