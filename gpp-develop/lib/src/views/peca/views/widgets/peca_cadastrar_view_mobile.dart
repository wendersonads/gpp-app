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
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class PecaCadastrarViewMobile extends StatefulWidget {
  int? idProduto;
  PecaCadastrarViewMobile({this.idProduto, Key? key}) : super(key: key);

  @override
  _PecaCadastrarViewState createState() => _PecaCadastrarViewState();
}

class _PecaCadastrarViewState extends State<PecaCadastrarViewMobile> {
  late final GlobalKey<FormState> formKeyPecas = GlobalKey<FormState>(debugLabel: "FormKey");

  @override
  void initState() {
    super.initState();

    final controller = Get.put(PecaCadastrarController());
    controller.txtIdProduto.text = widget.idProduto != null ? widget.idProduto.toString() : '';

    if (widget.idProduto != null) {
      controller.buscaProduto(controller.txtIdProduto.text);
    } else {
      controller.limparCampos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PecaCadastrarController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
          child: Form(
            key: formKeyPecas,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextComponent(
                      'Cadastrar peças',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InputComponent(
                        controller: controller.txtIdProduto,
                        keyboardType: TextInputType.number,
                        hintText: 'ID',
                        label: 'ID Produto',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            if (controller.txtIdProduto.text == null || controller.txtIdProduto.text == '') {
                              Notificacao.snackBar('Digite o ID do produto!', tipoNotificacao: TipoNotificacaoEnum.error);
                            } else {
                              await controller.buscaProduto(controller.txtIdProduto.text);
                            }
                          },
                          icon: const Icon(Icons.search),
                        ),
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            Notificacao.snackBar('Infomar o produto é obrigatório', tipoNotificacao: TipoNotificacaoEnum.error);
                          }
                        },
                        onFieldSubmitted: (value) async {
                          if (value.isEmpty) {
                            formKeyPecas.currentState!.reset();
                          } else {
                            await controller.buscaProduto(controller.txtIdProduto.text);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      flex: 1,
                      child: InputComponent(
                        label: 'Nome Produto',
                        controller: controller.txtNomeProduto,
                        enable: false,
                        hintText: 'Nome do Produto',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InputComponent(
                        label: 'ID Fornecedor',
                        controller: controller.txtIdFornecedor,
                        enable: false,
                        keyboardType: TextInputType.number,
                        hintText: 'ID',
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),

                    Flexible(
                      flex: 1,
                      child: InputComponent(
                        label: 'Nome Fornecedor',
                        controller: controller.txtNomeFornecedor,
                        enable: false,
                        hintText: 'Nome do Fornecedor',
                      ),
                    ),

                    // Fim Fornecedor
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextComponent(
                      'Informações da peça',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: InputComponent(
                          label: 'Nome da Peça',
                          onChanged: (value) {
                            controller.pecasController.pecasModel.descricao = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'A descrição da peça é obrigatória';
                            }
                            return null;
                          },
                          hintText: 'Digite o nome da peça',
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      flex: 1,
                      child: InputComponent(
                        label: 'Quantidade',
                        hintText: 'Digite a Quantidade',
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onSaved: (value) {
                          controller.pecasController.produtoPecaModel.quantidadePorProduto = int.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InputComponent(
                        label: 'Número',
                        hintText: 'Digite o Número',
                        onSaved: (value) {
                          controller.pecasController.pecasModel.numero = value;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      flex: 1,
                      child: InputComponent(
                        label: 'Código de Fábrica',
                        hintText: 'Código de Fábrica',
                        onSaved: (value) {
                          controller.pecasController.pecasModel.codigo_fabrica = value;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: InputComponent(
                        label: 'Custo R\$',
                        inputFormatter: [FilteringTextInputFormatter.digitsOnly, CurrencyPtBrInputFormatter()],
                        hintText: '00,00',
                        prefixText: 'R\$ ',
                        onSaved: (value) {
                          if (value == '')
                            controller.pecasController.pecasModel.custo = 0;
                          else
                            controller.pecasController.pecasModel.custo =
                                (double.parse(value.replaceAll('.', '').replaceAll(',', '.')));
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      flex: 1,
                      child: InputComponent(
                        label: 'Cor',
                        onSaved: (value) {
                          controller.pecasController.pecasModel.cor = value.toString();
                        },
                        hintText: 'Marrom',
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextComponent(
                            'Unidade',
                            fontWeight: FontWeight.bold,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<UnidadeTipo>(
                                      value: UnidadeTipo.values[controller.selectedUnidadeTipo!.index],
                                      onChanged: (UnidadeTipo? value) {
                                        setState(() {
                                          controller.selectedUnidadeTipo = value;

                                          controller.pecasController.pecasModel.unidade = value!.index;
                                        });
                                      },
                                      items: UnidadeTipo.values.map((UnidadeTipo? unidadeTipo) {
                                        return DropdownMenuItem<UnidadeTipo>(
                                            value: unidadeTipo,
                                            child: Text(
                                              unidadeTipo!.name,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14 * context.textScaleFactor),
                                            ));
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InputComponent(
                        label: 'Volumes',
                        hintText: 'Digite os vols',
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onSaved: (value) {
                          controller.pecasController.pecasModel.volumes = value.toString();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      flex: 1,
                      child: InputComponent(
                        label: 'Material',
                        onSaved: (value) {
                          controller.pecasController.pecasModel.material = value.toString();
                        },
                        hintText: 'MDF 15MM',
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextComponent(
                      'Medidas',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
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
                              controller.pecasController.pecasModel.largura = 00.00;
                            else
                              controller.pecasController.pecasModel.largura = double.parse(value.replaceAll(',', '.'));
                          }),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      flex: 1,
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
                              controller.pecasController.pecasModel.altura = 00.00;
                            else
                              controller.pecasController.pecasModel.altura = double.parse(value.replaceAll(',', '.'));
                          }),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextComponent(
                            'Und. Medida',
                            fontWeight: FontWeight.bold,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<UnidadeMedida>(
                                      value: UnidadeMedida.values[controller.selectedUnidadeMedida!.index],
                                      onChanged: (UnidadeMedida? value) {
                                        setState(() {
                                          controller.selectedUnidadeMedida = value;

                                          controller.pecasController.pecasModel.unidade_medida = value!.index;
                                        });
                                      },
                                      items: UnidadeMedida.values.map((UnidadeMedida? unidadeMedida) {
                                        return DropdownMenuItem<UnidadeMedida>(
                                            value: unidadeMedida,
                                            child: Text(unidadeMedida!.name,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14 * context.textScaleFactor)));
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
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
                              controller.pecasController.pecasModel.profundidade = 00.00;
                            else
                              controller.pecasController.pecasModel.profundidade = double.parse(value.replaceAll(',', '.'));
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            width: 82,
            child: Obx(
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
          ),
          SizedBox(
            width: 24,
          )
        ],
      ),
    );
  }
}
