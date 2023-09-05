import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/pecas_controller/pecas_grupo_controller.dart';
import 'package:gpp/src/controllers/pecas_controller/pecas_material_controller.dart';
import 'package:gpp/src/models/pecas_model/pecas_grupo_model.dart';
import 'package:gpp/src/models/pecas_model/pecas_material_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/pecas/situacao.dart';

class MaterialDetailView extends StatefulWidget {
  final PecasGrupoModel? pecasGrupoModel;
  final PecasMaterialModel? pecasMaterialModel;

  MaterialDetailView({this.pecasGrupoModel, this.pecasMaterialModel});

  @override
  _MaterialDetailViewState createState() => _MaterialDetailViewState();
}

class _MaterialDetailViewState extends State<MaterialDetailView> {
  PecasGrupoController _pecasGrupoController = PecasGrupoController();
  PecasMaterialController _pecasMaterialController = PecasMaterialController();

  PecasGrupoModel? selectedGrupo;

  PecasGrupoModel? pecasGrupoModel;
  PecasMaterialModel? pecasMaterialModel;

  @override
  void initState() {
    pecasGrupoModel = widget.pecasGrupoModel;
    pecasMaterialModel = widget.pecasMaterialModel;

    if (pecasGrupoModel != null) {
      _pecasGrupoController.pecasGrupoModel = pecasGrupoModel!;
    }

    if (pecasMaterialModel != null) {
      _pecasMaterialController.pecasMaterialModel = pecasMaterialModel!;
    }

    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  Future<bool> criarGrupo(context) async {
    try {
      if (await _pecasGrupoController.create()) {
        Notificacao.snackBar("Grupo cadastrado com sucesso!");
        return true;
      }
      return false;
    } catch (e) {
      Notificacao.snackBar(e.toString());
      return false;
    }
  }

  criarMaterial(context) async {
    try {
      if (await _pecasMaterialController.inserir()) {
        Notificacao.snackBar("Material cadastrado com sucesso!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  editarGrupo(context) async {
    try {
      if (await _pecasGrupoController.editar()) {
        Notificacao.snackBar("Grupo alterado com sucesso!");
        Navigator.pop(context);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  editarMaterial(context) async {
    try {
      if (await _pecasMaterialController.editar()) {
        Notificacao.snackBar("Material alterado com sucesso!");
        Navigator.pop(context);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              Icon(pecasGrupoModel != null || pecasMaterialModel != null
                  ? Icons.edit
                  : Icons.add_box),
              Padding(padding: EdgeInsets.only(right: 12)),
              TitleComponent(
                  pecasGrupoModel != null || pecasMaterialModel != null
                      ? 'Editar Material de Fabricação'
                      : 'Cadastrar Material de Fabricação'),
            ],
          ),
        ),
        Divider(),
        pecasGrupoModel == null && pecasMaterialModel == null
            ? Column(
                children: [
                  grupo(context),
                  material(context),
                ],
              )
            : Column(
                children: [
                  pecasGrupoModel == null ? Container() : grupo(context),
                  pecasMaterialModel == null
                      ? Padding(padding: EdgeInsets.only(bottom: 30))
                      : Padding(padding: EdgeInsets.zero),
                  pecasMaterialModel == null ? Container() : material(context),
                ],
              ),
      ],
    );
  }

  grupo(BuildContext context) {
    return Column(
      children: [
        pecasGrupoModel == null
            ? Container()
            : Row(
                children: [
                  Flexible(
                    child: InputComponent(
                      enable: false,
                      initialValue: pecasGrupoModel == null
                          ? ''
                          : pecasGrupoModel!.id_peca_grupo_material.toString(),
                      label: 'ID',
                      onChanged: (value) {
                        _pecasGrupoController
                            .pecasGrupoModel.id_peca_grupo_material = value;
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 30)),
                  DropdownButton<Situacao>(
                      value: Situacao.values[pecasGrupoModel!.situacao!],
                      onChanged: (Situacao? newValue) {
                        setState(() {
                          pecasGrupoModel?.situacao = newValue!.index;
                          _pecasGrupoController.pecasGrupoModel.situacao =
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
            // Padding(padding: EdgeInsets.only(bottom: 30)),
            Flexible(
              child: InputComponent(
                label: 'Grupo/Família',
                initialValue: pecasGrupoModel == null
                    ? ''
                    : pecasGrupoModel!.grupo.toString(),
                onChanged: (value) {
                  _pecasGrupoController.pecasGrupoModel.grupo = value;
                  _pecasGrupoController.pecasGrupoModel.situacao = 1;
                },
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(bottom: 30)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            pecasGrupoModel == null
                ? ButtonComponent(
                    onPressed: () {
                      criarGrupo(context).then((value) => setState((() {})));
                    },
                    text: 'Salvar',
                  )
                : Row(
                    children: [
                      ButtonComponent(
                        onPressed: () {
                          editarGrupo(context);
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

  material(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 30)),
            pecasMaterialModel == null
                ? Container()
                : Row(
                    children: [
                      Flexible(
                        child: InputComponent(
                          enable: false,
                          initialValue: pecasMaterialModel == null
                              ? ''
                              : pecasMaterialModel!.id_peca_material_fabricacao
                                  .toString(),
                          label: 'ID',
                          onChanged: (value) {
                            _pecasMaterialController.pecasMaterialModel
                                .id_peca_material_fabricacao = value;
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 30)),
                      DropdownButton<Situacao>(
                          value: Situacao.values[pecasMaterialModel!.situacao!],
                          onChanged: (Situacao? newValue) {
                            setState(() {
                              pecasMaterialModel?.situacao = newValue!.index;
                              _pecasMaterialController.pecasMaterialModel
                                  .situacao = newValue!.index;
                            });
                          },
                          items: Situacao.values.map((Situacao? situacao) {
                            return DropdownMenuItem<Situacao>(
                                value: situacao, child: Text(situacao!.name));
                          }).toList())
                    ],
                  ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            pecasMaterialModel == null
                ? Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Cadastrar Material',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      Divider(),
                    ],
                  )
                : Container(),
            Padding(padding: EdgeInsets.only(bottom: 30)),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextComponent('Selecione o grupo'),
                    Padding(padding: EdgeInsets.only(bottom: 6)),
                    Container(
                      width: 200,
                      height: 48,
                      child: FutureBuilder(
                        future: _pecasGrupoController.buscarTodos(),
                        builder: (context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Text("there is no connection");
                            case ConnectionState.active:
                            case ConnectionState.waiting:
                              return Center(
                                  child: new CircularProgressIndicator());
                            case ConnectionState.done:
                              return Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownSearch<PecasGrupoModel?>(
                                  mode: Mode.DIALOG,
                                  showSearchBox: true,
                                  items: snapshot.data,
                                  selectedItem: pecasMaterialModel == null
                                      ? snapshot.data[0]
                                      : pecasMaterialModel!.grupo_material,
                                  itemAsString: (PecasGrupoModel? value) =>
                                      value!.grupo!,
                                  onChanged: (value) {
                                    _pecasMaterialController.pecasMaterialModel
                                            .id_peca_grupo_material =
                                        value!.id_peca_grupo_material;
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
                    //   future: _pecasGrupoController.buscarTodos(),
                    //   builder: (context, AsyncSnapshot snapshot) {
                    //     if (!snapshot.hasData) {
                    //       return CircularProgressIndicator();
                    //     } else {
                    //       final List<PecasGrupoModel> _pecasGrupo = snapshot.data;

                    //       return Container(
                    //         padding: EdgeInsets.only(left: 12, right: 12),
                    //         decoration: BoxDecoration(
                    //           color: Colors.grey.shade200,
                    //           borderRadius: BorderRadius.circular(5),
                    //         ),
                    //         child: DropdownButtonHideUnderline(
                    //           child: DropdownButton<PecasGrupoModel>(
                    //             hint: Text('Selecione'),
                    //             value: selectedGrupo?.id_peca_grupo_material == null
                    //                 ? selectedGrupo
                    //                 : _pecasGrupo.firstWhere(
                    //                     (element) => element.id_peca_grupo_material == selectedGrupo!.id_peca_grupo_material,
                    //                     orElse: () => _pecasGrupo[0]),
                    //             items: _pecasGrupo
                    //                 .map((dadosGrupo) => DropdownMenuItem<PecasGrupoModel>(
                    //                       value: dadosGrupo,
                    //                       child: Text(dadosGrupo.grupo.toString().toUpperCase()),
                    //                     ))
                    //                 .toList(),
                    //             onChanged: (value) {
                    //               setState(() {
                    //                 selectedGrupo = value!;
                    //               });
                    //               _pecasMaterialController.pecasMaterialModel.id_peca_material_fabricacao =
                    //                   value!.id_peca_grupo_material;
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
                    label: 'Nome do Material',
                    initialValue: pecasMaterialModel == null
                        ? ''
                        : pecasMaterialModel!.material.toString(),
                    onChanged: (value) {
                      _pecasMaterialController.pecasMaterialModel.material =
                          value;
                      _pecasMaterialController.pecasMaterialModel.situacao = 1;
                      // _pecasMaterialController.pecasMaterialModel.id_peca_grupo_material = 21;
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 30)),
                Flexible(
                  child: InputComponent(
                    label: 'Sigla',
                    initialValue: pecasMaterialModel == null
                        ? ''
                        : pecasMaterialModel!.sigla.toString(),
                    onChanged: (value) {
                      _pecasMaterialController.pecasMaterialModel.sigla = value;
                    },
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                pecasMaterialModel == null
                    ? ButtonComponent(
                        onPressed: () {
                          // if (selectedGrupo?.id_peca_grupo_material == null) {
                          //   print('Selecione o grupo');
                          // } else {
                          criarMaterial(context);
                          // }
                        },
                        text: 'Salvar',
                      )
                    : Row(
                        children: [
                          ButtonComponent(
                            onPressed: () {
                              editarMaterial(context);
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
        ),
      ],
    );
  }
}
