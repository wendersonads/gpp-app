import 'package:auth_migration/core/auth/token_service.dart';
import 'package:auth_migration/domain/model/token_model.dart';
import 'package:auth_migration/base/service/base_service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final TokenService _tokenService = TokenService();

  final BaseService _abstractService = BaseService('auth');

  Future<bool> authCheck() async {
    Token token = _tokenService.get();
    http.Response response = await http.get(
      await _abstractService.getUrl('check'),
      headers: token.sendToken(),
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<void> logOut() async {
    _tokenService.delete();
  }
}
