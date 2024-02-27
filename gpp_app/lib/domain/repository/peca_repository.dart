import 'dart:convert';

import 'package:auth_migration/core/auth/usuario_service.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:auth_migration/view/splash/splash_screen.dart';
import 'package:get/get.dart' as gett;

import '../../base/service/base_service.dart';
import '../../core/auth/token_service.dart';
import '../model/peca_model.dart';
import 'package:http/http.dart';

import '../model/token_model.dart';

class PecaRepository {
  final BaseService _abstractService = BaseService('');
  final TokenService _tokenService = TokenService();

  Future<List<Peca>> listaPecas() async {
    Token token = _tokenService.get();

    Response response = await get(
      await _abstractService.getUrl('pecas/'),
      headers: token.sendToken(),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      var pecas = jsonList.map((e) => Peca.fromJson(e)).toList();
      return pecas;
    } else {
      _tokenService.delete();
      var error = jsonDecode(response.body)['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
      gett.Get.to(const SplashScreen());
      throw error;
    }
  }

  Future<Peca> adicionarPeca(Peca novaPeca) async {
    Token token = _tokenService.get();

    // Codifique a novaPeca em um JSON
    var pecaJson = jsonEncode(novaPeca.toJson());

    Response response = await post(
      await _abstractService.getUrl('pecas/'),
      headers: token.sendToken(),
      body: pecaJson,
    );

    if (response.statusCode == 200) {
      // Se a solicitação foi bem-sucedida, decodifique a resposta e retorne a Peca
      return Peca.fromJson(jsonDecode(response.body));
    } else {
      _tokenService.delete();
      var error = jsonDecode(response.body)['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
      gett.Get.to(const SplashScreen());
      throw error;
    }
  }

  Future<void> deletarPeca(int idPeca) async {
    try {
      Token token = _tokenService.get();

      // Envia a requisição DELETE para o servidor
      Response response = await delete(
        await _abstractService.getUrl('peca/$idPeca'),
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
