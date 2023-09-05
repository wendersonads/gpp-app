// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/departament_controller.dart';

import 'package:gpp/src/models/departament_model.dart';
import 'package:gpp/src/repositories/DepartamentoRepository.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/status_component.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/enumeration/departament_enum.dart';
import 'package:gpp/src/shared/repositories/styles.dart';

import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/departamentos/view/departamento_form_view.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class DepartamentosDesktop extends StatefulWidget {
  const DepartamentosDesktop({Key? key}) : super(key: key);

  @override
  _DepartamentosDesktopState createState() => _DepartamentosDesktopState();
}

class _DepartamentosDesktopState extends State<DepartamentosDesktop> {
  late final DepartamentController _controller =
      DepartamentController(DepartamentoRepository());

  changeDepartments() async {
    try {
      setState(() {
        _controller.state = DepartamentEnum.loading;
      });

      await _controller.fetchAll();

      setState(() {
        _controller.state = DepartamentEnum.changeDepartament;
      });
    } catch (e) {
      Notificacao.snackBar(e.toString());
      setState(() {
        _controller.state = DepartamentEnum.changeDepartament;
      });
    }
  }

  handleCreate(context) async {
    bool? isCreate = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(actions: <Widget>[DepartamentoFormView()]);
        });

    if (isCreate != null && isCreate) {
      changeDepartments();
    }
  }

  handleEdit(context, DepartamentoModel departament) async {
    // bool? isEdit = await showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(actions: <Widget>[
    //         DepartamentoFormView(
    //           departament: departament,
    //         )
    //       ]);
    //     });

    // if (isEdit != null && isEdit) {
    //   changeDepartments();
    // }
  }

  handleDelete(context, DepartamentoModel departament) async {
    try {
      if (await Notificacao.confirmacao(
          'você deseja excluir essa departamento?')) {
        if (await _controller.delete(departament)) {
          Notificacao.snackBar("Departamento excluído!");
          changeDepartments();
        }
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  @override
  initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    changeDepartments();
  }

  Widget _buildList() {
    Widget widget = LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
            itemCount: _controller.departaments.length,
            itemBuilder: (context, index) {
              return _buildListItem(index, context);
            });
      },
    );

    return Container(color: Colors.white, child: widget);
  }

  Widget _buildListItem(int index, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: (index % 2) == 0 ? Colors.white : Colors.grey.shade50,
          child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: CardWidget(
                widget: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: TextComponent(
                          'Código do departamento',
                          fontWeight: FontWeight.bold,
                        )),
                        Expanded(
                            child: TextComponent(
                          'Nome',
                          fontWeight: FontWeight.bold,
                        )),
                        Expanded(
                            child: TextComponent('Status',
                                fontWeight: FontWeight.bold)),
                        Expanded(
                            child: TextComponent('Ações',
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: TextComponent(
                          '#${_controller.departaments[index].idDepartamento.toString()}',
                        )),
                        Expanded(
                            child: TextComponent(
                          '${_controller.departaments[index].nome.toString()}',
                        )),
                        Expanded(
                            child: Row(
                          children: [
                            StatusComponent(
                                status:
                                    _controller.departaments[index].situacao!)
                          ],
                        )),
                        Expanded(
                            child: ButtonAcaoWidget(
                          editar: () => exibirFormDepartamento(
                              departamentoModel:
                                  _controller.departaments[index]),
                          deletar: () => handleDelete(
                              context, _controller.departaments[index]),
                        ))
                      ],
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  Container _buildStatus(bool status) {
    if (status) {
      return Container(
        height: 20,
        width: 60,
        decoration: BoxDecoration(
          color: secundaryColor,
          borderRadius: BorderRadius.all(
              Radius.circular(10.0) //                 <--- border radius here
              ),
        ),
        child: Center(
          child: Text(
            "Ativo",
            style: textStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      );
    } else {
      return Container(
        height: 20,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
              Radius.circular(10.0) //                 <--- border radius here
              ),
        ),
        child: Center(
          child: Text(
            "Inativo",
            style: textStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }
  }

  // Widget _buildDepartaments() {
  //   switch (_controller.state) {
  //     case DepartamentEnum.loading:
  //       return const LoadingComponent();
  //     case DepartamentEnum.notDepartament:
  //       return Container();
  //     case DepartamentEnum.changeDepartament:
  //       return _buildList(_controller.departaments);
  //   }
  // }

  exibirFormDepartamento({DepartamentoModel? departamentoModel}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: DepartamentoFormView(
              departamentoModel: departamentoModel,
            ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TitleComponent('Departamentos'),
                          ButtonComponent(
                              onPressed: () {
                                exibirFormDepartamento();
                              },
                              text: 'Adicionar')
                        ],
                      ),
                    ),
                    Expanded(
                      child:
                          _controller.state == DepartamentEnum.changeDepartament
                              ? _buildList()
                              : LoadingComponent(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
