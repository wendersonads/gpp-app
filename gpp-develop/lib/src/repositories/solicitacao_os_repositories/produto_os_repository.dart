import 'dart:convert';

import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/solicitacao_os/produto_os_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class ProdutoOSRepository {
  late ApiService api;

  ProdutoOSRepository() {
    api = ApiService();
  }

  Future<List> buscarProdutos(
      {required int pagina,
      required int filial,
      required int? ld,
      String? buscar}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'filial': filial.toString(),
      'ld': ld != null ? ld.toString() : '',
      'buscar': buscar ?? '',
    };

    Response response = await api.get('/solicitacao-os/produtos',
        queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = json.decode(response.body);

      List<ProdutoOSModel> produtos = data['produto']
          .map<ProdutoOSModel>((produto) => ProdutoOSModel.fromJson(produto))
          .toList();
      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);

      return [produtos, pagina];
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
