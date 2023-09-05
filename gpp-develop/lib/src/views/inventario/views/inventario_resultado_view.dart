// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/inventario/inventario_peca_model.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';

import 'package:gpp/src/views/inventario/controllers/inventario_resultado_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class InventarioResultadoView extends StatelessWidget {
  int id;
  InventarioResultadoView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InventarioResultadoController(this.id));

    return SafeArea(
      child: Scaffold(
        appBar: NavbarWidget(),
        drawer: Sidebar(),
        backgroundColor: Colors.white,
        body: WillPopScope(
          onWillPop: () async => await Get.toNamed('/inventario'),
          child: Row(
            children: [
              context.width > 576 ? Sidebar() : Container(),
              Obx(
                () => !controller.carregando.value
                    ? Container(
                        height: context.height,
                        width: context.width * 0.85,
                        margin: EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: context.width,
                                child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runSpacing: 10,
                                  spacing: 10,
                                  children: [
                                    Container(
                                      width: context.width,
                                      child: Text(
                                        'Resultado inventário',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16,
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
                                        hintText: 'Buscar por código da peça',
                                        onChanged: (value) async {
                                          controller.buscarInventarioPeca(value);
                                        },
                                        onFieldSubmitted: (value) {
                                          controller.buscarInventarioPeca(value);
                                        },
                                        onSaved: (value) {
                                          controller.codigo = value;
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Informe um código';
                                          }
                                        },
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            controller.formKey.currentState!.save();
                                            if (controller.formKey.currentState!.validate()) {
                                              controller.buscarInventarioPeca(controller.codigo.toString());
                                            }
                                          },
                                          icon: Icon(
                                            Icons.search,
                                            color: secundaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   width: context.width,
                                    //   child: ButtonComponent(
                                    //       onPressed: () async {
                                    //         if (controller.formKey.currentState!.validate()) {
                                    //           controller.formKey.currentState!.save();
                                    //           controller.buscarInventarioPeca(controller.codigo);
                                    //         }
                                    //       },
                                    //       text: 'Pesquisar'),
                                    // ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 16),
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                              Container(
                                height: context.height * 0.58,
                                width: context.width,
                                child: Obx(
                                  () => !controller.carregando.value
                                      ? controller.inventarioBusca!.inventarioPeca != null &&
                                              controller.inventarioBusca!.inventarioPeca!.length > 0
                                          ? ListView.builder(
                                              itemCount: controller.inventarioBusca?.inventarioPeca?.length ?? 0,
                                              itemBuilder: (context, index) {
                                                return CardInventario(
                                                    inventarioPeca: controller.inventarioBusca!.inventarioPeca![index]);
                                              },
                                            )
                                          : ListView.builder(
                                              itemCount: controller.inventario?.inventarioPeca?.length ?? 0,
                                              itemBuilder: (context, index) {
                                                return CardInventario(
                                                  inventarioPeca: controller.inventario!.inventarioPeca![index],
                                                );
                                              },
                                            )
                                      : LoadingComponent(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        height: context.height,
                        width: context.width * 0.85,
                        margin: EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: LoadingComponent(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardInventario extends StatelessWidget {
  InventarioPecaModel inventarioPeca;

  CardInventario({Key? key, required this.inventarioPeca}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
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
                                      text: '${inventarioPeca.peca!.id_peca}', style: TextStyle(fontWeight: FontWeight.normal)),
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
                                        text: '${inventarioPeca.peca!.descricao}',
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
                                  text: 'Endereço: ',
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(text: '${inventarioPeca.endereco}', style: TextStyle(fontWeight: FontWeight.normal)),
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
                                      text: '${inventarioPeca.qtd_disponivel}', style: TextStyle(fontWeight: FontWeight.normal)),
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
                                      text: '${inventarioPeca.qtd_reservado}', style: TextStyle(fontWeight: FontWeight.normal)),
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
                                text: 'Contado: ',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '${inventarioPeca.qtd_contada}', style: TextStyle(fontWeight: FontWeight.normal)),
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
                                      text: (inventarioPeca.qtd_reservado! + inventarioPeca.qtd_disponivel!).toString(),
                                      style: TextStyle(fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 200,
            top: 15,
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 30,
                  decoration: BoxDecoration(
                      color:
                          ((inventarioPeca.qtd_contada! - inventarioPeca.qtd_disponivel! + inventarioPeca.qtd_reservado!)) * 1 < 0
                              ? vermelhoColor
                              : ((inventarioPeca.qtd_contada! - inventarioPeca.qtd_disponivel! + inventarioPeca.qtd_reservado!)) *
                                          1 >
                                      0
                                  ? secundaryColor
                                  : primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      'Diferença: ${((inventarioPeca.qtd_contada! - inventarioPeca.qtd_disponivel! + inventarioPeca.qtd_reservado!)) * 1} ',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),

          // Positioned(
          //   left: 250,
          //   top: -10,
          //   child: Container(
          //     width: 70,
          //     height: 70,
          //     decoration: BoxDecoration(
          //         color: inventarioPeca.qtd_contada! < (inventarioPeca.qtd_disponivel! + inventarioPeca.qtd_reservado!)
          //             ? Colors.redAccent
          //             : secundaryColor,
          //         borderRadius: BorderRadius.circular(50)),
          //     child: Center(
          //       child: Text(
          //         '${inventarioPeca.qtd_contada}',
          //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
