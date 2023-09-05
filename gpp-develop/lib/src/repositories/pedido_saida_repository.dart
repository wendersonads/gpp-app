import 'dart:convert';

import 'package:gpp/src/models/evento_status_model.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/pedido_saida_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class PedidoSaidaRepository {
  late ApiService api;

  PedidoSaidaRepository() {
    api = ApiService();
  }

  Future<List> buscarTodosPedidosSaida(int pagina,
      {String? pesquisar, DateTime? dataInicio, DateTime? dataFim, EventoStatusModel? eventoStatus}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'pesquisar': pesquisar != null ? pesquisar.toString() : '',
      'dataInicio': dataInicio != null ? dataInicio.toString() : '',
      'dataFim': dataFim != null ? dataFim.toString() : '',
      'evento': eventoStatus != null ? eventoStatus.id_evento_status?.toString() ?? '' : ''
    };

    Response response = await api.get('/pedidos-saida', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PedidoSaidaModel> pedidos = data['pedidos'].map<PedidoSaidaModel>((data) => PedidoSaidaModel.fromJson(data)).toList();
      //Obtém a pagina
      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [pedidos, pagina];
    } else {
      var error = json.decode(response.body)['error'];

      throw error;
    }
  }

  Future<List> buscarPedidosSaidaEmAberto(int pagina,
      {String? pesquisar, DateTime? dataInicio, DateTime? dataFim, EventoStatusModel? eventoStatus}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'pesquisar': pesquisar != null ? pesquisar.toString() : '',
      'dataInicio': dataInicio != null ? dataInicio.toString() : '',
      'dataFim': dataFim != null ? dataFim.toString() : '',
      'evento': eventoStatus != null ? eventoStatus.id_evento_status?.toString() ?? '' : ''
    };

    Response response = await api.get('/pedidos-saida/em-aberto', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PedidoSaidaModel> pedidos = data['pedidos'].map<PedidoSaidaModel>((data) => PedidoSaidaModel.fromJson(data)).toList();
      //Obtém a pagina
      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [pedidos, pagina];
    } else {
      var error = json.decode(response.body)['error'];

      throw error;
    }
  }

  Future<List> buscarPedidosSaidaEmAtendimento(int pagina,
      {String? pesquisar, DateTime? dataInicio, DateTime? dataFim, EventoStatusModel? eventoStatus}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'pesquisar': pesquisar != null ? pesquisar.toString() : '',
      'dataInicio': dataInicio != null ? dataInicio.toString() : '',
      'dataFim': dataFim != null ? dataFim.toString() : '',
      'evento': eventoStatus != null ? eventoStatus.id_evento_status?.toString() ?? '' : ''
    };

    Response response = await api.get('/pedidos-saida/em-atendimento', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PedidoSaidaModel> pedidos = data['pedidos'].map<PedidoSaidaModel>((data) => PedidoSaidaModel.fromJson(data)).toList();
      //Obtém a pagina
      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [pedidos, pagina];
    } else {
      var error = json.decode(response.body)['error'];

      throw error;
    }
  }

  Future<List> buscarPedidosSaidaCriadoPorMim(int pagina,
      {String? pesquisar, DateTime? dataInicio, DateTime? dataFim, EventoStatusModel? eventoStatus}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'pesquisar': pesquisar != null ? pesquisar.toString() : '',
      'dataInicio': dataInicio != null ? dataInicio.toString() : '',
      'dataFim': dataFim != null ? dataFim.toString() : '',
      'evento': eventoStatus != null ? eventoStatus.id_evento_status?.toString() ?? '' : ''
    };

    Response response = await api.get('/pedidos-saida/criado-por-mim', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PedidoSaidaModel> pedidos = data['pedidos'].map<PedidoSaidaModel>((data) => PedidoSaidaModel.fromJson(data)).toList();
      //Obtém a pagina
      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [pedidos, pagina];
    } else {
      var error = json.decode(response.body)['error'];

      throw error;
    }
  }

  Future<List> buscarPedidosSaidaSeparacao(int pagina,
      {int? idPedido, DateTime? dataInicio, DateTime? dataFim, int? situacao}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'pesquisar': idPedido != null ? idPedido.toString() : '',
      'dataInicio': dataInicio != null ? dataInicio.toString() : '',
      'dataFim': dataFim != null ? dataFim.toString() : '',
      'situacao': situacao != null ? situacao.toString() : ''
    };

    Response response = await api.get('/pedidos-saida/separacao', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PedidoSaidaModel> pedidos = data['pedidos'].map<PedidoSaidaModel>((data) => PedidoSaidaModel.fromJson(data)).toList();
      //Obtém a pagina
      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [pedidos, pagina];
    } else {
      var error = json.decode(response.body)['error'];

      throw error;
    }
  }

  Future<List> buscarPedidosSaidaAguardandoFornecedor(int pagina,
      {int? idPedido, DateTime? dataInicio, DateTime? dataFim, int? situacao}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'idPedido': idPedido != null ? idPedido.toString() : '',
      'dataInicio': dataInicio != null ? dataInicio.toString() : '',
      'dataFim': dataFim != null ? dataFim.toString() : '',
      'situacao': situacao != null ? situacao.toString() : ''
    };

    Response response = await api.get('/pedidos-saida/aguardando-fornecedor', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PedidoSaidaModel> pedidos = data['pedidos'].map<PedidoSaidaModel>((data) => PedidoSaidaModel.fromJson(data)).toList();
      //Obtém a pagina
      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [pedidos, pagina];
    } else {
      var error = json.decode(response.body)['error'];

      throw error;
    }
  }

  Future<bool> encaminharSeparacao(int idPedidoSaida) async {
    Response response = await api.post('/pedidos-saida/${idPedidoSaida}/encaminhar-separacao', '');

    if (response.statusCode == StatusCode.OK) {
      // var data = jsonDecode(response.body);

      return true;
    } else {
      var error = json.decode(response.body)['error'];

      throw error;
    }
  }

  Future<PedidoSaidaModel> buscarPedidoSaida(int id) async {
    Response response = await api.get('/pedidos-saida/${id.toString()}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      PedidoSaidaModel pedido = PedidoSaidaModel.fromJson(data);

      return pedido;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<PedidoSaidaModel> buscarPedidoSaidaSeparacao(int id) async {
    Response response = await api.get('/pedidos-saida/${id.toString()}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      PedidoSaidaModel pedido = PedidoSaidaModel.fromJson(data);
      return pedido;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<PedidoSaidaModel> criar(PedidoSaidaModel pedidoSaida) async {
    Response response = await api.post('/pedidos-saida', pedidoSaida.toJson());

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);
      PedidoSaidaModel pedido = PedidoSaidaModel.fromJson(data);

      return pedido;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  /***
   * Função responsável por enviar email ao fornecedor do pedido de saída
   */
  Future<bool> enviarEmailFornecedor(int idPedidoSaida, PedidoSaidaModel pedidoSaidaModel) async {
    Response response = await api.post('/pedidos-saida/${idPedidoSaida.toString()}/email-fornecedor', pedidoSaidaModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];

      throw error;
    }
  }

  Future<bool> separarItemPedidoSaidaPeca(int idPedidoSaida, int idItemPedidoSaida, int idPeca) async {
    Response response =
        await api.put('/pedidos-saida/${idPedidoSaida}/item-pedido-saida/${idItemPedidoSaida}/peca/${idPeca}', '');

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];

      throw error;
    }
  }

  Future<bool> cancelarItemPedidoSaidaPeca(int idPedidoSaida, int idItemPedidoSaida, int idPeca) async {
    Response response = await api.delete(
      '/pedidos-saida/${idPedidoSaida}/item-pedido-saida/${idItemPedidoSaida}/peca/${idPeca}',
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];

      throw error;
    }
  }

  Future<bool> separarPeca(int idPedidoSaida, int idPeca) async {
    Response response = await api.put('/pedidos-saida/${idPedidoSaida}/peca/${idPeca}', '');

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];

      throw error;
    }
  }

  Future<bool> iniciarSeparacao(
    int idPedidoSaida,
  ) async {
    Response response = await api.post('/pedidos-saida/${idPedidoSaida}/iniciar-separacao', '');

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];

      throw error;
    }
  }

  Future<bool> finalizarSeparacao(
    int idPedidoSaida,
  ) async {
    Response response = await api.post('/pedidos-saida/${idPedidoSaida}/finalizar-separacao', '');

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];

      throw error;
    }
  }
}
