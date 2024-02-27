import 'dart:convert';

import 'package:auth_migration/domain/model/perfil_usuario.dart';
import 'package:auth_migration/domain/model/usuario_model.dart';

import '../../base/service/base_service.dart';
import '../../core/auth/token_service.dart';
import '../../shared/components/Notificacao.dart';
import '../../view/splash/splash_screen.dart';
import '../model/token_model.dart';
import 'package:http/http.dart';
import 'package:get/get.dart' as gett;

class PerfilUsuarioRepository {
  final BaseService _baseService = BaseService('');
  final TokenService _tokenService = TokenService();

  Future<List<Usuario>> listarTodos() async {
    Token token = _tokenService.get();
    var error;
    Response response = await get(await _baseService.getUrl('/account/'),
        headers: token.sendToken());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Usuario> users =
          data.map<Usuario>((data) => Usuario.fromJson(data)).toList();
      return users;
    } else if (response.statusCode == 401) {
      _tokenService.delete();
      error = jsonDecode(response.body)['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
      gett.Get.to(const SplashScreen());
    } else {
      error = jsonDecode(response.body)['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
    }
    return [];
  }

  Future<Usuario> buscarPorId(int idUsuario) async {
    late Usuario user;
    Token token = _tokenService.get();
    var error;
    Response response = await get(
        await _baseService.getUrl('/account/' + idUsuario.toString()),
        headers: token.sendToken());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      user = Usuario.fromJson(data);
    } else if (response.statusCode == 401) {
      _tokenService.delete();
      error = jsonDecode(response.body)['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
      gett.Get.to(const SplashScreen());
    } else {
      error = jsonDecode(response.body)['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
    }
    return user;
  }

  Future<List<PerfilUsuario>> buscarPerfis() async {
    late Usuario user;
    Token token = _tokenService.get();
    var error;
    Response response = await get(await _baseService.getUrl('/perfil/'),
        headers: token.sendToken());

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<PerfilUsuario> usuarios = data
          .map<PerfilUsuario>((data) => PerfilUsuario.fromJson(data))
          .toList();
      return usuarios;
    } else if (response.statusCode == 401) {
      _tokenService.delete();
      error = jsonDecode(response.body)['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
      gett.Get.to(const SplashScreen());
    } else {
      error = jsonDecode(response.body)['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
    }
    return [];
  }

  Future<bool> vincularPerfilUsuario(int? idUser,  int idPerfil) async {
    Token token = _tokenService.get();
    var error = '';
    late bool retorno;
    Uri url = await _baseService.getUrl('/perfil/vincular?idconta=$idUser&id=$idPerfil');
    Response response = await post(
      url,
      headers: {'Content-Type': 'application/json', ...token.sendToken()},
    );
    if (response.statusCode == 200) {
      retorno = true;
    } else if (response.statusCode == 401) {
      retorno = false;
      _tokenService.delete();
      error = jsonDecode(response.body)['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
      gett.Get.to(const SplashScreen());
    } else {
      retorno = false;
      error = jsonDecode(response.body)['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
    }
    return retorno;
  }
}
