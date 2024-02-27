import 'package:auth_migration/domain/model/perfil_usuario.dart';
import 'package:auth_migration/domain/model/usuario_model.dart';
import 'package:auth_migration/domain/repository/perfil_usuario_repository.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:get/get.dart';

class PerfilUsuarioDetalheService extends GetxController {
  var carregandoUsuario = false.obs;
  var etapa = 1.obs;
  late int id;
  late Rx<Usuario> usuario;
  late PerfilUsuarioRepository repository;
  late RxList<PerfilUsuario> usuarios;
  late RxInt idPerfilUsuario;

  PerfilUsuarioDetalheService(Id) {
    id = Id;
    usuario = Usuario().obs;
    repository = PerfilUsuarioRepository();
    usuarios = <PerfilUsuario>[].obs;
    idPerfilUsuario = 0.obs;
  }

  @override
  void onInit() async {
    super.onInit();
    await buscarPorId();
    await buscarPerfis();
  }

  Future<void> buscarPorId() async {
    try {
      usuario.value = await repository.buscarPorId(id);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    }
  }

  Future<void> buscarPerfis() async {
    try {
      carregandoUsuario(true);
      usuarios.value = await repository.buscarPerfis();
    } catch (e) {
      carregandoUsuario(false);
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoUsuario(true);
    }
  }

  Future<bool> vincularPerfilUsuario() async {
   bool retorno = false;
    try {
      print(idPerfilUsuario.value);
      retorno = await repository.vincularPerfilUsuario(usuario.value.id ,idPerfilUsuario.value);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    }
    return retorno;
  }
}
