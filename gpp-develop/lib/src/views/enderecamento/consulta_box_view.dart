import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/controllers/consulta_box_controller.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';

import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class ConsultaBoxView extends StatelessWidget {
  const ConsultaBoxView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConsultaBoxController());

    return Scaffold(
      appBar: NavbarWidget(),
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Sidebar(),
            Expanded(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(child: TitleComponent('Consulta Box')),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                  child: InputComponent(
                                hintText: 'Buscar',
                                onFieldSubmitted: (value) {
                                  controller.pesquisar = value;
                                  controller.buscarBoxes();
                                },
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => !controller.carregando.value
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: ListView.builder(
                                itemCount: controller.boxes.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: CardWidget(
                                      widget: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    TextComponent(
                                                      'ID Box',
                                                      fontWeight: FontWeight.bold,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: TextComponent(
                                                'Volume Total',
                                                fontWeight: FontWeight.bold,
                                              )),
                                              Expanded(
                                                  child: TextComponent(
                                                'Volume Utilizado',
                                                fontWeight: FontWeight.bold,
                                              )),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    SelectableText(
                                                      '${controller.boxes[index].idBox}',
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: SelectableText(
                                                controller.boxes[index].volumeTotal.toString(),
                                              )),
                                              Expanded(
                                                  child: SelectableText(
                                                controller.boxes[index].volumeUtilizado.toString(),
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : LoadingComponent(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                    child: GetBuilder<ConsultaBoxController>(
                      builder: (_) => PaginacaoComponent(
                        total: controller.pagina.getTotal(),
                        atual: controller.pagina.getAtual(),
                        primeiraPagina: () {
                          controller.pagina.primeira();
                          controller.buscarBoxes();
                        },
                        anteriorPagina: () {
                          controller.pagina.anterior();
                          controller.buscarBoxes();
                        },
                        proximaPagina: () {
                          controller.pagina.proxima();
                          controller.buscarBoxes();
                        },
                        ultimaPagina: () {
                          controller.pagina.ultima();
                          controller.buscarBoxes();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
