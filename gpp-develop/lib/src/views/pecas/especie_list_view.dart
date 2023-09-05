import 'package:flutter/material.dart';

import 'package:gpp/src/controllers/pecas_controller/pecas_especie_controller.dart';
import 'package:gpp/src/models/pecas_model/pecas_especie_model.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/pecas/linha_detail_view.dart';
import 'package:gpp/src/views/pecas/pop_up_editar.dart';
import 'package:gpp/src/views/pecas/situacao.dart';

class EspecieListView extends StatefulWidget {
  const EspecieListView({Key? key}) : super(key: key);

  @override
  _EspecieListViewState createState() => _EspecieListViewState();
}

class _EspecieListViewState extends State<EspecieListView> {
  PecasEspecieController _pecasEspecieController = PecasEspecieController();

  Future<bool> excluir(context, PecasEspecieModel pecasEspecieModel) async {
    try {
      if (await Notificacao.confirmacao(
          'Deseja excluir a espécie (${pecasEspecieModel.id_peca_especie} - ${pecasEspecieModel.especie})?')) {
        if (await _pecasEspecieController.excluir(pecasEspecieModel)) {
          Notificacao.snackBar("Espécie excluída com sucesso!");
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
                      'Espécie',
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
              child: TextComponent('Espécie'),
            ),
            Expanded(
              child: TextComponent('Situação'),
            ),
            Expanded(
              child: TextComponent('Linha Vinculada'),
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
          future: _pecasEspecieController.buscarTodos(),
          builder: (context, AsyncSnapshot snapshot) {
            List<PecasEspecieModel> _pecasEspecie = snapshot.data ?? [];

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return Container(
                height: 500,
                child: ListView.builder(
                  itemCount: _pecasEspecie.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Padding(padding: EdgeInsets.only(left: 10)),
                          // CheckboxComponent(),
                          Expanded(
                            child: Text(
                              _pecasEspecie[index].id_peca_especie.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                              // textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            child:
                                Text(_pecasEspecie[index].especie.toString()),
                          ),
                          Expanded(
                            child: Text(Situacao
                                .values[_pecasEspecie[index].situacao!].name),
                          ),
                          Expanded(
                            child: Text(
                                _pecasEspecie[index].linha!.linha.toString()),
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
                                            EspecieDetailView(
                                                pecasEspecieModel:
                                                    _pecasEspecie[index]))
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
                                      // _pecasEspecieController.excluir(_pecasEspecie[index]).then((value) => setState(() {}));
                                      excluir(context, _pecasEspecie[index])
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
