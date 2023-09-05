import 'dart:convert';

import 'package:gpp/src/models/departament_model.dart';
import 'package:gpp/src/models/subfuncionalidade.dart';
import 'package:gpp/src/shared/exceptions/departament_exception.dart';
import 'package:gpp/src/shared/exceptions/funcionalities_exception.dart';
import 'package:http/http.dart';

import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';

class DepartamentoRepository {
  late ApiService api;

  DepartamentoRepository() {
    api = ApiService();
  }

  String path = '/departamentos';

  Future<DepartamentoModel> fetch(String id) async {
    Response response = await api.get('/departamentos/' + id);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return DepartamentoModel.fromJson(data.first.first);
    } else {
      throw DepartamentException("Não foi possível encontrar departamentos !");
    }
  }

  Future<List<DepartamentoModel>> buscarTodos() async {
    Response response = await api.get(path);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<DepartamentoModel> departamento = data
          .map<DepartamentoModel>((data) => DepartamentoModel.fromJson(data))
          .toList();
      return departamento;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List<SubFuncionalidadeModel>> fetchSubFuncionalities(
      DepartamentoModel departament) async {
    Response response = await api.get('/departamentos/itensfuncionalidades/' +
        departament.idDepartamento.toString());

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<SubFuncionalidadeModel> subFuncionalities = data.first
          .map<SubFuncionalidadeModel>(
              (data) => SubFuncionalidadeModel.fromJson(data))
          .toList();
      return subFuncionalities;
    } else {
      throw FuncionalitiesException(
          "Não foi possivel encontrar itens de funcionalidades relacionadas ao departamentos !");
    }
  }

  Future<bool> updateDepartmentSubFuncionalities(DepartamentoModel departament,
      List<SubFuncionalidadeModel> subFuncionalities) async {
    List<Map<String, dynamic>> dataSend = subFuncionalities
        .map((subFuncionalitie) => subFuncionalitie.toJson())
        .toList();

    Response response = await api.put(
        '/departamentos/itensfuncionalidades/' +
            departament.idDepartamento.toString(),
        dataSend);

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      return throw DepartamentException(
          "Funcionalidades do departamento foram atualizadas !");
    }
  }

  Future<bool> criar(DepartamentoModel departament) async {
    Response response = await api.post(path, departament.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw DepartamentException(error);
    }
  }

  Future<bool> excluir(DepartamentoModel departament) async {
    Response response = await api.delete(
      path + '/' + departament.idDepartamento.toString(),
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw DepartamentException(error);
    }
  }

  Future<bool> update(DepartamentoModel departament) async {
    Response response = await api.put(
        '/departamentos/' + departament.idDepartamento.toString(),
        departament.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw DepartamentException("Departamento não foi atualizado!");
    }
  }
}
