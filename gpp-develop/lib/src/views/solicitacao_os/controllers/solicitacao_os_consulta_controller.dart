import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/perfil_usuario_model.dart';
import 'package:gpp/src/models/solicitacao_os/solicitacao_os_model.dart';
import 'package:gpp/src/repositories/solicitacao_os_repositories/solicitacao_os_repository.dart';
import 'package:gpp/src/shared/services/auth.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';

import '../../../enums/status_os_enum.dart';

class SolicitacaoOSConsultaController extends GetxController {
  // Estados para a listagem de solicitações de OS
  RxBool carregandoSolicitacoes = false.obs;
  late RxList<SolicitacaoOSModel> solicitacoes;
  late SolicitacaoOSRepository solicitacaoOSRepository;
  late PaginaModel pagina;

  // Estados do formulário de filtro
  RxBool formFiltragemVisivel = false.obs;
  late GlobalKey<FormState> formFiltragemSolicitacoesKey;
  late TextEditingController buscarSolicitacaoFiltroController;
  DateTime? dataInicioFiltro;
  DateTime? dataFimFiltro;
  String? filialFiltro;
  Rxn<StatusOSEnum> situacaoFiltro = Rxn(null);

  // Estado para guardar se o usuário é aprovador de OS ou não
  RxBool usuarioAprovador = false.obs;

  // Estados gerais
  late MaskFormatter maskFormatter;

  SolicitacaoOSConsultaController() {
    solicitacoes = <SolicitacaoOSModel>[].obs;
    solicitacaoOSRepository = SolicitacaoOSRepository();
    pagina = PaginaModel(
      atual: 1,
      total: 0,
    );

    formFiltragemSolicitacoesKey = GlobalKey<FormState>();
    buscarSolicitacaoFiltroController = TextEditingController();

    maskFormatter = MaskFormatter();
  }

  @override
  void onInit() async {
    super.onInit();

    buscarPerfilUsuario();
    await buscarSolicitacoesOS();
  }

  /// Função responsável por mostrar/esconder o formulário de filtragem.
  void alternarVisibilidadeFormFiltragem() {
    formFiltragemVisivel.value = !formFiltragemVisivel.value;
  }

  /// Função responsável por limpar os filtros de busca.
  void limparFiltros() {
    buscarSolicitacaoFiltroController.clear();
    dataInicioFiltro = null;
    dataFimFiltro = null;
    filialFiltro = null;
    situacaoFiltro.value = null;
  }

  /// Função responsável por buscar o perfil do usuário logado e verificar se o
  /// mesmo é aprovador de OS.
  void buscarPerfilUsuario() {
    List<String> perfisAprovador = [
      'Aprovador - OS',
      'Administrativo',
    ];
    PerfilUsuarioModel perfilUsuario = getUsuario().perfilUsuario!;

    if (perfisAprovador.contains(perfilUsuario.descricao)) {
      usuarioAprovador.value = true;
    }
  }

  /// Função responsável por buscar as solicitações de OS.
  Future<void> buscarSolicitacoesOS() async {
    try {
      carregandoSolicitacoes(true);

      var retorno = await solicitacaoOSRepository.buscarSolicitacoes(
        pagina: this.pagina.atual,
        buscar: buscarSolicitacaoFiltroController.text,
        dataInicio: dataInicioFiltro,
        dataFim: dataFimFiltro,
        filial: usuarioAprovador.value
            ? int.tryParse(filialFiltro ?? '')
            : getUsuario().idFilial,
        situacao: situacaoFiltro.value?.value,
      );

      this.solicitacoes.value = retorno[0];
      this.pagina = retorno[1];

      // Fecha o formulário de filtragem caso esteja aberto
      if (formFiltragemVisivel.value) {
        formFiltragemVisivel.value = false;
      }
    } catch (e) {
      print(e);
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoSolicitacoes(false);
      update();
    }
  }
}
