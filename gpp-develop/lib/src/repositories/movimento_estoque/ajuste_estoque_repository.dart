import 'dart:convert';

import 'package:gpp/src/models/movimento_estoque/ajuste_estoque_model.dart';
import 'package:gpp/src/models/pecas_model/pecas_estoque_model.dart';

import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class AjusteEstoqueRepository {
  late ApiService api;

  AjusteEstoqueRepository() {
    api = ApiService();
  }

  Future<List<AjusteEstoqueModel>> buscarAjustesEstoques({
    int? idMotivo,
    int? idPeca,
    String? reCliente,
    String? dataInicio,
    String? dataFim,
  }) async {
    Map<String, String> queryParameters = {
      'idMotivo': idMotivo?.toString() ?? '',
      'dataInicio': dataInicio ?? '',
      'dataFim': dataFim ?? '',
      'idFuncionario': reCliente ?? '',
      'idPeca': idPeca?.toString() ?? ''
    };

    Response response = await api.get('/ajuste-peca-estoque', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<AjusteEstoqueModel> movimentoEstoque =
          data.map<AjusteEstoqueModel>((data) => AjusteEstoqueModel.fromJson(data)).toList();

      return movimentoEstoque;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> AdicionarSaldoPecaEstoque(int idPecaEstoque, AjusteEstoqueModel ajusteEstoque) async {
    Response response = await api.put('/ajuste-peca-estoque/${idPecaEstoque}/adicionar', ajusteEstoque.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> SubtrairSaldoPecaEstoque(int idPecaEstoque, AjusteEstoqueModel ajusteEstoque) async {
    Response response = await api.put('/ajuste-peca-estoque/${idPecaEstoque}/subtrair', ajusteEstoque.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> removerEnderecamento(PecasEstoqueModel pecaEstoque) async {
    Response response =
        await api.put('/ajuste-peca-estoque/${pecaEstoque.id_peca_estoque}/remove-endereco', pecaEstoque.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
