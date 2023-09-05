import 'dart:convert';

import 'package:gpp/src/models/motivo_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class MotivoEstoqueRepository {
  late ApiService api;
  late String path;

  MotivoEstoqueRepository() {
    this.api = ApiService();
    this.path = '/estoque/motivos';
  }

  Future<List<MotivoModel>> buscarMotivosAjusteEstoque() async {
    Response response = await api.get(path);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<MotivoModel> motivosAjusteEstoque = data.map<MotivoModel>((data) => MotivoModel.fromJson(data)).toList();

      return motivosAjusteEstoque;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> create(MotivoModel motivoAjusteEstoque) async {
    Response response = await api.post(path, motivoAjusteEstoque.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> update(MotivoModel motivoAjusteEstoque) async {
    Response response = await api.put(path + '/' + motivoAjusteEstoque.idMotivo.toString(), motivoAjusteEstoque.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> excluir(MotivoModel motivoAjusteEstoque) async {
    Response response = await api.delete(
      path + '/' + motivoAjusteEstoque.idMotivo.toString(),
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
