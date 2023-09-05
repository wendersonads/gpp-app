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

class MapaCargaViewDesktop extends StatelessWidget {
  final int? idMapa;
  MapaCargaViewDesktop({Key? key, this.idMapa}) : super(key: key);

  final controller = Get.put(MapaCargaController());

  @override
  Widget build(BuildContext context) {
    controller.mapaCargaEdicao?.idMapaCarga = this.idMapa ?? null;
    Size media = MediaQuery.of(context).size;
    print(controller.mapaCargaEdicao!.idMapaCarga.toString() +
        ' ' +
        controller.isEdicao.toString());
    return Expanded(
      child: SingleChildScrollView(
        controller: new ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const TextComponent("Transportadora"),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Obx(
                      () => !controller.carregandoTransportadora.value
                          ? Flexible(
                              flex: 1,
                              child: Column(
                                children: [
                                  Container(
                                    height: 40,
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
                                              await controller
                                                  .buscarMotorista();
                                            }
                                          },
                                          icon: Icon(
                                              Icons.arrow_right_alt_outlined),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(flex: 1, child: LoadingComponent()),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 30)),
                    Flexible(
                      flex: 4,
                      child: Obx(() => !controller
                              .carregandoTransportadora.value
                          ? controller.transportadoraSelecionada
                                      .idTransportadora !=
                                  null
                              ? Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextFormField(
                                    controller:
                                        controller.controllerNomeTransportadora,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
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
                                  height: 40,
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
                                      controller
                                              .controllerIdTransportadora.text =
                                          value!.idTransportadora.toString();
                                      controller.transportadoraSelecionada =
                                          value;
                                      controller.controllerNomeTransportadora
                                          .text = value.contato.toString();
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
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
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
                                    popupItemBuilder:
                                        (context, value, verdadeiro) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 8),
                                              child: Text(
                                                "${value.idTransportadora.toString()} - ${value.contato?.toString() ?? '-'}",
                                                textAlign: TextAlign.center,
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
                    ),
                    const Padding(padding: EdgeInsets.only(right: 30)),
                    Flexible(
                      flex: 1,
                      child: ButtonComponent(
                        color: primaryColor,
                        colorHover: primaryColorHover,
                        onPressed: () {
                          controller.limparBuscas();
                        },
                        text: 'Limpar Seleções',
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 30)),
                  ],
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            Obx(() => !controller.carregandoMotorista.value
                ? Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const TextComponent("Selecione o Motorista"),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            controller.listaMotoristas.isNotEmpty
                                ? Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5)),
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
                                                  BorderRadius.circular(10)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Text(
                                                  "${value.idMotorista.toString()} - ${value.funcMotorista?.funcionario?.clienteFunc?.cliente?.nome.toString() ?? '-'}",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      dropdownSearchDecoration: InputDecoration(
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
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextFormField(
                                      enabled: false,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
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
                                                'Aguardando seleção de transportadora'
                                            : 'Aguardando seleção de transportadora',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            top: 15, bottom: 10, left: 10),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15)),
                      Flexible(
                        flex: 3,
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
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: DropdownSearch<CaminhaoModel>(
                                      mode: Mode.MENU,
                                      showSearchBox: true,
                                      items: controller.listaCaminhao,
                                      itemAsString: (value) =>
                                          value!.placa.toString(),
                                      onChanged: (value) {
                                        controller.caminhaoSelecionado = value!;
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
                                                  BorderRadius.circular(10)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Text(
                                                  "${value.placa}",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      dropdownSearchDecoration: InputDecoration(
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
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextFormField(
                                      enabled: false,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: controller.mapaCargaEdicao
                                                    ?.idCaminhao !=
                                                null
                                            ? controller.caminhaoSelecionado
                                                    .placa ??
                                                'Aguardando seleção de transportadora'
                                            : 'Aguardando seleção de transportadora',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            top: 15, bottom: 10, left: 10),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(right: 30)),
                    ],
                  )
                : Row(
                    children: [
                      Flexible(flex: 5, child: LoadingComponent()),
                      Flexible(flex: 5, child: LoadingComponent())
                    ],
                  )),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            Obx(
              () => !controller.carregandoSubDados.value
                  ? Form(
                      key: controller.FormKeyMapaCarga,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: InputComponent(
                              enable: false,
                              controller: controller.controllerFilialOrigem,
                              initialValue:
                                  controller.controllerFilialOrigem.text,
                              label: "Filial Origem",
                              hintText: getFilial().id_filial.toString(),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(right: 30)),
                          controller.groupRadio.value
                              ? Flexible(
                                  flex: 2,
                                  child: InputComponent(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Este campo é obrigatório';
                                      }
                                      return null;
                                    },
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    controller:
                                        controller.controllerFilialDestino,
                                    label: "Filial Destino",
                                    initialValue:
                                        controller.controllerFilialDestino.text,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      controller.controllerFilialDestino.text =
                                          value;
                                    },
                                    hintText: 'Digite a filial de destino',
                                  ),
                                )
                              : Container(),
                          const Padding(padding: EdgeInsets.only(right: 30)),
                          Flexible(
                            flex: 2,
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
                              initialValue: controller.controllerVolume.text,
                              label: "Volume",
                              onChanged: (value) {
                                controller.controllerVolume.text = value;
                              },
                              hintText: 'Digite o volume',
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(right: 30)),
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextComponent("Espécie"),
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                DropdownButtonFormFieldComponent(
                                  items: UnidadeTipo.values
                                      .map((UnidadeTipo? unidadeTipo) {
                                    return DropdownMenuItem<UnidadeTipo>(
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
                          const Padding(padding: EdgeInsets.only(right: 30)),
                        ],
                      ),
                    )
                  : Center(
                      child: LoadingComponent(),
                    ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Filial'),
                  Radio(
                    focusColor: primaryColor,
                    fillColor: MaterialStateProperty.all(primaryColor),
                    groupValue: controller.groupRadio.value,
                    value: true,
                    onChanged: (value) {
                      controller.groupRadio(true);
                    },
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                  const Text('Cliente'),
                  Radio(
                    focusColor: primaryColor,
                    fillColor: MaterialStateProperty.all(primaryColor),
                    groupValue: controller.groupRadio.value,
                    value: false,
                    onChanged: (value) {
                      controller.groupRadio(false);
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(right: 30))
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => !controller.carregandoPedidos.value
                    ? ButtonComponent(
                        color: primaryColor,
                        colorHover: primaryColorHover,
                        onPressed: () {
                          exibirOrdemSaida(context);
                        },
                        text: 'Adicionar Ordens de Saída',
                      )
                    : Center(child: LoadingComponent())),
                const Padding(padding: EdgeInsets.only(right: 30))
              ],
            ),
            const Padding(padding: EdgeInsets.only(left: 30)),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                  //new Spacer(),
                  //ButtonComponent(onPressed: () {}, text: 'Adicionar Peça'),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.only(right: 18),
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              color: Colors.grey.shade200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: const TextComponent(
                      'ID O.S',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    //flex: ,
                    child: const TextComponent(
                      'ID Asteca',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: const TextComponent(
                      'Data O.S',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: const TextComponent(
                      'Nome Cliente',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: const TextComponent(
                      'Ações',
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => !controller.carregandoListaMapa.value
                  ? Center(
                      child: Container(
                        height: media.height / 2,
                        child: ListView.builder(
                          primary: false,
                          itemCount: controller.listaPedidosParaEntrada.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 18),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey.shade100),
                                      left: BorderSide(
                                          color: Colors.grey.shade100),
                                      bottom: BorderSide(
                                          color: Colors.grey.shade100),
                                      right: BorderSide(
                                          color: Colors.grey.shade100))),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SelectableText(
                                      controller.listaPedidosParaEntrada[index]
                                          .idPedidoSaida
                                          .toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: SelectableText(
                                      controller.listaPedidosParaEntrada[index]
                                          .asteca!.idAsteca
                                          .toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: SelectableText(
                                      DateFormat('dd/MM/yyyy')
                                          .format(controller
                                              .listaPedidosParaEntrada[index]
                                              .dataEmissao!)
                                          .toString(),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: SelectableText(
                                      controller.listaPedidosParaEntrada[index]
                                          .cliente!.nome
                                          .toString(),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5)),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: IconButton(
                                          tooltip: 'Excluir Item',
                                          icon: Icon(
                                            Icons.delete_outlined,
                                            color: Colors.grey.shade400,
                                          ),
                                          onPressed: () async {
                                            await controller.removerPedidosMapa(
                                                controller
                                                        .listaPedidosParaEntrada[
                                                    index]);
                                          },
                                        ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Container(),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            const Divider(),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  exibirOrdemSaida(context) async {
    try {
      await controller.buscarPedidoSaida();

      MediaQueryData media = MediaQuery.of(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      size: 32,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const TitleComponent('Ordens de Saída para Mapa de Carga'),
                  ],
                ),
                content: Container(
                  width: media.size.width * 0.80,
                  height: media.size.height * 0.80,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const TextComponent(
                              'Selecione uma ou mais Ordens de Saída para realizar o Mapa de Carga',
                              letterSpacing: 0.15,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Form(
                            key: controller.filtroFormKey,
                            child: Row(
                              children: [
                                Expanded(
                                  child: InputComponent(
                                    controller:
                                        controller.controllerFiltroIdPedido,
                                    onSaved: (value) {
                                      controller.controllerFiltroIdPedido.text =
                                          value;
                                    },
                                    hintText: 'ID Ordem Saída',
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
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
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: InputComponent(
                                    controller:
                                        controller.controllerFiltroNomeCliente,
                                    onSaved: (value) {
                                      controller.controllerFiltroNomeCliente
                                          .text = value;
                                    },
                                    hintText: 'Nome Cliente',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                ButtonComponent(
                                  color: secundaryColor,
                                  colorHover: secundaryColorHover,
                                  icon: Icon(Icons.search, color: Colors.white),
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
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        color: Colors.grey.shade200,
                        child: Row(
                          children: [
                            CheckboxComponent(
                              value: controller.marcados ==
                                  controller.listaPedidosSaidaBusca.length,
                              onChanged: (bool value) {
                                setState(() {
                                  controller.marcarTodosCheckbox(value);
                                });
                              },
                            ),
                            Expanded(
                              flex: 2,
                              child: const TextComponent(
                                'ID Ordem Saida',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: const TextComponent(
                                'ID Asteca',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: const TextComponent(
                                'Data Ordem Saida',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: const TextComponent(
                                'Nome Cliente',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: const TextComponent(
                                'Primeiro Mapeamento',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => !controller.carregandoPedidos.value
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: controller
                                    .listaPopUpPedidosSaidaBusca.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey.shade100),
                                            left: BorderSide(
                                                color: Colors.grey.shade100),
                                            bottom: BorderSide(
                                                color: Colors.grey.shade100),
                                            right: BorderSide(
                                                color: Colors.grey.shade100))),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 12),
                                    //color: (index % 2) == 0 ? Colors.white : Colors.grey.shade50,
                                    child: Row(
                                      children: [
                                        CheckboxComponent(
                                            value: controller
                                                .listaPopUpPedidosSaidaBusca[
                                                    index]
                                                .marcado!,
                                            onChanged: (bool value) => {
                                                  setState(() {
                                                    controller.marcarCheckbox(
                                                        index, value);
                                                  })
                                                }),
                                        Expanded(
                                          flex: 2,
                                          child: TextComponent(controller
                                                  .listaPedidosSaidaBusca[index]
                                                  .idPedidoSaida
                                                  ?.toString() ??
                                              ''),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TextComponent(controller
                                                  .listaPedidosSaidaBusca[index]
                                                  .asteca
                                                  ?.idAsteca
                                                  .toString() ??
                                              ''),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TextComponent(
                                            DateFormat('dd/MM/yyyy').format(
                                                controller
                                                    .listaPedidosSaidaBusca[
                                                        index]
                                                    .dataEmissao!),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: TextComponent(controller
                                                  .listaPedidosSaidaBusca[index]
                                                  .cliente
                                                  ?.nome
                                                  .toString() ??
                                              ''),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: /* Se a Asteca possui a pendência 652, então essa ordem de saída
                                                  * já foi mapeada anteriormente
                                                  */
                                              !controller
                                                      .listaPedidosSaidaBusca[
                                                          index]
                                                      .asteca!
                                                      .astecaPendencias!
                                                      .map((pendencia) =>
                                                          pendencia
                                                              .astecaTipoPendencia
                                                              ?.idTipoPendencia)
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
                                  );
                                },
                              ),
                            )
                          : Expanded(child: Center(child: LoadingComponent()))),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => !controller.carregandoPedidos.value
                                ? TextComponent(
                                    'Total de Ordens de Saída selecionadas: ${controller.marcados}')
                                : LoadingComponent(),
                          ),
                          Row(
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
                          )
                        ],
                      )
                    ],
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
