import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/models/box_enderecamento_model.dart';
import 'package:gpp/src/models/corredor_enderecamento_model.dart';
import 'package:gpp/src/models/estante_enderecamento_model.dart';
import 'package:gpp/src/models/pecas_model/pecas_estoque_model.dart';
import 'package:gpp/src/models/piso_enderecamento_model.dart';
import 'package:gpp/src/models/prateleira_enderecamento_model.dart';
import 'package:gpp/src/repositories/PecaRepository.dart';
import 'package:gpp/src/repositories/enderecamento_repository.dart';
import 'package:gpp/src/repositories/movimento_estoque/ajuste_estoque_repository.dart';
import 'package:gpp/src/repositories/pecas_repository/peca_estoque_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';

class EstoqueDetalheController extends GetxController {
  var carregando = true.obs;
  late PecasEstoqueModel pecaEstoque;
  late PecasEstoqueModel pecaEstoqueTransferencia;
  late PecaEstoqueRepository pecaEstoqueRepository;
  late AjusteEstoqueRepository ajusteRepository;
  late int id;
  var etapa = 2.obs;
  var finalizando = false.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PecaRepository pecaRepository;

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

  var carregandoPisos = false.obs;
  var carregandoCorredores = false.obs;
  var carregandoEstantes = false.obs;
  var carregandoPrateleira = false.obs;
  var carregandoBoxs = false.obs;

  EstoqueDetalheController(int id) {
    pecaEstoque = PecasEstoqueModel();
    pecaEstoqueTransferencia = PecasEstoqueModel();
    pecaRepository = PecaRepository();
    pecaEstoqueRepository = PecaEstoqueRepository();
    ajusteRepository = AjusteEstoqueRepository();
    this.id = id;

    enderecamentoRepository = EnderecamentoRepository();

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
  }

  @override
  void onInit() async {
    super.onInit();
    await buscarPecaEstoque();
    buscarPisos();
  }

  @override
  void onClose() {
    super.onClose();
  }

  buscarPecaEstoque() async {
    try {
      carregando(true);
      this.pecaEstoque = await pecaEstoqueRepository.buscarPecaEstoque(id);
    } finally {
      carregando(false);
    }
  }

  buscarPisos() async {
    try {
      carregandoPisos(true);

      pisos = await enderecamentoRepository.buscarPisos();
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
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
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
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
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
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
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
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
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoBoxs(false);
      update();
    }
  }

  alterarEndereco(int idPeca, int idPecaEstoque, BoxEnderecamentoModel box) async {
    try {
      if (await pecaRepository.alterarEndereco(idPeca, idPecaEstoque, box)) {
        Notificacao.snackBar('Endereço alterado com sucesso!');
        Get.offAllNamed('/estoques');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      update();
    }
  }

  transferirEstoqueEndereco(int idPeca, int idPecaEstoque, PecasEstoqueModel pecaEstoque) async {
    try {
      if (await pecaEstoqueRepository.transferirEstoqueEndereco(idPeca, idPecaEstoque, pecaEstoque)) {
        Notificacao.snackBar('Estoque transferido com sucesso!');
        Get.offAllNamed('/estoques');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      update();
    }
  }

  removerEnderecamento(PecasEstoqueModel pecaEstoque) async {
    try {
      finalizando(true);
      if (await ajusteRepository.removerEnderecamento(pecaEstoque)) {
        Notificacao.snackBar('Operacão relizada com sucesso!');
        Get.offAllNamed('/estoques');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      finalizando(false);
      update();
    }
  }
}
