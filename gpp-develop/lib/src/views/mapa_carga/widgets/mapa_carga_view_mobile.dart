// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/caminhao_model.dart';
import 'package:gpp/src/models/motorista_model.dart';
import 'package:gpp/src/models/transportadora_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/CheckboxComponent.dart';
import 'package:gpp/src/shared/components/DropdownButtonFormFieldComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/services/auth.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/mapa_carga/controller/mapa_carga_controller.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:gpp/src/views/pecas/unidade.dart';

class MapaCargaViewMobile extends StatelessWidget {
  final int? idMapa;
  MapaCargaViewMobile({Key? key, this.idMapa}) : super(key: key);

  final controller = Get.put(MapaCargaController());
  double FONTEBASE = 18;

  @override
  Widget build(BuildContext context) {
    controller.mapaCargaEdicao?.idMapaCarga = this.idMapa ?? null;
    Size media = MediaQuery.of(context).size;
    return SingleChildScrollView(
      controller: new ScrollController(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const TextComponent("Transportadora"),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                //INPUT ID TRANSPORTADORA
                Container(
                  child: Column(
                    children: [
                      Obx(
                        () => !controller.carregandoTransportadora.value
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                  controller:
                                      controller.controllerIdTransportadora,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onFieldSubmitted: (value) async {
                                    if (controller
                                            .controllerIdTransportadora.text ==
                                        '') {
                                      controller.limparBuscas();
                                    } else {
                                      controller.limpaMotoCaminhao();
                                      await controller.buscarTransportadora();
                                      await controller.buscarMotorista();
                                    }
                                  },
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'ID Transportadora',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        top: 15, bottom: 10, left: 10),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        if (controller
                                                .controllerIdTransportadora
                                                .text ==
                                            '') {
                                          controller.limparBuscas();
                                        } else {
                                          controller.limpaMotoCaminhao();
                                          await controller
                                              .buscarTransportadora();
                                          await controller.buscarMotorista();
                                        }
                                      },
                                      icon:
                                          Icon(Icons.arrow_right_alt_outlined),
                                    ),
                                  ),
                                ),
                              )
                            : LoadingComponent(),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
                //INPUT NOME TRANSPORTADORA
                Obx(() => !controller.carregandoTransportadora.value
                    ? controller.transportadoraSelecionada.idTransportadora !=
                            null
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              controller:
                                  controller.controllerNomeTransportadora,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: controller
                                            .controllerNomeTransportadora
                                            .text !=
                                        ''
                                    ? controller
                                        .controllerNomeTransportadora.text
                                    : 'Nome Transportadora',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    top: 15, bottom: 10, left: 10),
                              ),
                            ),
                          )
                        : Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5)),
                            child: DropdownSearch<TransportadoraModel>(
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              items: controller.listaTransportadoras,
                              itemAsString: (value) =>
                                  value!.contato.toString(),
                              onChanged: (value) async {
                                controller.limpaMotoCaminhao();
                                controller.controllerIdTransportadora.text =
                                    value!.idTransportadora.toString();
                                controller.transportadoraSelecionada = value;
                                controller.controllerNomeTransportadora.text =
                                    value.contato.toString();
                                await controller.buscarMotorista();
                              },
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  contentPadding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10),
                                  border: InputBorder.none,
                                  labelText: 'Pesquisar por nome',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                                style: const TextStyle(color: Colors.black),
                              ),
                              selectedItem:
                                  controller.listaTransportadoras.first,
                              dropdownBuilder: (context, value) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${value!.idTransportadora.toString()} - ${value.contato?.toString() ?? '-'}',
                                    style: TextStyle(
                                      color: controller
                                                  .transportadoraSelecionada
                                                  .idTransportadora !=
                                              null
                                          ? Colors.black
                                          : Colors.grey,
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                              popupItemBuilder: (context, value, verdadeiro) {
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Text(
                                          "${value.idTransportadora.toString()} - ${value.contato?.toString() ?? '-'}",
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              dropdownSearchDecoration: InputDecoration(
                                fillColor: Colors
                                    .pinkAccent, // Cor fundo caixa dropdown
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                // labelText: 'Filial',
                                // labelStyle: TextStyle(color: Colors.white),
                              ),

                              emptyBuilder: (context, value) {
                                return Center(
                                    child: TextComponent(
                                  'Nenhuma Transportadora encontrada',
                                  textAlign: TextAlign.center,
                                  color: Colors.grey.shade400,
                                ));
                              },

                              dropDownButton: const Icon(
                                Icons.expand_more_rounded,
                                color: Colors.grey,
                              ),
                              popupBackgroundColor: Colors
                                  .white, // Cor de fundo para caixa de seleção
                              showAsSuffixIcons: true,
                            ),
                          )
                    : LoadingComponent()),
                SizedBox(
                  height: 20,
                ),
                //INPUT MOTORISTA / CAMINHAO
                Obx(() => !controller.carregandoMotorista.value
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const TextComponent(
                                        "Selecione o Motorista"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                controller.listaMotoristas.isNotEmpty
                                    ? Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: DropdownSearch<MotoristaModel>(
                                          mode: Mode.MENU,
                                          showSearchBox: true,
                                          items: controller.listaMotoristas,
                                          itemAsString: (value) =>
                                              value?.funcMotorista?.funcionario
                                                  ?.clienteFunc?.cliente?.nome
                                                  .toString() ??
                                              '-',
                                          onChanged: (value) {
                                            controller.motoristaSelecionado =
                                                value!;
                                          },
                                          searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                              fillColor: Colors.grey.shade100,
                                              filled: true,
                                              contentPadding: EdgeInsets.only(
                                                  top: 5, bottom: 5, left: 10),
                                              border: InputBorder.none,
                                              labelText: 'Pesquisar pelo nome',
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          selectedItem:
                                              controller.listaMotoristas.first,
                                          dropdownBuilder: (context, value) {
                                            return Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${value?.idMotorista.toString() ?? '-'} - ${value?.funcMotorista?.funcionario?.clienteFunc?.cliente?.nome.toString() ?? '-'}',
                                                style: TextStyle(
                                                  color: controller
                                                              .motoristaSelecionado
                                                              .idMotorista !=
                                                          null
                                                      ? Colors.black
                                                      : Colors.grey,
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          },
                                          popupItemBuilder:
                                              (context, value, verdadeiro) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Text(
                                                      "${value.idMotorista.toString()} - ${value.funcMotorista?.funcionario?.clienteFunc?.cliente?.nome.toString() ?? '-'}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            isDense: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            // labelText: 'Filial',
                                            // labelStyle: TextStyle(color: Colors.white),
                                          ),

                                          emptyBuilder: (context, value) {
                                            return Center(
                                                child: TextComponent(
                                              'Nenhum motorista encontrado',
                                              textAlign: TextAlign.center,
                                              color: Colors.grey.shade400,
                                            ));
                                          },

                                          dropDownButton: const Icon(
                                            Icons.expand_more_rounded,
                                            color: Colors.grey,
                                          ),
                                          popupBackgroundColor: Colors
                                              .white, // Cor de fundo para caixa de seleção
                                          showAsSuffixIcons: true,
                                        ),
                                      )
                                    : Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: TextFormField(
                                          enabled: false,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13),
                                          decoration: InputDecoration(
                                            hintText: controller.mapaCargaEdicao
                                                        ?.idMotorista !=
                                                    null
                                                ? controller
                                                        .motoristaSelecionado
                                                        .funcMotorista
                                                        ?.funcionario
                                                        ?.clienteFunc
                                                        ?.cliente
                                                        ?.nome ??
                                                    'Informe a transportadora'
                                                : 'Informe a transportadora',
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                                top: 15,
                                                bottom: 18,
                                                left: 7,
                                                right: 5),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const TextComponent("Selecione o Caminhão"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                controller.listaCaminhao.isNotEmpty
                                    ? Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: DropdownSearch<CaminhaoModel>(
                                          mode: Mode.MENU,
                                          showSearchBox: true,
                                          items: controller.listaCaminhao,
                                          itemAsString: (value) =>
                                              value!.placa.toString(),
                                          onChanged: (value) {
                                            controller.caminhaoSelecionado =
                                                value!;
                                          },
                                          searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                              fillColor: Colors.grey.shade100,
                                              filled: true,
                                              contentPadding: EdgeInsets.only(
                                                  top: 5, bottom: 5, left: 10),
                                              border: InputBorder.none,
                                              labelText: 'Pesquisar por placa',
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          selectedItem:
                                              controller.listaCaminhao.first,
                                          dropdownBuilder: (context, value) {
                                            return Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${value!.placa}',
                                                style: TextStyle(
                                                  color: controller
                                                              .caminhaoSelecionado
                                                              .idCaminhao !=
                                                          null
                                                      ? Colors.black
                                                      : Colors.grey,
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          },
                                          popupItemBuilder:
                                              (context, value, verdadeiro) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Text(
                                                      "${value.placa}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            isDense: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            // labelText: 'Filial',
                                            // labelStyle: TextStyle(color: Colors.white),
                                          ),

                                          emptyBuilder: (context, value) {
                                            return Center(
                                                child: TextComponent(
                                              'Nenhum caminhão encontrado',
                                              textAlign: TextAlign.center,
                                              color: Colors.grey.shade400,
                                            ));
                                          },

                                          dropDownButton: const Icon(
                                            Icons.expand_more_rounded,
                                            color: Colors.grey,
                                          ),
                                          popupBackgroundColor: Colors
                                              .white, // Cor de fundo para caixa de seleção
                                          showAsSuffixIcons: true,
                                        ),
                                      )
                                    : Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: TextFormField(
                                          enabled: false,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13),
                                          decoration: InputDecoration(
                                            hintText: controller.mapaCargaEdicao
                                                        ?.idCaminhao !=
                                                    null
                                                ? controller.caminhaoSelecionado
                                                        .placa ??
                                                    'Informe a transportadora'
                                                : 'Informe a transportadora',
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                                top: 15,
                                                bottom: 18,
                                                left: 7,
                                                right: 5),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Flexible(flex: 5, child: LoadingComponent()),
                          Flexible(flex: 5, child: LoadingComponent())
                        ],
                      )),
                SizedBox(
                  height: 20,
                ),
                //INPUT FILIAIS VOLUME E ESPECIE
                Obx(
                  () => !controller.carregandoSubDados.value
                      ? Form(
                          key: controller.FormKeyMapaCarga,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InputComponent(
                                  enable: false,
                                  controller: controller.controllerFilialOrigem,
                                  initialValue:
                                      controller.controllerFilialOrigem.text,
                                  label: "Filial Origem",
                                  hintText: getFilial().id_filial.toString(),
                                ),
                              ),
                              controller.groupRadio.value
                                  ? SizedBox(
                                      width: 7,
                                    )
                                  : SizedBox.shrink(),
                              controller.groupRadio.value
                                  ? Expanded(
                                      flex: 1,
                                      child: InputComponent(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Este campo é obrigatório';
                                          }
                                          return null;
                                        },
                                        inputFormatter: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        controller:
                                            controller.controllerFilialDestino,
                                        label: "Filial Destino",
                                        initialValue: controller
                                            .controllerFilialDestino.text,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          controller.controllerFilialDestino
                                              .text = value;
                                        },
                                        hintText: 'Filial...',
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: InputComponent(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Este campo é obrigatório';
                                      }
                                      return null;
                                    },
                                    controller: controller.controllerVolume,
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    initialValue:
                                        controller.controllerVolume.text,
                                    label: "Volume",
                                    onChanged: (value) {
                                      controller.controllerVolume.text = value;
                                    },
                                    hintText: 'Volume...',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: LoadingComponent(),
                        ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Espécie",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      DropdownButtonFormFieldComponent(
                        items:
                            UnidadeTipo.values.map((UnidadeTipo? unidadeTipo) {
                          return DropdownMenuItem<UnidadeTipo>(
                              alignment: AlignmentDirectional.center,
                              value: unidadeTipo,
                              child: Text(unidadeTipo!.name));
                        }).toList(),
                        hintText: controller.especieDropDown.name,
                        onChanged: (UnidadeTipo? value) {
                          controller.especieDropDown = value!;
                        },
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Filial'),
                              Radio(
                                focusColor: primaryColor,
                                fillColor:
                                    MaterialStateProperty.all(primaryColor),
                                groupValue: controller.groupRadio.value,
                                value: true,
                                onChanged: (value) {
                                  controller.groupRadio(true);
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Cliente'),
                              Radio(
                                focusColor: primaryColor,
                                fillColor:
                                    MaterialStateProperty.all(primaryColor),
                                groupValue: controller.groupRadio.value,
                                value: false,
                                onChanged: (value) {
                                  controller.groupRadio(false);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Obx(() => !controller.carregandoPedidos.value
                          ? ButtonComponent(
                              color: primaryColor,
                              colorHover: primaryColorHover,
                              onPressed: () {
                                exibirOrdemSaida(context);
                              },
                              text: 'Adicionar Ordens de Saída',
                            )
                          : Center(child: LoadingComponent())),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      flex: 1,
                      child: ButtonComponent(
                        color: primaryColor,
                        onPressed: () {
                          controller.limparBuscas();
                        },
                        text: 'Limpar',
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => controller.isList.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.inventory_rounded,
                                    size: 32,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  const TitleComponent('Ordens de Saída'),
                                ],
                              ),
                            ),
                            //new Spacer(),
                            //ButtonComponent(onPressed: () {}, text: 'Adicionar Peça'),
                          ],
                        )
                      : SizedBox.shrink(),
                ),
                Obx(
                  () => !controller.carregandoListaMapa.value
                      ? Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            scrollDirection: Axis.vertical,
                            itemCount:
                                controller.listaPedidosParaEntrada.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: secundaryColor,
                                              style: BorderStyle.solid,
                                              width: 4.5))),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        !(controller
                                                    .listaPedidosParaEntrada[
                                                        index]
                                                    .cliente!
                                                    .nome!
                                                    .length >
                                                20)
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'ID: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                FONTEBASE),
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        '${controller.listaPedidosParaEntrada[index].idPedidoSaida.toString()}',
                                                        style: TextStyle(
                                                            fontSize:
                                                                FONTEBASE),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 7,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Nome: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                FONTEBASE),
                                                      ),
                                                      Text(
                                                          '${controller.listaPedidosParaEntrada[index].cliente!.nome.toString()}',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  FONTEBASE))
                                                    ],
                                                  )
                                                ],
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'ID Ordem de Saída:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                FONTEBASE),
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        '${controller.listaPedidosParaEntrada[index].idPedidoSaida.toString()}',
                                                        style: TextStyle(
                                                            fontSize:
                                                                FONTEBASE),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Nome: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  FONTEBASE),
                                                        ),
                                                        Text(
                                                            '${controller.listaPedidosParaEntrada[index].cliente!.nome.toString()}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    FONTEBASE))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Asteca: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: FONTEBASE),
                                                  ),
                                                  Text(
                                                      '${controller.listaPedidosParaEntrada[index].asteca!.idAsteca.toString()}',
                                                      style: TextStyle(
                                                          fontSize: FONTEBASE))
                                                ],
                                              ),
                                              Expanded(child: SizedBox()),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Data: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: FONTEBASE),
                                                  ),
                                                  Text(
                                                      '${DateFormat('dd/MM/yyyy').format(controller.listaPedidosParaEntrada[index].dataEmissao!).toString()}',
                                                      style: TextStyle(
                                                          fontSize: FONTEBASE))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              tooltip: 'Excluir Item',
                                              icon: Icon(
                                                Icons.delete_outlined,
                                                color: Colors.grey.shade400,
                                              ),
                                              onPressed: () async {
                                                await controller
                                                    .removerPedidosMapa(controller
                                                            .listaPedidosParaEntrada[
                                                        index]);
                                              },
                                            )
                                          ],
                                        )
                                      ]),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  exibirOrdemSaida(context) async {
    try {
      await controller.buscarPedidoSaida();
      controller.isList(true);

      MediaQueryData media = MediaQuery.of(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                title: Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.settings,
                          size: 32,
                        ),
                        CloseButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            controller.isList(false);
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    TitleComponent('Ordens de Saída para Mapa de Carga'),
                  ],
                ),
                content: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Container(
                    width: media.size.width * 0.80,
                    child: Column(
                      children: [
                        Wrap(
                          children: [
                            const TextComponent(
                              'Selecione uma ou mais Ordens de Saída para realizar o Mapa de Carga',
                              letterSpacing: 0.15,
                              fontSize: 16,
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Form(
                            key: controller.filtroFormKey,
                            child: Column(
                              children: [
                                InputComponent(
                                  controller:
                                      controller.controllerFiltroNomeCliente,
                                  onSaved: (value) {
                                    controller.controllerFiltroNomeCliente
                                        .text = value;
                                  },
                                  hintText: 'Nome Cliente',
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InputComponent(
                                        controller:
                                            controller.controllerFiltroIdPedido,
                                        onSaved: (value) {
                                          controller.controllerFiltroIdPedido
                                              .text = value;
                                        },
                                        hintText: 'ID Ordem Saída',
                                        keyboardType: TextInputType.number,
                                        inputFormatter: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Expanded(
                                      child: InputComponent(
                                        controller:
                                            controller.controllerFiltroIdAsteca,
                                        onSaved: (value) {},
                                        hintText: 'ID Asteca',
                                        keyboardType: TextInputType.number,
                                        inputFormatter: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text('Marcar todos '),
                                        CheckboxComponent(
                                          value: controller.marcados ==
                                              controller.listaPedidosSaidaBusca
                                                  .length,
                                          onChanged: (bool value) {
                                            setState(() {
                                              controller
                                                  .marcarTodosCheckbox(value);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    ButtonComponent(
                                      color: secundaryColor,
                                      colorHover: secundaryColorHover,
                                      icon: Icon(Icons.search,
                                          color: Colors.white),
                                      onPressed: () async {
                                        if (controller.validaFiltros()) {
                                          controller.filtroFormKey.currentState!
                                              .save();
                                          await controller.buscarPedidoSaida();
                                        } else {
                                          controller.filtroFormKey.currentState!
                                              .reset();
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
                        Obx(() => !controller.carregandoPedidos.value
                            ? Container(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: controller
                                      .listaPopUpPedidosSaidaBusca.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(
                                          () {
                                            if (!controller
                                                .listaPopUpPedidosSaidaBusca[
                                                    index]
                                                .marcado!) {
                                              controller
                                                  .listaPopUpPedidosSaidaBusca[
                                                      index]
                                                  .marcado = true;
                                              controller.marcados++;
                                            } else {
                                              controller
                                                  .listaPopUpPedidosSaidaBusca[
                                                      index]
                                                  .marcado = false;
                                              controller.marcados--;
                                            }
                                          },
                                        );
                                      },
                                      child: Card(
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                                      color: secundaryColor,
                                                      style: BorderStyle.solid,
                                                      width: 4.5))),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: CheckboxComponent(
                                                      value: controller
                                                          .listaPopUpPedidosSaidaBusca[
                                                              index]
                                                          .marcado!,
                                                      onChanged: (bool value) =>
                                                          {
                                                            setState(() {
                                                              controller
                                                                  .marcarCheckbox(
                                                                      index,
                                                                      value);
                                                            })
                                                          }),
                                                ),
                                                Expanded(
                                                  flex: 6,
                                                  child: Column(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'ID:',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        FONTEBASE),
                                                              ),
                                                              SizedBox(
                                                                width: 7,
                                                              ),
                                                              Text(
                                                                '${controller.listaPopUpPedidosSaidaBusca[index].pedidoSaida?.idPedidoSaida.toString() ?? ''}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        FONTEBASE),
                                                              ),
                                                              SizedBox(
                                                                width: 7,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'ID Asteca: ',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            FONTEBASE),
                                                                  ),
                                                                  Text(
                                                                      '${controller.listaPopUpPedidosSaidaBusca[index].pedidoSaida?.asteca?.idAsteca.toString() ?? ''}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              FONTEBASE))
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 7,
                                                          ),
                                                          Container(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Nome: ',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          FONTEBASE),
                                                                ),
                                                                Text(
                                                                    '${controller.listaPopUpPedidosSaidaBusca[index].pedidoSaida?.cliente?.nome.toString() ?? ''}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            FONTEBASE))
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 7,
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              height: 7,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Data: ',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          FONTEBASE),
                                                                ),
                                                                Text(
                                                                    '${DateFormat('dd/MM/yyyy').format(controller.listaPedidosSaidaBusca[index].dataEmissao!)}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            FONTEBASE))
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 7,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Text(
                                                                    '1º Mapeamento: ',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            FONTEBASE),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      /* Se a Asteca possui a pendência 652, então essa ordem de saída
                                                                       * já foi mapeada anteriormente
                                                                       */
                                                                      !controller
                                                                              .listaPedidosSaidaBusca[index]
                                                                              .asteca!
                                                                              .astecaPendencias!
                                                                              .map((pendencia) => pendencia.astecaTipoPendencia?.idTipoPendencia)
                                                                              .contains(652)
                                                                          ? EventoStatusWidget(
                                                                              texto: 'Sim',
                                                                              color: HexColor('00CF08'),
                                                                            )
                                                                          : EventoStatusWidget(
                                                                              texto: 'Não',
                                                                              color: HexColor('CD001A'),
                                                                            ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Expanded(
                                child: Center(child: LoadingComponent()))),
                        const Divider(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(
                              () => !controller.carregandoPedidos.value
                                  ? TextComponent(
                                      'Total de Ordens de Saída selecionadas: ${controller.marcados}')
                                  : LoadingComponent(),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonComponent(
                                    color: vermelhoColor,
                                    colorHover: vermelhoColorHover,
                                    onPressed: () {
                                      Get.back();
                                      controller.listaPopUpPedidosSaidaBusca
                                          .clear();
                                    },
                                    text: 'Cancelar'),
                                const SizedBox(
                                  width: 12,
                                ),
                                Obx(() =>
                                    !controller.carregandoPedidosParaMapa.value
                                        ? ButtonComponent(
                                            color: secundaryColor,
                                            colorHover: secundaryColorHover,
                                            onPressed: () async {
                                              await controller
                                                  .adicionarPedidosParaMapa();
                                              controller
                                                  .listaPopUpPedidosSaidaBusca
                                                  .clear();
                                            },
                                            text: 'Adicionar')
                                        : LoadingComponent())
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
          });
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }
}
