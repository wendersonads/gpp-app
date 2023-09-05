// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/enums/inventario_status_enum.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../models/inventario/inventario_model.dart';
import '../../widgets/evento_status_widget.dart';
import '../controllers/inventario_controller.dart';

class InventarioView extends StatelessWidget {
  const InventarioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InventarioController());
    return SafeArea(
      child: Scaffold(
        appBar: NavbarWidget(),
        drawer: Sidebar(),
        backgroundColor: Colors.white,
        body: Row(
          children: [
            context.width > 576 ? Sidebar() : Container(),
            Container(
              height: context.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: context.width,
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 10,
                        children: [
                          Container(
                            width: context.width * 0.40,
                            child: Text(
                              'Inventário de estoque',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ),
                          Container(
                            width: 140,
                            child: ButtonComponent(
                                text: 'Criar inventário',
                                onPressed: () {
                                  Get.offAllNamed('inventario-cadastro');
                                }),
                          )
                        ],
                      ),
                    ),
                    ToggleSwitch(
                      customWidths: [60.0, 70.0, 90.0, 90.0],
                      cornerRadius: 5.0,
                      initialLabelIndex: controller.situacao.value,
                      activeBgColors: [
                        [secundaryColor],
                        [primaryColor],
                        [HexColor('00CF08')],
                        [HexColor('CD001A')],
                      ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 4,
                      customTextStyles: [TextStyle(fontWeight: FontWeight.w500, color: Colors.white)],
                      labels: ['Todos', 'Abertos', 'Concluídos', 'Cancelados'],
                      //icons: [null, FontAwesomeIcons.times],
                      onToggle: (index) async {
                        switch (index) {
                          case 0:
                            controller.situacao(0);
                            await controller.buscarInventarios();
                            break;
                          case 1:
                            controller.situacao(InventarioStatusEnum.EM_ABERTO);
                            await controller.buscarInventarios();
                            break;
                          case 2:
                            controller.situacao(InventarioStatusEnum.CONCLUIDO);
                            await controller.buscarInventarios();
                            break;
                          case 3:
                            controller.situacao(InventarioStatusEnum.CANCELADO);
                            await controller.buscarInventarios();
                            break;
                          default:
                            controller.situacao(0);
                            await controller.buscarInventarios();
                            break;
                        }
                      },
                    ),
                    Container(
                      height: context.height * 0.70,
                      width: context.width,
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Obx(
                        () => !controller.carregando.value
                            ? ListView.builder(
                                itemCount: controller.inventarios.length,
                                itemBuilder: (context, index) {
                                  return CardInventario(inventario: controller.inventarios[index]);
                                },
                              )
                            : LoadingComponent(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardInventario extends StatelessWidget {
  late InventarioModel inventario;
  CardInventario({Key? key, required this.inventario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        inventario.inventarioEvento!.last.eventoStatus!.id_evento_status != InventarioStatusEnum.CANCELADO &&
                inventario.inventarioEvento!.last.eventoStatus!.id_evento_status != InventarioStatusEnum.CONCLUIDO
            ? Get.offAllNamed('/inventario/${inventario.id_inventario.toString()}')
            : Get.offAllNamed('/inventario-resultado/${inventario.id_inventario.toString()}');
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          width: context.width * 0.90,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: context.width,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 160,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Código inventário: ',
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${inventario.id_inventario.toString()}',
                                        style: TextStyle(fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Funcionário: ',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              '${inventario.funcionario?.clienteFunc?.cliente?.nome.toString().capitalize ?? ''}',
                                          style: TextStyle(fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Local: ',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '${inventario.endereco ?? ''}', style: TextStyle(fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    EventoStatusWidget(
                      color: inventario.inventarioEvento?.length != 0
                          ? HexColor(inventario.inventarioEvento?.last.eventoStatus?.statusCor ?? '#040491')
                          : null,
                      texto: inventario.inventarioEvento?.length != 0
                          ? inventario.inventarioEvento?.last.eventoStatus?.descricao ?? ''
                          : 'Aguardando status',
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
