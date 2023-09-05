import 'dart:convert';

import 'package:gpp/src/models/solicitacao_os/defeito_os_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class DefeitoOSRepository {
  late ApiService api;

  DefeitoOSRepository() {
    api = ApiService();
  }

  Future<List<DefeitoOSModel>> buscarDefeitos(
      {required String idProduto}) async {
    Response response = await api.get(
      '/solicitacao-os/defeito/$idProduto',
    );

    if (response.statusCode == StatusCode.OK) {
      var data = json.decode(response.body);

      List<DefeitoOSModel> defeitos = data
          .map<DefeitoOSModel>((defeito) => DefeitoOSModel.fromJson(defeito))
          .toList();

      return defeitos;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
