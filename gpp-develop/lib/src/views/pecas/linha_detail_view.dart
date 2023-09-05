import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/pecas_controller/pecas_especie_controller.dart';
import 'package:gpp/src/controllers/pecas_controller/pecas_linha_controller.dart';
import 'package:gpp/src/models/pecas_model/pecas_especie_model.dart';
import 'package:gpp/src/models/pecas_model/pecas_linha_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/pecas/situacao.dart';

// ignore: must_be_immutable
class EspecieDetailView extends StatefulWidget {
  PecasLinhaModel? pecasLinhaModel;
  PecasEspecieModel? pecasEspecieModel;

  EspecieDetailView({this.pecasLinhaModel, this.pecasEspecieModel});

  @override
  _EspecieDetailViewState createState() => _EspecieDetailViewState();
}

class _EspecieDetailViewState extends State<EspecieDetailView> {
  PecasLinhaController _pecasLinhaController = PecasLinhaController();
  PecasEspecieController _pecasEspecieController = PecasEspecieController();

  PecasLinhaModel? selectedLinha;

  PecasLinhaModel? pecasLinhaModel;
  PecasEspecieModel? pecasEspecieModel;

  @override
  void initState() {
    pecasLinhaModel = widget.pecasLinhaModel;
    pecasEspecieModel = widget.pecasEspecieModel;

    if (pecasLinhaModel != null) {
      _pecasLinhaController.pecasLinhaModel = pecasLinhaModel!;
    }

    if (pecasEspecieModel != null) {
      _pecasEspecieController.pecasEspecieModel = pecasEspecieModel!;
    }

    super.initState();
  }

  Future<bool> criarLinha(context) async {
    try {
      if (await _pecasLinhaController.inserir()) {
        Notificacao.snackBar("Linha cadastrada com sucesso!");
        return true;
      }
      return false;
    } catch (e) {
      Notificacao.snackBar(e.toString());
      return false;
    }
  }

  criarEspecie(context) async {
    try {
      if (await _pecasEspecieController.create()) {
        Notificacao.snackBar("Espécie cadastrada com sucesso!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  editarLinha(context) async {
    try {
      if (await _pecasLinhaController.editar()) {
        Notificacao.snackBar("Linha editada com sucesso!");
        Navigator.pop(context);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  editarEspecie(context) async {
    try {
      if (await _pecasEspecieController.editar()) {
        Notificacao.snackBar("Espécie editada com sucesso!");
        Navigator.pop(context);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 20)),
            Icon(pecasLinhaModel != null || pecasEspecieModel != null
                ? Icons.edit
                : Icons.add_box),
            Padding(padding: EdgeInsets.only(right: 12)),
            TitleComponent(pecasLinhaModel != null || pecasEspecieModel != null
                ? 'Editar Linha e Espécie'
                : 'Cadastrar Linha e Espécie'),
          ],
        ),
      ),
      Divider(),
      Column(
        children: [
          pecasLinhaModel == null && pecasEspecieModel == null
              ? Column(
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 30)),
                    linha(context),
                    Padding(padding: EdgeInsets.only(bottom: 30)),
                    especie(context),
                  ],
                )
              : Column(
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 30)),
                    pecasLinhaModel == null ? Container() : linha(context),
                    pecasEspecieModel == null
                        ? Padding(padding: EdgeInsets.only(bottom: 30))
                        : Padding(padding: EdgeInsets.zero),
                    pecasEspecieModel == null ? Container() : especie(context),
                  ],
                )
        ],
      ),
    ]);
  }

  linha(BuildContext context) {
    return Column(
      children: [
        pecasLinhaModel == null
            ? Container()
            : Row(
                children: [
                  Flexible(
                    child: InputComponent(
                      enable: false,
                      initialValue: pecasLinhaModel == null
                          ? ''
                          : pecasLinhaModel!.id_peca_linha.toString(),
                      label: 'ID',
                      onChanged: (value) {
                        _pecasLinhaController.pecasLinhaModel.id_peca_linha =
                            value;
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 30)),
                  DropdownButton<Situacao>(
                      value: Situacao.values[pecasLinhaModel!.situacao!],
                      onChanged: (Situacao? newValue) {
                        setState(() {
                          pecasLinhaModel?.situacao = newValue!.index;
                          _pecasLinhaController.pecasLinhaModel.situacao =
                              newValue!.index;
                        });
                      },
                      items: Situacao.values.map((Situacao? situacao) {
                        return DropdownMenuItem<Situacao>(
                            value: situacao, child: Text(situacao!.name));
                      }).toList())
                ],
              ),
        Padding(padding: EdgeInsets.only(bottom: 10)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(padding: EdgeInsets.only(bottom: 30)),
            Flexible(
              child: InputComponent(
                label: 'Nome da Linha',
                initialValue:
                    pecasLinhaModel == null ? '' : pecasLinhaModel!.linha,
                onChanged: (value) {
                  _pecasLinhaController.pecasLinhaModel.linha = value;
                },
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(bottom: 30)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            pecasLinhaModel == null
                ? ButtonComponent(
                    onPressed: () {
                      criarLinha(context).then((value) => setState(() {}));
                    },
                    text: 'Salvar',
                  )
                : Row(
                    children: [
                      ButtonComponent(
                        onPressed: () {
                          editarLinha(context);
                        },
                        text: 'Editar',
                      ),
                      Padding(padding: EdgeInsets.only(right: 20)),
                      ButtonComponent(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: 'Cancelar',
                        color: Colors.red,
                      ),
                    ],
                  ),
          ],
        ),
      ],
    );
  }

  especie(BuildContext context) {
    return Column(
      children: [
        pecasEspecieModel == null
            ? Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Cadastrar Espécie',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  Divider()
                ],
              )
            : Container(),
        Padding(padding: EdgeInsets.only(bottom: 30)),
        pecasEspecieModel == null
            ? Container()
            : Row(
                children: [
                  Flexible(
                    child: InputComponent(
                      enable: false,
                      initialValue: pecasEspecieModel == null
                          ? ''
                          : pecasEspecieModel!.id_peca_especie.toString(),
                      label: 'ID',
                      onChanged: (value) {
                        _pecasEspecieController
                            .pecasEspecieModel.id_peca_especie = value;
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 30)),
                  DropdownButton<Situacao>(
                      value: Situacao.values[pecasEspecieModel!.situacao!],
                      onChanged: (Situacao? newValue) {
                        setState(() {
                          pecasEspecieModel?.situacao = newValue!.index;
                          _pecasEspecieController.pecasEspecieModel.situacao =
                              newValue!.index;
                        });
                      },
                      items: Situacao.values.map((Situacao? situacao) {
                        return DropdownMenuItem<Situacao>(
                            value: situacao, child: Text(situacao!.name));
                      }).toList())
                ],
              ),
        Padding(padding: EdgeInsets.only(bottom: 10)),
        // FutureBuilder(
        //   future: _pecasLinhaController.buscarTodos(),
        //   builder: (context, AsyncSnapshot snapshot) {
        //     switch (snapshot.connectionState) {
        //       case ConnectionState.none:
        //         return Text("there is no connection");
        //       case ConnectionState.active:
        //       case ConnectionState.waiting:
        //         return Center(child: new CircularProgressIndicator());
        //       case ConnectionState.done:
        //         return Container(
        //           padding: EdgeInsets.only(left: 12, right: 12),
        //           decoration: BoxDecoration(
        //             color: Colors.grey.shade200,
        //             borderRadius: BorderRadius.circular(5),
        //           ),
        //           child: DropdownSearch<PecasLinhaModel?>(
        //             mode: Mode.MENU,
        //             showSearchBox: true,
        //             items: snapshot.data,
        //             itemAsString: (PecasLinhaModel? u) => u!.linha!,
        //             onSaved: (newValue) {
        //               print(newValue);
        //             },
        //             dropdownSearchDecoration: InputDecoration(
        //               labelText: 'Selecione',
        //               hintText: 'Paises',
        //             ),
        //             onChanged: (value) {
        //               _pecasEspecieController.pecasEspecieModel.id_peca_linha = value!.id_peca_linha;
        //             },
        //           ),
        //         );
        //     }
        //   },
        // ),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextComponent('Selecione a linha'),
                Padding(padding: EdgeInsets.only(bottom: 6)),
                Container(
                  width: 300,
                  height: 48,
                  child: FutureBuilder(
                    future: _pecasLinhaController.buscarTodos(),
                    builder: (context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text("there is no connection");
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return Center(child: new CircularProgressIndicator());
                        case ConnectionState.done:
                          return Container(
                            padding: EdgeInsets.only(left: 12, right: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownSearch<PecasLinhaModel?>(
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              selectedItem: pecasEspecieModel == null
                                  ? snapshot.data[0]
                                  : pecasEspecieModel!.linha,
                              items: snapshot.data,
                              itemAsString: (PecasLinhaModel? value) =>
                                  value!.linha!,
                              onChanged: (value) {
                                _pecasEspecieController.pecasEspecieModel
                                    .id_peca_linha = value!.id_peca_linha;
                              },
                              dropdownSearchDecoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                              ),
                              dropDownButton: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.black,
                              ),
                              showAsSuffixIcons: true,
                              // popupTitle: Column(
                              //   children: [
                              //     Padding(padding: EdgeInsets.only(top: 20)),
                              //     Row(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Padding(padding: EdgeInsets.only(left: 10)),
                              //         Text(
                              //           'Selecione a linha',
                              //           style: TextStyle(fontWeight: FontWeight.bold),
                              //         ),
                              //         // Padding(padding: EdgeInsets.only(top: 20, left: 60)),
                              //       ],
                              //     ),
                              //     Padding(padding: EdgeInsets.only(top: 20)),
                              //   ],
                              // ),
                            ),
                          );
                      }
                    },
                  ),
                ),
                // FutureBuilder(
                //   future: _pecasLinhaController.buscarTodos(),
                //   builder: (context, AsyncSnapshot snapshot) {
                //     if (!snapshot.hasData) {
                //       return CircularProgressIndicator();
                //     } else {
                //       final List<PecasLinhaModel> _pecasLinha = snapshot.data;

                //       if (pecasEspecieModel != null) {
                //         selectedLinha?.id_peca_linha = pecasEspecieModel?.id_peca_linha;
                //       }

                //       return Container(
                //         padding: EdgeInsets.only(left: 12, right: 12),
                //         decoration: BoxDecoration(
                //           color: Colors.grey.shade200,
                //           borderRadius: BorderRadius.circular(5),
                //         ),
                //         child: DropdownButtonHideUnderline(
                //           child: DropdownButton<PecasLinhaModel>(
                //             hint: Text('Selecione'),
                //             value: selectedLinha?.id_peca_linha == null
                //                 ? selectedLinha
                //                 : _pecasLinha.firstWhere((element) => element.id_peca_linha == selectedLinha!.id_peca_linha,
                //                     orElse: () => _pecasLinha[0]),
                //             items: _pecasLinha
                //                 .map((dadosLinha) => DropdownMenuItem<PecasLinhaModel>(
                //                       value: dadosLinha,
                //                       child: Text(dadosLinha.linha!.toString().toUpperCase()),
                //                     ))
                //                 .toList(),
                //             onChanged: (value) {
                //               setState(() {
                //                 selectedLinha = value!;
                //               });
                //               _pecasEspecieController.pecasEspecieModel.id_peca_linha = value!.id_peca_linha;
                //             },
                //             icon: Icon(
                //               Icons.arrow_drop_down_rounded,
                //               color: Colors.black,
                //             ),
                //             iconSize: 36,
                //           ),
                //         ),
                //       );
                //     }
                //   },
                // ),
              ],
            ),
            Padding(padding: EdgeInsets.only(right: 30)),
            Flexible(
              child: InputComponent(
                label: 'Nome da Espécie',
                initialValue:
                    pecasEspecieModel == null ? '' : pecasEspecieModel!.especie,
                onChanged: (value) {
                  _pecasEspecieController.pecasEspecieModel.especie = value;
                },
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(bottom: 30)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            pecasEspecieModel == null
                ? ButtonComponent(
                    onPressed: () {
                      criarEspecie(context);
                    },
                    text: 'Salvar',
                  )
                : Row(
                    children: [
                      ButtonComponent(
                        onPressed: () {
                          editarEspecie(context);
                        },
                        text: 'Editar',
                      ),
                      Padding(padding: EdgeInsets.only(right: 20)),
                      ButtonComponent(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: 'Cancelar',
                        color: Colors.red,
                      ),
                    ],
                  ),
          ],
        ),
      ],
    );
  }
}
