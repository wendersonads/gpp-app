import 'dart:convert';

import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/pecas_model/peca_enderecamento_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class PecaEnderecamentoRepository {
  late ApiService api;

  PecaEnderecamentoRepository() {
    this.api = ApiService();
  }

  Future<List> buscarTodos(
      int pagina_atual,
      int? id_filial,
      int? id_fornecedor,
      int? id_produto,
      int? id_peca,
      int? id_piso,
      int? id_corredor,
      int? id_estante,
      int? id_prateleira,
      int? id_box) async {
    Map<String, String> queryParameters = {
      'page': pagina_atual.toString(),
      'id_filial': id_filial != null ? id_filial.toString() : '',
      'id_fornecedor': id_fornecedor != null ? id_fornecedor.toString() : '',
      'id_produto': id_produto != null ? id_produto.toString() : '',
      'id_peca': id_peca != null ? id_peca.toString() : '',
      'id_piso': id_piso != null ? id_piso.toString() : '',
      'id_corredor': id_corredor != null ? id_corredor.toString() : '',
      'id_estante': id_estante != null ? id_estante.toString() : '',
      'id_prateleira': id_prateleira != null ? id_prateleira.toString() : '',
      'id_box': id_box != null ? id_box.toString() : '',
    };

    Response response =
        await api.get('/peca-enderecamento', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);
      List<PecaEnderacamentoModel> pecaEnderecamento = data['data']
          .map<PecaEnderacamentoModel>(
              (data) => PecaEnderacamentoModel.fromJson(data))
          .toList();

      return [
        pecaEnderecamento,
        PaginaModel(total: data['last_page'], atual: data['current_page'])
      ];
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> create(PecaEnderacamentoModel pe) async {
    Response response = await api.post('/peca-enderecamento', pe.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> editar(PecaEnderacamentoModel pe) async {
    Response response = await api.put(
        '/peca-enderecamento/${pe.id_peca_enderecamento}', pe.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> excluir(PecaEnderacamentoModel pe) async {
    Response response = await api
        .delete('/peca-enderecamento/' + pe.id_peca_enderecamento.toString());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
