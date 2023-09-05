import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/enderecamento_controller.dart';
import 'package:gpp/src/models/piso_enderecamento_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/services/auth.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:get/get.dart';

class CadastroPisoViewMobile extends StatefulWidget {
  const CadastroPisoViewMobile({Key? key}) : super(key: key);

  @override
  _CadastroPisoViewState createState() => _CadastroPisoViewState();
}

class _CadastroPisoViewState extends State<CadastroPisoViewMobile> {
//  late AddressingFloorController controller;
  late EnderecamentoController enderecamentoController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;

  buscarTodos() async {
    try {
      enderecamentoController.listaPiso = await enderecamentoController.buscarTodos(getFilial().id_filial!);
      if (mounted) {
        setState(() {
          enderecamentoController.isLoaded = true;
        });
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
      enderecamentoController.listaPiso = [];
      if (mounted) {
        setState(() {
          enderecamentoController.isLoaded = true;
        });
      }
    }
  }

  handleCreate(context, PisoEnderecamentoModel piso) async {
    setState(() {
      loading = true;
    });
    try {
      if (await enderecamentoController.repository.criar(piso)) {
        await buscarTodos();
        Get.offAllNamed('/enderecamentos');
        Notificacao.snackBar('Piso adicionado com sucesso!');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
    setState(() {
      loading = false;
    });
  }

  handleDelete(context, PisoEnderecamentoModel excluiPiso) async {
    try {
      if (await Notificacao.confirmacao("Você deseja excluir o piso?")) {
        if (await enderecamentoController.repository.excluir(excluiPiso)) {
          Notificacao.snackBar("Piso excluído!");
          //Atualiza a lista de motivos
          buscarTodos();
        }
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  //  handleEdit(context) async {
  //   NotifyController notify = NotifyController(context: context);
  //   try {
  //     if (await enderecamentoController.editar()) {
  //       notify.sucess("Piso editado com sucesso!");
  //     }
  //   } catch (e) {
  //     notify.error(e.toString());
  //   }
  // }

  handleEdit(context, PisoEnderecamentoModel editaPiso) async {
    try {
      if (await enderecamentoController.editar()) {
        Notificacao.snackBar("Piso editado com sucesso!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  openForm(context, PisoEnderecamentoModel pisoEnderecamentoReplacement) {
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
                    const Text("Cadastro do Piso"),
                  ],
                ),
                // pisoEnderecamentoReplacement.id_piso == null

                content: SingleChildScrollView(
                  controller: new ScrollController(),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          InputComponent(
                            label: 'Piso',
                            hintText: 'Digite o nome do Piso',
                            onSaved: (value) {
                              setState(() {
                                pisoEnderecamentoReplacement.desc_piso = value!;
                              });
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
                                //  pisoEnderecamentoReplacement.id_piso == null
                                !loading
                                    ? ButtonComponent(
                                        onPressed: () async {
                                          formKey.currentState!.save();
                                          formKey.currentState!.reset();
                                          await handleCreate(context, pisoEnderecamentoReplacement);
                                        },
                                        text: 'Adicionar',
                                      )
                                    : const LoadingComponent()
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

  openFormEdit(context, PisoEnderecamentoModel pisoEnderecamentoReplacement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Cadastro do Piso"),
              // pisoEnderecamentoReplacement.id_piso == null

              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      InputComponent(
                        label: 'Piso',
                        initialValue: pisoEnderecamentoReplacement.desc_piso,
                        hintText: 'Digite o nome do Piso',
                        onChanged: (value) {
                          setState(() {
                            pisoEnderecamentoReplacement.desc_piso.toString();
                          });
                        },
                      ),
                      InputComponent(
                        label: 'Filial',
                        initialValue: pisoEnderecamentoReplacement.id_filial.toString(),
                        hintText: 'Digite a filial',
                        onChanged: (value) {
                          setState(() {
                            pisoEnderecamentoReplacement.id_filial.toString();
                          });
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
                                onPressed: () {
                                  handleEdit(context, pisoEnderecamentoReplacement);
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
    //controller = AddressingFloorController();
    enderecamentoController = EnderecamentoController();
    //Quando o widget for inserido na árvore chama o buscarTodos
    buscarTodos();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          Expanded(
            flex: 4,
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
                          const Flexible(child: const TitleComponent('Pisos')),
                          (enderecamentoController.listaPiso.length < 1)
                              ? ButtonComponent(
                                  onPressed: () {
                                    openForm(context, enderecamentoController.pisoModel);
                                  },
                                  text: 'Adicionar',
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    enderecamentoController.isLoaded
                        ? Expanded(
                            child: Container(
                              child: ListView.builder(
                                itemCount: enderecamentoController.listaPiso.length,
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
                                                'Piso',
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
                                                child:
                                                    SelectableText(enderecamentoController.listaPiso[index].desc_piso.toString()),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    ButtonComponent(
                                                      onPressed: () {
                                                        Get.toNamed(
                                                            '/piso/${enderecamentoController.listaPiso[index].id_piso.toString()}/corredores');
                                                      },
                                                      text: 'Corredor',
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: ButtonAcaoWidget(
                                                        deletar: () {
                                                          handleDelete(
                                                            context,
                                                            enderecamentoController.listaPiso[index],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
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
