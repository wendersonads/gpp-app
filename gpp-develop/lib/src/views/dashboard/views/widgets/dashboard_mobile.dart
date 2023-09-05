import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/dashboard/controllers/dashboard_controller.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../shared/components/TextComponent.dart';
import '../../../widgets/appbar_widget.dart';

class DashboardMobile extends StatelessWidget {
  const DashboardMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: NavbarWidget(),
        drawer: Sidebar(),
        body: Container(
          child: Obx(
            () => !controller.carregando.value
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: SingleChildScrollView(
                      controller: ScrollController(),
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
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 150,
                              aspectRatio: 20 / 9,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration: Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: [2, 1, 3].map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return i == 1
                                      ? Card(
                                          child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.2),
                                                spreadRadius: 0,
                                                blurRadius: 2,
                                                offset: Offset(0, 2), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      child: Row(
                                                        children: [
                                                          TextComponent(
                                                            "Total de Ordens de Entrada ",
                                                            color: Colors.grey.shade400,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      // width: 30,
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        TextComponent(
                                                          controller.dashboard.totalPedidoEntrada.toString(),
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 35,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(30),
                                                      color: Colors.pink,
                                                    ),
                                                    child: Center(
                                                      child: Icon(Icons.assignment, color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ))
                                      : i == 2
                                          ? Card(
                                              child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    spreadRadius: 0,
                                                    blurRadius: 2,
                                                    offset: Offset(0, 2), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          child: Row(
                                                            children: [
                                                              TextComponent(
                                                                "Total de Ordens de Saida",
                                                                color: Colors.grey.shade400,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          // width: 30,
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            TextComponent(
                                                              controller.dashboard.totalPedidoSaida.toString(),
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(30),
                                                          color: Colors.purple,
                                                        ),
                                                        child: Center(
                                                          child: Icon(Icons.assignment, color: Colors.white),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ))
                                          : Card(
                                              child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    spreadRadius: 0,
                                                    blurRadius: 2,
                                                    offset: Offset(0, 2), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          child: Row(
                                                            children: [
                                                              TextComponent(
                                                                "Total Astecas",
                                                                color: Colors.grey.shade400,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          // width: 30,
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            TextComponent(
                                                              controller.dashboard.totalAsteca.toString(),
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(30),
                                                          color: Colors.orange,
                                                        ),
                                                        child: Center(
                                                          child: Icon(Icons.assignment, color: Colors.white),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ));
                                },
                              );
                            }).toList(),
                          ),
                          controller.dashboard.astecas!.length != 0
                              ? Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 50),
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
                                                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 27),
                                                    child: TextComponent(
                                                      'Ver mais',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      color: controller.onHoverAsteca.value ? primaryColor : Colors.grey.shade400,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        child: ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: 4,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                child: Padding(
                                                    padding: const EdgeInsets.all(12.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const TextComponent(
                                                              'ID asteca:',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            TextComponent(
                                                              controller.dashboard.astecas?[index].idAsteca.toString() ?? '',
                                                              textAlign: TextAlign.end,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const TextComponent(
                                                              'Nome do Solicitante: ',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                controller.dashboard.astecas?[index].documentoFiscal?.nome
                                                                        .toString()
                                                                        .capitalize ??
                                                                    '',
                                                                style: TextStyle(fontSize: 13),
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
                                                            const TextComponent(
                                                              'Data de Abertura:',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            TextComponent(
                                                              DateFormat('dd/MM/yyyy')
                                                                  .format(controller.dashboard.astecas![index].dataEmissao!),
                                                              textAlign: TextAlign.end,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const TextComponent(
                                                              'Pendência:',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            TextComponent(
                                                              '${controller.dashboard.astecas?[index].astecaPendencias?.last.astecaTipoPendencia?.idTipoPendencia.toString() ?? ''} - ${controller.dashboard.astecas?[index].astecaPendencias?.last.astecaTipoPendencia?.descricao.toString().capitalize ?? ''}',
                                                              textAlign: TextAlign.end,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                              );
                                            }))
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
                                                'Ordens de Entrada',
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
                                                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 27),
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
                                          child: ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: 4,
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(12.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const TextComponent(
                                                                'ID asteca:',
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              TextComponent(
                                                                controller.dashboard.pedidosEntrada?[index].idPedidoEntrada
                                                                        .toString() ??
                                                                    '',
                                                                textAlign: TextAlign.end,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const TextComponent(
                                                                'Fornecedor: ',
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  '${controller.dashboard.pedidosEntrada![index].asteca != null ? controller.dashboard.pedidosEntrada![index].asteca!.compEstProd!.first.produto!.fornecedores!.first.cliente!.nome.toString().capitalize ?? '' : '-'}',
                                                                  style: TextStyle(
                                                                    fontSize: 13,
                                                                  ),
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
                                                              const TextComponent(
                                                                'Data de Abertura:',
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              TextComponent(
                                                                DateFormat('dd/MM/yyyy').format(
                                                                    controller.dashboard.pedidosEntrada!.last.dataEmissao!),
                                                                textAlign: TextAlign.end,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const TextComponent(
                                                                'CPF/CNPJ:',
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              TextComponent(
                                                                controller.dashboard.pedidosEntrada?[index].asteca != null
                                                                    ? controller.maskFormatter
                                                                        .cpfCnpjFormatter(
                                                                            value: controller
                                                                                .dashboard
                                                                                .pedidosEntrada?[index]
                                                                                .asteca!
                                                                                .compEstProd!
                                                                                .first
                                                                                .produto!
                                                                                .fornecedores!
                                                                                .first
                                                                                .cliente!
                                                                                .cpfCnpj)!
                                                                        .getMaskedText()
                                                                    : '-',
                                                                textAlign: TextAlign.end,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const TextComponent(
                                                                'Valor Total:',
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              TextComponent(
                                                                '${controller.formatter.format(controller.dashboard.pedidosEntrada?.last.valorTotal ?? '-')}',
                                                                textAlign: TextAlign.end,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      )),
                                                );
                                              }))
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
                                                'Ordens de Saída',
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
                                        child: ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: 4,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                child: Padding(
                                                    padding: const EdgeInsets.all(12.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const TextComponent(
                                                              'ID:',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            TextComponent(
                                                              controller.dashboard.pedidosSaida?[index].idPedidoSaida
                                                                      .toString() ??
                                                                  '',
                                                              textAlign: TextAlign.end,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const TextComponent(
                                                              'Nome:',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            TextComponent(
                                                              controller.dashboard.pedidosSaida?[index].cliente?.nome
                                                                      .toString() ??
                                                                  '',
                                                              textAlign: TextAlign.end,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const TextComponent(
                                                              'Data de Abertura:',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            TextComponent(
                                                              DateFormat('dd/MM/yyyy')
                                                                  .format(controller.dashboard.pedidosSaida!.last.dataEmissao!),
                                                              textAlign: TextAlign.end,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const TextComponent(
                                                              'CPF/CNPJ:',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            TextComponent(
                                                              controller.maskFormatter
                                                                  .cpfCnpjFormatter(
                                                                      value: controller.dashboard.pedidosSaida?[index].cpfCnpj)!
                                                                  .getMaskedText(),
                                                              textAlign: TextAlign.end,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const TextComponent(
                                                              'Valor Total:',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            TextComponent(
                                                              controller.formatter
                                                                  .format(controller.dashboard.pedidosSaida?[index].valorTotal),
                                                              textAlign: TextAlign.end,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                              );
                                            }),
                                      )
                                    ],
                                  ))
                              : Container(),
                        ],
                      ),
                    ),
                  )
                : Container(child: Center(child: LoadingComponent())),
          ),
        ),
      ),
    );
  }
}
