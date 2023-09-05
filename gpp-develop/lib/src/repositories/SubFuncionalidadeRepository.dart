import 'dart:convert';

import 'package:gpp/src/models/FuncionalidadeModel.dart';
import 'package:gpp/src/models/subfuncionalidade.dart';

import 'package:gpp/src/shared/exceptions/subfuncionalities_exception.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class SubFuncionalidadeRepository {
  late ApiService api;

  SubFuncionalidadeRepository() {
    api = ApiService();
  }

  Future<List<SubFuncionalidadeModel>> fetch(String id) async {
    Response response =
        await api.get('/funcionalidades/' + id + '/subfuncionalidades');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<SubFuncionalidadeModel> subfuncionalidades = data
          .map<SubFuncionalidadeModel>(
              (data) => SubFuncionalidadeModel.fromJson(data))
          .toList();

      return subfuncionalidades;
    } else {
      throw SubFuncionalitiesException("Funcionalidades não encontrada !");
    }
  }

  Future<bool> create(
      String id, SubFuncionalidadeModel subFuncionalitie) async {
    Response response = await api.post(
        '/itensfuncionalidades/' + id, subFuncionalitie.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw SubFuncionalitiesException("Funcionalidade não foi cadastrada !");
    }
  }

  Future<bool> update(SubFuncionalidadeModel subFuncionalitie) async {
    Response response = await api.put(
        '/itensfuncionalidades/' +
            subFuncionalitie.idSubFuncionalidade.toString(),
        subFuncionalitie.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw SubFuncionalitiesException("Funcionalidade não foi atualizada !");
    }
  }

  Future<bool> delete(FuncionalidadeModel funcionalidade,
      SubFuncionalidadeModel subFuncionalidade) async {
    Response response = await api.delete(
      '/funcionalidades/${funcionalidade.idFuncionalidade}/subfuncionalidades/${subFuncionalidade.idSubFuncionalidade}',
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw SubFuncionalitiesException(error);
    }
  }
}
