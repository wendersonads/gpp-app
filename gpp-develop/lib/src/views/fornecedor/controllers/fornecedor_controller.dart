import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/produto/fornecedor_model.dart';

import 'package:gpp/src/repositories/pecas_repository/fornecedor_repository.dart';

import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:intl/intl.dart';

import '../../../utils/notificacao.dart';

class FornecedorController extends GetxController {
  String pesquisar = '';
  var carregando = true.obs;
  late FornecedorRepository fornecedorRepository;
  late List<FornecedorModel> fornecedores;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PaginaModel pagina;
  late MaskFormatter maskFormatter = MaskFormatter();
  int marcados = 0;
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  FornecedorController() {
    fornecedorRepository = FornecedorRepository();
    fornecedores = <FornecedorModel>[].obs;
    pagina = PaginaModel(atual: 1, total: 0);
  }

  @override
  void onInit() async {
    buscarFornecedores();
    super.onInit();
  }

  buscarFornecedores() async {
    try {
      carregando(true);

      var retorno = await fornecedorRepository
          .buscarFornecedores(this.pagina.atual, pesquisar: pesquisar);

      this.fornecedores = retorno[0];
      this.pagina = retorno[1];
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      update();
    }
  }
}
