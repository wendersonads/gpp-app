import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/pecas_controller/pecas_cor_controller.dart';
import 'package:gpp/src/models/pecas_model/pecas_cor_model.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/pecas/situacao.dart';

import 'pop_up_editar.dart';
import 'cores_detail_view.dart';

class CoresListView extends StatefulWidget {
  const CoresListView({Key? key}) : super(key: key);

  @override
  _CoresListViewState createState() => _CoresListViewState();
}

class _CoresListViewState extends State<CoresListView> {
  PecasCorController _pecasCorController = PecasCorController();

  @override
  initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  Future<bool> excluir(context, PecasCorModel pecasCorModel) async {
    try {
      if (await Notificacao.confirmacao(
          'Deseja excluir a cor (${pecasCorModel.id_peca_cor} - ${pecasCorModel.cor})?')) {
        if (await _pecasCorController.excluir(pecasCorModel)) {
          Notificacao.snackBar("Cor excluída com sucesso!");
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
                      'Cores',
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
              child: TextComponent('Cor'),
            ),
            Expanded(
              child: TextComponent('Sigla'),
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
          future: _pecasCorController.buscarTodos(),
          builder: (context, AsyncSnapshot snapshot) {
            List<PecasCorModel> _pecaCor = snapshot.data ?? [];

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return Container(
                height: 500,
                child: ListView.builder(
                  itemCount: _pecaCor.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Padding(padding: EdgeInsets.only(left: 10)),
                          // CheckboxComponent(),
                          Expanded(
                            child: Text(
                              _pecaCor[index].id_peca_cor.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                              // textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            child: Text(_pecaCor[index].cor.toString()),
                          ),
                          Expanded(
                            child: Text(_pecaCor[index].sigla.toString()),
                          ),
                          Expanded(
                            child: Text(Situacao
                                .values[_pecaCor[index].situacao!].name),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.grey.shade400,
                                    ),
                                    tooltip: 'Editar',
                                    onPressed: () {
                                      PopUpEditar.popUpPeca(
                                              context,
                                              CoresDetailView(
                                                  pecaCor: _pecaCor[index]))
                                          .then((value) => setState(() {}));
                                    }),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.grey.shade400,
                                    ),
                                    tooltip: 'Excluir',
                                    onPressed: () {
                                      excluir(context, _pecaCor[index])
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
