import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/pecas_controller/peca_controller.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/pecas/pecas_edit_view.dart';
import 'package:gpp/src/views/pecas/pop_up_editar.dart';

class PecasListView extends StatefulWidget {
  const PecasListView({Key? key}) : super(key: key);

  @override
  _PecasListViewState createState() => _PecasListViewState();
}

class _PecasListViewState extends State<PecasListView> {
  PecaController _pecasController = PecaController();

  excluir(PecasModel pecasModel) async {
    try {
      if (await _pecasController.excluir(pecasModel)) {
        Notificacao.snackBar("Peça excluída com sucesso!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  editar() async {
    try {
      if (await true) {
        Notificacao.snackBar("Peça alterada com sucesso!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  buscarTodasPecas() async {
    // List pecasRetornadas = await _pecasController
    //     .buscarTodos(_pecasController.pecasPagina.paginaAtual!);

    // _pecasController.listaPecas = pecasRetornadas[0];
    // _pecasController.pecasPagina = pecasRetornadas[1];

    // setState(() {
    //   _pecasController.carregado = true;
    //   _pecasController.listaPecas;
    // });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    buscarTodasPecas();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleComponent(
                      'Peças',
                    ),
                  ],
                ),
              ),
              // _buildState()
            ],
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // CheckboxComponent(),
            Expanded(
              child: TextComponent(
                'ID',
              ),
            ),
            Expanded(
              child: TextComponent('Número'),
            ),
            Expanded(
              child: TextComponent('Cod. Fabrica'),
            ),
            Expanded(
              child: TextComponent('Descrição'),
            ),
            Expanded(
              child: Text(
                'Opções',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                // textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Divider(),
        _pecasController.carregado
            ? Column(
                children: [
                  Container(
                    height: 400,
                    child: ListView.builder(
                      itemCount: _pecasController.listaPecas.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Padding(padding: EdgeInsets.only(left: 10)),
                              // CheckboxComponent(),
                              Expanded(
                                child: Text(
                                  _pecasController.listaPecas[index].id_peca
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                  // textAlign: TextAlign.start,
                                ),
                              ),
                              Expanded(
                                child: Text(_pecasController
                                    .listaPecas[index].id_peca
                                    .toString()),
                              ),
                              Expanded(
                                child: Text(_pecasController
                                            .listaPecas[index].codigo_fabrica ==
                                        null
                                    ? ''
                                    : _pecasController
                                        .listaPecas[index].codigo_fabrica
                                        .toString()),
                              ),
                              Expanded(
                                child: Text(_pecasController
                                    .listaPecas[index].descricao
                                    .toString()),
                              ),

                              Expanded(
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.visibility),
                                      color: Colors.grey.shade400,
                                      tooltip: 'Visualizar',
                                      onPressed: () {
                                        PopUpEditar.popUpPeca(
                                                context,
                                                PecasEditAndView(
                                                    pecasEditPopup:
                                                        _pecasController
                                                            .listaPecas[index],
                                                    enabled: false))
                                            .then((value) => setState(() {}));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.grey.shade400,
                                      ),
                                      tooltip: 'Editar',
                                      onPressed: () {
                                        PopUpEditar.popUpPeca(
                                                context,
                                                PecasEditAndView(
                                                    pecasEditPopup:
                                                        _pecasController
                                                            .listaPecas[index],
                                                    enabled: true))
                                            .then((value) => setState(() {
                                                  buscarTodasPecas();
                                                }));
                                      },
                                    ),
                                    // IconButton(
                                    //   icon: Icon(
                                    //     Icons.delete,
                                    //     color: Colors.grey.shade400,
                                    //   ),
                                    //   onPressed: () {
                                    //     // _pecasController.excluir(snapshot.data![index]).then((value) => setState(() {}));
                                    //     setState(() {
                                    //       excluir(snapshot.data![index]);
                                    //     });
                                    //   },
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 50, //media.height * 0.10,
                    // width: media.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextComponent('Total de páginas: ' +
                            _pecasController.pagina.total.toString()),
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.first_page),
                                tooltip: 'Primeira Página',
                                onPressed: () {
                                  _pecasController.pagina.atual = 1;
                                  buscarTodasPecas();
                                }),
                            IconButton(
                                icon: const Icon(
                                  Icons.navigate_before_rounded,
                                  color: Colors.black,
                                ),
                                tooltip: 'Página Anterior',
                                onPressed: () {
                                  if (_pecasController.pagina.atual > 0) {
                                    _pecasController.pagina.atual =
                                        _pecasController.pagina.atual - 1;
                                    buscarTodasPecas();
                                  }
                                }),
                            TextComponent(
                                _pecasController.pagina.atual.toString()),
                            IconButton(
                                icon: Icon(Icons.navigate_next_rounded),
                                tooltip: 'Próxima Página',
                                onPressed: () {
                                  if (_pecasController.pagina.atual !=
                                      _pecasController.pagina.atual) {
                                    _pecasController.pagina.atual =
                                        _pecasController.pagina.atual + 1;
                                  }

                                  buscarTodasPecas();
                                }),
                            IconButton(
                                icon: Icon(Icons.last_page),
                                tooltip: 'Última Página',
                                onPressed: () {
                                  _pecasController.pagina.atual =
                                      _pecasController.pagina.total;
                                  buscarTodasPecas();
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(),
        // FutureBuilder(
        //   future: _pecasController.buscarTodos(),
        //   builder: (context, AsyncSnapshot<List<PecasModel>> snapshot) {
        //     // List<PecasModel> _pecas = snapshot.data ?? [];

        //     switch (snapshot.connectionState) {
        //       case ConnectionState.none:
        //         return Text('none');
        //       case ConnectionState.waiting:
        //         return Center(child: CircularProgressIndicator());
        //       case ConnectionState.active:
        //         return Text('');
        //       case ConnectionState.done:
        //         if (snapshot.hasError) {
        //           return Text(
        //             '${snapshot.error}',
        //             style: TextStyle(color: Colors.red),
        //           );
        //         } else {
        //           return Column(
        //             children: [
        //               Container(
        //                 height: 400,
        //                 child: ListView.builder(
        //                   itemCount: snapshot.data?.length,
        //                   itemBuilder: (context, index) {
        //                     return Container(
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           // Padding(padding: EdgeInsets.only(left: 10)),
        //                           // CheckboxComponent(),
        //                           Expanded(
        //                             child: Text(
        //                               snapshot.data![index].id_peca.toString(),
        //                               style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        //                               // textAlign: TextAlign.start,
        //                             ),
        //                           ),
        //                           Expanded(
        //                             child: Text(snapshot.data![index].numero.toString()),
        //                           ),
        //                           Expanded(
        //                             child: Text(snapshot.data![index].codigo_fabrica == null
        //                                 ? ''
        //                                 : snapshot.data![index].codigo_fabrica.toString()),
        //                           ),
        //                           Expanded(
        //                             child: Text(snapshot.data![index].descricao.toString()),
        //                           ),

        //                           Expanded(
        //                             child: Row(
        //                               children: [
        //                                 IconButton(
        //                                   icon: Icon(Icons.visibility),
        //                                   color: Colors.grey.shade400,
        //                                   onPressed: () {
        //                                     PopUpEditar.popUpPeca(context,
        //                                             PecasEditAndView(pecasEditPopup: snapshot.data![index], enabled: false))
        //                                         .then((value) => setState(() {}));
        //                                   },
        //                                 ),
        //                                 IconButton(
        //                                   icon: Icon(
        //                                     Icons.edit,
        //                                     color: Colors.grey.shade400,
        //                                   ),
        //                                   onPressed: () {
        //                                     PopUpEditar.popUpPeca(context,
        //                                             PecasEditAndView(pecasEditPopup: snapshot.data![index], enabled: true))
        //                                         .then((value) => setState(() {}));
        //                                   },
        //                                 ),
        //                                 // IconButton(
        //                                 //   icon: Icon(
        //                                 //     Icons.delete,
        //                                 //     color: Colors.grey.shade400,
        //                                 //   ),
        //                                 //   onPressed: () {
        //                                 //     // _pecasController.excluir(snapshot.data![index]).then((value) => setState(() {}));
        //                                 //     setState(() {
        //                                 //       excluir(snapshot.data![index]);
        //                                 //     });
        //                                 //   },
        //                                 // ),
        //                               ],
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     );
        //                   },
        //                 ),
        //               ),
        //               Container(
        //                 height: 50, //media.height * 0.10,
        //                 // width: media.width,
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     TextComponent('Total de páginas: ' + '100'),
        //                     Row(
        //                       children: [
        //                         IconButton(
        //                             icon: Icon(Icons.first_page),
        //                             onPressed: () {
        //                               // pedidoController.pagina.atual = 1;
        //                               // buscarTodas();
        //                             }),
        //                         IconButton(
        //                             icon: const Icon(
        //                               Icons.navigate_before_rounded,
        //                               color: Colors.black,
        //                             ),
        //                             onPressed: () {
        //                               // if (pedidoController.pagina.atual > 0) {
        //                               //   pedidoController.pagina.atual = pedidoController.pagina.atual - 1;
        //                               //   buscarTodas();
        //                               // }
        //                             }),
        //                         TextComponent('1'),
        //                         IconButton(
        //                             icon: Icon(Icons.navigate_next_rounded),
        //                             onPressed: () {
        //                               // if (pedidoController.pagina.atual != pedidoController.pagina.total) {
        //                               //   pedidoController.pagina.atual = pedidoController.pagina.atual + 1;
        //                               // }

        //                               // buscarTodas();
        //                             }),
        //                         IconButton(
        //                             icon: Icon(Icons.last_page),
        //                             onPressed: () {
        //                               // pedidoController.pagina.atual = pedidoController.pagina.total;
        //                               // buscarTodas();
        //                             }),
        //                       ],
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           );
        //         }
        //     }
        //   },
        // ),
      ],
    );
  }
}
