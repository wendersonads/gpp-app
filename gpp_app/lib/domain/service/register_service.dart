import 'dart:convert';

import 'package:auth_migration/base/service/base_service.dart';
import 'package:auth_migration/base/service/abstract_service.dart';
import 'package:auth_migration/domain/model/dto/register_dto.dart';
import 'package:auth_migration/domain/model/register_model.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:http/http.dart';

class RegisterService extends AbstractService<Register, RegisterDTO> {
  RegisterService() : super('');
  final BaseService _abstractService = BaseService('');

  Future<bool> tryRegister(
      String name, String username, String password) async {

      RegisterDTO register =
          RegisterDTO(name: name, username: username, password: password);
      Response response = await post(await _abstractService.getUrl('register'),
          body: register.toJson(),
          headers: {'Content-Type': 'application/json'});
      var error = '';
      if (response.statusCode == 200) {
        return true;
      } else {
        error = json.decode(utf8.decode(response.bodyBytes))['message'];
        Notificacao.snackBar(error,
          tipoNotificacao: TipoNotificacaoEnum.error); 
      }
     return false;
  }

  @override
  Register fromJson(Map<String, dynamic> json) {
    return Register.fromMap(json);
  }
}
