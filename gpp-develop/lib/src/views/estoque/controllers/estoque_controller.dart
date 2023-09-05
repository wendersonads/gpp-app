import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/box_enderecamento_model.dart';
import 'package:gpp/src/models/corredor_enderecamento_model.dart';
import 'package:gpp/src/models/estante_enderecamento_model.dart';
import 'package:gpp/src/models/pecas_model/pecas_estoque_model.dart';
import 'package:gpp/src/models/piso_enderecamento_model.dart';
import 'package:gpp/src/models/prateleira_enderecamento_model.dart';
import 'package:gpp/src/repositories/PecaRepository.dart';
import 'package:gpp/src/repositories/enderecamento_repository.dart';

import 'package:gpp/src/repositories/pecas_repository/peca_estoque_repository.dart';

import '../../../utils/notificacao.dart';

class EstoqueController extends GetxController {
  String buscar = '';
  String endereco = '';
  var filtro = false.obs;
  var carregando = true.obs;
  var carregandoPisos = false.obs;
  var carregandoCorredores = false.obs;
  var carregandoEstantes = false.obs;
  var carregandoPrateleira = false.obs;
  var carregandoBoxs = false.obs;
  late PecaEstoqueRepository pecaEstoqueRepository;
  late PecaRepository pecaRepository;
  late List<PecasEstoqueModel> pecaEstoques;

  String? idProduto;

  late EnderecamentoRepository enderecamentoRepository;
  late List<PisoEnderecamentoModel> pisos;
  late PisoEnderecamentoModel? piso;
  late List<CorredorEnderecamentoModel> corredores;
  late CorredorEnderecamentoModel? corredor;
  late List<EstanteEnderecamentoModel> estantes;
  late EstanteEnderecamentoModel? estante;
  late List<PrateleiraEnderecamentoModel> prateleiras;
  late PrateleiraEnderecamentoModel? prateleira;
  late List<BoxEnderecamentoModel> boxs;
  late BoxEnderecamentoModel? box;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PaginaModel pagina;

  int marcados = 0;

  EstoqueController() {
    enderecamentoRepository = EnderecamentoRepository();
    pecaRepository = PecaRepository();
    pecaEstoqueRepository = PecaEstoqueRepository();
    pisos = <PisoEnderecamentoModel>[].obs;
    piso = PisoEnderecamentoModel();
    corredores = <CorredorEnderecamentoModel>[].obs;
    corredor = CorredorEnderecamentoModel();
    estantes = <EstanteEnderecamentoModel>[].obs;
    estante = EstanteEnderecamentoModel();
    prateleiras = <PrateleiraEnderecamentoModel>[].obs;
    prateleira = PrateleiraEnderecamentoModel();
    boxs = <BoxEnderecamentoModel>[].obs;
    box = BoxEnderecamentoModel();
    pecaEstoques = [];
    pagina = PaginaModel(atual: 1, total: 0);
  }

  @override
  void onInit() async {
    await buscarPecaEstoques();

    super.onInit();
  }

  limparFiltro() {
    piso = PisoEnderecamentoModel();
    corredor = CorredorEnderecamentoModel();
    estante = EstanteEnderecamentoModel();
    prateleira = PrateleiraEnderecamentoModel();
    box = BoxEnderecamentoModel();
    endereco = '';
  }

  Future<void> buscarPecaEstoques() async {
    try {
      carregando(true);

      var retorno = await pecaEstoqueRepository.buscarPecaEstoques(pagina.atual,
          buscar: buscar, endereco: endereco);

      this.pecaEstoques = retorno[0];
      this.pagina = retorno[1];

      // Alerta informando que não há peças vinculadas ao estoque informado
      if (this.pecaEstoques.length == 0) {
        Notificacao.snackBar('Endereço não possui peça vinculada',
            tipoNotificacao: TipoNotificacaoEnum.error);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      update();
    }
  }

  buscarPisos() async {
    try {
      carregandoPisos(true);

      pisos = await enderecamentoRepository.buscarPisos();
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoPisos(false);
      update();
    }
  }

  buscarCorredor(int idPiso) async {
    try {
      carregandoCorredores(true);
      corredores = await enderecamentoRepository.buscarCorredor(piso!.id_piso!);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoCorredores(false);
      update();
    }
  }

  buscarEstantes(int idCorredor) async {
    try {
      carregandoEstantes(true);
      estantes = await enderecamentoRepository.buscarEstante(idCorredor);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoEstantes(false);
      update();
    }
  }

  buscarPrateleiras(int idEstante) async {
    try {
      carregandoPrateleira(true);
      prateleiras = await enderecamentoRepository.buscarPrateleira(idEstante);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoPrateleira(false);
      update();
    }
  }

  buscarBoxs(int idPrateleira) async {
    try {
      carregandoBoxs(true);
      boxs = await enderecamentoRepository.buscarBox(idPrateleira);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoBoxs(false);
      update();
    }
  }
}
