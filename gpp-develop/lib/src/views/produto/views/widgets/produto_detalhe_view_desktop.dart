import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/produto/controllers/produto_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:universal_html/html.dart' as html;
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class ProdutoDetalheViewDesktop extends StatelessWidget {
  final int id;
  const ProdutoDetalheViewDesktop({
    Key? key,
    required this.id,
  }) : super(key: key);

  /* final headerCsv =
        'Codigo;Volumes;Descricao;QTD;Comprimento;Altura;Largura;Cor'; */

  String generateCsv() {
    List<String> rowHeader = [
      "Codigo",
      "Volumes",
      "Descricao",
      "QTD",
      "Comprimento",
      "Altura",
      "Largura",
      "Cor"
    ];
    List<List<dynamic>> rows = [];

    rows.add(rowHeader);

    String csv = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    return html.Url.createObjectUrlFromBlob(blob);
  }

  comoPreencher() {
    Get.dialog(AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: Container(
            width: Get.width * 0.4,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      color: primaryColor,
                      height: 200,
                      child: Row(
                        children: [
                          Flexible(
                            child: TextComponent(
                              'Passo a passo de como importar peças em massa',
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: TextComponent(
                                      '1. Baixe o modelo no botão “Download Template”',
                                      color: Colors.grey.shade700,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: TextComponent(
                                      '2. Preencha os campos com o código de fabricação, volumes, descrição, quantidade por produto, comprimento, altura, largura e cor',
                                      color: Colors.grey.shade700,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: TextComponent(
                                      '3. Envie a planilha preenchida em formato csv, clicando em “Importar peças”',
                                      color: Colors.grey.shade700,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                          child: Row(
                            children: [
                              TextComponent(
                                'Importante',
                                color: Colors.grey.shade700,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  TextComponent(
                                    '1. Preencha apenas um código de fábricação por linha',
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  TextComponent(
                                    '2. Não insira espaços em nenhum campo',
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  TextComponent(
                                    '3. Não deixe campos obrigatórios em branco',
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: TextComponent(
                                      '4. O tempo para cadastrar o estoque varia de acordo com o quantidade de peças que serão importadas',
                                      color: Colors.grey.shade700,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonComponent(
                                color: vermelhoColor,
                                colorHover: vermelhoColorHover,
                                onPressed: () {
                                  Get.back();
                                },
                                text: 'Fechar')
                          ]),
                    )
                  ],
                ),
              ),
            ))));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProdutoDetalheController>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: NavbarWidget(),
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Container(
              height: context.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              TitleComponent('Produto'),
                            ],
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      controller.etapa(1);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: controller.etapa == 1
                                                        ? secundaryColor
                                                        : Colors.grey.shade200,
                                                    width: controller.etapa == 1
                                                        ? 4
                                                        : 1))),
                                        child: TextComponent(
                                            'Informações do produto')),
                                  ),
                                ),
                                Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      controller.etapa(2);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: controller.etapa == 2
                                                      ? secundaryColor
                                                      : Colors.grey.shade200,
                                                  width: controller.etapa == 2
                                                      ? 4
                                                      : 1)),
                                        ),
                                        child: TextComponent('Peças')),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Obx((() => controller.etapa.value == 1
                              ? Container(
                                  child: Obx(() => !controller.carregando.value
                                      ? Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InputComponent(
                                                    enable: false,
                                                    label: 'ID Produto',
                                                    initialValue: controller
                                                        .produto.idProduto
                                                        .toString(),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: InputComponent(
                                                    enable: false,
                                                    label: 'Descrição',
                                                    initialValue: controller
                                                        .produto.resumida
                                                        .toString()
                                                        .capitalize,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: InputComponent(
                                                    enable: false,
                                                    label: 'Fornecedor',
                                                    initialValue: controller
                                                        .produto
                                                        .fornecedores!
                                                        .first
                                                        .cliente!
                                                        .nome
                                                        .toString()
                                                        .capitalize,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : LoadingComponent()),
                                )
                              : Container()))
                        ],
                      ),
                    ),
                    Obx(() => controller.etapa.value == 2
                        ? Container(
                            height: context.height * 0.6,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: InputComponent(
                                                controller:
                                                    controller.pesquisar,
                                                hintText: 'Buscar',
                                                onFieldSubmitted: (value) {
                                                  controller.pesquisar?.text =
                                                      value;
                                                  controller
                                                      .buscarProdutoPecas();
                                                },
                                              )),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              ButtonComponent(
                                                onPressed: () {
                                                  Get.toNamed(
                                                      '/pecas-cadastrar/' +
                                                          controller
                                                              .produto.idProduto
                                                              .toString());
                                                },
                                                text: 'Adicionar',
                                                icon: Icon(
                                                    Icons.upload_file_rounded,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              ButtonComponent(
                                                onPressed: () => controller
                                                    .importarPecas(id),
                                                text: 'Importar peças',
                                                icon: Icon(
                                                    Icons.upload_file_rounded,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              ButtonComponent(
                                                onPressed: () async {
                                                  controller
                                                      .downloadTemplate(id);
                                                },
                                                text: 'Download template',
                                                icon: Icon(
                                                    Icons.file_download_rounded,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              ButtonComponent(
                                                onPressed: () =>
                                                    comoPreencher(),
                                                text: 'Como preencher',
                                                icon: Icon(
                                                    Icons.info_outline_rounded,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 16),
                                          color: Colors.grey.shade200,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 12),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextComponent(
                                                  'ID Peça',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextComponent(
                                                  'Descrição',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextComponent(
                                                  'Quantidade de peças por produto',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextComponent(
                                                  'Código de fabrica',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextComponent(
                                                  'Medida',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextComponent(
                                                  'Ações',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            child: Obx(() => !controller
                                                    .carregandoProdutoPecas
                                                    .value
                                                ? ListView.builder(
                                                    itemCount: controller
                                                        .produtoPecas.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 12,
                                                                horizontal: 12),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                top: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade100),
                                                                left: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade100),
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade100),
                                                                right: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade100))),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  SelectableText(
                                                                controller
                                                                    .produtoPecas[
                                                                        index]
                                                                    .peca!
                                                                    .id_peca
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SelectableText(controller
                                                                      .produtoPecas[
                                                                          index]
                                                                      .peca!
                                                                      .descricao
                                                                      .toString()
                                                                      .capitalize ??
                                                                  ''),
                                                            ),
                                                            Expanded(
                                                              child: SelectableText(
                                                                  '${controller.produtoPecas[index].quantidadePorProduto ?? ''}'),
                                                            ),
                                                            Expanded(
                                                              child: SelectableText(controller
                                                                      .produtoPecas[
                                                                          index]
                                                                      .peca!
                                                                      .codigo_fabrica ??
                                                                  ''),
                                                            ),
                                                            Expanded(
                                                              child: SelectableText(
                                                                  '${controller.produtoPecas[index].peca?.altura ?? 0}x${controller.produtoPecas[index].peca?.largura ?? 0}x${controller.produtoPecas[index].peca?.profundidade ?? 0}'),
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    ButtonAcaoWidget(
                                                              deletar: () => controller
                                                                  .deletarProdutoPeca(
                                                                      id,
                                                                      controller
                                                                          .produtoPecas[
                                                                              index]
                                                                          .peca!
                                                                          .id_peca),
                                                            ))
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : LoadingComponent())),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            child: Obx(
                                              () => !controller
                                                      .carregandoProdutoPecas
                                                      .value
                                                  ? Row(
                                                      children: [
                                                        TextComponent(
                                                          'Total de peças vinculadas ${controller.produtoPecas.length}',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )
                                                      ],
                                                    )
                                                  : Container(),
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container()),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: Row(
                        children: [
                          ButtonComponent(
                              color: primaryColor,
                              colorHover: primaryColorHover,
                              onPressed: () {
                                Get.offAllNamed(Get.previousRoute);
                              },
                              text: 'Voltar'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
