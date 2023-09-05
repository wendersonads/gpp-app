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
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class MotivoAjusteEstoqueViewMobile extends StatelessWidget {
  MotivoAjusteEstoqueViewMobile({Key? key}) : super(key: key);
  final controller = Get.put(MotivoAjusteEstoqueController());

  openForm(context, MotivoModel motivo) {
    motivo.situacao = controller.radioGroup.value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return StatefulBuilder(builder: ((context, setState) {
          return SingleChildScrollView(
            child: AlertDialog(
                title: motivo.idMotivo == null
                    ? Text("Adicionar motivo de ajuste estoque")
                    : Text("Atualizar motivo de ajuste estoque"),
                content: Obx(
                  (() => Form(
                        key: controller.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("preencha as informações abaixo"),
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
                              onChanged: (value) async {
                                setState(() {
                                  motivo.nome = value!;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                            Row(
                              children: [
                                Expanded(
                                  child: ButtonComponent(
                                      color: Colors.red,
                                      onPressed: () {
                                        Get.back();
                                      },
                                      text: 'Cancelar'),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                motivo.idMotivo == null
                                    ? Expanded(
                                        child: ButtonComponent(
                                            onPressed: () {
                                              controller.criarMotivoAjusteEstoque(motivo);
                                            },
                                            text: 'Adicionar'),
                                      )
                                    : Expanded(
                                        child: ButtonComponent(
                                            onPressed: () {
                                              controller.atualizarMotivoAjusteEstoque(motivo);
                                            },
                                            text: 'Atualizar'),
                                      ),
                              ],
                            )
                          ],
                        ),
                      )),
                )),
          );
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double FONTEBASE = 16;
    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  height: 100,
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          child: SelectableText(
                        'Motivos de ajustes de estoque',
                        style: textStyleTitulo,
                      )),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: Get.width / 4,
                        child: ButtonComponent(
                            onPressed: () {
                              openForm(context, controller.motivoAjusteEstoque);
                            },
                            text: 'Adicionar'),
                      )
                    ],
                  ),
                ),
              ),
              Obx(() => !controller.carregando.value
                  ? Expanded(
                      child: ListView.separated(
                      itemCount: controller.motivosAjusteEstoque.length,
                      itemBuilder: (context, index) {
                        return Card(
                          borderOnForeground: false,
/*                               elevation: 0,
 */
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                              left: BorderSide(
                                color: secundaryColor,
                                width: 3,
                              ),
                            )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                'ID: ',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                              ),
                                              Text(
                                                '${controller.motivosAjusteEstoque[index].idMotivo.toString()}',
                                                style: TextStyle(fontSize: FONTEBASE),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Status: ',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                            ),
                                            Row(
                                              children: [
                                                StatusComponent(
                                                  status: controller.motivosAjusteEstoque[index].situacao!,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Motivo: ',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                          ),
                                          Text('${controller.motivosAjusteEstoque[index].nome!}',
                                              style: TextStyle(fontSize: FONTEBASE)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.radioGroup(controller.motivosAjusteEstoque[index].situacao);
                                          openForm(context, controller.motivosAjusteEstoque[index]);
                                        },
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Icon(
                                              Icons.edit_rounded,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.excluirMotivoAjusteEstoque(controller.motivosAjusteEstoque[index]);
                                        },
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Icon(
                                              Icons.delete_rounded,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    /* ButtonAcaoWidget(
                                          editar: () {
                                            controller.radioGroup(controller.motivosAjusteEstoque[index].situacao);
                                            openForm(context, controller.motivosAjusteEstoque[index]);
                                          },
                                          deletar: () {
                                            controller
                                                .excluirMotivoAjusteEstoque(controller.motivosAjusteEstoque[index]);
                                          },
                                        ), */
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 8,
                        );
                      },
                    ))
                  : Center(child: LoadingComponent()))
            ],
          ),
        ),
      ),
    );
  }
}
