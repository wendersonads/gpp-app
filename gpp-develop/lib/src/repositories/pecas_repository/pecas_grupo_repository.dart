import 'dart:convert';

import 'package:gpp/src/models/pecas_model/pecas_grupo_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class PecasGrupoRepository {
  late ApiService api;

  PecasGrupoRepository() {
    this.api = ApiService();
  }

  Future<List<PecasGrupoModel>> buscarTodos() async {
    Response response = await api.get('/peca-grupo-material');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PecasGrupoModel> pecasGrupo = data.map<PecasGrupoModel>((data) => PecasGrupoModel.fromJson(data)).toList();

      return pecasGrupo;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> create(PecasGrupoModel pecasGrupoModel) async {
    Response response = await api.post('/peca-grupo-material', pecasGrupoModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw 'Ocorreu um erro ao inserir um grupo';
    }
  }

  Future<bool> excluir(PecasGrupoModel pecasGrupoModel) async {
    Response response = await api.delete('/peca-grupo-material/' + pecasGrupoModel.id_peca_grupo_material.toString());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }

  Future<bool> editar(PecasGrupoModel pecasGrupoModel) async {
    Response response = await api.put('/peca-grupo-material/${pecasGrupoModel.id_peca_grupo_material}', pecasGrupoModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw 'Ocorreu um erro ao editar um grupo';
    }
  }
}
