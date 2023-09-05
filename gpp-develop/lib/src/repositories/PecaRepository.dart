import 'dart:convert';

import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/box_enderecamento_model.dart';

import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/models/produto_peca_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class PecaRepository {
  late ApiService api;

  PecaRepository() {
    api = ApiService();
  }

  Future<List> buscarPecas(int pagina,
      {String? buscar, String? idProduto, int? idPedido, DateTime? dataInicio, DateTime? dataFim, int? situacao}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'buscar': buscar != null ? buscar : '',
      'idProduto': idProduto != null ? idProduto : '',
      'idPedido': idPedido != null ? idPedido.toString() : '',
      'dataInicio': dataInicio != null ? dataInicio.toString() : '',
      'dataFim': dataFim != null ? dataFim.toString() : '',
      'situacao': situacao != null ? situacao.toString() : ''
    };

    Response response = await api.get('/pecas', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PecasModel> pedidos = data['pecas'].map<PecasModel>((data) => PecasModel.fromJson(data)).toList();
      //Obtém a pagina
      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [pedidos, pagina];
    } else {
      var error = json.decode(response.body)['error'];

      throw error;
    }
  }

  Future<PecasModel> buscarPeca(int idPeca) async {
    Response response = await api.get('/pecas/${idPeca}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      PecasModel pecas = PecasModel.fromJson(data);

      return pecas;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<PecasModel> buscarPecaFornecedor(int idPeca, int idFornecedor) async {
    Response response = await api.get('/pecas/${idPeca}/fornecedor/${idFornecedor}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      PecasModel pecas = PecasModel.fromJson(data);

      return pecas;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> excluir(PecasModel pecasModel) async {
    Response response = await api.delete('/pecas/' + pecasModel.id_peca.toString());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<PecasModel> criarPeca(PecasModel pecas) async {
    //print(jsonEncode(pecas.toJson()));
    Response response = await api.post('/pecas', pecas.toJson());

    var data = jsonDecode(response.body);

    if (response.statusCode == StatusCode.OK) {
      PecasModel pecas = PecasModel.fromJson(data);

      return pecas;
    } else {
      throw 'Ocorreu um erro ao criar uma peça';
    }
  }

  Future<bool> criarProdutoPeca(ProdutoPecaModel produtoPecaModel) async {
    //print(jsonEncode(produtoPecaModel.toJson()));

    Response response = await api.post('/pecas/00/produto-peca', produtoPecaModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw 'Ocorreu um erro ao criar um produto peça';
    }
  }

  Future<bool> editar(PecasModel pecasModel) async {
    //print(jsonEncode(pecasModel.toJson()));

    Response response = await api.put('/pecas/${pecasModel.id_peca}', pecasModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw 'Ocorreu um erro ao editar uma peça';
    }
  }

  Future<bool> editarProdutoPeca(ProdutoPecaModel produtoPecaModel) async {
    //print(jsonEncode(produtoPecaModel.toJson()));

    Response response = await api.put(
        '/pecas/${produtoPecaModel.idProdutoPeca}/produto-peca/${produtoPecaModel.idProdutoPeca}', produtoPecaModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      throw 'Ocorreu um erro ao editar um produto peça';
    }
  }

  Future<bool> alterarEndereco(int idPeca, int idPecaEstoque, BoxEnderecamentoModel box) async {
    Response response = await api.put('/pecas/${idPeca}/peca-estoque/${idPecaEstoque}', box.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
