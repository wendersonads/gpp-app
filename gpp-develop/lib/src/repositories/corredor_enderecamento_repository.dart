import 'dart:convert';

import 'package:gpp/src/models/corredor_enderecamento_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class CorredorEnderecamentoRepository {
  late ApiService api;
  late String path;

  CorredorEnderecamentoRepository() {
    this.api = ApiService();
    this.path = '/enderecamento-corredor';
  }

  Future<List<CorredorEnderecamentoModel>> buscarTodos() async {
    Response response = await api.get(path);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<CorredorEnderecamentoModel> enderecamentoCorredor =
          data.map<CorredorEnderecamentoModel>((data) => CorredorEnderecamentoModel.fromJson(data)).toList();

      return enderecamentoCorredor;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }

  Future<bool> create(CorredorEnderecamentoModel enderecamentoCorredor) async {
    Response response = await api.post(path, enderecamentoCorredor.toJson());

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

  Future<bool> excluir(CorredorEnderecamentoModel enderecamentoCorredor) async {
    Response response = await api.delete(
      path + '/' + enderecamentoCorredor.id_corredor.toString(),
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }
}
