import 'package:get/get.dart';
import 'package:gpp/src/models/perfil_usuario_model.dart';
import 'package:gpp/src/models/user_model.dart';
import 'package:gpp/src/repositories/perfil_usuario_repository.dart';
import 'package:gpp/src/repositories/usuario_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';

class UsuarioDetalheController extends GetxController {
  late int idUsuario;
  var etapa = 1.obs;
  var carregandoUsuario = false.obs;
  var carregandoPerfisUsuario = false.obs;
  late PerfilUsuarioRepository perfilUsuarioRepository;
  late List<PerfilUsuarioModel> perfisUsuario;
  late PerfilUsuarioModel selecaoPerfilUsuario;
  late UsuarioRepository usuarioRepository;
  late UsuarioModel usuario;

  UsuarioDetalheController(int idUsuario) {
    this.idUsuario = idUsuario;
    perfilUsuarioRepository = PerfilUsuarioRepository();
    perfisUsuario = <PerfilUsuarioModel>[].obs;
    selecaoPerfilUsuario = PerfilUsuarioModel();
    usuarioRepository = UsuarioRepository();
    usuario = UsuarioModel();
  }

  @override
  void onInit() async {
    await buscarUsuario();
    await buscarPerfisUsuario();
    super.onInit();
  }

  buscarUsuario() async {
    try {
      carregandoUsuario(true);

      usuario = await usuarioRepository.buscarUsuario(idUsuario);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoUsuario(false);
      update();
    }
  }

  buscarPerfisUsuario() async {
    try {
      carregandoPerfisUsuario(true);

      perfisUsuario = await perfilUsuarioRepository.buscarPerfisUsuarios();
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoPerfisUsuario(false);
      update();
    }
  }

  vincularPerfilUsuario(PerfilUsuarioModel perfilUsuario) async {
    try {
      if (await Notificacao.confirmacao(
          'Atenção: ao realizar o vinculo, o usuário vai ter acesso a todas as funcionalidades atribuídas ao perfil, pressione sim para continuar ou não para cancelar')) {
        await usuarioRepository.vincularPerfilUsuario(
            usuario.id!, perfilUsuario);

        Notificacao.snackBar('Usuário vinculado ao perfil com sucesso');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    }
  }
}
