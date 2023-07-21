import 'package:auth_migration/core/util/string_util.dart';
import 'package:auth_migration/domain/model/token_model.dart';
import 'package:hive/hive.dart';

class TokenService {
  final Box _storage = Hive.box('tokenStore');

  bool exists() {
    return !StringUtil.isEmpty(_storage.get('accessToken') ?? '');
  }

  save(Token _token) {
    _storage.put('accessToken', _token.accessToken);
    _storage.put('refreshToken', _token.refreshToken);
  }

  Token get() {
    return Token(
        accessToken: _storage.get('accessToken') ?? '',
        refreshToken: _storage.get('refreshToken') ?? '');
  }

  delete() {
    _storage.put('accessToken', '');
    _storage.put('refreshToken', '');
  }
}
