import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/login/views/login_view.dart';

import 'package:gpp/src/views/asteca/view/asteca_detalhe_view.dart';
import 'package:gpp/src/views/avaria/views/criacao_produto_avaria_view.dart';
import 'package:gpp/src/views/avaria/views/detalhes_produto_avaria_view.dart';
import 'package:gpp/src/views/dashboard/views/dashboard_view.dart';
import 'package:gpp/src/views/enderecamento/consulta_box_view.dart';
import 'package:gpp/src/views/entrada/entrada_historico_detalhe_view.dart';
import 'package:gpp/src/views/estoque/views/estoque_ajuste_view.dart';
import 'package:gpp/src/views/estoque/views/estoque_detalhe_view.dart';
import 'package:gpp/src/views/estoque/views/estoque_view.dart';
import 'package:gpp/src/views/extrato_ajuste_estoque/view/extrato_ajuste_estoque_view.dart';
import 'package:gpp/src/views/extrato_estoque/view/extrato_estoque_view.dart';
import 'package:gpp/src/views/fornecedor/views/fornecedor_detalhe_view.dart';
import 'package:gpp/src/views/fornecedor/views/fornecedor_view.dart';
import 'package:gpp/src/views/inventario/views/inventario_cadastro_view.dart';
import 'package:gpp/src/views/inventario/views/inventario_detalhe_view.dart';
import 'package:gpp/src/views/inventario/views/inventario_resultado_view.dart';
import 'package:gpp/src/views/inventario/views/inventario_view.dart';
import 'package:gpp/src/views/mapa_carga/view/mapa_carga_detalhe_view.dart';
import 'package:gpp/src/views/mapa_carga/view/menu_mapa_carga_view.dart';
import 'package:gpp/src/views/motivo_ajuste_estoque/views/motivo_ajuste_estoque_view.dart';
import 'package:gpp/src/views/peca/views/peca_consultar_mobile_view.dart';
import 'package:gpp/src/views/pedido_entrada/view/PedidoEntradaDetalheView.dart';
import 'package:gpp/src/views/pedido_entrada/view/PedidoEntradaListView.dart';
import 'package:gpp/src/views/pedido_entrada/view/cadastrar_pedido_entrada_view.dart';
import 'package:gpp/src/views/pedido_saida/views/pedido_saida_view.dart';
import 'package:gpp/src/views/perfil_usuario/views/perfil_usuario_detalhe_view.dart';
import 'package:gpp/src/views/perfil_usuario/views/perfil_usuario_form_view.dart';
import 'package:gpp/src/views/perfil_usuario/views/perfil_usuario_view.dart';
import 'package:gpp/src/views/permissao/view/PermissaoView.dart';
import 'package:gpp/src/views/separacao/views/separacao_detalhe_view.dart';
import 'package:gpp/src/views/separacao/views/separacao_view.dart';
import 'package:gpp/src/views/solicitacao_os/views/solicitacao_os_criacao_view.dart';
import 'package:gpp/src/views/solicitacao_os/views/solicitacao_os_detalhe_view.dart';
import 'package:gpp/src/views/solicitacao_os/views/solicitacao_os_consulta_view.dart';
import 'package:gpp/src/views/usuarios/views/usuario_detalhe_view.dart';
import 'package:gpp/src/views/usuarios/views/usuarios_view.dart';

import '../shared/services/auth.dart';
import '../views/asteca/view/asteca_view.dart';
import '../views/avaria/views/produto_avaria_view.dart';
import '../views/departamentos/view/departamentos_view.dart';
import '../views/enderecamento/cadastro_box_view.dart';
import '../views/enderecamento/cadastro_corredor_view.dart';
import '../views/enderecamento/cadastro_estante_view.dart';
import '../views/enderecamento/cadastro_piso_view.dart';
import '../views/enderecamento/cadastro_prateleira_view.dart';
import '../views/entrada/menu_entrada_view.dart';
import '../views/motivos_troca_pecas/motivos_troca_peca_list_view.dart';
import '../views/peca/views/peca_detalhe_view.dart';
import '../views/peca/views/peca_editar_view.dart';
import '../views/peca/views/peca_view.dart';
import '../views/pecas/menu_cadastrar_view.dart';
import '../views/pedido_saida/views/pedido_saida_view.dart';
import '../views/pedido_saida/views/pedido_saida_detalhe_view.dart';
import '../views/produto/views/produto_detalhe_view.dart';
import '../views/produto/views/produto_view.dart';

class Auth extends GetMiddleware {
//   The default is 0 but you can update it to any number. Please ensure you match the priority based
//   on the number of guards you have.
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (isAuthenticated()) {
      return null;
    } else {
      return RouteSettings(name: '/login');
    }
  }
}

class AuthGuard extends GetMiddleware {
  String route;
  AuthGuard({
    required this.route,
  });

//   The default is 0 but you can update it to any number. Please ensure you match the priority based
//   on the number of guards you have.
  @override
  int? get priority => 1;

  bool verificarPermissao() {
    var permissao = false;

    if (getUsuario().perfilUsuario == null) return permissao;

    getUsuario().perfilUsuario!.funcionalidades!.forEach((element) {
      element.subFuncionalidades!.forEach((element) {
        if (element.rota == route) {
          permissao = true;
          return;
        }
      });
    });
    return permissao;
  }

  @override
  RouteSettings? redirect(String? route) {
    if (verificarPermissao()) {
      return null;
    } else {
      return RouteSettings(name: '/permissao');
    }
  }
}

var appRoutes = [
  //Rotas
  GetPage(name: '/login', page: () => LoginView()),
  GetPage(name: '/permissao', page: () => PermissaoView()),

  GetPage(
      name: '/pecas-cadastrar',
      page: () => MenuCadastrarView(),
      middlewares: [Auth(), AuthGuard(route: '/pecas-cadastrar')]),

  GetPage(
      name: '/pecas-cadastrar/:id',
      page: () => MenuCadastrarView(
            idProduto: int.parse(Get.parameters['id']!),
          ),
      middlewares: [Auth(), AuthGuard(route: '/pecas-cadastrar')]),

  GetPage(
      name: '/pecas-consultar',
      page: () => PecaView(),
      middlewares: [Auth(), AuthGuard(route: '/pecas-consultar')]),

  GetPage(
      name: '/mapa-carga',
      page: () => MenuMapaCarga(),
      middlewares: [Auth(), AuthGuard(route: '/mapa-carga')]),
  GetPage(
      name: '/mapa-carga-edicao/:id',
      page: () => MenuMapaCarga(
            idMapa: int.parse(Get.parameters['id']!),
          ),
      middlewares: [Auth(), AuthGuard(route: '/mapa-carga')]),

  GetPage(
      name: '/mapa-carga/:id',
      page: () => MapaCargaDetalheView(
            id: int.parse(Get.parameters['id']!),
          ),
      middlewares: [Auth(), AuthGuard(route: '/mapa-carga')]),

  GetPage(
      name: '/pecas-consultar/:id',
      page: () => PecaDetalheView(
            id: int.parse(Get.parameters['id']!),
          ),
      middlewares: [Auth(), AuthGuard(route: '/pecas-consultar')]),
  GetPage(
      name: '/pecas-editar/:id',
      page: () => PecaEditarView(
            id: int.parse(Get.parameters['id']!),
          ),
      middlewares: [Auth(), AuthGuard(route: '/pecas-cadastrar')]),
  GetPage(
      name: '/pecas-enderecamento',
      page: () => EstoqueView(),
      middlewares: [Auth(), AuthGuard(route: '/pecas-enderecamento')]),
  GetPage(
      name: '/inspecionar-pecas',
      page: () => PecaConsultarMobileView(),
      middlewares: [Auth(), AuthGuard(route: '/pecas-consultar')]),

  GetPage(
      name: '/astecas',
      page: () => AstecaView(),
      middlewares: [Auth(), AuthGuard(route: '/astecas')]),
  GetPage(
      name: '/astecas/:id',
      page: () => AstecaDetalheView(id: int.parse(Get.parameters['id']!)),
      middlewares: [Auth(), AuthGuard(route: '/astecas')]),
  GetPage(
      name: '/motivos-defeitos',
      page: () => MotivosTrocaPecasListView(),
      middlewares: [Auth(), AuthGuard(route: '/motivos-defeitos')]),

  GetPage(
      name: '/enderecamentos',
      page: () => CadastroPisoView(),
      middlewares: [Auth(), AuthGuard(route: '/enderecamentos')]),
  GetPage(
      name: '/piso/:id/corredores',
      page: () => CadastroCorredorView(
            idPiso: Get.parameters['id'],
          ),
      middlewares: [Auth(), AuthGuard(route: '/enderecamentos')]),
  GetPage(
      name: '/corredor/:id/estantes',
      page: () => CadastroEstanteView(
            idCorredor: Get.parameters['id'],
          ),
      middlewares: [Auth(), AuthGuard(route: '/enderecamentos')]),
  GetPage(
      name: '/estante/:id/prateleiras',
      page: () => CadastroPrateleiraView(
            idEstante: Get.parameters['id'],
          ),
      middlewares: [Auth(), AuthGuard(route: '/enderecamentos')]),
  GetPage(
      name: '/prateleira/:id/boxes',
      page: () => CadastroBoxView(
            idPrateleira: Get.parameters['id'],
          ),
      middlewares: [Auth(), AuthGuard(route: '/enderecamentos')]),
  GetPage(
      name: '/estoque-entrada',
      page: () => MenuEntradaView(),
      middlewares: [Auth(), AuthGuard(route: '/estoque-entrada')]),
  // GetPage(
  //     name: '/estoque-consulta',
  //     page: () => isAuthenticated() ? EstoqueConsultaView(1) : LoginView()),

  GetPage(
      name: '/departamentos',
      page: () => DepartamentosView(),
      middlewares: [Auth(), AuthGuard(route: '/departamentos')]),

  GetPage(
      name: '/usuarios',
      page: () => UsuariosView(),
      middlewares: [Auth(), AuthGuard(route: '/usuarios')]),

  GetPage(
      name: '/usuarios/:id',
      page: () => UsuarioDetalheView(id: int.parse(Get.parameters['id']!)),
      middlewares: [Auth(), AuthGuard(route: '/usuarios')]),

  GetPage(
      name: '/ordens-saida',
      page: () => PedidoSaidaListView(),
      middlewares: [Auth(), AuthGuard(route: '/ordens-saida')]),

  GetPage(
      name: '/ordens-saida/:id',
      page: () => PedidoSaidaDetalheView(id: int.parse(Get.parameters['id']!)),
      middlewares: [Auth(), AuthGuard(route: '/ordens-saida')]),

  GetPage(
      name: '/ordens-entrada',
      page: () => PedidoEntradaListView(),
      middlewares: [Auth(), AuthGuard(route: '/ordens-entrada')]),

  GetPage(
      name: '/ordens-entrada/:id',
      page: () => PedidoEntradaDetalheView(
            id: int.parse(Get.parameters['id']!),
          ),
      middlewares: [Auth(), AuthGuard(route: '/ordens-entrada')]),
  //
  GetPage(
      name: '/ordens-entrada/historico/:id',
      page: () =>
          EntradaHistoricoDetalheView(id: int.parse(Get.parameters['id']!)),
      middlewares: [Auth(), AuthGuard(route: '/ordens-entrada')]),

  GetPage(
      name: '/criar-ordem-entrada',
      page: () => CadastrarPedidoEntradaView(),
      middlewares: [Auth(), AuthGuard(route: '/criar-ordem-entrada')]),

  GetPage(
      name: '/produtos',
      page: () => ProdutoView(),
      middlewares: [Auth(), AuthGuard(route: '/produtos')]),
  GetPage(
      name: '/produtos/:id',
      page: () => ProdutoDetalheView(id: int.parse(Get.parameters['id']!)),
      middlewares: [Auth(), AuthGuard(route: '/produtos')]),

  GetPage(
      name: '/estoques',
      page: () => EstoqueView(),
      middlewares: [Auth(), AuthGuard(route: '/estoques')]),
  GetPage(
      name: '/estoques/:id',
      page: () => EstoqueDetalheView(id: int.parse(Get.parameters['id']!)),
      middlewares: [Auth(), AuthGuard(route: '/estoques')]),

  GetPage(
      name: '/home',
      page: () => DashboardView(),
      middlewares: [Auth(), AuthGuard(route: '/dashboard')]),
  GetPage(
      name: '/dashboard',
      page: () => DashboardView(),
      middlewares: [Auth(), AuthGuard(route: '/dashboard')]),
  GetPage(
      name: '/inventario',
      page: () => InventarioView(),
      middlewares: [Auth(), AuthGuard(route: '/inventario')]),
  GetPage(
      name: '/inventario/:id',
      page: () => InventarioDetalheView(id: int.parse(Get.parameters['id']!)),
      middlewares: [Auth(), AuthGuard(route: '/estoques')]),
  GetPage(
      name: '/inventario-cadastro',
      page: () => InventarioCadastroView(),
      middlewares: [Auth(), AuthGuard(route: '/estoques')]),
  GetPage(
      name: '/inventario-resultado/:id',
      page: () => InventarioResultadoView(id: int.parse(Get.parameters['id']!)),
      middlewares: [Auth(), AuthGuard(route: '/estoques')]),
  GetPage(
      name: '/perfil-usuario',
      page: () => PerfilUsuarioView(),
      middlewares: [Auth(), AuthGuard(route: '/perfil-usuario')]),
  GetPage(
      name: '/perfil-usuario/registrar',
      page: () => PerfilUsuarioFormView(),
      middlewares: [Auth(), AuthGuard(route: '/perfil-usuario')]),
  GetPage(
      name: '/perfil-usuario/:id',
      page: () =>
          PerfilUsuarioDetalheView(id: int.parse(Get.parameters['id']!)),
      middlewares: [Auth(), AuthGuard(route: '/perfil-usuario')]),
  GetPage(
      name: '/separacao',
      page: () => SeparacaoView(),
      middlewares: [Auth(), AuthGuard(route: '/separacao')]),

  GetPage(
      name: '/separacao/:id',
      page: () => SeparacaoDetalheView(id: int.parse(Get.parameters['id']!)),
      middlewares: [Auth(), AuthGuard(route: '/separacao')]),
  GetPage(
      name: '/fornecedores',
      page: () => FornecedorView(),
      middlewares: [Auth(), AuthGuard(route: '/fornecedores')]),
  GetPage(
      name: '/fornecedores/:id',
      page: () => FornecedorDetalheView(id: int.parse(Get.parameters['id']!)),
      middlewares: [Auth(), AuthGuard(route: '/fornecedores')]),
  GetPage(
    name: '/extrato-estoque',
    page: () => ExtratoEstoqueView(),
  ),
  GetPage(
    name: '/extrato-ajuste-estoque',
    page: () => ExtratoAjusteEstoque(),
  ),
  GetPage(
    //middlewares: [Auth(), AuthGuard(route: '/fornecedores')]),
    name: '/estoque-ajuste/:id',
    page: () => EstoqueAjusteView(id: int.parse(Get.parameters['id']!)),
  ),
  GetPage(
      name: '/estoque/motivo',
      page: () => MotivoAjusteEstoqueView(),
      middlewares: [Auth(), AuthGuard(route: '/estoques')]),
  GetPage(
      name: '/capacidade-box',
      page: () => ConsultaBoxView(),
      middlewares: [Auth(), AuthGuard(route: '/dashboard')]),
  GetPage(
      name: '/solicitacao-os',
      page: () => SolicitacaoOSConsultaView(),
      middlewares: [Auth(), AuthGuard(route: '/solicitacao-os')]),

  GetPage(
      name: '/solicitacao-os/criar',
      page: () => SolicitacaoOSCriacaoView(),
      middlewares: [Auth(), AuthGuard(route: '/solicitacao-os')]),
  GetPage(
      name: '/solicitacao-os/:id',
      page: () =>
          SolicitacaoOSDetalheView(id: int.parse(Get.parameters['id']!)),
      middlewares: [Auth(), AuthGuard(route: '/solicitacao-os')]),
  GetPage(
    name: '/avaria',
    page: () => ProdutoAvariaView(),
  ),
  GetPage(
    name: '/avaria/criar',
    page: () => CriacaoProdutoAvariaView(),
  ),
  GetPage(
    name: '/avaria/detalhes/:id',
    page: () => DetalhesProdutoAvariaView(id: int.parse(Get.parameters['id']!)),
  ),
];
