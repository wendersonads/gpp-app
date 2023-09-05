// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/departament_controller.dart';

import 'package:gpp/src/models/departament_model.dart';
import 'package:gpp/src/repositories/DepartamentoRepository.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/status_component.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/enumeration/departament_enum.dart';
import 'package:gpp/src/shared/repositories/styles.dart';

import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/departamentos/view/departamento_form_view.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class DepartamentosMobile extends StatefulWidget {
  const DepartamentosMobile({Key? key}) : super(key: key);

  @override
  _DepartamentosMobileState createState() => _DepartamentosMobileState();
}

class _DepartamentosMobileState extends State<DepartamentosMobile> {
  late final DepartamentController _controller = DepartamentController(DepartamentoRepository());

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
    //         DepartamentFormView(
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
      if (await Notificacao.confirmacao('Você deseja excluir essa departamento?')) {
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
        return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: CardWidget(
              widget: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            TextComponent(
                              'Código',
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              '#${_controller.departaments[index].idDepartamento.toString()}',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            TextComponent(
                              'Nome',
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                '${_controller.departaments[index].nome.toString()}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      TextComponent(
                        'Status',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      StatusComponent(status: _controller.departaments[index].situacao!),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => exibirFormDepartamento(departamentoModel: _controller.departaments[index]),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => handleDelete(context, _controller.departaments[index]),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                Icons.delete_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }

  Container _buildStatus(bool status) {
    print(status);
    if (status) {
      return Container(
        height: 20,
        width: 60,
        decoration: BoxDecoration(
          color: secundaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
              ),
        ),
        child: Center(
          child: Text(
            "Ativo",
            style: textStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      );
    } else {
      return Container(
        height: 20,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
              ),
        ),
        child: Center(
          child: Text(
            "Inativo",
            style: textStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700),
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
            return SingleChildScrollView(
              child: AlertDialog(
                  title: DepartamentoFormView(
                departamentoModel: departamentoModel,
              )),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Departamentos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  ButtonComponent(
                      onPressed: () {
                        exibirFormDepartamento();
                      },
                      text: 'Adicionar')
                ],
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: _controller.state == DepartamentEnum.changeDepartament ? _buildList() : LoadingComponent(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
