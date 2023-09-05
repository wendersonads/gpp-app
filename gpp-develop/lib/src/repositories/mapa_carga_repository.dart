import 'dart:convert';

import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/item_mapa_carga_model.dart';
import 'package:gpp/src/models/pedido_saida_model.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

import '../models/mapa_carga_model.dart';
import '../shared/repositories/status_code.dart';

class MapaCargaRepository {
  late ApiService api;

  MapaCargaRepository() {
    api = ApiService();
  }

  Future<List> buscarMapasCarga(int pagina) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
    };

    Response response =
        await api.get('/mapa-carga', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<MapaCargaModel> mapasCarga = data['mapa_carga']
          .map<MapaCargaModel>((data) => MapaCargaModel.fromJson(data))
          .toList();

      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [mapasCarga, pagina];
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<MapaCargaModel> buscarMapaCarga(int idMapaCarga) async {
    Response response = await api.get('/mapa-carga/${idMapaCarga}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      MapaCargaModel mapaCargaModel = MapaCargaModel.fromJson(data);

      return mapaCargaModel;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  cancelarMapaCarga(MapaCargaModel mapaCarga) async {
    var data = {};
    data['id_motivo_cancelamento'] = mapaCarga.idMotivoCancelamento;

    Response response =
        await api.patch('/mapa-carga/${mapaCarga.idMapaCarga}/cancelar', data);

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> finalizarMapaCarga(int idMapaCarga, bool sucesso) async {
    Response response = await api.put(
        '/mapa-carga/${idMapaCarga}/finalizar?sucesso=${sucesso}', '');

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> inserirItemMapaCarga(
      int idMapaCarga, ItemMapaCargaModel itemMapaCarga) async {
    Response response = await api.put(
        '/mapa-carga/${idMapaCarga}/item-mapa-carga', itemMapaCarga.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> atualizarMapaCarga(MapaCargaModel mapaCarga) async {
    // print(jsonEncode(mapaCarga.toJson()));
    Response response = await api.put(
        '/mapa-carga/${mapaCarga.idMapaCarga}', mapaCarga.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> excluirItemMapaCarga(
      int idMapaCarga, int idItemMapaCarga) async {
    Response response = await api.delete(
        '/mapa-carga/${idMapaCarga}/item-mapa-carga/${idItemMapaCarga}');

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> criarMapaCarga(MapaCargaModel mapaCarga) async {
    // print(jsonEncode(mapaCarga.toJson()));
    Response response = await api.post('/mapa-carga', mapaCarga.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List<PedidoSaidaModel>> buscarMapaCargaPedidosSaida(
      {String? pesquisar,
      int? idPedido,
      int? idAsteca,
      String? nomeCliente}) async {
    Map<String, String> queryParameters = {
      'idPedidoSaida': idPedido != null ? idPedido.toString() : '',
      'idAsteca': idAsteca != null ? idAsteca.toString() : '',
      'nomeCliente': nomeCliente ?? '',
    };

    //print("QUERY ${queryParameters.toString()}");

    Response response = await api.get('/mapa-carga/pedidos-saida',
        queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PedidoSaidaModel> pedidosSaida = data
          .map<PedidoSaidaModel>((data) => PedidoSaidaModel.fromJson(data))
          .toList();

      return pedidosSaida;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
