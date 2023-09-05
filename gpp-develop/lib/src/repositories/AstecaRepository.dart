import 'dart:convert';

import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/asteca/asteca_model.dart';
import 'package:gpp/src/models/asteca/asteca_tipo_pendencia_model.dart';
import 'package:gpp/src/models/cancelamentoModel.dart';

import 'package:http/http.dart';

import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';

class AstecaRepository {
  late ApiService api;

  AstecaRepository() {
    api = ApiService();
  }

  Future<List> buscarAstecas(int pagina,
      {String? buscar,
      String? cpfCnpj,
      String? astecaTipoPendenciaFiltro,
      AstecaModel? astecaFiltro,
      String? dataInicioFiltro,
      String? dataFimFiltro,
      bool? pedidosVinculado}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'buscar': buscar != null ? buscar : '',
      'cpfCnpj': cpfCnpj ?? '',
      'numeroNotaFiscalVenda': astecaFiltro?.documentoFiscal?.numDocFiscal?.toString() ?? '',
      'pendencia': astecaTipoPendenciaFiltro != null ? astecaTipoPendenciaFiltro : '',
      'dataInicio': dataInicioFiltro != null ? dataInicioFiltro.toString() : '',
      'dataFim': dataFimFiltro != null ? dataFimFiltro.toString() : '',
      'pedidosVinculado': pedidosVinculado != false ? pedidosVinculado.toString() : '',
    };

    Response response = await api.get('/astecas', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<AstecaModel> astecas = data['astecas'].map<AstecaModel>((data) => AstecaModel.fromJson(data)).toList();

      //Obtém a pagina
      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [astecas, pagina];
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List> buscarAstecasAtendimento(
    int pagina, {
    String? buscar,
    String? cpfCnpj,
    AstecaModel? astecaFiltro,
    String? dataInicioFiltro,
    String? dataFimFiltro,
  }) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'buscar': buscar != null ? buscar : '',
      'cpfCnpj': cpfCnpj ?? '',
      'numeroNotaFiscalVenda': astecaFiltro?.documentoFiscal?.numDocFiscal?.toString() ?? '',
      'dataInicio': dataInicioFiltro != null ? dataInicioFiltro.toString() : '',
      'dataFim': dataFimFiltro != null ? dataFimFiltro.toString() : '',
    };

    // print(dataInicioFiltro.toString());
    // print(dataFimFiltro.toString());
    //print(queryParameters);

    Response response = await api.get('/astecas/atendimento', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<AstecaModel> astecas = data['astecas'].map<AstecaModel>((data) => AstecaModel.fromJson(data)).toList();

      //Obtém a pagina
      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [astecas, pagina];
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<AstecaModel> buscarAsteca(int id) async {
    Response response = await api.get('/astecas/${id.toString()}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return AstecaModel.fromJson(data);
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<CancelamentoModel> cancelarPedidosAsteca(int idAsteca) async {
    Response response = await api.post('/astecas/${idAsteca}/cancelar-pedidos', '');
    CancelamentoModel retorno;
    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      retorno = CancelamentoModel(info: data['info'], retorno: true);
      //print(retorno.info);
      return retorno;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }
}

class AstecaTipoPendenciaRepository {
  late ApiService api;

  AstecaTipoPendenciaRepository() {
    api = ApiService();
  }

  Future<List<AstecaTipoPendenciaModel>> buscarAstecaTipoPendencias() async {
    Response response = await api.get('/asteca-tipo-pendencias');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<AstecaTipoPendenciaModel> astecaTipoPendencia =
          data.map<AstecaTipoPendenciaModel>((data) => AstecaTipoPendenciaModel.fromJson(data)).toList();
      return astecaTipoPendencia;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> inserirAstecaPendencia(int id, AstecaTipoPendenciaModel astecaTipoPendencia) async {
    Response response = await api.post('/astecas/${id}/pendencias', astecaTipoPendencia.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
