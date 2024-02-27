import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/service/solicitacao_asteca_detalhe_service.dart';
import '../../../shared/utils/dispositivo.dart';
import '../solicitacao_asteca_detalhe.dart';

class SolicitacaoAstecaDetalheView extends StatelessWidget {
  final int id;
  const SolicitacaoAstecaDetalheView({super.key, required this.id});
  
  @override
  Widget build(BuildContext context) {
    Get.put(SolicitacaAstecaDetalheService(id));

    if (Dispositivo.mobile(context.width)) {
      return SolicitacaAstecaDetalhe();
    } 
    return Container();
  }
  
}
