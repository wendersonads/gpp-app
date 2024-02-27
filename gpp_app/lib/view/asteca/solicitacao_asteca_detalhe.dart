import 'package:auth_migration/domain/service/solicitacao_asteca_detalhe_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../shared/components/ButtonComponent.dart';
import '../../shared/components/InputComponent.dart';
import '../../shared/components/LoadingComponent.dart';
import '../../shared/components/TextComponent.dart';
import '../../shared/components/TitleComponent.dart';
import '../../shared/components/situacao_solicitacao_widget.dart';
import '../../shared/components/styles.dart';
import '../../shared/widgets/NavBarWidget.dart';
import '../../widgets/sidebar_widget.dart';

class SolicitacaAstecaDetalhe extends StatelessWidget {
  SolicitacaAstecaDetalhe({super.key});
  final controller = Get.find<SolicitacaAstecaDetalheService>();
  Widget _buildBotoesPrincipais(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 24,
      ),
      child: Obx(
        () => controller.carregandoAtualizacaoSolicitacao.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 8,
                      right: 8,
                    ),
                    child: const LoadingComponent(),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonComponent(
                    color: primaryColor,
                    colorHover: primaryColorHover,
                    onPressed: () {
                      Get.delete<SolicitacaAstecaDetalheService>();
                      Get.toNamed('/astecas');
                    },
                    text: 'Voltar',
                  ),
                  controller.solicitacao.situacaoAsteca != 3 &&
                          controller.solicitacao.situacaoAsteca != 4
                      ? Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            controller.solicitacao.situacaoAsteca == 1
                                ? ButtonComponent(
                                    color: primaryColorHover,
                                    colorHover: primaryColorHover,
                                    onPressed: () async {
                                      controller.situacaoAsteca = 2;
                                      if (await controller
                                          .atualizarSolicitacao()) {
                                        Get.toNamed('/astecas');
                                      }
                                    },
                                    text: 'Executar',
                                  )
                                : controller.solicitacao.situacaoAsteca == 2
                                    ? ButtonComponent(
                                        onPressed: () async {
                                          controller.situacaoAsteca = 4;
                                          if (await controller
                                              .atualizarSolicitacao()) {
                                            Get.toNamed('/astecas');
                                          }
                                        },
                                        text: 'Finalizar',
                                      )
                                    : controller.solicitacao.situacaoAsteca == 3
                                        ? Container()
                                        : controller.solicitacao
                                                    .situacaoAsteca ==
                                                4
                                            ? Container()
                                            : Container(),
                            const SizedBox(
                              width: 8,
                            ),
                            ButtonComponent(
                              color: vermelhoColor,
                              colorHover: vermelhoColorHover,
                              onPressed: () async {
                                controller.situacaoAsteca = 3;
                                if (await controller.atualizarSolicitacao()) {
                                  Get.toNamed('/astecas');
                                }
                              },
                              text: 'Cancelar',
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }

  Widget _buildCamposIniciais() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            bottom: 32,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Solicitação de Asteca',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SituacaoSolicitacaoWidget(
                    situacao: controller.solicitacao.situacaoAsteca,
                  ),
                ],
              ),
            ],
          ),
        ),
        controller.solicitacao.situacaoAsteca != null
            ? Row(
                children: [
                  Expanded(
                    child: InputComponent(
                      label: 'ID Solicitação',
                      initialValue: controller.solicitacao.idAsteca != null
                          ? controller.solicitacao.idAsteca.toString()
                          : '',
                      readOnly: true,
                    ),
                  ),
                  Expanded(
                    child: InputComponent(
                      label: 'Data Solicitação',
                      initialValue: DateFormat('dd/MM/yyyy').format(
                        DateTime.parse(controller.solicitacao.dataCriacao!),
                      ),
                      readOnly: true,
                    ),
                  )
                ],
              )
            : Container(),
        controller.solicitacao.situacaoAsteca != 4
            ? Row(
                children: [
                  controller.solicitacao.situacaoAsteca == 2
                      ? Expanded(
                          child: InputComponent(
                            label: 'Data Inicio Execução',
                            initialValue:
                                controller.solicitacao.dataInicioAsteca != ''
                                    ? DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(controller
                                            .solicitacao.dataInicioAsteca!),
                                      )
                                    : '',
                            readOnly: true,
                          ),
                        )
                      : controller.solicitacao.situacaoAsteca == 3
                          ? Expanded(
                              child: InputComponent(
                                label: 'Data Cancelamento',
                                initialValue:
                                    controller.solicitacao.dataInicioAsteca !=
                                            ''
                                        ? DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(controller
                                                .solicitacao.dataCancela!),
                                          )
                                        : '',
                                readOnly: true,
                              ),
                            )
                          : Container(),
                  controller.solicitacao.dataInicioAsteca != ''
                      ? Expanded(
                          child: InputComponent(
                            label: 'Data Inicio Execução',
                            initialValue:
                                controller.solicitacao.dataInicioAsteca != ''
                                    ? DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(controller
                                            .solicitacao.dataInicioAsteca!),
                                      )
                                    : '',
                            readOnly: true,
                          ),
                        )
                      : Container(),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: InputComponent(
                      label: 'Data Inicio Execução',
                      initialValue:
                          controller.solicitacao.dataInicioAsteca != ''
                              ? DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(
                                      controller.solicitacao.dataInicioAsteca!),
                                )
                              : '',
                      readOnly: true,
                    ),
                  ),
                  Expanded(
                    child: InputComponent(
                      label: 'Data Finalização',
                      initialValue: controller.solicitacao.dataFinaliza != ''
                          ? DateFormat('dd/MM/yyyy').format(
                              DateTime.parse(
                                  controller.solicitacao.dataFinaliza!),
                            )
                          : '',
                      readOnly: true,
                    ),
                  )
                ],
              ),
        const SizedBox(
          width: 8,
        ),
        Row(
          children: [
            Expanded(
              child: InputComponent(
                label: 'Produto.',
                keyboardType: TextInputType.number,
                initialValue: controller.solicitacao.descricaoProduto,
                readOnly: true,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: InputComponent(
                label: 'Motivo Criação',
                initialValue:
                    controller.solicitacao.motivoCriacaoAsteca?.denominacao,
                readOnly: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCamposNotaFiscalVenda() {
    return Column(children: [
      Row(
        children: [
          Icon(
            Icons.article,
            size: 32,
          ),
          SizedBox(
            width: 8,
          ),
          TitleComponent('Nota Fiscal'),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        color: Colors.grey.shade200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextComponent(
                'NF',
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: const TextComponent(
                'Série',
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              flex: 2,
              child: const TextComponent(
                'Dt Emissão',
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: const TextComponent(
                'Desc',
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: const TextComponent(
                'Fornec',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Text(
              controller.solicitacao.documentoFiscal!.numDocFiscal.toString(),
              style: textStyle(
                fontWeight: FontWeight.normal,
              )),
        ),
        Expanded(
          child: Text(
              controller.solicitacao.documentoFiscal!.serieDocFiscal.toString(),
              style: textStyle(
                fontWeight: FontWeight.normal,
              )),
        ),
        Expanded(
          flex: 2,
          child: SelectableText(
            DateFormat('dd/MM/yyyy').format(DateTime.parse(
                controller.solicitacao.documentoFiscal!.dataEmissao!)),
          ),
        ),
        Expanded(
          child:
              Text(controller.solicitacao.documentoFiscal!.descricao.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: textStyle(
                    fontWeight: FontWeight.normal,
                  )),
        ),
        Expanded(
          child: Text(
              controller.solicitacao.documentoFiscal!.fornecedor.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: textStyle(
                fontWeight: FontWeight.normal,
              )),
        ),
      ]),
      const SizedBox(
        height: 20,
      ),
    ]);
  }

  Widget _buildPecaSeleionada() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.handyman_rounded,
              size: 32,
            ),
            SizedBox(
              width: 8,
            ),
            TitleComponent('Peças Selecionadas'),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: Get.height * 0.40,
          child: controller.solicitacao.itensAsteca != null
              ? ListView.builder(
                  itemCount: controller.solicitacao.itensAsteca?.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: GetBuilder<SolicitacaAstecaDetalheService>(
                        builder: (_) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                border: Border(
                                    top:
                                        BorderSide(color: Colors.grey.shade100),
                                    left:
                                        BorderSide(color: Colors.grey.shade100),
                                    bottom:
                                        BorderSide(color: Colors.grey.shade100),
                                    right: BorderSide(
                                        color: Colors.grey.shade100))),
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
                                    Expanded(
                                      child: const TextComponent(
                                        'Nome',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: const TextComponent(
                                        'Quantidade',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Expanded(
                                      child: TextComponent(
                                        'Saldo',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          '${_.solicitacao.itensAsteca![index].pecaEstoque?.peca?.idPeca}'),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${_.solicitacao.itensAsteca![index].pecaEstoque?.peca?.descricao}',
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                          '${_.solicitacao.itensAsteca![index].quantidade}'),
                                    ),
                                    Expanded(
                                      child: Text(
                                          '${_.solicitacao.itensAsteca![index].pecaEstoque?.saldoDisponivel}'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  })
              : Container(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarWidget(),
      drawer: const Sidebar(),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Obx(
          () => !controller.carregandoSolicitacao.value
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCamposIniciais(),
                      _buildCamposNotaFiscalVenda(),
                      _buildPecaSeleionada(),
                      // _buildProduto(),
                      // _buildDefeitos(),
                      // _buildChecklist(),
                      // _buildCamposObservacoesAdicionais(),
                      // _buildImagens(),
                      // _buildCategoriaNumeroSerie(),
                      // _buildCategoriaCondicaProduto(),
                      // _buildCategoriaDefeito(),
                      // _buildVideos(controller.solicitacao.caminhoVideo),
                      // _buildDigitalizacoes(),
                      // _buildMotivoReprovacaoSolicitacaoOs(),
                      // _buildMotivoAprovacaoSolicitacaoOs(),
                      _buildBotoesPrincipais(context),
                    ],
                  ),
                )
              : Center(
                  child: const LoadingComponent(),
                ),
        ),
      ),
    );
  }
}
