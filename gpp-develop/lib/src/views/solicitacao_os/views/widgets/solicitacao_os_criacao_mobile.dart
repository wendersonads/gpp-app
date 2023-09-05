import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/enums/categoria_de_imagens_enum.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:gpp/src/enums/solicitacao_os_categoria_troca_enum.dart';
import 'package:gpp/src/enums/solicitacao_os_complemento_enum.dart';
import 'package:gpp/src/models/solicitacao_os/checklist_os_model.dart';
import 'package:gpp/src/models/solicitacao_os/defeito_os_model.dart';
import 'package:gpp/src/models/solicitacao_os/digitalizacao_os_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/solicitacao_os/controllers/solicitacao_os_criacao_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:video_player/video_player.dart';

class SolicitacaoOSCriacaoMobile extends StatelessWidget {
  final controller = Get.find<SolicitacaoOSCriacaoController>();
  final isPlaying = false.obs;

  Widget _buildCamposIniciais(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: 32,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Criar Solicitação de OS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: InputComponent(
                label: 'Filial Origem',
                initialValue:
                    controller.solicitacao.value.filialOrigem.toString(),
                readOnly: true,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: InputComponent(
                label: 'Data Emissão',
                initialValue: DateFormat('dd/MM/yyyy').format(
                  controller.solicitacao.value.dataEmissao!,
                ),
                readOnly: true,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Focus(
                onFocusChange: (focus) {
                  if (!focus) {
                    controller.buscarFilialRetransferencia();
                  }
                },
                child: InputComponent(
                  label: 'Filial Destino',
                  keyboardType: TextInputType.number,
                  inputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (filialDestino) {
                    controller.solicitacao.update((value) {
                      value!.filialDestino = filialDestino;
                    });
                  },
                  onSaved: (filialDestino) {
                    controller.solicitacao.update((value) {
                      value!.filialDestino = filialDestino;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              // Por algum motivo, o InputComponent não funciona aqui. Por isso, foi usado o widget padrão do Flutter
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    'Filial Destino Retransf.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    height: 80,
                    child: TextFormField(
                      controller: controller.filialRetransfTextController,
                      readOnly: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14 * context.textScaleFactor,
                        letterSpacing: 0.15,
                        height: 2,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding:
                            EdgeInsets.only(top: 5, bottom: 10, left: 10),
                      ),
                      onSaved: (filialDestinoRetransf) {
                        controller.solicitacao.update((value) {
                          value!.filialDestinoRetransf = filialDestinoRetransf;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      'Componente OS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButtonHideUnderline(
                              child:
                                  DropdownButton<SolicitacaoOSComplementoEnum>(
                                value: SolicitacaoOSComplementoEnum.values[
                                    controller
                                        .solicitacao.value.complemento!.index],
                                items: SolicitacaoOSComplementoEnum.values.map<
                                        DropdownMenuItem<
                                            SolicitacaoOSComplementoEnum>>(
                                    (SolicitacaoOSComplementoEnum value) {
                                  return DropdownMenuItem<
                                      SolicitacaoOSComplementoEnum>(
                                    value: value,
                                    child: Text(value.name),
                                  );
                                }).toList(),
                                onChanged: (SolicitacaoOSComplementoEnum?
                                    complemento) {
                                  controller.solicitacao.update((value) {
                                    value!.complemento = complemento;

                                    // Reseta os campos de CRM, Categoria Troca
                                    // Nota de Venda, Nota de Troca e Digitalizações
                                    value.crm = null;
                                    value.filialSaidaVenda = null;
                                    value.numDocFiscalVenda = null;
                                    value.serieDocFiscalVenda = null;
                                    value.dataEmissaoVenda = null;
                                    value.filialSaidaTroca = null;
                                    value.numDocFiscalTroca = null;
                                    value.serieDocFiscalTroca = null;
                                    value.dataEmissaoTroca = null;

                                    // Complemento OS = Jurídico
                                    if (complemento?.value == 1) {
                                      value.digitalizacoes = [
                                        DigitalizacaoOSModel()
                                      ];
                                    } else {
                                      value.digitalizacoes = null;
                                    }

                                    // Complemento OS = Troca Consumidor OU Troca Central Cliente
                                    if (complemento?.value == 2 ||
                                        complemento?.value == 4) {
                                      value.categoriaTroca =
                                          SolicitacaoOSCategoriaTrocaEnum.TROCA;
                                    } else {
                                      value.categoriaTroca = null;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => controller.solicitacao.value.complemento?.value ==
                      2 // Complemento OS = Troca Consumidor
                  ||
                  controller.solicitacao.value.complemento?.value ==
                      4 // Complemento OS = Troca Central Cliente
              ? SizedBox(
                  height: 32,
                )
              : Container(),
        ),
        Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: controller.solicitacao.value.complemento?.value ==
                            2 // Complemento OS = Troca Consumidor
                        ||
                        controller.solicitacao.value.complemento?.value ==
                            4 // Complemento OS = Troca Central Cliente
                    ? InputComponent(
                        label: 'CRM',
                        onSaved: (crm) {
                          controller.solicitacao.update((value) {
                            value!.crm = crm;
                          });
                        },
                      )
                    : Container(),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: controller.solicitacao.value.complemento?.value ==
                            2 // Complemento OS = Troca Consumidor
                        ||
                        controller.solicitacao.value.complemento?.value ==
                            4 // Complemento OS = Troca Central Cliente
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            'Categoria Troca',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.solicitacao.value
                                              .complemento?.value ==
                                          4 // Complemento OS = Troca Central Cliente
                                      ? true
                                      : false,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<
                                          SolicitacaoOSCategoriaTrocaEnum>(
                                        value: SolicitacaoOSCategoriaTrocaEnum
                                                .values[
                                            controller.solicitacao.value
                                                .categoriaTroca!.index],
                                        items: SolicitacaoOSCategoriaTrocaEnum
                                            .values
                                            .map<
                                                    DropdownMenuItem<
                                                        SolicitacaoOSCategoriaTrocaEnum>>(
                                                (SolicitacaoOSCategoriaTrocaEnum
                                                    value) {
                                          return DropdownMenuItem<
                                              SolicitacaoOSCategoriaTrocaEnum>(
                                            value: value,
                                            child: Text(value.name),
                                          );
                                        }).toList(),
                                        onChanged:
                                            (SolicitacaoOSCategoriaTrocaEnum?
                                                categoriaTroca) {
                                          controller.solicitacao
                                              .update((value) {
                                            value!.categoriaTroca =
                                                categoriaTroca;

                                            // Reseta os campos de Nota de Troca
                                            value.filialSaidaTroca = null;
                                            value.numDocFiscalTroca = null;
                                            value.serieDocFiscalTroca = null;
                                            value.dataEmissaoTroca = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCamposNotaFiscalVenda() {
    return Obx(
      () => controller.solicitacao.value.complemento?.value ==
                  2 // Complemento OS = Troca Consumidor
              ||
              controller.solicitacao.value.complemento?.value ==
                  4 // Complemento OS = Troca Central Cliente
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 12,
                    bottom: 20,
                  ),
                  child: TextComponent(
                    'Nota Fiscal de Venda',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputComponent(
                        label: 'Filial Saída',
                        onSaved: (filialSaidaVenda) {
                          controller.solicitacao.update((value) {
                            if (filialSaidaVenda != null &&
                                filialSaidaVenda.isNotEmpty) {
                              value!.filialSaidaVenda =
                                  int.parse(filialSaidaVenda);
                            } else {
                              value!.filialSaidaVenda = null;
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: InputComponent(
                        label: 'Nota Fiscal',
                        onSaved: (numDocFiscalVenda) {
                          controller.solicitacao.update((value) {
                            if (numDocFiscalVenda != null &&
                                numDocFiscalVenda.isNotEmpty) {
                              value!.numDocFiscalVenda =
                                  int.parse(numDocFiscalVenda);
                            } else {
                              value!.numDocFiscalVenda = null;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputComponent(
                        label: 'Série',
                        onSaved: (serieDocFiscalVenda) {
                          controller.solicitacao.update((value) {
                            value!.serieDocFiscalVenda = serieDocFiscalVenda;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: InputComponent(
                        label: 'Data Emissão',
                        inputFormatter: [
                          controller.maskFormatter.dataFormatter(),
                        ],
                        onSaved: (dataEmissaoVenda) {
                          if (dataEmissaoVenda == null ||
                              dataEmissaoVenda.isEmpty) {
                            controller.solicitacao.update((value) {
                              value!.dataEmissaoVenda = null;
                            });
                          } else {
                            controller.solicitacao.update((value) {
                              value!.dataEmissaoVenda = DateFormat('dd/MM/yyyy')
                                  .parse(dataEmissaoVenda);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Container(),
    );
  }

  Widget _buildCamposNotaFiscalTroca() {
    return Obx(
      () => controller.solicitacao.value.categoriaTroca?.value ==
                  1 // Categoria Troca = Troca
              &&
              (controller.solicitacao.value.complemento?.value ==
                      2 // Complemento OS = Troca Consumidor
                  ||
                  controller.solicitacao.value.complemento?.value ==
                      4) // Complemento OS = Troca Central Cliente
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 12,
                    bottom: 20,
                  ),
                  child: TextComponent(
                    'Nota Fiscal de Troca',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputComponent(
                        label: 'Filial Saída',
                        onSaved: (filialSaidaTroca) {
                          controller.solicitacao.update((value) {
                            if (filialSaidaTroca != null &&
                                filialSaidaTroca.isNotEmpty) {
                              value!.filialSaidaTroca =
                                  int.parse(filialSaidaTroca);
                            } else {
                              value!.filialSaidaTroca = null;
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: InputComponent(
                        label: 'Nota Fiscal',
                        onSaved: (numDocFiscalTroca) {
                          controller.solicitacao.update((value) {
                            if (numDocFiscalTroca != null &&
                                numDocFiscalTroca.isNotEmpty) {
                              value!.numDocFiscalTroca =
                                  int.parse(numDocFiscalTroca);
                            } else {
                              value!.numDocFiscalTroca = null;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputComponent(
                        label: 'Série',
                        onSaved: (serieDocFiscalTroca) {
                          controller.solicitacao.update((value) {
                            value!.serieDocFiscalTroca = serieDocFiscalTroca;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: InputComponent(
                        label: 'Data Emissão',
                        inputFormatter: [
                          controller.maskFormatter.dataFormatter(),
                        ],
                        onSaved: (dataEmissaoTroca) {
                          if (dataEmissaoTroca == null ||
                              dataEmissaoTroca.isEmpty) {
                            controller.solicitacao.update((value) {
                              value!.dataEmissaoTroca = null;
                            });
                          } else {
                            controller.solicitacao.update((value) {
                              value!.dataEmissaoTroca = DateFormat('dd/MM/yyyy')
                                  .parse(dataEmissaoTroca);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Container(),
    );
  }

  Widget _buildSelecaoProduto(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 32,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextComponent(
                'Produto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              Obx(
                () => controller.solicitacao.value.itemSolicitacao == null
                    ? ButtonComponent(
                        color: primaryColor,
                        colorHover: primaryColorHover,
                        onPressed: () {
                          controller.buscarProdutos();
                          _showProdutos(context);
                        },
                        text: 'Adicionar Produto',
                      )
                    : Container(),
              ),
            ],
          ),
          Obx(
            () => controller.solicitacao.value.itemSolicitacao?.idProduto ==
                    null
                ? Container()
                : Container(
                    margin: EdgeInsets.only(
                      top: 24,
                    ),
                    child: CardWidget(
                      color: primaryColor,
                      widget: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      TextComponent(
                                        'ID',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      SelectableText(
                                        controller.solicitacao.value
                                                .itemSolicitacao?.idProduto ??
                                            '',
                                      )
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
                                        'LD',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      SelectableText(
                                        controller.solicitacao.value
                                                .itemSolicitacao?.idLd ??
                                            '',
                                      )
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
                                Expanded(
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
                                          controller
                                                  .solicitacao
                                                  .value
                                                  .itemSolicitacao
                                                  ?.nomeProduto ??
                                              '',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
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
                                Expanded(
                                  child: Row(
                                    children: [
                                      TextComponent(
                                        'Estoque',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      SelectableText(
                                        controller.solicitacao.value
                                                .itemSolicitacao?.estoque ??
                                            '',
                                      )
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
                                        'Valor',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      SelectableText(
                                        controller.solicitacao.value
                                                    .itemSolicitacao?.valor !=
                                                null
                                            ? controller.formatter.format(
                                                controller.solicitacao.value
                                                    .itemSolicitacao!.valor!,
                                              )
                                            : '',
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextComponent(
                                  'Nº Série',
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 40,
                                  child: InputComponent(
                                    onSaved: (numeroSerie) {
                                      controller.solicitacao.update(
                                        (value) {
                                          value!.itemSolicitacao?.numeroSerie =
                                              numeroSerie;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    color: vermelhoColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      controller.removerProdutoSelecionado();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showProdutos(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.all(16),
          contentPadding: EdgeInsets.all(16),
          insetPadding: EdgeInsets.all(10),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleComponent('Produto da OS'),
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.close),
                tooltip: 'Fechar',
              ),
            ],
          ),
          content: Container(
            width: Get.width * 0.9,
            height: Get.height * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: TextComponent(
                    'Clique no produto desejado para adicioná-lo a solicitação de criação da OS.',
                    letterSpacing: 0.15,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Form(
                  key: controller.formFiltragemProdutosKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: InputComponent(
                              prefixIcon: Icon(
                                Icons.search,
                              ),
                              hintText: 'Descrição',
                              onSaved: (value) {
                                controller.buscarProdutoFiltro = value;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            flex: 1,
                            child: InputComponent(
                              prefixIcon: Icon(
                                Icons.fact_check,
                              ),
                              hintText: 'LD',
                              onSaved: (value) {
                                controller.ldProdutoFiltro =
                                    int.tryParse(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ButtonComponent(
                              color: secundaryColor,
                              colorHover: secundaryColorHover,
                              icon: Icon(Icons.search, color: Colors.white),
                              onPressed: () async {
                                controller
                                    .formFiltragemProdutosKey.currentState!
                                    .save();

                                await controller.buscarProdutos();
                              },
                              text: 'Pesquisar',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Obx(
                  () => !controller.carregandoProdutos.value
                      ? Expanded(
                          child: ListView.separated(
                            itemCount: controller.produtos.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.selecionarProduto(
                                      controller.produtos[index].idProduto ??
                                          '');
                                },
                                child:
                                    GetBuilder<SolicitacaoOSCriacaoController>(
                                  builder: (_) {
                                    return Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: _.codigoProdutoSelecionado
                                                    .value ==
                                                _.produtos[index].idProduto
                                            ? Color.fromRGBO(24, 2, 153, 0.2)
                                            : Colors.white,
                                        border: Border.all(
                                          width: 1,
                                          color: _.codigoProdutoSelecionado
                                                      .value ==
                                                  _.produtos[index].idProduto
                                              ? primaryColor
                                              : Color.fromRGBO(
                                                  238, 238, 238, 1),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    TextComponent(
                                                      'ID',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    SelectableText(
                                                      _.produtos[index]
                                                              .idProduto ??
                                                          '',
                                                    )
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
                                                      'LD',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    SelectableText(
                                                      _.produtos[index].idLd ??
                                                          '',
                                                    )
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
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    TextComponent(
                                                      'Nome',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        _.produtos[index]
                                                                .denominacao ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
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
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    TextComponent(
                                                      'Estoque',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    SelectableText(
                                                      _.produtos[index]
                                                              .saldoDisponivel ??
                                                          '',
                                                    )
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
                                                      'Valor',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    SelectableText(
                                                      _.produtos[index]
                                                                  .custoMedio !=
                                                              null
                                                          ? _.formatter.format(
                                                              double.parse(_
                                                                  .produtos[
                                                                      index]
                                                                  .custoMedio!))
                                                          : '',
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 8,
                              );
                            },
                          ),
                        )
                      : Expanded(
                          child: LoadingComponent(),
                        ),
                ),
                GetBuilder<SolicitacaoOSCriacaoController>(
                  builder: (_) {
                    return PaginacaoComponent(
                      primeiraPagina: () async {
                        _.paginaProdutos.primeira();
                        await _.buscarProdutos();
                      },
                      anteriorPagina: () async {
                        _.paginaProdutos.anterior();
                        await _.buscarProdutos();
                      },
                      proximaPagina: () async {
                        _.paginaProdutos.proxima();
                        await _.buscarProdutos();
                      },
                      ultimaPagina: () async {
                        _.paginaProdutos.ultima();
                        await _.buscarProdutos();
                      },
                      total: _.paginaProdutos.getTotal(),
                      atual: _.paginaProdutos.getAtual(),
                    );
                  },
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonComponent(
                        color: vermelhoColor,
                        colorHover: vermelhoColorHover,
                        onPressed: () {
                          controller.fecharDialog();
                        },
                        text: 'Cancelar',
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ButtonComponent(
                        onPressed: () {
                          controller.confirmarSelecaoProduto();
                          controller.fecharDialog();
                        },
                        text: 'Confirmar',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCamposDefeitosChecklists() {
    return Obx(
      () => controller.solicitacao.value.itemSolicitacao != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 32,
                    bottom: 20,
                  ),
                  child: TextComponent(
                    'Defeitos',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                !controller.carregandoDefeitosChecklists.value
                    ? Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Defeitos',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                // height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownSearch<
                                    DefeitoOSModel>.multiSelection(
                                  mode: Mode.DIALOG,
                                  showSearchBox: true,
                                  items: controller.defeitos,
                                  itemAsString: (value) =>
                                      value!.descricao.toString(),
                                  onChanged: (defeitos) {
                                    controller.solicitacao.update((value) {
                                      value!.itemSolicitacao!.defeitos =
                                          defeitos;
                                    });
                                  },
                                  selectedItems: controller.solicitacao.value
                                      .itemSolicitacao!.defeitos!,
                                  selectionListViewProps:
                                      SelectionListViewProps(
                                    padding: EdgeInsets.all(16),
                                  ),
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      contentPadding: EdgeInsets.only(
                                          top: 5, bottom: 5, left: 10),
                                      border: InputBorder.none,
                                      labelText: 'Pesquisar por nome',
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  dropdownSearchDecoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  emptyBuilder: (context, value) {
                                    return Center(
                                        child: TextComponent(
                                      'Nenhum defeito encontrado',
                                      textAlign: TextAlign.center,
                                      color: Colors.grey.shade400,
                                    ));
                                  },
                                  popupBackgroundColor: Colors.white,
                                  showAsSuffixIcons: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Check List da Loja',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                // height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownSearch<
                                    ChecklistOSModel>.multiSelection(
                                  mode: Mode.DIALOG,
                                  showSearchBox: true,
                                  items: controller.checklists,
                                  itemAsString: (value) =>
                                      '${value!.tipo.toString()} - ${value.descricao.toString()}',
                                  onChanged: (checklists) {
                                    controller.solicitacao.update((value) {
                                      value!.itemSolicitacao!.checklists =
                                          checklists;
                                    });
                                  },
                                  selectedItems: controller.solicitacao.value
                                      .itemSolicitacao!.checklists!,
                                  selectionListViewProps:
                                      SelectionListViewProps(
                                    padding: EdgeInsets.all(16),
                                  ),
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      contentPadding: EdgeInsets.only(
                                          top: 5, bottom: 5, left: 10),
                                      border: InputBorder.none,
                                      labelText: 'Pesquisar por nome',
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  dropdownSearchDecoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  emptyBuilder: (context, value) {
                                    return Center(
                                        child: TextComponent(
                                      'Nenhum checklist encontrado',
                                      textAlign: TextAlign.center,
                                      color: Colors.grey.shade400,
                                    ));
                                  },
                                  popupBackgroundColor: Colors.white,
                                  showAsSuffixIcons: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : LoadingComponent(),
              ],
            )
          : Container(),
    );
  }

  Widget _buildCamposVideo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 32,
            bottom: 20,
          ),
          child: TextComponent(
            'Vídeo',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 200,
                          child: controller.solicitacao.value.videos?.length ==
                                  0
                              ? Center(
                                  child:
                                      Text('Selecione pelo menos 1 um vídeo'),
                                )
                              : FutureBuilder(
                                  future: controller.iniciarVideo.value,
                                  builder: ((context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: AspectRatio(
                                          aspectRatio: controller
                                              .controllerVideo
                                              .value!
                                              .value
                                              .aspectRatio,
                                          child: VideoPlayer(controller
                                              .controllerVideo.value!),
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  }),
                                ),
                        ),
                        Positioned(
                          bottom: 8,
                          child: Row(
                            children: [
                              Obx(() => controller
                                          .solicitacao.value.videos!.length !=
                                      0
                                  ? Container(
                                      padding: EdgeInsets.all(6),
                                      width: 48,
                                      height: 48,
                                      child: FittedBox(
                                        child: FloatingActionButton(
                                          child: Icon(
                                            isPlaying.value
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                          ),
                                          onPressed: () {
                                            if (controller.controllerVideo
                                                .value!.value.isPlaying) {
                                              controller.controllerVideo.value!
                                                  .pause();
                                              isPlaying.value = false;
                                            } else {
                                              controller.controllerVideo.value!
                                                  .play();
                                              isPlaying.value = true;
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  : Container()),
                              SizedBox(width: 5),
                              Obx(() => controller
                                          .solicitacao.value.videos!.length !=
                                      0
                                  ? Container(
                                      padding: EdgeInsets.all(6),
                                      width: 48,
                                      height: 48,
                                      child: FittedBox(
                                        child: FloatingActionButton(
                                          heroTag: 'btn_${0}_remover_video',
                                          backgroundColor: Colors.red.shade400,
                                          child: Icon(
                                            Icons.delete,
                                            size: 24,
                                          ),
                                          onPressed: () {
                                            controller
                                                .removerVideoSelecionado(0);
                                          },
                                        ),
                                      ),
                                    )
                                  : Container()),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 24,
                      ),
                      child: StreamBuilder<Object>(
                          stream: null,
                          builder: (context, snapshot) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ButtonComponent(
                                  color: controller.solicitacao.value.videos
                                              ?.length ==
                                          5
                                      ? Colors.grey.shade400
                                      : secundaryColor,
                                  onPressed: controller.solicitacao.value.videos
                                              ?.length ==
                                          5
                                      ? () {}
                                      : () async {
                                          if (kIsWeb) {
                                            await controller.escolherVideos();
                                          } else {
                                            _showModalOpcaoEscolhaVideos(
                                              context,
                                              onCamera: () async {
                                                await controller.escolherVideos(
                                                  origem: ImageSource.camera,
                                                );
                                                controller.fecharDialog();
                                              },
                                              onGallery: () async {
                                                controller.escolherVideos();
                                                controller.fecharDialog();
                                              },
                                            );
                                          }
                                        },
                                  text: 'Anexar vídeo',
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCamposObservacoesAdicionais(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 32,
              bottom: 20,
            ),
            child: TextComponent(
              'Informações Adicionais',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Obx(() => controller.solicitacao.value.itemSolicitacao != null
              ? Row(
                  children: [
                    Expanded(
                      child: InputComponent(
                        label: 'Observações',
                        maxLines: 5,
                        onSaved: (observacoes) {
                          controller.solicitacao.update(
                            (value) {
                              value!.itemSolicitacao?.observacao = observacoes;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Container()),
        ],
      ),
    );
  }

  Widget _buildCamposImagensNumeroSerie(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Icon(
                Icons.attach_file,
                size: 30,
                color: Colors.black,
              ),
              TextComponent(
                'Anexos',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonComponent(
                text: 'Anexar imagens',
                onPressed: () {
                  _showSelecaoDeMidias(context);
                },
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 32,
            bottom: 20,
          ),
          child: Row(
            children: [
              TextComponent(
                'Número Série',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      child: controller.solicitacao.value.imagens?.length == 0
                          ? Center(
                              child: Text('Selecione entre 1 a 5 imagens'),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  controller.solicitacao.value.imagens!.length,
                              separatorBuilder: (context, index) {
                                return index == 0
                                    ? SizedBox()
                                    : SizedBox(
                                        width: 1,
                                      );
                              },
                              itemBuilder: (context, index) {
                                return controller.solicitacao.value
                                            .imagens![index].categoria ==
                                        '1'
                                    ? Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: kIsWeb
                                                ? Image.network(
                                                    controller
                                                                .solicitacao
                                                                .value
                                                                .imagens![index]
                                                                .categoria ==
                                                            '1'
                                                        ? controller
                                                                .solicitacao
                                                                .value
                                                                .imagens![index]
                                                                .url ??
                                                            ''
                                                        : '',
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
                                                    File(
                                                      controller
                                                                  .solicitacao
                                                                  .value
                                                                  .imagens![
                                                                      index]
                                                                  .categoria
                                                                  .toString() ==
                                                              '1'
                                                          ? controller
                                                                  .solicitacao
                                                                  .value
                                                                  .imagens![
                                                                      index]
                                                                  .url ??
                                                              ''
                                                          : '',
                                                    ),
                                                    fit: BoxFit.cover,
                                                    filterQuality:
                                                        FilterQuality.low,
                                                    scale: 1,
                                                  ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(6),
                                            width: 48,
                                            height: 48,
                                            child: FittedBox(
                                              child: FloatingActionButton(
                                                heroTag:
                                                    'btn_${index}_remover_imagem',
                                                backgroundColor:
                                                    Colors.red.shade400,
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 24,
                                                ),
                                                onPressed: () {
                                                  controller
                                                      .removerImagemSelecionada(
                                                          index);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container();
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSelecaoDeMidias(BuildContext context) {
    controller.selecionandoImagens.value = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              TextComponent(
                'Anexar Mídias',
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ],
          ),
          content: Container(
            width: Get.width * 0.9,
            height: Get.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                  ),
                  child: GetBuilder<SolicitacaoOSCriacaoController>(
                    builder: (_) {
                      return Obx(
                        () => Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: controller.selecionandoImagens == false
                                      ? ListTile(
                                          title: const Text(
                                            'Número Série',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          leading: Radio<CategoriaImagensEnum>(
                                            value: CategoriaImagensEnum
                                                .NUMEROSERIE,
                                            groupValue: controller
                                                .checkBoxCategoriaImagem,
                                            onChanged:
                                                (CategoriaImagensEnum? value) {
                                              controller.checkBoxImagem(value);
                                            },
                                          ),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: controller.selecionandoImagens == false
                                      ? ListTile(
                                          title: const Text(
                                            'Condição Produto',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          leading: Radio<CategoriaImagensEnum>(
                                            value: CategoriaImagensEnum
                                                .CONDICAOPRODUTO,
                                            groupValue: controller
                                                .checkBoxCategoriaImagem,
                                            onChanged:
                                                (CategoriaImagensEnum? value) {
                                              controller.checkBoxImagem(value);
                                            },
                                          ),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: controller.selecionandoImagens == false
                                      ? ListTile(
                                          title: const Text('Defeitos',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              )),
                                          leading: Radio<CategoriaImagensEnum>(
                                            value: CategoriaImagensEnum
                                                .DEFEITOPECA,
                                            groupValue: controller
                                                .checkBoxCategoriaImagem,
                                            onChanged:
                                                (CategoriaImagensEnum? value) {
                                              controller.checkBoxImagem(value);
                                            },
                                          ),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextComponent(
                                    '${controller.tamanhoLista(controller.checkBoxCategoriaImagem)}/5 imagens anexadas na categoria'),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child:
                      GetBuilder<SolicitacaoOSCriacaoController>(builder: (_) {
                    return Obx(
                      () => Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: Get.height * 0.2,
                                    child: controller.tamanhoLista(controller
                                                .checkBoxCategoriaImagem) ==
                                            0
                                        ? Center(
                                            child: Text(
                                                'Selecione entre 1 a 5 imagens'),
                                          )
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: controller.solicitacao
                                                        .value.imagens!.length >
                                                    0
                                                ? controller.solicitacao.value
                                                    .imagens!.length
                                                : controller.tamanhoLista(
                                                    controller
                                                        .checkBoxCategoriaImagem),
                                            separatorBuilder: (context, index) {
                                              return SizedBox(
                                                width: 3,
                                              );
                                            },
                                            itemBuilder: (context, index) {
                                              return controller
                                                          .solicitacao
                                                          .value
                                                          .imagens![index]
                                                          .categoria
                                                          .toString() ==
                                                      controller
                                                          .checkBoxCategoriaImagem!
                                                          .value
                                                          .toString()
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      children: [
                                                        Container(
                                                          width: 180,
                                                          height: 180,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),

                                                          child: kIsWeb
                                                              ? Image.network(
                                                                  controller
                                                                              .solicitacao
                                                                              .value
                                                                              .imagens![
                                                                                  index]
                                                                              .categoria ==
                                                                          controller
                                                                              .checkBoxCategoriaImagem!
                                                                              .value
                                                                              .toString()
                                                                      ? controller
                                                                              .solicitacao
                                                                              .value
                                                                              .imagens![index]
                                                                              .url ??
                                                                          ''
                                                                      : '',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.file(
                                                                  File(
                                                                    controller.solicitacao.value.imagens![index].categoria.toString() ==
                                                                            controller.checkBoxCategoriaImagem!.value
                                                                                .toString()
                                                                        ? controller.solicitacao.value.imagens![index].url ??
                                                                            ''
                                                                        : '',
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .low,
                                                                  scale: 1,
                                                                ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(6),
                                                          width: 48,
                                                          height: 48,
                                                          child: FittedBox(
                                                            child:
                                                                FloatingActionButton(
                                                              heroTag:
                                                                  'btn_${index}_remover_imagem',
                                                              backgroundColor:
                                                                  Colors.red
                                                                      .shade400,
                                                              child: Icon(
                                                                Icons.delete,
                                                                size: 24,
                                                              ),
                                                              onPressed: () {
                                                                controller
                                                                    .removerImagemSelecionada(
                                                                        index);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Container();
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                ButtonComponent(
                    color: controller.solicitacao.value.imagens?.length == 15
                        ? Colors.grey.shade400
                        : Color.fromARGB(255, 4, 4, 158),
                    onPressed: controller.solicitacao.value.imagens?.length ==
                            15
                        ? () {}
                        : () async {
                            if (controller.checkBoxCategoriaImagem == null) {
                              Notificacao.snackBar(
                                  'Selecione uma categoria de Imagem!',
                                  tipoNotificacao: TipoNotificacaoEnum.error);
                            } else {
                              if (controller.verificalimiteImagens(
                                  controller.checkBoxCategoriaImagem)) {
                                if (kIsWeb) {
                                  await controller.escolherImagens();
                                } else {
                                  _showModalOpcaoEscolhaImagens(
                                    context,
                                    onCamera: () async {
                                      await controller.escolherImagens(
                                        origem: ImageSource.camera,
                                      );
                                      //controller.fecharDialog();
                                    },
                                    onGallery: () async {
                                      await controller.escolherImagens();
                                      // controller.fecharDialog();
                                    },
                                  );
                                }
                              } else {
                                Get.back();
                              }
                              ;
                            }
                          },
                    text: 'Anexar Mídias'),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonComponent(
                        color: vermelhoColor,
                        colorHover: vermelhoColorHover,
                        onPressed: () {
                          Get.back();
                        },
                        text: 'Cancelar',
                      ),
                      ButtonComponent(
                        onPressed: () {
                          if (controller.tamanhoMinimo()) {
                          } else {
                            Get.back();
                          }
                        },
                        text: 'Adicionar',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCamposImagensCondicaoProduto() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 32,
            bottom: 20,
          ),
          child: Row(
            children: [
              TextComponent(
                'Condição Produto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      child: controller.solicitacao.value.imagens?.length == 0
                          ? Center(
                              child: Text('Selecione entre 1 a 5 imagens'),
                            )
                          : ListView.separated(
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  controller.solicitacao.value.imagens!.length,
                              separatorBuilder: (context, index) {
                                return index == 0
                                    ? SizedBox()
                                    : SizedBox(
                                        width: 1,
                                      );
                              },
                              itemBuilder: (context, index) {
                                return controller.solicitacao.value
                                            .imagens![index].categoria
                                            .toString() ==
                                        '2'
                                    ? Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: kIsWeb
                                                ? Image.network(
                                                    controller
                                                                .solicitacao
                                                                .value
                                                                .imagens![index]
                                                                .categoria
                                                                .toString() ==
                                                            '2'
                                                        ? controller
                                                                .solicitacao
                                                                .value
                                                                .imagens![index]
                                                                .url ??
                                                            ''
                                                        : '',
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
                                                    File(
                                                      controller
                                                                  .solicitacao
                                                                  .value
                                                                  .imagens![
                                                                      index]
                                                                  .categoria
                                                                  .toString() ==
                                                              '2'
                                                          ? controller
                                                                  .solicitacao
                                                                  .value
                                                                  .imagens![
                                                                      index]
                                                                  .url ??
                                                              ''
                                                          : '',
                                                    ),
                                                    fit: BoxFit.cover,
                                                    filterQuality:
                                                        FilterQuality.low,
                                                    scale: 1,
                                                  ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(6),
                                            width: 48,
                                            height: 48,
                                            child: FittedBox(
                                              child: FloatingActionButton(
                                                heroTag:
                                                    'btn_${index}_remover_imagem',
                                                backgroundColor:
                                                    Colors.red.shade400,
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 24,
                                                ),
                                                onPressed: () {
                                                  controller
                                                      .removerImagemSelecionada(
                                                          index);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container();
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCamposImagensDefeitos() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 32,
            bottom: 20,
          ),
          child: Row(
            children: [
              TextComponent(
                'Defeitos',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      child: controller.solicitacao.value.imagens?.length == 0
                          ? Center(
                              child: Text('Selecione entre 1 a 5 imagens'),
                            )
                          : ListView.separated(
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  controller.solicitacao.value.imagens!.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 1,
                                );
                              },
                              itemBuilder: (context, index) {
                                return controller.solicitacao.value
                                            .imagens![index].categoria ==
                                        '3'
                                    ? Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: kIsWeb
                                                ? Image.network(
                                                    controller
                                                                .solicitacao
                                                                .value
                                                                .imagens![index]
                                                                .categoria
                                                                .toString() ==
                                                            '3'
                                                        ? controller
                                                                .solicitacao
                                                                .value
                                                                .imagens![index]
                                                                .url ??
                                                            ''
                                                        : '',
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
                                                    File(controller
                                                                .solicitacao
                                                                .value
                                                                .imagens![index]
                                                                .categoria
                                                                .toString() ==
                                                            '3'
                                                        ? controller
                                                                .solicitacao
                                                                .value
                                                                .imagens![index]
                                                                .url ??
                                                            ''
                                                        : ''),
                                                    fit: BoxFit.cover,
                                                    filterQuality:
                                                        FilterQuality.low,
                                                    scale: 1,
                                                  ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(6),
                                            width: 48,
                                            height: 48,
                                            child: FittedBox(
                                              child: FloatingActionButton(
                                                heroTag:
                                                    'btn_${index}_remover_imagem',
                                                backgroundColor:
                                                    Colors.red.shade400,
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 24,
                                                ),
                                                onPressed: () {
                                                  controller
                                                      .removerImagemSelecionada(
                                                          index);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container();
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showModalOpcaoEscolhaImagens(BuildContext context,
      {required Function() onCamera, required Function() onGallery}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Anexar imagem'),
          content:
              Text('Deseja tirar uma foto ou escolher as imagens da galeria?'),
          actions: [
            TextButton(
              onPressed: onCamera,
              child: Text('Tirar uma foto'),
            ),
            TextButton(
              onPressed: onGallery,
              child: Text('Escolher da galeria'),
            ),
          ],
        );
      },
    );
  }

  void _showModalOpcaoEscolhaVideos(BuildContext context,
      {required Function() onCamera, required Function() onGallery}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Anexar vídeo'),
          content: Text('Deseja gravar um vídeo ou escolher da galeria?'),
          actions: [
            TextButton(
              onPressed: onCamera,
              child: Text('Gravar vídeo'),
            ),
            TextButton(
              onPressed: onGallery,
              child: Text('Escolher da galeria'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDigitalizacoes() {
    return Obx(
      () => controller.solicitacao.value.complemento?.value ==
              1 // Complemento OS = Jurídico
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 32,
                    bottom: 20,
                  ),
                  child: TextComponent(
                    'Digitalizações',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      controller.solicitacao.value.digitalizacoes?.length ?? 0,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 8,
                    );
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: InputComponent(
                                label: 'Descrição',
                                onSaved: (descricao) {
                                  controller.solicitacao.update(
                                    (value) {
                                      value!.digitalizacoes?[index].descricao =
                                          descricao;
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: 16,
                                ),
                                child: Obx(
                                  () => controller
                                              .solicitacao
                                              .value
                                              .digitalizacoes?[index]
                                              .nomeImagem ==
                                          null
                                      ? ButtonComponent(
                                          onPressed: () async {
                                            if (kIsWeb) {
                                              await controller
                                                  .escolherImagemDigitalizacao(
                                                      index);
                                            } else {
                                              _showModalOpcaoEscolhaImagens(
                                                context,
                                                onCamera: () async {
                                                  await controller
                                                      .escolherImagemDigitalizacao(
                                                    index,
                                                    origem: ImageSource.camera,
                                                  );
                                                  controller.fecharDialog();
                                                },
                                                onGallery: () async {
                                                  controller
                                                      .escolherImagemDigitalizacao(
                                                          index);
                                                  controller.fecharDialog();
                                                },
                                              );
                                            }
                                          },
                                          text: 'Anexar imagem',
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                controller
                                                        .solicitacao
                                                        .value
                                                        .digitalizacoes?[index]
                                                        .nomeImagem ??
                                                    '',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 16,
                                            ),
                                            Tooltip(
                                              message: 'Apagar imagem',
                                              preferBelow: false,
                                              child: SizedBox(
                                                width: 32,
                                                height: 32,
                                                child: FittedBox(
                                                  child: FloatingActionButton(
                                                    heroTag:
                                                        'btn_${index}_remover_imagem_digitalizacao',
                                                    backgroundColor:
                                                        Colors.red.shade400,
                                                    child: Icon(
                                                      Icons.delete,
                                                      size: 32,
                                                    ),
                                                    onPressed: () {
                                                      controller
                                                          .removerImagemDigitalizacao(
                                                              index);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: 16,
                                ),
                                child: ButtonComponent(
                                  color: index == 0
                                      ? Colors.grey.shade400
                                      : vermelhoColor,
                                  colorHover:
                                      index == 0 ? null : vermelhoColorHover,
                                  onPressed: index == 0
                                      ? () {}
                                      : () {
                                          controller
                                              .removerDigitalizacao(index);
                                        },
                                  text: 'Deletar',
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ButtonComponent(
                          onPressed: () {
                            controller.adicionarDigitalizacao();
                          },
                          text: 'Adicionar digitalização',
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Container(),
    );
  }

  Widget _buildBotoesPrincipais(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 12,
      ),
      child: Obx(
        () => !controller.carregandoCriacao.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonComponent(
                    color: primaryColor,
                    colorHover: primaryColorHover,
                    onPressed: () {
                      _showModalConfirmarVoltar(context);
                    },
                    text: 'Voltar',
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ButtonComponent(
                    onPressed: () {
                      controller.formKey.currentState!.save();

                      if (controller.validarCamposSolicitacao()) {
                        _showModalConfirmarSalvar(context);
                      }
                    },
                    text: 'Salvar',
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LoadingComponent(),
                ],
              ),
      ),
    );
  }

  void _showModalConfirmarVoltar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Aviso'),
          content: Text(
              'Tem certeza que deseja voltar? Todos os dados informados serão perdidos.'),
          actions: [
            TextButton(
              onPressed: () {
                controller.fecharDialog();
              },
              child: Text('Não'),
            ),
            TextButton(
              onPressed: () {
                Get.offAllNamed('/solicitacao-os');
              },
              child: Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  void _showModalConfirmarSalvar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Aviso'),
          content: Text(
              'Deseja confirmar a solicitação? Uma vez criada, a solicitação não poderá ser alterada.'),
          actions: [
            TextButton(
              onPressed: () {
                controller.fecharDialog();
              },
              child: Text('Não'),
            ),
            TextButton(
              onPressed: () async {
                Get.back();

                if (await controller.criarSolicitacao()) {
                  Notificacao.snackBar('Solicitação criada com sucesso!',
                      tipoNotificacao: TipoNotificacaoEnum.sucesso);

                  Get.delete<SolicitacaoOSCriacaoController>();
                  Get.offAllNamed('/solicitacao-os');
                }
              },
              child: Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCamposIniciais(context),
                      _buildCamposNotaFiscalVenda(),
                      _buildCamposNotaFiscalTroca(),
                      _buildSelecaoProduto(context),
                      _buildCamposDefeitosChecklists(),
                      _buildCamposObservacoesAdicionais(context),
                      _buildCamposImagensNumeroSerie(context),
                      _buildCamposImagensCondicaoProduto(),
                      _buildCamposImagensDefeitos(),
                      _buildCamposVideo(),
                      _buildDigitalizacoes(),
                    ],
                  ),
                ),
              ),
            ),
            _buildBotoesPrincipais(context),
          ],
        ),
      ),
    );
  }
}
