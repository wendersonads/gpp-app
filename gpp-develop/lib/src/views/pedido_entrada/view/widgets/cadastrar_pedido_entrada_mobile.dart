// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/CheckboxComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/CurrencyPtBrInputFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/entrada/controller/cadastrar_pedido_entrada_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class CadastrarPedidoEntradaMobile extends StatelessWidget {
  CadastrarPedidoEntradaMobile({Key? key}) : super(key: key);

  final controller = Get.put(CadastrarPedidoEntradaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: new ScrollController(),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.edit,
                            size: 32,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const TitleComponent('Criar Ordem de Entrada'),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 18)),
                        Obx(
                          () => !controller.carregandoFornecedor.value
                              ? Flexible(
                                  flex: 2,
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
                                          contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
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
                                    width: 135,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextFormField(
                                      controller: controller.controllerNomeFornecedor,
                                      enabled: false,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Fornecedor',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(flex: 3, child: LoadingComponent()),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        Column(
                          children: [
                            ButtonComponent(
                              onPressed: () {
                                if (controller.fornecedorController.fornecedorModel.idFornecedor != null) {
                                  exibirPecas(context);
                                } else {
                                  Notificacao.snackBar("Informe um fornecedor antes de adicionar as peças");
                                }
                              },
                              text: 'Adicionar Peça',
                              color: primaryColor,
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(left: 18)),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
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
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 18, left: 18),
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                          color: Colors.grey.shade200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: const TextComponent(
                                  'ID Peça',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Expanded(
                              //   // flex: 3,
                              //   child: const TextComponent(
                              //     'Descrição Peça',
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              Expanded(
                                child: const TextComponent(
                                  'Qtd. Necessária',
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
                                    itemCount: controller.listaItemPedido.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(left: 18, right: 18),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(color: Colors.grey.shade100),
                                                left: BorderSide(color: Colors.grey.shade100),
                                                bottom: BorderSide(color: Colors.grey.shade100),
                                                right: BorderSide(color: Colors.grey.shade100))),
                                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: TextComponent(
                                                  controller.listaItemPedido[index].peca!.id_peca.toString(),
                                                ),
                                              ),
                                            ),
                                            // Expanded(
                                            //   flex: 1,
                                            //   child: TextComponent(
                                            //     controller
                                            //         .listaItemPedido[index]
                                            //         .peca!
                                            //         .descricao
                                            //         .toString(),
                                            //   ),
                                            // ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: 'Qtd',
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                                                  ),
                                                  onChanged: (value) {
                                                    if (value == '') {
                                                      controller.listaItemPedido[index].quantidade = null;
                                                    } else {
                                                      controller.listaItemPedido[index].quantidade = int.parse(value);
                                                      controller.listaItemPedido[index].custo = 0.00;
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            const Padding(padding: EdgeInsets.only(left: 5)),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.digitsOnly,
                                                    CurrencyPtBrInputFormatter()
                                                  ],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: '0,00',
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                                                    prefixText: 'R\$ ',
                                                  ),
                                                  onChanged: (value) {
                                                    if (value == '') {
                                                      controller.listaItemPedido[index].custo = 0;
                                                    } else {
                                                      controller.listaItemPedido[index].custo =
                                                          (double.parse(value.replaceAll('.', '').replaceAll(',', '.')));
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: IconButton(
                                                    tooltip: 'Excluir Item',
                                                    icon: Icon(
                                                      Icons.delete_outlined,
                                                      color: Colors.grey.shade400,
                                                    ),
                                                    onPressed: () {
                                                      controller.removerPecasEntrada(controller.listaItemPedido[index]);
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
                                )
                              : Container(
                                  height: 450,
                                  child: LoadingComponent(),
                                ),
                        ),
                      ],
                    ),
                    Obx(
                      () => !controller.carregandoEntrada.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Padding(padding: EdgeInsets.only(left: 5)),
                                Container(
                                  child: ButtonComponent(
                                    onPressed: () async {
                                      controller.context = context;
                                      bool valida = await controller.CriarPedidoEntrada();
                                    },
                                    text: 'Criar Ordem de Entrada',
                                    color: primaryColor,
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.only(right: 20)),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const LoadingComponent(),
                                const Padding(padding: EdgeInsets.only(right: 20)),
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
                    const TextComponent('Peças para criar ordem de entrada', fontSize: 12),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const TextComponent(
                              'Selecione uma ou mais Peças',
                              letterSpacing: 0.25,
                              fontSize: 15,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Form(
                          key: controller.filtroFormKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: InputComponent(
                                      controller: controller.controllerIdProduto,
                                      onSaved: (value) {
                                        controller.controllerIdProduto.text = value;
                                      },
                                      hintText: 'ID Produto',
                                      onFieldSubmitted: (value) async {
                                        controller.filtroFormKey.currentState!.save();

                                        controller.pecasPopUp.clear();
                                        await controller.buscarPecas();
                                        controller.filtroFormKey.currentState!.reset();
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: InputComponent(
                                      controller: controller.controllerIdPeca,
                                      onSaved: (value) {
                                        controller.controllerIdPeca.text = value;
                                      },
                                      hintText: 'ID Peças',
                                      onFieldSubmitted: (value) async {
                                        controller.filtroFormKey.currentState!.save();
                                        controller.pecasPopUp.clear();
                                        await controller.buscarPecas();
                                        controller.filtroFormKey.currentState!.reset();
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => !controller.carregandoPecas.value
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ButtonComponent(
                                      color: secundaryColor,
                                      colorHover: secundaryColorHover,
                                      icon: Icon(Icons.search, color: Colors.white),
                                      onPressed: () async {
                                        controller.filtroFormKey.currentState!.save();
                                        controller.pecasPopUp.clear();
                                        await controller.buscarPecas();
                                        controller.filtroFormKey.currentState!.reset();
                                      },
                                      text: 'Pesquisar',
                                    ),
                                  ],
                                )
                              : Expanded(
                                  child: LoadingComponent(),
                                ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          color: Colors.grey.shade200,
                          child: Row(
                            children: [
                              CheckboxComponent(
                                value: controller.marcados == controller.pecasBusca.length,
                                onChanged: (bool value) {
                                  setState(() {
                                    controller.marcarTodosCheckbox(value);
                                  });
                                },
                              ),
                              Expanded(
                                child: const TextComponent('ID Peça', fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: const TextComponent('Nome da Peça', fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Obx(() => !controller.carregandoPecas.value
                            ? Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.pecasPopUp.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: Row(
                                        children: [
                                          CheckboxComponent(
                                              value: controller.pecasPopUp[index].marcado!,
                                              onChanged: (bool value) => {
                                                    setState(() {
                                                      controller.marcarCheckbox(index, value);
                                                    })
                                                  }),
                                          Expanded(
                                            child: TextComponent(controller.pecasPopUp[index].peca!.id_peca?.toString() ?? ''),
                                          ),
                                          Expanded(
                                            child: TextComponent(controller.pecasPopUp[index].peca?.descricao.toString() ?? ''),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Expanded(child: Center(child: LoadingComponent()))),
                        const Divider(),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Obx(
                              () => !controller.carregandoPecas.value
                                  ? Container(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: TextComponent('Total de Peças selecionadas: ${controller.marcados}'))
                                  : LoadingComponent(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  width: 8,
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
                        ),
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
