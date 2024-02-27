import 'dart:convert';

import 'package:auth_migration/core/auth/token_service.dart';
import 'package:auth_migration/core/auth/usuario_service.dart';
import 'package:auth_migration/domain/model/dto/login_dto.dart';
import 'package:auth_migration/domain/model/token_model.dart';
import 'package:auth_migration/base/service/base_service.dart';
import 'package:auth_migration/base/custom/custom_http.dart';
import 'package:auth_migration/domain/model/usuario_model.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:http/http.dart';

class LoginService {
  TokenService tokenService = TokenService();

  final BaseService _abstractService = BaseService('');
  final TokenService _tokenService = TokenService();
  final UsuarioService _usuarioService = UsuarioService();
  var valida = false; 

  Future<bool> tryLogin(String username, String password) async {
   
    LoginDTO login = LoginDTO(username: username, password: password);
    Response response = await CustomHttp.post(
      await _abstractService.getUrl('login'),
      headers: login.toMap(),
      body: login.toJson(),
      secure: false,
    );
    if (response.statusCode == 200) {
      var retorno = jsonDecode(response.body);
      tokenService.save(retorno["token"]);
      Token token = _tokenService.get();

      Response responseUser = await get(
        await _abstractService
            .getUrl('perfil/user?username=' + retorno["username"]),
        headers: token.sendToken(),
      );
      if (responseUser.statusCode == 200) {
        Map<String, dynamic> data  = jsonDecode(utf8.decode(responseUser.bodyBytes));
        Usuario usuario = Usuario.fromJson(data);
        _usuarioService.setUsuario(usuario);
      }
      valida = true;
    } else {
      var error = jsonDecode(utf8.decode(response.bodyBytes))['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
      valida =  false;
    }
    return valida;
  }
}
