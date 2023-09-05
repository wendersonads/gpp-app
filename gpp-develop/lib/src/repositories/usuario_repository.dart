import 'dart:convert';

import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/filial/empresa_filial_model.dart';
import 'package:gpp/src/models/perfil_usuario_model.dart';
import 'package:gpp/src/models/subfuncionalidade.dart';
import 'package:http/http.dart';

import 'package:gpp/src/models/FuncionalidadeModel.dart';
import 'package:gpp/src/models/user_model.dart';
import 'package:gpp/src/shared/exceptions/user_exception.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';

class UsuarioRepository {
  late ApiService api;

  UsuarioRepository() {
    api = ApiService();
  }
  String path = '/usuarios';

  Future<UsuarioModel> buscarUsuario(int idUsuario) async {
    Response response = await api.get('/usuarios/${idUsuario}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return UsuarioModel.fromJson(data);
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<List> buscarUsuarios(int pagina, {String? pesquisar}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'pesquisar': pesquisar ?? '',
    };
    Response response =
        await api.get('/usuarios', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<UsuarioModel> usuarios = data['usuarios']
          .map<UsuarioModel>((data) => UsuarioModel.fromJson(data))
          .toList();

      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [usuarios, pagina];
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<List<SubFuncionalidadeModel>> fetchSubFuncionalities(String id) async {
    Response response = await api.get('/user/itensfuncionalidades/' + id);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<SubFuncionalidadeModel> subFuncionalities = data.first
          .map<SubFuncionalidadeModel>(
              (data) => SubFuncionalidadeModel.fromJson(data))
          .toList();
      return subFuncionalities;
    } else {
      throw UserException(
          "Não foi encontrado itens de funcionalidades relacionado ao usuário !");
    }
  }

  Future<bool> updateUserSubFuncionalities(
      UsuarioModel user, List<SubFuncionalidadeModel> subFuncionalities) async {
    List<Map<String, dynamic>> dataSend = subFuncionalities
        .map((subFuncionalitie) => subFuncionalitie.toJson())
        .toList();

    Response response = await api.put(
        '/user/itensfuncionalidades/' + user.id.toString(), dataSend);

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw UserException(error);
    }
  }

  Future<List<FuncionalidadeModel>> buscarFuncionalidades(int id) async {
    Response response = await api.get('/usuarios/${id}/funcionalidades');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<FuncionalidadeModel> funcionalidades = data
          .map<FuncionalidadeModel>(
              (data) => FuncionalidadeModel.fromJson(data))
          .toList();

      return funcionalidades;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> update(UsuarioModel user) async {
    Response response =
        await api.put('/user/' + user.id.toString(), user.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw UserException(error);
    }
  }

  Future<List<EmpresaFilialModel>> buscarFiliais() async {
    Response response = await api.get('/menu-filiais');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<EmpresaFilialModel> filiais = data
          .map<EmpresaFilialModel>((data) => EmpresaFilialModel.fromJson(data))
          .toList();

      return filiais;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> vincularPerfilUsuario(
      int idUsuario, PerfilUsuarioModel perfilUsuario) async {
    Response response = await api.put(
        '/usuarios/${idUsuario}/perfil-usuario/${perfilUsuario.idPerfilUsuario}',
        '');

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
