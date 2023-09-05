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

class CadastrarPedidoEntradaDesktop extends StatelessWidget {
  CadastrarPedidoEntradaDesktop({Key? key}) : super(key: key);

  final controller = Get.put(CadastrarPedidoEntradaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Sidebar(),
          Expanded(
            child: SingleChildScrollView(
              controller: new ScrollController(),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                        const Padding(padding: EdgeInsets.only(right: 30)),
                        Flexible(
                          flex: 1,
                          child: ButtonComponent(
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
                        ),
                        const Padding(padding: EdgeInsets.only(left: 5)),
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
                          margin: EdgeInsets.only(right: 18),
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                          color: Colors.grey.shade200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextComponent(
                                  'ID Peça',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TextComponent(
                                  'Descrição Peça',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: TextComponent(
                                  'Qtd. Necessária',
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: TextComponent(
                                  'Valor Unitário',
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: TextComponent(
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
                                        margin: EdgeInsets.only(right: 18),
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
                                              child: TextComponent(
                                                controller.listaItemPedido[index].peca!.id_peca.toString(),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: TextComponent(
                                                controller.listaItemPedido[index].peca!.descricao.toString(),
                                              ),
                                            ),
                                            Expanded(
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
                    const TitleComponent('Peças para criar ordem de entrada'),
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
                            TextComponent(
                              'Selecione uma ou mais Peças para ordem de entrada',
                              letterSpacing: 0.15,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     vertical: 8.0,
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       const SizedBox.shrink(),
                      //       ButtonComponent(
                      //         color: secundaryColor,
                      //         colorHover: secundaryColorHover,
                      //         icon: Icon(Icons.tune_rounded, color: Colors.white),
                      //         onPressed: () {
                      //           setState(() {
                      //             controller.abrirFiltro(controller.abrirFiltro.value == true ? false : true);
                      //           });
                      //         },
                      //         text: 'Adicionar filtro',
                      //       )
                      //     ],
                      //   ),
                      // ),
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
                                  flex: 5,
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
                                  width: 8,
                                ),
                                Obx(
                                  () => !controller.carregandoPecas.value
                                      ? Expanded(
                                          flex: 3,
                                          child: ButtonComponent(
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
                              child: TextComponent('ID Peça', fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: TextComponent('Nome da Peça', fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: TextComponent('ID Fornecedor', fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: TextComponent('Nome Fornecedor', fontWeight: FontWeight.bold),
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
                                            top: BorderSide(color: Colors.grey.shade100),
                                            left: BorderSide(color: Colors.grey.shade100),
                                            bottom: BorderSide(color: Colors.grey.shade100),
                                            right: BorderSide(color: Colors.grey.shade100))),
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
                                        Expanded(
                                          child: TextComponent(controller.pecasPopUp[index].peca?.produto != null
                                              ? controller.pecasPopUp[index].peca!.produto!.fornecedores!.first.idFornecedor
                                                  .toString()
                                              : controller.pecasPopUp[index].peca!.produtoPeca?.isEmpty == true
                                                  ? '-'
                                                  : controller.pecasPopUp[index].peca!.produtoPeca!.first.produto!.fornecedores!
                                                      .first.idFornecedor
                                                      .toString()),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            controller.pecasPopUp[index].peca?.produto != null
                                                ? controller.pecasPopUp[index].peca!.produto!.fornecedores!.first.cliente!.nome
                                                    .toString()
                                                : controller.pecasPopUp[index].peca!.produtoPeca?.isEmpty == true
                                                    ? '-'
                                                    : controller.pecasPopUp[index].peca!.produtoPeca!.first.produto!.fornecedores!
                                                        .first.cliente!.nome
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
                                ? TextComponent('Total de Peças selecionadas: ${controller.marcados}')
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
