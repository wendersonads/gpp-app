
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/models/produto/fornecedor_model.dart';
import 'package:gpp/src/models/produto/produto_model.dart';
import 'package:gpp/src/models/produto_peca_model.dart';
import 'package:gpp/src/repositories/pecas_repository/fornecedor_repository.dart';

import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';


class FornecedorDetalheController extends GetxController {
  late int id;
  var count = 0;
  var etapa = 2.obs;
  var carregando = true.obs;
  var separacaoCompleta = true.obs;
  late FornecedorRepository fornecedorRepository;
  late List<ProdutoModel> produtos;
  late List<ProdutoPecaModel> produtoPecas;

  late MaskFormatter maskFormatter;
  late GlobalKey<FormState> formKey;
  int marcados = 0;
  late FornecedorModel fornecedor;

  FornecedorDetalheController(int id) {
    fornecedorRepository = FornecedorRepository();
    produtos = <ProdutoModel>[].obs;
    produtoPecas = <ProdutoPecaModel>[].obs;

    formKey = GlobalKey<FormState>();
    maskFormatter = MaskFormatter();
    this.id = id;
    fornecedor = FornecedorModel();
  }

  @override
  void onInit() async {
    super.onInit();
    await buscarFornecedor();
  }

  @override
  void onClose() {
    super.onClose();
  }

  buscarFornecedor() async {
    try {
      carregando(true);
      this.fornecedor = await fornecedorRepository.buscarFornecedor(this.id);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
    }
  }

  inserirFornecedorEmail() async {
    try {
      formKey.currentState!.save();
      if (await fornecedorRepository.inserirFornecedorEmail(
          fornecedor.idFornecedor!, fornecedor)) {
        Notificacao.snackBar('E-mail adicionado com sucesso!');
        formKey.currentState!.reset();
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      await buscarFornecedor();
    }
  }
}
