import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/box_enderecamento_model.dart';
import 'package:gpp/src/models/corredor_enderecamento_model.dart';
import 'package:gpp/src/models/estante_enderecamento_model.dart';
import 'package:gpp/src/models/piso_enderecamento_model.dart';
import 'package:gpp/src/models/prateleira_enderecamento_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/DropdownButtonFormFieldComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/ImprimirQrCodeBox.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/estoque/controllers/estoque_controller.dart';
import 'package:gpp/src/views/estoque/controllers/estoque_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class EstoqueViewMobile extends StatelessWidget {
  const EstoqueViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double? FONTEBASE = 18;
    final controller = Get.put(EstoqueController());
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavbarWidget(),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextComponent(
                        Get.currentRoute == '/estoques'
                            ? 'Estoque'
                            : 'Endereçamento',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 2,
                          child: InputComponent(
                            prefixIcon: Icon(
                              Icons.search,
                            ),
                            hintText: 'Buscar',
                            onChanged: (value) => controller.buscar = value,
                            onFieldSubmitted: (value) {
                              controller.buscarPecaEstoques();
                            },
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 1,
                        child: ButtonComponent(
                            icon: Icon(Icons.tune_rounded, color: Colors.white),
                            onPressed: () async {
                              controller.filtro(!controller.filtro.value);
                              await controller.buscarPisos();
                            },
                            text: 'Filtro'),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: !controller.filtro.value ? 0 : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: GetBuilder<EstoqueController>(
                      builder: (_) => Form(
                        key: controller.formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Obx(
                                  () => !controller.carregandoPisos.value
                                      ? Expanded(
                                          child: Container(
                                            child:
                                                DropdownButtonFormFieldComponent(
                                              label: 'Piso',
                                              hintText: controller
                                                      .piso?.desc_piso
                                                      ?.toString() ??
                                                  'Piso...',
                                              onChanged: (value) async {
                                                controller.piso = value;
                                                controller.corredor =
                                                    CorredorEnderecamentoModel();

                                                await controller.buscarCorredor(
                                                    value.id_piso!);
                                              },
                                              items: controller.pisos.map<
                                                      DropdownMenuItem<
                                                          PisoEnderecamentoModel>>(
                                                  (PisoEnderecamentoModel
                                                      value) {
                                                return DropdownMenuItem<
                                                    PisoEnderecamentoModel>(
                                                  value: value,
                                                  child: TextComponent(
                                                      value.desc_piso!),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Obx(
                                  () => !controller.carregandoCorredores.value
                                      ? Expanded(
                                          child: Container(
                                            child:
                                                DropdownButtonFormFieldComponent(
                                              label: 'Corredor',
                                              hintText: controller
                                                      .corredor!.desc_corredor
                                                      ?.toString() ??
                                                  'Corredor...',
                                              onChanged:
                                                  (CorredorEnderecamentoModel
                                                      value) async {
                                                controller.prateleira =
                                                    PrateleiraEnderecamentoModel();
                                                controller.corredor = value;
                                                await controller.buscarEstantes(
                                                    value.id_corredor!);
                                              },
                                              items: controller.corredores.map<
                                                      DropdownMenuItem<
                                                          CorredorEnderecamentoModel>>(
                                                  (CorredorEnderecamentoModel
                                                      value) {
                                                return DropdownMenuItem<
                                                    CorredorEnderecamentoModel>(
                                                  value: value,
                                                  child: TextComponent(
                                                      value.desc_corredor!),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Obx(
                                  () => !controller.carregandoEstantes.value
                                      ? Expanded(
                                          child: Container(
                                            child:
                                                DropdownButtonFormFieldComponent(
                                              label: 'Estante',
                                              hintText: controller
                                                      .estante!.desc_estante
                                                      ?.toString() ??
                                                  'Estante...',
                                              onChanged:
                                                  (EstanteEnderecamentoModel
                                                      value) async {
                                                controller.estante = value;
                                                await controller
                                                    .buscarPrateleiras(
                                                        value.id_estante!);
                                              },
                                              items: controller.estantes.map<
                                                      DropdownMenuItem<
                                                          EstanteEnderecamentoModel>>(
                                                  (EstanteEnderecamentoModel
                                                      value) {
                                                return DropdownMenuItem<
                                                    EstanteEnderecamentoModel>(
                                                  value: value,
                                                  child: TextComponent(
                                                      value.desc_estante!),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Obx(
                                  () => !controller.carregandoPrateleira.value
                                      ? Expanded(
                                          child: Container(
                                            child:
                                                DropdownButtonFormFieldComponent(
                                              label: 'Prateleira',
                                              hintText: controller.prateleira!
                                                      .desc_prateleira
                                                      ?.toString() ??
                                                  'Prateleira...',
                                              onChanged:
                                                  (PrateleiraEnderecamentoModel
                                                      value) async {
                                                controller.prateleira = value;
                                                await controller.buscarBoxs(
                                                    value.id_prateleira!);
                                              },
                                              items: controller.prateleiras.map<
                                                      DropdownMenuItem<
                                                          PrateleiraEnderecamentoModel>>(
                                                  (PrateleiraEnderecamentoModel
                                                      value) {
                                                return DropdownMenuItem<
                                                    PrateleiraEnderecamentoModel>(
                                                  value: value,
                                                  child: TextComponent(
                                                      value.desc_prateleira!),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Obx(
                                  () => !controller.carregandoBoxs.value
                                      ? Expanded(
                                          child: Container(
                                            child:
                                                DropdownButtonFormFieldComponent(
                                              label: 'Box',
                                              hintText: controller.box!.desc_box
                                                      ?.toString() ??
                                                  'Box...',
                                              onChanged: (BoxEnderecamentoModel
                                                  value) async {
                                                controller.endereco =
                                                    value.id_box.toString();
                                                controller.box = value;
                                              },
                                              items: controller.boxs.map<
                                                      DropdownMenuItem<
                                                          BoxEnderecamentoModel>>(
                                                  (BoxEnderecamentoModel
                                                      value) {
                                                return DropdownMenuItem<
                                                    BoxEnderecamentoModel>(
                                                  value: value,
                                                  child: TextComponent(
                                                      value.desc_box!),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonComponent(
                            color: vermelhoColor,
                            colorHover: vermelhoColorHover,
                            onPressed: () async {
                              controller.limparFiltro();
                            },
                            text: 'Limpar'),
                        SizedBox(
                          width: 8,
                        ),
                        ButtonComponent(
                            onPressed: () async {
                              controller.filtro(false);
                              await controller.buscarPecaEstoques();
                            },
                            text: 'Pesquisar')
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => !controller.carregando.value
                    ? Container(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: controller.pecaEstoques.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: secundaryColor, width: 3)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    ((controller.pecaEstoques[index].peca
                                                    ?.descricao?.length ??
                                                0) >=
                                            22)
                                        ? Row(
                                            children: [
                                              Row(
                                                children: [
                                                  TextComponent(
                                                    'ID: ',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: FONTEBASE,
                                                  ),
                                                  TextComponent(
                                                    controller
                                                            .pecaEstoques[index]
                                                            .peca
                                                            ?.id_peca
                                                            .toString()
                                                            .capitalize ??
                                                        '',
                                                    fontSize: FONTEBASE,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Flexible(
                                                child: Row(
                                                  children: [
                                                    TextComponent(
                                                      'Descrição: ',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: FONTEBASE,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        controller
                                                                .pecaEstoques[
                                                                    index]
                                                                .peca
                                                                ?.descricao
                                                                .toString()
                                                                .capitalize ??
                                                            '',
                                                        style: TextStyle(
                                                            fontSize: FONTEBASE,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Row(
                                                children: [
                                                  TextComponent(
                                                    'ID: ',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: FONTEBASE,
                                                  ),
                                                  TextComponent(
                                                    controller
                                                            .pecaEstoques[index]
                                                            .peca
                                                            ?.id_peca
                                                            .toString()
                                                            .capitalize ??
                                                        '',
                                                    fontSize: FONTEBASE,
                                                  ),
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
                                                    controller
                                                            .pecaEstoques[index]
                                                            .peca
                                                            ?.descricao
                                                            .toString()
                                                            .capitalize ??
                                                        '',
                                                    style: TextStyle(
                                                        fontSize: FONTEBASE),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.delete<
                                                  EstoqueDetalheController>();
                                              Get.toNamed(
                                                  '/estoques/${controller.pecaEstoques[index].id_peca_estoque}');
                                            },
                                            child: Container(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  color: Colors.purpleAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                child: Icon(
                                                  Icons.sync_rounded,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (controller.pecaEstoques[index]
                                                      .id_box ==
                                                  null) {
                                                Notificacao.snackBar(
                                                    'Erro ao realizar a impressão da etiqueta de QR Code, este estoque não possui endereçamento');
                                              }
                                              if (controller.pecaEstoques[index]
                                                      .id_box !=
                                                  null) {
                                                await ImprimirQrCodeBox(
                                                        pecaEstoque: controller
                                                                .pecaEstoques[
                                                            index])
                                                    .imprimirQrCode();
                                              }
                                              if (controller
                                                  .pecaEstoques[index].endereco!
                                                  .contains('Box Saída')) {
                                                Notificacao.snackBar(
                                                    'Não é possivel realizar a impressão de um Box de Saída');
                                              }
                                              if (controller
                                                  .pecaEstoques[index].endereco!
                                                  .contains('Box Entrada')) {
                                                Notificacao.snackBar(
                                                    'Não é possivel realizar a impressão de um Box de Entrada');
                                              }
                                            },
                                            child: Container(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                child: Icon(
                                                  Icons.qr_code_rounded,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.offAllNamed(
                                                  '/estoque-ajuste/${controller.pecaEstoques[index].id_peca_estoque}');
                                            },
                                            child: Container(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  color: Colors.blueAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                child: Icon(
                                                  Icons.edit_rounded,
                                                  color: Colors.white,
                                                  size: 20,
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
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                        ),
                      )
                    : LoadingComponent(),
              ),
            ),
            Container(
              child: GetBuilder<EstoqueController>(
                builder: (_) => PaginacaoComponent(
                  total: controller.pagina.getTotal(),
                  atual: controller.pagina.getAtual(),
                  primeiraPagina: () {
                    controller.pagina.primeira();
                    controller.buscarPecaEstoques();
                  },
                  anteriorPagina: () {
                    controller.pagina.anterior();
                    controller.buscarPecaEstoques();
                  },
                  proximaPagina: () {
                    controller.pagina.proxima();
                    controller.buscarPecaEstoques();
                  },
                  ultimaPagina: () {
                    controller.pagina.ultima();
                    controller.buscarPecaEstoques();
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
