import 'dart:convert';

import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/pedido_entrada_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class PedidoEntradaRepository {
  late ApiService api;

  PedidoEntradaRepository() {
    api = ApiService();
  }

  Future<List> buscarPedidosEntrada(int pagina,
      {String? idFornecedor, int? idPedido, String? dataInicio, String? dataFim, int? situacao}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'idFornecedor': idFornecedor != null ? idFornecedor.toString() : '',
      'idPedido': idPedido != null ? idPedido.toString() : '',
      'dataInicio': dataInicio != null ? dataInicio.toString() : '',
      'dataFim': dataFim != null ? dataFim.toString() : '',
      'situacao': situacao != null ? situacao.toString() : ''
    };

    Response response = await api.get('/pedidos-entrada', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PedidoEntradaModel> pedidosEntrada =
          data['pedidos'].map<PedidoEntradaModel>((data) => PedidoEntradaModel.fromJson(data)).toList();

      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [pedidosEntrada, pagina];
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<List<PedidoEntradaModel>> buscarEntradaPedido({
    int? idPedido,
    int? idFornecedor,
    String? nomeFornecedor,
  }) async {
    Map<String, String> queryParameters = {
      'idPedido': idPedido != null ? idPedido.toString() : '',
      'idFornecedor': idFornecedor != null ? idFornecedor.toString() : '',
      'nomeFornecedor': nomeFornecedor != null ? nomeFornecedor.toString() : '',
    };

    Response response = await api.get('/entrada-pedido', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PedidoEntradaModel> pedidosEntrada =
          data.map<PedidoEntradaModel>((data) => PedidoEntradaModel.fromJson(data)).toList();

      //PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return pedidosEntrada;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<PedidoEntradaModel> buscarPedidoEntrada(int id) async {
    Response response = await api.get('/pedidos-entrada/${id.toString()}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      PedidoEntradaModel pedidoEntrada = PedidoEntradaModel.fromJson(data);
      return pedidoEntrada;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<PedidoEntradaModel> criar(PedidoEntradaModel pedidoEntrada) async {
    Response response = await api.post('/pedidos-entrada', pedidoEntrada.toJson());

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      PedidoEntradaModel pedidoEntrada = PedidoEntradaModel.fromJson(data);

      return pedidoEntrada;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  /***
   * Função responsável por enviar email ao fornecedor do pedido de entrada
   */
  Future<bool> enviarEmailFornecedor(int idPedidoEntrada, PedidoEntradaModel pedidoEntradaModel) async {
    Response response =
        await api.post('/pedidos-entrada/${idPedidoEntrada.toString()}/email-fornecedor', pedidoEntradaModel.toJson());
    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<List<PedidoEntradaModel>> buscarRelEntradasPorFornecedor({
    String? idFornecedor,
    String? dataInicioFiltro,
    String? dataFimFiltro,
  }) async {
    Map<String, String> queryParameters = {
      'dataInicio': dataInicioFiltro != null ? dataInicioFiltro.toString() : '',
      'dataFim': dataFimFiltro != null ? dataFimFiltro.toString() : '',
    };

    Response response = await api.get('/pedidos-entrada/${idFornecedor}/relatorio', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PedidoEntradaModel> pedidosEntrada =
          data.map<PedidoEntradaModel>((data) => PedidoEntradaModel.fromJson(data)).toList();

      return pedidosEntrada;
    } else {
      var error = jsonDecode(response.body)['message'];
      throw error;
    }
  }

  Future<List<PedidoEntradaModel>> buscarRelEntradasPorFornecedor2({
    String? idFornecedor,
    String? dataInicioFiltro,
    String? dataFimFiltro,
  }) async {
    Map<String, String> queryParameters = {
      'dataInicio': dataInicioFiltro != null ? dataInicioFiltro.toString() : '',
      'dataFim': dataFimFiltro != null ? dataFimFiltro.toString() : '',
    };

    Response response = await api.get('/pedidos-entrada/${idFornecedor}/relatorio', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PedidoEntradaModel> pedidosEntrada =
          data.map<PedidoEntradaModel>((data) => PedidoEntradaModel.fromJson(data)).toList();

      //PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return pedidosEntrada;

      // PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      // return [pedidosEntrada, pagina];
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }
}
