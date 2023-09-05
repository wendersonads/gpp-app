import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/asteca/asteca_model.dart';
import 'package:gpp/src/models/asteca/asteca_tipo_pendencia_model.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';

import '../../../repositories/AstecaRepository.dart';
import '../../../utils/notificacao.dart';

class AstecaController extends GetxController {
  late List<AstecaModel> astecas;

  var carregando = true.obs;
  var carregandoAstecaTipoPendencias = true.obs;
  late AstecaRepository astecaRepository;
  late List<AstecaTipoPendenciaModel> astecaTipoPendencias;
  late AstecaTipoPendenciaRepository astecaTipoPendenciaRepository;
  late PaginaModel pagina;
  late PaginaModel paginaAtendimento;
  String buscarFiltro = '';
  String cpfCnpjFiltro = '';
  String astecaTipoPendenciaFiltro = '';
  late AstecaModel? astecaFiltro;
  String? dataInicioFiltro;
  String? dataFimFiltro;
  var filtro = false.obs;
  var filtroAstecaPedidos = false.obs;
  var selected = 1.obs;

  late MaskFormatter maskFormatter;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AstecaController() {
    astecas = <AstecaModel>[].obs;

    astecaRepository = AstecaRepository();
    astecaTipoPendencias = <AstecaTipoPendenciaModel>[].obs;
    astecaTipoPendenciaRepository = AstecaTipoPendenciaRepository();
    pagina = PaginaModel(atual: 1, total: 0);
    paginaAtendimento = PaginaModel(atual: 1, total: 0);
    astecaFiltro = AstecaModel();
    maskFormatter = MaskFormatter();
  }

  @override
  void onInit() async {
    await buscarAstecas();

    super.onInit();
  }

  menu() async {
    limparFiltros();
    switch (selected.value) {
      case 1:
        await buscarAstecas();
        break;
      case 2:
        await buscarAstecasAtendimento();
        break;
    }
  }

  limparFitro() {
    formKey.currentState!.reset();
    buscarFiltro = '';
    cpfCnpjFiltro = '';
    astecaTipoPendenciaFiltro = '';
    astecaFiltro = AstecaModel();
    dataInicioFiltro = '';
    dataFimFiltro = '';
  }

  buscarAstecas() async {
    try {
      astecas = [];
      carregando(true);
      var resposta = await astecaRepository.buscarAstecas(pagina.atual,
          astecaTipoPendenciaFiltro: astecaTipoPendenciaFiltro,
          cpfCnpj: cpfCnpjFiltro,
          buscar: buscarFiltro,
          astecaFiltro: astecaFiltro,
          dataInicioFiltro: dataInicioFiltro,
          dataFimFiltro: dataFimFiltro,
          pedidosVinculado: filtroAstecaPedidos.value);
      astecas = resposta[0];

      pagina = resposta[1];
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      // limparFiltros();
      carregando(false);
      update();
    }
  }

  buscarAstecasAtendimento() async {
    try {
      astecas = [];
      carregando(true);
      var resposta = await astecaRepository.buscarAstecasAtendimento(
        paginaAtendimento.atual,
        cpfCnpj: cpfCnpjFiltro,
        buscar: buscarFiltro,
        astecaFiltro: astecaFiltro,
        dataInicioFiltro: dataInicioFiltro,
        dataFimFiltro: dataFimFiltro,
      );
      astecas = resposta[0];

      paginaAtendimento = resposta[1];
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      // limparFiltros();
      carregando(false);
      update();
    }
  }

  limparFiltros() {
    cpfCnpjFiltro = '';
    astecaTipoPendenciaFiltro = '';
    buscarFiltro = '';
    dataInicioFiltro = null;
    dataFimFiltro = null;
    filtroAstecaPedidos(false);
    update();
  }

  mudarRadioFiltro() {
    filtroAstecaPedidos.value
        ? filtroAstecaPedidos(false)
        : filtroAstecaPedidos(true);
    update();
  }

  buscarTipoPendencias() async {
    try {
      carregandoAstecaTipoPendencias(true);
      astecaTipoPendencias =
          await astecaTipoPendenciaRepository.buscarAstecaTipoPendencias();
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoAstecaTipoPendencias(false);
      update();
    }
  }
}
