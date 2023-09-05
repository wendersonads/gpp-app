import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/dashboard/controllers/dashboard_controller.dart';
import 'package:gpp/src/views/dashboard/views/dashboard_view.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:intl/intl.dart';

import '../../../../shared/components/TextComponent.dart';
import '../../../widgets/appbar_widget.dart';

class DashboardDesktop extends StatelessWidget {
  const DashboardDesktop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      body: WillPopScope(
        onWillPop: () async => false,
        child: Row(
          children: [
            Sidebar(),
            Expanded(
              child: Obx(
                () => !controller.carregando.value
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 32),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                    color: Colors.grey.shade200,
                                  )),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                      child: TextComponent(
                                        'Dashboard',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CardWidget(
                                    total: controller.dashboard.totalPedidoSaida.toString(),
                                    texto: 'Total de ordens de saida',
                                    color: Colors.purple,
                                    icon: Icon(Icons.assignment, color: Colors.white),
                                  ),
                                  CardWidget(
                                      total: controller.dashboard.totalPedidoEntrada.toString(),
                                      texto: 'Total de ordens de entrada',
                                      color: Colors.pink,
                                      icon: Icon(Icons.assignment, color: Colors.white)),
                                  CardWidget(
                                    total: controller.dashboard.totalAsteca.toString(),
                                    texto: 'Total de astecas',
                                    color: Colors.orange,
                                    icon: Icon(Icons.dashboard_rounded, color: Colors.white),
                                  )
                                ],
                              ),
                              controller.dashboard.astecas!.length != 0
                                  ? Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                                child: TextComponent(
                                                  'Últimas astecas',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              MouseRegion(
                                                onHover: (value) {
                                                  controller.onHoverAsteca(true);
                                                },
                                                onExit: (value) {
                                                  controller.onHoverAsteca(false);
                                                },
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed('/astecas');
                                                    },
                                                    child: Obx(
                                                      () => Container(
                                                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                                        child: TextComponent(
                                                          'Ver mais',
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14,
                                                          color: controller.onHoverAsteca.value
                                                              ? primaryColor
                                                              : Colors.grey.shade400,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                                color: Colors.grey.shade100,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextComponent(
                                                        'ID asteca',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: TextComponent(
                                                        'Nome do solicitante',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: TextComponent(
                                                        'Data de abertura',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: TextComponent(
                                                        'Pendência',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 320,
                                                child: Column(
                                                  children: controller.dashboard.astecas!.map((e) {
                                                    return Container(
                                                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              top: BorderSide(color: Colors.grey.shade100),
                                                              left: BorderSide(color: Colors.grey.shade100),
                                                              bottom: BorderSide(color: Colors.grey.shade100),
                                                              right: BorderSide(color: Colors.grey.shade100))),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SelectableText('${e.idAsteca}'),
                                                          ),
                                                          Expanded(
                                                            child: SelectableText(
                                                                '${e.documentoFiscal?.nome.toString().capitalize ?? ''}'),
                                                          ),
                                                          Expanded(
                                                            child: SelectableText(
                                                                '${DateFormat('dd/MM/yyyy').format(e.dataEmissao!)}'),
                                                          ),
                                                          Expanded(
                                                            child: Expanded(
                                                                child: e.astecaPendencias!.length != 0
                                                                    ? SelectableText(
                                                                        '${e.astecaPendencias?.last.astecaTipoPendencia?.idTipoPendencia ?? ''} - ${e.astecaPendencias?.last.astecaTipoPendencia?.descricao.toString().capitalize ?? ''}',
                                                                      )
                                                                    : SelectableText('Aguardando pendência')),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(),
                              controller.dashboard.pedidosEntrada!.length != 0
                                  ? Container(
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: 16),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                                  child: TextComponent(
                                                    'Últimas ordens de entrada',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                MouseRegion(
                                                  onHover: (value) {
                                                    controller.onHoverPedidosaida(true);
                                                  },
                                                  onExit: (value) {
                                                    controller.onHoverPedidosaida(false);
                                                  },
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        Get.toNamed('/ordens-entrada');
                                                      },
                                                      child: Obx(
                                                        () => Container(
                                                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                                          child: TextComponent(
                                                            'Ver mais',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: controller.onHoverPedidosaida.value
                                                                ? primaryColor
                                                                : Colors.grey.shade400,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                                  color: Colors.grey.shade100,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextComponent(
                                                          'ID',
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextComponent(
                                                          'Fornecedor',
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextComponent(
                                                          'Data de abertura',
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextComponent(
                                                          'CPF/CNPJ',
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextComponent(
                                                          'Valor total',
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Column(
                                                    children: controller.dashboard.pedidosEntrada!.map<Widget>((e) {
                                                      return Container(
                                                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                top: BorderSide(color: Colors.grey.shade100),
                                                                left: BorderSide(color: Colors.grey.shade100),
                                                                bottom: BorderSide(color: Colors.grey.shade100),
                                                                right: BorderSide(color: Colors.grey.shade100))),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: SelectableText('${e.idPedidoEntrada}'),
                                                            ),
                                                            Expanded(
                                                              child: SelectableText(
                                                                  '${e.asteca != null ? e.asteca!.compEstProd!.first.produto!.fornecedores!.first.cliente!.nome.toString().capitalize ?? '' : '-'}'),
                                                            ),
                                                            Expanded(
                                                              child: SelectableText(
                                                                  '${DateFormat('dd/MM/yyyy').format(e.dataEmissao!)}'),
                                                            ),
                                                            Expanded(
                                                              child: SelectableText(
                                                                  '${e.asteca != null ? controller.maskFormatter.cpfCnpjFormatter(value: e.asteca!.compEstProd!.first.produto!.fornecedores!.first.cliente!.cpfCnpj)!.getMaskedText() : '-'}'),
                                                            ),
                                                            Expanded(
                                                              child: SelectableText(
                                                                  '${controller.formatter.format(e.valorTotal ?? '-')}'),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ))
                                  : Container(),
                              controller.dashboard.pedidosSaida!.length != 0
                                  ? Container(
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: 16),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                                  child: TextComponent(
                                                    'Últimas ordens de saída',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                MouseRegion(
                                                  onHover: (value) {
                                                    controller.onHoverPedidoEntrada(true);
                                                  },
                                                  onExit: (value) {
                                                    controller.onHoverPedidoEntrada(false);
                                                  },
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        Get.toNamed('/ordens-saida');
                                                      },
                                                      child: Obx(
                                                        () => Container(
                                                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                                          child: TextComponent(
                                                            'Ver mais',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: controller.onHoverPedidoEntrada.value
                                                                ? primaryColor
                                                                : Colors.grey.shade400,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                                  color: Colors.grey.shade100,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextComponent(
                                                          'ID',
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextComponent(
                                                          'Nome',
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextComponent(
                                                          'Data de abertura',
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextComponent(
                                                          'CPF/CNPJ',
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextComponent(
                                                          'Valor total',
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: controller.dashboard.pedidosSaida!.map<Widget>((e) {
                                                    return Container(
                                                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              top: BorderSide(color: Colors.grey.shade100),
                                                              left: BorderSide(color: Colors.grey.shade100),
                                                              bottom: BorderSide(color: Colors.grey.shade100),
                                                              right: BorderSide(color: Colors.grey.shade100))),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SelectableText('${e.idPedidoSaida}'),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                SelectableText('${e.cliente?.nome.toString().capitalize ?? ''}'),
                                                          ),
                                                          Expanded(
                                                            child: SelectableText(
                                                                '${DateFormat('dd/MM/yyyy').format(e.dataEmissao!)}'),
                                                          ),
                                                          Expanded(
                                                            child: SelectableText(
                                                                '${controller.maskFormatter.cpfCnpjFormatter(value: e.cpfCnpj)!.getMaskedText()}'),
                                                          ),
                                                          Expanded(
                                                            child: SelectableText('${controller.formatter.format(e.valorTotal)}'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ))
                                  : Container(),
                              //Capacidade Estoque
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Capacidade Estoque',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          MouseRegion(
                                              child: GestureDetector(
                                            onTap: () {
                                              Get.toNamed('/capacidade-box');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                              child: TextComponent(
                                                'Ver mais',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: controller.onHoverAsteca.value ? primaryColor : Colors.grey.shade400,
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Container(
                                              height: 600,
                                              width: Get.width,
                                              child: Scrollbar(
                                                child: GridView.builder(
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: controller.capacidadeEstoqueModel.length,
                                                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 5,
                                                    childAspectRatio: 1,
                                                  ),
                                                  itemBuilder: (context, index) {
                                                    return Card(
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Box:',
                                                                  style: TextStyle(fontSize: 24),
                                                                ),
                                                                Text(
                                                                  controller.capacidadeEstoqueModel[index].idBox.toString(),
                                                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Volume Total: ',
                                                                  style: TextStyle(fontSize: 16),
                                                                ),
                                                                Text(
                                                                    controller.capacidadeEstoqueModel[index].volumeTotal
                                                                        .toString(),
                                                                    style: TextStyle(fontSize: 16))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('Volume Utilizado: ', style: TextStyle(fontSize: 16)),
                                                                Text(controller.capacidadeEstoqueModel[index].volumeUtilizado
                                                                    .toString())
                                                              ],
                                                            )
                                                          ],
                                                        ));
                                                  },
                                                ),
                                              )),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : LoadingComponent(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
