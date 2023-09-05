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

class PecaDetalheViewMobile extends StatelessWidget {
  final int id;
  const PecaDetalheViewMobile({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PecaDetalheController(id),
    );
    final double FONTEBASE = 18;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      body: Container(
        height: context.height,
        child: SingleChildScrollView(
          controller: new ScrollController(),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Obx((() => !controller.carregando.value
                  ? Column(
                      children: [
                        //Peça
                        Container(
                            child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [TitleComponent('Peça')],
                            ),
                            Obx(
                              (() => Container(
                                    margin: EdgeInsets.symmetric(vertical: 16),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                controller.menu(1);
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 16),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: controller.menu.value == 1
                                                                  ? secundaryColor
                                                                  : Colors.grey.shade200,
                                                              width: controller.menu.value == 1 ? 4 : 1))),
                                                  child: TextComponent('Informações da peça')),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                controller.menu(3);
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(vertical: 8),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: controller.menu.value == 3
                                                                  ? secundaryColor
                                                                  : Colors.grey.shade200,
                                                              width: controller.menu.value == 3 ? 4 : 1))),
                                                  child: TextComponent('Estoque')),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                                  )),
                            ),
                            Obx(
                              () => controller.menu.value == 1
                                  ? Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
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
                                                flex: 3,
                                                child: InputComponent(
                                                  label: 'Descrição',
                                                  readOnly: true,
                                                  initialValue: '${controller.peca.descricao ?? ''}',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: InputComponent(
                                                  label: 'Material',
                                                  readOnly: true,
                                                  initialValue: '${controller.peca.material ?? ''}',
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
                                        Container(
                                          child: Row(
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
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: InputComponent(
                                                  label: 'Volumes',
                                                  readOnly: true,
                                                  initialValue: '${controller.peca.volumes ?? ''}',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
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
                                                  label: 'ID do produto',
                                                  readOnly: true,
                                                  initialValue:
                                                      '${controller.peca.produtoPeca!.length != 0 ? controller.peca.produtoPeca?.first.produto?.idProduto ?? '' : 'Essa peça não está vinculada a nenhum produto'}',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
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
                                  controller.peca.estoque!.length != null
                                      ? Column(
                                          children: controller.peca.estoque!
                                              .map<Widget>((e) => Card(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(left: BorderSide(color: secundaryColor, width: 3.5))),
                                                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                                      child: Column(
                                                        children: [
                                                          !(e.endereco.length > 9)
                                                              ? Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text('ID estoque: ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: FONTEBASE)),
                                                                        Text(
                                                                          e.idPecaEstoque.toString(),
                                                                          style: TextStyle(fontSize: FONTEBASE),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text('Endereço: ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: FONTEBASE)),
                                                                        Text(
                                                                          e.endereco,
                                                                          style: TextStyle(fontSize: FONTEBASE),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
                                                              : Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text('ID estoque: ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: FONTEBASE)),
                                                                        Text(
                                                                          e.idPecaEstoque.toString(),
                                                                          style: TextStyle(fontSize: FONTEBASE),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text('Endereço: ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: FONTEBASE)),
                                                                        Text(
                                                                          e.endereco,
                                                                          style: TextStyle(fontSize: FONTEBASE),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text('Saldo dispoível: ',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold, fontSize: FONTEBASE)),
                                                                  Text(
                                                                    e.saldoDisponivel.toString(),
                                                                    style: TextStyle(fontSize: FONTEBASE),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text('Saldo reservada: ',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold, fontSize: FONTEBASE)),
                                                                  Text(
                                                                    e.saldoReservado.toString(),
                                                                    style: TextStyle(fontSize: FONTEBASE),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text('Saldo transferência: ',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold, fontSize: FONTEBASE)),
                                                                  Text(
                                                                    e.saldoDisponivel.toString(),
                                                                    style: TextStyle(fontSize: FONTEBASE),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text('Saldo mínima: ',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold, fontSize: FONTEBASE)),
                                                                  Text(
                                                                    e.quantidadeMinima?.toString() ?? '',
                                                                    style: TextStyle(fontSize: FONTEBASE),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        )
                                      : Container(),
                                ],
                              )
                            : Container()),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: Get.width / 2,
                              child: ButtonComponent(
                                  color: primaryColor,
                                  colorHover: primaryColorHover,
                                  onPressed: () {
                                    Get.offAllNamed('/pecas-consultar');
                                  },
                                  text: 'Voltar'),
                            )
                          ],
                        )
                      ],
                    )
                  : Container(color: Colors.white, child: LoadingComponent())))),
        ),
      ),
    );
  }
}
