import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/corredor_enderecamento_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/DropdownButtonFormFieldComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/inventario/controllers/inventario_cadastro_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class InventarioCadastroView extends StatelessWidget {
  const InventarioCadastroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InventarioCadastroController());
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: NavbarWidget(),
            drawer: Sidebar(),
            backgroundColor: Colors.white,
            body: WillPopScope(
              onWillPop: () async => await Get.toNamed('/inventario'),
              child: Row(
                children: [
                  context.width > 576 ? Sidebar() : Container(),
                  Expanded(
                    child: Obx(
                      () => !controller.carregando.value
                          ? Container(
                              height: context.height,
                              margin: EdgeInsets.all(24),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      width: context.width,
                                      child: Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        runSpacing: 10,
                                        spacing: 10,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 200,
                                                child: Text(
                                                  'Informe o local do inventário',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24),
                                                ),
                                              ),
                                              ButtonComponent(
                                                onPressed: () {
                                                  controller.limparCampos();
                                                },
                                                text: 'Limpar',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 16),
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                    Container(
                                        child: Container(
                                      child: Column(
                                        children: [
                                          DropdownButtonFormFieldComponent(
                                            label: 'Piso',
                                            hintText: 'Selecione o piso',
                                            value: controller.piso.value,
                                            onChanged: (value) async {
                                              controller.piso.value = value;

                                              await controller.buscarCorredor();
                                            },
                                            items:
                                                controller.pisos.map((value) {
                                              return DropdownMenuItem<dynamic>(
                                                value: value,
                                                child: Text(value.desc_piso!),
                                              );
                                            }).toList(),
                                          ),
                                          DropdownButtonFormFieldComponent(
                                            label: 'Corredor',
                                            hintText: 'Selecione o corredor',
                                            value: controller.corredor.value,
                                            onChanged: (value) async {
                                              controller.corredor.value = value;
                                              controller.piso.value?.corredor =
                                                  value;

                                              await controller.buscarEstantes();
                                            },
                                            items: controller.corredores
                                                .map((value) {
                                              return DropdownMenuItem<
                                                  CorredorEnderecamentoModel>(
                                                value: value,
                                                child:
                                                    Text(value.desc_corredor!),
                                              );
                                            }).toList(),
                                          ),
                                          DropdownButtonFormFieldComponent(
                                            label: 'Estante',
                                            hintText: 'Selecione a estante',
                                            value: controller.estante.value,
                                            onChanged: (value) async {
                                              controller.estante.value = value;
                                              controller.piso.value?.corredor!
                                                  .estante = value;

                                              await controller
                                                  .buscarPrateleiras();
                                            },
                                            items: controller.estantes
                                                .map((value) {
                                              return DropdownMenuItem<dynamic>(
                                                value: value,
                                                child:
                                                    Text(value.desc_estante!),
                                              );
                                            }).toList(),
                                          ),
                                          DropdownButtonFormFieldComponent(
                                            label: 'Prateleira',
                                            hintText: 'Selecione a prateleira',
                                            value: controller.prateleira.value,
                                            onChanged: (value) async {
                                              controller.prateleira.value =
                                                  value;
                                              controller.piso.value?.corredor!
                                                  .estante!.prateleira = value;

                                              await controller.buscarBoxs();
                                            },
                                            items: controller.prateleiras
                                                .map((value) {
                                              return DropdownMenuItem<dynamic>(
                                                value: value,
                                                child: Text(
                                                    value.desc_prateleira!),
                                              );
                                            }).toList(),
                                          ),
                                          DropdownButtonFormFieldComponent(
                                            label: 'Box',
                                            hintText: 'Selecione a box',
                                            value: controller.box.value,
                                            onChanged: (value) {
                                              controller.box.value = value;
                                              controller
                                                  .piso
                                                  .value
                                                  ?.corredor!
                                                  .estante!
                                                  .prateleira!
                                                  .box = value;
                                            },
                                            items: controller.boxs.map((value) {
                                              return DropdownMenuItem<dynamic>(
                                                value: value,
                                                child: Text(value.desc_box!),
                                              );
                                            }).toList(),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 16),
                                            width: context.width,
                                            child: Wrap(
                                                spacing: 10,
                                                runSpacing: 10,
                                                alignment:
                                                    WrapAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 80,
                                                    child: ButtonComponent(
                                                        color: vermelhoColor,
                                                        text: 'Cancelar',
                                                        onPressed: () {
                                                          Get.offAllNamed(
                                                              '/inventario');
                                                        }),
                                                  ),
                                                  Container(
                                                    child: Wrap(
                                                      spacing: 10,
                                                      children: [
                                                        Container(
                                                          width: 120,
                                                          child:
                                                              ButtonComponent(
                                                                  color:
                                                                      primaryColor,
                                                                  text:
                                                                      'Cadastrar',
                                                                  onPressed:
                                                                      () async {
                                                                    await controller
                                                                        .cadastrarInventario();
                                                                  }),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ]),
                                          )
                                        ],
                                      ),
                                    )
                                        // Column(
                                        //     mainAxisAlignment: MainAxisAlignment.center,
                                        //     crossAxisAlignment: CrossAxisAlignment.center,
                                        //     children: [
                                        //       LoadingComponent(),
                                        //       TextComponent('Criando inventário, aguarde...'),
                                        //     ],
                                        //   ),
                                        // ),
                                        ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              height: Get.height * 0.70,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  LoadingComponent(),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Obx(
                                    () {
                                      controller.pontinhosLoading();
                                      return TextComponent(
                                        'Criando inventário, aguarde${controller.pontinhos}',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => controller.carregandoDados.value
                ? Opacity(
                    opacity: 0.8,
                    child: ModalBarrier(
                      dismissible: false,
                      color: Colors.black,
                    ),
                  )
                : SizedBox.shrink(),
          ),
          Obx(
            () => controller.carregandoDados.value
                ? Center(
                    child: LoadingComponent(),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
