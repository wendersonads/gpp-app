import 'dart:convert';

import 'package:gpp/src/models/piso_enderecamento_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class PisoEnderecamentoRepository {
  late ApiService api;
  late String path;

  PisoEnderecamentoRepository() {
    api = ApiService();
    path = '/enderecamento-piso';
  }

  Future<List<PisoEnderecamentoModel>> buscarPisos() async {
    Response response = await api.get(path);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PisoEnderecamentoModel> enderecamentoPiso = data
          .map<PisoEnderecamentoModel>(
              (data) => PisoEnderecamentoModel.fromJson(data))
          .toList();

      return enderecamentoPiso;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }

  Future<bool> create(PisoEnderecamentoModel enderecamentoPiso) async {
    Response response = await api.post(path, enderecamentoPiso.toJson());

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

  Future<bool> excluir(PisoEnderecamentoModel enderecamentoPiso) async {
    Response response = await api.delete(
      path + '/' + enderecamentoPiso.id_piso.toString(),
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }
}
