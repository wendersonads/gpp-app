import 'dart:convert';

import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/produto/fornecedor_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class FornecedorRepository {
  late ApiService api;

  FornecedorRepository() {
    this.api = ApiService();
  }

  Future<List> buscarFornecedores(int pagina, {String? pesquisar}) async {
    Map<String, String> queryParameters = {'pagina': pagina.toString(), 'pesquisar': pesquisar != null ? pesquisar : ''};

    Response response = await api.get('/fornecedor', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<FornecedorModel> pedidosEntrada =
          data['fornecedores'].map<FornecedorModel>((data) => FornecedorModel.fromJson(data)).toList();

      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [pedidosEntrada, pagina];
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<FornecedorModel> buscarFornecedor(int idFornecedor) async {
    Response response = await api.get('/fornecedor/${idFornecedor}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return FornecedorModel.fromJson(data);
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> inserirFornecedorEmail(int idFornecedor, FornecedorModel fornecedor) async {
    Response response = await api.post('/fornecedor/${idFornecedor}/fornecedor-email', fornecedor.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }
}
