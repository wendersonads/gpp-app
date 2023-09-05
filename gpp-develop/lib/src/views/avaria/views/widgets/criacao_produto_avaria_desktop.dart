import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/views/avaria/views/controller/produto_avaria_controller.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
//import 'package:gpp/src/enums/categoria_de_imagens_enum.dart';
import 'package:gpp/src/enums/categoria_imagens_avaria_enum.dart';
import 'package:gpp/src/utils/notificacao.dart';

class CriacaoProdutoAvariaDesktop extends StatelessWidget {
  final controller = Get.put(ProdutoAvariaController());
  XFile? comprovante;
  final controllerAvaria = Get.find<ProdutoAvariaController>();
  final isPlaying = false.obs;

  Widget _politicaAvaria(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(
            Icons.info_outlined,
            size: 25,
            color: Color.fromRGBO(77, 196, 235, 1),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(77, 196, 235, 1),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: Offset(1, 1),
                      blurRadius: 2),
                ]),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Text(
                'Acesse a política de produtos avariados',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuAvaria(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            top: 16,
            //left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(
            bottom: 16,
          ),
          child: Text(
            'Cadastro de Avaria',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _politicaAvaria(context),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: InputComponent(
                hintText: 'ex: 0000',
                controller: controller.idProdutoSKU,
                label: 'ID Produto/SKU',
                keyboardType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (controller.validaFormulario(value)) {
                    return 'Informe o ID Produto/SKU';
                  }
                  return null;
                },
                onSaved: (idProduto) {
                  controller.criacaoAvaria.update((value) {
                    value!.idProduto = int.parse(idProduto);
                  });
                },
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: InputComponent(
                hintText: controller.criacaoAvaria.value.idFilial.toString(),
                enable: false,
                label: 'Filial Origem',
                keyboardType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  margin: EdgeInsets.only(
                    bottom: 10,
                    right: 8,
                  ),
                  child: TextFormField(
                    enabled: false,
                    // controller: controller.idCor,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0',
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Column(
            //   children: [
            //     Container(
            //       width: 150,
            //       height: 55,
            //       margin: EdgeInsets.only(
            //         bottom: 10,
            //         right: 8,
            //       ),
            //       child: TextFormField(
            //         readOnly: true,
            //         style: TextStyle(
            //           color: Colors.black.withOpacity(0.1),
            //           fontSize: 14,
            //         ),
            //         keyboardType: TextInputType.number,
            //         decoration: InputDecoration(
            //           filled: true,
            //           fillColor: Colors.black.withOpacity(0.1),
            //           labelStyle: TextStyle(
            //             color: Colors.black,
            //           ),
            //           border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(5),
            //             borderSide: BorderSide.none,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 55,
                    margin: EdgeInsets.only(
                      bottom: 10,
                      right: 8,
                    ),
                    child: TextFormField(
                      controller: controller.ldOrigem,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.1),
                        labelText: 'LD Origem',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _SliderAvaria(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  'Defeito do produto',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 130, right: 20),
              child: Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Leve',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Médio',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Alto',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Grave',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Amassado:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Slider(
                            min: 0.0,
                            max: 4.0,
                            label: controller.grauAmassado.value == 0
                                ? ''
                                : controller.grauAmassado.value == 1
                                    ? 'Leve'
                                    : controller.grauAmassado.value == 2
                                        ? 'Médio'
                                        : controller.grauAmassado.value == 3
                                            ? 'Alto'
                                            : 'Grave',
                            divisions: 4,
                            value: controller.grauAmassado.value,
                            onChanged: (value) {
                              controller.grauAmassado(value);
                            },
                            activeColor: Color.fromRGBO(4, 4, 145, 1)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Arranhado:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Slider(
                            min: 0.0,
                            max: 4.0,
                            divisions: 4,
                            label: controller.grauArranhado.value == 0
                                ? ''
                                : controller.grauArranhado.value == 1
                                    ? 'Leve'
                                    : controller.grauArranhado.value == 2
                                        ? 'Médio'
                                        : controller.grauArranhado.value == 3
                                            ? 'Alto'
                                            : 'Grave',
                            value: controller.grauArranhado.value,
                            onChanged: (value) {
                              controller.grauArranhado(value);
                            },
                            activeColor: Color.fromRGBO(4, 4, 145, 1)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Quebrado:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Slider(
                            min: 0.0,
                            max: 4.0,
                            divisions: 4,
                            label: controller.grauQuebrado.value == 0
                                ? ''
                                : controller.grauQuebrado.value == 1
                                    ? 'Leve'
                                    : controller.grauQuebrado.value == 2
                                        ? 'Médio'
                                        : controller.grauQuebrado.value == 3
                                            ? 'Alto'
                                            : 'Grave',
                            value: controller.grauQuebrado.value,
                            onChanged: (value) {
                              controller.grauQuebrado(value);
                            },
                            activeColor: Color.fromRGBO(4, 4, 145, 1)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Manchado:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Slider(
                            min: 0.0,
                            max: 4.0,
                            divisions: 4,
                            label: controller.grauManchado.value == 0
                                ? ''
                                : controller.grauManchado.value == 1
                                    ? 'Leve'
                                    : controller.grauManchado.value == 2
                                        ? 'Médio'
                                        : controller.grauManchado.value == 3
                                            ? 'Alto'
                                            : 'Grave',
                            value: controller.grauManchado.value,
                            onChanged: (value) {
                              controller.grauManchado(value);
                            },
                            activeColor: Color.fromRGBO(4, 4, 145, 1)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _descricaoDefeito(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Descrição do Defeito',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            controller: controller.descricaoDefeito,
            maxLines: 5,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _anexos(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_file_outlined,
              ),
              Text(
                'Anexos',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromRGBO(46, 212, 148, 1),
                ),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
              ),
              onPressed: () {
                if (controller.grauAmassado.value == 0.0 &&
                    controller.grauArranhado == 0.0 &&
                    controller.grauManchado.value == 0.0 &&
                    controller.grauQuebrado.value == 0.0) {
                  Notificacao.snackBar('Informe o Grau de Avaria',
                      tipoNotificacao: TipoNotificacaoEnum.error);
                } else {
                  _showSelecaoMidiasAvarias(context);
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Text(
                  'Anexar Imagens',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCamposImagensAmassado(BuildContext context) {
    return Obx(
      () {
        return controller.grauAmassado.value > 0.0
            ? Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 32,
                      bottom: 20,
                    ),
                    child: Row(
                      children: [
                        TextComponent(
                          'Amassado',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 100,
                                child: controller.criacaoAvaria.value.imagens
                                            ?.length ==
                                        0
                                    ? Center(
                                        child: Text(
                                            'Selecione entre 1 a 5 imagens'),
                                      )
                                    : ListView.separated(
                                        shrinkWrap: false,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.criacaoAvaria
                                            .value.imagens!.length,
                                        separatorBuilder: (context, index) {
                                          return index == 0
                                              ? SizedBox()
                                              : SizedBox(
                                                  width: 1,
                                                );
                                        },
                                        itemBuilder: (context, index) {
                                          return controller
                                                      .criacaoAvaria
                                                      .value
                                                      .imagens![index]
                                                      .categoria ==
                                                  '1'
                                              ? Stack(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Image.network(
                                                        controller
                                                                    .criacaoAvaria
                                                                    .value
                                                                    .imagens![
                                                                        index]
                                                                    .categoria ==
                                                                '1'
                                                            ? controller
                                                                    .criacaoAvaria
                                                                    .value
                                                                    .imagens![
                                                                        index]
                                                                    .url ??
                                                                ''
                                                            : '',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      width: 48,
                                                      height: 48,
                                                      child: FittedBox(
                                                        child:
                                                            FloatingActionButton(
                                                          heroTag:
                                                              'btn_${index}_remover_imagem',
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade400,
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 24,
                                                          ),
                                                          onPressed: () {
                                                            controller
                                                                .removerImagemSelecionada(
                                                                    index);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container();
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox.shrink();
      },
    );
  }

  Widget _buildCamposImagensArranhado(BuildContext context) {
    return Obx(
      () {
        return controller.grauArranhado.value > 0.0
            ? Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 32,
                      bottom: 20,
                    ),
                    child: Row(
                      children: [
                        TextComponent(
                          'Arranhado',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 100,
                                child: controller.criacaoAvaria.value.imagens
                                            ?.length ==
                                        0
                                    ? Center(
                                        child: Text(
                                            'Selecione entre 1 a 5 imagens'),
                                      )
                                    : ListView.separated(
                                        shrinkWrap: false,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.criacaoAvaria
                                            .value.imagens!.length,
                                        separatorBuilder: (context, index) {
                                          return index == 0
                                              ? SizedBox()
                                              : SizedBox(
                                                  width: 1,
                                                );
                                        },
                                        itemBuilder: (context, index) {
                                          return controller
                                                      .criacaoAvaria
                                                      .value
                                                      .imagens![index]
                                                      .categoria ==
                                                  '2'
                                              ? Stack(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Image.network(
                                                        controller
                                                                    .criacaoAvaria
                                                                    .value
                                                                    .imagens![
                                                                        index]
                                                                    .categoria ==
                                                                '2'
                                                            ? controller
                                                                    .criacaoAvaria
                                                                    .value
                                                                    .imagens![
                                                                        index]
                                                                    .url ??
                                                                ''
                                                            : '',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      width: 48,
                                                      height: 48,
                                                      child: FittedBox(
                                                        child:
                                                            FloatingActionButton(
                                                          heroTag:
                                                              'btn_${index}_remover_imagem',
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade400,
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 24,
                                                          ),
                                                          onPressed: () {
                                                            controller
                                                                .removerImagemSelecionada(
                                                                    index);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container();
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox.shrink();
      },
    );
  }

  Widget _buildCamposImagensQuebrado(BuildContext context) {
    return Obx(
      () {
        return controller.grauQuebrado.value > 0.0
            ? Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 32,
                      bottom: 20,
                    ),
                    child: Row(
                      children: [
                        TextComponent(
                          'Quebrado',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 100,
                                child: controller.criacaoAvaria.value.imagens
                                            ?.length ==
                                        0
                                    ? Center(
                                        child: Text(
                                            'Selecione entre 1 a 5 imagens'),
                                      )
                                    : ListView.separated(
                                        shrinkWrap: false,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.criacaoAvaria
                                            .value.imagens!.length,
                                        separatorBuilder: (context, index) {
                                          return index == 0
                                              ? SizedBox()
                                              : SizedBox(
                                                  width: 1,
                                                );
                                        },
                                        itemBuilder: (context, index) {
                                          return controller
                                                      .criacaoAvaria
                                                      .value
                                                      .imagens![index]
                                                      .categoria ==
                                                  '3'
                                              ? Stack(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Image.network(
                                                        controller
                                                                    .criacaoAvaria
                                                                    .value
                                                                    .imagens![
                                                                        index]
                                                                    .categoria ==
                                                                '3'
                                                            ? controller
                                                                    .criacaoAvaria
                                                                    .value
                                                                    .imagens![
                                                                        index]
                                                                    .url ??
                                                                ''
                                                            : '',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      width: 48,
                                                      height: 48,
                                                      child: FittedBox(
                                                        child:
                                                            FloatingActionButton(
                                                          heroTag:
                                                              'btn_${index}_remover_imagem',
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade400,
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 24,
                                                          ),
                                                          onPressed: () {
                                                            controller
                                                                .removerImagemSelecionada(
                                                                    index);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container();
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox.shrink();
      },
    );
  }

  Widget _buildCamposImagensManchado(BuildContext context) {
    return Obx(() {
      return controller.grauManchado.value > 0.0
          ? Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 32,
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      TextComponent(
                        'Manchado',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 100,
                              child: controller.criacaoAvaria.value.imagens
                                          ?.length ==
                                      0
                                  ? Center(
                                      child:
                                          Text('Selecione entre 1 a 5 imagens'),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: false,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller
                                          .criacaoAvaria.value.imagens!.length,
                                      separatorBuilder: (context, index) {
                                        return index == 0
                                            ? SizedBox()
                                            : SizedBox(
                                                width: 1,
                                              );
                                      },
                                      itemBuilder: (context, index) {
                                        return controller
                                                    .criacaoAvaria
                                                    .value
                                                    .imagens![index]
                                                    .categoria ==
                                                '4'
                                            ? Stack(
                                                alignment:
                                                    Alignment.bottomRight,
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Image.network(
                                                      controller
                                                                  .criacaoAvaria
                                                                  .value
                                                                  .imagens![
                                                                      index]
                                                                  .categoria ==
                                                              '4'
                                                          ? controller
                                                                  .criacaoAvaria
                                                                  .value
                                                                  .imagens![
                                                                      index]
                                                                  .url ??
                                                              ''
                                                          : '',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(6),
                                                    width: 48,
                                                    height: 48,
                                                    child: FittedBox(
                                                      child:
                                                          FloatingActionButton(
                                                        heroTag:
                                                            'btn_${index}_remover_imagem',
                                                        backgroundColor:
                                                            Colors.red.shade400,
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 24,
                                                        ),
                                                        onPressed: () {
                                                          controller
                                                              .removerImagemSelecionada(
                                                                  index);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container();
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : SizedBox.shrink();
    });
  }

  // Widget _videoAvaria(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Obx(
  //         () => controller.criacaoAvaria.value.videos!.length == 0
  //             ? Container(
  //                 child: Text(
  //                   'Incluir  ao menos 1 vídeo',
  //                 ),
  //               )
  //             : Container(
  //                 width: 300,
  //                 height: 180,
  //                 child: Column(
  //                   children: [
  //                     Stack(
  //                       alignment: Alignment.bottomRight,
  //                       children: [
  //                         FutureBuilder(
  //                           future:
  //                               controller.initializeVideoPlayerFuture.value,
  //                           builder: (context, snapshot) {
  //                             if (snapshot.connectionState ==
  //                                 ConnectionState.done) {
  //                               return AspectRatio(
  //                                 aspectRatio: controller.controllerVideoPlayer
  //                                     .value!.value.aspectRatio,
  //                                 child: VideoPlayer(
  //                                     controller.controllerVideoPlayer.value!),
  //                               );
  //                             } else {
  //                               return const Center(
  //                                 child: CircularProgressIndicator(),
  //                               );
  //                             }
  //                           },
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.all(6.0),
  //                               child: Container(
  //                                 width: 36,
  //                                 height: 36,
  //                                 child: FittedBox(
  //                                   child: FloatingActionButton(
  //                                     onPressed: () {
  //                                       if (controller.controllerVideoPlayer
  //                                           .value!.value.isPlaying) {
  //                                         controller
  //                                             .controllerVideoPlayer.value!
  //                                             .pause();
  //                                         controller.isPlayVideo.value = false;
  //                                       } else {
  //                                         // If the video is paused, play it.
  //                                         controller
  //                                             .controllerVideoPlayer.value!
  //                                             .play();
  //                                         controller.isPlayVideo.value = true;
  //                                       }
  //                                     },
  //                                     child: controller.isPlayVideo.value
  //                                         ? Icon(
  //                                             Icons.pause,
  //                                             color: Colors.white,
  //                                             size: 24,
  //                                           )
  //                                         : Icon(
  //                                             Icons.play_arrow,
  //                                             color: Colors.white,
  //                                             size: 24,
  //                                           ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             Obx(() => controller
  //                                         .criacaoAvaria.value.videos!.length !=
  //                                     0
  //                                 ? Container(
  //                                     padding: EdgeInsets.all(6),
  //                                     width: 48,
  //                                     height: 48,
  //                                     child: FittedBox(
  //                                       child: FloatingActionButton(
  //                                         heroTag: 'btn_${0}_remover_video',
  //                                         backgroundColor: Colors.red.shade400,
  //                                         child: Icon(
  //                                           Icons.delete,
  //                                           size: 24,
  //                                         ),
  //                                         onPressed: () {
  //                                           controller.revomerVideo(0);
  //                                         },
  //                                       ),
  //                                     ),
  //                                   )
  //                                 : Container()),
  //                           ],
  //                         ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //       ),
  //       SizedBox(
  //         height: 8,
  //       ),
  //       Row(
  //         children: [
  //           ElevatedButton(
  //             onPressed: () {
  //               controller.escolherVideos();
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 10),
  //               child: Text('Incluir Video'),
  //             ),
  //             style: ButtonStyle(
  //               backgroundColor: MaterialStateProperty.all(
  //                 Color.fromRGBO(46, 212, 148, 1),
  //               ),
  //               shape: MaterialStateProperty.all(
  //                 RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildCamposImagensGrauAvaria(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Icon(
                Icons.attach_file,
                size: 20,
                color: Colors.black,
              ),
              Text(
                'Anexos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromRGBO(46, 212, 148, 1),
                ),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
              ),
              onPressed: () {
                _openGallery(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Text(
                  'Anexar Imagens',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void alertaConfirmarCriacao(BuildContext context) {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text('Confirmação de Criação de Avaria'),
          content: Text(
              'Depois de confirmada, a criação da avaria não poderá ser alterada'),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.pop(context, 'Cancelar');
                Get.back();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Get.back();

                if (await controller.salvarProdutoAvariado()) {
                  Notificacao.snackBar(
                      'Produto avariado Cadastrado com sucesso!',
                      tipoNotificacao: TipoNotificacaoEnum.sucesso);

                  Get.delete<ProdutoAvariaController>();
                  Get.offAllNamed('/avaria');
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      }),
    );
  }

  Widget _bottomSalvarVoltar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Obx(
          () => controller.carregandoDados.value == false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.delete<ProdutoAvariaController>();
                        Get.offAllNamed('/avaria');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Voltar'),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(46, 212, 148, 1),
                      )),
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.formKey.currentState!.save();

                          if (controller.validaCriacaoProdutoAvaria()) {
                            //String? idCor = controller.idCor.text;
                            //controller.criacaoAvaria.value.cor = int.parse(idCor);

                            String? ldOrigem = controller.ldOrigem.text;
                            controller.criacaoAvaria.value.ldOrigem =
                                int.parse(ldOrigem);

                            controller.criarProdutoAvariado();

                            alertaConfirmarCriacao(context);
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Salvar'),
                      ),
                    ),
                  ],
                )
              : LoadingComponent(),
        ),
      ),
    );
  }

  void _showSelecaoMidiasAvarias(BuildContext context) {
    controller.selecionandoImagens.value = false;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(
                'Anexar Mídias',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Container(
            width: Get.width * 0.5,
            height: Get.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GetBuilder<ProdutoAvariaController>(
                  builder: (_) {
                    return Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 120,
                                child: controllerAvaria.tamanhoLista(controller
                                            .checkBoxCategoriaImagem) ==
                                        0
                                    ? Center(
                                        child: Text(
                                            'Selecione entre 1 a 5 imagens'),
                                      )
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controllerAvaria
                                                    .criacaoAvaria
                                                    .value
                                                    .imagens!
                                                    .length >
                                                0
                                            ? controllerAvaria.criacaoAvaria
                                                .value.imagens!.length
                                            : controllerAvaria.tamanhoLista(
                                                controller
                                                    .checkBoxCategoriaImagem),
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            width: 3,
                                          );
                                        },
                                        itemBuilder: (context, index) {
                                          return controllerAvaria
                                                      .criacaoAvaria
                                                      .value
                                                      .imagens![index]
                                                      .categoria
                                                      .toString() ==
                                                  controllerAvaria
                                                      .checkBoxCategoriaImagem!
                                                      .value
                                                      .toString()
                                              ? Stack(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  children: [
                                                    Container(
                                                      width: 120,
                                                      height: 120,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Image.network(
                                                        controllerAvaria
                                                                    .criacaoAvaria
                                                                    .value
                                                                    .imagens![
                                                                        index]
                                                                    .categoria
                                                                    .toString() ==
                                                                controllerAvaria
                                                                    .checkBoxCategoriaImagem!
                                                                    .value
                                                                    .toString()
                                                            ? controllerAvaria
                                                                    .criacaoAvaria
                                                                    .value
                                                                    .imagens![
                                                                        index]
                                                                    .url ??
                                                                ''
                                                            : '',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      width: 48,
                                                      height: 48,
                                                      child: FittedBox(
                                                        child:
                                                            FloatingActionButton(
                                                          heroTag:
                                                              'btn_${index}_remover_imagem',
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade400,
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 24,
                                                          ),
                                                          onPressed: () {
                                                            controllerAvaria
                                                                .removerImagemSelecionada(
                                                                    index);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container();
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                GetBuilder<ProdutoAvariaController>(
                  builder: (_) {
                    return Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextComponent(
                                  '${controllerAvaria.tamanhoLista(controllerAvaria.checkBoxCategoriaImagem)}/5 imagens anexadas na categoria'),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Container(
                                child: controllerAvaria.selecionandoImagens ==
                                            false &&
                                        controller.grauAmassado.value > 0.0
                                    ? Expanded(
                                        child: ListTile(
                                          title: const Text('Amassado'),
                                          leading:
                                              Radio<CategoriaImagensAvariaEnum>(
                                            value: CategoriaImagensAvariaEnum
                                                .AMASSADO,
                                            groupValue: controllerAvaria
                                                .checkBoxCategoriaImagem,
                                            onChanged:
                                                (CategoriaImagensAvariaEnum?
                                                    value) {
                                              controllerAvaria
                                                  .checkBoxImagem(value);
                                            },
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                              Container(
                                child: controllerAvaria.selecionandoImagens ==
                                            false &&
                                        controller.grauArranhado.value > 0.0
                                    ? Expanded(
                                        child: ListTile(
                                          title: const Text('Arranhado'),
                                          leading:
                                              Radio<CategoriaImagensAvariaEnum>(
                                            value: CategoriaImagensAvariaEnum
                                                .ARRANHADO,
                                            groupValue: controllerAvaria
                                                .checkBoxCategoriaImagem,
                                            onChanged:
                                                (CategoriaImagensAvariaEnum?
                                                    value) {
                                              controller.checkBoxImagem(value);
                                            },
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                              Container(
                                child: controllerAvaria.selecionandoImagens ==
                                            false &&
                                        controller.grauQuebrado.value > 0.0
                                    ? Expanded(
                                        child: ListTile(
                                          title: const Text('Quebrado'),
                                          leading:
                                              Radio<CategoriaImagensAvariaEnum>(
                                            value: CategoriaImagensAvariaEnum
                                                .QUEBRADO,
                                            groupValue: controllerAvaria
                                                .checkBoxCategoriaImagem,
                                            onChanged:
                                                (CategoriaImagensAvariaEnum?
                                                    value) {
                                              controllerAvaria
                                                  .checkBoxImagem(value);
                                            },
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                              Container(
                                child: controllerAvaria.selecionandoImagens ==
                                            false &&
                                        controller.grauManchado.value > 0.0
                                    ? Expanded(
                                        child: ListTile(
                                          title: const Text('Manchado'),
                                          leading:
                                              Radio<CategoriaImagensAvariaEnum>(
                                            value: CategoriaImagensAvariaEnum
                                                .MANCHADO,
                                            groupValue: controllerAvaria
                                                .checkBoxCategoriaImagem,
                                            onChanged:
                                                (CategoriaImagensAvariaEnum?
                                                    value) {
                                              controllerAvaria
                                                  .checkBoxImagem(value);
                                            },
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (controller.checkBoxCategoriaImagem == null) {
                                Notificacao.snackBar(
                                  'Selecione uma categoria de Imagem!',
                                  tipoNotificacao: TipoNotificacaoEnum.error,
                                );
                              } else {
                                if (controller.verificalimiteImagens(
                                    controller.checkBoxCategoriaImagem)) {
                                  controller.selecionandoImagens.value = true;
                                  await controller.escolherImagens();
                                  controller.selecionandoImagens.value = false;
                                } else {
                                  controller.selecionandoImagens.value = false;
                                  Get.back();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.blue, // Color de fondo del botón
                              foregroundColor:
                                  Colors.white, // Color del texto del botón
                            ),
                            child: Text('Anexar Mídias'),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Color de fondo del botón
                        foregroundColor:
                            Colors.white, // Color del texto del botón
                        disabledBackgroundColor:
                            Colors.red, // Color al pasar el cursor por encima
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('Cancelar'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.tamanhoMinimo()) {
                          // Agrega el código que necesitas para el botón "Adicionar"
                        } else {
                          Get.back();
                        }
                      },
                      child: Text('Adicionar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Anexar Mídia"),
            content: Text("Caminho da imagem: ${pickedFile.path}"),
            actions: [
              TextButton(
                child: Text("Cancelar"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Anexar Mídia"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
                onPressed: () {
                  // Lógica para anexar a mídia aqui, se necessário
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      body: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Sidebar(),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _menuAvaria(context),
                              _SliderAvaria(context),
                              _descricaoDefeito(context),
                              _anexos(context),
                              _buildCamposImagensAmassado(context),
                              _buildCamposImagensArranhado(context),
                              _buildCamposImagensQuebrado(context),
                              _buildCamposImagensManchado(context),
                              //  _videoAvaria(context),
                              _bottomSalvarVoltar(context)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
