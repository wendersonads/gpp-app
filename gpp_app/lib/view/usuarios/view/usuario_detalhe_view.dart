import 'package:auth_migration/view/usuarios/usuario_detatlhe.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/service/perfil_usuario_detalhe_service.dart';
import '../../../shared/utils/dispositivo.dart';

class UsuarioDetalheView extends StatelessWidget{
final int id;
const UsuarioDetalheView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Get.put(PerfilUsuarioDetalheService(id));

    if (Dispositivo.mobile(context.width)) {
      return const UsuarioDetalhe();
    } 
    return Container();
  }
}