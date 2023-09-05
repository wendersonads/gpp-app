import 'dart:convert';

import 'package:gpp/src/models/prateleira_enderecamento_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class PrateleiraEnderecamentoRepository {
  late ApiService api;
  late String path;

  PrateleiraEnderecamentoRepository() {
    this.api = ApiService();
    this.path = '/enderecamento-prateleira';
  }

  Future<List<PrateleiraEnderecamentoModel>> buscarTodos() async {
    Response response = await api.get(path);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PrateleiraEnderecamentoModel> enderecamentoCorredor =
          data.map<PrateleiraEnderecamentoModel>((data) => PrateleiraEnderecamentoModel.fromJson(data)).toList();

      return enderecamentoCorredor;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }

  Future<bool> create(PrateleiraEnderecamentoModel enderecamentoPrateleira) async {
    Response response = await api.post(path, enderecamentoPrateleira.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  // Future<bool> update(PisoEnderecamentoModel enderecamentoPiso) async {
  //   Response response = await api.put(
  //       path + '/' + enderecamentoPiso.id_piso.toString(),
  //       enderecamentoPiso.toJson());

  //   if (response.statusCode == StatusCode.OK) {
  //     return true;
  //   } else {
  //     var error = json.decode(response.body)['error'];
  //     throw error;
  //   }
  // }

  Future<bool> excluir(PrateleiraEnderecamentoModel enderecamentoPrateleira) async {
    Response response = await api.delete(
      path + '/' + enderecamentoPrateleira.id_estante.toString(),
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }
}
