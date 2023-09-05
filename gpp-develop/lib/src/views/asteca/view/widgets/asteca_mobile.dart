import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/asteca/controller/asteca_controller.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/views/peca/controller/peca_detalhe_controller.dart';

import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:intl/intl.dart';

class AstecaMobile extends StatelessWidget {
  AstecaMobile({Key? key}) : super(key: key);

  final controller = Get.find<AstecaController>();

  String tipoAsteca(int? tipoAsteca) {
    switch (tipoAsteca) {
      case 1:
        return 'Cliente';
      case 2:
        return 'Estoque';
      default:
        return 'Aguardando tipo de asteca';
    }
  }

  Widget menuExibido({int? exibido}) {
    switch (controller.selected.value) {
      case 1:
        return astecasEmAberto();
      case 2:
        return astecasEmAtendimento();
      default:
        return Container();
    }
  }

  MaterialColor situacao(DateTime data) {
    int diasEmAtraso = DateTime.now().difference(data).inDays;

    // Se os dias em atraso for menor que 15 dias, situação = verde
    if (diasEmAtraso < 15) {
      return Colors.green;
    }

    // Se os dias em atraso for maior que 15 e menor que 30, situação = amarela
    if (diasEmAtraso > 15 && diasEmAtraso < 30) {
      return Colors.yellow;
    }

    // Se os dias em atraso for maior que 30, situação = vermelha
    return Colors.red;
  }

  Widget astecasEmAberto() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: Obx(
                () => controller.carregando.value
                    ? LoadingComponent()
                    : ListView.builder(
                        itemCount: controller.astecas.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: CardWidget(
                              color: situacao(
                                  controller.astecas[index].dataEmissao!),
                              widget: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            TextComponent(
                                              'ID',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            SelectableText(
                                              '# ${controller.astecas[index].idAsteca}',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            TextComponent(
                                              'Data de abertura',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            SelectableText(
                                              '${DateFormat('dd/MM/yyyy').format(controller.astecas[index].dataEmissao!)}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextComponent(
                                          'Nome',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${controller.astecas[index].documentoFiscal?.nome.toString().capitalize ?? ''}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextComponent(
                                          'Tipo asteca',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          tipoAsteca(controller
                                              .astecas[index].tipoAsteca),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: EventoStatusWidget(
                                          texto: controller
                                                      .astecas[index]
                                                      .astecaPendencias
                                                      ?.length !=
                                                  0
                                              ? '${controller.astecas[index].astecaPendencias?.last.astecaTipoPendencia?.idTipoPendencia ?? ''} - ${controller.astecas[index].astecaPendencias?.last.astecaTipoPendencia?.descricao.toString().capitalize ?? ''}'
                                              : 'Aguardando status',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.delete<PecaDetalheController>();

                                            Get.toNamed('/astecas/' +
                                                controller
                                                    .astecas[index].idAsteca
                                                    .toString());
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.visibility_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: GetBuilder<AstecaController>(
              builder: (_) => PaginacaoComponent(
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
                total: controller.pagina.getTotal(),
                atual: controller.pagina.getAtual(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget astecasEmAtendimento() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: Obx(
                () => controller.carregando.value
                    ? LoadingComponent()
                    : ListView.builder(
                        itemCount: controller.astecas.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: CardWidget(
                              color: situacao(
                                  controller.astecas[index].dataEmissao!),
                              widget: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            TextComponent(
                                              'ID',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            SelectableText(
                                              '# ${controller.astecas[index].idAsteca}',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            TextComponent(
                                              'Data de abertura',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            SelectableText(
                                              '${DateFormat('dd/MM/yyyy').format(controller.astecas[index].dataEmissao!)}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextComponent(
                                          'Nome',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${controller.astecas[index].documentoFiscal?.nome.toString().capitalize ?? ''}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextComponent(
                                          'Tipo asteca',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          tipoAsteca(controller
                                              .astecas[index].tipoAsteca),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: EventoStatusWidget(
                                          texto: controller
                                                      .astecas[index]
                                                      .astecaPendencias
                                                      ?.length !=
                                                  0
                                              ? '${controller.astecas[index].astecaPendencias?.last.astecaTipoPendencia?.idTipoPendencia ?? ''} - ${controller.astecas[index].astecaPendencias?.last.astecaTipoPendencia?.descricao.toString().capitalize ?? ''}'
                                              : 'Aguardando status',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.delete<PecaDetalheController>();

                                            Get.toNamed('/astecas/' +
                                                controller
                                                    .astecas[index].idAsteca
                                                    .toString());
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.visibility_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: GetBuilder<AstecaController>(
              builder: (_) => PaginacaoComponent(
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
                total: controller.paginaAtendimento.getTotal(),
                atual: controller.paginaAtendimento.getAtual(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      TextComponent(
                        'Astecas',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      Obx(
                        () => Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  controller.selected(1);
                                  controller.menu();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: controller.selected.value == 1
                                            ? 4
                                            : 1,
                                        color: controller.selected.value == 1
                                            ? secundaryColor
                                            : Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: TextComponent('Em aberto'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  controller.selected(2);
                                  controller.menu();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: controller.selected.value == 2
                                            ? 4
                                            : 1,
                                        color: controller.selected.value == 2
                                            ? secundaryColor
                                            : Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: TextComponent('Em atendimento'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: InputComponent(
                              prefixIcon: Icon(
                                Icons.search,
                              ),
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
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: ButtonComponent(
                              icon: Icon(
                                Icons.tune_rounded,
                                color: Colors.white,
                              ),
                              color: secundaryColor,
                              colorHover: secundaryColorHover,
                              onPressed: () async {
                                controller.filtro(!controller.filtro.value);
                              },
                              text: 'Filtrar',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Obx(() => menuExibido())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
