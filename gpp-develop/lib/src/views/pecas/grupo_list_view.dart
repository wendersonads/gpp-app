import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/pecas_controller/pecas_grupo_controller.dart';
import 'package:gpp/src/models/pecas_model/pecas_grupo_model.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/pecas/material_detail_view.dart';
import 'package:gpp/src/views/pecas/pop_up_editar.dart';
import 'package:gpp/src/views/pecas/situacao.dart';

class GrupoListView extends StatefulWidget {
  const GrupoListView({Key? key}) : super(key: key);

  @override
  _GrupoListViewState createState() => _GrupoListViewState();
}

class _GrupoListViewState extends State<GrupoListView> {
  PecasGrupoController _pecasGrupoController = PecasGrupoController();

  Future<bool> excluir(context, PecasGrupoModel pecasGrupoModel) async {
    try {
      if (await Notificacao.confirmacao(
          'Deseja excluir o grupo (${pecasGrupoModel.id_peca_grupo_material} - ${pecasGrupoModel.grupo})?')) {
        if (await _pecasGrupoController.excluir(pecasGrupoModel)) {
          Notificacao.snackBar("Linha excluída com sucesso!");
          return true;
        }
      }
      return false;
    } catch (e) {
      Notificacao.snackBar(e.toString());
      return false;
    }
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
                      'Grupo de Fabricação',
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
              child: TextComponent('Grupo'),
            ),
            Expanded(
              child: TextComponent('Situação'),
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
        FutureBuilder(
          future: _pecasGrupoController.buscarTodos(),
          builder: (context, AsyncSnapshot snapshot) {
            List<PecasGrupoModel> _pecasGrupo = snapshot.data ?? [];

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return Container(
                height: 500,
                child: ListView.builder(
                  itemCount: _pecasGrupo.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Padding(padding: EdgeInsets.only(left: 10)),
                          // CheckboxComponent(),
                          Expanded(
                            child: Text(
                              _pecasGrupo[index]
                                  .id_peca_grupo_material
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                              // textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            child: Text(_pecasGrupo[index].grupo.toString()),
                          ),
                          Expanded(
                            child: Text(Situacao
                                .values[_pecasGrupo[index].situacao!].name),
                          ),

                          Expanded(
                            child: Row(
                              children: [
                                // IconButton(
                                //   icon: Icon(
                                //     Icons.add,
                                //     color: Colors.grey.shade400,
                                //   ),
                                //   onPressed: () => {},
                                // ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.grey.shade400,
                                  ),
                                  tooltip: 'Editar',
                                  onPressed: () {
                                    PopUpEditar.popUpPeca(
                                            context,
                                            MaterialDetailView(
                                                pecasGrupoModel:
                                                    _pecasGrupo[index]))
                                        .then((value) => setState(() {}));
                                  },
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.grey.shade400,
                                    ),
                                    tooltip: 'Excluir',
                                    onPressed: () {
                                      setState(() {
                                        excluir(context, _pecasGrupo[index])
                                            .then((value) => setState(() {}));
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
