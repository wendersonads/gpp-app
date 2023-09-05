import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/box_enderecamento_model.dart';
import 'package:gpp/src/models/corredor_enderecamento_model.dart';
import 'package:gpp/src/models/estante_enderecamento_model.dart';
import 'package:gpp/src/models/piso_enderecamento_model.dart';
import 'package:gpp/src/models/prateleira_enderecamento_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/DropdownButtonFormFieldComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';

import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/ImprimirQrCodeBox.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/estoque/controllers/estoque_controller.dart';
import 'package:gpp/src/views/estoque/controllers/estoque_detalhe_controller.dart';

import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';

import '../../../widgets/sidebar_widget.dart';

class EstoqueViewDesktop extends StatelessWidget {
  const EstoqueViewDesktop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EstoqueController());

    return Scaffold(
      appBar: NavbarWidget(),
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Sidebar(),
            Expanded(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: TitleComponent(Get.currentRoute == '/estoques'
                              ? 'Estoque'
                              : 'Endereçamento'),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                  child: InputComponent(
                                hintText: 'Buscar',
                                onChanged: (value) => controller.buscar = value,
                                onFieldSubmitted: (value) {
                                  controller.buscarPecaEstoques();
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
                                    await controller.buscarPisos();
                                  },
                                  text: 'Adicionar filtro')
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(
                    () => AnimatedContainer(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10)),
                      margin:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      duration: Duration(milliseconds: 500),
                      height: controller.filtro.value ? null : 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 16),
                                child: GetBuilder<EstoqueController>(
                                  builder: (_) => Form(
                                    key: controller.formKey,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Obx(
                                          () => !controller
                                                  .carregandoPisos.value
                                              ? Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child:
                                                        DropdownButtonFormFieldComponent(
                                                      label: 'Piso',
                                                      hintText: controller
                                                              .piso?.desc_piso
                                                              ?.toString() ??
                                                          'Selecione o piso',
                                                      onChanged: (value) async {
                                                        controller.piso = value;
                                                        controller.corredor =
                                                            CorredorEnderecamentoModel();

                                                        await controller
                                                            .buscarCorredor(
                                                                value.id_piso!);
                                                      },
                                                      items: controller.pisos.map<
                                                              DropdownMenuItem<
                                                                  PisoEnderecamentoModel>>(
                                                          (PisoEnderecamentoModel
                                                              value) {
                                                        return DropdownMenuItem<
                                                            PisoEnderecamentoModel>(
                                                          value: value,
                                                          child: TextComponent(
                                                              value.desc_piso!),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        Obx(
                                          () => !controller
                                                  .carregandoCorredores.value
                                              ? Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child:
                                                        DropdownButtonFormFieldComponent(
                                                      label: 'Corredor',
                                                      hintText: controller
                                                              .corredor!
                                                              .desc_corredor
                                                              ?.toString() ??
                                                          'Selecione o corredor',
                                                      onChanged:
                                                          (CorredorEnderecamentoModel
                                                              value) async {
                                                        controller.prateleira =
                                                            PrateleiraEnderecamentoModel();
                                                        controller.corredor =
                                                            value;
                                                        await controller
                                                            .buscarEstantes(value
                                                                .id_corredor!);
                                                      },
                                                      items: controller.corredores.map<
                                                              DropdownMenuItem<
                                                                  CorredorEnderecamentoModel>>(
                                                          (CorredorEnderecamentoModel
                                                              value) {
                                                        return DropdownMenuItem<
                                                            CorredorEnderecamentoModel>(
                                                          value: value,
                                                          child: TextComponent(
                                                              value
                                                                  .desc_corredor!),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        Obx(
                                          () => !controller
                                                  .carregandoEstantes.value
                                              ? Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child:
                                                        DropdownButtonFormFieldComponent(
                                                      label: 'Estante',
                                                      hintText: controller
                                                              .estante!
                                                              .desc_estante
                                                              ?.toString() ??
                                                          'Selecione a estante',
                                                      onChanged:
                                                          (EstanteEnderecamentoModel
                                                              value) async {
                                                        controller.estante =
                                                            value;
                                                        await controller
                                                            .buscarPrateleiras(
                                                                value
                                                                    .id_estante!);
                                                      },
                                                      items: controller.estantes.map<
                                                              DropdownMenuItem<
                                                                  EstanteEnderecamentoModel>>(
                                                          (EstanteEnderecamentoModel
                                                              value) {
                                                        return DropdownMenuItem<
                                                            EstanteEnderecamentoModel>(
                                                          value: value,
                                                          child: TextComponent(
                                                              value
                                                                  .desc_estante!),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        Obx(
                                          () => !controller
                                                  .carregandoPrateleira.value
                                              ? Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child:
                                                        DropdownButtonFormFieldComponent(
                                                      label: 'Prateleira',
                                                      hintText: controller
                                                              .prateleira!
                                                              .desc_prateleira
                                                              ?.toString() ??
                                                          'Selecione a prateleira',
                                                      onChanged:
                                                          (PrateleiraEnderecamentoModel
                                                              value) async {
                                                        controller.prateleira =
                                                            value;
                                                        await controller
                                                            .buscarBoxs(value
                                                                .id_prateleira!);
                                                      },
                                                      items: controller.prateleiras.map<
                                                              DropdownMenuItem<
                                                                  PrateleiraEnderecamentoModel>>(
                                                          (PrateleiraEnderecamentoModel
                                                              value) {
                                                        return DropdownMenuItem<
                                                            PrateleiraEnderecamentoModel>(
                                                          value: value,
                                                          child: TextComponent(value
                                                              .desc_prateleira!),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        Obx(
                                          () => !controller.carregandoBoxs.value
                                              ? Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child:
                                                        DropdownButtonFormFieldComponent(
                                                      label: 'Box',
                                                      hintText: controller
                                                              .box!.desc_box
                                                              ?.toString() ??
                                                          'Selecione o box',
                                                      onChanged:
                                                          (BoxEnderecamentoModel
                                                              value) async {
                                                        controller.endereco =
                                                            value.id_box
                                                                .toString();
                                                        controller.box = value;
                                                      },
                                                      items: controller.boxs.map<
                                                              DropdownMenuItem<
                                                                  BoxEnderecamentoModel>>(
                                                          (BoxEnderecamentoModel
                                                              value) {
                                                        return DropdownMenuItem<
                                                            BoxEnderecamentoModel>(
                                                          value: value,
                                                          child: TextComponent(
                                                              value.desc_box!),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ButtonComponent(
                                      color: vermelhoColor,
                                      colorHover: vermelhoColorHover,
                                      onPressed: () async {
                                        controller.limparFiltro();
                                      },
                                      text: 'Limpar'),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  ButtonComponent(
                                      onPressed: () async {
                                        controller.filtro(false);
                                        await controller.buscarPecaEstoques();
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
                  Expanded(
                    child: Obx(
                      () => !controller.carregando.value
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: ListView.builder(
                                itemCount: controller.pecaEstoques.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: CardWidget(
                                      widget: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: const TextComponent(
                                                    'Filial',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: const TextComponent(
                                                    'Endereço',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: const TextComponent(
                                                    'ID da peça',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: const TextComponent(
                                                    'Descrição da peça',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: const TextComponent(
                                                    'Disponível',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: const TextComponent(
                                                    'Reservado',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: const TextComponent(
                                                    'Transferência',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: const TextComponent(
                                                    'Ações',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    SelectableText(
                                                        '${controller.pecaEstoques[index].filial.toString()}')
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: SelectableText(
                                                      controller
                                                          .pecaEstoques[index]
                                                          .endereco
                                                          .toString())),
                                              Expanded(
                                                  child: SelectableText(
                                                      controller
                                                              .pecaEstoques[
                                                                  index]
                                                              .peca
                                                              ?.id_peca
                                                              .toString()
                                                              .capitalize ??
                                                          '')),
                                              Expanded(
                                                  flex: 2,
                                                  child: SelectableText(
                                                      controller
                                                              .pecaEstoques[
                                                                  index]
                                                              .peca
                                                              ?.descricao
                                                              .toString()
                                                              .capitalize ??
                                                          '')),
                                              Expanded(
                                                  child: SelectableText(
                                                      controller
                                                          .pecaEstoques[index]
                                                          .saldo_disponivel
                                                          .toString())),
                                              Expanded(
                                                  child: SelectableText(
                                                      controller
                                                          .pecaEstoques[index]
                                                          .saldo_reservado
                                                          .toString())),
                                              Expanded(
                                                  child: SelectableText(controller
                                                      .pecaEstoques[index]
                                                      .quantidade_transferencia
                                                      .toString())),
                                              Expanded(
                                                child: ButtonAcaoWidget(
                                                  qrCode: () async {
                                                    if (controller
                                                            .pecaEstoques[index]
                                                            .id_box ==
                                                        null) {
                                                      Notificacao.snackBar(
                                                          'Erro ao realizar a impressão da etiqueta de QR Code, este estoque não possui endereçamento');
                                                    }
                                                    if (controller
                                                            .pecaEstoques[index]
                                                            .id_box !=
                                                        null) {
                                                      await ImprimirQrCodeBox(
                                                              pecaEstoque:
                                                                  controller
                                                                          .pecaEstoques[
                                                                      index])
                                                          .imprimirQrCode();
                                                    }
                                                    if (controller
                                                        .pecaEstoques[index]
                                                        .endereco!
                                                        .contains(
                                                            'Box Saída')) {
                                                      Notificacao.snackBar(
                                                          'Não é possivel realizar a impressão de um Box de Saída');
                                                    }
                                                    if (controller
                                                        .pecaEstoques[index]
                                                        .endereco!
                                                        .contains(
                                                            'Box Entrada')) {
                                                      Notificacao.snackBar(
                                                          'Não é possivel realizar a impressão de um Box de Entrada');
                                                    }
                                                  },
                                                  editar: () {
                                                    Get.offAllNamed(
                                                        '/estoque-ajuste/${controller.pecaEstoques[index].id_peca_estoque}');
                                                  },
                                                  transferencia: () {
                                                    Get.delete<
                                                        EstoqueDetalheController>();
                                                    Get.toNamed(
                                                        '/estoques/${controller.pecaEstoques[index].id_peca_estoque}');
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : LoadingComponent(),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                    child: GetBuilder<EstoqueController>(
                      builder: (_) => PaginacaoComponent(
                        total: controller.pagina.getTotal(),
                        atual: controller.pagina.getAtual(),
                        primeiraPagina: () {
                          controller.pagina.primeira();
                          controller.buscarPecaEstoques();
                        },
                        anteriorPagina: () {
                          controller.pagina.anterior();
                          controller.buscarPecaEstoques();
                        },
                        proximaPagina: () {
                          controller.pagina.proxima();
                          controller.buscarPecaEstoques();
                        },
                        ultimaPagina: () {
                          controller.pagina.ultima();
                          controller.buscarPecaEstoques();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
