import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gpp/src/enums/solicitacao_os_classificacao_produto_enum.dart';
import 'package:gpp/src/models/solicitacao_os/motivo_reprovacao_solicitacao_os_model.dart';
import 'package:gpp/src/repositories/solicitacao_os_repositories/motivo_reprovacao_os_repository.dart';
import 'package:gpp/src/views/solicitacao_os/controllers/solicitacao_os_consulta_controller.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gpp/src/views/solicitacao_os/controllers/solicitacao_os_consulta_controller.dart';

import 'package:gpp/src/models/perfil_usuario_model.dart';
import 'package:gpp/src/models/solicitacao_os/solicitacao_os_model.dart';
import 'package:gpp/src/repositories/solicitacao_os_repositories/solicitacao_os_repository.dart';
import 'package:gpp/src/shared/services/auth.dart';
import 'package:gpp/src/utils/notificacao.dart';

class SolicitacaoOSDetalheController extends GetxController {
  // Atributo da classe
  late int id;

  // Estados referentes aos dados da tela
  RxBool carregandoSolicitacao = false.obs;
  RxBool carregandoAtualizacaoSolicitacao = false.obs;
  late SolicitacaoOSModel solicitacao;
  late SolicitacaoOSRepository solicitacaoOSRepository;
  late MotivoReprovacaoOsRepository motivoReprovacaoOsRepository;
  var carregandoMotivosReprovacao = false.obs;
  Rxn<SolicitacaoOsClassificacaoProdutoEnum> classificacaoProduto = Rxn(null);
  Rxn<String> aux = Rxn(null);

  // Estado para guardar se o usuário é aprovador de OS ou não
  RxBool usuarioAprovador = false.obs;

  // Estados gerais
  late NumberFormat formatter;

  //lista motivos de reprovacao
  late List<MotivoReprovacaoSolicitacaoOsModel> motivosReprovacao;

  SolicitacaoOSDetalheController(id) {
    this.id = id;

    solicitacao = SolicitacaoOSModel();
    solicitacaoOSRepository = SolicitacaoOSRepository();
    motivoReprovacaoOsRepository = MotivoReprovacaoOsRepository();

    formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    motivosReprovacao = [];
  }

  @override
  void onInit() async {
    super.onInit();

    buscarPefilUsuario();
    await buscarSolicitacao();
  }

  /// Função responsável por buscar o perfil do usuário logado e verificar se o
  /// mesmo é aprovador de OS.
  void buscarPefilUsuario() {
    List<String> perfisAprovador = [
      'Aprovador - OS',
      'Administrativo',
    ];
    PerfilUsuarioModel perfilUsuario = getUsuario().perfilUsuario!;

    if (perfisAprovador.contains(perfilUsuario.descricao)) {
      usuarioAprovador.value = true;
    }
  }

  //Função reponsável por buscar motivos de reprovacao de solicitacao de os
  buscarMotivosReprovacaoSolicitacaoOs() async {
    try {
      carregandoMotivosReprovacao(true);
      this.motivosReprovacao =
          await motivoReprovacaoOsRepository.buscaMotivosReprovacao();
    } catch (e) {
      Notificacao.snackBar(
        e.toString(),
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
    } finally {
      carregandoMotivosReprovacao(false);
    }
  }

  /// Função responsável por buscar a solicitação selecionada pelo usuário.
  Future<void> buscarSolicitacao() async {
    try {
      carregandoSolicitacao(true);
      this.solicitacao =
          await solicitacaoOSRepository.buscarSolicitacao(id: id);
      //Passando valor a variável que será mostrada na tela de acordo com classificação do produto na aprovação da  Solicitacão de OS
      if (solicitacao.situacao == 2) {
        if (solicitacao.classificacaoProduto == 1) {
          aux.value = 'Imprópio pra Revenda';
        } else if (solicitacao.classificacaoProduto == 2) {
          aux.value = 'Produto Obsoleto';
        } else if (solicitacao.classificacaoProduto == 3) {
          aux.value = 'Produto em Conformidade';
        } else {
          aux.value = null;
        }
      }
    } catch (e) {
      Notificacao.snackBar(
        e.toString(),
        tipoNotificacao: TipoNotificacaoEnum.error,
      );

      Get.back();
    } finally {
      carregandoSolicitacao(false);
    }
  }

  /// Função responsável por montar corretamente a URL do video informado.
  String? montarURLvideo(String? urlOriginal) {
    if (urlOriginal == null) {
      return null;
    }

    // Se a URL original possui a palavra 'photos', então o ambiente é o de
    // desenvolvimento e a URL precisa ser montada de uma maneira diferente
    if (urlOriginal.contains('videos')) {
      return 'http://localhost:1340/$urlOriginal';
    }

    return 'https://$urlOriginal';
  }

  /// Função responsável por abrir o link do video.
  Future<void> abrirLinkVideo(String? url) async {
    try {
      if (url == null) {
        throw 'Não é possível visualizar esse video!';
      }

      final Uri uri = Uri.parse(url);
      LaunchMode modoAbertura =
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication;

      if (!await launchUrl(uri, mode: modoAbertura)) {
        throw 'Não foi possível abrir o video!';
      }
    } catch (e) {
      Notificacao.snackBar(
        e.toString(),
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
    }
  }

  /// Função responsável por montar corretamente a URL da imagem informada.
  String? montarURLImagem(String? urlOriginal) {
    if (urlOriginal == null) {
      return null;
    }

    // Se a URL original possui a palavra 'photos', então o ambiente é o de
    // desenvolvimento e a URL precisa ser montada de uma maneira diferente
    if (urlOriginal.contains('photos')) {
      return 'http://localhost:1340/$urlOriginal';
    }

    return 'https://$urlOriginal';
  }

  /// Função responsável por abrir o link da imagem.
  Future<void> abrirLinkImagem(String? url) async {
    try {
      if (url == null) {
        throw 'Não é possível visualizar essa imagem!';
      }

      final Uri uri = Uri.parse(url);
      LaunchMode modoAbertura =
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication;

      if (!await launchUrl(uri, mode: modoAbertura)) {
        throw 'Não foi possível abrir a imagem!';
      }
    } catch (e) {
      Notificacao.snackBar(
        e.toString(),
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
    }
  }

  /// Função responsável por aprovar ou reprovar a solicitação de OS.
  Future<bool> atualizarSolicitacao({required bool aprovacao}) async {
    try {
      carregandoAtualizacaoSolicitacao(true);

      if (aprovacao) {
        // Atualiza a situacao da solicitação para 2 (Aprovada)
        solicitacao.situacao = 2;
        // Passa o valor da variável de classificação do produto vindo do front pra solicitação de OS
        solicitacao.classificacaoProduto = classificacaoProduto.value != null
            ? classificacaoProduto.value!.value
            : null;
      } else {
        // Atualiza a situacao da solicitação para 3 (Reprovada)
        solicitacao.situacao = 3;
      }

      var retorno = await solicitacaoOSRepository.atualizarSolicitacao(
          solicitacao.idSolicitacao!, solicitacao);

      final consultaController = Get.find<SolicitacaoOSConsultaController>();
      consultaController.solicitacoes
          .firstWhere((element) => element.idSolicitacao == id)
          .situacao = solicitacao.situacao;
      consultaController.solicitacoes.refresh();

      Notificacao.snackBar(
        retorno,
        tipoNotificacao: TipoNotificacaoEnum.sucesso,
      );

      return true;
    } catch (e) {
      Notificacao.snackBar(
        e.toString(),
        tipoNotificacao: TipoNotificacaoEnum.error,
      );

      // Volta a situação da solicitação para 1 (Aguardando Aprovação)
      solicitacao.situacao = 1;

      return false;
    } finally {
      carregandoAtualizacaoSolicitacao(false);
    }
  }
}
