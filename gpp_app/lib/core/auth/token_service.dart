import 'package:auth_migration/core/util/string_util.dart';
import 'package:auth_migration/domain/model/token_model.dart';
import 'package:hive/hive.dart';

class TokenService {
  final Box _storage = Hive.box('token');

  bool exists() {
    return !StringUtil.isEmpty(_storage.get('token') ?? '');
  }

  save(String token) {
    _storage.put('token', token);
  }

  Token get() {
    return Token(token: _storage.get('token') ?? '');
  }

  delete() {
    _storage.put('token', '');
  }

  bool isAuthenticated() {
    return _storage.get('token') != null;
  }
}
