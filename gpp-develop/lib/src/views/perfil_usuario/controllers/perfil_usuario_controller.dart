import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/perfil_usuario_model.dart';
import 'package:gpp/src/repositories/perfil_usuario_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';

class PerfilUsuarioController extends GetxController {
  var carregando = false.obs;
  late List<PerfilUsuarioModel> perfisUsuarios;
  late PerfilUsuarioRepository perfilUsuarioRepository;
  late PerfilUsuarioModel perfilUsuario;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PerfilUsuarioController() {
    perfisUsuarios = <PerfilUsuarioModel>[].obs;
    perfilUsuarioRepository = PerfilUsuarioRepository();
    perfilUsuario = PerfilUsuarioModel();
  }

  @override
  void onInit() async {
    await buscarPerfilUsuario();
    super.onInit();
  }

  buscarPerfilUsuario() async {
    try {
      carregando(true);

      perfisUsuarios = await perfilUsuarioRepository.buscarPerfisUsuarios();
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      update();
    }
  }

  criarPerfilUsuario() async {
    try {
      if (await perfilUsuarioRepository.criarPerfilUsuario(perfilUsuario)) {
        Notificacao.snackBar('Perfil de usuário cadastrado com sucesso!');
        Get.toNamed('/perfil-usuario');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      buscarPerfilUsuario();
    }
  }

  deletarPerfilUsuario(int idPerfilUsuario) async {
    try {
      if (await Notificacao.confirmacao(
          'As funcionalidades relacionadas a esse perfil será apagadas, pressione sim para continuar ou não para cancelar')) {
        if (await perfilUsuarioRepository
            .deletarPerfilUsuario(idPerfilUsuario)) {
          Notificacao.snackBar('Perfil de usuário excluído com sucesso!');
        }
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      buscarPerfilUsuario();
    }
  }
}
