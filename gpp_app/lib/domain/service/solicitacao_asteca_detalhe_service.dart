import 'package:auth_migration/domain/model/solicitacao_asteca_model.dart';
import 'package:auth_migration/domain/repository/solicitacao_asteca_repository.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:get/get.dart';

class SolicitacaAstecaDetalheService extends GetxController {
  late int id;
  late SolicitacaoAstecaModel solicitacao;
  late SolicitacaoAstecaRepository repository;
  RxBool carregandoAtualizacaoSolicitacao = false.obs;
  RxBool carregandoSolicitacao = false.obs;
  late int situacaoAsteca;

  SolicitacaAstecaDetalheService(iD) {
    id = iD;
    solicitacao = SolicitacaoAstecaModel();
    repository = SolicitacaoAstecaRepository();
    situacaoAsteca = 0;
  }

  @override
  void onInit() async {
    super.onInit();
    await solicitacaId();
  }

  Future<void> solicitacaId() async {
    try {
      carregandoSolicitacao(true);
      solicitacao = await repository.solicitacaoId(id: id);
      print(solicitacao.toJson());
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
      carregandoSolicitacao(false);
    } finally {
      carregandoSolicitacao(false);
    }
  }

  Future<bool> atualizarSolicitacao() async {
    late bool retorno;
    try {
      retorno = await repository.atualizarSoliciitacao(solicitacao,
          situacao: situacaoAsteca);
      Notificacao.snackBar('Solicitação atualiizada',
          tipoNotificacao: TipoNotificacaoEnum.sucesso);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    }
    return retorno;
  }
}
