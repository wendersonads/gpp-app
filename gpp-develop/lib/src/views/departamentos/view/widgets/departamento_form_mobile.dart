import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/controllers/departament_controller.dart';
import 'package:gpp/src/models/departament_model.dart';

import 'package:gpp/src/repositories/DepartamentoRepository.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/utils/notificacao.dart';

class DepartamentoFormMobile extends StatefulWidget {
  final DepartamentoModel? departamentoModel;

  DepartamentoFormMobile({this.departamentoModel, Key? key}) : super(key: key);

  @override
  State<DepartamentoFormMobile> createState() => _DepartamentoFormMobile();
}

class _DepartamentoFormMobile extends State<DepartamentoFormMobile> {
  late DepartamentController _controller;

  criar() async {
    try {
      if (await _controller.create()) {
        Navigator.pop(context);
        Get.offAllNamed('/departamentos');
        _controller.fetchAll();
        Notificacao.snackBar("Departamento cadastrado!",
            tipoNotificacao: TipoNotificacaoEnum.sucesso);
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
        Notificacao.snackBar("Departamento atualizado!",
            tipoNotificacao: TipoNotificacaoEnum.sucesso);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  bottom: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.departamentoModel != null
                        ? Text(
                            "Editar Departamento",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            "Cadastrar Departamento",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
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
              Row(
                children: [
                  Radio(
                      activeColor: secundaryColor,
                      value: true,
                      groupValue: widget.departamentoModel?.situacao ??
                          _controller.departament.situacao,
                      onChanged: (bool? value) {
                        setState(() {
                          if (widget.departamentoModel?.situacao == null) {
                            _controller.departament.situacao = value;
                          } else {
                            widget.departamentoModel?.situacao = value;
                          }
                        });
                      }),
                  Text(
                    "Habilitado",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Radio(
                      activeColor: secundaryColor,
                      value: false,
                      groupValue: widget.departamentoModel?.situacao ??
                          _controller.departament.situacao,
                      onChanged: (bool? value) {
                        setState(() {
                          if (widget.departamentoModel?.situacao == null) {
                            _controller.departament.situacao = value;
                          } else {
                            widget.departamentoModel?.situacao = value;
                          }
                        });
                      }),
                  Text(
                    "Inativo",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (widget.departamentoModel == null) {
                            criar();
                          } else {
                            editar();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: secundaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            child: widget.departamentoModel != null
                                ? Text(
                                    "Alterar",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    "Cadastrar",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
