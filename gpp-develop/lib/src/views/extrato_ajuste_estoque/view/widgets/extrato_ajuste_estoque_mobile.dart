import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/models/motivo_model.dart';
import 'package:gpp/src/models/movimento_estoque/ajuste_estoque_model.dart';
import 'package:gpp/src/repositories/motivo_estoque_repository.dart';
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

class ExtratoAjusteEstoqueMobileListView extends StatelessWidget {
  ExtratoAjusteEstoqueMobileListView({Key? key}) : super(key: key);

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
              content: Container(
                height: media.size.height / 2.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TitleComponent('Motivo'),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10)),
                    TextComponent(controller.ajustes[index].motivo?.nome.toString() ?? '-'),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10)),
                    Divider(),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10)),
                    TitleComponent('Observação'),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10)),
                    TextComponent(controller.ajustes[index].observacao?.toString() ?? '-'),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonComponent(
                              color: primaryColor,
                              onPressed: () {
                                Get.back();
                              },
                              text: 'Voltar'),
                        )
                      ],
                    )
                  ],
                ),
              ),
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
      drawer: Sidebar(),
      appBar: NavbarWidget(),
      body: SingleChildScrollView(
          controller: new ScrollController(),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextComponent(
                  'Extrato ajuste de estoque',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
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
                              icon: Icon(Icons.tune_rounded, color: Colors.white),
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
                  height: 10,
                ),
                Obx(
                  () => AnimatedContainer(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    //margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    duration: Duration(milliseconds: 500),
                    height: controller.filtro.value ? null : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // margin: EdgeInsets.symmetric(vertical: 16),
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Obx(
                                        () => !controller.carregandoMotivo.value
                                            ? Container(
                                                child: DropdownButtonFormFieldComponent(
                                                  label: 'Motivos',
                                                  hintText: 'Selecione o um motivo',
                                                  onChanged: (value) async {
                                                    controller.motivoController = value;
                                                  },
                                                  items:
                                                      controller.motivos.map<DropdownMenuItem<MotivoModel>>((MotivoModel value) {
                                                    return DropdownMenuItem<MotivoModel>(
                                                      value: value,
                                                      child: TextComponent(value.nome.toString()),
                                                    );
                                                  }).toList(),
                                                ),
                                              )
                                            : LoadingComponent(),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                          child: InputComponent(
                                        controller: controller.reFuncionarioController,
                                        label: 'RE Funcionário',
                                        hintText: 'Digite o RE do funcionário',
                                        onSaved: (value) {
                                          controller.reFuncionarioController.text = value;
                                        },
                                      )),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InputComponent(
                                        inputFormatter: [controller.maskFormatter.dataFormatter()],
                                        label: 'Período:',
                                        maxLines: 1,
                                        onSaved: (value) {
                                          if (value.length == 10) {
                                            controller.dataInicioController.text =
                                                DateFormat("dd/MM/yyyy").parse(value).toString();
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
                                        inputFormatter: [controller.maskFormatter.dataFormatter()],
                                        maxLines: 1,
                                        label: '',
                                        onSaved: (value) {
                                          if (value.length == 10) {
                                            controller.dataFimController.text = DateFormat("dd/MM/yyyy").parse(value).toString();
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
                                    controller.formKey.currentState!.save();
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
                SizedBox(
                  height: 10,
                ),
                Obx(
                  () => !controller.carregandoExtrato.value
                      ? ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: controller.ajustes.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: const TextComponent(
                                              'ID Ajuste',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextComponent(
                                              controller.ajustes[index].id_ajuste_estoque.toString(),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: const TextComponent(
                                              'ID Peça',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextComponent(
                                              controller.ajustes[index].pecasEstoque?.id_peca.toString() ?? '-',
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: const TextComponent(
                                              'Solicitante',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextComponent(
                                              controller.ajustes[index].solicitante?.clienteFunc?.cliente?.nome.toString() ?? '-',
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: const TextComponent(
                                              'Data solicitação',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextComponent(
                                              '${DateFormat('dd/MM/yyyy').format(controller.ajustes[index].data_solicitacao!)}',
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: const TextComponent(
                                              'Motivo/Observação',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: IconButton(
                                                onPressed: () {
                                                  motivoObservacao(context, index);
                                                },
                                                icon: const Icon(Icons.visibility),
                                                alignment: Alignment(1.2, 0.6)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: const TextComponent(
                                              'Qtd Ajuste',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextComponent(
                                              controller.ajustes[index].qtd_ajuste?.toString() ?? '-',
                                              color: controller.ajustes[index].tipo_solicitacao! < 0
                                                  ? vermelhoColor
                                                  : controller.ajustes[index].tipo_solicitacao! > 0
                                                      ? primaryColor
                                                      : Colors.black,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: const TextComponent(
                                              'Aprovador',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextComponent(
                                                controller.ajustes[index].solicitante?.clienteFunc?.cliente?.nome.toString() ??
                                                    '-',
                                                textAlign: TextAlign.end),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: const TextComponent(
                                              'Situação',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextComponent(
                                              controller.situacao(controller.ajustes[index].situacao ?? 2),
                                              textAlign: TextAlign.end,
                                              color: controller.ajustes[index].situacao == 0
                                                  ? vermelhoColor
                                                  : controller.ajustes[index].situacao == 1
                                                      ? primaryColor
                                                      : Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Expanded(child: LoadingComponent()),
                ),
              ],
            ),
          )),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              padding: EdgeInsets.all(16),
              width: 100,
              child: ButtonComponent(
                color: primaryColor,
                onPressed: () {
                  Get.offAllNamed('/dashboard');
                },
                text: 'Voltar',
              )),
          SizedBox(
            width: 24,
          )
        ],
      ),
    );
  }
}
