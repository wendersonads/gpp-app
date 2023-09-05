import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/pecas_controller/pecas_material_controller.dart';
import 'package:gpp/src/models/pecas_model/pecas_material_model.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/pecas/material_detail_view.dart';
import 'package:gpp/src/views/pecas/pop_up_editar.dart';
import 'package:gpp/src/views/pecas/situacao.dart';

class MaterialListView extends StatefulWidget {
  const MaterialListView({Key? key}) : super(key: key);

  @override
  _MaterialListViewState createState() => _MaterialListViewState();
}

class _MaterialListViewState extends State<MaterialListView> {
  PecasMaterialController _pecasMaterialController = PecasMaterialController();

  Future<bool> excluir(context, PecasMaterialModel pecasMaterialModel) async {
    try {
      if (await Notificacao.confirmacao(
          'Deseja excluir o Material (${pecasMaterialModel.id_peca_material_fabricacao} - ${pecasMaterialModel.material})?')) {
        if (await _pecasMaterialController.excluir(pecasMaterialModel)) {
          Notificacao.snackBar("Material excluído com sucesso!");
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
                      'Material de Fabricação',
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
              child: TextComponent('Material'),
            ),
            Expanded(
              child: TextComponent('Sigla'),
            ),
            Expanded(
              child: TextComponent('Situação'),
            ),
            Expanded(
              child: TextComponent('Grupo Vinculado'),
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
          future: _pecasMaterialController.buscarTodos(),
          builder: (context, AsyncSnapshot snapshot) {
            List<PecasMaterialModel> _pecasMaterial = snapshot.data ?? [];

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return Container(
                height: 500,
                child: ListView.builder(
                  itemCount: _pecasMaterial.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Padding(padding: EdgeInsets.only(left: 10)),
                          // CheckboxComponent(),
                          Expanded(
                            child: Text(
                              _pecasMaterial[index]
                                  .id_peca_material_fabricacao
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                              // textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            child:
                                Text(_pecasMaterial[index].material.toString()),
                          ),
                          Expanded(
                            child: Text(_pecasMaterial[index].sigla.toString()),
                          ),
                          Expanded(
                            child: Text(Situacao
                                .values[_pecasMaterial[index].situacao!].name),
                          ),
                          Expanded(
                            child: Text(_pecasMaterial[index]
                                .grupo_material!
                                .grupo
                                .toString()),
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
                                                pecasMaterialModel:
                                                    _pecasMaterial[index]))
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
                                      // _pecasMaterialController.excluir(_pecasMaterial[index]).then((value) => setState(() {}));
                                      excluir(context, _pecasMaterial[index])
                                          .then((value) => setState(() {}));
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
