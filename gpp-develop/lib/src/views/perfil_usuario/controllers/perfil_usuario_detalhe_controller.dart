import 'package:get/get.dart';
import 'package:gpp/src/models/FuncionalidadeModel.dart';

import 'package:gpp/src/models/perfil_usuario_model.dart';
import 'package:gpp/src/repositories/funcionalidade_repository.dart';
import 'package:gpp/src/repositories/perfil_usuario_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';

class PerfilUsuarioDetalheController extends GetxController {
  var carregando = false.obs;
  var carregandoFuncionalidades = false.obs;
  late PerfilUsuarioModel perfilUsuario;
  late PerfilUsuarioRepository perfilUsuarioRepository;
  late FuncionalidadeRepository funcionalidadeRepository;
  late List<FuncionalidadeModel> funcionalidades;
  late int idPerfilUsuario;

  PerfilUsuarioDetalheController(int idPerfilUsuario) {
    perfilUsuario = PerfilUsuarioModel();
    perfilUsuarioRepository = PerfilUsuarioRepository();
    funcionalidadeRepository = FuncionalidadeRepository();
    funcionalidades = <FuncionalidadeModel>[].obs;
    this.idPerfilUsuario = idPerfilUsuario;
  }

  @override
  void onInit() async {
    await buscarPerfilUsuario();
    await buscarFuncionalidades();
    super.onInit();
  }

  buscarPerfilUsuario() async {
    try {
      carregando(true);

      perfilUsuario =
          await perfilUsuarioRepository.buscarPerfilUsuario(idPerfilUsuario);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      update();
    }
  }

  buscarFuncionalidades() async {
    try {
      carregandoFuncionalidades(true);

      funcionalidades = await funcionalidadeRepository.buscarFuncionalidades();
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoFuncionalidades(false);
      update();
    }
  }

  vincularPerfilUsuarioFuncionalidade(
      int idPerfilUsuario, int idFuncionalidade) async {
    try {
      if (await perfilUsuarioRepository.vincularPerfilUsuarioFuncionalidade(
          idPerfilUsuario, idFuncionalidade)) {
        Notificacao.snackBar(
            'Funcionalidade vinculada com sucesso ao perfil de usuário!');
      }
      ;
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      await buscarPerfilUsuario();
      await buscarFuncionalidades();
    }
  }

  removerPerfilUsuarioFuncionalidade(
      int idPerfilUsuario, int idFuncionalidade) async {
    try {
      if (await perfilUsuarioRepository.removerPerfilUsuarioFuncionalidade(
          idPerfilUsuario, idFuncionalidade)) {
        Notificacao.snackBar(
            'Funcionalidade removida com sucesso ao perfil de usuário!');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      buscarFuncionalidades();
      await buscarPerfilUsuario();
      await buscarFuncionalidades();
    }
  }

  verificarFuncionalidade(idFuncionalidade) {
    var resultado = perfilUsuario.funcionalidades!.firstWhereOrNull(
        (element) => element.idFuncionalidade == idFuncionalidade);

    if (resultado == null) {
      return 1;
    } else {
      return 0;
    }
  }
}
