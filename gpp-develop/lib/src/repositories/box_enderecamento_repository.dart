import 'dart:convert';

import 'package:gpp/src/models/box_enderecamento_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class BoxEnderecamentoRepository {
  late ApiService api;
  late String path;

  BoxEnderecamentoRepository() {
    this.api = ApiService();
    this.path = '/enderecamento-box';
  }

  Future<List<BoxEnderecamentoModel>> buscarTodos() async {
    Response response = await api.get(path);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<BoxEnderecamentoModel> enderecamentoBox =
          data.map<BoxEnderecamentoModel>((data) => BoxEnderecamentoModel.fromJson(data)).toList();

      return enderecamentoBox;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }

  Future<bool> create(BoxEnderecamentoModel enderecamentoBox) async {
    Response response = await api.post(path, enderecamentoBox.toJson());

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

  Future<bool> excluir(BoxEnderecamentoModel enderecamentoBox) async {
    Response response = await api.delete(
      path + '/' + enderecamentoBox.id_box.toString(),
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw Exception(error);
    }
  }
}
