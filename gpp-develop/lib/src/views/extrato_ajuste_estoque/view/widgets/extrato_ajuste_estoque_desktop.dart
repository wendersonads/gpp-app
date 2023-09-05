import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/models/motivo_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/DropdownButtonFormFieldComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/extrato_ajuste_estoque/controller/extrato_estoque_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:intl/intl.dart';

class ExtratoAjusteEstoqueDesktopListView extends StatelessWidget {
  ExtratoAjusteEstoqueDesktopListView({Key? key}) : super(key: key);

  final controller = Get.put(ExtratoAjusteEstoqueController());

  motivoObservacao(context, index) {
    MediaQueryData media = MediaQuery.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Center(child: TitleComponent('Motivo - Observação')),
              insetPadding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              actions: <Widget>[
                Container(
                  width: media.size.width / 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleComponent('Motivo'),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10)),
                            TextComponent(controller.ajustes[index].motivo?.nome
                                    .toString() ??
                                '-'),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10)),
                            Divider(),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10)),
                        TitleComponent('Observação'),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10)),
                        TextComponent(
                            controller.ajustes[index].observacao?.toString() ??
                                '-'),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ButtonComponent(
                                  color: Colors.red,
                                  onPressed: () {
                                    Get.back();
                                  },
                                  text: 'Voltar')
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
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
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: SingleChildScrollView(
              controller: new ScrollController(),
              child: Container(
                height: Get.height,
                margin: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TitleComponent('Extrato ajuste de estoque'),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                  child: InputComponent(
                                controller: controller.idPecaController,
                                hintText: 'Buscar por ID peça',
                                onFieldSubmitted: (value) async {
                                  controller.formKey.currentState!.save();
                                  await controller.buscarMotivos();
                                },
                              )),
                              const SizedBox(
                                width: 8,
                              ),
                              ButtonComponent(
                                  icon: Icon(Icons.tune_rounded,
                                      color: Colors.white),
                                  onPressed: () async {
                                    controller.filtro(!controller.filtro.value);
                                  },
                                  text: 'Adicionar filtro')
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Obx(
                      () => AnimatedContainer(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10)),
                        //margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        duration: Duration(milliseconds: 500),
                        height: controller.filtro.value ? null : 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                //margin: EdgeInsets.symmetric(vertical: 16),
                                child: Form(
                                  key: controller.formKey,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Obx(
                                              () => !controller
                                                      .carregandoMotivo.value
                                                  ? Container(
                                                      child:
                                                          DropdownButtonFormFieldComponent(
                                                        label: 'Motivos',
                                                        hintText:
                                                            'Selecione o um motivo',
                                                        onChanged:
                                                            (value) async {
                                                          controller
                                                                  .motivoController =
                                                              value;
                                                        },
                                                        items: controller.motivos.map<
                                                                DropdownMenuItem<
                                                                    MotivoModel>>(
                                                            (MotivoModel
                                                                value) {
                                                          return DropdownMenuItem<
                                                              MotivoModel>(
                                                            value: value,
                                                            child: TextComponent(
                                                                value.nome
                                                                    .toString()),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    )
                                                  : LoadingComponent(),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Container(
                                                child: InputComponent(
                                              controller: controller
                                                  .reFuncionarioController,
                                              label: 'RE Funcionário',
                                              hintText:
                                                  'Digite o RE do funcionário',
                                              onSaved: (value) {
                                                controller
                                                    .reFuncionarioController
                                                    .text = value;
                                              },
                                            )),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InputComponent(
                                              inputFormatter: [
                                                controller.maskFormatter
                                                    .dataFormatter()
                                              ],
                                              label: 'Período:',
                                              maxLines: 1,
                                              onSaved: (value) {
                                                if (value.length == 10) {
                                                  controller
                                                          .dataInicioController
                                                          .text =
                                                      DateFormat("dd/MM/yyyy")
                                                          .parse(value)
                                                          .toString();
                                                }
                                              },
                                              hintText: 'DD/MM/AAAA',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: InputComponent(
                                              inputFormatter: [
                                                controller.maskFormatter
                                                    .dataFormatter()
                                              ],
                                              maxLines: 1,
                                              label: '',
                                              onSaved: (value) {
                                                if (value.length == 10) {
                                                  controller.dataFimController
                                                          .text =
                                                      DateFormat("dd/MM/yyyy")
                                                          .parse(value)
                                                          .toString();
                                                }
                                              },
                                              hintText: 'DD/MM/AAAA',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ButtonComponent(
                                        color: vermelhoColor,
                                        colorHover: vermelhoColorHover,
                                        onPressed: () async {
                                          controller.limparFiltros();
                                        },
                                        text: 'Limpar'),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    ButtonComponent(
                                        onPressed: () async {
                                          controller.formKey.currentState!
                                              .save();
                                          await controller.buscarAjustes();
                                        },
                                        text: 'Pesquisar')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      color: Colors.grey.shade200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: const TextComponent(
                              'ID Ajuste',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'ID Peça',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: const TextComponent(
                              'Solicitante',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Data solicitação',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Motivo/Observação',
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Qtd Ajuste',
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: const TextComponent(
                              'Aprovador',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Data Aprovação',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Observação do aprovador',
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Situação',
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => !controller.carregandoExtrato.value
                          ? Expanded(
                              //height: Get.height / 2,
                              child: ListView.builder(
                                primary: false,
                                itemCount: controller.ajustes.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    //margin: EdgeInsets.only(right: 18),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey.shade100),
                                            left: BorderSide(
                                                color: Colors.grey.shade100),
                                            bottom: BorderSide(
                                                color: Colors.grey.shade100),
                                            right: BorderSide(
                                                color: Colors.grey.shade100))),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextComponent(
                                            controller.ajustes[index]
                                                .id_ajuste_estoque
                                                .toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(controller
                                                  .ajustes[index]
                                                  .pecasEstoque
                                                  ?.id_peca
                                                  .toString() ??
                                              '-'),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TextComponent(controller
                                                  .ajustes[index]
                                                  .solicitante
                                                  ?.clienteFunc
                                                  ?.cliente
                                                  ?.nome
                                                  .toString() ??
                                              '-'),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                              '${DateFormat('dd/MM/yyyy').format(controller.ajustes[index].data_solicitacao!)}'),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            onPressed: () {
                                              motivoObservacao(context, index);
                                            },
                                            icon: const Icon(Icons.visibility),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            controller.ajustes[index].qtd_ajuste
                                                    ?.toString() ??
                                                '-',
                                            color: controller.ajustes[index]
                                                        .tipo_solicitacao! <
                                                    0
                                                ? vermelhoColor
                                                : controller.ajustes[index]
                                                            .tipo_solicitacao! >
                                                        0
                                                    ? primaryColor
                                                    : Colors.black,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TextComponent(
                                            controller
                                                    .ajustes[index]
                                                    .solicitante
                                                    ?.clienteFunc
                                                    ?.cliente
                                                    ?.nome
                                                    .toString() ??
                                                '-',
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            controller.ajustes[index]
                                                        .data_aprovacao !=
                                                    null
                                                ? '${DateFormat('dd/MM/yyyy').format(controller.ajustes[index].data_aprovacao!)}'
                                                : '-',
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            '-',
                                            textAlign: TextAlign.center,
                                          ),
                                          // child: IconButton(
                                          //   onPressed: () {
                                          //     motivoObservacao(context, 0, index);
                                          //   },
                                          //   icon: Icon(Icons.visibility),
                                          // ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            controller.situacao(controller
                                                    .ajustes[index].situacao ??
                                                2),
                                            textAlign: TextAlign.center,
                                            color: controller.ajustes[index]
                                                        .situacao ==
                                                    0
                                                ? vermelhoColor
                                                : controller.ajustes[index]
                                                            .situacao ==
                                                        1
                                                    ? primaryColor
                                                    : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Expanded(child: LoadingComponent()),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: 100,
                            child: ButtonComponent(
                              color: vermelhoColor,
                              colorHover: vermelhoColorHover,
                              onPressed: () {
                                Get.back();
                              },
                              text: 'Voltar',
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
