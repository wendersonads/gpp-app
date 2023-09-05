import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/controllers/enderecamento_controller.dart';
import 'package:gpp/src/models/prateleira_enderecamento_model.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

// ignore: must_be_immutable
class CadastroPrateleiraViewDesktop extends StatefulWidget {
  String? idEstante;
  CadastroPrateleiraViewDesktop({this.idEstante});

  // int id;

  //CadastroCorredorView({ Key? key, required this.id } ) : super(key: key);
  //const CadastroPrateleiraView({Key? key}) : super(key: key);

  @override
  _CadastroPrateleiraViewState createState() => _CadastroPrateleiraViewState();
}

class _CadastroPrateleiraViewState
    extends State<CadastroPrateleiraViewDesktop> {
  //late EnderecamentoPrateleiraController controller;
  String? idEstante;

  late EnderecamentoController enderecamentoController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  buscarTodos(String idEstante) async {
    try {
      enderecamentoController.listaPrateleira = await enderecamentoController
          .repository
          .buscarPrateleira(int.parse(idEstante));
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

  handleCreate(
      context,
      PrateleiraEnderecamentoModel prateleiraEnderecamentoModel,
      String idEstante) async {
    try {
      if (await enderecamentoController.criarPrateleira(
          prateleiraEnderecamentoModel, idEstante)) {
        Get.offAllNamed("/estante/${idEstante}/prateleiras");
        buscarTodos(widget.idEstante.toString());
        Notificacao.snackBar('Prateleira adicionada com sucesso!');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  handleDelete(context,
      PrateleiraEnderecamentoModel prateleiraEnderecamentoModel) async {
    try {
      if (await Notificacao.confirmacao("você deseja excluir a prateleira?")) {
        if (await enderecamentoController
            .excluirPrateleira(prateleiraEnderecamentoModel)) {
          // Navigator.pop(context); //volta para tela anterior
          buscarTodos(widget.idEstante.toString());
          Notificacao.snackBar("Prateleira excluída!");
          //Atualiza a lista de motivos
        }
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  handleEdit(context, PrateleiraEnderecamentoModel editaEstante) async {
    try {
      if (await enderecamentoController.editar()) {
        Notificacao.snackBar("Prateleira editada com sucesso!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  openForm(context,
      PrateleiraEnderecamentoModel prateleiraEnderecamentoReplacement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: prateleiraEnderecamentoReplacement.id_prateleira == null
                  ? Text("Cadastro da Prateleira")
                  : Text("Atualizar motivo de troca de peça"),
              actions: <Widget>[
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        InputComponent(
                          label: 'Prateleira',
                          hintText: 'Digite o nome da Prateleira',
                          onSaved: (value) {
                            prateleiraEnderecamentoReplacement.desc_prateleira =
                                value!;
                          },
                        ),
                        InputComponent(
                          label: 'Estante',
                          initialValue: prateleiraEnderecamentoReplacement
                              .id_estante
                              .toString(),
                          hintText: 'Digite a Estante',
                          enable: false,
                          onSaved: (value) {
                            prateleiraEnderecamentoReplacement.id_estante
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
                              ButtonComponent(
                                  onPressed: () async {
                                    formKey.currentState!.save();
                                    formKey.currentState!.reset();
                                    await handleCreate(
                                        context,
                                        enderecamentoController.prateleiraModel,
                                        widget.idEstante.toString());
                                  },
                                  text: 'Adicionar')
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

  openFormEdit(context,
      PrateleiraEnderecamentoModel prateleiraEnderecamentoReplacement) {
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
                            prateleiraEnderecamentoReplacement.desc_prateleira,
                        hintText: 'Digite o nome do Piso',
                        onChanged: (value) {
                          setState(() {
                            prateleiraEnderecamentoReplacement.desc_prateleira
                                .toString();
                          });
                        },
                      ),
                      InputComponent(
                        label: 'Filial',
                        initialValue: prateleiraEnderecamentoReplacement
                            .id_prateleira
                            .toString(),
                        hintText: 'Digite a estante',
                        onChanged: (value) {
                          setState(() {
                            prateleiraEnderecamentoReplacement.id_prateleira
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
                                onPressed: () {
                                  handleEdit(context,
                                      prateleiraEnderecamentoReplacement);
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
    // controller = EnderecamentoPrateleiraController();
    enderecamentoController = EnderecamentoController();
    //Quando o widget for inserido na árvore chama o buscarTodos
    buscarTodos(widget.idEstante.toString());
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
                              child: const TitleComponent('Prateleiras')),
                          ButtonComponent(
                              onPressed: () {
                                enderecamentoController
                                        .prateleiraModel.id_estante =
                                    int.parse(widget.idEstante.toString());
                                openForm(context,
                                    enderecamentoController.prateleiraModel);
                              },
                              text: 'Adicionar')
                        ],
                      ),
                    ),
                    enderecamentoController.isLoaded
                        ? Container(
                            height: media.size.height * 0.5,
                            child: ListView.builder(
                              itemCount: enderecamentoController
                                  .listaPrateleira.length,
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
                                                  'Prateleira',
                                                  fontWeight: FontWeight.bold)),
                                          const Expanded(
                                              child: const TextComponent(
                                                  'Opções',
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SelectableText(
                                                enderecamentoController
                                                    .listaPrateleira[index]
                                                    .desc_prateleira
                                                    .toString()),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                ButtonComponent(
                                                    onPressed: () {
                                                      Get.toNamed(
                                                          '/prateleira/${enderecamentoController.listaPrateleira[index].id_prateleira.toString()}/boxes');
                                                    },
                                                    text: 'Box'),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                    child: ButtonAcaoWidget(
                                                  deletar: () {
                                                    handleDelete(
                                                        context,
                                                        enderecamentoController
                                                                .listaPrateleira[
                                                            index]);
                                                  },
                                                ))
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
