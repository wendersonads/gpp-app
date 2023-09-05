import 'package:flutter/material.dart';

import 'package:gpp/src/controllers/subfuncionalities_controller.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/utils/notificacao.dart';

// ignore: must_be_immutable
class SubFuncionalitiesFormView extends StatefulWidget {
  String id;
  SubFuncionalitiesFormView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _SubFuncionalitiesFormViewState createState() =>
      _SubFuncionalitiesFormViewState();
}

class _SubFuncionalitiesFormViewState extends State<SubFuncionalitiesFormView> {
  SubFuncionalitiesController _controller = SubFuncionalitiesController();

  handleCreate() async {
    try {
      if (await _controller.create(widget.id)) {
        Notificacao.snackBar("Subfuncionalidade cadastrado!");
        Navigator.pushReplacementNamed(context, '/funcionalities');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          key: _controller.formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: TitleComponent('Cadastrar Subfuncionalidade'),
                ),
                InputComponent(
                  label: "Nome",
                  onChanged: (value) {
                    _controller.subFuncionalitie.nome = value;
                  },
                  validator: (value) {
                    _controller.validate(value);
                  },
                  hintText: "Digite o nome da funcionalidade",
                  prefixIcon: Icon(Icons.lock),
                ),
                SizedBox(
                  height: 8,
                ),
                InputComponent(
                  label: "Rota",
                  onChanged: (value) {
                    _controller.subFuncionalitie.rota = value;
                  },
                  validator: (value) {
                    _controller.validate(value);
                  },
                  hintText: "Digite a rota da subfuncionalidade",
                  prefixIcon: Icon(Icons.lock),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Radio(
                        activeColor: secundaryColor,
                        value: true,
                        groupValue: _controller.subFuncionalitie.situacao,
                        onChanged: (bool? value) {
                          setState(() {
                            _controller.subFuncionalitie.situacao = value;
                          });
                        }),
                    Text("Ativo"),
                    Radio(
                        activeColor: secundaryColor,
                        value: false,
                        groupValue: _controller.subFuncionalitie.situacao,
                        onChanged: (bool? value) {
                          setState(() {
                            _controller.subFuncionalitie.situacao = value;
                          });
                        }),
                    Text("Inativo"),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    children: [
                      ButtonComponent(
                        onPressed: () {
                          handleCreate();
                        },
                        text: 'Adicionar',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
