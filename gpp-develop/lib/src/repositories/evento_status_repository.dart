import 'dart:convert';

import 'package:gpp/src/models/evento_status_model.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

import '../shared/repositories/status_code.dart';

class EventoStatusRepository {
  late ApiService api;

  EventoStatusRepository() {
    api = ApiService();
  }

  Future<List<EventoStatusModel>> buscarEventosPedidoSaida() async {
    Response response = await api.get(
      '/evento-status/pedido-saida',
    );

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<EventoStatusModel> eventosStatus = data
          .map<EventoStatusModel>((data) => EventoStatusModel.fromJson(data))
          .toList();

      return eventosStatus;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
