import 'dart:convert';

import 'package:gpp/src/models/pecas_model/pecas_especie_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class PecasEspecieRepository {
  late ApiService api;

  PecasEspecieRepository() {
    this.api = ApiService();
  }

  Future<bool> create(PecasEspecieModel pecasEspecieModel) async {
    Response response = await api.post('/peca-especie', pecasEspecieModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw 'Ocorreu um erro ao tentar inserir uma espécie';
    }
  }

  Future<List<PecasEspecieModel>> buscarTodos() async {
    Response response = await api.get('/peca-especie');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PecasEspecieModel> pecasEspecie = data.map<PecasEspecieModel>((data) => PecasEspecieModel.fromJson(data)).toList();

      return pecasEspecie;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> excluir(PecasEspecieModel pecasEspecieModel) async {
    Response response = await api.delete('/peca-especie/' + pecasEspecieModel.id_peca_especie.toString());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }

  Future<bool> editar(PecasEspecieModel pecasEspecieModel) async {
    Response response = await api.put('/peca-especie/${pecasEspecieModel.id_peca_especie}', pecasEspecieModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw 'Ocorreu um erro ao editar uma espécie';
    }
  }
}
