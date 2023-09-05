import 'dart:convert';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:http/http.dart';
import 'package:gpp/src/models/motivo_cancelamento_carga_model.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';

class MotivoCancelamentoCargaRepository {
  late ApiService api;

  MotivoCancelamentoCargaRepository() {
    api = ApiService();
  }

  Future<List<MotivoCancelamentoCargaModel>> buscarMotivosCancelamento() async {
    Response response = await api.get('/motivo-cancelamento-carga');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<MotivoCancelamentoCargaModel> motivosCancelamento = data
          .map<MotivoCancelamentoCargaModel>(
              (data) => MotivoCancelamentoCargaModel.fromJson(data))
          .toList();

      return motivosCancelamento;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }
}
