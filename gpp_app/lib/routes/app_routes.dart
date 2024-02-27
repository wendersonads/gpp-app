import 'package:auth_migration/core/auth/token_service.dart';
import 'package:auth_migration/core/auth/usuario_service.dart';
import 'package:auth_migration/domain/service/auth_service.dart';
import 'package:auth_migration/view/asteca/solicitacao_asteca_criar.dart';
import 'package:auth_migration/view/asteca/solicitacao_asteca_detalhe.dart';
import 'package:auth_migration/view/asteca/solicitacao_asteca_list.dart';
import 'package:auth_migration/view/asteca/view/solicitacao_asteca_detalhe_view.dart';
import 'package:auth_migration/view/home/home_screen.dart';
import 'package:auth_migration/view/login/login_screen.dart';
import 'package:auth_migration/view/produto/produto_list.dart';
import 'package:auth_migration/view/usuarios/usuario_list.dart';
import 'package:auth_migration/view/usuarios/view/usuario_detalhe_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../view/fornecedor/fornecedor_form.dart';
import '../view/fornecedor/fornecedor_list.dart';
import '../view/peca/peca_form.dart';
import '../view/peca/peca_list.dart';

class Auth extends GetMiddleware {
  @override
  int? get priority => 1;

  final TokenService _serviceToken = TokenService();

  @override
  RouteSettings? redirect(String? route) {
    if (_serviceToken.isAuthenticated()) {
      return null;
    } else {
      return const RouteSettings(name: '/login');
    }
  }
}

class AuthGuard extends GetMiddleware {
  String? route;

  AuthGuard({
    required this.route,
  });
  @override
  int? get priority => 1;

  final UsuarioService _serviceUser = UsuarioService();

  bool verificarPermisao() {
    var permissao = false;

    if (_serviceUser.getUsuario().perfilUsuario == null) return false;

    _serviceUser
        .getUsuario()
        .perfilUsuario!
        .perfilUsuarioFuncionalidades!
        .forEach((element) {
      element.funcionalidade!.subFuncionalidades!.forEach((data) {
        if (data.rota == route) {
          permissao = true;
          return;
        }
      });
    });
    return permissao;
  }

  @override
  RouteSettings? redirect(String? route) {
    if (verificarPermisao()) {
      return null;
    } else {
      return const RouteSettings(name: '/login');
    }
  }

  static var appRoutes = [
    GetPage(name: '/login', page: () => const LoginScreen()),
    GetPage(name: '/home', page: () => const HomeScreen()),
    GetPage(name: '/fornecedores', page: () => const FornecedorList()),
    GetPage(name: '/pecas', page: () => const PecaList()),
    GetPage(name: '/produtos', page: () => const ProdutoList()),
    GetPage(name: '/login', page: ()=> const LoginScreen()),
    GetPage(name: '/home', page: () => const HomeScreen()),
    GetPage(name: '/criar-asteca', page: () => SolicitacaoAstecaCriar()),
    GetPage(name: '/criar-fornecedor', page: () => FornecedorForm()),
    GetPage(name: '/criar-peca', page: () => PecaForm()),
    GetPage(name: '/astecas', page: () => SolicitacaoAstecaList()),
    GetPage(name: '/astecas/:id', page: () =>SolicitacaoAstecaDetalheView(id: int.parse(Get.parameters['id']!))),
    GetPage(name: '/usuarios', page: () => const UsuarioList()),
    GetPage(name: '/usuarios/:id', page: () => UsuarioDetalheView(id: int.parse(Get.parameters['id']!)))
  ];
}
