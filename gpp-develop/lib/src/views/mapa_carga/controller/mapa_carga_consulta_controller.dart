import 'package:flutter/material.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/mapa_carga_model.dart';
import 'package:gpp/src/repositories/mapa_carga_repository.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MapaCargaConsultaController extends GetxController {
  String pesquisar = '';
  var carregando = true.obs;
  late MapaCargaRepository mapaCargaRepository;
  late List<MapaCargaModel> mapasCarga;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PaginaModel pagina;
  late MaskFormatter maskFormatter = MaskFormatter();
  int marcados = 0;
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  MapaCargaConsultaController() {
    mapaCargaRepository = MapaCargaRepository();
    mapasCarga = <MapaCargaModel>[].obs;
    pagina = PaginaModel(atual: 1, total: 0);
  }

  @override
  void onInit() async {
    buscarMapasCarga();
    super.onInit();
  }

  buscarMapasCarga() async {
    try {
      carregando(true);

      var retorno = await mapaCargaRepository.buscarMapasCarga(
        this.pagina.atual,
      );

      this.mapasCarga = retorno[0];
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
