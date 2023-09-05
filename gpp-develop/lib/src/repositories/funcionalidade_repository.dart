import 'dart:convert';

import 'package:gpp/src/shared/exceptions/funcionalities_exception.dart';
import 'package:gpp/src/models/FuncionalidadeModel.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class FuncionalidadeRepository {
  late ApiService api;

  FuncionalidadeRepository() {
    this.api = ApiService();
  }

  Future<FuncionalidadeModel> fetch(String id) async {
    Response response = await api.get('/funcionalidades/' + id);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return FuncionalidadeModel.fromJson(data);
    } else {
      throw FuncionalitiesException("Funcionalidades não encontrada !");
    }
  }

  Future<List<FuncionalidadeModel>> buscarFuncionalidades() async {
    Response response = await api.get('/funcionalidades');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<FuncionalidadeModel> funcionalidades = data
          .map<FuncionalidadeModel>(
              (data) => FuncionalidadeModel.fromJson(data))
          .toList();

      return funcionalidades;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> create(FuncionalidadeModel funcionalitie) async {
    Response response =
        await api.post('/funcionalidades', funcionalitie.toJson()); // alteração

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw FuncionalitiesException("Funcionalidade não foi cadastrada !");
    }
  }

  Future<bool> update(FuncionalidadeModel funcionalitie) async {
    Response response = await api.put(
        '/funcionalidades/' + funcionalitie.idFuncionalidade.toString(),
        funcionalitie.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw FuncionalitiesException("Funcionalidade não foi atualizada !");
    }
  }

  Future<bool> delete(FuncionalidadeModel funcionalitie) async {
    Response response = await api.delete(
      '/funcionalidades/' + funcionalitie.idFuncionalidade.toString(),
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw FuncionalitiesException("Funcionalidade não foi deletada !");
    }
  }
}
