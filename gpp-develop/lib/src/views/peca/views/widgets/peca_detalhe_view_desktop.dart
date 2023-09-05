// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/peca/controller/peca_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class PecaDetalheViewDesktop extends StatelessWidget {
  final int id;
  const PecaDetalheViewDesktop({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PecaDetalheController(id),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Container(
              height: context.height,
              child: SingleChildScrollView(
                controller: new ScrollController(),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Obx((() => !controller.carregando.value
                            ? Column(
                                children: [
                                  //Peça
                                  Container(
                                      child: Column(
                                    children: [
                                      Row(
                                        children: [TitleComponent('Peça')],
                                      ),
                                      Obx(
                                        (() => Container(
                                              margin: EdgeInsets.symmetric(vertical: 16),
                                              child: Row(children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    controller.menu(1);
                                                  },
                                                  child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: controller.menu.value == 1
                                                                      ? secundaryColor
                                                                      : Colors.grey.shade200,
                                                                  width: controller.menu.value == 1 ? 4 : 1))),
                                                      child: TextComponent('Informações da peça')),
                                                ),
                                                // GestureDetector(
                                                //   onTap: () async {
                                                //     controller.menu(2);
                                                //   },
                                                //   child: Container(
                                                //       padding:
                                                //           EdgeInsets.symmetric(
                                                //               vertical: 8,
                                                //               horizontal: 16),
                                                //       decoration: BoxDecoration(
                                                //           border: Border(
                                                //               bottom: BorderSide(
                                                //                   color: controller
                                                //                               .menu
                                                //                               .value ==
                                                //                           2
                                                //                       ? secundaryColor
                                                //                       : Colors
                                                //                           .grey
                                                //                           .shade200,
                                                //                   width: controller
                                                //                               .menu
                                                //                               .value ==
                                                //                           2
                                                //                       ? 4
                                                //                       : 1))),
                                                //       child: TextComponent(
                                                //           'QR Code')),
                                                // ),
                                                GestureDetector(
                                                  onTap: () {
                                                    controller.menu(3);
                                                  },
                                                  child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: controller.menu.value == 3
                                                                      ? secundaryColor
                                                                      : Colors.grey.shade200,
                                                                  width: controller.menu.value == 3 ? 4 : 1))),
                                                      child: TextComponent('Estoque')),
                                                ),
                                              ]),
                                            )),
                                      ),
                                      Obx(
                                        () => controller.menu.value == 1
                                            ? Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(vertical: 16),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: InputComponent(
                                                            label: 'ID da peça',
                                                            readOnly: true,
                                                            initialValue: '${controller.peca.id_peca ?? ''}',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: InputComponent(
                                                            label: 'Descrição',
                                                            readOnly: true,
                                                            initialValue: '${controller.peca.descricao ?? ''}',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: InputComponent(
                                                            label: 'Cor',
                                                            readOnly: true,
                                                            initialValue: '${controller.peca.cor ?? ''}',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: InputComponent(
                                                          label: 'Profundidade',
                                                          readOnly: true,
                                                          initialValue: '${controller.peca.profundidade ?? ''}',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Expanded(
                                                        child: InputComponent(
                                                          label: 'Altura',
                                                          readOnly: true,
                                                          initialValue: '${controller.peca.altura ?? ''}',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Expanded(
                                                        child: InputComponent(
                                                          label: 'Largura',
                                                          readOnly: true,
                                                          initialValue: '${controller.peca.largura ?? ''}',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(vertical: 16),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: InputComponent(
                                                            label: 'Volumes',
                                                            readOnly: true,
                                                            initialValue: '${controller.peca.volumes ?? ''}',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: InputComponent(
                                                            label: 'ID de fabrica',
                                                            readOnly: true,
                                                            initialValue: '${controller.peca.codigo_fabrica ?? ''}',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: InputComponent(
                                                            label: 'Material',
                                                            readOnly: true,
                                                            initialValue: '${controller.peca.material ?? ''}',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(vertical: 16),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: InputComponent(
                                                            label: 'ID do produto',
                                                            readOnly: true,
                                                            initialValue:
                                                                '${controller.peca.produtoPeca!.length != 0 ? controller.peca.produtoPeca?.first.produto?.idProduto ?? '' : 'Essa peça não está vinculada a nenhum produto'}',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: InputComponent(
                                                            label: 'Produto',
                                                            readOnly: true,
                                                            initialValue:
                                                                '${controller.peca.produtoPeca!.length != 0 ? controller.peca.produtoPeca?.first.produto?.resumida.toString().capitalize ?? '' : 'Essa peça não está vinculada a nenhum produto'}',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: InputComponent(
                                                            label: 'Fornecedor',
                                                            readOnly: true,
                                                            initialValue:
                                                                '${controller.peca.produtoPeca!.length != 0 ? controller.peca.produtoPeca?.first.produto?.fornecedores!.first.cliente?.nome.toString().capitalize ?? '' : 'Essa peça não está vinculada a nenhum fornecedor'}',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  )),

                                  Obx(() => controller.menu.value == 3
                                      ? Column(
                                          children: [
                                            Container(
                                              color: Colors.grey.shade200,
                                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextComponent(
                                                      'ID do estoque',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextComponent(
                                                      'Endereço',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextComponent(
                                                      'Quantidade disponível',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextComponent(
                                                      'Quantidade reservada',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextComponent(
                                                      'Quantidade transferência',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextComponent(
                                                      'Quantidade mínima',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            controller.peca.estoque!.length != null
                                                ? Column(
                                                    children: controller.peca.estoque!
                                                        .map<Widget>((e) => Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      top: BorderSide(color: Colors.grey.shade100),
                                                                      left: BorderSide(color: Colors.grey.shade100),
                                                                      bottom: BorderSide(color: Colors.grey.shade100),
                                                                      right: BorderSide(color: Colors.grey.shade100))),
                                                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: SelectableText(e.idPecaEstoque.toString()),
                                                                  ),
                                                                  Expanded(
                                                                    child: SelectableText(e.endereco),
                                                                  ),
                                                                  Expanded(
                                                                    child: SelectableText(e.saldoDisponivel.toString()),
                                                                  ),
                                                                  Expanded(
                                                                    child: SelectableText(e.saldoReservado.toString()),
                                                                  ),
                                                                  Expanded(
                                                                    child: SelectableText(e.quantidadeTransferencia.toString()),
                                                                  ),
                                                                  Expanded(
                                                                    child: SelectableText(e.quantidadeMinima?.toString() ?? ''),
                                                                  )
                                                                ],
                                                              ),
                                                            ))
                                                        .toList(),
                                                  )
                                                : Container(),
                                          ],
                                        )
                                      : Container()),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 16),
                                    child: Row(
                                      children: [
                                        ButtonComponent(
                                            color: primaryColor,
                                            colorHover: primaryColorHover,
                                            onPressed: () {
                                              Get.back();
                                            },
                                            text: 'Voltar')
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : Container(color: Colors.white, child: LoadingComponent()))))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
