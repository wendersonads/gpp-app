import 'dart:convert';

import 'package:gpp/src/models/movimento_estoque/movimento_estoque_model.dart';
import 'package:gpp/src/models/movimento_estoque/tipo_movimento_estoque_model.dart';

import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class MovimentoEstoqueRepository {
  late ApiService api;

  MovimentoEstoqueRepository() {
    api = ApiService();
  }

  Future<List<MovimentoEstoqueModel>> buscarMovimentoEstoque({
    int? idTipoMovimento,
    int? idPedido,
    int? idPeca,
    String? reCliente,
    String? dataInicio,
    String? dataFim,
  }) async {
    Map<String, String> queryParameters = {
      'tipoMovimento': idTipoMovimento?.toString() ?? '',
      'dataInicio': dataInicio ?? '',
      'dataFim': dataFim ?? '',
      'idFuncionario': reCliente ?? '',
      'idPedido': idPedido?.toString() ?? '',
      'idPeca': idPeca?.toString() ?? ''
    };

    Response response = await api.get('/movimento-estoque', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<MovimentoEstoqueModel> movimentoEstoque =
          data.map<MovimentoEstoqueModel>((data) => MovimentoEstoqueModel.fromJson(data)).toList();

      return movimentoEstoque;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List<TipoMovimentoEstoqueModel>> buscarTiposMovimentoEstoque() async {
    Response response = await api.get('/tipo-movimento-estoque');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<TipoMovimentoEstoqueModel> tipoMovimento =
          data.map<TipoMovimentoEstoqueModel>((data) => TipoMovimentoEstoqueModel.fromJson(data)).toList();

      return tipoMovimento;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
