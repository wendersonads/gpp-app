import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/avaria/controllers/consulta_produto_avaria_controller.dart';
import 'package:gpp/src/views/avaria/views/controller/detalhes_produto_avaria_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class DetalhesProdutoAvariaDesktop extends StatelessWidget {
  final controller = Get.find<DetalhesProdutoAvariaController>();

  Widget cardStatus() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 120,
            height: 22,
            alignment: Alignment.center,
            child: Text(
              'Aprovado',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(0, 207, 128, 1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(3, 5),
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 7),
                ]),
          ),
        ),
      ],
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
        SizedBox(
          height: 16,
        ),
        cardStatus(),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: InputComponent(
                enable: false,
                hintText: controller.produtoAvaria.first.idAvaria.toString(),
                label: 'ID Produto/SKU',
                keyboardType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: InputComponent(
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
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.1),
                      fontSize: 14,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.1),
                      labelText: 'Cor',
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
            Column(
              children: [
                Container(
                  width: 150,
                  height: 55,
                  margin: EdgeInsets.only(
                    bottom: 10,
                    right: 8,
                  ),
                  child: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.1),
                      fontSize: 14,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
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
            Expanded(
              child: InputComponent(
                enable: false,
                label: 'LD Origem',
                keyboardType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _SliderAvaria(BuildContext context) {
    return Container(
      // width: double.infinity,
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Slider(
                        min: 0.0,
                        max: 4.0,
                        divisions: 4,
                        value: 3,
                        onChanged: null,
                        activeColor: Color.fromRGBO(4, 4, 145, 1),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Arranhado:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Slider(
                        min: 0.0,
                        max: 4.0,
                        divisions: 4,
                        value: 0,
                        onChanged: null,
                        activeColor: Color.fromRGBO(4, 4, 145, 1),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Quebrado:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Slider(
                        min: 0.0,
                        max: 4.0,
                        divisions: 4,
                        value: 2,
                        onChanged: null,
                        activeColor: Color.fromRGBO(4, 4, 145, 1),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Manchado:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Slider(
                        min: 0.0,
                        max: 4.0,
                        divisions: 4,
                        value: 2,
                        onChanged: null,
                        activeColor: Color.fromRGBO(4, 4, 145, 1),
                      ),
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
    );
  }
  // Widget _buildPreviewImagem(String? url, int index) {
  //   // String? imageURL = controller.montarURLImagem(url);

  //   if (imageURL == null) {
  //     return Container();
  //   }

  //   //Caso esteja rodando na Web, é necessário uma configuração extra para o preview
  //   if (kIsWeb) {
  //     // ignore: undefined_prefixed_name
  //     ui.platformViewRegistry.registerViewFactory(
  //       imageURL,
  //       (int viewId) => html.ImageElement()
  //         ..src = imageURL
  //         ..style.width = '100%'
  //         ..style.objectFit = 'cover'
  //         ..style.height = '100%',
  //     );

  //     return Stack(
  //       alignment: Alignment.bottomRight,
  //       children: [
  //         Container(
  //           width: 200,
  //           height: 200,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: HtmlElementView(
  //             viewType: imageURL,
  //           ),
  //         ),
  //         Container(
  //           padding: EdgeInsets.all(6),
  //           width: 56,
  //           height: 56,
  //           child: FittedBox(
  //             child: FloatingActionButton(
  //               heroTag: 'btn_${index}_visualizar_imagem',
  //               backgroundColor: secundaryColor,
  //               onPressed: () async {
  //                 await controller.abrirLinkImagem(imageURL);
  //               },
  //               child: Icon(
  //                 Icons.image_search,
  //                 color: Colors.white,
  //                 size: 28,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  //   }

  //   return Container();
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
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Produto Amassado na lateral',
              hintStyle: TextStyle(fontSize: 16, color: Colors.black),
              filled: true,
              fillColor: Color.fromARGB(255, 180, 180, 180).withOpacity(0.1),
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

  Widget _buildCategoriaAmassado() {
    // final List<ImagemAvaria>? categoriasAmassado = controller
    //     .produtoAvaria.imagens
    //     ?.where((imagem) => imagem.categoria == '1')
    //     .toList();
    // if (categoriasAmassado?.isEmpty ?? false) {
    //   return SizedBox.shrink();
    // }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: SelectableText(
                    'Amassado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                // Container(
                //   height: 200,
                //   child: ListView.separated(
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: categoriasAmassado?.length ?? 0,
                //     separatorBuilder: (context, index) {
                //       return SizedBox(
                //         width: 2,
                //       );
                //     },
                //     itemBuilder: (context, index) {
                //       //verifica a categoria da imagem
                //       return _buildPreviewImagem(
                //           controller.produtoAvaria.imagens?[index].url, index);
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaArranhado() {
    // final List<ImagemAvaria>? categoriasArranhado = controller
    //     .solicitacao.imagens
    //     ?.where((imagem) => imagem.categoria == '2')
    //     .toList();
    // if (categoriasArranhado?.isEmpty ?? false) {
    //   return SizedBox.shrink();
    // }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: SelectableText(
                    'Arranhado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                // Container(
                //   height: 200,
                //   child: ListView.separated(
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: categoriasArranhado?.length ?? 0,
                //     separatorBuilder: (context, index) {
                //       return SizedBox(
                //         width: 1,
                //       );
                //     },
                //     itemBuilder: (context, index) {
                //       //verifica a categoria da imagem
                //       return _buildPreviewImagem(
                //           categoriasArranhado?[index].url, index);
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaManchado() {
    // final List<ImagemAvaria>? categoriasManchado = controller
    //     .solicitacao.imagens
    //     ?.where((imagem) => imagem.categoria == '2')
    //     .toList();
    // if (categoriasArranhado?.isEmpty ?? false) {
    //   return SizedBox.shrink();
    // }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: SelectableText(
                    'Manchado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                // Container(
                //   height: 200,
                //   child: ListView.separated(
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: categoriasArranhado?.length ?? 0,
                //     separatorBuilder: (context, index) {
                //       return SizedBox(
                //         width: 1,
                //       );
                //     },
                //     itemBuilder: (context, index) {
                //       //verifica a categoria da imagem
                //       return _buildPreviewImagem(
                //           categoriasManchado?[index].url, index);
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaQuebrado() {
    // final List<ImagemAvaria>? categoriaQuebrado = controller
    //     .solicitacao.imagens
    //     ?.where((imagem) => imagem.categoria == '2')
    //     .toList();
    // if (categoriasArranhado?.isEmpty ?? false) {
    //   return SizedBox.shrink();
    // }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: SelectableText(
                    'Quebrado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                // Container(
                //   height: 200,
                //   child: ListView.separated(
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: categoriaQuebrado?.length ?? 0,
                //     separatorBuilder: (context, index) {
                //       return SizedBox(
                //         width: 1,
                //       );
                //     },
                //     itemBuilder: (context, index) {
                //       //verifica a categoria da imagem
                //       return _buildPreviewImagem(
                //           categoriasManchado?[index].url, index);
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 8,
          ),
          width: 200,
          height: 60,
          child: ButtonComponent(
            onPressed: () {},
            text: 'Ver video',
          ),
        ),
      ],
    );
  }

  Widget _bottomVoltar(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
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
      ],
    ));
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
            Obx(
              () {
                return controller.carregandoDados.value
                    ? Expanded(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Form(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _menuAvaria(context),
                                        _SliderAvaria(context),
                                        _descricaoDefeito(context),
                                        _buildCategoriaAmassado(),
                                        _buildCategoriaArranhado(),
                                        _buildCategoriaManchado(),
                                        _buildCategoriaQuebrado(),
                                        // _buildVideos(), // comentado será implementado na fase 2
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              _bottomVoltar(context),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: LoadingComponent(),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
