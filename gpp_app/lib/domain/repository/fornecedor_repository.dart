import 'dart:convert';

import 'package:auth_migration/core/auth/usuario_service.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:auth_migration/view/splash/splash_screen.dart';
import 'package:get/get.dart' as gett;

import '../../base/service/base_service.dart';
import '../../core/auth/token_service.dart';
import '../model/fornecedor_model.dart';
import 'package:http/http.dart';

import '../model/token_model.dart';

class FornecedorRepository {
  final BaseService _abstractService = BaseService('');

  final TokenService _tokenService = TokenService();

  final UsuarioService _usuarioService = UsuarioService();

  Future<List<Fornecedor>> listaFornecedores() async {
    Token token = _tokenService.get();

    Response response = await get(
      await _abstractService.getUrl('fornecedor/'),
      headers: token.sendToken(),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      var Fornecedores = jsonList.map((e) => Fornecedor.fromJson(e)).toList();
      print(_usuarioService.getUsuario().toJson());
      return Fornecedores;
      // var data = jsonDecode(response.body);
      // List<Fornecedor> fornecedores = data['fornecedores']
      //     .map<Fornecedor>((data) => Fornecedor.fromJson(data))
      //     .toList();
      // return fornecedores;
    } else {
      _tokenService.delete();
      var error = jsonDecode(response.body)['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
      gett.Get.to(const SplashScreen());
      throw error;
    }
  }

  Future<void> salvarNovoFornecedor(Fornecedor novoFornecedor) async {
    try {
      Token token = _tokenService.get();

      // Converte o objeto fornecedor para JSON
      final novoFornecedorJson = novoFornecedor.toJson();

      // Envia a requisição POST para o servidor
      Response response = await post(
        await _abstractService.getUrl('fornecedor/'),
        headers: {
          ...token.sendToken(),
          'Content-Type':
              'application/json', // Certifique-se de incluir este cabeçalho
        },
        body: novoFornecedorJson,
      );

      if (response.statusCode == 201) {
        // Fornecedor criado com sucesso
        Notificacao.snackBar('Fornecedor criado com sucesso');
      } else {
        // Algo deu errado ao criar o fornecedor
        var error = jsonDecode(response.body)['message'];
        Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
      }
    } catch (e) {
      // Exibe uma mensagem de erro em caso de falha
      // Notificacao.snackBar('Erro ao criar fornecedor',
      //     tipoNotificacao: TipoNotificacaoEnum.error);
    }
  }

  Future<void> editarFornecedor(Fornecedor fornecedorEditado) async {
    try {
      Token token = _tokenService.get();

      // Converte o objeto fornecedor para JSON
      final fornecedorEditadoJson = fornecedorEditado.toJson();

      // Envia a requisição POST para o servidor
      Response response = await put(
        await _abstractService.getUrl('fornecedor/'),
        headers: {
          ...token.sendToken(),
          'Content-Type':
              'application/json', // Certifique-se de incluir este cabeçalho
        },
        body: fornecedorEditadoJson,
      );

      if (response.statusCode == 201) {
        // Fornecedor criado com sucesso
        Notificacao.snackBar('Fornecedor editado com sucesso');
      } else {
        // Algo deu errado ao criar o fornecedor
        var error = jsonDecode(response.body)['message'];
        Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
      }
    } catch (e) {
      // Exibe uma mensagem de erro em caso de falha
      Notificacao.snackBar('Erro ao criar fornecedor',
          tipoNotificacao: TipoNotificacaoEnum.error);
    }
  }

  Future<void> deletarFornecedor(int idFornecedor) async {
    try {
      Token token = _tokenService.get();

      // Envia a requisição DELETE para o servidor
      Response response = await delete(
        await _abstractService.getUrl('fornecedor/$idFornecedor'),
        headers: token.sendToken(),
      );

      if (response.statusCode == 204) {
        // Fornecedor deletado com sucesso
        Notificacao.snackBar('Fornecedor deletado com sucesso');
      } else {
        // Algo deu errado ao deletar o fornecedor
        var error = jsonDecode(response.body)['message'];
        Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
      }
    } catch (e) {}
  }
}
