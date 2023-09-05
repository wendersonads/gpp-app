import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/controllers/entrada/movimento_entrada_controller.dart';
import 'package:gpp/src/models/entrada/movimento_entrada_model.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:intl/intl.dart';

class EntradaHistoricoViewMobile extends StatefulWidget {
  const EntradaHistoricoViewMobile({Key? key}) : super(key: key);

  @override
  _EntradaHistoricoViewState createState() => _EntradaHistoricoViewState();
}

class _EntradaHistoricoViewState extends State<EntradaHistoricoViewMobile> {
  late MovimentoEntradaController movimentoEntradaController;
  String? id_filial = null;

  @override
  void initState() {
    movimentoEntradaController = MovimentoEntradaController();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        controller: new ScrollController(),
        child: Column(children: [
          FutureBuilder(
            future: movimentoEntradaController.buscarTodos(id_filial),
            builder: (BuildContext context,
                AsyncSnapshot<List<MovimentoEntradaModel>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Sem conexão!');
                case ConnectionState.waiting:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: LoadingComponent(),
                      ),
                    ],
                  );
                case ConnectionState.active:
                  return Text('');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else {
                    return Container(
                      height: media.height * 2,
                      child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: CardWidget(
                                widget: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  //.
                                                  TextComponent(
                                                    'Data de Entrada',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: TextComponent(
                                                'Situação',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: TextComponent(
                                                'Ações',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  TextComponent(
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(snapshot
                                                                .data?[index]
                                                                .data_entrada ??
                                                            DateTime.now()),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                child: TextComponent(
                                              snapshot.data?[index].situacao
                                                      .toString()
                                                      .split('.')
                                                      .last ??
                                                  '',
                                            )),
                                            Expanded(
                                              child: ButtonAcaoWidget(
                                                detalhe: () {
                                                  Get.toNamed(
                                                      '/ordens-entrada/historico/' +
                                                          snapshot.data![index]
                                                              .id_movimento_entrada
                                                              .toString());
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  }
              }
            },
          ),
        ]),
      ),
    );
  }
}
