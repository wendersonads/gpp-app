// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/mapa_carga/controller/mapa_carga_consulta_controller.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class MapaCargaConsultaViewMobile extends StatelessWidget {
  MapaCargaConsultaViewMobile({Key? key}) : super(key: key);
  double FONTEBASE = 18;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapaCargaConsultaController());

    return Expanded(
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Obx(() => !controller.carregando.value
                  ? Container(
                      child: ListView.builder(
                        itemCount: controller.mapasCarga.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed('/mapa-carga/${controller.mapasCarga[index].idMapaCarga}');
                              Get.delete<MapaCargaConsultaController>();
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: CardWidget(
                                  color: controller.mapasCarga[index].mapaCargaEvento?.length != 0
                                      ? HexColor(
                                          controller.mapasCarga[index].mapaCargaEvento?.last.eventoStatus?.statusCor ?? '#040491')
                                      : primaryColor,
                                  widget: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Row(children: [
                                          TextComponent(
                                            'ID: ',
                                            fontWeight: FontWeight.bold,
                                            fontSize: FONTEBASE,
                                          ),
                                          SelectableText(
                                            controller.mapasCarga[index].idMapaCarga.toString(),
                                            style: TextStyle(
                                              fontSize: FONTEBASE,
                                            ),
                                          ),
                                          Expanded(child: SizedBox()),
                                          Row(
                                            children: [
                                              TextComponent(
                                                'Data de criação: ',
                                                fontWeight: FontWeight.bold,
                                                fontSize: FONTEBASE,
                                              ),
                                              SelectableText(
                                                DateFormat('dd/MM/yyyy').format(controller.mapasCarga[index].dataEmissao!),
                                                style: TextStyle(
                                                  fontSize: FONTEBASE,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextComponent(
                                              'Transportadora: ',
                                              fontWeight: FontWeight.bold,
                                              fontSize: FONTEBASE,
                                            ),
                                            SelectableText(
                                              '${controller.mapasCarga[index].transportadora?.idTransportadora?.toString() ?? 'Sem ID'} - ${controller.mapasCarga[index].transportadora?.contato?.toString().capitalize ?? 'Sem nome'}',
                                              style: TextStyle(
                                                fontSize: FONTEBASE,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextComponent(
                                                  'Status: ',
                                                  fontSize: FONTEBASE,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                Row(
                                                  children: [
                                                    EventoStatusWidget(
                                                      color: controller.mapasCarga[index].mapaCargaEvento?.length != 0
                                                          ? HexColor(controller.mapasCarga[index].mapaCargaEvento?.last
                                                                  .eventoStatus?.statusCor ??
                                                              '#040491')
                                                          : null,
                                                      texto: controller.mapasCarga[index].mapaCargaEvento?.length != 0
                                                          ? controller.mapasCarga[index].mapaCargaEvento?.last.eventoStatus
                                                                  ?.descricao ??
                                                              ''
                                                          : 'Aguardando status',
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Expanded(child: SizedBox()),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextComponent(
                                                  'Ações',
                                                  fontSize: FONTEBASE,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed('/mapa-carga/${controller.mapasCarga[index].idMapaCarga}');
                                                    Get.delete<MapaCargaConsultaController>();
                                                  },
                                                  child: Container(
                                                    constraints: BoxConstraints(minWidth: 50, maxWidth: 140),
                                                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                                    margin: EdgeInsets.only(right: 8),
                                                    decoration:
                                                        BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(6),
                                                      child: Icon(
                                                        Icons.visibility_rounded,
                                                        color: Colors.white,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                      ])),
                                )),
                          );
                        },
                      ),
                    )
                  : LoadingComponent()),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: GetBuilder<MapaCargaConsultaController>(
                builder: (_) => PaginacaoComponent(
                  total: controller.pagina.getTotal(),
                  atual: controller.pagina.getAtual(),
                  primeiraPagina: () {
                    controller.pagina.primeira();
                    controller.buscarMapasCarga();
                  },
                  anteriorPagina: () {
                    controller.pagina.anterior();
                    controller.buscarMapasCarga();
                  },
                  proximaPagina: () {
                    controller.pagina.proxima();
                    controller.buscarMapasCarga();
                  },
                  ultimaPagina: () {
                    controller.pagina.ultima();
                    controller.buscarMapasCarga();
                    ;
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
