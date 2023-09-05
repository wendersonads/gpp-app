import 'dart:convert';

import 'package:gpp/src/models/PaginaModel.dart';
import 'package:http/http.dart';

import '../models/CapacidadeEstoqueModel.dart';
import '../shared/services/gpp_api.dart';

class CapacidadeEstoqueRepository {
  late ApiService api;

  CapacidadeEstoqueRepository() {
    api = ApiService();
  }

  Future<List> consultaCapacidade(int pagina, {String? pesquisar}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'pesquisar': pesquisar ?? '',
    };

    Response response =
        await api.get('/consultabox', queryParameters: queryParameters);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<CapacidadeEstoqueModel> capacidadeEstoqueModel = data['dados']
          .map<CapacidadeEstoqueModel>(
              (data) => CapacidadeEstoqueModel.fromJson(data))
          .toList();

      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);

      return [capacidadeEstoqueModel, pagina];
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }
}
