import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/avaria/views/controller/produto_avaria_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:gpp/src/enums/categoria_imagens_avaria_enum.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/src/widgets/image.dart';
import 'dart:io';

class CriacaoProdutoAvariaMobile extends StatelessWidget {
  CriacaoProdutoAvariaMobile({super.key});
  final controller = Get.put(ProdutoAvariaController());
  final controllerAvaria = Get.find<ProdutoAvariaController>();

  final isPlaying = false.obs;

  Widget _politicaAvaria() {
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _politicaAvaria(),
        SizedBox(
          height: 16,
        ),
        Column(
          children: [
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
                    hintText:
                        controller.criacaoAvaria.value.idFilial.toString(),
                    enable: false,
                    label: 'Filial Origem',
                    keyboardType: TextInputType.number,
                    inputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ld Origem',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 100,
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
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.1),
                              hintText: 'ex: 00',
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
                  ],
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Cor',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      width: 100,
                      height: 55,
                      margin: EdgeInsets.only(
                        bottom: 10,
                        right: 8,
                      ),
                      child: TextFormField(
                        enabled: true,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
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
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _showModalGravarVideos(BuildContext context,
      {required Function() onCamera}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Anexar vídeo'),
          content: Text('Deseja gravar um vídeo ?'),
          actions: [
            TextButton(
              onPressed: onCamera,
              child: Text('Gravar vídeo'),
            ),
          ],
        );
      },
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 110, right: 20),
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
                              fontSize: 12,
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
                              fontSize: 12,
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
                              fontSize: 12,
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
                              fontSize: 12,
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
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                              print(controller.idProdutoSKU.text);
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

  Widget _bottomSalvarVoltar(BuildContext context) {
    return Container(
      child: Obx(
        () => controller.carregandoDados.value == false
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                            // controller.criacaoAvaria.value.cor =int.parse(idCor);

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
                ),
              )
            : LoadingComponent(),
      ),
    );
  }

  // Widget _videoAvaria(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         margin: EdgeInsets.only(
  //           top: 32,
  //           bottom: 20,
  //         ),
  //         child: TextComponent(
  //           'Vídeo',
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       Obx(
  //         () => Row(
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Stack(
  //                     children: [
  //                       Container(
  //                         height: 200,
  //                         child: controller
  //                                     .criacaoAvaria.value.videos?.length ==
  //                                 0
  //                             ? Center(
  //                                 child:
  //                                     Text('Selecione pelo menos 1 um vídeo'),
  //                               )
  //                             : FutureBuilder(
  //                                 future: controller.initializeVideoPlayerFuture.value,
  //                                 builder: ((context, snapshot) {
  //                                   if (snapshot.connectionState ==
  //                                       ConnectionState.done) {
  //                                     return Container(
  //                                       decoration: BoxDecoration(
  //                                         borderRadius:
  //                                             BorderRadius.circular(12),
  //                                       ),
  //                                       child: AspectRatio(
  //                                         aspectRatio: controller
  //                                             .controllerVideoPlayer
  //                                             .value!
  //                                             .value
  //                                             .aspectRatio,
  //                                         child: VideoPlayer(controller
  //                                             .controllerVideoPlayer.value!),
  //                                       ),
  //                                     );
  //                                   } else {
  //                                     return const Center(
  //                                       child: CircularProgressIndicator(),
  //                                     );
  //                                   }
  //                                 }),
  //                               ),
  //                       ),
  //                       Positioned(
  //                         bottom: 8,
  //                         child: Row(
  //                           children: [
  //                             Obx(() => controller
  //                                         .criacaoAvaria.value.videos!.length !=
  //                                     0
  //                                 ? Container(
  //                                     padding: EdgeInsets.all(6),
  //                                     width: 48,
  //                                     height: 48,
  //                                     child: FittedBox(
  //                                       child: FloatingActionButton(
  //                                         child: Icon(
  //                                           isPlaying.value
  //                                               ? Icons.pause
  //                                               : Icons.play_arrow,
  //                                         ),
  //                                         onPressed: () {
  //                                           if (controller.controllerVideoPlayer
  //                                               .value!.value.isPlaying) {
  //                                             controller
  //                                                 .controllerVideoPlayer.value!
  //                                                 .pause();
  //                                             controller.isPlayVideo.value =
  //                                                 false;
  //                                           } else {
  //                                             // If the video is paused, play it.
  //                                             controller
  //                                                 .controllerVideoPlayer.value!
  //                                                 .play();
  //                                             controller.isPlayVideo.value =
  //                                                 true;
  //                                           }
  //                                         },
  //                                       ),
  //                                     ),
  //                                   )
  //                                 : Container()),
  //                             SizedBox(width: 5),
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
  //                                           controller.removerVideoSelecionado(0);
  //                                         },
  //                                       ),
  //                                     ),
  //                                   )
  //                                 : Container()),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Container(
  //                     margin: EdgeInsets.only(
  //                       top: 24,
  //                     ),
  //                     child: StreamBuilder<Object>(
  //                         stream: null,
  //                         builder: (context, snapshot) {
  //                           return Row(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               ButtonComponent(
  //                                 color: controller.criacaoAvaria.value.videos
  //                                             ?.length ==
  //                                         5
  //                                     ? Colors.grey.shade400
  //                                     : secundaryColor,
  //                                 onPressed: controller.criacaoAvaria.value
  //                                             .videos?.length ==
  //                                         5
  //                                     ? () {}
  //                                     : () async {
  //                                         if (kIsWeb) {
  //                                           await controller.escolherVideos();
  //                                         } else {
  //                                           _showModalGravarVideos(
  //                                             context,
  //                                             onCamera: () async {
  //                                               await controller.escolherVideos(
  //                                                 origem: ImageSource.camera,
  //                                               );
  //                                               controller.fecharDialog();
  //                                             },
  //                                           );
  //                                         }
  //                                       },
  //                                 text: 'Anexar vídeo',
  //                               ),
  //                               SizedBox(
  //                                 width: 12,
  //                               ),
  //                             ],
  //                           );
  //                         }),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  //Criar Widgets para as imagens a partir daqui
  Widget _anexos(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Icon(
                Icons.attach_file,
                size: 30,
                color: Colors.black,
              ),
              TextComponent(
                'Anexos',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonComponent(
                text: 'Anexar imagens',
                onPressed: () {
                  _showSelecaoMidiasAvarias(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  //Widget para as imagens de amassado
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
                                child:
                                    controller.criacaoAvaria.value.imagens
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
                                                          .categoria
                                                          .toString() ==
                                                      '1'
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: kIsWeb
                                                              ? Image.network(
                                                                  controller
                                                                              .criacaoAvaria
                                                                              .value
                                                                              .imagens![
                                                                                  index]
                                                                              .categoria
                                                                              .toString() ==
                                                                          '1'
                                                                      ? controller
                                                                              .criacaoAvaria
                                                                              .value
                                                                              .imagens![index]
                                                                              .url ??
                                                                          ''
                                                                      : '',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.file(
                                                                  File(
                                                                    controller.criacaoAvaria.value.imagens![index].categoria.toString() ==
                                                                            '1'
                                                                        ? controller.criacaoAvaria.value.imagens![index].url ??
                                                                            ''
                                                                        : '',
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .low,
                                                                  scale: 1,
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
                                                                  Colors.red
                                                                      .shade400,
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
            : Container();
      },
    );
  }

  //Widget para as imagens de amassado
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
                                child:
                                    controller.criacaoAvaria.value.imagens
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
                                                          .categoria
                                                          .toString() ==
                                                      '2'
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: kIsWeb
                                                              ? Image.network(
                                                                  controller
                                                                              .criacaoAvaria
                                                                              .value
                                                                              .imagens![
                                                                                  index]
                                                                              .categoria
                                                                              .toString() ==
                                                                          '2'
                                                                      ? controller
                                                                              .criacaoAvaria
                                                                              .value
                                                                              .imagens![index]
                                                                              .url ??
                                                                          ''
                                                                      : '',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.file(
                                                                  File(
                                                                    controller.criacaoAvaria.value.imagens![index].categoria.toString() ==
                                                                            '2'
                                                                        ? controller.criacaoAvaria.value.imagens![index].url ??
                                                                            ''
                                                                        : '',
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .low,
                                                                  scale: 1,
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
                                                                  Colors.red
                                                                      .shade400,
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
            : Container();
      },
    );
  }

  //Widget para as imagens de quebrado
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
                                child:
                                    controller.criacaoAvaria.value.imagens
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
                                                          .categoria
                                                          .toString() ==
                                                      '3'
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: kIsWeb
                                                              ? Image.network(
                                                                  controller
                                                                              .criacaoAvaria
                                                                              .value
                                                                              .imagens![
                                                                                  index]
                                                                              .categoria
                                                                              .toString() ==
                                                                          '3'
                                                                      ? controller
                                                                              .criacaoAvaria
                                                                              .value
                                                                              .imagens![index]
                                                                              .url ??
                                                                          ''
                                                                      : '',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.file(
                                                                  File(
                                                                    controller.criacaoAvaria.value.imagens![index].categoria.toString() ==
                                                                            '3'
                                                                        ? controller.criacaoAvaria.value.imagens![index].url ??
                                                                            ''
                                                                        : '',
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .low,
                                                                  scale: 1,
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
                                                                  Colors.red
                                                                      .shade400,
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
            : Container();
      },
    );
  }

  //Widget para as imagens de manchado
  Widget _buildCamposImagensManchado(BuildContext context) {
    return Obx(
      () {
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
                                child:
                                    controller.criacaoAvaria.value.imagens
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
                                                          .categoria
                                                          .toString() ==
                                                      '4'
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: kIsWeb
                                                              ? Image.network(
                                                                  controller
                                                                              .criacaoAvaria
                                                                              .value
                                                                              .imagens![
                                                                                  index]
                                                                              .categoria
                                                                              .toString() ==
                                                                          '4'
                                                                      ? controller
                                                                              .criacaoAvaria
                                                                              .value
                                                                              .imagens![index]
                                                                              .url ??
                                                                          ''
                                                                      : '',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.file(
                                                                  File(
                                                                    controller.criacaoAvaria.value.imagens![index].categoria.toString() ==
                                                                            '4'
                                                                        ? controller.criacaoAvaria.value.imagens![index].url ??
                                                                            ''
                                                                        : '',
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .low,
                                                                  scale: 1,
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
                                                                  Colors.red
                                                                      .shade400,
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
            : Container();
      },
    );
  }

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

  void _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

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

  //Função que abre o modal de seleção de imagens
  void _showSelecaoMidiasAvarias(BuildContext context) {
    controller.selecionandoImagens.value = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              TextComponent(
                'Anexar Mídias',
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ],
          ),
          content: Container(
            width: Get.width * 0.9,
            height: Get.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                  ),
                  child: GetBuilder<ProdutoAvariaController>(
                    builder: (_) {
                      return Obx(
                        () => Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: controller.selecionandoImagens ==
                                              false &&
                                          controller.grauAmassado.value > 0.0
                                      ? ListTile(
                                          title: const Text(
                                            'Amassado',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          leading:
                                              Radio<CategoriaImagensAvariaEnum>(
                                            value: CategoriaImagensAvariaEnum
                                                .AMASSADO,
                                            groupValue: controller
                                                .checkBoxCategoriaImagem,
                                            onChanged:
                                                (CategoriaImagensAvariaEnum?
                                                    value) {
                                              controller.checkBoxImagem(value);
                                            },
                                          ),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: controller.selecionandoImagens ==
                                              false &&
                                          controller.grauArranhado.value > 0.0
                                      ? ListTile(
                                          title: const Text(
                                            'Arranhado',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          leading:
                                              Radio<CategoriaImagensAvariaEnum>(
                                            value: CategoriaImagensAvariaEnum
                                                .ARRANHADO,
                                            groupValue: controller
                                                .checkBoxCategoriaImagem,
                                            onChanged:
                                                (CategoriaImagensAvariaEnum?
                                                    value) {
                                              controller.checkBoxImagem(value);
                                            },
                                          ),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: controller.selecionandoImagens ==
                                              false &&
                                          controller.grauQuebrado.value > 0.0
                                      ? ListTile(
                                          title: const Text('Quebrado',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              )),
                                          leading:
                                              Radio<CategoriaImagensAvariaEnum>(
                                            value: CategoriaImagensAvariaEnum
                                                .QUEBRADO,
                                            groupValue: controller
                                                .checkBoxCategoriaImagem,
                                            onChanged:
                                                (CategoriaImagensAvariaEnum?
                                                    value) {
                                              controller.checkBoxImagem(value);
                                            },
                                          ),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: controller.selecionandoImagens ==
                                              false &&
                                          controller.grauManchado.value > 0.0
                                      ? ListTile(
                                          title: const Text('Manchado',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              )),
                                          leading:
                                              Radio<CategoriaImagensAvariaEnum>(
                                            value: CategoriaImagensAvariaEnum
                                                .MANCHADO,
                                            groupValue: controller
                                                .checkBoxCategoriaImagem,
                                            onChanged:
                                                (CategoriaImagensAvariaEnum?
                                                    value) {
                                              controller.checkBoxImagem(value);
                                            },
                                          ),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextComponent(
                                    '${controller.tamanhoLista(controller.checkBoxCategoriaImagem)}/5 imagens anexadas na categoria'),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: GetBuilder<ProdutoAvariaController>(builder: (_) {
                    return Obx(
                      () => Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: Get.height * 0.2,
                                    child: controller.tamanhoLista(controller
                                                .checkBoxCategoriaImagem) ==
                                            0
                                        ? Center(
                                            child: Text(
                                                'Selecione entre 1 a 5 imagens'),
                                          )
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: controller.criacaoAvaria
                                                        .value.imagens!.length >
                                                    0
                                                ? controller.criacaoAvaria.value
                                                    .imagens!.length
                                                : controller.tamanhoLista(
                                                    controller
                                                        .checkBoxCategoriaImagem),
                                            separatorBuilder: (context, index) {
                                              return SizedBox(
                                                width: 3,
                                              );
                                            },
                                            itemBuilder: (context, index) {
                                              return controller
                                                          .criacaoAvaria
                                                          .value
                                                          .imagens![index]
                                                          .categoria
                                                          .toString() ==
                                                      controller
                                                          .checkBoxCategoriaImagem!
                                                          .value
                                                          .toString()
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      children: [
                                                        Container(
                                                          width: 180,
                                                          height: 180,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: kIsWeb
                                                              ? Image.network(
                                                                  controller
                                                                              .criacaoAvaria
                                                                              .value
                                                                              .imagens![
                                                                                  index]
                                                                              .categoria ==
                                                                          controller
                                                                              .checkBoxCategoriaImagem!
                                                                              .value
                                                                              .toString()
                                                                      ? controller
                                                                              .criacaoAvaria
                                                                              .value
                                                                              .imagens![index]
                                                                              .url ??
                                                                          ''
                                                                      : '',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.file(
                                                                  File(
                                                                    controller.criacaoAvaria.value.imagens![index].categoria.toString() ==
                                                                            controller.checkBoxCategoriaImagem!.value
                                                                                .toString()
                                                                        ? controller.criacaoAvaria.value.imagens![index].url ??
                                                                            ''
                                                                        : '',
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .low,
                                                                  scale: 1,
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
                                                                  Colors.red
                                                                      .shade400,
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
                    );
                  }),
                ),
                ButtonComponent(
                    color: controller.criacaoAvaria.value.imagens?.length == 15
                        ? Colors.grey.shade400
                        : Color.fromARGB(255, 4, 4, 158),
                    onPressed: controller.criacaoAvaria.value.imagens?.length ==
                            15
                        ? () {}
                        : () async {
                            if (controller.checkBoxCategoriaImagem == null) {
                              Notificacao.snackBar(
                                  'Selecione uma categoria de Imagem!',
                                  tipoNotificacao: TipoNotificacaoEnum.error);
                            } else {
                              if (controller.verificalimiteImagens(
                                  controller.checkBoxCategoriaImagem)) {
                                if (kIsWeb) {
                                  await controller.escolherImagens();
                                } else {
                                  _showModalOpcaoEscolhaImagens(
                                    context,
                                    onCamera: () async {
                                      await controller.escolherImagens(
                                        origem: ImageSource.camera,
                                      );
                                      //controller.fecharDialog();
                                    },
                                    onGallery: () async {
                                      await controller.escolherImagens();
                                      // controller.fecharDialog();
                                    },
                                  );
                                }
                              } else {
                                Get.back();
                              }
                              ;
                            }
                          },
                    text: 'Anexar Mídias'),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonComponent(
                        color: vermelhoColor,
                        colorHover: vermelhoColorHover,
                        onPressed: () {
                          Get.back();
                        },
                        text: 'Cancelar',
                      ),
                      ButtonComponent(
                        onPressed: () {
                          if (controller.tamanhoMinimo()) {
                          } else {
                            Get.back();
                          }
                        },
                        text: 'Adicionar',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Função que abre modal com confirmação para tirar a(s) fotos.
  void _showModalOpcaoEscolhaImagens(BuildContext context,
      {required Function() onCamera, required Function() onGallery}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Anexar imagem'),
          content: Text('Deseja tirar uma foto?'),
          actions: [
            TextButton(
              onPressed: onCamera,
              child: Text('Tirar foto(s)'),
            ),
          ],
        );
      },
    );
  }

  //Função que abre modal de confirmação da criação da avaria
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
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
                      //_videoAvaria(context),
                      _bottomSalvarVoltar(context)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
