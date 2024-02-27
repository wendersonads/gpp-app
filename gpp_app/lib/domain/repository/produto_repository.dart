import 'dart:convert';

import 'package:auth_migration/core/auth/usuario_service.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:auth_migration/view/splash/splash_screen.dart';
import 'package:get/get.dart' as gett;

import '../../base/service/base_service.dart';
import '../../core/auth/token_service.dart';
import '../model/produto_model.dart';
import 'package:http/http.dart';

import '../model/token_model.dart';

class ProdutoRepository {
  final BaseService _abstractService = BaseService('');

  final TokenService _tokenService = TokenService();

  final UsuarioService _usuarioService = UsuarioService();

  Future<List<Produto>> listaProdutos() async {
    Token token = _tokenService.get();

    Response response = await get(
      await _abstractService.getUrl('produto/'),
      headers: token.sendToken(),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      var Produtos = jsonList.map((e) => Produto.fromJson(e)).toList();
         print(_usuarioService.getUsuario().toJson());
      return Produtos;
      // var data = jsonDecode(response.body);
      // List<Produto> produtos = data['produtos']
      //     .map<Produto>((data) => Produto.fromJson(data))
      //     .toList();
      // return produtos;
    } else {
      _tokenService.delete();
      var error = jsonDecode(response.body)['message'];
      Notificacao.snackBar(error, tipoNotificacao: TipoNotificacaoEnum.error);
      gett.Get.to(const SplashScreen());
      throw error;
    }
    
  }

  deletarProduto(int idProduto) {}

  editarProduto(Produto produtoEditado) {}

  salvarNovoProduto(Produto novoProduto) {}
}
