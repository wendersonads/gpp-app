// ignore_for_file: must_call_super

import 'package:get/get.dart';

class NotFoundController extends GetxController {
  var carregando = false.obs;

  @override
  void onInit() async {
    await redirecionar();
  }

  void onClose() {
    super.onClose();
    Get.delete<NotFoundController>();
  }

  redirecionar() async {
    try {
      carregando(true);
      await Future.delayed(Duration(seconds: 3));
    } catch (e) {
    } finally {
      carregando(false);
      Get.offAllNamed('/login');
    }
  }
}
