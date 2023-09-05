import 'package:get/get.dart';
import 'package:gpp/src/models/inventario/inventario_model.dart';
import 'package:gpp/src/repositories/inventario/inventario_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';

class InventarioController extends GetxController {
  var carregando = false.obs;

  late List<InventarioModel> inventarios;
  late InventarioRepository inventarioRepository;
  var situacao = 0.obs;

  InventarioController() {
    inventarios = <InventarioModel>[].obs;
    inventarioRepository = new InventarioRepository();
  }
  @override
  void onInit() async {
    await buscarInventarios();
    super.onInit();
  }

  buscarInventarios() async {
    try {
      carregando(true);
      inventarios = await inventarioRepository.buscarInventarios(situacao.value);
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
    }
  }
}
