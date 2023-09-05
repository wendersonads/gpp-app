import 'dart:convert';
import 'dart:developer';
import 'package:gpp/src/models/inventario/inventario_local_model.dart';
import 'package:gpp/src/models/inventario/inventario_local_result_model.dart';
import 'package:gpp/src/models/inventario/inventario_model.dart';
import 'package:gpp/src/repositories/inventario/inventario_local_repository.dart';

import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

import '../../models/inventario/inventario_peca_model.dart';

class InventarioRepository {
  late ApiService api;
  late InventarioLocalRepository inventarioLocalRepository;

  InventarioRepository() {
    api = ApiService();
    inventarioLocalRepository = InventarioLocalRepository();
  }

  Future<List<InventarioModel>> buscarInventarios(int? situacao) async {
    Map<String, String> queryParameters = {
      'situacao': situacao?.toString() ?? '',
    };

    Response response = await api.get('/inventario', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<InventarioModel> inventarios = data.map<InventarioModel>((data) => InventarioModel.fromJson(data)).toList();

      return inventarios;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<InventarioModel> buscarInventario(int idInventario) async {
    Response response = await api.get('/inventario/${idInventario}');
    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);
      InventarioModel inventario = InventarioModel.fromJson(data);
      return inventario;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<InventarioModel> criarInventario(InventarioModel inventario) async {
    Response response = await api.post('/inventario', inventario.toJson());

    var data = jsonDecode(response.body);

    if (response.statusCode == StatusCode.OK) {
      InventarioModel inventario = InventarioModel.fromJson(data);

      try {
        inventarioLocalRepository.populate(
          inventarioLocalModel: InventarioLocalModel.fromInventarioModel(inventarioModel: inventario),
          idInventario: inventario.id_inventario ?? 0,
        );
      } catch (e) {
        log(e.toString());
        throw e;
      }

      return inventario;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<InventarioModel> biparPeca(int idInventario, InventarioPecaModel inventarioPeca) async {
    Response response = await api.post('/inventario/${idInventario}/bipagem', inventarioPeca.toJson());

    var data = jsonDecode(response.body);
    if (response.statusCode == StatusCode.OK) {
      InventarioModel inventario = InventarioModel.fromJson(data);

      return inventario;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> cancelarInventario(
    int idInventario,
  ) async {
    Response response = await api.post('/inventario/${idInventario}/cancelar', '');

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> finalizarInventario({required int idInventario, required InventarioLocalResultModel inventario}) async {
    Response response = await api.put('/inventario/${idInventario}/salvar', inventario.toJson());

    if (response.statusCode == StatusCode.OK) {
      try {
        inventarioLocalRepository.finishInventario(idInventario: idInventario);
      } catch (e) {
        log(e.toString());
        throw e;
      }

      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
