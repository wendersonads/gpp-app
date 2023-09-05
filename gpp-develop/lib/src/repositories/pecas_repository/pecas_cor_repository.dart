import 'dart:convert';

import 'package:gpp/src/models/pecas_model/pecas_cor_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class PecasCorRepository {
  late ApiService api;

  PecasCorRepository() {
    this.api = ApiService();
  }

  Future<bool> create(PecasCorModel pecasCorModel) async {
    Response response = await api.post('/peca-cor', pecasCorModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw 'Ocorreu um erro ao criar uma cor';
    }
  }

  Future<bool> editar(PecasCorModel pecasCorModel) async {
    Response response = await api.put('/peca-cor/${pecasCorModel.id_peca_cor}', pecasCorModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw 'Ocorreu um erro ao editar uma cor';
    }
  }

  Future<List<PecasCorModel>> buscarTodos() async {
    Response response = await api.get('/peca-cor');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PecasCorModel> pecasCor = data.map<PecasCorModel>((data) => PecasCorModel.fromJson(data)).toList();

      return pecasCor;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> excluir(PecasCorModel pecasCorModel) async {
    Response response = await api.delete('/peca-cor/' + pecasCorModel.id_peca_cor.toString());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }
}
