import 'package:auth_migration/base/base/enum/content_type_enum.dart';
import 'package:auth_migration/core/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CustomHttp {
  static final TokenService _tokenService = TokenService();

  static Future<Response> get(Uri url,
      {Map<String, String>? headers, bool secure = false}) async {
    Map<String, String> _headers = <String, String>{};
    if (secure) {
      _headers = {..._tokenService.get().sendToken(), ...?headers};
      return await http.get(url, headers: _headers);
    }
    return await http.get(url, headers: headers);
  }

  static Future<Response> post(Uri url,
      {Map<String, String>? headers,
      ContentTypeEnum type = ContentTypeEnum.applicationJson,
      Object? body,
      bool secure = false}) async {
    Map<String, String> _headers = <String, String>{};
    if (secure) {
      _headers = {
        ..._tokenService.get().sendToken(),
        ...type.value,
        ...?headers
      };
      return await http.post(url, headers: _headers, body: body);
    }
    _headers = {...type.value, ...?headers};
    return await http.post(url, headers: _headers, body: body);
  }

  static Future<Response> put(Uri url,
      {Map<String, String>? headers,
      ContentTypeEnum type = ContentTypeEnum.urlEncoded,
      Object? body,
      bool secure = false}) async {
    Map<String, String> _headers = <String, String>{};
    if (secure) {
      _headers = {
        ..._tokenService.get().sendToken(),
        ...type.value,
        ...?headers
      };
      return await http.put(url, headers: _headers, body: body);
    }
    _headers = {...type.value, ...?headers};
    return await http.put(url, headers: _headers, body: body);
  }

  static Future<Response> patch(Uri url,
      {Map<String, String>? headers,
      ContentTypeEnum type = ContentTypeEnum.urlEncoded,
      Object? body,
      bool secure = false}) async {
    Map<String, String> _headers = <String, String>{};
    if (secure) {
      _headers = {
        ..._tokenService.get().sendToken(),
        ...type.value,
        ...?headers
      };
      return await http.patch(url, headers: _headers, body: body);
    }
    _headers = {...type.value, ...?headers};
    return await http.patch(url, headers: _headers, body: body);
  }

  static Future<Response> delete(Uri url,
      {Map<String, String>? headers,
      ContentTypeEnum type = ContentTypeEnum.urlEncoded,
      Object? body,
      bool secure = false}) async {
    Map<String, String> _headers = <String, String>{};
    if (secure) {
      _headers = {
        ..._tokenService.get().sendToken(),
        ...type.value,
        ...?headers
      };
      return await http.delete(url, headers: _headers, body: body);
    }
    _headers = {...type.value, ...?headers};
    return await http.delete(url, headers: _headers, body: body);
  }
}
