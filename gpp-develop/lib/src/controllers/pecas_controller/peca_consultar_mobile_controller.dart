import 'package:get/get.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/repositories/PecaRepository.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PecaConsultarMobileController extends GetxController {
  late PecasModel? pecaModel;
  late PecaRepository repository;
  List<PecasModel> pecas = <PecasModel>[].obs;
  var idPeca = 0;
  var carregando = false.obs;
  var dialog = true.obs;

  PecaConsultarMobileController() {
    pecaModel = PecasModel();
    repository = PecaRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    getPecas();
  }

  buscarPeca() async {
    try {
      carregando(true);
      pecaModel = null;
      pecaModel = await repository.buscarPeca(idPeca);
      if (!pecas.any((element) => element.id_peca == (pecaModel?.id_peca ?? 0))) {
        pecas.add(await repository.buscarPeca(idPeca));
        if (pecas.length > 4) {
          pecas.removeAt(4);
          pecas.removeAt(3);
          pecas.insert(0, await repository.buscarPeca(idPeca));
        }
      }

      savePecas();
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
    }
  }

  savePecas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('savedPecas', pecas.map((e) => e.id_peca.toString()).toList());
  }

  getPecas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList('savedPecas');
    if (list != null) {
      list.forEach((element) async {
        pecas.add(await repository.buscarPeca(int.parse(element)));
      });
    }
  }
}
