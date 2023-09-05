import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/pecas_controller/pecas_cor_controller.dart';
import 'package:gpp/src/models/pecas_model/pecas_cor_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/pecas/situacao.dart';

// ignore: must_be_immutable
class CoresDetailView extends StatefulWidget {
  PecasCorModel? pecaCor;

  CoresDetailView({this.pecaCor});

  @override
  _CoresDetailViewState createState() => _CoresDetailViewState();
}

class _CoresDetailViewState extends State<CoresDetailView> {
  PecasCorController _pecasCorController = PecasCorController();
  PecasCorModel? pecaCor;

  @override
  void initState() {
    pecaCor = widget.pecaCor;
    if (pecaCor != null) {
      _pecasCorController.pecasCorModel = pecaCor!;
    }

    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  create(context) async {
    try {
      if (await _pecasCorController.create()) {
        Notificacao.snackBar("Cor cadastrada com sucesso!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  editar(context) async {
    try {
      if (await _pecasCorController.editar()) {
        Notificacao.snackBar("Cor editada com sucesso!");
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
            Icon(pecaCor == null ? Icons.add_box : Icons.edit),
            Padding(padding: EdgeInsets.only(right: 12)),
            TitleComponent(pecaCor == null ? 'Cadastrar Cores' : 'Editar Cor'),
          ],
        ),
      ),
      Divider(),
      Padding(padding: EdgeInsets.only(bottom: 20)),
      Column(
        children: [
          pecaCor == null
              ? Container()
              : Row(
                  children: [
                    Flexible(
                      child: InputComponent(
                        enable: false,
                        initialValue: pecaCor!.id_peca_cor.toString(),
                        label: 'ID',
                        onChanged: (value) {
                          _pecasCorController.pecasCorModel.id_peca_cor = value;
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 30)),
                    DropdownButton<Situacao>(
                        value: Situacao.values[pecaCor!.situacao!],
                        onChanged: (Situacao? newValue) {
                          setState(() {
                            pecaCor?.situacao = newValue!.index;
                            _pecasCorController.pecasCorModel.situacao =
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
            children: [
              Flexible(
                child: InputComponent(
                  initialValue: pecaCor == null ? '' : pecaCor!.cor,
                  label: 'Cor',
                  onChanged: (value) {
                    _pecasCorController.pecasCorModel.cor = value;
                  },
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 30)),
              Flexible(
                child: InputComponent(
                  initialValue: pecaCor == null ? '' : pecaCor?.sigla,
                  label: 'Sigla',
                  onChanged: (value) {
                    _pecasCorController.pecasCorModel.sigla = value;
                    _pecasCorController.pecasCorModel.situacao =
                        1; // situacao por padrão vai ativa
                  },
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 30)),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              pecaCor == null
                  ? ButtonComponent(
                      onPressed: () {
                        create(context);
                      },
                      text: 'Salvar',
                    )
                  : Row(
                      children: [
                        ButtonComponent(
                          onPressed: () {
                            editar(context);
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
    ]);
  }
}
