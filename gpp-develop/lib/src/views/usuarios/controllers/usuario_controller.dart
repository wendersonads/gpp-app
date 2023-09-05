import 'package:get/get.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/user_model.dart';
import 'package:gpp/src/repositories/usuario_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';

class UsuarioController2 extends GetxController {
  var carregando = false.obs;

  late List<UsuarioModel> usuarios;
  late UsuarioRepository usuarioRepository;
  late PaginaModel pagina;
  String pesquisar = '';
  UsuarioController2() {
    usuarios = <UsuarioModel>[].obs;
    pagina = PaginaModel(atual: 1, total: 0);
    usuarioRepository = UsuarioRepository();
  }

  @override
  void onInit() async {
    await buscarUsuarios();
    super.onInit();
  }

  buscarUsuarios() async {
    try {
      carregando(true);

      var retorno = await usuarioRepository.buscarUsuarios(pagina.atual,
          pesquisar: pesquisar);

      this.usuarios = retorno[0];
      this.pagina = retorno[1];
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      update();
    }
  }
}
