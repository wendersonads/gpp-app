import 'package:auth_migration/domain/model/asteca_motivo_model.dart';
import 'package:auth_migration/domain/model/documento_fiscal_model.dart';
import 'package:auth_migration/domain/model/enumeradores/tipo_asteca_enum.dart';
import 'package:auth_migration/domain/model/item_solicitacao_asteca_model.dart';
import 'package:auth_migration/domain/model/peca_estoque_model.dart';
import 'package:auth_migration/domain/repository/solicitacao_asteca_repository.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/item_produto_peca_asteca.dart';
import '../model/solicitacao_asteca_model.dart';

class SolicitacaoAstecaService extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var carregandoNotasFiscais = false.obs;
  var carregandoEstoquePecas = false.obs;
  var carregandoMotivoCriacaoAsteca = false.obs;
  var carregando = true.obs;
  List<DocumentoFiscal> documentosFiscais = <DocumentoFiscal>[];
  List<PecaEstoque> pecasEstoque = <PecaEstoque>[];
  late final txtIdProduto;
  late final txtIdDocumento;
  late SolicitacaoAstecaRepository astecaRepository;
  late Rxn<int> idNotaFiscalSelecionada = Rxn(null);
  late Rxn<DocumentoFiscal> notaFiscalSelecionada;
  late List<AstecaMotivo> motivosCriacaoAstecaList;
  late RxList<ItemProdutoPecaAsteca> pecaSelecionada;
  late RxList<ItemProdutoPecaAsteca> itensSelecionados;
  late Rx<SolicitacaoAstecaModel> pedidoAsteca;
  late Rx<AstecaMotivo> motivoCriacaoAsteca;
  late RxList<ItemSolicitacaoAsteca> itemSolicitacaoCricaoAsteca;
  final List<TextEditingController> quantidade = [];
  Rxn<TipoAstecaEnum> tipoAstecaEnum = Rxn(null);
  var colors = Colors.white.obs;
  int? tipoAsteca;

  SolicitacaoAstecaService() {
    txtIdProduto = TextEditingController();
    txtIdDocumento = TextEditingController();
    astecaRepository = SolicitacaoAstecaRepository();
    notaFiscalSelecionada = Rxn(null);
    motivosCriacaoAstecaList = <AstecaMotivo>[];
    pecaSelecionada = <ItemProdutoPecaAsteca>[].obs;
    pecasEstoque = <PecaEstoque>[].obs;
    itensSelecionados = <ItemProdutoPecaAsteca>[].obs;
    itemSolicitacaoCricaoAsteca = <ItemSolicitacaoAsteca>[].obs;
    pedidoAsteca = SolicitacaoAstecaModel().obs;
    motivoCriacaoAsteca = AstecaMotivo().obs;
  }

  @override
  void onInit() async {
    super.onInit();
    await motivosCriacaoAsteca();
  }

  limparFiltro() {
    formKey.currentState!.reset();
  }

  checkBoxListaPeca(bool value, index) {
    pecaSelecionada[index].marcado = value;
    update(['modalListaPecas']);
  }

  buscarNotaModal(String idProduto, String idDocumento) {}

  void selecionarNotaFiscal(DocumentoFiscal docFiscal) {
    idNotaFiscalSelecionada.value = docFiscal.idDocumentoFiscal;
  }

  motivosCriacaoAsteca() async {
    try {
      carregando(true);
      carregandoMotivoCriacaoAsteca(true);
      motivosCriacaoAstecaList = await astecaRepository.motivosCriacaoAsteca();
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoMotivoCriacaoAsteca(false);
      carregando(false);
    }
  }

  estoquePecasProduto(String idProduto) async {
    try {
      int idProdutoInt = int.parse(idProduto);
      carregandoEstoquePecas(true);
      pecasEstoque = await astecaRepository.listarPorProduto(idProdutoInt);
      pecaSelecionada.value = pecasEstoque
          .map((e) => ItemProdutoPecaAsteca(marcado: false, produtoPeca: e))
          .toList();
    } catch (e) {
      Notificacao.snackBar(
        e.toString(),
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
    } finally {
      carregandoEstoquePecas(false);
    }
  }

  void adicionarPecaSelecionadas() {
    itensSelecionados.value =
        pecaSelecionada.where((p0) => p0.marcado == true).toList();
    pedidoAsteca.value =
        SolicitacaoAstecaModel(itensAsteca: itemSolicitacaoCricaoAsteca);
    adicionarPecas();
  }

  adicionarPecas() {
    for (var itemPeca in itensSelecionados) {
      if (itemPeca.marcado) {
        int index = pedidoAsteca.value.itensAsteca!.indexWhere((element) =>
            element.pecaEstoque!.idPecaEstoque ==
            itemPeca.produtoPeca.idPecaEstoque);

        if (index < 0) {
          pedidoAsteca.value.itensAsteca!.add(
            ItemSolicitacaoAsteca(
                pecaEstoque: itemPeca.produtoPeca, quantidade: 1),
          );
        } else {
          pedidoAsteca.value.itensAsteca![index].quantidade++;
          quantidade[index].text =
              pedidoAsteca.value.itensAsteca![index].quantidade.toString();
        }
        itemPeca.marcado = false;
      }
    }
  }

  statusSaldoPeca(int index) {
    pedidoAsteca.value.itensAsteca![index].pecaEstoque?.saldoDisponivel == null
        ? colors.value = Colors.red.shade100
        : pedidoAsteca.value.itensAsteca![index].pecaEstoque!.saldoDisponivel <
                pedidoAsteca.value.itensAsteca![index].quantidade
            ? colors.value = Colors.red.shade100
            : colors.value = Colors.white;
    return colors.value;
  }

  buildSituacaoEstoque(int index) {
    pedidoAsteca.value.itensAsteca![index].pecaEstoque?.saldoDisponivel == null
        ? colors.value = Colors.red.shade100
        : pedidoAsteca.value.itensAsteca![index].pecaEstoque!.saldoDisponivel <
                pedidoAsteca.value.itensAsteca![index].quantidade
            ? colors.value = Colors.red.shade100
            : colors.value = Colors.white;
    update(['listadePecaSelecionada']);
  }

  removerPeca(int index) {
    pedidoAsteca.value.itensAsteca!.removeAt(index);
    update(['listadePecaSelecionada']);
  }

  void removerQuantidade(index) async {
    if (pedidoAsteca.value.itensAsteca![index].quantidade > 1) {
      pedidoAsteca.value.itensAsteca![index].quantidade--;

      quantidade[index].text =
          pedidoAsteca.value.itensAsteca![index].quantidade.toString();
    } else {
      if (await Notificacao.confirmacao(
          "Deseja realmente remover essa peça ?")) {
        removerPeca(index);
        update();
      }
    }
  }

  void adicionarQuantidade(index) {
    pedidoAsteca.value.itensAsteca![index].quantidade++;

    quantidade[index].text =
        pedidoAsteca.value.itensAsteca![index].quantidade.toString();
  }

  Future<bool> notasFiscaisPorProduto(String idProduto) async {
    int idProdutoInt = int.parse(idProduto);
    try {
      carregandoNotasFiscais(true);
      documentosFiscais =
          await astecaRepository.notasFiscaisPorProduto(idProdutoInt);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoNotasFiscais(false);
    }
    return astecaRepository.carregandoNotas.value;
  }

  void confirmarSelecaoNotaFiscal({required int tipoSelecao}) {
    if (tipoSelecao == 0) {
      idNotaFiscalSelecionada.value = null;
      notaFiscalSelecionada.value = null;
    } else {
      notaFiscalSelecionada.value = documentosFiscais.firstWhere((element) =>
          element.idDocumentoFiscal == idNotaFiscalSelecionada.value);
    }
  }

  Future<bool> salvarAsteca() async {
    bool result = false;
    try {
      //0-Vistoria 1-Reparo
      if (tipoAstecaEnum.value!.index == 0) {
        pedidoAsteca.value.tipoAsteca = 1;
      } else {
        pedidoAsteca.value.tipoAsteca = 2;
      }
      pedidoAsteca.value.motivoCriacaoAsteca = motivoCriacaoAsteca.value;
      pedidoAsteca.value.idProduto =
          notaFiscalSelecionada.value?.itens?.first.produto?.idProduto;
      pedidoAsteca.value.documentoFiscal = notaFiscalSelecionada.value;
      pedidoAsteca.value.descricaoProduto = notaFiscalSelecionada.value?.itens?.first.produto?.descricao ?? '';
      result = await astecaRepository.novaSolicitacao(pedidoAsteca.value);
    } catch (e) {
      result = false;
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    }
    return result;
  }
}
