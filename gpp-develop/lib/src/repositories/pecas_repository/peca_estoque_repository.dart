import 'dart:convert';
import 'package:gpp/src/models/PaginaModel.dart';

import 'package:gpp/src/models/pecas_model/pecas_estoque_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class PecaEstoqueRepository {
  late ApiService api;

  PecaEstoqueRepository() {
    this.api = ApiService();
  }

  Future<PecasEstoqueModel> buscarEstoque(String id_peca, String? id_filial) async {
    Map<String, String> queryParameters = {
      'id_filial': id_filial != null ? id_filial.toString() : '',
    };

    Response response = await api.get('/pecas/$id_peca/peca-estoque', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return PecasEstoqueModel.fromJson(data[0]);
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  //Verificar se pode deletar depois
  Future<List> consultarEstoque(
      int paginaAtual,
      String filial,
      String id_peca,
      String id_produto,
      String id_fornecedor,
      bool? endereco,
      bool disponivel,
      bool reservado,
      bool transferencia,
      String desc_corredor,
      String desc_estante,
      String desc_prateleira,
      String desc_box) async {
    Map<String, String> queryParameters = {
      'page': paginaAtual.toString(),
      'id_filial': filial,
      'id_peca': id_peca,
      'id_produto': id_produto,
      'id_fornecedor': id_fornecedor,
      'enderecado': endereco.toString(),
      'disponivel': disponivel.toString(),
      'reservado': reservado.toString(),
      'transferencia': transferencia.toString(),
      'desc_corredor': desc_corredor,
      'desc_estante': desc_estante,
      'desc_prateleira': desc_prateleira,
      'desc_box': desc_box,
    };

    Response response = await api.get('/consulta-estoque', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return [
        data['data'].map<PecasEstoqueModel>((data) => PecasEstoqueModel.fromJson(data)).toList(),
        PaginaModel(total: data['last_page'], atual: data['current_page'])
      ];
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> alterarEstoque(PecasEstoqueModel pe) async {
    Response response = await api.put('/pecas/${pe.id_peca}/peca-estoque/${pe.id_peca_estoque}', pe.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List> buscarPecaEstoques(int pagina, {String? buscar, String? endereco}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'buscar': buscar ?? '',
      'endereco': endereco ?? '',
    };

    Response response = await api.get('/peca-estoques', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PecasEstoqueModel> produtos =
          data['dados'].map<PecasEstoqueModel>((data) => PecasEstoqueModel.fromJson(data)).toList();

      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [produtos, pagina];
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<PecasEstoqueModel> buscarPecaEstoque(int id) async {
    Response response = await api.get('/peca-estoques/${id}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return PecasEstoqueModel.fromJson(data);
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<List<PecasEstoqueModel>> buscarPecaEstoquesAsteca({String? idProduto}) async {
    Response response = await api.get('/peca-estoques/produto/${idProduto}/pecas');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PecasEstoqueModel> pecaEstoques = data.map<PecasEstoqueModel>((data) => PecasEstoqueModel.fromJson(data)).toList();

      return pecaEstoques;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> transferirEstoqueEndereco(int idPeca, int idPecaEstoque, PecasEstoqueModel pecaEstoque) async {
    Response response = await api.put('/pecas/${idPeca}/transferir-estoque/${idPecaEstoque}', pecaEstoque.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
