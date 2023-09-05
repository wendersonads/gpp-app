import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/motivo_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/components/status_component.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/motivo_ajuste_estoque/controller/motivo_ajuste_estoque_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class MotivoAjusteEstoqueViewDesktop extends StatelessWidget {
  MotivoAjusteEstoqueViewDesktop({Key? key}) : super(key: key);
  final controller = Get.put(MotivoAjusteEstoqueController());

  openForm(context, MotivoModel motivo) {
    motivo.situacao = controller.radioGroup.value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: motivo.idMotivo == null
                  ? Text("Adicionar motivo de ajuste estoque")
                  : Text("Atualizar motivo de ajuste estoque"),
              content: new Text("preencha as informações abaixo"),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        InputComponent(
                          label: 'Nome',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Esse campo é obrigatório !';
                            }
                            return null;
                          },
                          initialValue: motivo.nome,
                          hintText: 'Digite o motivo ajuste estoque',
                          onChanged: (value) {
                            setState(() {
                              motivo.nome = value!;
                            });
                          },
                        ),
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: secundaryColor,
                                  value: true,
                                  groupValue: controller.radioGroup.value,
                                  onChanged: (bool? value) {
                                    controller.radioGroup(value!);
                                    motivo.situacao = value;
                                  },
                                ),
                                Text("Ativo"),
                                Radio(
                                    activeColor: secundaryColor,
                                    value: false,
                                    groupValue: controller.radioGroup.value,
                                    onChanged: (bool? value) {
                                      controller.radioGroup(value!);
                                      motivo.situacao = value;
                                    }),
                                Text("Inativo"),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Row(
                            children: [
                              motivo.idMotivo == null
                                  ? ButtonComponent(
                                      onPressed: () {
                                        controller.criarMotivoAjusteEstoque(motivo);
                                      },
                                      text: 'Adicionar')
                                  : ButtonComponent(
                                      onPressed: () {
                                        controller.atualizarMotivoAjusteEstoque(motivo);
                                      },
                                      text: 'Atualizar'),
                              SizedBox(
                                width: 8,
                              ),
                              ButtonComponent(
                                  color: Colors.red,
                                  onPressed: () {
                                    Get.back();
                                  },
                                  text: 'Cancelar')
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      body: Row(
        children: [
          Expanded(child: Sidebar()),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: SelectableText(
                            'Motivos de ajustes de estoque',
                            style: textStyleTitulo,
                          )),
                          ButtonComponent(
                              onPressed: () {
                                openForm(context, controller.motivoAjusteEstoque);
                              },
                              text: 'Adicionar')
                        ],
                      ),
                    ),
                    Obx(() => !controller.carregando.value
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: controller.motivosAjusteEstoque.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    child: CardWidget(
                                      widget: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: SelectableText(
                                                'ID',
                                                style: textStyleTexto,
                                              )),
                                              Expanded(
                                                  child: SelectableText(
                                                'Motivo',
                                                style: textStyleTexto,
                                              )),
                                              Expanded(
                                                  child: SelectableText(
                                                'Status',
                                                style: textStyleTexto,
                                              )),
                                              Expanded(
                                                  child: SelectableText(
                                                'Opções',
                                                style: textStyleTexto,
                                              )),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: SelectableText(
                                                      '${controller.motivosAjusteEstoque[index].idMotivo.toString()}')),
                                              Expanded(child: SelectableText(controller.motivosAjusteEstoque[index].nome!)),
                                              Expanded(
                                                  child: Row(
                                                children: [
                                                  StatusComponent(status: controller.motivosAjusteEstoque[index].situacao!),
                                                ],
                                              )),
                                              Expanded(
                                                child: ButtonAcaoWidget(
                                                  editar: () {
                                                    controller.radioGroup(controller.motivosAjusteEstoque[index].situacao);
                                                    openForm(context, controller.motivosAjusteEstoque[index]);
                                                  },
                                                  deletar: () {
                                                    controller.excluirMotivoAjusteEstoque(controller.motivosAjusteEstoque[index]);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }))
                        : Center(child: LoadingComponent()))
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
