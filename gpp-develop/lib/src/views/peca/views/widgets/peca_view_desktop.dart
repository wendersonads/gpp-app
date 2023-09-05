import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/enumeration/estoque_enum.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/ImprimirQrCodePeca.dart';
import 'package:gpp/src/views/peca/controller/peca_controller.dart';
import 'package:gpp/src/views/peca/controller/peca_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

import '../../../../shared/components/TextComponent.dart';
import '../../../../shared/components/TitleComponent.dart';

class PecaViewDesktop extends StatelessWidget {
  const PecaViewDesktop({Key? key}) : super(key: key);

  verificarEstoque(EstoqueEnum value) {
    switch (value) {
      case EstoqueEnum.ESTOQUE_REGULAR:
        return Container(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextComponent(
              'Estoque regular',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case EstoqueEnum.ESTOQUE_MINIMO:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextComponent(
              'Estoque mínimo',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case EstoqueEnum.SEM_ESTOQUE:
        return Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextComponent(
              'Sem estoque atribuído',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  getQrCode(data, PecasModel peca) {
    Get.dialog(
      AlertDialog(
        content: Container(
          height: Get.height * .5,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: data,
                  width: 200,
                  height: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ID Peça: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(peca.id_peca.toString()),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonComponent(
                        color: vermelhoColor,
                        colorHover: vermelhoColorHover,
                        onPressed: () {
                          Get.back();
                        },
                        text: 'Cancelar',
                      ),
                      Padding(padding: EdgeInsets.only(right: 8)),
                      ButtonComponent(
                        onPressed: () async {
                          await ImprimirQrCodePeca(peca: peca).imprimirQrCode();
                        },
                        text: 'Imprimir',
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PecaController());

    return Scaffold(
      appBar: NavbarWidget(),
      body: Row(
        children: [
          Expanded(child: Sidebar()),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Expanded(child: TitleComponent('Peças')),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                  child: InputComponent(
                                hintText: 'Buscar',
                                onFieldSubmitted: (value) async {
                                  controller.buscar = value;
                                  await controller.buscarPecas();
                                },
                              )),
                              SizedBox(
                                width: 8,
                              ),
                              ButtonComponent(
                                  icon: Icon(Icons.tune_rounded, color: Colors.white),
                                  onPressed: () async {
                                    controller.filtro(!controller.filtro.value);
                                  },
                                  text: 'Adicionar filtro')
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(
                    () => AnimatedContainer(
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      duration: Duration(milliseconds: 500),
                      height: controller.filtro.value ? null : 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Form(
                                key: controller.formKey,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InputComponent(
                                        label: 'Código do produto',
                                        hintText: 'Digite o código do produto',
                                        onSaved: (value) {
                                          controller.idProduto = value;
                                        },
                                        onFieldSubmitted: (value) async {
                                          controller.idProduto = value;
                                          await controller.buscarPecas();
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ButtonComponent(
                                      color: vermelhoColor,
                                      colorHover: vermelhoColorHover,
                                      onPressed: () async {
                                        controller.formKey.currentState!.reset();
                                      },
                                      text: 'Limpar'),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  ButtonComponent(
                                      onPressed: () async {
                                        controller.filtro(false);
                                        controller.formKey.currentState!.save();
                                        await controller.buscarPecas();
                                      },
                                      text: 'Pesquisar')
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        child: Obx(() => !controller.carregando.value
                            ? ListView.builder(
                                itemCount: controller.pecas.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: CardWidget(
                                      widget: Column(
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
                                                    'Descrição',
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Expanded(
                                                  flex: 2,
                                                  child: TextComponent(
                                                    'Comprimento',
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Expanded(
                                                  child: TextComponent(
                                                'Altura',
                                                fontWeight: FontWeight.bold,
                                              )),
                                              Expanded(
                                                  child: TextComponent(
                                                'Largura',
                                                fontWeight: FontWeight.bold,
                                              )),
                                              Expanded(
                                                  child: TextComponent(
                                                'Cor',
                                                fontWeight: FontWeight.bold,
                                              )),
                                              Expanded(
                                                  flex: 2,
                                                  child: TextComponent(
                                                    'Produto',
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Expanded(
                                                  flex: 3,
                                                  child: TextComponent(
                                                    'Fornecedor',
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Expanded(
                                                  flex: 3,
                                                  child: TextComponent(
                                                    'Estoque',
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Expanded(
                                                  flex: 2,
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
                                              Expanded(child: SelectableText('# ${controller.pecas[index].id_peca}')),
                                              Expanded(
                                                  flex: 2,
                                                  child: SelectableText(
                                                      '${controller.pecas[index].descricao.toString().capitalize}')),
                                              Expanded(
                                                  flex: 2,
                                                  child: SelectableText('${controller.pecas[index].profundidade ?? ''}')),
                                              Expanded(child: SelectableText('${controller.pecas[index].altura ?? ''}')),
                                              Expanded(child: SelectableText('${controller.pecas[index].largura ?? ''}')),
                                              Expanded(child: SelectableText('${controller.pecas[index].cor ?? ''}')),
                                              Expanded(
                                                  flex: 2,
                                                  child: SelectableText(
                                                      '${controller.pecas[index].produtoPeca!.length != 0 ? controller.pecas[index].produtoPeca?.first.produto?.resumida.toString().capitalize ?? '' : 'Essa peça não está vinculada a nenhum produto'}')),
                                              Expanded(
                                                  flex: 3,
                                                  child: SelectableText(
                                                      '${controller.pecas[index].produtoPeca!.length != 0 ? controller.pecas[index].produtoPeca?.first.produto?.fornecedores!.first.cliente?.nome.toString().capitalize ?? '' : 'Essa peça não está vinculada a nenhum fornecedor'}')),
                                              Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    padding: EdgeInsets.only(right: 8),
                                                    child: verificarEstoque(controller.verificarEstoque(controller.pecas[index])),
                                                  )),
                                              Expanded(
                                                flex: 2,
                                                child: ButtonAcaoWidget(
                                                  detalhe: () {
                                                    Get.delete<PecaDetalheController>();
                                                    Get.toNamed('/pecas-consultar/' + controller.pecas[index].id_peca.toString());

                                                    // Get.keys[1]!.currentState!
                                                    //     .pushNamed('/pecas/${controller.pecas[index].id_peca}');
                                                  },
                                                  editar: () {
                                                    Get.delete<PecaDetalheController>();
                                                    Get.toNamed('/pecas-editar/' + controller.pecas[index].id_peca.toString());
                                                    // Get.keys[1]!.currentState!
                                                    //     .pushNamed('/pecas/${controller.pecas[index].id_peca}/editar');
                                                  },
                                                  qrCode: () {
                                                    getQrCode(
                                                        controller.pecas[index].id_peca.toString(), controller.pecas[index]);
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : LoadingComponent())),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                    child: GetBuilder<PecaController>(
                      builder: (_) => PaginacaoComponent(
                        total: controller.pagina.getTotal(),
                        atual: controller.pagina.getAtual(),
                        primeiraPagina: () {
                          controller.pagina.primeira();
                          controller.buscarPecas();
                        },
                        anteriorPagina: () {
                          controller.pagina.anterior();
                          controller.buscarPecas();
                        },
                        proximaPagina: () {
                          controller.pagina.proxima();
                          controller.buscarPecas();
                        },
                        ultimaPagina: () {
                          controller.pagina.ultima();
                          controller.buscarPecas();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
