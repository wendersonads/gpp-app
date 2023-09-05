import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/motivo_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/DropdownButtonFormFieldComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/estoque/controllers/estoque_ajuste_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class EstoqueAjusteViewMobile extends StatelessWidget {
  final int id;
  const EstoqueAjusteViewMobile({
    Key? key,
    required this.id,
  }) : super(key: key);

  returnToPreviousRoute(String route) {
    if (route == '/pecas-enderecamento') {
      Get.offAllNamed('/pecas-enderecamento');
    } else {
      Get.offAllNamed('/estoques');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EstoqueAjusteController(id));
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: Sidebar(),
        appBar: NavbarWidget(),
        body: Row(children: [
          context.width > 576 ? Sidebar() : Container(),
          Expanded(
              child: Container(
            height: context.height,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          TextComponent(
                            'Ajuste de estoque',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          SelectableText(
                            'Informações da peça',
                            style: textStyleSubtitulo,
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.shade100),
                    Obx(
                      () => !controller.carregando.value
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              width: context.width,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                alignment: WrapAlignment.start,
                                spacing: 10,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.only(right: 8),
                                          child: InputComponent(
                                            enable: false,
                                            label: 'ID',
                                            initialValue: controller.pecaEstoque.peca?.id_peca?.toString() ?? 'Sem ID',
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          child: InputComponent(
                                            enable: false,
                                            label: 'Descrição',
                                            initialValue: controller.pecaEstoque.peca?.descricao?.toString() ?? ' Sem descrição',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.only(right: 8),
                                          child: InputComponent(
                                            enable: false,
                                            label: 'Endereço',
                                            initialValue: controller.pecaEstoque.endereco?.toString() ?? ' Sem endereço',
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: InputComponent(
                                            enable: false,
                                            label: 'Quantidade disponível',
                                            initialValue: controller.pecaEstoque.saldo_disponivel?.toString() ??
                                                'Sem quantidade de disponível',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.only(right: 8),
                                          child: InputComponent(
                                            enable: false,
                                            label: 'Quantidade reservada',
                                            initialValue:
                                                controller.pecaEstoque.saldo_reservado?.toString() ?? 'Sem quantidade reservada',
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: InputComponent(
                                            enable: false,
                                            label: 'Quantidade transferência',
                                            initialValue: controller.pecaEstoque.quantidade_transferencia?.toString() ??
                                                'Sem quantidade de transferência',
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          : LoadingComponent(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          SelectableText(
                            'Adicionar ou remover estoque',
                            style: textStyleSubtitulo,
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.shade100),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      width: context.width,
                      child: Form(
                        key: controller.formKey,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          spacing: 10,
                          children: [
                            Obx(
                              () => Container(
                                width: context.width < 576 ? context.width : 320,
                                child: InputComponent(
                                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                  label: 'Informe o saldo que deseja adicionar ou remover',
                                  hintText: 'Digite a quantidade',
                                  errorText: controller.errorText.value,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Esse campo é obrigatório !';
                                    }
                                    if (int.tryParse(value) != null && int.tryParse(value) == 0) {
                                      return 'Esse campo deve ser maio que zero !';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    controller.ajusteUpdate.qtd_ajuste = int.tryParse(value);
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: context.width < 576 ? context.width : 320,
                              child: Obx(
                                () => !controller.carregandoMotivosAjusteEstoque.value
                                    ? DropdownButtonFormFieldComponent(
                                        label: 'Motivos',
                                        hintText: 'Selecione o um motivo',
                                        validator: (value) {
                                          if (controller.motivoSelecionado.idMotivo == null) {
                                            return 'Esse campo é obrigatório !';
                                          }

                                          return null;
                                        },
                                        onChanged: (value) async {
                                          controller.motivoSelecionado = value;
                                          controller.ajusteUpdate.motivo = value;
                                        },
                                        items: controller.motivosAjusteEstoque
                                            .where((element) => element.situacao == true)
                                            .map<DropdownMenuItem<MotivoModel>>((MotivoModel value) {
                                          return DropdownMenuItem<MotivoModel>(
                                            value: value,
                                            child: TextComponent(value.nome.toString()),
                                          );
                                        }).toList(),
                                      )
                                    : LoadingComponent(),
                              ),
                            ),
                            Container(
                              width: context.width,
                              child: InputComponent(
                                label: 'Observação',
                                hintText: 'Digite a observação',
                                maxLines: 5,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Esse campo é obrigatório !';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  controller.ajusteUpdate.observacao = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      width: context.width,
                      child: Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: ButtonComponent(
                                      color: primaryColor,
                                      onPressed: () {
                                        returnToPreviousRoute(Get.previousRoute);
                                      },
                                      text: 'Voltar'),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Obx(
                                    () => !controller.finalizando.value
                                        ? ButtonComponent(
                                            onPressed: () async {
                                              await controller.adicionarEstoque();
                                            },
                                            text: 'Adicionar saldo')
                                        : LoadingComponent(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: Obx(
                                    () => !controller.finalizando.value
                                        ? ButtonComponent(
                                            color: sexternaryColor,
                                            onPressed: () async {
                                              await controller.removerEstoque();
                                            },
                                            text: 'Remover saldo')
                                        : LoadingComponent(),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Obx(
                                    () => !controller.finalizando.value
                                        ? ButtonComponent(
                                            color: sexternaryColor,
                                            onPressed: () async {
                                              await controller.removerEnderecamento();
                                            },
                                            text: 'Remover endereço')
                                        : LoadingComponent(),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))
        ]));
  }
}
