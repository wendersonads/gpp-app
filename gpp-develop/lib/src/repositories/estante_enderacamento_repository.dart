import 'dart:convert';

import 'package:gpp/src/models/estante_enderecamento_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class EstanteEnderecamentoRepository {
  late ApiService api;
  late String path;

  EstanteEnderecamentoRepository() {
    this.api = ApiService();
    this.path = '/enderecamento-estante';
  }

  Future<List<EstanteEnderecamentoModel>> buscarTodos() async {
    Response response = await api.get(path);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<EstanteEnderecamentoModel> enderecamentoCorredor =
          data.map<EstanteEnderecamentoModel>((data) => EstanteEnderecamentoModel.fromJson(data)).toList();

      return enderecamentoCorredor;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }

  Future<bool> create(EstanteEnderecamentoModel enderecamentoEstante) async {
    Response response = await api.post(path, enderecamentoEstante.toJson());

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

  Future<bool> excluir(EstanteEnderecamentoModel enderecamentoEstante) async {
    Response response = await api.delete(
      path + '/' + enderecamentoEstante.id_estante.toString(),
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }
}
