import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/GerarRelPedidosMovimento.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/views/entrada/controller/entrada_historico_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EntradaHistoricoDetalheViewDesktop extends StatelessWidget {
  EntradaHistoricoDetalheViewDesktop({Key? key}) : super(key: key);

  MaskFormatter maskFormatter = MaskFormatter();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EntradaHistoricoDetalheController>();

    return Scaffold(
        appBar: NavbarWidget(),
        backgroundColor: Colors.white,
        body: Row(
          children: [
            Sidebar(),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Obx(
                    () => !controller.carregandoMovimento.value
                        ? Expanded(
                            child: SingleChildScrollView(
                              controller: ScrollController(),
                              child: Column(
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Padding(padding: EdgeInsets.only(top: 20)),
                                        Row(
                                          children: [TitleComponent('Movimento da Entrada')],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 16),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: InputComponent(
                                                  label: 'Id Movimento',
                                                  readOnly: true,
                                                  initialValue: controller.idMovimento.toString(),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: InputComponent(
                                                  label: 'Funcionario',
                                                  readOnly: true,
                                                  initialValue: controller.movimentoEntradaModel.id_funcionario != null
                                                      ? controller.movimentoEntradaModel.id_funcionario.toString()
                                                      : '',
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: InputComponent(
                                                  label: 'Data Entrada',
                                                  readOnly: true,
                                                  // inputFormatter: [maskFormatter.dataFormatter()],
                                                  initialValue: controller.movimentoEntradaModel.data_entrada != null
                                                      ? DateFormat('dd/MM/yyyy')
                                                          .format(controller.movimentoEntradaModel.data_entrada!)
                                                      : '',
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
                                                  label: 'Nota Fiscal',
                                                  readOnly: true,
                                                  initialValue: controller.movimentoEntradaModel.num_nota_fiscal != null
                                                      ? controller.movimentoEntradaModel.num_nota_fiscal.toString()
                                                      : '',
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: InputComponent(
                                                  label: 'Série',
                                                  readOnly: true,
                                                  initialValue: controller.movimentoEntradaModel.serie != null
                                                      ? controller.movimentoEntradaModel.serie.toString()
                                                      : '',
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TitleComponent('Peças solicitadas'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 18),
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
                                            'Descrição',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: const TextComponent(
                                            'Quantidade Solicitada',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 200,
                                    child: ListView.builder(
                                      itemCount:
                                          controller.itensPedidosToList(controller.movimentoEntradaModel.pedidoEntrada!).length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 18),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(color: Colors.grey.shade100),
                                                  left: BorderSide(color: Colors.grey.shade100),
                                                  bottom: BorderSide(color: Colors.grey.shade100),
                                                  right: BorderSide(color: Colors.grey.shade100))),
                                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextComponent(
                                                      controller.itensPedidos[index].peca?.id_peca.toString() ?? '',
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextComponent(
                                                      controller.itensPedidos[index].peca?.descricao.toString() ?? '',
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextComponent(
                                                        controller.itensPedidos[index].quantidade?.toString() ?? ''),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TitleComponent('Peças que deram entrada'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 18),
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
                                            'Descrição',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: const TextComponent(
                                            'Quantidade Recebida',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 200,
                                    child: ListView.builder(
                                      itemCount: controller.movimentoEntradaModel.itemMovimentoEntradaModel?.length ?? 1,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 18),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(color: Colors.grey.shade100),
                                                  left: BorderSide(color: Colors.grey.shade100),
                                                  bottom: BorderSide(color: Colors.grey.shade100),
                                                  right: BorderSide(color: Colors.grey.shade100))),
                                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextComponent(
                                                      controller.movimentoEntradaModel.itemMovimentoEntradaModel?[index].pecaModel
                                                              ?.id_peca
                                                              .toString() ??
                                                          '',
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextComponent(
                                                      controller.movimentoEntradaModel.itemMovimentoEntradaModel?[index].pecaModel
                                                              ?.descricao ??
                                                          '',
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextComponent(controller
                                                            .movimentoEntradaModel.itemMovimentoEntradaModel?[index].quantidade
                                                            .toString() ??
                                                        ''),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TitleComponent('Pedido que deram entrada'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 18),
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                    color: Colors.grey.shade200,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: const TextComponent(
                                            'ID Pedido Entrada',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: const TextComponent(
                                            'ID Asteca',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: const TextComponent(
                                            'Data Emissão',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: const TextComponent(
                                            'Tipo',
                                            fontWeight: FontWeight.bold,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 200,
                                    child: ListView.builder(
                                      itemCount: controller.movimentoEntradaModel.pedidoEntrada?.length ?? 1,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 18),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(color: Colors.grey.shade100),
                                                  left: BorderSide(color: Colors.grey.shade100),
                                                  bottom: BorderSide(color: Colors.grey.shade100),
                                                  right: BorderSide(color: Colors.grey.shade100))),
                                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextComponent(
                                                      controller.movimentoEntradaModel.pedidoEntrada?[index].idPedidoEntrada
                                                              .toString() ??
                                                          '',
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextComponent(
                                                      controller.movimentoEntradaModel.pedidoEntrada?[index].asteca?.idAsteca
                                                              .toString() ??
                                                          '',
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextComponent(
                                                      controller.movimentoEntradaModel.pedidoEntrada?[index].dataEmissao == null
                                                          ? ''
                                                          : DateFormat('dd/MM/yyyy').format(controller
                                                              .movimentoEntradaModel.pedidoEntrada![index].dataEmissao!),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: EventoStatusWidget(
                                                      texto: controller
                                                                  .movimentoEntradaModel.pedidoEntrada?[index].asteca?.idAsteca !=
                                                              null
                                                          ? 'Asteca'
                                                          : 'Manual',
                                                      color: controller
                                                                  .movimentoEntradaModel.pedidoEntrada?[index].asteca?.idAsteca !=
                                                              null
                                                          ? HexColor('#040491')
                                                          : HexColor('#0DE8A6'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ButtonComponent(
                                            color: primaryColor,
                                            colorHover: primaryColorHover,
                                            onPressed: () {
                                              Get.back();
                                            },
                                            text: 'Voltar'),
                                        Obx(
                                          () => !controller.carregandoRelatorio.value
                                              ? controller.movimentoEntradaModel.pedidoEntrada!.isNotEmpty
                                                  ? ButtonComponent(
                                                      color: primaryColor,
                                                      colorHover: primaryColorHover,
                                                      onPressed: () async {
                                                        await controller.carregarRelatorioPedidosMovimento();
                                                        await GerarRelPedidosMovimento(movimento: controller.relatorio)
                                                            .imprimirPDF();
                                                      },
                                                      text: 'Imprimir Relatório')
                                                  : Container()
                                              : LoadingComponent(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Expanded(child: LoadingComponent()),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
