import 'package:get/get.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/repositories/PecaRepository.dart';

class PecaDetalheController extends GetxController {
  late int id;
  late PecaRepository pecaRepository;
  var carregando = false.obs;
  var menu = 1.obs;
  late PecasModel peca;

  PecaDetalheController(id) {
    this.id = id;
    this.pecaRepository = PecaRepository();
    this.peca = PecasModel();
  }

  @override
  void onInit() async {
    await buscarPeca();
    super.onInit();
  }

  buscarPeca() async {
    try {
      carregando(true);

      this.peca = await pecaRepository.buscarPeca(this.id);
    } catch (e) {
    } finally {
      carregando(false);
    }
  }
}
