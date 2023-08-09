import 'package:auth_migration/base/base/enum/content_type_enum.dart';
import 'package:auth_migration/base/service/base_service.dart';
import 'package:auth_migration/base/service/abstract_service.dart';
import 'package:auth_migration/domain/model/dto/register_dto.dart';
import 'package:auth_migration/domain/model/register_model.dart';
import 'package:auth_migration/base/custom/custom_http.dart';
import 'package:http/http.dart';

class RegisterService extends AbstractService<Register, RegisterDTO> {
  RegisterService() : super('');
  final BaseService _abstractService = BaseService('auth');

  Future<bool> tryRegister(String username, String password) async {
    RegisterDTO register = RegisterDTO(username: username, password: password);
    Response response = await CustomHttp.post(
        await _abstractService.getUrl('register'),
        body: register.toJson(),
        type: ContentTypeEnum.applicationJson,
        secure: false);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Register fromJson(Map<String, dynamic> json) {
    return Register.fromMap(json);
  }
}
