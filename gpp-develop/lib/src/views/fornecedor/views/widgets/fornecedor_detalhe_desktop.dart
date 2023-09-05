import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/fornecedor_email_model.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/views/fornecedor/controllers/fornecedor_detalhe_controller.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class FornecedorDetalheDesktop extends StatelessWidget {
  const FornecedorDetalheDesktop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FornecedorDetalheController>();
    return Scaffold(
        appBar: NavbarWidget(),
        backgroundColor: Colors.white,
        body: Row(
          children: [
            Sidebar(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(24),
                child: Obx(() => !controller.carregando.value
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TitleComponent('Fornecedor'),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 32),
                            child: Row(
                              children: [
                                Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      controller.etapa(1);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: controller.etapa == 1
                                                        ? secundaryColor
                                                        : Colors.grey.shade200,
                                                    width: controller.etapa == 1
                                                        ? 4
                                                        : 1))),
                                        child: TextComponent(
                                            'Informações do fornecedor')),
                                  ),
                                ),
                                Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      controller.etapa(2);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: controller.etapa == 2
                                                      ? secundaryColor
                                                      : Colors.grey.shade200,
                                                  width: controller.etapa == 2
                                                      ? 4
                                                      : 1)),
                                        ),
                                        child: TextComponent(
                                            'E-mail do fornecedor')),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Obx(() => controller.etapa == 1
                              ? Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(children: [
                                              Expanded(
                                                flex: 3,
                                                child: InputComponent(
                                                  readOnly: true,
                                                  label: 'ID Fornecedor ',
                                                  initialValue: controller
                                                      .fornecedor.idFornecedor
                                                      .toString(),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                flex: 8,
                                                child: InputComponent(
                                                  readOnly: true,
                                                  label: ' Cliente',
                                                  initialValue: controller
                                                          .fornecedor
                                                          .cliente
                                                          ?.nome
                                                          .toString()
                                                          .capitalize ??
                                                      '',
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Expanded(
                                                child: Container(),
                                              )
                                            ]),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          ButtonComponent(
                                              color: primaryColor,
                                              colorHover: primaryColorHover,
                                              onPressed: () async {
                                                Get.back();
                                              },
                                              text: 'Voltar'),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : Container()),
                          Obx(() => controller.etapa == 2
                              ? Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  child: Form(
                                    key: controller.formKey,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InputComponent(
                                                initialValue: controller
                                                        .fornecedor
                                                        .fornecedorEmail
                                                        ?.eMail
                                                        ?.toString() ??
                                                    null,
                                                onSaved: (value) {
                                                  controller.fornecedor
                                                          .fornecedorEmail =
                                                      FornecedorEmailModel(
                                                          eMail:
                                                              value.toString());
                                                },
                                                hintText:
                                                    'Digite o e-mail do fornecedor',
                                                label: 'E-mail',
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            Expanded(
                                              child: Container(),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            ButtonComponent(
                                              color: primaryColor,
                                              colorHover: primaryColorHover,
                                              onPressed: () async {
                                                Get.back();
                                              },
                                              text: 'Voltar',
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            ButtonComponent(
                                                onPressed: () async {
                                                  await controller
                                                      .inserirFornecedorEmail();
                                                },
                                                text: 'Salvar')
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                              : Container()),
                        ],
                      )
                    : LoadingComponent()),
              ),
            )
          ],
        ));
  }
}

class ButtonSeparacaoWidget extends StatelessWidget {
  final bool separado;
  final Function onPressed;
  const ButtonSeparacaoWidget({
    Key? key,
    required this.separado,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!separado) {
      return GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          color: Colors.grey.shade500,
          width: 120,
          padding: EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Center(
            child: TextComponent(
              'Não separado',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          width: 120,
          color: Colors.lightGreenAccent.shade700,
          padding: EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Center(
            child: TextComponent(
              'Separado',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }
}
