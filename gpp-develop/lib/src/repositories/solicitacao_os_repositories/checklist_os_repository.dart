import 'dart:convert';

import 'package:gpp/src/models/solicitacao_os/checklist_os_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class ChecklistOSRepository {
  late ApiService api;

  ChecklistOSRepository() {
    api = ApiService();
  }

  Future<List<ChecklistOSModel>> buscarChecklists(
      {required String idProduto}) async {
    Response response = await api.get(
      '/solicitacao-os/checklist/$idProduto',
    );

    if (response.statusCode == StatusCode.OK) {
      var data = json.decode(response.body);

      List<ChecklistOSModel> checklists = data
          .map<ChecklistOSModel>(
              (checklist) => ChecklistOSModel.fromJson(checklist))
          .toList();

      return checklists;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
