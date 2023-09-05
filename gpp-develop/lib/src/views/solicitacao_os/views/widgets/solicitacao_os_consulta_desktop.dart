import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/enums/status_os_enum.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/solicitacao_os/controllers/solicitacao_os_consulta_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:gpp/src/views/widgets/situacao_solicitacao_os_widget.dart';

class SolicitacaoOSConsultaDesktop extends StatelessWidget {
  final controller = Get.find<SolicitacaoOSConsultaController>();
  Widget _buildFiltragem() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TitleComponent('Solicitações de OS'),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InputComponent(
                      hintText: 'Buscar',
                      controller: controller.buscarSolicitacaoFiltroController,
                      onFieldSubmitted: (value) {
                        controller.buscarSolicitacoesOS();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ButtonComponent(
                    icon: Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      controller.alternarVisibilidadeFormFiltragem();
                    },
                    text: 'Filtrar',
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      ButtonComponent(
                        color: primaryColor,
                        onPressed: () {
                          Get.offNamed('/solicitacao-os/criar');
                        },
                        text: 'Criar Solicitação',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Obx(
          () => Container(
            height: controller.formFiltragemVisivel.value ? null : 0,
            margin: EdgeInsets.symmetric(
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Form(
                    key: controller.formFiltragemSolicitacoesKey,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InputComponent(
                            label: 'Período',
                            hintText: 'Data Início',
                            inputFormatter: [
                              controller.maskFormatter.dataFormatter(),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }

                              if (value.length != 10) {
                                return 'Data inválida';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              controller.dataInicioFiltro = DateFormat('dd/MM/yyyy').parse(value);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 1,
                          child: InputComponent(
                            label: '',
                            hintText: 'Data Fim',
                            inputFormatter: [
                              controller.maskFormatter.dataFormatter(),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }

                              if (value.length != 10) {
                                return 'Data inválida';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              controller.dataFimFiltro = DateFormat('dd/MM/yyyy').parse(value);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        controller.usuarioAprovador.value
                            ? Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: InputComponent(
                                        label: 'Filial',
                                        hintText: 'Filial',
                                        keyboardType: TextInputType.number,
                                        inputFormatter: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        onSaved: (value) {
                                          controller.filialFiltro = value.isEmpty ? null : value;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        Expanded(
                          flex: 2,
                          child: Obx(() {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SelectableText(
                                    'Situação',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<StatusOSEnum>(
                                        value: controller.situacaoFiltro.value,
                                        hint: Text('Status'),
                                        onChanged: (value) {
                                          controller.situacaoFiltro.value = value;
                                        },
                                        items: StatusOSEnum.values.map<DropdownMenuItem<StatusOSEnum>>((status) {
                                          return DropdownMenuItem<StatusOSEnum>(
                                            value: status,
                                            child: Text(status.name),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonComponent(
                        color: vermelhoColor,
                        colorHover: vermelhoColorHover,
                        onPressed: () {
                          controller.formFiltragemSolicitacoesKey.currentState!.reset();
                          controller.limparFiltros();
                          controller.buscarSolicitacoesOS();
                        },
                        text: 'Limpar',
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ButtonComponent(
                        onPressed: () {
                          if (controller.formFiltragemSolicitacoesKey.currentState!.validate()) {
                            controller.formFiltragemSolicitacoesKey.currentState!.save();

                            controller.buscarSolicitacoesOS();
                          }
                        },
                        text: 'Pesquisar',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListagem() {
    return Expanded(
      child: Obx(
        () => !controller.carregandoSolicitacoes.value
            ? ListView.builder(
                itemCount: controller.solicitacoes.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: CardWidget(
                      color: controller.solicitacoes[index].situacao == 2
                          ? HexColor('#00CF80')
                          : controller.solicitacoes[index].situacao == 3
                              ? HexColor('#F44336')
                              : primaryColor,
                      widget: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextComponent(
                                    'ID',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(
                                  () => controller.usuarioAprovador.value
                                      ? Expanded(
                                          child: TextComponent(
                                            'Filial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Container(),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: TextComponent(
                                    'Produto',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: TextComponent(
                                    'Motivo Troca',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextComponent(
                                    'NF Venda',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextComponent(
                                    'Data Abertura',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TextComponent(
                                    'Situação',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextComponent(
                                    'Ações',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    controller.solicitacoes[index].idSolicitacao.toString(),
                                  ),
                                ),
                                Obx(
                                  () => controller.usuarioAprovador.value
                                      ? Expanded(
                                          child: SelectableText(
                                            controller.solicitacoes[index].filialOrigem.toString(),
                                          ),
                                        )
                                      : Container(),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: SelectableText(
                                    controller.solicitacoes[index].itemSolicitacao?.nomeProduto ?? '',
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    controller.solicitacoes[index].itemSolicitacao?.observacao ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SelectableText(
                                    controller.solicitacoes[index].numDocFiscalVenda != null
                                        ? controller.solicitacoes[index].numDocFiscalVenda.toString()
                                        : '-',
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SelectableText(
                                    DateFormat('dd/MM/yyyy').format(controller.solicitacoes[index].dataEmissao!),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      SituacaoSolicitacaoOSWidget(
                                        situacao: controller.solicitacoes[index].situacao,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: ButtonAcaoWidget(
                                    detalhe: () {
                                      // Get.delete<
                                      //     SolicitacaoOSConsultaController>();

                                      Get.toNamed('/solicitacao-os/${controller.solicitacoes[index].idSolicitacao}');
                                    },
                                  ),
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
            : LoadingComponent(),
      ),
    );
  }

  Widget _buildPaginacao() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 24,
      ),
      child: GetBuilder<SolicitacaoOSConsultaController>(
        builder: (_) => PaginacaoComponent(
          primeiraPagina: () async {
            _.pagina.primeira();
            await _.buscarSolicitacoesOS();
          },
          anteriorPagina: () async {
            _.pagina.anterior();
            await _.buscarSolicitacoesOS();
          },
          proximaPagina: () async {
            _.pagina.proxima();
            await _.buscarSolicitacoesOS();
          },
          ultimaPagina: () async {
            _.pagina.ultima();
            await _.buscarSolicitacoesOS();
          },
          total: _.pagina.total,
          atual: _.pagina.atual,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Sidebar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                  right: 24,
                  left: 24,
                ),
                child: Column(
                  children: [
                    _buildFiltragem(),
                    _buildListagem(),
                    _buildPaginacao(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
