import 'package:auth_migration/domain/model/enumeradores/situacao_asteca_enum.dart';
import 'package:auth_migration/domain/model/solicitacao_asteca_model.dart';
import 'package:auth_migration/domain/repository/solicitacao_asteca_repository.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/components/MaskFormatter.dart';

class SolicitacaoAstecaServiceList extends GetxController {
  var carregandoSolicitacoes = false.obs;
  var selected = 1.obs;
  late TextEditingController buscarSolicitacaoFiltroController;
  RxBool formFiltragemVisivel = false.obs;
  late GlobalKey<FormState> formFiltragemSolicitacoesKey;
  DateTime? dataInicioFiltro;
  DateTime? dataFimFiltro;
  late MaskFormatter maskFormatter;
  RxBool usuarioAprovador = false.obs;
  Rxn<SituacaoAstecaEnum> situacaoFiltro = Rxn(null);
  late RxList<SolicitacaoAstecaModel> solicitacoes;
  late SolicitacaoAstecaRepository repository;

  SolicitacaoAstecaServiceList() {
    solicitacoes = <SolicitacaoAstecaModel>[].obs;
    formFiltragemSolicitacoesKey = GlobalKey<FormState>();
    buscarSolicitacaoFiltroController = TextEditingController();
    maskFormatter = MaskFormatter();
    repository = SolicitacaoAstecaRepository();
  }

 @override
  void onInit() async {
    super.onInit();
    await buscarSolicitacoes();
  }
  void alternarVisibilidadeFormFiltragem() {
    formFiltragemVisivel.value = !formFiltragemVisivel.value;
  }

  Future<void> buscarSolicitacoes() async {
    try {
      solicitacoes.value = await repository.buscarSolicitacoes();
    } catch (e) {

      print(e.toString());
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    }
  }
  
  void limparFiltros() {
    buscarSolicitacaoFiltroController.clear();
    dataInicioFiltro = null;
    dataFimFiltro = null;

    situacaoFiltro.value = null;
  }
}
