import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/produto/fornecedor_model.dart';
import 'package:gpp/src/shared/components/CheckboxComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/utils/CurrencyPtBrInputFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/entrada/controller/entrada_manual_controller.dart';

import '../../../shared/components/ButtonComponent.dart';
import '../../../shared/components/TextComponent.dart';
import '../../../shared/components/TitleComponent.dart';
import '../../../shared/repositories/styles.dart';

class EntradaManualViewDesktop extends StatefulWidget {
  const EntradaManualViewDesktop({Key? key}) : super(key: key);

  @override
  _EntradaManualViewState createState() => _EntradaManualViewState();
}

class _EntradaManualViewState extends State<EntradaManualViewDesktop> {
  final controller = Get.put(EntradaManualController());

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size media = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        controller: new ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: controller.notaFiscalForm,
              child: Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        controller: controller.controllerNotaFiscal,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Nota Fiscal',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(top: 15, bottom: 10, left: 10),
                        ),
                        onSaved: (value) {
                          controller.controllerNotaFiscal.text = value!;
                        },
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        controller: controller.controllerSerie,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Série',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(top: 15, bottom: 10, left: 10),
                        ),
                        onSaved: (value) {
                          controller.controllerSerie.text = value!;
                        },
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              children: [
                Obx(
                  () => !controller.carregandoFornecedor.value
                      ? Flexible(
                          flex: 1,
                          child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                controller: controller.controllerIdFornecedor,
                                onFieldSubmitted: (value) async {
                                  await controller.buscarFornecedor();
                                },
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'ID',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      top: 15, bottom: 10, left: 10),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      await controller.buscarFornecedor();
                                    },
                                    icon: Icon(Icons.search),
                                  ),
                                ),
                              )),
                        )
                      : Expanded(flex: 1, child: LoadingComponent()),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Obx(
                  () => !controller.carregandoFornecedor.value
                      ? Flexible(
                          flex: 3,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownSearch<FornecedorModel?>(
                              mode: Mode.MENU,
                              showSearchBox: true,
                              searchDelay: Duration(seconds: 1),
                              isFilteredOnline: true,
                              itemAsString: (FornecedorModel? value) =>
                                  '${value!.cliente?.idCliente} - ${value.cliente?.nome}',
                              onFind: (String? filter) async {
                                return await controller
                                    .buscarFornecedores(filter);
                              },
                              selectedItem: controller
                                  .fornecedorController.fornecedorModel,
                              searchFieldProps: TextFieldProps(
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: 'Nome do Fornecedor',
                                  border: InputBorder.none,
                                ),
                              ),
                              onChanged: (fornecedor) {
                                controller
                                        .fornecedorController.fornecedorModel =
                                    fornecedor as FornecedorModel;
                                controller.controllerIdFornecedor.text =
                                    fornecedor.idFornecedor.toString();
                              },
                              dropdownSearchDecoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 8, bottom: 8),
                                border: InputBorder.none,
                              ),
                              dropdownBuilder: (context, value) {
                                return Text(
                                    '${value!.cliente?.nome ?? 'Fornecedor'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ));
                              },
                              emptyBuilder: (context, value) {
                                return Center(
                                    child: TextComponent(
                                  'Nenhum fornecedor encontrado',
                                  textAlign: TextAlign.center,
                                  color: Colors.grey.shade400,
                                ));
                              },
                            ),
                          ),
                        )
                      : Expanded(flex: 3, child: LoadingComponent()),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Flexible(
                  flex: 1,
                  child: ButtonComponent(
                    onPressed: () {
                      if (controller.fornecedorController.fornecedorModel
                              .idFornecedor !=
                          null) {
                        exibirPecas(context);
                      } else {
                        Notificacao.snackBar(
                            "Informe um fornecedor antes de adicionar as peças");
                      }
                    },
                    text: 'Adicionar Peça',
                    color: primaryColor,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 5)),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 25)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.handyman,
                        size: 32,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const TitleComponent('Peças'),
                      new Spacer(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  margin: EdgeInsets.only(right: 18),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  color: Colors.grey.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: const TextComponent(
                          'ID. Peça',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: const TextComponent(
                          'Descrição Peça',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: const TextComponent(
                          'Qtd. Pedida',
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: const TextComponent(
                          'Qtd. Recebida',
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: const TextComponent(
                          'Valor Unitário',
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: const TextComponent(
                          'Ações',
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => !controller.carregandoPecasEntrada.value
                      ? Container(
                          height: 450,
                          child: ListView.builder(
                            primary: false,
                            itemCount: controller.listaMovimento.length,
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextComponent(
                                          controller.listaMovimento[index]
                                              .pecaModel!.id_peca
                                              .toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: TextComponent(
                                          controller.listaMovimento[index]
                                              .pecaModel!.descricao
                                              .toString(),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Qtd',
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 5,
                                                  right: 5),
                                            ),
                                            onChanged: (value) {
                                              if (value == '')
                                                controller.listaMovimento[index]
                                                    .quantidade_pedido = null;
                                              else
                                                controller.listaMovimento[index]
                                                        .quantidade_pedido =
                                                    int.parse(value);
                                            },
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Qtd',
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 5,
                                                  right: 5),
                                            ),
                                            onChanged: (value) {
                                              if (value == '')
                                                controller.listaMovimento[index]
                                                    .quantidade = null;
                                              else
                                                controller.listaMovimento[index]
                                                        .quantidade =
                                                    int.parse(value);
                                            },
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              CurrencyPtBrInputFormatter()
                                            ],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: '0,00',
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 5,
                                                  right: 5),
                                              prefixText: 'R\$ ',
                                            ),
                                            onChanged: (value) {
                                              if (value == '')
                                                controller.listaMovimento[index]
                                                    .valor_unitario = 0.0;
                                              else
                                                controller.listaMovimento[index]
                                                        .valor_unitario =
                                                    (double.parse(value
                                                        .replaceAll('.', '')
                                                        .replaceAll(',', '.')));
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: IconButton(
                                              tooltip: 'Excluir Item',
                                              icon: Icon(
                                                Icons.delete_outlined,
                                                color: Colors.grey.shade400,
                                              ),
                                              onPressed: () {
                                                controller.removerPecasEntrada(
                                                    controller
                                                        .listaMovimento[index]);
                                              },
                                            ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          height: 450,
                          child: LoadingComponent(),
                        ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            const Divider(),
          ],
        ),
      ),
    );
  }

  exibirPecas(context) async {
    try {
      //await controller.buscarPedidosEntrada();

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
                    const TitleComponent('Peças para entrada'),
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
                              'Selecione uma ou mais Peças para entrada',
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
                                  flex: 5,
                                  child: InputComponent(
                                    controller: controller.controllerIdProduto,
                                    onSaved: (value) {
                                      controller.controllerIdProduto.text =
                                          value;
                                    },
                                    hintText: 'ID Produto',
                                    onFieldSubmitted: (value) async {
                                      controller.filtroFormKey.currentState!
                                          .save();

                                      controller.pecasPopUp.clear();
                                      await controller.buscarPecas();
                                      controller.filtroFormKey.currentState!
                                          .reset();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 5,
                                  child: InputComponent(
                                    controller: controller.controllerIdPeca,
                                    onSaved: (value) {
                                      controller.controllerIdPeca.text = value;
                                    },
                                    hintText: 'ID Peças',
                                    onFieldSubmitted: (value) async {
                                      controller.filtroFormKey.currentState!
                                          .save();
                                      controller.pecasPopUp.clear();
                                      await controller.buscarPecas();
                                      controller.filtroFormKey.currentState!
                                          .reset();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Obx(
                                  () => !controller.carregandoPecas.value
                                      ? Expanded(
                                          flex: 3,
                                          child: ButtonComponent(
                                            color: secundaryColor,
                                            colorHover: secundaryColorHover,
                                            icon: Icon(Icons.search,
                                                color: Colors.white),
                                            onPressed: () async {
                                              controller
                                                  .filtroFormKey.currentState!
                                                  .save();
                                              controller.pecasPopUp.clear();
                                              await controller.buscarPecas();
                                              controller
                                                  .filtroFormKey.currentState!
                                                  .reset();
                                            },
                                            text: 'Pesquisar',
                                          ),
                                        )
                                      : Expanded(
                                          flex: 3,
                                          child: LoadingComponent(),
                                        ),
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
                                  controller.pecasBusca.length,
                              onChanged: (bool value) {
                                setState(() {
                                  controller.marcarTodosCheckbox(value);
                                });
                              },
                            ),
                            Expanded(
                              child: const TextComponent(
                                'ID Peça',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: const TextComponent(
                                'Nome da Peça',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: const TextComponent(
                                'ID Fornecedor',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: const TextComponent(
                                'Nome Fornecedor',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => !controller.carregandoPecas.value
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: controller.pecasPopUp.length,
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
                                    child: Row(
                                      children: [
                                        CheckboxComponent(
                                            value: controller
                                                .pecasPopUp[index].marcado!,
                                            onChanged: (bool value) => {
                                                  setState(() {
                                                    controller.marcarCheckbox(
                                                        index, value);
                                                  })
                                                }),
                                        Expanded(
                                          child: TextComponent(controller
                                                  .pecasPopUp[index]
                                                  .peca!
                                                  .id_peca
                                                  ?.toString() ??
                                              ''),
                                        ),
                                        Expanded(
                                          child: TextComponent(controller
                                                  .pecasPopUp[index]
                                                  .peca
                                                  ?.descricao
                                                  .toString() ??
                                              ''),
                                        ),
                                        Expanded(
                                          child: TextComponent(controller
                                                      .pecasPopUp[index]
                                                      .peca
                                                      ?.produto !=
                                                  null
                                              ? controller
                                                  .pecasPopUp[index]
                                                  .peca!
                                                  .produto!
                                                  .fornecedores!
                                                  .first
                                                  .idFornecedor
                                                  .toString()
                                              : controller
                                                          .pecasPopUp[index]
                                                          .peca!
                                                          .produtoPeca
                                                          ?.isEmpty ==
                                                      true
                                                  ? '-'
                                                  : controller
                                                      .pecasPopUp[index]
                                                      .peca!
                                                      .produtoPeca!
                                                      .first
                                                      .produto!
                                                      .fornecedores!
                                                      .first
                                                      .idFornecedor
                                                      .toString()),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            controller.pecasPopUp[index].peca
                                                        ?.produto !=
                                                    null
                                                ? controller
                                                    .pecasPopUp[index]
                                                    .peca!
                                                    .produto!
                                                    .fornecedores!
                                                    .first
                                                    .cliente!
                                                    .nome
                                                    .toString()
                                                : controller
                                                            .pecasPopUp[index]
                                                            .peca!
                                                            .produtoPeca
                                                            ?.isEmpty ==
                                                        true
                                                    ? '-'
                                                    : controller
                                                        .pecasPopUp[index]
                                                        .peca!
                                                        .produtoPeca!
                                                        .first
                                                        .produto!
                                                        .fornecedores!
                                                        .first
                                                        .cliente!
                                                        .nome
                                                        .toString(),
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
                            () => !controller.carregandoPecas.value
                                ? TextComponent(
                                    'Total de Peças selecionadas: ${controller.marcados}')
                                : LoadingComponent(),
                          ),
                          Row(
                            children: [
                              ButtonComponent(
                                  color: vermelhoColor,
                                  colorHover: vermelhoColorHover,
                                  onPressed: () {
                                    Get.back();
                                    controller.pecasPopUp.clear();
                                  },
                                  text: 'Cancelar'),
                              const SizedBox(
                                width: 12,
                              ),
                              ButtonComponent(
                                  color: secundaryColor,
                                  colorHover: secundaryColorHover,
                                  onPressed: () {
                                    controller.adicionarPecasParaEntrada();
                                    controller.pecasPopUp.clear();
                                  },
                                  text: 'Adicionar')
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
