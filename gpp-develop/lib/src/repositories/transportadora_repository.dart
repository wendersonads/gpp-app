import 'dart:convert';

import 'package:gpp/src/models/caminhao_model.dart';
import 'package:gpp/src/models/motorista_model.dart';
import 'package:gpp/src/models/transportadora_model.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

import '../shared/repositories/status_code.dart';

class TransportadoraRepository {
  late ApiService api;

  TransportadoraRepository() {
    api = ApiService();
  }

  Future<List<TransportadoraModel>> buscarTransportadoras() async {
    Response response = await api.get('/transportadora');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<TransportadoraModel> transportadoras =
          data.map<TransportadoraModel>((value) => TransportadoraModel.fromJson(value)).toList();

      return transportadoras;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<TransportadoraModel> buscarTransportadora(int idTransportadora) async {
    Response response = await api.get('/transportadora/${idTransportadora}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      TransportadoraModel transportadora = TransportadoraModel.fromJson(data);

      return transportadora;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List<MotoristaModel>> buscarMotoristas(int idTransportadora) async {
    Response response = await api.get('/transportadora/${idTransportadora}/motorista');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<MotoristaModel> motoristas = data.map<MotoristaModel>((value) => MotoristaModel.fromJson(value)).toList();

      return motoristas;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List<CaminhaoModel>> buscarCaminhoes(int idTransportadora) async {
    Response response = await api.get('/transportadora/${idTransportadora}/caminhao');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<CaminhaoModel> caminhoes = data.map<CaminhaoModel>((value) => CaminhaoModel.fromJson(value)).toList();

      return caminhoes;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
