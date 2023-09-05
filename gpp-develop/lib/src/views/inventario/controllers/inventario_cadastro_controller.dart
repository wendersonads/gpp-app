import 'package:get/get.dart';
import 'package:gpp/src/models/corredor_enderecamento_model.dart';
import 'package:gpp/src/models/estante_enderecamento_model.dart';
import 'package:gpp/src/models/inventario/inventario_model.dart';
import 'package:gpp/src/repositories/inventario/inventario_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';

import '../../../models/box_enderecamento_model.dart';
import '../../../models/piso_enderecamento_model.dart';
import '../../../models/prateleira_enderecamento_model.dart';
import '../../../repositories/enderecamento_repository.dart';

class InventarioCadastroController extends GetxController {
  var carregando = false.obs;
  var carregandoDados = false.obs;
  var pontinhos = ''.obs;
  int count = 0;

  //Piso
  late EnderecamentoRepository enderecamentoRepository;
  RxList<PisoEnderecamentoModel> pisos = <PisoEnderecamentoModel>[].obs;
  Rxn<PisoEnderecamentoModel> piso = Rxn<PisoEnderecamentoModel>(null);

  //Corredor
  RxList<CorredorEnderecamentoModel> corredores =
      <CorredorEnderecamentoModel>[].obs;
  Rxn<CorredorEnderecamentoModel> corredor =
      Rxn<CorredorEnderecamentoModel>(null);

  //Estante
  RxList<EstanteEnderecamentoModel> estantes =
      <EstanteEnderecamentoModel>[].obs;
  Rxn<EstanteEnderecamentoModel> estante = Rxn<EstanteEnderecamentoModel>(null);

  //Prateleira
  RxList<PrateleiraEnderecamentoModel> prateleiras =
      <PrateleiraEnderecamentoModel>[].obs;
  Rxn<PrateleiraEnderecamentoModel> prateleira =
      Rxn<PrateleiraEnderecamentoModel>(null);

  //Box
  RxList<BoxEnderecamentoModel> boxs = <BoxEnderecamentoModel>[].obs;
  Rxn<BoxEnderecamentoModel> box = Rxn<BoxEnderecamentoModel>(null);

  late InventarioRepository inventarioRepository;

  InventarioCadastroController() {
    inventarioRepository = new InventarioRepository();
    enderecamentoRepository = EnderecamentoRepository();
  }

  @override
  void onInit() async {
    await buscarPisos();
    super.onInit();
  }

  pontinhosLoading() async {
    if (count > 3) {
      pontinhos('');
      count = 0;
    }
    await Future.delayed(const Duration(milliseconds: 500));
    pontinhos(pontinhos.value += '.');
    update();
    count++;
    await pontinhos();
  }

  cadastrarInventario() async {
    try {
      carregando(true);

      //chama a API para cadastro
      await inventarioRepository
          .criarInventario(new InventarioModel(piso: piso.value));
      Get.offAllNamed('/inventario');
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
    }
  }

  buscarPisos() async {
    try {
      carregandoDados(true);

      pisos.value = await enderecamentoRepository.buscarPisos();
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoDados(false);
    }
  }

  buscarCorredor() async {
    try {
      carregandoDados(true);

      corredores.value =
          await enderecamentoRepository.buscarCorredor(piso.value!.id_piso!);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoDados(false);
    }
  }

  buscarEstantes() async {
    try {
      carregandoDados(true);

      estantes.value = await enderecamentoRepository
          .buscarEstante(piso.value!.corredor!.id_corredor!);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoDados(false);
    }
  }

  buscarPrateleiras() async {
    try {
      carregandoDados(true);

      prateleiras.value = await enderecamentoRepository
          .buscarPrateleira(piso.value!.corredor!.estante!.id_estante!);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoDados(false);
    }
  }

  buscarBoxs() async {
    try {
      carregandoDados(true);

      boxs.value = await enderecamentoRepository
          .buscarBox(piso.value!.corredor!.estante!.prateleira!.id_prateleira!);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoDados(false);
      update();
    }
  }

  limparCampos() {
    try {
      piso.value = null;
      corredor.value = null;
      estante.value = null;
      prateleira.value = null;
      box.value = null;

      buscarPisos();
      carregandoDados(true);

      corredores.value = [];
      estantes.value = [];
      prateleiras.value = [];
      boxs.value = [];
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoDados(false);
      update();
    }
  }
}
