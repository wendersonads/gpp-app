import 'package:auth_migration/domain/model/enumeradores/situacao_asteca_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../domain/service/solicitacao_asteca_service_list.dart';
import '../../shared/components/ButtonComponent.dart';
import '../../shared/components/InputComponent.dart';
import '../../shared/components/LoadingComponent.dart';
import '../../shared/components/TextComponent.dart';
import '../../shared/components/button_acao_widget.dart';
import '../../shared/components/situacao_solicitacao_widget.dart';
import '../../shared/components/styles.dart';
import '../../shared/widgets/CardWidget.dart';
import '../../shared/widgets/NavBarWidget.dart';
import '../../widgets/sidebar_widget.dart';

class SolicitacaoAstecaList extends StatelessWidget {
  SolicitacaoAstecaList({Key? key}) : super(key: key);
  final controller = Get.put(SolicitacaoAstecaServiceList());

  Widget _buildFiltragem() {
    return Column(
      children: [
        const Text(
          'Solicitações de Astecas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: InputComponent(
                hintText: 'Buscar',
                controller: controller.buscarSolicitacaoFiltroController,
                onFieldSubmitted: (value) {
                  controller.buscarSolicitacoes();
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            ButtonComponent(
              icon: const Icon(
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
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: ButtonComponent(
                    color: primaryColor,
                    onPressed: () {
                      Get.offNamed('/criar-asteca');
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
            margin: const EdgeInsets.symmetric(
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
                            const SizedBox(
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
                            Expanded(
                              child: Obx(() {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SelectableText(
                                      'Situação',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child:
                                            DropdownButton<SituacaoAstecaEnum>(
                                          value:
                                              controller.situacaoFiltro.value,
                                          hint: const Text('Status'),
                                          onChanged: (value) {
                                            controller.situacaoFiltro.value =
                                                value;
                                          },
                                          items: SituacaoAstecaEnum.values.map<
                                                  DropdownMenuItem<
                                                      SituacaoAstecaEnum>>(
                                              (status) {
                                            return DropdownMenuItem<
                                                SituacaoAstecaEnum>(
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
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonComponent(
                        color: vermelhoColor,
                        colorHover: vermelhoColorHover,
                        onPressed: () {
                          controller.alternarVisibilidadeFormFiltragem();
                          controller.limparFiltros();
                          controller.buscarSolicitacoes();
                        },
                        text: 'Cancelar',
                      ),
                      const SizedBox(
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

                            await controller.buscarSolicitacoes();
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
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: CardWidget(
                        color: controller.solicitacoes[index].situacaoAsteca ==
                                2
                            ? primaryColorHover
                            : controller.solicitacoes[index].situacaoAsteca == 3
                                ? HexColor('#F44336')
                                : controller.solicitacoes[index]
                                            .situacaoAsteca ==
                                        4
                                    ? HexColor('#00CF80')
                                    : primaryColor,
                        widget: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const TextComponent(
                                    'ID',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SelectableText(
                                    '#${controller.solicitacoes[index].idAsteca.toString()}',
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const TextComponent(
                                    'Produto',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      controller.solicitacoes[index]
                                              .descricaoProduto ??
                                          '',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const TextComponent(
                                    'NF Venda',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      controller.solicitacoes[index]
                                                  .documentoFiscal !=
                                              null
                                          ? controller
                                              .solicitacoes[index]
                                              .documentoFiscal!
                                              .idDocumentoFiscal
                                              .toString()
                                          : '-',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const TextComponent(
                                    'Data Abertura',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SelectableText(
                                    DateFormat('dd/MM/yyyy').format(DateTime.parse(controller
                                        .solicitacoes[index].dataCriacao!) ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const TextComponent(
                                    'Situação',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(
                                    width: 48,
                                  ),
                                  Expanded(
                                    child: SituacaoSolicitacaoWidget(
                                      situacao: controller
                                          .solicitacoes[index].situacaoAsteca,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const TextComponent(
                                    'Ações',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ButtonAcaoWidget(
                                    detalhe: () {
                                      // Get.delete<
                                      //     SolicitacaoOSConsultaController>();

                                      Get.toNamed(
                                          '/astecas/${controller.solicitacoes[index].idAsteca}');
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : const LoadingComponent(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarWidget(),
      drawer: const Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Column(
          children: [
            _buildFiltragem(),
            _buildListagem(),
            // _buildPaginacao(),
          ],
        ),
      ),
    );
  }
}
