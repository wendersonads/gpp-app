// ignore_for_file: must_be_immutable, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';

import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';

import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/peca/controller/peca_detalhe_controller.dart';

import 'package:gpp/src/views/widgets/appbar_widget.dart';

import 'package:gpp/src/views/peca/controller/peca_controller.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class PecaEditarView extends StatelessWidget {
  final int id;
  PecaEditarView({
    Key? key,
    required this.id,
  }) : super(key: key);

  PecaController _pecaController = PecaController();

  editar(PecaDetalheController pecaController) async {
    try {
      if (await pecaController.pecaRepository.editar(pecaController.peca)) {
        Notificacao.snackBar("Peça editada com sucesso!", tipoNotificacao: TipoNotificacaoEnum.sucesso);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerPecas = Get.put(
      PecaController(),
    );
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
            child: Column(
              children: [
                Expanded(
                  child: Container(
                      child: Obx((() => !controller.carregando.value
                          ? Column(
                              children: [
                                //Peça
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [TitleComponent('Editar Peça')],
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 16),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: InputComponent(
                                                        label: 'Código da peça',
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
                                                        initialValue: '${controller.peca.descricao ?? ''}',
                                                        onChanged: (value) {
                                                          controller.peca.descricao = value;
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: InputComponent(
                                                        label: 'Cor',
                                                        initialValue: '${controller.peca.cor ?? ''}',
                                                        onChanged: (value) {
                                                          controller.peca.cor = value;
                                                        },
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
                                                        inputFormatter: [
                                                          FilteringTextInputFormatter.digitsOnly,
                                                        ],
                                                        label: 'Profundidade',
                                                        initialValue: '${controller.peca.profundidade ?? ''}',
                                                        onChanged: (value) {
                                                          controller.peca.profundidade = double.parse(value);
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: InputComponent(
                                                        inputFormatter: [
                                                          FilteringTextInputFormatter.digitsOnly,
                                                        ],
                                                        label: 'Altura',
                                                        initialValue: '${controller.peca.altura ?? ''}',
                                                        onChanged: (value) {
                                                          controller.peca.altura = double.parse(value);
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: InputComponent(
                                                        inputFormatter: [
                                                          FilteringTextInputFormatter.digitsOnly,
                                                        ],
                                                        label: 'Largura',
                                                        initialValue: '${controller.peca.largura ?? ''}',
                                                        onChanged: (value) {
                                                          controller.peca.largura = double.parse(value);
                                                        },
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
                                                        label: 'Volumes',
                                                        initialValue: '${controller.peca.volumes ?? ''}',
                                                        onChanged: (value) {
                                                          controller.peca.volumes = value;
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: InputComponent(
                                                        label: 'Código de fabrica',
                                                        initialValue: '${controller.peca.codigo_fabrica ?? ''}',
                                                        onChanged: (value) {
                                                          controller.peca.codigo_fabrica = value;
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: InputComponent(
                                                        label: 'Material',
                                                        initialValue: '${controller.peca.material ?? ''}',
                                                        onChanged: (value) {
                                                          controller.peca.material = value;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.only(top: 20)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ButtonComponent(
                                              onPressed: () async {
                                                await editar(controller);
                                                controllerPecas.buscarPecas();
                                                Navigator.pop(context);
                                              },
                                              text: 'Editar',
                                            ),
                                            Padding(padding: EdgeInsets.only(right: 20)),
                                            ButtonComponent(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              text: 'Cancelar',
                                              color: Colors.red,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : LoadingComponent()))),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
