import 'package:flutter/material.dart';
import 'package:gpp/src/models/PaginaModel.dart';

import 'package:gpp/src/models/pedido_saida_model.dart';
import 'package:gpp/src/models/asteca/asteca_model.dart';
import 'package:gpp/src/models/produto_peca_model.dart';
import 'package:gpp/src/models/asteca/asteca_tipo_pendencia_model.dart';
import 'package:gpp/src/models/documento_fiscal_model.dart';

import 'package:gpp/src/repositories/AstecaRepository.dart';
import 'package:gpp/src/repositories/PecaRepository.dart';
import 'package:gpp/src/repositories/pedido_entrada_repository.dart';
import 'package:gpp/src/repositories/pedido_saida_repository.dart';
import 'package:intl/intl.dart';

class AstecaController {
  late PedidoSaidaRepository pedidoSaidaRepository = PedidoSaidaRepository();
  bool carregaProdutoPeca = false;
  bool abreDialogo = false;
  late PecaRepository pecaRepository = PecaRepository();
  late List<ProdutoPecaModel> produtoPecas;
  PedidoEntradaRepository pedidoEntradaRepository = PedidoEntradaRepository();

  DateTime? dataInicio;
  DateTime? dataFim;

  PedidoSaidaModel pedidoSaida = PedidoSaidaModel(
    itemsPedidoSaida: [],
    valorTotal: 0.0,
  );

  bool abrirDropDownButton = false;

  String? pendenciaFiltro;

  int step = 2;
  bool abrirFiltro = false;

  bool carregado = false;
  bool carregadoAsteca = false;
  bool carregadoMotivoTrocaPeca = false;

  PaginaModel pagina = PaginaModel(total: 0, atual: 1);
  late AstecaTipoPendenciaModel astecaTipoPendencia;
  List<AstecaTipoPendenciaModel> astecaTipoPendencias = [];
  List<AstecaTipoPendenciaModel> astecaTipoPendenciasBuscar = [];
  AstecaModel asteca = AstecaModel(
    documentoFiscal: DocumentoFiscalModel(),
  );
  GlobalKey<FormState> filtroFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> filtroExpandidoFormKey = GlobalKey<FormState>();
  AstecaRepository repository = AstecaRepository();
  AstecaTipoPendenciaRepository astecaTipoPendenciaRepository = AstecaTipoPendenciaRepository();
  AstecaModel filtroAsteca = AstecaModel(
    documentoFiscal: DocumentoFiscalModel(),
  );
  List<AstecaModel> astecas = [];

  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  // GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // AstecaModel asteca = AstecaModel();

  // List<SubFuncionalitiesModel> subFuncionalities = [];
  // AstecaEnum state = AstecaEnum.notAsteca;

  // AstecaController();

  // Future<void> fetch(String id) async {
  //   asteca = await repository.fetch(id);
  // }

  // Future<void> fetchAll() async {
  //   astecas = await repository.fetchAll();
  // }

  // Future<bool> updateastecaSubFuncionalities() async {
  //   return await repository.updateDepartmentSubFuncionalities(
  //       asteca, subFuncionalities);
  // }

  // Future<void> changeAstecaSubFuncionalities(AstecaModel asteca) async {
  //   subFuncionalities = await repository.fetchSubFuncionalities(asteca);
  // }

  // Future<bool> create() async {
  //   if (formKey.currentState!.validate()) {
  //     return await repository.create(asteca);
  //   }

  //   return false;
  // }

  // Future<bool> update() async {
  //   return await repository.update(asteca);
  // }

  // Future<bool> delete(AstecaModel asteca) async {
  //   return await repository.delete(asteca);
  // }

  // validate(value) {
  //   if (value.isEmpty) {
  //     return 'Campo obrigatório';
  //   }
  //   return null;
  // }

  camelCaseAll(String? value) {
    String? nome = '';
    value!.split(" ").forEach((element) {
      if (element.length > 3) {
        nome = nome! + " ${toBeginningOfSentenceCase(element.toString().toLowerCase())}";
      } else {
        nome = nome! + " ${element.toString().toLowerCase()}";
      }
    });
    return nome;
  }

  camelCaseFirst(String? value) {
    return toBeginningOfSentenceCase(value.toString().toLowerCase());
  }

  //

}
