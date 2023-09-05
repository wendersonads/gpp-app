import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/asteca/asteca_tipo_pendencia_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/CheckboxComponent.dart';
import 'package:gpp/src/shared/components/DropdownButtonFormFieldComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/asteca/controller/asteca_controller.dart';

import 'package:gpp/src/views/peca/controller/peca_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:intl/intl.dart';

class AstecaDesktop extends StatelessWidget {
  AstecaDesktop({Key? key}) : super(key: key);

  final controller = Get.find<AstecaController>();

  tipoAsteca(int? tipoAsteca) {
    switch (tipoAsteca) {
      case 1:
        return 'Cliente';
      case 2:
        return 'Estoque';
      default:
        return 'Aguardando tipo de asteca';
    }
  }

  menuExibido({int? exibido}) {
    switch (controller.selected.value) {
      case 1:
        return astecasNormais();
      case 2:
        return astecasAtendidmento();
    }
  }

  situacao(DateTime data) {
    int diasEmAtraso = DateTime.now().difference(data).inDays;
    //Se os dias em atraso for menor que 15 dias, situação = verde
    if (diasEmAtraso < 15) {
      return Colors.green;
    }
    //Se os dias em atraso for maior que 15 e menor que 30, situação = amarela
    if (diasEmAtraso > 15 && diasEmAtraso < 30) {
      return Colors.yellow;
    }
    //Se os dias em atraso for maior que 30, situação = vermelha

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      body: WillPopScope(
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Expanded(child: Sidebar()),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Row(
                          children: [
                            Expanded(child: TitleComponent('Astecas')),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: InputComponent(
                                    hintText: 'Buscar',
                                    onFieldSubmitted: (value) async {
                                      controller.buscarFiltro = value;

                                      if (controller.selected.value == 1) {
                                        controller.astecas.clear();
                                        await controller.buscarAstecas();
                                      } else {
                                        controller.astecas.clear();
                                        await controller.buscarAstecasAtendimento();
                                      }
                                    },
                                  )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  ButtonComponent(
                                      color: secundaryColor,
                                      colorHover: secundaryColorHover,
                                      onPressed: () async {
                                        controller.filtro(!controller.filtro.value);
                                      },
                                      text: 'Adicionar filtro')
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Obx((() => !controller.carregandoAstecaTipoPendencias.value
                          ? AnimatedContainer(
                              height: controller.filtro.value ? null : 0,
                              duration: Duration(milliseconds: 500),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Form(
                                  key: controller.formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Obx(() => controller.selected.value == 1
                                              ? Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextComponent('Pendência'),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      DropdownButtonFormFieldComponent(
                                                        hintText:
                                                            '${controller.astecaTipoPendencias.first.idTipoPendencia} - ${controller.astecaTipoPendencias.first.descricao.toString().capitalize}',
                                                        onChanged: (AstecaTipoPendenciaModel value) {
                                                          controller.astecaTipoPendenciaFiltro = value.idTipoPendencia.toString();
                                                        },
                                                        items: controller.astecaTipoPendencias
                                                            .map<DropdownMenuItem<AstecaTipoPendenciaModel>>((value) {
                                                          return DropdownMenuItem<AstecaTipoPendenciaModel>(
                                                            value: value,
                                                            child: TextComponent(
                                                                '${value.idTipoPendencia} - ${value.descricao.toString().capitalize}'),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox.shrink()),
                                          SizedBox(width: controller.selected.value == 1 ? 8 : 0),
                                          Expanded(
                                            child: InputComponent(
                                              inputFormatter: [
                                                FilteringTextInputFormatter.digitsOnly,
                                                CpfOuCnpjFormatter(),
                                              ],
                                              label: 'CPF ou CNPJ:',
                                              maxLines: 1,
                                              validator: (value) {
                                                //    validator.cpfOuCnpj(UtilBrasilFields.removeCaracteres(value));
                                              },
                                              onSaved: (value) {
                                                if (value.toString().isNotEmpty) {
                                                  controller.cpfCnpjFiltro = UtilBrasilFields.removeCaracteres(value);
                                                }
                                              },
                                              hintText: 'Digite o CPF ou CNPJ',
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
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
                                                  controller.dataInicioFiltro = value;
                                                }
                                              },
                                              hintText: 'DD/MM/AAAA',
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: InputComponent(
                                              inputFormatter: [controller.maskFormatter.dataFormatter()],
                                              label: '',
                                              maxLines: 1,
                                              onSaved: (value) {
                                                if (value.length == 10) {
                                                  controller.dataFimFiltro = value;
                                                }
                                              },
                                              hintText: 'DD/MM/AAAA',
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Obx(() => controller.selected.value != 2
                                              ? Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextComponent("Vínculo de Asteca"),
                                                      const SizedBox(height: 6),
                                                      ListTile(
                                                        title: const Text('Somente Astecas com pedidos vinculados'),
                                                        leading: CheckboxComponent(
                                                          value: controller.filtroAstecaPedidos.value,
                                                          onChanged: (value) {
                                                            controller.mudarRadioFiltro();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox.shrink())
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ButtonComponent(
                                                color: vermelhoColor,
                                                colorHover: vermelhoColorHover,
                                                onPressed: () async {
                                                  controller.limparFiltros();
                                                  controller.formKey.currentState!.reset();
                                                },
                                                text: 'Limpar'),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            ButtonComponent(
                                                onPressed: () async {
                                                  // if (astecaController.filtroExpandidoFormKey.currentState!.validate()) {

                                                  controller.filtro(false);
                                                  controller.formKey.currentState!.save();

                                                  if (controller.selected.value == 1) {
                                                    controller.astecas.clear();
                                                    await controller.buscarAstecas();
                                                  } else {
                                                    controller.astecas.clear();
                                                    await controller.buscarAstecasAtendimento();
                                                  }
                                                },
                                                text: 'Pesquisar'),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container())),
                      Obx(
                        (() => Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              child: Row(children: [
                                GestureDetector(
                                  onTap: () async {
                                    controller.selected(1);
                                    controller.menu();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: controller.selected.value == 1 ? secundaryColor : Colors.grey.shade200,
                                                  width: controller.selected.value == 1 ? 4 : 1))),
                                      child: TextComponent('Em aberto')),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.selected(2);
                                    controller.menu();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: controller.selected.value == 2 ? secundaryColor : Colors.grey.shade200,
                                                  width: controller.selected.value == 2 ? 4 : 1))),
                                      child: TextComponent('Em atendimento')),
                                ),
                              ]),
                            )),
                      ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(vertical: 8),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       Row(children: [
                      //         Container(
                      //           height: 12,
                      //           width: 12,
                      //           decoration: BoxDecoration(
                      //             color: Colors.green,
                      //             borderRadius: BorderRadius.only(
                      //                 topLeft: Radius.circular(2),
                      //                 topRight: Radius.circular(2),
                      //                 bottomLeft: Radius.circular(2),
                      //                 bottomRight: Radius.circular(2)),
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           width: 8,
                      //         ),
                      //         TextComponent(
                      //             'Tempo de abertura inferior à 15 dias')
                      //       ]),
                      //       SizedBox(
                      //         width: 8,
                      //       ),
                      //       Row(children: [
                      //         Container(
                      //           height: 12,
                      //           width: 12,
                      //           decoration: BoxDecoration(
                      //             color: Colors.yellow,
                      //             borderRadius: BorderRadius.only(
                      //                 topLeft: Radius.circular(2),
                      //                 topRight: Radius.circular(2),
                      //                 bottomLeft: Radius.circular(2),
                      //                 bottomRight: Radius.circular(2)),
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           width: 8,
                      //         ),
                      //         TextComponent(
                      //             'Tempo de abertura superior à 15 dias')
                      //       ]),
                      //       SizedBox(
                      //         width: 8,
                      //       ),
                      //       Row(children: [
                      //         Container(
                      //           height: 12,
                      //           width: 12,
                      //           decoration: BoxDecoration(
                      //             color: Colors.red,
                      //             borderRadius: BorderRadius.only(
                      //                 topLeft: Radius.circular(2),
                      //                 topRight: Radius.circular(2),
                      //                 bottomLeft: Radius.circular(2),
                      //                 bottomRight: Radius.circular(2)),
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           width: 8,
                      //         ),
                      //         TextComponent(
                      //             'Tempo de abertura superior à 30 dias')
                      //       ]),
                      //     ],
                      //   ),
                      // ),
                      Obx(() => menuExibido()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onWillPop: () async => false,
      ),
    );
  }

  astecasNormais() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
                child: Obx(() => !controller.carregando.value
                    ? ListView.builder(
                        itemCount: controller.astecas.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: CardWidget(
                              color: situacao(controller.astecas[index].dataEmissao!),
                              widget: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextComponent(
                                          'ID da asteca',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                          child: TextComponent(
                                        'Nome',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          child: TextComponent(
                                        'Data de abertura',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          child: TextComponent(
                                        'Tipo asteca',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          flex: 2,
                                          child: TextComponent(
                                            'Pendência',
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                          child: TextComponent(
                                        'Ações',
                                        fontWeight: FontWeight.bold,
                                      ))
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: SelectableText(
                                        '# ${controller.astecas[index].idAsteca}',
                                      )),
                                      Expanded(
                                          child: SelectableText(
                                        '${controller.astecas[index].documentoFiscal?.nome.toString().capitalize ?? ''}',
                                      )),
                                      Expanded(
                                          child: SelectableText(
                                        '${DateFormat('dd/MM/yyyy').format(controller.astecas[index].dataEmissao!)}',
                                      )),
                                      Expanded(
                                          child: SelectableText(
                                        tipoAsteca(controller.astecas[index].tipoAsteca),
                                      )),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            EventoStatusWidget(
                                              texto: controller.astecas[index].astecaPendencias?.length != 0
                                                  ? '${controller.astecas[index].astecaPendencias?.last.astecaTipoPendencia?.idTipoPendencia ?? ''} - ${controller.astecas[index].astecaPendencias?.last.astecaTipoPendencia?.descricao?.toString().capitalize ?? ''}'
                                                  : 'Aguardando status',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ButtonAcaoWidget(detalhe: () {
                                          Get.delete<PecaDetalheController>();
                                          // Get.keys[1]!.currentState!
                                          //     .pushNamed('/astecas/${controller.astecas[index].idAsteca}');
                                          Get.toNamed('/astecas/' + controller.astecas[index].idAsteca.toString());
                                        }),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : LoadingComponent())),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 4,
            ),
            child: GetBuilder<AstecaController>(
                builder: (_) => PaginacaoComponent(
                      total: controller.pagina.getTotal(),
                      atual: controller.pagina.getAtual(),
                      primeiraPagina: () {
                        controller.pagina.primeira();
                        controller.buscarAstecas();
                      },
                      anteriorPagina: () {
                        controller.pagina.anterior();
                        controller.buscarAstecas();
                      },
                      proximaPagina: () {
                        controller.pagina.proxima();
                        controller.buscarAstecas();
                      },
                      ultimaPagina: () {
                        controller.pagina.ultima();
                        controller.buscarAstecas();
                      },
                    )),
          ),
        ],
      ),
    );
  }

  astecasAtendidmento() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
                child: Obx(() => !controller.carregando.value
                    ? ListView.builder(
                        itemCount: controller.astecas.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: CardWidget(
                              color: situacao(controller.astecas[index].dataEmissao!),
                              widget: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextComponent(
                                          'ID da asteca',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                          child: TextComponent(
                                        'Nome',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          child: TextComponent(
                                        'Data de abertura',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          child: TextComponent(
                                        'Tipo asteca',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Expanded(
                                          flex: 2,
                                          child: TextComponent(
                                            'Pendência',
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                          child: TextComponent(
                                        'Ações',
                                        fontWeight: FontWeight.bold,
                                      ))
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: SelectableText(
                                        '# ${controller.astecas[index].idAsteca}',
                                      )),
                                      Expanded(
                                          child: SelectableText(
                                        '${controller.astecas[index].documentoFiscal?.nome.toString().capitalize ?? ''}',
                                      )),
                                      Expanded(
                                          child: SelectableText(
                                        '${DateFormat('dd/MM/yyyy').format(controller.astecas[index].dataEmissao!)}',
                                      )),
                                      Expanded(
                                          child: SelectableText(
                                        tipoAsteca(controller.astecas[index].tipoAsteca),
                                      )),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            EventoStatusWidget(
                                              texto: controller.astecas[index].astecaPendencias?.length != 0
                                                  ? '${controller.astecas[index].astecaPendencias?.last.astecaTipoPendencia?.idTipoPendencia ?? ''} - ${controller.astecas[index].astecaPendencias?.last.astecaTipoPendencia?.descricao.toString().capitalize ?? ''}'
                                                  : 'Aguardando status',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ButtonAcaoWidget(detalhe: () {
                                          Get.delete<PecaDetalheController>();
                                          // Get.keys[1]!.currentState!
                                          //     .pushNamed('/astecas/${controller.astecas[index].idAsteca}');
                                          Get.toNamed('/astecas/' + controller.astecas[index].idAsteca.toString());
                                        }),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : LoadingComponent())),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 4,
            ),
            child: GetBuilder<AstecaController>(
                builder: (_) => PaginacaoComponent(
                      total: controller.paginaAtendimento.getTotal(),
                      atual: controller.paginaAtendimento.getAtual(),
                      primeiraPagina: () async {
                        controller.paginaAtendimento.primeira();
                        await controller.buscarAstecasAtendimento();
                      },
                      anteriorPagina: () async {
                        controller.paginaAtendimento.anterior();
                        await controller.buscarAstecasAtendimento();
                      },
                      proximaPagina: () async {
                        controller.paginaAtendimento.proxima();
                        await controller.buscarAstecasAtendimento();
                      },
                      ultimaPagina: () async {
                        controller.paginaAtendimento.ultima();
                        await controller.buscarAstecasAtendimento();
                      },
                    )),
          ),
        ],
      ),
    );
  }
}

class SLAWidget extends StatelessWidget {
  final String texto;
  final Color? color;
  const SLAWidget({
    Key? key,
    required this.texto,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 260,
      constraints: BoxConstraints(minWidth: 150, maxWidth: 150),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(color: color ?? primaryColor, borderRadius: BorderRadius.circular(5)),
      child: TextComponent(
        texto,
        fontSize: context.textScaleFactor * 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
