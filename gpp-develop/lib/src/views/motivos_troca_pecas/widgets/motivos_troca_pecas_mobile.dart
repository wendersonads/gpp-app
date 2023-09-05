import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/controllers/MotivoTrocaPecaController.dart';
import 'package:gpp/src/models/motivo_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/components/status_component.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';

import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class MotivosTrocaPecasMobile extends StatefulWidget {
  const MotivosTrocaPecasMobile({Key? key}) : super(key: key);

  @override
  _MotivosTrocaPecasMobileState createState() => _MotivosTrocaPecasMobileState();
}

class _MotivosTrocaPecasMobileState extends State<MotivosTrocaPecasMobile> {
  late MotivoTrocaPecaController controller;

  fetchAll() async {
    try {
      //Notifica a tela para atualizar os dados
      setState(() {
        controller.carregando = true;
      });
      controller.motivos.clear();
      //Carrega lista de motivos de defeito de peças
      controller.motivos = await controller.repository.buscarTodos();
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      //Notifica a tela para atualizar os dados
      setState(() {
        controller.carregando = false;
      });
    }
  }

  handleDelete(context, MotivoModel reasonPartsReplacement) async {
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (await Notificacao.confirmacao("você deseja excluir o motivo de troca de peça ?")) {
        if (await controller.repository.excluir(reasonPartsReplacement)) {
          Notificacao.snackBar('Motivo de troca de peça excluido com sucesso !');
          //Atualiza a lista de motivos
          fetchAll();
        }
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  handleCreate(context, MotivoModel reasonPartsReplacement) async {
    try {
      if (await controller.repository.create(reasonPartsReplacement)) {
        Navigator.pop(context);
        fetchAll();
        Notificacao.snackBar('Motivo de peça adicionado com sucesso!');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  handleUpdate(context, MotivoModel reasonPartsReplacement) async {
    try {
      if (await controller.repository.update(reasonPartsReplacement)) {
        Navigator.pop(context);
        fetchAll();
        Notificacao.snackBar('Motivo de peça atualizado com sucesso!');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  openForm(context, MotivoModel reasonPartsReplacement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                  title: reasonPartsReplacement.idMotivo == null
                      ? Text("Adicionar motivo de troca de peça")
                      : Text("Atualizar motivo de troca de peça"),
                  content: Column(
                    children: [
                      new Text("preencha as informações abaixo"),
                      InputComponent(
                        label: 'Nome',
                        initialValue: reasonPartsReplacement.nome,
                        hintText: 'Digite o motivo da troca de peça',
                        onChanged: (value) {
                          setState(() {
                            reasonPartsReplacement.nome = value!;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Radio(
                                activeColor: secundaryColor,
                                value: true,
                                groupValue: reasonPartsReplacement.situacao,
                                onChanged: (bool? value) {
                                  setState(() {
                                    reasonPartsReplacement.situacao = value!;
                                  });
                                }),
                            Text("Ativo"),
                            Radio(
                                activeColor: secundaryColor,
                                value: false,
                                groupValue: reasonPartsReplacement.situacao,
                                onChanged: (bool? value) {
                                  setState(() {
                                    reasonPartsReplacement.situacao = value!;
                                  });
                                }),
                            Flexible(
                              child: new Text("Inativo"),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          reasonPartsReplacement.idMotivo == null
                              ? ButtonComponent(
                                  onPressed: () {
                                    handleCreate(context, reasonPartsReplacement);
                                  },
                                  text: 'Adicionar')
                              : ButtonComponent(
                                  onPressed: () {
                                    handleUpdate(context, reasonPartsReplacement);
                                  },
                                  text: 'Atualizar'),
                          SizedBox(
                            width: 8,
                          ),
                          ButtonComponent(
                              color: Colors.red,
                              onPressed: () {
                                Get.back();
                              },
                              text: 'Cancelar')
                        ],
                      )
                    ],
                  )),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //Iniciliza controlador
    controller = MotivoTrocaPecaController();
    //Quando o widget for inserido na árvore chama o fetchAll
    fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: TextComponent(
                    'Motivos de troca de peças',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
                  ButtonComponent(
                      onPressed: () {
                        openForm(context, controller.motivo);
                      },
                      text: 'Adicionar')
                ],
              ),
            ),
            !controller.carregando
                ? Expanded(
                    child: ListView.builder(
                        // padding: EdgeInsets.all(8.0),
                        itemCount: controller.motivos.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: CardWidget(
                              widget: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: TextComponent('ID', fontWeight: FontWeight.bold)),
                                      Expanded(
                                          child: SelectableText('#${controller.motivos[index].idMotivo.toString()}',
                                              textAlign: TextAlign.end)),
                                    ],
                                  ),
                                  Divider(color: Colors.grey.shade200, height: 50, thickness: 2),
                                  Row(
                                    children: [
                                      Expanded(child: TextComponent('Motivo', fontWeight: FontWeight.bold)),
                                      Expanded(child: SelectableText(controller.motivos[index].nome!, textAlign: TextAlign.end)),
                                    ],
                                  ),
                                  Divider(color: Colors.grey.shade200, height: 50, thickness: 2),
                                  Row(
                                    children: [
                                      Expanded(child: TextComponent('Status', fontWeight: FontWeight.bold)),
                                      Expanded(
                                          child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [StatusComponent(status: controller.motivos[index].situacao!)],
                                      )),
                                    ],
                                  ),
                                  Divider(color: Colors.grey.shade200, height: 50, thickness: 2),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(child: TextComponent('Opções', fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ButtonAcaoWidget(
                                              editar: () {
                                                openForm(context, controller.motivos[index]);
                                              },
                                              deletar: () {
                                                Get.closeAllSnackbars();
                                                handleDelete(context, controller.motivos[index]);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }))
                : Center(child: LoadingComponent())
          ],
        ),
      ),
    );
  }
}
