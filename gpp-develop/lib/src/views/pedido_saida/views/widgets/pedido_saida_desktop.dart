// ignore_for_file: unused_field, unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/evento_status_model.dart';
import 'package:gpp/src/shared/components/DropdownButtonFormFieldComponent.dart';

import 'package:gpp/src/views/pedido_saida/controllers/pedido_saida_controller.dart';
import 'package:gpp/src/views/pedido_saida/controllers/pedido_saida_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:gpp/src/controllers/responsive_controller.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';

import '../../../../shared/components/PaginacaoComponent.dart';

class PedidoSaidaDesktop extends StatefulWidget {
  const PedidoSaidaDesktop({Key? key}) : super(key: key);

  @override
  _PedidoSaidaDesktopState createState() => _PedidoSaidaDesktopState();
}

class _PedidoSaidaDesktopState extends State<PedidoSaidaDesktop> {
  final ResponsiveController _responsive = ResponsiveController();
  late MaskFormatter maskFormatter;

  final controller = Get.put(PedidoSaidaController());

  _buildSituacaoPedido(value) {
    if (value == 1) {
      return TextComponent(
        'Em aberto',
        color: Colors.blue,
      );
    } else if (value == 2) {
      return TextComponent(
        'Pendente',
        color: Colors.orange,
      );
    } else if (value == 3) {
      return TextComponent(
        'Concluído',
        color: secundaryColor,
      );
    } else if (value == 4) {
      return TextComponent(
        'Cancelado',
        color: Colors.red,
      );
    }
  }

  @override
  initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    //Inicializa mask formatter
    maskFormatter = MaskFormatter();
  }

  situacao(DateTime data) {
    int diasEmAtraso = DateTime.now().difference(data).inDays;
    //Se os dias em atraso for menor que 15 dias, situação = verde
    if (diasEmAtraso < 15) {
      return secundaryColor;
    }
    //Se os dias em atraso for maior que 15 e menor que 30, situação = amarela
    if (diasEmAtraso > 15 && diasEmAtraso < 30) {
      return Colors.yellow;
    }
    //Se os dias em atraso for maior que 30, situação = vermelha

    return Colors.red;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Drawer(),
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Expanded(child: TitleComponent('Ordens de Saída')),
                          Expanded(
                            child: Form(
                              key: controller.filtroFormKey,
                              child: InputComponent(
                                maxLines: 1,
                                onFieldSubmitted: (value) async {
                                  controller.pesquisar = value;
                                  controller.buscarPedidosSaidaMenu();
                                },
                                prefixIcon: Icon(
                                  Icons.search,
                                ),
                                hintText: 'Buscar',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          ButtonComponent(
                              icon: Icon(Icons.tune_rounded, color: Colors.white),
                              color: secundaryColor,
                              onPressed: () {
                                setState(() {
                                  controller.abrirFiltro(!controller.abrirFiltro.value);
                                });
                              },
                              text: 'Adicionar filtro')
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: controller.abrirFiltro.value ? null : 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Form(
                              key: controller.filtroExpandidoFormKey,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextComponent('Status'),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Obx(() => !controller.carregandoEventosPedidoSaida.value
                                          ? Container(
                                              width: 260,
                                              child: DropdownButtonFormFieldComponent(
                                                  hint: TextComponent(
                                                      controller.eventoSelecionado?.descricao ?? 'Selecione o status'),
                                                  items: controller.eventosPedidoSaida
                                                      .map<DropdownMenuItem<EventoStatusModel>>((EventoStatusModel value) {
                                                    return DropdownMenuItem<EventoStatusModel>(
                                                      value: value,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 10,
                                                            width: 10,
                                                            decoration: BoxDecoration(
                                                              color: HexColor(value.statusCor ?? '#040491'),
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(2),
                                                                  topRight: Radius.circular(2),
                                                                  bottomLeft: Radius.circular(2),
                                                                  bottomRight: Radius.circular(2)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          TextComponent(value.descricao!),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    controller.eventoSelecionado = value;
                                                  }),
                                            )
                                          : DropdownButtonFormFieldComponent(
                                              hint:
                                                  TextComponent(controller.eventoSelecionado?.descricao ?? 'Selecione o status'),
                                              items: controller.eventosPedidoSaida
                                                  .map<DropdownMenuItem<EventoStatusModel>>((EventoStatusModel value) {
                                                return DropdownMenuItem<EventoStatusModel>(
                                                  value: value,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 10,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                          color: HexColor(value.statusCor ?? '#040491'),
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(2),
                                                              topRight: Radius.circular(2),
                                                              bottomLeft: Radius.circular(2),
                                                              bottomRight: Radius.circular(2)),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      TextComponent(value.descricao!),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                // controller.pedidoController
                                                //     .selecionado = value;
                                              }))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: InputComponent(
                                      inputFormatter: [maskFormatter.dataFormatter()],
                                      label: 'Período:',
                                      maxLines: 1,
                                      onSaved: (value) {
                                        if (value.length == 10) {
                                          controller.dataInicio = DateFormat("dd/MM/yyyy").parse(value);
                                        }
                                      },
                                      hintText: 'DD/MM/AAAA',
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: InputComponent(
                                      inputFormatter: [maskFormatter.dataFormatter()],
                                      label: '',
                                      maxLines: 1,
                                      onSaved: (value) {
                                        if (value.length == 10) {
                                          controller.dataFim = DateFormat("dd/MM/yyyy").parse(value);
                                        }
                                      },
                                      hintText: 'DD/MM/AAAA',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ButtonComponent(
                                      onPressed: () {
                                        controller.limparFiltro();
                                      },
                                      text: 'Limpar'),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  ButtonComponent(
                                      onPressed: () {
                                        controller.buscarPedidosSaidaMenu();
                                      },
                                      text: 'Pesquisar')
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      (() => Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Row(children: [
                              GestureDetector(
                                onTap: () async {
                                  controller.selected(1);
                                  controller.buscarPedidosSaidaMenu();
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: controller.selected.value == 1 ? secundaryColor : Colors.grey.shade200,
                                                width: controller.selected.value == 1 ? 4 : 1))),
                                    child: TextComponent('Todas')),
                              ),
                              // GestureDetector(
                              //   onTap: () async {
                              //     controller.selected(2);
                              //     controller.buscarPedidosSaidaMenu();
                              //   },
                              //   child: Container(
                              //       padding: EdgeInsets.symmetric(
                              //           vertical: 8, horizontal: 16),
                              //       decoration: BoxDecoration(
                              //           border: Border(
                              //               bottom: BorderSide(
                              //                   color:
                              //                       controller.selected.value ==
                              //                               2
                              //                           ? secundaryColor
                              //                           : Colors.grey.shade200,
                              //                   width:
                              //                       controller.selected.value ==
                              //                               2
                              //                           ? 4
                              //                           : 1))),
                              //       child: TextComponent('Em aberto')),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  controller.selected(3);
                                  controller.buscarPedidosSaidaMenu();
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: controller.selected.value == 3 ? secundaryColor : Colors.grey.shade200,
                                                width: controller.selected.value == 3 ? 4 : 1))),
                                    child: TextComponent('Em atendimento')),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.selected(4);
                                  controller.buscarPedidosSaidaMenu();
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: controller.selected.value == 4 ? secundaryColor : Colors.grey.shade200,
                                                width: controller.selected.value == 4 ? 4 : 1))),
                                    child: TextComponent('Criado por mim')),
                              ),
                            ]),
                          )),
                    ),
                    ListarPedidosSaida()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListarPedidosSaida() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
                child: Obx(() => !controller.carregando.value
                    ? ListView.builder(
                        itemCount: controller.pedidos.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: CardWidget(
                              color: controller.pedidos[index].pedidoSaidaEvento?.length != 0
                                  ? HexColor(
                                      controller.pedidos[index].pedidoSaidaEvento?.last.eventoStatus?.statusCor ?? '#040491')
                                  : primaryColor,
                              widget: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              TextComponent(
                                                'ID',
                                                fontWeight: FontWeight.bold,
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: TextComponent(
                                              'Nome',
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: TextComponent(
                                              'Data de abertura',
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: TextComponent(
                                              'CPF/CNPJ',
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Expanded(
                                            child: TextComponent(
                                          'Valor total',
                                          fontWeight: FontWeight.bold,
                                        )),
                                        Expanded(
                                            flex: 2,
                                            child: TextComponent(
                                              'Status',
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [SelectableText('#' + controller.pedidos[index].idPedidoSaida.toString())],
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: SelectableText(
                                                controller.pedidos[index].cliente?.nome?.toString().capitalize ?? '')),
                                        Expanded(
                                            flex: 2,
                                            child: SelectableText(
                                                DateFormat('dd/MM/yyyy').format(controller.pedidos[index].dataEmissao!))),
                                        Expanded(
                                            flex: 2,
                                            child: SelectableText(maskFormatter
                                                .cpfCnpjFormatter(value: controller.pedidos[index].cpfCnpj.toString())!
                                                .getMaskedText())),
                                        Expanded(
                                            child: SelectableText(
                                                controller.formatter.format(controller.pedidos[index].valorTotal)
                                                // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                                )),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              EventoStatusWidget(
                                                color: controller.pedidos[index].pedidoSaidaEvento?.length != 0
                                                    ? HexColor(controller
                                                            .pedidos[index].pedidoSaidaEvento?.last.eventoStatus?.statusCor ??
                                                        '#040491')
                                                    : null,
                                                texto: controller.pedidos[index].pedidoSaidaEvento?.length != 0
                                                    ? controller.pedidos[index].pedidoSaidaEvento?.last.eventoStatus?.descricao ??
                                                        ''
                                                    : 'Aguardando status',
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: ButtonAcaoWidget(
                                          detalhe: () {
                                            Get.delete<PedidoSaidaDetalheController>();
                                            Get.toNamed('/ordens-saida/${controller.pedidos[index].idPedidoSaida}');
                                          },
                                        )
                                            // maskFormatter.realInputFormmater(pedido[index].valorTotal.toString()).getMaskedText(),
                                            )
                                      ],
                                    ),
                                  ],
                                ),
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
            child: GetBuilder<PedidoSaidaController>(
                builder: (_) => PaginacaoComponent(
                      total: controller.pagina.getTotal(),
                      atual: controller.pagina.getAtual(),
                      primeiraPagina: () async {
                        controller.pagina.primeira();
                        await controller.buscarPedidosSaidaMenu();
                      },
                      anteriorPagina: () async {
                        controller.pagina.anterior();
                        await controller.buscarPedidosSaidaMenu();
                      },
                      proximaPagina: () async {
                        controller.pagina.proxima();
                        await controller.buscarPedidosSaidaMenu();
                      },
                      ultimaPagina: () async {
                        controller.pagina.ultima();
                        await controller.buscarPedidosSaidaMenu();
                      },
                    )),
          ),
        ],
      ),
    );
  }
}
