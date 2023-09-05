import 'dart:convert';

import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/avaria/avaria_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';
import 'dart:developer';

class AvariaRepository {
  late ApiService api;

  AvariaRepository() {
    api = ApiService();
  }

  Future<List<AvariaModel>> buscarAvarias(
      {int? id_filial,
      int? id_avaria,
      int? id_solicitador,
      int? situacao}) async {
    Map<String, String> queryParams = {
      "id_filial": id_filial != null ? id_filial.toString() : '',
      "id_avaria": id_avaria != null ? id_avaria.toString() : '',
      "id_solicitdor": id_solicitador != null ? id_solicitador.toString() : '',
      "situacao": situacao != null ? situacao.toString() : '',
    };

    Response response =
        await api.get('/avaria/consulta-avaria', queryParameters: queryParams);

    if (response.statusCode != StatusCode.OK) {
      var error = json.decode(response.body)['error'];
      throw error;
    }

    if (response.body == '') {
      var error = json.decode(response.body)['error'];
      throw error;
    }

    var data = json.decode(response.body);
    List<AvariaModel> avarias = data
        .map<AvariaModel>((avaria) => AvariaModel.fromJson(avaria))
        .toList();

    return avarias;
  }

//Função responsavel por enviar os dados do produto avariado para API
  Future<bool> criarProdutoAvaria(AvariaModel ProdutoAvaria) async {
    Response response = await api.post('/avaria/criar', ProdutoAvaria.toJson());

    if (response.statusCode == StatusCode.CREATED) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
