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
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/solicitacao_os/controllers/solicitacao_os_consulta_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:gpp/src/views/widgets/situacao_solicitacao_os_widget.dart';

class SolicitacaoOSConsultaMobile extends StatelessWidget {
  final controller = Get.find<SolicitacaoOSConsultaController>();

  Widget _buildFiltragem() {
    return Column(
      children: [
        Text(
          'Solicitações de OS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
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
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: ButtonComponent(
                    color: primaryColor,
                    onPressed: () {
                      Get.offNamed('/solicitacao-os/criar');
                    },
                    text: 'Criar Solicitação',
                  ),
                ),
              ],
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
                    child: Column(
                      children: [
                        Row(
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
                                  controller.dataInicioFiltro =
                                      DateFormat('dd/MM/yyyy').parse(value);
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
                                  controller.dataFimFiltro =
                                      DateFormat('dd/MM/yyyy').parse(value);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
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
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            onSaved: (value) {
                                              controller.filialFiltro =
                                                  value.isEmpty ? null : value;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SelectableText(
                                      'Situação',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<StatusOSEnum>(
                                          value:
                                              controller.situacaoFiltro.value,
                                          hint: Text('Status'),
                                          onChanged: (value) {
                                            controller.situacaoFiltro.value =
                                                value;
                                          },
                                          items: StatusOSEnum.values.map<
                                              DropdownMenuItem<
                                                  StatusOSEnum>>((status) {
                                            return DropdownMenuItem<
                                                StatusOSEnum>(
                                              value: status,
                                              child: Text(status.name),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
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
                          controller.formFiltragemSolicitacoesKey.currentState!
                              .reset();
                          controller.limparFiltros();
                          controller.buscarSolicitacoesOS();
                        },
                        text: 'Limpar',
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ButtonComponent(
                        onPressed: () async {
                          if (controller
                              .formFiltragemSolicitacoesKey.currentState!
                              .validate()) {
                            controller
                                .formFiltragemSolicitacoesKey.currentState!
                                .save();

                            await controller.buscarSolicitacoesOS();
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextComponent(
                                  'ID',
                                  fontWeight: FontWeight.bold,
                                ),
                                SelectableText(
                                  '#${controller.solicitacoes[index].idSolicitacao.toString()}',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Obx(
                              () => controller.usuarioAprovador.value
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextComponent(
                                              'Filial',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SelectableText(
                                              controller.solicitacoes[index]
                                                  .filialOrigem
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextComponent(
                                  'Produto',
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  width: 24,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    controller.solicitacoes[index]
                                            .itemSolicitacao?.nomeProduto ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextComponent(
                                  'Motivo Troca',
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  width: 24,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    controller.solicitacoes[index]
                                            .itemSolicitacao?.observacao ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextComponent(
                                  'NF Venda',
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  width: 24,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    controller.solicitacoes[index]
                                                .numDocFiscalVenda !=
                                            null
                                        ? controller.solicitacoes[index]
                                            .numDocFiscalVenda
                                            .toString()
                                        : '-',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextComponent(
                                  'Data Abertura',
                                  fontWeight: FontWeight.bold,
                                ),
                                SelectableText(
                                  DateFormat('dd/MM/yyyy').format(controller
                                      .solicitacoes[index].dataEmissao!),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextComponent(
                                  'Situação',
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  width: 48,
                                ),
                                Expanded(
                                  child: SituacaoSolicitacaoOSWidget(
                                    situacao:
                                        controller.solicitacoes[index].situacao,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextComponent(
                                  'Ações',
                                  fontWeight: FontWeight.bold,
                                ),
                                ButtonAcaoWidget(
                                  detalhe: () {
                                    // Get.delete<
                                    //     SolicitacaoOSConsultaController>();

                                    Get.toNamed(
                                        '/solicitacao-os/${controller.solicitacoes[index].idSolicitacao}');
                                  },
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
      drawer: Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Column(
          children: [
            _buildFiltragem(),
            _buildListagem(),
            _buildPaginacao(),
          ],
        ),
      ),
    );
  }
}
