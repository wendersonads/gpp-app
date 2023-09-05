import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/controllers/departament_controller.dart';
import 'package:gpp/src/models/departament_model.dart';

import 'package:gpp/src/repositories/DepartamentoRepository.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/utils/notificacao.dart';

// ignore: must_be_immutable
class DepartamentoFormDesktop extends StatefulWidget {
  DepartamentoModel? departamentoModel;

  DepartamentoFormDesktop({this.departamentoModel, Key? key}) : super(key: key);

  @override
  State<DepartamentoFormDesktop> createState() => _DepartamentoFormDesktop();
}

class _DepartamentoFormDesktop extends State<DepartamentoFormDesktop> {
  late DepartamentController _controller;

  criar() async {
    try {
      if (await _controller.create()) {
        Navigator.pop(context);
        Get.offAllNamed('/departamentos');
        _controller.fetchAll();
        Notificacao.snackBar("Departamento cadastrado!", tipoNotificacao: TipoNotificacaoEnum.sucesso);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  editar() async {
    try {
      _controller.departament = widget.departamentoModel!;
      if (await _controller.update()) {
        Navigator.pop(context);
        Get.offAllNamed('/departamentos');
        _controller.fetchAll();
        Notificacao.snackBar("Departamento atualizado!", tipoNotificacao: TipoNotificacaoEnum.sucesso);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _controller = DepartamentController(DepartamentoRepository());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          key: _controller.formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: widget.departamentoModel != null
                      ? Text("Editar Departamento", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                      : Text("Cadastrar Departamento", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                InputComponent(
                  label: "Nome",
                  initialValue: widget.departamentoModel?.nome ?? '',
                  onChanged: (value) {
                    if (widget.departamentoModel == null) {
                      _controller.departament.nome = value;
                    } else {
                      widget.departamentoModel!.nome = value;
                    }
                  },
                  validator: (value) {
                    _controller.validate(value);
                  },
                  hintText: "Digite o nome do departamento",
                  prefixIcon: Icon(Icons.lock),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: [
                      Radio(
                          activeColor: secundaryColor,
                          value: true,
                          groupValue: widget.departamentoModel?.situacao ?? _controller.departament.situacao,
                          onChanged: (bool? value) {
                            setState(() {
                              if (widget.departamentoModel?.situacao == null) {
                                _controller.departament.situacao = value;
                              } else {
                                widget.departamentoModel?.situacao = value;
                              }
                            });
                          }),
                      Text("Habilitado"),
                      Radio(
                          activeColor: secundaryColor,
                          value: false,
                          groupValue: widget.departamentoModel?.situacao ?? _controller.departament.situacao,
                          onChanged: (bool? value) {
                            setState(() {
                              if (widget.departamentoModel?.situacao == null) {
                                _controller.departament.situacao = value;
                              } else {
                                widget.departamentoModel?.situacao = value;
                              }
                            });
                          }),
                      Text("Inativo"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.departamentoModel == null) {
                            criar();
                          } else {
                            editar();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(color: secundaryColor, borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 25, bottom: 15, right: 25),
                            child: widget.departamentoModel != null
                                ? Text(
                                    "Alterar",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "Cadastrar",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
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
