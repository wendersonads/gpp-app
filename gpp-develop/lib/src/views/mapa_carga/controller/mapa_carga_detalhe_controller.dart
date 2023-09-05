import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/mapa_carga_model.dart';
import 'package:gpp/src/models/motivo_cancelamento_carga_model.dart';

import 'package:gpp/src/repositories/mapa_carga_repository.dart';
import 'package:gpp/src/repositories/motivo_cancelamento_carga_repository.dart';

import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';

class MapaCargaDetalheController extends GetxController {
  late int id;
  var carregando = true.obs;
  var carregandoFinalizar = false.obs;
  var carregandoMotivosCancelamento = false.obs;
  var carregandoCancelar = false.obs;

  /* Variáveis para lidar com a lógica de fechamento do mapa de carga */
  var stepAtivo = 0.obs;
  var mapaCompletamenteEntregue = true.obs;

  late MapaCargaRepository mapaCargaRepository;
  late MotivoCancelamentoCargaRepository motivoCancelamentoCargaRepository;
  late MapaCargaModel mapaCarga;

  late List<MotivoCancelamentoCargaModel> motivosCancelamento;

  late MaskFormatter maskFormatter;
  late GlobalKey<FormState> formKey;
  int marcados = 0;

  MapaCargaDetalheController(int id) {
    mapaCargaRepository = MapaCargaRepository();
    motivoCancelamentoCargaRepository = MotivoCancelamentoCargaRepository();

    mapaCarga = MapaCargaModel();
    motivosCancelamento = [];

    formKey = GlobalKey<FormState>();
    maskFormatter = MaskFormatter();
    this.id = id;
  }

  @override
  void onInit() async {
    await buscarMapaCarga();
    super.onInit();
  }

  buscarMapaCarga() async {
    try {
      carregando(true);
      this.mapaCarga = await mapaCargaRepository.buscarMapaCarga(this.id);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
    }
  }

  buscarMotivosCancelamentoCarga() async {
    try {
      carregandoMotivosCancelamento(true);
      this.motivosCancelamento =
          await motivoCancelamentoCargaRepository.buscarMotivosCancelamento();
    } catch (e) {
      Notificacao.snackBar(
        e.toString(),
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
    } finally {
      carregandoMotivosCancelamento(false);
    }
  }

  Future<bool> cancelarMapaCarga(MapaCargaModel mapaCarga) async {
    try {
      carregandoCancelar(true);
      if (await mapaCargaRepository.cancelarMapaCarga(mapaCarga)) {
        Notificacao.snackBar('Mapa de carga cancelado com sucesso!');
        await buscarMapaCarga();
        return true;
      }

      return false;
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);

      return false;
    } finally {
      carregandoCancelar(false);
    }
  }

  Future<bool> finalizarMapaCarga(int idMapaCarga, bool sucesso) async {
    try {
      carregandoFinalizar(true);
      if (await mapaCargaRepository.finalizarMapaCarga(idMapaCarga, sucesso)) {
        Notificacao.snackBar('Mapa de carga finalizado com sucesso');
        await buscarMapaCarga();
        return true;
      }

      return false;
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);

      return false;
    } finally {
      carregandoFinalizar(false);
    }
  }
}
