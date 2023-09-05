// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/CurrencyPtBrInputFormatter.dart';

import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/peca/controller/peca_cadastrar_controller.dart';
import 'package:gpp/src/views/pecas/und_medida.dart';
import 'package:gpp/src/views/pecas/unidade.dart';

class PecaCadastrarViewDesktop extends StatefulWidget {
  int? idProduto;
  PecaCadastrarViewDesktop({this.idProduto, Key? key}) : super(key: key);

  @override
  _PecaCadastrarViewState createState() => _PecaCadastrarViewState();
}

class _PecaCadastrarViewState extends State<PecaCadastrarViewDesktop> {
  late final GlobalKey<FormState> formKeyPecas =
      GlobalKey<FormState>(debugLabel: "FormKey");

  @override
  void initState() {
    super.initState();

    final controller = Get.put(PecaCadastrarController());
    controller.txtIdProduto.text =
        widget.idProduto != null ? widget.idProduto.toString() : '';

    if (widget.idProduto != null) {
      controller.buscaProduto(controller.txtIdProduto.text);
    } else {
      controller.limparCampos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PecaCadastrarController());

    // controller.txtIdProduto.text = '42182';
    //controller.txtIdProduto.text = widget.idProduto != null ? widget.idProduto.toString() : '';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      height: context.height,
      child: SingleChildScrollView(
        child: Form(
          key: formKeyPecas,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    //const TitleComponent('Cadastrar Peças'),
                    SelectableText(
                      'Cadastrar peças',
                      style: textStyleTitulo,
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'ID do Produto',
                              style: textStyleTexto,
                            ),
                            Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 35)),
                  Flexible(
                    flex: 4,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Fornecedor',
                              style: textStyleTexto,
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                      ],
                    ),
                  )
                ],
              ),

              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: InputComponent(
                        controller: controller.txtIdProduto,
                        keyboardType: TextInputType.number,
                        hintText: 'ID',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            if (controller.txtIdProduto.text == null ||
                                controller.txtIdProduto.text == '') {
                              Notificacao.snackBar('Digite o ID do produto!',
                                  tipoNotificacao: TipoNotificacaoEnum.error);
                            } else {
                              await controller
                                  .buscaProduto(controller.txtIdProduto.text);
                            }
                          },
                          icon: const Icon(Icons.search),
                        ),
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            Notificacao.snackBar(
                                'Infomar o produto é obrigatório',
                                tipoNotificacao: TipoNotificacaoEnum.error);
                          }
                        },
                        onFieldSubmitted: (value) async {
                          if (value.isEmpty) {
                            formKeyPecas.currentState!.reset();
                          } else {
                            await controller
                                .buscaProduto(controller.txtIdProduto.text);
                          }
                        },
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 10)),
                  Flexible(
                    flex: 5,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: InputComponent(
                        controller: controller.txtNomeProduto,
                        enable: false,
                        hintText: 'Nome Produto',
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 30)),
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: InputComponent(
                        controller: controller.txtIdFornecedor,
                        enable: false,
                        keyboardType: TextInputType.number,
                        hintText: 'ID',
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 10)),
                  Flexible(
                    flex: 5,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: InputComponent(
                        controller: controller.txtNomeFornecedor,
                        enable: false,
                        hintText: 'Nome Fornecedor',
                      ),
                    ),
                  ),
                  // Fim Fornecedor
                ],
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    //const TitleComponent('Cadastrar Peças'),
                    SelectableText(
                      'Informações da peça',
                      style: textStyleTitulo,
                    )
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                children: [
                  Flexible(
                      flex: 6,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Descrição da Peça',
                                style: textStyleTexto,
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          InputComponent(
                            onChanged: (value) {
                              controller.pecasController.pecasModel.descricao =
                                  value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'A descrição da peça é obrigatória';
                              }
                              return null;
                            },
                            hintText: 'Digite o nome da peça',
                          )
                        ],
                      )),
                  const Padding(padding: EdgeInsets.only(right: 30)),
                  Flexible(
                    flex: 1,
                    child: InputComponent(
                      label: 'Quantidade',
                      hintText: 'Digite a quantidade',
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onSaved: (value) {
                        controller.pecasController.produtoPecaModel
                            .quantidadePorProduto = int.parse(value);
                      },
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: InputComponent(
                      label: 'Número',
                      hintText: 'Digite o número',
                      onSaved: (value) {
                        controller.pecasController.pecasModel.numero = value;
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 30)),
                  Flexible(
                    flex: 1,
                    child: InputComponent(
                      label: 'ID de Fabrica',
                      hintText: 'Digite o ID',
                      onSaved: (value) {
                        controller.pecasController.pecasModel.codigo_fabrica =
                            value;
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 30)),
                  Flexible(
                    flex: 1,
                    child: InputComponent(
                      label: 'Custo R\$',
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyPtBrInputFormatter()
                      ],
                      hintText: '00,00',
                      prefixText: 'R\$ ',
                      onSaved: (value) {
                        if (value == '')
                          controller.pecasController.pecasModel.custo = 0;
                        else
                          controller.pecasController.pecasModel.custo =
                              (double.parse(value
                                  .replaceAll('.', '')
                                  .replaceAll(',', '.')));
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 30)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const TextComponent('Unidade'),
                      const Padding(padding: EdgeInsets.only(top: 6)),
                      Container(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<UnidadeTipo>(
                            value: UnidadeTipo
                                .values[controller.selectedUnidadeTipo!.index],
                            onChanged: (UnidadeTipo? value) {
                              setState(() {
                                controller.selectedUnidadeTipo = value;

                                controller.pecasController.pecasModel.unidade =
                                    value!.index;
                              });
                            },
                            items: UnidadeTipo.values
                                .map((UnidadeTipo? unidadeTipo) {
                              return DropdownMenuItem<UnidadeTipo>(
                                  value: unidadeTipo,
                                  child: Text(unidadeTipo!.name));
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              // Padding(padding: EdgeInsets.only(top: 30)),

              // Divider(),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Flexible(
                    child: InputComponent(
                      label: 'Volumes',
                      hintText: 'Digite os volumes',
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onSaved: (value) {
                        controller.pecasController.pecasModel.volumes =
                            value.toString();
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 30)),
                  Flexible(
                    child: InputComponent(
                      label: 'Cor',
                      onSaved: (value) {
                        controller.pecasController.pecasModel.cor =
                            value.toString();
                      },
                      hintText: 'Marrom',
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 30)),
                  Flexible(
                    child: InputComponent(
                      label: 'Material',
                      onSaved: (value) {
                        controller.pecasController.pecasModel.material =
                            value.toString();
                      },
                      hintText: 'MDF 15MM',
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    //const TitleComponent('Cadastrar Peças'),
                    SelectableText(
                      'Medidas',
                      style: textStyleTitulo,
                    )
                  ],
                ),
              ),

              const Padding(padding: EdgeInsets.only(bottom: 30)),
              Row(
                children: [
                  Flexible(
                    child: InputComponent(
                        label: 'Largura',
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyPtBrInputFormatter(),
                          LengthLimitingTextInputFormatter(5)
                        ],
                        hintText: '00,00',
                        onSaved: (value) {
                          if (value == '')
                            controller.pecasController.pecasModel.largura =
                                00.00;
                          else
                            controller.pecasController.pecasModel.largura =
                                double.parse(value.replaceAll(',', '.'));
                        }),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 30)),
                  Flexible(
                    child: InputComponent(
                        label: 'Altura',
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyPtBrInputFormatter(),
                          LengthLimitingTextInputFormatter(5)
                        ],
                        hintText: '00,00',
                        onSaved: (value) {
                          if (value == '')
                            controller.pecasController.pecasModel.altura =
                                00.00;
                          else
                            controller.pecasController.pecasModel.altura =
                                double.parse(value.replaceAll(',', '.'));
                        }),
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
                        onSaved: (value) {
                          if (value == '')
                            controller.pecasController.pecasModel.profundidade =
                                00.00;
                          else
                            controller.pecasController.pecasModel.profundidade =
                                double.parse(value.replaceAll(',', '.'));
                        }),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 30)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const TextComponent('Und. Medida'),
                      const Padding(padding: EdgeInsets.only(top: 6)),
                      Container(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<UnidadeMedida>(
                            value: UnidadeMedida.values[
                                controller.selectedUnidadeMedida!.index],
                            onChanged: (UnidadeMedida? value) {
                              setState(() {
                                controller.selectedUnidadeMedida = value;

                                controller.pecasController.pecasModel
                                    .unidade_medida = value!.index;
                              });
                            },
                            items: UnidadeMedida.values
                                .map((UnidadeMedida? unidadeMedida) {
                              return DropdownMenuItem<UnidadeMedida>(
                                  value: unidadeMedida,
                                  child: Text(unidadeMedida!.name));
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 60)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () => controller.carregandoCadastroPeca == true
                        ? LoadingComponent()
                        : ButtonComponent(
                            color: secundaryColor,
                            colorHover: secundaryColorHover,
                            onPressed: () async {
                              if (formKeyPecas.currentState!.validate()) {
                                formKeyPecas.currentState!.save();

                                await controller.InserirDados();
                                formKeyPecas.currentState!.reset();
                              }
                            },
                            text: 'Salvar',
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
