import 'dart:convert';

import 'package:gpp/src/models/filial/empresa_filial_model.dart';
import 'package:gpp/src/models/user_model.dart';

import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class FilialRepository {
  late ApiService api;

  FilialRepository() {
    this.api = ApiService();
  }

  Future<bool> mudarFilialSelecionada(UsuarioModel usuario) async {
    Response response =
        await api.post('/menu-filiais/filialSelecionada', usuario.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<List<EmpresaFilialModel>> buscarTodos() async {
    Response response = await api.get('/menu-filiais');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<EmpresaFilialModel> filiais = data
          .map<EmpresaFilialModel>((data) => EmpresaFilialModel.fromJson(data))
          .toList();

      return filiais;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List<dynamic>> buscarFiliaisAsteca() async {
    Response response = await api.get('/filiais/filiais-asteca');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List<dynamic>> buscarFiliaisLoja() async {
    Response response = await api.get('/filiais/filiais-loja');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
