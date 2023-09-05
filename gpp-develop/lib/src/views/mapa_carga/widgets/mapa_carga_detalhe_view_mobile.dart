import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/enums/mapa_carga_evento_status_enum.dart';
import 'package:gpp/src/models/motivo_cancelamento_carga_model.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/utils/GerarMapaCargaPDF.dart';
import 'package:gpp/src/shared/utils/GerarRomaneioPDF.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/mapa_carga/controller/mapa_carga_consulta_controller.dart';
import 'package:gpp/src/views/mapa_carga/controller/mapa_carga_controller.dart';
import 'package:gpp/src/views/mapa_carga/controller/mapa_carga_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:gpp/src/views/mapa_carga/controller/menu_mapa_carga_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

import '../../../shared/components/TextComponent.dart';

class MapaCargaDetalheViewMobile extends StatelessWidget {
  final int id;
  MapaCargaDetalheViewMobile({
    Key? key,
    required this.id,
  }) : super(key: key);

  final controller = Get.find<MapaCargaDetalheController>();
  final controllerMenu = Get.put(MenuMapaCargaController());

  void exibirModalAvisoFinalizacao(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Finalizar Mapa Carga'),
              CloseButton(
                onPressed: () {
                  controller.stepAtivo.value = 0;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          content: Container(
            width: 400,
            height: 280,
            child: Obx(
              () => Stepper(
                elevation: 0,
                type: StepperType.vertical,
                currentStep: controller.stepAtivo.value,
                controlsBuilder: (context, details) {
                  return Obx(() => !controller.carregandoFinalizar.value
                      ? Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ButtonComponent(
                                color: primaryColor,
                                onPressed: () {
                                  if (controller.stepAtivo.value == 0) {
                                    controller.mapaCompletamenteEntregue.value = false;
                                    controller.stepAtivo.value++;
                                  } else {
                                    controller.stepAtivo.value--;
                                  }
                                },
                                text: controller.stepAtivo.value == 0 ? 'Não' : 'Voltar',
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: ButtonComponent(
                                onPressed: () async {
                                  if (controller.stepAtivo.value == 0) {
                                    controller.mapaCompletamenteEntregue.value = true;
                                    controller.stepAtivo.value++;
                                  } else {
                                    if (await controller.finalizarMapaCarga(
                                        controller.mapaCarga.idMapaCarga!, controller.mapaCompletamenteEntregue.value)) {
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                text: controller.stepAtivo.value == 0 ? 'Sim' : 'Confirmar',
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingComponent(),
                          ],
                        ));
                },
                steps: [
                  Step(
                    title: Text('Confirmação da entrega'),
                    content: Container(
                      margin: EdgeInsets.only(
                        bottom: 24,
                      ),
                      child: Text('Todos os itens do mapa de carga ${controller.mapaCarga.idMapaCarga} foram entregues?'),
                    ),
                    isActive: controller.stepAtivo.value >= 0,
                  ),
                  Step(
                    title: Text('Aviso final'),
                    content: Container(
                      margin: EdgeInsets.only(
                        bottom: 24,
                      ),
                      child: controller.mapaCompletamenteEntregue.value
                          ? Text(
                              'Todos os itens do mapa carga foram entregues. Logo, o estoque sofrerá a baixa das peças e esse mapa será finalizado com sucesso.')
                          : Text(
                              'Os itens do mapa carga não foram entregues. Logo, o estoque não sofrerá a baixa das peças e você poderá criar novos mapas de carga para as ordem de saída envolvidas.'),
                    ),
                    isActive: controller.stepAtivo.value >= 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void exibirModalCancelamento(BuildContext context) async {
    controller.buscarMotivosCancelamentoCarga();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Cancelar Mapa Carga'),
            insetPadding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text('Antes de cancelar o mapa carga, é necessário informar o motivo.'),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 24,
                  ),
                  child: Obx(() => !controller.carregandoMotivosCancelamento.value
                      ? DropdownSearch<MotivoCancelamentoCargaModel>(
                          mode: Mode.MENU,
                          items: controller.motivosCancelamento,
                          isFilteredOnline: false,
                          showSearchBox: true,
                          itemAsString: (MotivoCancelamentoCargaModel? motivo) => motivo!.descricao.toString(),
                          onChanged: (MotivoCancelamentoCargaModel? motivo) {
                            if (motivo != null) {
                              controller.mapaCarga.idMotivoCancelamento = motivo.idMotivoCancelamentoCarga;
                            }
                          },
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                              border: InputBorder.none,
                              labelText: 'Pesquisar por motivo',
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                          dropdownSearchDecoration: InputDecoration(
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelText: 'Motivo do cancelamento',
                          ),
                          emptyBuilder: (context, value) {
                            return Center(
                              child: TextComponent(
                                'Nenhum motivo encontrado',
                                textAlign: TextAlign.center,
                                color: Colors.grey.shade400,
                              ),
                            );
                          },
                          dropDownButton: const Icon(
                            Icons.expand_more_rounded,
                            color: Colors.grey,
                          ),
                          popupBackgroundColor: Colors.white,
                          showAsSuffixIcons: true,
                        )
                      : LoadingComponent()),
                ),
                Obx(
                  () => !controller.carregandoCancelar.value
                      ? Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ButtonComponent(
                                  color: vermelhoColor,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  text: 'Fechar'),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: ButtonComponent(
                                  color: primaryColor,
                                  onPressed: () async {
                                    if (controller.mapaCarga.idMotivoCancelamento == null) {
                                      Notificacao.snackBar('Informe o motivo do cancelamento!',
                                          tipoNotificacao: TipoNotificacaoEnum.error);

                                      return;
                                    }

                                    if (await controller.cancelarMapaCarga(controller.mapaCarga)) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  text: 'Confirmar'),
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingComponent(),
                          ],
                        ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final double FONTEBASE = 16;

    return Scaffold(
        appBar: NavbarWidget(),
        drawer: Sidebar(),
        backgroundColor: Colors.white,
        body: Row(
          children: [
            Expanded(
                child: Obx(() => !controller.carregando.value
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 16),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                    color: Colors.grey.shade200,
                                  )),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      child: TextComponent(
                                        'Mapa de carga',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: EventoStatusWidget(
                                            color: primaryColor,
                                            texto: "Tipo Mapa - ${controller.mapaCarga.tipoEntrega == 1 ? "Cliente" : "Filial"}",
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: EventoStatusWidget(
                                              color: controller.mapaCarga.mapaCargaEvento?.length != 0
                                                  ? HexColor(controller.mapaCarga.mapaCargaEvento?.last.eventoStatus?.statusCor ??
                                                      '#040491')
                                                  : null,
                                              texto: controller.mapaCarga.mapaCargaEvento?.length != 0
                                                  ? controller.mapaCarga.mapaCargaEvento?.last.eventoStatus?.descricao ?? ''
                                                  : 'Aguardando status'),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InputComponent(
                                      readOnly: true,
                                      label: 'Código do mapa de carga',
                                      initialValue: controller.mapaCarga.idMapaCarga.toString(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: InputComponent(
                                      readOnly: true,
                                      label: 'Data de criação',
                                      initialValue: DateFormat('dd/MM/yyyy').format(controller.mapaCarga.dataEmissao!),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InputComponent(
                                      readOnly: true,
                                      label: 'Filial de origem',
                                      initialValue: controller.mapaCarga.filialOrigem?.id_filial.toString() ?? '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: InputComponent(
                                      readOnly: true,
                                      label: 'Filial de destino',
                                      initialValue: controller.mapaCarga.filialDestino?.id_filial.toString() ?? '',
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InputComponent(
                                        readOnly: true,
                                        label: 'Quantidade',
                                        initialValue:
                                            controller.mapaCarga.volume != null ? controller.mapaCarga.volume.toString() : '',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: InputComponent(
                                        readOnly: true,
                                        label: 'Espécie',
                                        initialValue: controller.mapaCarga.especieVolume ?? '',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: InputComponent(
                                          readOnly: true,
                                          label: 'Funcionário',
                                          initialValue: (controller.mapaCarga.funcionario?.clienteFunc?.cliente?.nome
                                                  .toString()
                                                  .capitalize ??
                                              '')),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  children: [
                                    TitleComponent('Transportadora'),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: InputComponent(
                                          readOnly: true,
                                          label: 'ID transportadora',
                                          initialValue: controller.mapaCarga.transportadora?.idTransportadora.toString() ?? '',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: InputComponent(
                                          readOnly: true,
                                          label: 'Nome',
                                          initialValue:
                                              controller.mapaCarga.transportadora?.contato?.toString().capitalize ?? 'Sem nome',
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
                                        flex: 3,
                                        child: InputComponent(
                                          readOnly: true,
                                          label: 'Motorista',
                                          initialValue: controller
                                                  .mapaCarga.motorista?.funcMotorista?.funcionario?.clienteFunc?.cliente?.nome
                                                  ?.toString()
                                                  .capitalize ??
                                              'Sem motorista',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: InputComponent(
                                          readOnly: true,
                                          label: 'Placa do veículo',
                                          initialValue:
                                              controller.mapaCarga.caminhao?.placa?.toString() ?? 'Sem placa do veículo',
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    controller.mapaCarga.mapaCargaEvento!.length != 0 &&
                                            controller.mapaCarga.mapaCargaEvento!.last.eventoStatus!.id_evento_status !=
                                                MapaCargaEventoStatusEnum.FINALIZADO &&
                                            controller.mapaCarga.mapaCargaEvento!.last.eventoStatus!.id_evento_status !=
                                                MapaCargaEventoStatusEnum.CANCELADO
                                        ? Container(
                                            width: Get.width / 2,
                                            child: ButtonComponent(
                                              onPressed: () {
                                                Get.delete<MapaCargaConsultaController>();
                                                Get.delete<MenuMapaCargaController>();
                                                Get.delete<MapaCargaController>();

                                                Get.offAllNamed(
                                                    '/mapa-carga-edicao/${controller.mapaCarga.idMapaCarga.toString()}');
                                              },
                                              text: 'Editar Mapa Carga',
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                    SizedBox(
                                      height: 22,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        TitleComponent('Itens do mapa de carga'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: controller.mapaCarga.itemMapaCarga!.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Container(
                                        decoration:
                                            BoxDecoration(border: Border(left: BorderSide(color: secundaryColor, width: 2.5))),
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'ID Ordem de Saida: ',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                                ),
                                                Text(
                                                    controller.mapaCarga.itemMapaCarga?[index].pedidoSaida?.idPedidoSaida
                                                            .toString() ??
                                                        '',
                                                    style: TextStyle(
                                                      fontSize: FONTEBASE,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'ID Mapa Carga: ',
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                                      ),
                                                      Text(
                                                          controller.mapaCarga.itemMapaCarga?[index].idItemMapaCarga.toString() ??
                                                              '',
                                                          style: TextStyle(
                                                            fontSize: FONTEBASE,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'ID Asteca: ',
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                                      ),
                                                      Text(
                                                          controller.mapaCarga.itemMapaCarga?[index].pedidoSaida?.asteca?.idAsteca
                                                                  .toString() ??
                                                              '',
                                                          style: TextStyle(
                                                            fontSize: FONTEBASE,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            !(controller.mapaCarga.itemMapaCarga![index].pedidoSaida!.cliente!.nome!.length > 22)
                                                ? Row(
                                                    children: [
                                                      Text(
                                                        'Cliente: ',
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                                      ),
                                                      Text(
                                                          controller.mapaCarga.itemMapaCarga?[index].pedidoSaida?.cliente?.nome
                                                                  .toString()
                                                                  .capitalize ??
                                                              '',
                                                          style: TextStyle(
                                                            fontSize: FONTEBASE,
                                                          ))
                                                    ],
                                                  )
                                                : Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Cliente: ',
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                                      ),
                                                      Text(
                                                          controller.mapaCarga.itemMapaCarga?[index].pedidoSaida?.cliente?.nome
                                                                  .toString()
                                                                  .capitalize ??
                                                              '',
                                                          style: TextStyle(
                                                            fontSize: FONTEBASE,
                                                          ))
                                                    ],
                                                  ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Data de Emissão: ',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                                ),
                                                Text(
                                                    DateFormat('dd/MM/yyyy').format(
                                                        controller.mapaCarga.itemMapaCarga![index].pedidoSaida!.dataEmissao!),
                                                    style: TextStyle(
                                                      fontSize: FONTEBASE,
                                                    ))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              !(controller.mapaCarga.mapaCargaEvento?.isEmpty ?? true)
                                  ? Container(
                                      margin: EdgeInsets.symmetric(vertical: 38),
                                      child: Row(
                                        children: [
                                          TitleComponent('Rastreio do mapa de carga'),
                                        ],
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: controller.mapaCarga.mapaCargaEvento!.length,
                                  itemBuilder: (context, index) {
                                    int reverseIndex = controller.mapaCarga.mapaCargaEvento!.length - 1 - index;
                                    return Card(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: HexColor(controller
                                                            .mapaCarga.mapaCargaEvento?[reverseIndex].eventoStatus?.statusCor ??
                                                        '#040491'),
                                                    width: 2.5))),
                                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'ID Evento: ',
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                                    ),
                                                    Text(
                                                      controller.mapaCarga.mapaCargaEvento?[reverseIndex].idMapaCargaEvento
                                                              .toString() ??
                                                          '',
                                                      style: TextStyle(fontSize: FONTEBASE),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(child: SizedBox()),
                                                Row(
                                                  children: [
                                                    EventoStatusWidget(
                                                        color: controller.mapaCarga.mapaCargaEvento?.length != 0
                                                            ? HexColor(controller.mapaCarga.mapaCargaEvento?[reverseIndex]
                                                                    .eventoStatus?.statusCor ??
                                                                '#040491')
                                                            : null,
                                                        texto: controller.mapaCarga.mapaCargaEvento?.length != 0
                                                            ? controller.mapaCarga.mapaCargaEvento![reverseIndex].eventoStatus
                                                                    ?.descricao ??
                                                                ''
                                                            : 'Aguardando status'),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Descrição: ',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                                ),
                                                Text(
                                                  controller.mapaCarga.mapaCargaEvento?[index].eventoStatus?.mensagemPadrao ?? '',
                                                  style: TextStyle(fontSize: FONTEBASE),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Data: ',
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                                    ),
                                                    Text(
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(controller.mapaCarga.mapaCargaEvento![index].dataEvento!),
                                                      style: TextStyle(fontSize: FONTEBASE),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(child: SizedBox()),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Hora: ',
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                                    ),
                                                    Text(
                                                      DateFormat('HH:mm')
                                                          .format(controller.mapaCarga.mapaCargaEvento![index].dataEvento!),
                                                      style: TextStyle(fontSize: FONTEBASE),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Funcionário: ',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                                                ),
                                                Text(
                                                  controller.mapaCarga.mapaCargaEvento?[index].funcionario?.clienteFunc?.cliente
                                                          ?.nome ??
                                                      '',
                                                  style: TextStyle(fontSize: FONTEBASE),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              controller.mapaCarga.mapaCargaEvento!.length != 0 &&
                                      controller.mapaCarga.mapaCargaEvento!.last.eventoStatus!.id_evento_status ==
                                          MapaCargaEventoStatusEnum.CANCELADO
                                  ? Container(
                                      margin: EdgeInsets.symmetric(vertical: 32),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              TitleComponent('Motivo do cancelamento'),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(vertical: 32),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: InputComponent(
                                                        readOnly: true,
                                                        label: 'Código',
                                                        initialValue: controller
                                                                .mapaCarga.motivoCancelamento?.idMotivoCancelamentoCarga
                                                                .toString() ??
                                                            '',
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: InputComponent(
                                                        readOnly: true,
                                                        label: 'Descrição',
                                                        initialValue: controller.mapaCarga.motivoCancelamento?.descricao
                                                                ?.toString()
                                                                .capitalize ??
                                                            '',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: InputComponent(
                                                        readOnly: true,
                                                        label: 'Funcionário',
                                                        initialValue: controller.mapaCarga.mapaCargaEvento?.last.funcionario
                                                                ?.clienteFunc?.cliente?.nome
                                                                ?.toString()
                                                                .capitalize ??
                                                            '',
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: InputComponent(
                                                          readOnly: true,
                                                          label: 'Data',
                                                          initialValue: controller.mapaCarga.mapaCargaEvento?.last.dataEvento !=
                                                                  null
                                                              ? DateFormat('dd/MM/yyyy')
                                                                  .format(controller.mapaCarga.mapaCargaEvento!.last.dataEvento!)
                                                              : ''),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              Obx(
                                () => !controllerMenu.isLoading.value
                                    ? Container(
                                        margin: EdgeInsets.symmetric(vertical: 32),
                                        child: Column(children: [
                                          controller.mapaCarga.mapaCargaEvento!.length != 0 &&
                                                  controller.mapaCarga.mapaCargaEvento!.last.eventoStatus!.id_evento_status ==
                                                      MapaCargaEventoStatusEnum.FINALIZADO
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 28),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      ButtonComponent(
                                                          color: vermelhoColor,
                                                          onPressed: () {
                                                            exibirModalCancelamento(context);
                                                          },
                                                          text: 'Cancelar Mapa de Carga'),
                                                      SizedBox(
                                                        height: 7,
                                                      ),
                                                      ButtonComponent(
                                                          onPressed: () {
                                                            GerarMapaCargaPDF.imprimirPDF(controller.mapaCarga);
                                                          },
                                                          text: 'Imprimir Mapa de Carga'),
                                                      SizedBox(
                                                        height: 7,
                                                      ),
                                                      ButtonComponent(
                                                          onPressed: () {
                                                            GerarRomaneioPDF.imprimirPDF(controller.mapaCarga);
                                                          },
                                                          text: 'Imprimir Romaneio'),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 28),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: ButtonComponent(
                                                      color: primaryColor,
                                                      colorHover: vermelhoColorHover,
                                                      onPressed: () {
                                                        Get.offAndToNamed('/mapa-carga');
                                                      },
                                                      text: 'Fechar'),
                                                ),
                                                controller.mapaCarga.mapaCargaEvento!.length != 0 &&
                                                        controller
                                                                .mapaCarga.mapaCargaEvento!.last.eventoStatus!.id_evento_status !=
                                                            MapaCargaEventoStatusEnum.FINALIZADO
                                                    ? SizedBox(
                                                        width: 8,
                                                      )
                                                    : SizedBox.shrink(),
                                                controller.mapaCarga.mapaCargaEvento!.length != 0 &&
                                                        controller
                                                                .mapaCarga.mapaCargaEvento!.last.eventoStatus!.id_evento_status !=
                                                            MapaCargaEventoStatusEnum.FINALIZADO &&
                                                        controller
                                                                .mapaCarga.mapaCargaEvento!.last.eventoStatus!.id_evento_status !=
                                                            MapaCargaEventoStatusEnum.CANCELADO
                                                    ? Obx((() => !controller.carregandoFinalizar.value
                                                        ? Expanded(
                                                            flex: 2,
                                                            child: ButtonComponent(
                                                                color: primaryColor,
                                                                colorHover: primaryColorHover,
                                                                onPressed: () {
                                                                  exibirModalAvisoFinalizacao(context);
                                                                },
                                                                text: 'Finalizar mapa de carga'),
                                                          )
                                                        : LoadingComponent()))
                                                    : Container(),
                                              ],
                                            ),
                                          )
                                        ]),
                                      )
                                    : LoadingComponent(),
                              )
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: LoadingComponent(),
                      ))),
          ],
        ));
  }
}

class ButtonSeparacaoWidget extends StatelessWidget {
  final bool separado;
  final Function onPressed;
  const ButtonSeparacaoWidget({
    Key? key,
    required this.separado,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!separado) {
      return GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          color: Colors.grey.shade500,
          width: 120,
          padding: EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Center(
            child: TextComponent(
              'Não separado',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          width: 120,
          color: Colors.lightGreenAccent.shade700,
          padding: EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Center(
            child: TextComponent(
              'Separado',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }
}
