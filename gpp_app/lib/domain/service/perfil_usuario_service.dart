import 'package:auth_migration/domain/model/usuario_model.dart';
import 'package:auth_migration/domain/repository/perfil_usuario_repository.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:get/get.dart';

import '../model/pagina_model.dart';

class PerfilUsuarioService extends GetxController {
  late RxList<Usuario> usuarios;
  late PerfilUsuarioRepository repository;
  var carregando = false.obs;
  late Pagina pagina;


  PerfilUsuarioService() {
    usuarios = <Usuario>[].obs;
    repository = PerfilUsuarioRepository();
     pagina = Pagina(total: 0, atual: 1);
  }

  @override
  void onInit() async {
    super.onInit();
    await listarTodos();
  }

  Future<void> listarTodos() async {
    try {
      carregando(true);
      usuarios.value = await repository.listarTodos();
    } catch (e) {
      carregando(false);
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    }
  }
}
