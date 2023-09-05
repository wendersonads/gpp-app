import 'dart:convert';

import 'package:gpp/src/models/motivo_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class MotivoTrocaPecaRepository {
  late ApiService api;

  MotivoTrocaPecaRepository() {
    this.api = ApiService();
  }

  Future<List<MotivoModel>> buscarTodos() async {
    Response response = await api.get('/pecas/motivos');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<MotivoModel> motivosTrocaPeca =
          data.map<MotivoModel>((data) => MotivoModel.fromJson(data)).toList();

      return motivosTrocaPeca;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> create(MotivoModel motivoTrocaPeca) async {
    Response response =
        await api.post('/pecas/motivos', motivoTrocaPeca.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> update(MotivoModel motivoTrocaPeca) async {
    Response response = await api.put(
        '/pecas/motivos/${motivoTrocaPeca.idMotivo.toString()}',
        motivoTrocaPeca.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> excluir(MotivoModel motivoTrocaPeca) async {
    Response response = await api.delete(
      '/pecas/motivos/${motivoTrocaPeca.idMotivo.toString()}',
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
