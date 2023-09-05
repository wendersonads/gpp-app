import 'package:get/get.dart';
import 'package:gpp/src/models/FuncionalidadeModel.dart';
import 'package:gpp/src/models/filial/empresa_filial_model.dart';
import 'package:gpp/src/models/subfuncionalidade.dart';

import 'package:gpp/src/repositories/usuario_repository.dart';

import 'package:gpp/src/shared/services/auth.dart';
import 'package:gpp/src/utils/notificacao.dart';

class UsuarioController extends GetxController {
  // String pesquisar = '';
  var carregando = true.obs;
  late UsuarioRepository usuarioRepository;

  List<FuncionalidadeModel> funcionalidades = [];
  List<EmpresaFilialModel> empresaFiliais = [];
  // GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // late PaginaModel pagina;

  int marcados = 0;

  UsuarioController() {
    usuarioRepository = UsuarioRepository();
    funcionalidades = <FuncionalidadeModel>[].obs;
    // pagina = PaginaModel(atual: 1, total: 0);
  }

  @override
  void onInit() async {
    await buscarFuncionalidades();
    await buscarFiliais();

    super.onInit();
  }

  buscarFuncionalidades() async {
    try {
      carregando(true);

      funcionalidades =
          await usuarioRepository.buscarFuncionalidades(getUsuario().id!);

      funcionalidades.forEach((element) {});
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      update();
    }
  }

  buscarFiliais() async {
    try {
      carregando(true);

      empresaFiliais = await usuarioRepository.buscarFiliais();
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      update();
    }
  }

  verificarSubfuncionalidade(List<SubFuncionalidadeModel> subFuncionalidade) {
    List<SubFuncionalidadeModel>? resultado;
    if (GetPlatform.isWeb) {
      resultado =
          subFuncionalidade.where((element) => element.web == true).toList();
    } else if (GetPlatform.isMobile) {
      resultado =
          subFuncionalidade.where((element) => element.mobile == true).toList();
    }

    if (resultado != null && resultado.length > 0) {
      return true;
    } else {
      return false;
    }
  }
}
