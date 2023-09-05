import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/movimento_estoque/tipo_movimento_estoque_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/DropdownButtonFormFieldComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/extrato_estoque/controller/extrato_estoque_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:intl/intl.dart';

class ExtratoEstoqueViewDesktop extends StatelessWidget {
  const ExtratoEstoqueViewDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExtratoEstoqueController());
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
                          child: TitleComponent('Extrato de estoque'),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                  child: InputComponent(
                                controller: controller.idPecaController,
                                hintText: 'Buscar por ID da peça',
                                onFieldSubmitted: (value) async {
                                  controller.formKey.currentState!.save();
                                  await controller.buscarMovimentos();
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
                                                      .carregandoTipoMovimento
                                                      .value
                                                  ? Container(
                                                      child:
                                                          DropdownButtonFormFieldComponent(
                                                        label: 'Tipo Movimento',
                                                        hintText:
                                                            'Selecione o piso',
                                                        onChanged:
                                                            (value) async {
                                                          controller
                                                                  .tipoMovimentoController =
                                                              value;
                                                        },
                                                        items: controller
                                                            .tiposMovimento
                                                            .map<
                                                                    DropdownMenuItem<
                                                                        TipoMovimentoEstoqueModel>>(
                                                                (TipoMovimentoEstoqueModel
                                                                    value) {
                                                          return DropdownMenuItem<
                                                              TipoMovimentoEstoqueModel>(
                                                            value: value,
                                                            child: TextComponent(
                                                                value.descricao
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
                                      Row(
                                        children: [
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
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Container(
                                                child: InputComponent(
                                              controller:
                                                  controller.idPedidoController,
                                              label: 'ID Pedido',
                                              hintText: 'Digite o ID do pedido',
                                              onSaved: (value) {
                                                controller.idPedidoController
                                                    .text = value;
                                              },
                                            )),
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
                                          await controller.buscarMovimentos();
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
                              'ID Peça',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'ID Origem',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Tipo Movimento',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Data',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: const TextComponent(
                              'Funcionário',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Qtd Movimento',
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Saldo Disponível',
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Saldo Reservado',
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Saldo Box',
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: const TextComponent(
                              'Saldo Peça',
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
                                itemCount: controller.movimentos.length,
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
                                            controller.movimentos[index]
                                                .pecasEstoque!.id_peca
                                                .toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(controller
                                                  .movimentos[index]
                                                  .id_pedido_saida
                                                  ?.toString() ??
                                              controller.movimentos[index]
                                                  .id_pedido_entrada
                                                  ?.toString() ??
                                              controller.movimentos[index]
                                                  .id_ajuste_estoque
                                                  ?.toString() ??
                                              controller.movimentos[index]
                                                  .id_inventario
                                                  ?.toString() ??
                                              '-'),
                                        ),
                                        Expanded(
                                          child: TextComponent(controller
                                              .movimentos[index]
                                              .tipoMovimentoEstoque!
                                              .descricao
                                              .toString()),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                              '${DateFormat('dd/MM/yyyy').format(controller.movimentos[index].data_movimento!)}'),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TextComponent(controller
                                                  .movimentos[index]
                                                  .funcionario
                                                  ?.clienteFunc
                                                  ?.cliente
                                                  ?.nome
                                                  ?.toString() ??
                                              '-'),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            controller
                                                .movimentos[index].qtd_movimento
                                                .toString(),
                                            color: controller
                                                        .movimentos[index]
                                                        .tipoMovimentoEstoque!
                                                        .tipo_movimento! <
                                                    0
                                                ? vermelhoColor
                                                : controller
                                                            .movimentos[index]
                                                            .tipoMovimentoEstoque!
                                                            .tipo_movimento! >
                                                        0
                                                    ? primaryColor
                                                    : Colors.black,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            controller.movimentos[index]
                                                .saldo_disponivel
                                                .toString(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            controller.movimentos[index]
                                                .saldo_reservado
                                                .toString(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            controller
                                                .movimentos[index].saldo_box
                                                .toString(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            controller.movimentos[index]
                                                .saldo_total_peca
                                                .toString(),
                                            textAlign: TextAlign.center,
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
                              color: primaryColor,
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
