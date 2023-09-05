import 'dart:convert';

import 'package:gpp/src/models/perfil_usuario_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class PerfilUsuarioRepository {
  late ApiService api;

  PerfilUsuarioRepository() {
    api = ApiService();
  }

  Future<List<PerfilUsuarioModel>> buscarPerfisUsuarios() async {
    Response response = await api.get('/perfil-usuario');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PerfilUsuarioModel> perfilUsuarios = data
          .map<PerfilUsuarioModel>((data) => PerfilUsuarioModel.fromJson(data))
          .toList();
      return perfilUsuarios;
    } else {
      var error = json.decode(response.body)['error'];

      throw error;
    }
  }

  Future<PerfilUsuarioModel> buscarPerfilUsuario(int idPerfilUsuario) async {
    Response response = await api.get('/perfil-usuario/${idPerfilUsuario}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      PerfilUsuarioModel perfilUsuario = PerfilUsuarioModel.fromJson(data);

      return perfilUsuario;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> vincularPerfilUsuarioFuncionalidade(
      int idPerfilUsuario, int idFuncionalidade) async {
    Response response = await api.post(
        '/perfil-usuario/${idPerfilUsuario}/funcionalidade/${idFuncionalidade}',
        '');

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> removerPerfilUsuarioFuncionalidade(
      int idPerfilUsuario, int idFuncionalidade) async {
    Response response = await api.delete(
      '/perfil-usuario/${idPerfilUsuario}/funcionalidade/${idFuncionalidade}',
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> criarPerfilUsuario(PerfilUsuarioModel perfilUsuario) async {
    Response response =
        await api.post('/perfil-usuario', perfilUsuario.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> deletarPerfilUsuario(int idPerfilUsuario) async {
    Response response = await api.delete(
      '/perfil-usuario/${idPerfilUsuario}',
    );

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
