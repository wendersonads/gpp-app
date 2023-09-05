// ignore_for_file: must_be_immutable

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/controllers/enderecamento_controller.dart';

import 'package:gpp/src/models/box_enderecamento_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/CurrencyPtBrInputFormatter.dart';
import 'package:gpp/src/shared/utils/ImprimirQrCodeBox.dart';

import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/enderecamento/und_medida_box.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class CadastroBoxViewDesktop extends StatefulWidget {
  String? idPrateleira;
  CadastroBoxViewDesktop({this.idPrateleira});

  @override
  _CadastroBoxViewState createState() => _CadastroBoxViewState();
}

class _CadastroBoxViewState extends State<CadastroBoxViewDesktop> {
  //late EnderecamentoPrateleiraController controller;
  String? idEstante;

  late EnderecamentoController enderecamentoController;

  UnidadeMedidaBox? _selectedUnidadeMedidaBox = UnidadeMedidaBox.Centimetros;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;

  buscarTodos(String idPrateleira) async {
    try {
      enderecamentoController.listaBox = await enderecamentoController.buscarBox(idPrateleira);
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

  handleCreate(context, BoxEnderecamentoModel boxEnderecamentoModel, String idPrateleira) async {
    setState(() {
      loading = true;
    });
    try {
      if (await enderecamentoController.criarBox(boxEnderecamentoModel, idPrateleira)) {
        Notificacao.snackBar('Box adicionado com sucesso!');
        buscarTodos(widget.idPrateleira.toString());
        Get.offAllNamed("/prateleira/${idPrateleira}/boxes");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
    setState(() {
      loading = false;
    });
  }

  handleDelete(context, BoxEnderecamentoModel boxEnderecamentoModel) async {
    try {
      if (await Notificacao.confirmacao("você deseja excluir o Box?")) {
        if (await enderecamentoController.excluirBox(widget.idPrateleira.toString(), boxEnderecamentoModel)) {
          // Navigator.pop(context); //volta para tela anterior

          Notificacao.snackBar("Box excluído!");
          Get.offAllNamed("/box/${widget.idPrateleira.toString()}");
          //Atualiza a lista de motivos
        }
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  handleEdit(context, BoxEnderecamentoModel editaBox) async {
    try {
      if (await enderecamentoController.editar()) {
        Notificacao.snackBar("Box editada com sucesso!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  getQrCode(data, BoxEnderecamentoModel boxEnderecamento) {
    Get.dialog(
      AlertDialog(
        content: Container(
          height: Get.height * .5,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: data,
                  width: 200,
                  height: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Endereço: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(boxEnderecamento.endereco ?? ''),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonComponent(
                        color: vermelhoColor,
                        colorHover: vermelhoColorHover,
                        onPressed: () {
                          Get.back();
                        },
                        text: 'Cancelar',
                      ),
                      Padding(padding: EdgeInsets.only(right: 8)),
                      ButtonComponent(
                        onPressed: () async {
                          await ImprimirQrCodeBox(idBox: data, boxEnderecamento: boxEnderecamento).imprimirQrCode();
                        },
                        text: 'Imprimir',
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  openForm(context, BoxEnderecamentoModel boxEnderecamentoModel) {
    MediaQueryData media = MediaQuery.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Cadastro de Box"),
              insetPadding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              actions: <Widget>[
                Container(
                  width: media.size.width * 0.50,
                  // height: media.size.height * 0.80,
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 6,
                                child: InputComponent(
                                  label: 'Box',
                                  hintText: 'Digite o nome do Box',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'A descrição é obrigatória';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    boxEnderecamentoModel.desc_box = value;
                                  },
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(right: 30)),
                              Flexible(
                                flex: 2,
                                child: InputComponent(
                                  label: 'Prateleira',
                                  initialValue: boxEnderecamentoModel.id_prateleira.toString(),
                                  hintText: 'Digite a Prateleira',
                                  enable: false,
                                  onSaved: (value) {
                                    boxEnderecamentoModel.id_prateleira.toString();
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Row(
                            children: [
                              Flexible(
                                child: InputComponent(
                                  label: 'Altura',
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyPtBrInputFormatter(),
                                    LengthLimitingTextInputFormatter(5)
                                  ],
                                  hintText: '00,00',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'A altura é obrigatória';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value == '')
                                      boxEnderecamentoModel.altura = 00.00;
                                    else
                                      boxEnderecamentoModel.altura = double.parse(value.replaceAll(',', '.'));
                                  },
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(right: 30)),
                              Flexible(
                                child: InputComponent(
                                  label: 'Largura',
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyPtBrInputFormatter(),
                                    LengthLimitingTextInputFormatter(5)
                                  ],
                                  hintText: '00,00',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'A largura é obrigatória';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value == '')
                                      boxEnderecamentoModel.largura = 00.00;
                                    else
                                      boxEnderecamentoModel.largura = double.parse(value.replaceAll(',', '.'));
                                  },
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(right: 30)),
                              Flexible(
                                child: InputComponent(
                                  label: 'Profundidade',
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyPtBrInputFormatter(),
                                    LengthLimitingTextInputFormatter(5)
                                  ],
                                  hintText: '00,00',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'A profundidade é obrigatória';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value == '')
                                      boxEnderecamentoModel.profundidade = 00.00;
                                    else
                                      boxEnderecamentoModel.profundidade = double.parse(value.replaceAll(',', '.'));
                                  },
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(right: 30)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextComponent('Und. Medida'),
                                  Padding(padding: EdgeInsets.only(top: 6)),
                                  Container(
                                    padding: EdgeInsets.only(left: 12, right: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<UnidadeMedidaBox>(
                                        value: UnidadeMedidaBox.values[_selectedUnidadeMedidaBox!.index],
                                        onChanged: (UnidadeMedidaBox? value) {
                                          setState(() {
                                            _selectedUnidadeMedidaBox = value;
                                            boxEnderecamentoModel.unidade_medida = value!.index;
                                          });
                                        },
                                        items: UnidadeMedidaBox.values.map((UnidadeMedidaBox? unidadeMedidaBox) {
                                          return DropdownMenuItem<UnidadeMedidaBox>(
                                              value: unidadeMedidaBox, child: Text(unidadeMedidaBox!.name));
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                                          if (formKey.currentState!.validate()) {
                                            formKey.currentState!.save();

                                            if (boxEnderecamentoModel.unidade_medida == null) {
                                              boxEnderecamentoModel.unidade_medida = _selectedUnidadeMedidaBox!.index;
                                            }
                                            await handleCreate(
                                                context, enderecamentoController.boxModel, widget.idPrateleira.toString());

                                            formKey.currentState!.reset();
                                          }
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
                )
              ],
            );
          },
        );
      },
    );
  }

  openFormEdit(context, BoxEnderecamentoModel boxEnderecamentoModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Cadastro de Box"),
              insetPadding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 6,
                            child: InputComponent(
                              label: 'Box',
                              initialValue: boxEnderecamentoModel.desc_box,
                              hintText: 'Digite o nome do Box',
                              onChanged: (value) {
                                setState(() {
                                  boxEnderecamentoModel.desc_box.toString();
                                });
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 30)),
                          Flexible(
                            flex: 2,
                            child: InputComponent(
                              label: 'Prateleira',
                              initialValue: boxEnderecamentoModel.id_prateleira.toString(),
                              hintText: 'Digite a Prateleira',
                              enable: false,
                              onChanged: (value) {
                                setState(() {
                                  boxEnderecamentoModel.id_prateleira.toString();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Row(
                        children: [
                          Flexible(
                            child: InputComponent(
                              label: 'Altura',
                              hintText: 'Digite a altura',
                              onChanged: (value) {
                                setState(() {
                                  boxEnderecamentoModel.altura.toString();
                                });
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 30)),
                          Flexible(
                            child: InputComponent(
                              label: 'Largura',
                              hintText: 'Digite a largura',
                              onChanged: (value) {
                                setState(() {
                                  boxEnderecamentoModel.largura.toString();
                                });
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 30)),
                          Flexible(
                            child: InputComponent(
                              label: 'Profundidade',
                              hintText: 'Digite a profundidade',
                              onChanged: (value) {
                                setState(() {
                                  boxEnderecamentoModel.profundidade.toString();
                                });
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 30)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextComponent('Und. Medida'),
                              Padding(padding: EdgeInsets.only(top: 6)),
                              Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<UnidadeMedidaBox>(
                                    value: UnidadeMedidaBox.values[_selectedUnidadeMedidaBox!.index],
                                    onChanged: (UnidadeMedidaBox? value) {
                                      setState(() {
                                        _selectedUnidadeMedidaBox = value;

                                        boxEnderecamentoModel.unidade_medida = value!.index;
                                      });
                                    },
                                    items: UnidadeMedidaBox.values.map((UnidadeMedidaBox? unidadeMedidaBox) {
                                      return DropdownMenuItem<UnidadeMedidaBox>(
                                          value: unidadeMedidaBox, child: Text(unidadeMedidaBox!.name));
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
                                color: secundaryColor,
                                colorHover: secundaryColorHover,
                                onPressed: () {
                                  handleEdit(context, boxEnderecamentoModel);
                                },
                                text: 'Alterar')
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
    buscarTodos(widget.idPrateleira.toString());
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
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
                          Flexible(child: TitleComponent('Boxes')),
                          ButtonComponent(
                              onPressed: () {
                                enderecamentoController.boxModel.id_prateleira = int.parse(widget.idPrateleira.toString());
                                openForm(context, enderecamentoController.boxModel);
                              },
                              text: 'Adicionar')
                        ],
                      ),
                    ),
                    enderecamentoController.isLoaded
                        ? Expanded(
                            child: Container(
                              child: ListView.builder(
                                itemCount: enderecamentoController.listaBox.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: CardWidget(
                                        widget: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Expanded(child: const TextComponent('Box', fontWeight: FontWeight.bold)),
                                            const Expanded(child: const TextComponent('Altura', fontWeight: FontWeight.bold)),
                                            const Expanded(child: const TextComponent('Largura', fontWeight: FontWeight.bold)),
                                            const Expanded(
                                                child: const TextComponent('Profundidade', fontWeight: FontWeight.bold)),
                                            const Expanded(
                                                child: const TextComponent('Und. Medida', fontWeight: FontWeight.bold)),
                                            const Expanded(child: const TextComponent('Opções', fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SelectableText(enderecamentoController.listaBox[index].desc_box.toString()),
                                            ),
                                            Expanded(
                                              child: SelectableText(enderecamentoController.listaBox[index].altura == null
                                                  ? ''
                                                  : enderecamentoController.listaBox[index].altura.toString()),
                                            ),
                                            Expanded(
                                              child: SelectableText(enderecamentoController.listaBox[index].largura == null
                                                  ? ''
                                                  : enderecamentoController.listaBox[index].largura.toString()),
                                            ),
                                            Expanded(
                                              child: SelectableText(enderecamentoController.listaBox[index].profundidade == null
                                                  ? ''
                                                  : enderecamentoController.listaBox[index].profundidade.toString()),
                                            ),
                                            Expanded(
                                              child: SelectableText(enderecamentoController.listaBox[index].unidade_medida == null
                                                  ? ''
                                                  : enderecamentoController.listaBox[index].unidade_medida == 0
                                                      ? UnidadeMedidaBox.Milimetros.name
                                                      : enderecamentoController.listaBox[index].unidade_medida == 1
                                                          ? UnidadeMedidaBox.Centimetros.name
                                                          : enderecamentoController.listaBox[index].unidade_medida == 2
                                                              ? UnidadeMedidaBox.Metros.name
                                                              : enderecamentoController.listaBox[index].unidade_medida == 3
                                                                  ? UnidadeMedidaBox.Polegadas.name
                                                                  : ''),
                                            ),
                                            // IconButton(
                                            //   icon: Icon(
                                            //     Icons.edit,
                                            //     color: Colors.grey.shade400,
                                            //   ),
                                            //   onPressed: () {
                                            //     openFormEdit(
                                            //         context,
                                            //         enderecamentoController
                                            //             .listaBox[index]);
                                            //   },
                                            // ),
                                            Expanded(
                                                child: ButtonAcaoWidget(
                                              qrCode: () {
                                                getQrCode(enderecamentoController.listaBox[index].id_box.toString(),
                                                    enderecamentoController.listaBox[index]);
                                              },
                                              deletar: () {
                                                handleDelete(context, enderecamentoController.listaBox[index]);
                                              },
                                            ))
                                          ],
                                        )
                                      ],
                                    )),
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
