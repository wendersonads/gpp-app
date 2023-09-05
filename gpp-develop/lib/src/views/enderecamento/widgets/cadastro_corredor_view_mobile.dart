import 'package:flutter/material.dart';

import 'package:gpp/src/controllers/enderecamento_controller.dart';

import 'package:gpp/src/models/corredor_enderecamento_model.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CadastroCorredorViewMobile extends StatefulWidget {
  String? idPiso;
  CadastroCorredorViewMobile({this.idPiso});

  // int id;

  //CadastroCorredorView({ Key? key, required this.id } ) : super(key: key);
  // const CadastroCorredorView({Key? key}) : super(key: key);

  @override
  _CadastroCorredorViewState createState() => _CadastroCorredorViewState();
}

class _CadastroCorredorViewState extends State<CadastroCorredorViewMobile> {
  //late EnderecamentoCorredorController controller;
  // String? idPiso;

  late EnderecamentoController enderecamentoController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;

  buscarTodos(String idPiso) async {
    try {
      enderecamentoController.listaCorredor = await enderecamentoController.buscarCorredor(idPiso);
      if (mounted) {
        setState(() {
          enderecamentoController.isLoaded = true;
        });
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
      enderecamentoController.listaCorredor = [];
      if (mounted) {
        setState(() {
          enderecamentoController.isLoaded = true;
        });
      }
    }
  }

  handleCreate(context, CorredorEnderecamentoModel corredor, String idPiso) async {
    setState(() {
      loading = true;
    });
    try {
      if (await enderecamentoController.criarCorredor(corredor, idPiso)) {
        Get.offAllNamed("/piso/${idPiso}/corredores");
        buscarTodos(widget.idPiso.toString());
        Notificacao.snackBar('Corredor adicionado com sucesso!');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
    setState(() {
      loading = false;
    });
  }

  handleDelete(context, CorredorEnderecamentoModel excluiCorredor) async {
    try {
      if (await Notificacao.confirmacao("Você deseja excluir o corredor?")) {
        if (await enderecamentoController.repository.excluirCorredor(widget.idPiso.toString(), excluiCorredor)) {
          // Navigator.pop(context); //volta para tela anterior
          Notificacao.snackBar("Corredor excluído!");
          buscarTodos(widget.idPiso.toString());

          //Atualiza a lista de motivos
        }
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  handleEdit(context, CorredorEnderecamentoModel editaCorredor) async {
    try {
      if (await enderecamentoController.editar()) {
        Notificacao.confirmacao("Corredor editado com sucesso!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  openForm(context, CorredorEnderecamentoModel corredorEnderecamentoReplacement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Cadastro do Corredor"),
                  ],
                ),
                content: SingleChildScrollView(
                  controller: new ScrollController(),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          InputComponent(
                            label: 'Corredor',
                            hintText: 'Digite o nome do Corredor',
                            onSaved: (value) {
                              corredorEnderecamentoReplacement.desc_corredor = value!;
                            },
                          ),
                          InputComponent(
                            label: 'Piso',
                            initialValue: corredorEnderecamentoReplacement.id_piso.toString(),
                            hintText: 'Digite o piso',
                            enable: false,
                            onSaved: (value) {
                              corredorEnderecamentoReplacement.id_piso.toString();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                !loading
                                    ? ButtonComponent(
                                        color: secundaryColor,
                                        colorHover: secundaryColorHover,
                                        onPressed: () async {
                                          formKey.currentState!.save();
                                          formKey.currentState!.reset();
                                          await handleCreate(
                                              context, enderecamentoController.corredorModel, widget.idPiso.toString());
                                        },
                                        text: 'Adicionar',
                                      )
                                    : const LoadingComponent(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          },
        );
      },
    );
  }

  openFormEdit(context, CorredorEnderecamentoModel corredorEnderecamentoReplacement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Cadastro do Piso"),
              // pisoEnderecamentoReplacement.id_piso == null

              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      InputComponent(
                        label: 'Piso',
                        initialValue: corredorEnderecamentoReplacement.desc_corredor,
                        hintText: 'Digite o nome do Piso',
                        onChanged: (value) {
                          corredorEnderecamentoReplacement.desc_corredor.toString();
                        },
                      ),
                      InputComponent(
                        label: 'Filial',
                        initialValue: corredorEnderecamentoReplacement.id_corredor.toString(),
                        hintText: 'Digite a filial',
                        onChanged: (value) {
                          corredorEnderecamentoReplacement.id_corredor.toString();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Row(
                          children: [
                            //  pisoEnderecamentoReplacement.id_piso == null
                            ButtonComponent(
                                color: secundaryColor,
                                colorHover: secundaryColorHover,
                                onPressed: () {
                                  handleEdit(context, corredorEnderecamentoReplacement);
                                  // handleEdit(context);
                                  // Navigator.pop(context);
                                  // context,
                                  //           enderecamentoController.listaPiso[index],
                                },
                                text: 'Alterar')
                            // :ButtonComponent(
                            //     color: Colors.red,
                            //     onPressed: () {
                            //       handleCreate(context, pisoEnderecamentoReplacement);
                            //     },
                            //     text: 'Cancelar')
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
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
    enderecamentoController = EnderecamentoController();
    // corredorEnderecamentoModel = widget.corredorEnderecamentoModel;
    //Quando o widget for inserido na árvore chama o buscarTodos
    buscarTodos(widget.idPiso.toString());
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(child: const TitleComponent('Corredores')),
                          ButtonComponent(
                              onPressed: () {
                                enderecamentoController.corredorModel.id_piso = int.parse(widget.idPiso.toString());
                                openForm(context, enderecamentoController.corredorModel);
                              },
                              text: 'Adicionar')
                        ],
                      ),
                    ),
                    enderecamentoController.isLoaded
                        ? Container(
                            height: media.size.height * 0.5,
                            child: ListView.builder(
                              itemCount: enderecamentoController.listaCorredor.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CardWidget(
                                      widget: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Expanded(
                                              child: const TextComponent(
                                            'Corredor',
                                            fontWeight: FontWeight.bold,
                                          )),
                                          const Expanded(
                                              child: const TextComponent(
                                            'Ações',
                                            fontWeight: FontWeight.bold,
                                          )),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SelectableText(
                                                enderecamentoController.listaCorredor[index].desc_corredor.toString()),
                                          ),
                                          Expanded(
                                            child: Row(
                                              //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                ButtonComponent(
                                                    onPressed: () {
                                                      Get.toNamed(
                                                          '/corredor/${enderecamentoController.listaCorredor[index].id_corredor.toString()}/estantes');
                                                    },
                                                    text: 'Estante'),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(child: ButtonAcaoWidget(
                                                  deletar: () {
                                                    handleDelete(
                                                      context,
                                                      enderecamentoController.listaCorredor[index],
                                                    );
                                                  },
                                                )),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                                );
                              },
                            ),
                          )
                        : const LoadingComponent()
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
