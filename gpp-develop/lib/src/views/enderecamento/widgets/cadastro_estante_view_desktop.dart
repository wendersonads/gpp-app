import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/controllers/enderecamento_controller.dart';

import 'package:gpp/src/models/estante_enderecamento_model.dart';
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

// ignore: must_be_immutable
// ignore: must_be_immutable
class CadastroEstanteViewDesktop extends StatefulWidget {
  String? idCorredor;
  CadastroEstanteViewDesktop({this.idCorredor});

  // int id;

  //CadastroEstanteView({ Key? key, required this.id } ) : super(key: key);

  //const CadastroEstanteView({Key? key}) : super(key: key);

  @override
  _CadastroEstanteViewState createState() => _CadastroEstanteViewState();
}

class _CadastroEstanteViewState extends State<CadastroEstanteViewDesktop> {
  //late EnderecamentoEstanteController controller;
  String? idCorredor;

  late EnderecamentoController enderecamentoController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;

  buscarTodos(String idCorredor) async {
    try {
      enderecamentoController.listaEstante = await enderecamentoController
          .repository
          .buscarEstante(int.parse(idCorredor));
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

  handleCreate(context, EstanteEnderecamentoModel estanteEnderecamentoModel,
      String idCorredor) async {
    setState(() {
      loading = true;
    });
    try {
      if (await enderecamentoController.criarEstante(
          estanteEnderecamentoModel, idCorredor)) {
        Get.offAllNamed("/corredor/${idCorredor}/estantes");
        Notificacao.snackBar('Estante adicionada com sucesso!');
        buscarTodos(widget.idCorredor.toString());
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
    setState(() {
      loading = false;
    });
  }

  handleDelete(
      context, EstanteEnderecamentoModel estanteEnderecamentoModel) async {
    try {
      if (await Notificacao.confirmacao("você deseja excluir a estante?")) {
        if (await enderecamentoController.excluirEstante(
            widget.idCorredor.toString(), estanteEnderecamentoModel)) {
          // Navigator.pop(context); //volta para tela anterior

          buscarTodos(widget.idCorredor.toString());
          Notificacao.snackBar("Estante excluída!");
          //Atualiza a lista de motivos
        }
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  handleEdit(context, EstanteEnderecamentoModel editaEstante) async {
    try {
      if (await enderecamentoController.editar()) {
        Notificacao.snackBar("Estante editada com sucesso!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  openForm(context, EstanteEnderecamentoModel estanteEnderecamentoReplacement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Cadastro da Estante"),
              actions: <Widget>[
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        InputComponent(
                          label: 'Estante',
                          hintText: 'Digite o nome da Estante',
                          onSaved: (value) {
                            estanteEnderecamentoReplacement.desc_estante =
                                value!;
                          },
                        ),
                        InputComponent(
                          label: 'Corredor',
                          initialValue: estanteEnderecamentoReplacement
                              .id_corredor
                              .toString(),
                          enable: false,
                          onSaved: (value) {
                            estanteEnderecamentoReplacement.id_corredor
                                .toString();
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
                              !loading
                                  ? ButtonComponent(
                                      color: secundaryColor,
                                      colorHover: secundaryColorHover,
                                      onPressed: () async {
                                        formKey.currentState!.save();
                                        formKey.currentState!.reset();
                                        await handleCreate(
                                            context,
                                            enderecamentoController
                                                .estanteModel,
                                            widget.idCorredor.toString());
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
                )
              ],
            );
          },
        );
      },
    );
  }

  openFormEdit(
      context, EstanteEnderecamentoModel estanteEnderecamentoReplacement) {
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
                        initialValue:
                            estanteEnderecamentoReplacement.desc_estante,
                        hintText: 'Digite o nome do Piso',
                        onChanged: (value) {
                          setState(() {
                            estanteEnderecamentoReplacement.desc_estante
                                .toString();
                          });
                        },
                      ),
                      InputComponent(
                        label: 'Filial',
                        initialValue: estanteEnderecamentoReplacement.id_estante
                            .toString(),
                        hintText: 'Digite a estante',
                        onChanged: (value) {
                          setState(() {
                            estanteEnderecamentoReplacement.id_estante
                                .toString();
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
                                color: secundaryColor,
                                colorHover: secundaryColorHover,
                                onPressed: () {
                                  handleEdit(
                                      context, estanteEnderecamentoReplacement);
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
    // controller = EnderecamentoEstanteController();
    enderecamentoController = EnderecamentoController();
    //Quando o widget for inserido na árvore chama o buscarTodos
    buscarTodos(widget.idCorredor.toString());
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      body: Row(
        children: [
          Sidebar(),
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
                          const Flexible(
                              child: const TitleComponent('Estantes')),
                          ButtonComponent(
                              onPressed: () {
                                enderecamentoController
                                        .estanteModel.id_corredor =
                                    int.parse(widget.idCorredor.toString());
                                openForm(context,
                                    enderecamentoController.estanteModel);
                              },
                              text: 'Adicionar')
                        ],
                      ),
                    ),
                    enderecamentoController.isLoaded
                        ? Container(
                            height: media.size.height * 0.5,
                            child: ListView.builder(
                              itemCount:
                                  enderecamentoController.listaEstante.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CardWidget(
                                      widget: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Expanded(
                                              child: const TextComponent(
                                                  'Estante',
                                                  fontWeight: FontWeight.bold)),
                                          const Expanded(
                                              child: const TextComponent(
                                                  'Ações',
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SelectableText(
                                                enderecamentoController
                                                    .listaEstante[index]
                                                    .desc_estante
                                                    .toString()),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                ButtonComponent(
                                                    onPressed: () {
                                                      Get.toNamed(
                                                          '/estante/${enderecamentoController.listaEstante[index].id_estante.toString()}/prateleiras');
                                                    },
                                                    text: 'Prateleira'),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: ButtonAcaoWidget(
                                                    deletar: () {
                                                      handleDelete(
                                                          context,
                                                          enderecamentoController
                                                                  .listaEstante[
                                                              index]);
                                                    },
                                                  ),
                                                )
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
