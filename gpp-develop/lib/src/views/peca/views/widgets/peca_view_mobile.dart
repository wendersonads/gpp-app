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
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

import '../../../../shared/components/TextComponent.dart';
import '../../../../shared/components/TitleComponent.dart';

class PecaViewMobile extends StatelessWidget {
  const PecaViewMobile({Key? key}) : super(key: key);

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
              fontSize: 18,
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
              fontSize: 18,
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
              fontSize: 18,
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
          height: Get.height * .6,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: data,
                  width: 220,
                  height: 220,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ID Peça: ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      peca.id_peca.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      ButtonComponent(
                          color: vermelhoColor,
                          colorHover: vermelhoColorHover,
                          onPressed: () {
                            Get.back();
                          },
                          text: 'Cancelar'),
                      SizedBox(height: 7),
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
    final double FONTEBASE = 18;

    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  TextComponent(
                    'Peças',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InputComponent(
                    hintText: 'Buscar',
                    onFieldSubmitted: (value) async {
                      controller.buscar = value;
                      await controller.buscarPecas();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width / 2,
                    child: ButtonComponent(
                        icon: Icon(Icons.tune_rounded, color: Colors.white),
                        onPressed: () async {
                          controller.filtro(!controller.filtro.value);
                        },
                        text: 'Adicionar filtro'),
                  )
                ],
              ),
            ),
            Obx(
              () => AnimatedContainer(
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(vertical: 16),
                duration: Duration(milliseconds: 500),
                height: controller.filtro.value ? null : 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              InputComponent(
                                label: 'Código do produto',
                                hintText: 'Digite o código do produto',
                                onFieldSubmitted: (value) async {
                                  controller.buscar = value;
                                  await controller.buscarPecas();
                                },
                              ),
                              Container()
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ButtonComponent(
                                color: vermelhoColor,
                                colorHover: vermelhoColorHover,
                                onPressed: () async {
                                  controller.formKey.currentState!.reset();
                                },
                                text: 'Limpar'),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: ButtonComponent(
                                onPressed: () async {
                                  controller.filtro(false);
                                  controller.formKey.currentState!.save();
                                  await controller.buscarPecas();
                                },
                                text: 'Pesquisar'),
                          )
                        ],
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
                                widget: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      !(controller.pecas[index].descricao!.length >= 13)
                                          ? Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    TextComponent(
                                                      'ID: ',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: FONTEBASE,
                                                    ),
                                                    Text(
                                                      '# ${controller.pecas[index].id_peca}',
                                                      style: TextStyle(fontSize: FONTEBASE),
                                                    )
                                                  ],
                                                ),
                                                Expanded(child: SizedBox()),
                                                Row(
                                                  children: [
                                                    TextComponent(
                                                      'Descrição: ',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: FONTEBASE,
                                                    ),
                                                    Text(
                                                      '${controller.pecas[index].descricao.toString().capitalize}',
                                                      style: TextStyle(fontSize: FONTEBASE),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    TextComponent(
                                                      'ID: ',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: FONTEBASE,
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        '# ${controller.pecas[index].id_peca}',
                                                        style: TextStyle(fontSize: FONTEBASE),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Row(
                                                  children: [
                                                    TextComponent(
                                                      'Descrição: ',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: FONTEBASE,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${controller.pecas[index].descricao.toString().capitalize}',
                                                        style: TextStyle(fontSize: FONTEBASE),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Container(
                                        child: verificarEstoque(controller.verificarEstoque(controller.pecas[index])),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                getQrCode(controller.pecas[index].id_peca.toString(), controller.pecas[index]);
                                              },
                                              child: Container(
                                                decoration:
                                                    BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(5)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 12),
                                                  child: Icon(
                                                    Icons.qr_code_rounded,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.delete<PecaDetalheController>();
                                                Get.toNamed('/pecas-consultar/' + controller.pecas[index].id_peca.toString());
                                              },
                                              child: Container(
                                                decoration:
                                                    BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 12),
                                                  child: Icon(
                                                    Icons.visibility_rounded,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.delete<PecaDetalheController>();
                                                Get.toNamed('/pecas-editar/' + controller.pecas[index].id_peca.toString());
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 12),
                                                  child: Icon(
                                                    Icons.edit_rounded,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
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
    );
  }
}
