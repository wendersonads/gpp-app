import 'dart:convert';
import 'dart:io';

import 'package:auth_migration/base/base/enum/content_type_enum.dart';
import 'package:auth_migration/base/model/abstract_dto.dart';
import 'package:auth_migration/base/model/abstract_entity.dart';
import 'package:auth_migration/base/service/base_service.dart';
import 'package:auth_migration/base/custom/custom_http.dart';
import 'package:http/http.dart' as http;

abstract class AbstractService<T extends AbstractEntity, E extends AbstractDTO>
    extends BaseService {
  AbstractService(String path) : super(path);

  Future<List<T>> findAll() async {
    final response = await CustomHttp.get(
      await getUrl('find-all'),
      secure: true,
    );
    if (response.statusCode == HttpStatus.ok) {
      return fromJsonArray(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<T> findById(int id) async {
    final response = await CustomHttp.get(
      await getUrl('find-by-id/$id'),
      secure: true,
    );
    if (response.statusCode == HttpStatus.ok) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<T>> findAllEnabled() async {
    final response = await CustomHttp.get(
      await getUrl('find-all-enabled'),
      secure: true,
    );
    if (response.statusCode == HttpStatus.ok) {
      return fromJsonArray(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<T> save(E entity) async {
    final response = await CustomHttp.post(
      await getUrl('save'),
      body: entity.toJson(),
      type: ContentTypeEnum.applicationJson,
      secure: true,
    );
    if (response.statusCode == HttpStatus.ok) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<T>> saveAll(List<T> list) async {
    final response = await CustomHttp.post(
      await getUrl('save-all'),
      body: jsonEncode(list),
      type: ContentTypeEnum.applicationJson,
      secure: true,
    );
    if (response.statusCode == HttpStatus.ok) {
      return fromJsonArray(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<T> update(T entity) async {
    final response = await CustomHttp.put(
      await getUrl('update'),
      body: jsonEncode(entity),
      type: ContentTypeEnum.applicationJson,
      secure: true,
    );
    if (response.statusCode == HttpStatus.ok) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<T> updateStatus(int id) async {
    final response = await CustomHttp.patch(
      await getUrl('update-status/$id'),
      secure: true,
    );
    if (response.statusCode == HttpStatus.ok) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> delete(int id) async {
    final response = await CustomHttp.delete(
      await getUrl('delete/$id'),
      secure: true,
    );
    await http.delete(await getUrl('$id'));
    if (response.statusCode == HttpStatus.ok) {
      return;
    } else {
      throw Exception(response.body);
    }
  }

  T fromJson(Map<String, dynamic> json);

  List<T> fromJsonArray(dynamic parsed) {
    return parsed.map<T>((json) => fromJson(json)).toList();
  }
}
