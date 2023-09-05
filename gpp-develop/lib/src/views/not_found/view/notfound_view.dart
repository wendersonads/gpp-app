import 'package:flutter/material.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/not_found/controller/not_found_controller.dart';
import 'package:get/get.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotFoundController());
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 460,
                      child: Image.asset('lib/src/shared/assets/not_found.png'),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    TextComponent(
                      'Ops, página não encontrada, tente novamente !',
                      fontSize: context.textScaleFactor * 24,
                    ),
                    SizedBox(height: 8),
                    Obx(() => controller.carregando.value
                        ? LoadingComponent()
                        : Container())
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
