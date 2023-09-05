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

class ExtratoEstoqueViewMobile extends StatelessWidget {
  const ExtratoEstoqueViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExtratoEstoqueController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
        // height: Get.height,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextComponent(
                    'Extrato de estoque',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
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
              height: 15,
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
                      //margin: EdgeInsets.symmetric(vertical: 16),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => !controller.carregandoTipoMovimento.value
                                        ? Container(
                                            child: DropdownButtonFormFieldComponent(
                                              label: 'Tipo Movimento',
                                              hintText: 'Selecione o piso',
                                              onChanged: (value) async {
                                                controller.tipoMovimentoController = value;
                                              },
                                              items: controller.tiposMovimento.map<DropdownMenuItem<TipoMovimentoEstoqueModel>>(
                                                  (TipoMovimentoEstoqueModel value) {
                                                return DropdownMenuItem<TipoMovimentoEstoqueModel>(
                                                  value: value,
                                                  child: TextComponent(value.descricao.toString()),
                                                );
                                              }).toList(),
                                            ),
                                          )
                                        : LoadingComponent(),
                                  ),
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
                                        controller.dataInicioController.text = DateFormat("dd/MM/yyyy").parse(value).toString();
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
                            Row(
                              children: [
                                Expanded(
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
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Container(
                                      child: InputComponent(
                                    controller: controller.idPedidoController,
                                    label: 'ID Pedido',
                                    hintText: 'Digite o ID do pedido',
                                    onSaved: (value) {
                                      controller.idPedidoController.text = value;
                                    },
                                  )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Padding(
                    //padding: const EdgeInsets.only(top: 8.0),
                    Row(
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
                              await controller.buscarMovimentos();
                              controller.filtro.value = false;
                            },
                            text: 'Pesquisar')
                      ],
                    ),
                    //),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Obx(
              () => !controller.carregandoExtrato.value
                  ? Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: new ScrollController(),
                        primary: false,
                        itemCount: controller.movimentos.length,
                        itemBuilder: (context, index) {
                          return Card(
                            //elevation: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: secundaryColor, width: 3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text('ID Peça: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: TextComponent(
                                            controller.movimentos[index].pecasEstoque!.id_peca.toString(),
                                          ),
                                        ),
                                        const Text('ID Origem: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: TextComponent(controller.movimentos[index].id_pedido_saida?.toString() ??
                                              controller.movimentos[index].id_pedido_entrada?.toString() ??
                                              controller.movimentos[index].id_ajuste_estoque?.toString() ??
                                              controller.movimentos[index].id_inventario?.toString() ??
                                              '-'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text('Tipo Movimento: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: TextComponent(
                                              controller.movimentos[index].tipoMovimentoEstoque!.descricao.toString()),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text('Funcionário: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Expanded(
                                          flex: 2,
                                          child: TextComponent(
                                              controller.movimentos[index].funcionario?.clienteFunc?.cliente?.nome?.toString() ??
                                                  '-'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text('Quantidade de Movimento: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextComponent(
                                          controller.movimentos[index].qtd_movimento.toString(),
                                          color: controller.movimentos[index].tipoMovimentoEstoque!.tipo_movimento! < 0
                                              ? vermelhoColor
                                              : controller.movimentos[index].tipoMovimentoEstoque!.tipo_movimento! > 0
                                                  ? primaryColor
                                                  : Colors.black,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text('Saldo Disponível: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextComponent(
                                          controller.movimentos[index].saldo_disponivel.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                        Expanded(child: Container()),
                                        const Text('Saldo Reservado: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextComponent(
                                          controller.movimentos[index].saldo_reservado.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text('Saldo Box: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextComponent(
                                          controller.movimentos[index].saldo_box.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                        Expanded(child: Container()),
                                        const Text('Saldo Peça: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextComponent(
                                          controller.movimentos[index].saldo_total_peca.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                        Expanded(child: Container()),
                                        const Text('Data: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextComponent(
                                            '${DateFormat('dd/MM/yyyy').format(controller.movimentos[index].data_movimento!)}'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(child: LoadingComponent()),
            ),

            //Padding(padding: EdgeInsets.symmetric(vertical: 35)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 82,
              child: ButtonComponent(
                  color: primaryColor,
                  onPressed: () {
                    Get.offAllNamed('/dashboard');
                  },
                  text: 'Voltar'),
            ),
            SizedBox(
              width: 24,
            )
          ],
        ),
      ),
    );
  }
}
