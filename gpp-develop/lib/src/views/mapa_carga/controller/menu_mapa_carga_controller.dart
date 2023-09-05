import 'package:get/get.dart';
import 'package:gpp/src/views/mapa_carga/controller/mapa_carga_detalhe_controller.dart';

class MenuMapaCargaController extends GetxController {
  var selected = 1.obs;
  var isLoading = false.obs;

  MenuMapaCargaController() {}

  validaRota() {
    isLoading.value = true;
    selected.value = 2;
    Get.delete<MapaCargaDetalheController>();
    Get.offAllNamed('/mapa-carga-consultar');
    isLoading.value = false;
    update();
  }
}
