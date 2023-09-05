// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gpp/src/enums/inventario_status_enum.dart';
import 'package:gpp/src/models/inventario/inventario_local_peca_model.dart';
import 'package:gpp/src/models/inventario/inventario_peca_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../controllers/inventario_detalhe_controller.dart';

class InventarioDetalheView extends StatelessWidget {
  int id;
  InventarioDetalheView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InventarioDetalheController(id));

    return SafeArea(
      child: Scaffold(
        appBar: NavbarWidget(),
        drawer: Sidebar(),
        backgroundColor: Colors.white,
        body: WillPopScope(
          child: Row(
            children: [
              context.width > 576 ? Sidebar() : Container(),
              Expanded(
                child: Container(
                  height: context.height,
                  margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: context.width,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Inventário de estoque',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  ToggleSwitch(
                                    customWidths: [90.0, 50.0],
                                    cornerRadius: 20.0,
                                    initialLabelIndex: controller.multiplicar.value,
                                    activeBgColors: [
                                      [primaryColor],
                                      [Colors.redAccent]
                                    ],
                                    activeFgColor: Colors.white,
                                    inactiveBgColor: Colors.grey,
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    labels: ['Multiplicar', ''],
                                    icons: [null, FontAwesomeIcons.times],
                                    onToggle: (index) {
                                      log(index.toString());
                                      controller.multiplicar(index);
                                    },
                                  ),
                                ],
                              ),
                              Form(
                                key: controller.formKey,
                                child: Wrap(
                                  runSpacing: 10,
                                  children: [
                                    Container(
                                      width: context.width,
                                      child: InputComponent(
                                        keyboardType: TextInputType.number,
                                        hintText: 'Informe o código da peça',
                                        // onChanged: (value) async {
                                        //   controller.buscarInventarioPeca(value);
                                        // },
                                        onFieldSubmitted: (value) {
                                          controller.biparPeca(value);
                                        },
                                        onSaved: (value) {
                                          controller.codigo = value;
                                        },
                                      ),
                                    ),
                                    Container(
                                        width: context.width,
                                        child: ButtonComponent(
                                            onPressed: () async {
                                              if (controller.formKey.currentState!.validate()) {
                                                controller.formKey.currentState!.save();
                                                controller.biparPeca(controller.codigo);
                                              }
                                            },
                                            text: 'Contar')),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        Container(
                          height: context.height * 0.50,
                          width: context.width,
                          child: Obx(() => !controller.carregando.value
                              ? ListView.builder(
                                  controller: controller.scrollController,
                                  itemCount: controller.inventario.pecas.length,
                                  itemBuilder: (context, index) {
                                    return CardInventario(inventarioPeca: controller.inventario.pecas[index]);
                                  },
                                )
                              : LoadingComponent()),
                        ),
                        Obx(
                          () => !controller.carregando.value && controller.inventario.pecas.length > 0
                              ? controller.inventario.evento.idEventoStatus != InventarioStatusEnum.CANCELADO &&
                                      controller.inventario.evento.idEventoStatus != InventarioStatusEnum.CONCLUIDO
                                  ? Container(
                                      margin: EdgeInsets.symmetric(vertical: 24),
                                      width: context.width,
                                      child: Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.spaceBetween, children: [
                                        Container(
                                          width: 80,
                                          child: ButtonComponent(
                                              color: vermelhoColor,
                                              text: 'Cancelar',
                                              onPressed: () async {
                                                await controller.cancelarInventario();
                                              }),
                                        ),
                                        Container(
                                          child: Wrap(
                                            spacing: 10,
                                            children: [
                                              Container(
                                                width: 80,
                                                child: Obx(
                                                  () => ButtonComponent(
                                                    color:
                                                        controller.contagemCompleta.value ? primaryColor : Colors.grey.shade400,
                                                    text: 'Finalizar',
                                                    onPressed: () async {
                                                      if (controller.contagemCompleta.value) {
                                                        await controller.finalizarInventario();
                                                      }
                                                    },
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                    )
                                  : Container()
                              : Container(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          onWillPop: () async => await Get.toNamed('/inventario'),
        ),
      ),
    );
  }
}

class CardInventario extends StatelessWidget {
  InventarioLocalPecaModel inventarioPeca;
  CardInventario({Key? key, required this.inventarioPeca}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventarioDetalheController>();

    return Container(
      height: 240,
      margin: EdgeInsets.only(top: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
              padding: EdgeInsets.all(8),
              child: Container(
                child: Row(
                  children: [
                    Container(
                      width: 160,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Cód. Peça: ',
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${inventarioPeca.idPeca}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        )),
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
                                    text: 'Descrição: ',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '${inventarioPeca.descricaoPeca}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                          )),
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
                                    text: 'Endereço: ',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '${inventarioPeca.endereco}', style: TextStyle(fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Disponível: ',
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${inventarioPeca.quantidadeDisponivel}',
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
                              RichText(
                                text: TextSpan(
                                  text: 'Reservado: ',
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${inventarioPeca.quantidadeReservada}',
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
                              RichText(
                                text: TextSpan(
                                  text: 'Total: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: inventarioPeca.total.toString(), style: TextStyle(fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (inventarioPeca.quantidadeContada > 0) {
                                      inventarioPeca.removeQuantidadeContada = 1;
                                      controller.ajustarPeca(inventarioPeca);
                                    }
                                  },
                                  child: Container(
                                    child: Icon(
                                      Icons.remove,
                                      size: 32,
                                      color: inventarioPeca.quantidadeContada == 0 ? Colors.transparent : vermelhoColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    inventarioPeca.quantidadeContada = 0;
                                    await controller.ajustarPeca(inventarioPeca);
                                  },
                                  child: Container(
                                    child: Icon(
                                      Icons.delete,
                                      size: 32,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    inventarioPeca.addQuantidadeContada = 1;
                                    controller.ajustarPeca(inventarioPeca);
                                  },
                                  child: Container(
                                    child: Icon(
                                      Icons.add,
                                      size: 32,
                                      color: secundaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
              left: 280,
              top: -10,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    color: inventarioPeca.quantidadeContada <
                            (inventarioPeca.quantidadeDisponivel + inventarioPeca.quantidadeReservada)
                        ? Colors.redAccent
                        : secundaryColor,
                    borderRadius: BorderRadius.circular(50)),
                child: Center(
                  child: Text(
                    '${inventarioPeca.quantidadeContada}',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// Widget _buildQrView(BuildContext context) {
//   // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//   var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
//   // To ensure the Scanner view is properly sizes after rotation
//   // we need to listen for Flutter SizeChanged notification and update controller
//   return QRView(
//     key: qrKey,
//     onQRViewCreated: (QRViewController controller) => {},
//     overlay:
//         QrScannerOverlayShape(borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
//     onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//   );
// }

// final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

// void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//   print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
//   if (!p) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('no Permission')),
//     );
//   }
// }
