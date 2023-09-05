import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/mapa_carga/controller/mapa_carga_consulta_controller.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class MapaCargaConsultaViewDesktop extends StatelessWidget {
  const MapaCargaConsultaViewDesktop({Key? key}) : super(key: key);

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
                          return Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: CardWidget(
                                color: controller.mapasCarga[index].mapaCargaEvento?.length != 0
                                    ? HexColor(
                                        controller.mapasCarga[index].mapaCargaEvento?.last.eventoStatus?.statusCor ?? '#040491')
                                    : primaryColor,
                                widget: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: TextComponent(
                                              'ID',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                              child: TextComponent(
                                            'Filial de origem',
                                            fontWeight: FontWeight.bold,
                                          )),
                                          Expanded(
                                              child: TextComponent(
                                            controller.mapasCarga[index].filialDestino?.id_filial != null
                                                ? 'Filial de destino'
                                                : 'Tipo mapa',
                                            fontWeight: FontWeight.bold,
                                          )),
                                          Expanded(
                                              child: TextComponent(
                                            'Transportadora',
                                            fontWeight: FontWeight.bold,
                                          )),
                                          Expanded(
                                              child: TextComponent(
                                            'Data de criação',
                                            fontWeight: FontWeight.bold,
                                          )),
                                          Expanded(
                                              flex: 2,
                                              child: TextComponent(
                                                'Funcionário',
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: TextComponent(
                                                'Status',
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Expanded(
                                              child: TextComponent(
                                            'Ações',
                                            fontWeight: FontWeight.bold,
                                          ))
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
                                                  controller.mapasCarga[index].idMapaCarga.toString(),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: SelectableText(
                                                controller.mapasCarga[index].filialOrigem?.id_filial.toString() ?? ''),
                                          ),
                                          Expanded(
                                            child: SelectableText(
                                                controller.mapasCarga[index].filialDestino?.id_filial.toString() != null
                                                    ? controller.mapasCarga[index].filialDestino!.id_filial.toString()
                                                    : controller.mapasCarga[index].tipoEntrega == 1
                                                        ? "Cliente"
                                                        : "Filial"),
                                          ),
                                          Expanded(
                                            child: SelectableText(
                                                '${controller.mapasCarga[index].transportadora?.idTransportadora?.toString() ?? 'Sem ID'} - ${controller.mapasCarga[index].transportadora?.contato?.toString().capitalize ?? 'Sem nome'}'),
                                          ),
                                          Expanded(
                                              child: SelectableText(
                                            DateFormat('dd/MM/yyyy').format(controller.mapasCarga[index].dataEmissao!),
                                          )),
                                          Expanded(
                                            flex: 2,
                                            child: SelectableText(controller
                                                    .mapasCarga[index].funcionario?.clienteFunc?.cliente?.nome
                                                    .toString()
                                                    .capitalize ??
                                                ''),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                EventoStatusWidget(
                                                  color: controller.mapasCarga[index].mapaCargaEvento?.length != 0
                                                      ? HexColor(controller
                                                              .mapasCarga[index].mapaCargaEvento?.last.eventoStatus?.statusCor ??
                                                          '#040491')
                                                      : null,
                                                  texto: controller.mapasCarga[index].mapaCargaEvento?.length != 0
                                                      ? controller
                                                              .mapasCarga[index].mapaCargaEvento?.last.eventoStatus?.descricao ??
                                                          ''
                                                      : 'Aguardando status',
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: ButtonAcaoWidget(
                                              detalhe: () {
                                                Get.toNamed('/mapa-carga/${controller.mapasCarga[index].idMapaCarga}');

                                                Get.delete<MapaCargaConsultaController>();
                                              },
                                            ),
                                            // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                          )
                                        ],
                                      )
                                    ])),
                              ));
                        },
                      ),
                    )
                  : LoadingComponent()),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
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
