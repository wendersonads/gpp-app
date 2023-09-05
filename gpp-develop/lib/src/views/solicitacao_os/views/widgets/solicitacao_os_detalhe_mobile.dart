import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/enums/solicitacao_os_classificacao_produto_enum.dart';
import 'package:gpp/src/models/solicitacao_os/imagem_os_model.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/solicitacao_os/controllers/solicitacao_os_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:gpp/src/views/widgets/situacao_solicitacao_os_widget.dart';
import 'package:gpp/src/shared/shims/dart_ui.dart' as ui;

import '../../../../models/solicitacao_os/motivo_reprovacao_solicitacao_os_model.dart';
import '../../../../utils/notificacao.dart';

class SolicitacaoOSDetalheMobile extends StatelessWidget {
  final controller = Get.find<SolicitacaoOSDetalheController>();

  Widget _buildCamposIniciais() {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Solicitação de OS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SituacaoSolicitacaoOSWidget(
                    situacao: controller.solicitacao.situacao,
                  ),
                ],
              ),
            ],
          ),
        ),
        controller.solicitacao.situacao == 2
            ? Row(
                children: [
                  Expanded(
                    child: InputComponent(
                      label: 'ID Ordem de Serviço',
                      initialValue:
                          controller.solicitacao.idOrdemServico != null
                              ? controller.solicitacao.idOrdemServico.toString()
                              : '',
                      readOnly: true,
                    ),
                  ),
                ],
              )
            : Container(),
        Row(
          children: [
            Expanded(
              child: InputComponent(
                label: 'Filial Origem',
                initialValue: controller.solicitacao.filialOrigem.toString(),
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
                  controller.solicitacao.dataEmissao!,
                ),
                readOnly: true,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: InputComponent(
                label: 'Filial Destino',
                keyboardType: TextInputType.number,
                initialValue: controller.solicitacao.filialDestino,
                readOnly: true,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InputComponent(
                label: 'Filial Destino Retransf.',
                keyboardType: TextInputType.number,
                initialValue: controller.solicitacao.filialDestinoRetransf,
                readOnly: true,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: InputComponent(
                label: 'Componente OS',
                initialValue: controller.solicitacao.complemento?.name,
                readOnly: true,
              ),
            ),
          ],
        ),
        controller.solicitacao.complemento?.value ==
                    2 // Complemento OS = Troca Consumidor
                ||
                controller.solicitacao.complemento?.value ==
                    4 // Complemento OS = Troca Central Cliente
            ? Row(
                children: [
                  Expanded(
                    child: InputComponent(
                      label: 'CRM',
                      initialValue: controller.solicitacao.crm,
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: InputComponent(
                      label: 'Categoria Troca',
                      initialValue: controller.solicitacao.categoriaTroca?.name,
                      readOnly: true,
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget _buildCamposNotaFiscalVenda() {
    return controller.solicitacao.complemento?.value ==
                2 // Complemento OS = Troca Consumidor
            ||
            controller.solicitacao.complemento?.value ==
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
                      initialValue: controller.solicitacao.filialSaidaVenda !=
                              null
                          ? controller.solicitacao.filialSaidaVenda.toString()
                          : '-',
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: InputComponent(
                      label: 'Nota Fiscal',
                      initialValue: controller.solicitacao.numDocFiscalVenda !=
                              null
                          ? controller.solicitacao.numDocFiscalVenda.toString()
                          : '-',
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InputComponent(
                      label: 'Série',
                      initialValue: controller.solicitacao.serieDocFiscalVenda,
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: InputComponent(
                      label: 'Data Emissão',
                      initialValue: DateFormat('dd/MM/yyyy')
                          .format(controller.solicitacao.dataEmissaoVenda!),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Container();
  }

  Widget _buildCamposNotaFiscalTroca() {
    return controller.solicitacao.categoriaTroca?.value ==
                1 // Categoria Troca = Troca
            &&
            (controller.solicitacao.complemento?.value ==
                    2 // Complemento OS = Troca Consumidor
                ||
                controller.solicitacao.complemento?.value ==
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
                      initialValue: controller.solicitacao.filialSaidaTroca !=
                              null
                          ? controller.solicitacao.filialSaidaTroca.toString()
                          : '-',
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: InputComponent(
                      label: 'Nota Fiscal',
                      initialValue: controller.solicitacao.numDocFiscalTroca !=
                              null
                          ? controller.solicitacao.numDocFiscalTroca.toString()
                          : '-',
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InputComponent(
                      label: 'Série',
                      initialValue: controller.solicitacao.serieDocFiscalTroca,
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: InputComponent(
                      label: 'Data Emissão',
                      initialValue: DateFormat('dd/MM/yyyy')
                          .format(controller.solicitacao.dataEmissaoTroca!),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Container();
  }

  Widget _buildProduto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 12,
            bottom: 20,
          ),
          child: TextComponent(
            'Produto',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        CardWidget(
          color: primaryColor,
          widget: Container(
            padding: EdgeInsets.all(8),
            child: Column(
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
                            controller.solicitacao.itemSolicitacao?.idProduto ??
                                '',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 3,
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
                              controller.solicitacao.itemSolicitacao
                                      ?.nomeProduto ??
                                  '',
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
                    Expanded(
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
                            controller.solicitacao.itemSolicitacao?.idLd ?? '',
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
                            'Estoque',
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          SelectableText(
                            controller.solicitacao.itemSolicitacao?.estoque ??
                                '',
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
                            'Nº Série',
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              controller.solicitacao.itemSolicitacao
                                      ?.numeroSerie ??
                                  '',
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
                    Expanded(
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
                            controller.formatter.format(
                                controller.solicitacao.itemSolicitacao?.valor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefeitos() {
    return controller.solicitacao.itemSolicitacao!.defeitos!.length > 0
        ? Container(
            margin: EdgeInsets.only(
              top: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 12,
                    bottom: 20,
                  ),
                  child: TextComponent(
                    'Defeitos do Produto',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      controller.solicitacao.itemSolicitacao?.defeitos?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: CardWidget(
                        color: primaryColor,
                        widget: Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
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
                                    SelectableText(
                                      controller.solicitacao.itemSolicitacao
                                              ?.defeitos?[index].descricao ??
                                          '',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _buildChecklist() {
    return controller.solicitacao.itemSolicitacao!.checklists!.length > 0
        ? Container(
            margin: EdgeInsets.only(
              top: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 12,
                    bottom: 20,
                  ),
                  child: TextComponent(
                    'Checklist da Loja',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller
                      .solicitacao.itemSolicitacao?.checklists?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: CardWidget(
                        color: primaryColor,
                        widget: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        TextComponent(
                                          'Tipo',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        SelectableText(
                                          controller.solicitacao.itemSolicitacao
                                                  ?.checklists?[index].tipo ??
                                              '',
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
                                                    .itemSolicitacao
                                                    ?.checklists?[index]
                                                    .descricao ??
                                                '',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _buildCamposObservacoesAdicionais() {
    return Column(
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
        Row(
          children: [
            Expanded(
              child: InputComponent(
                label: 'Observações',
                maxLines: 5,
                initialValue:
                    controller.solicitacao.itemSolicitacao?.observacao,
                readOnly: true,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    child: SelectableText(
                      'Anexos',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 200,
                  //   child: ListView.separated(
                  //     shrinkWrap: true,
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: controller.solicitacao.imagens?.length ?? 0,
                  //     separatorBuilder: (context, index) {
                  //       return SizedBox(
                  //         width: 8,
                  //       );
                  //     },
                  //     itemBuilder: (context, index) {
                  //       return _buildPreviewImagem(controller.solicitacao.imagens?[index].url, index);
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriaNumeroSerie() {
    final List<ImagemOSModel>? categoriasNumeroSerie = controller
        .solicitacao.imagens
        ?.where((imagem) => imagem.categoria == '1')
        .toList();
    if (categoriasNumeroSerie?.isEmpty ?? false) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: SelectableText(
                    'Número Série',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 200,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categoriasNumeroSerie?.length ?? 0,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 2,
                      );
                    },
                    itemBuilder: (context, index) {
                      //verifica a categoria da imagem
                      return _buildPreviewImagem(
                          categoriasNumeroSerie?[index].url, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaDefeito() {
    final List<ImagemOSModel>? categoriasDefeito = controller
        .solicitacao.imagens
        ?.where((imagem) => imagem.categoria == '3')
        .toList();
    if (categoriasDefeito?.isEmpty ?? false) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: SelectableText(
                    'Defeitos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 200,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categoriasDefeito?.length ?? 0,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 1,
                      );
                    },
                    itemBuilder: (context, index) {
                      //verifica a categoria da imagem
                      return _buildPreviewImagem(
                          categoriasDefeito?[index].url, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaCondicaProduto() {
    final List<ImagemOSModel>? categoriasCondicaoProduto = controller
        .solicitacao.imagens
        ?.where((imagem) => imagem.categoria == '2')
        .toList();
    if (categoriasCondicaoProduto?.isEmpty ?? false) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: SelectableText(
                    'Condição Produto',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 200,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categoriasCondicaoProduto?.length ?? 0,
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 1);
                    },
                    itemBuilder: (context, index) {
                      //verifica a categoria da imagem
                      return _buildPreviewImagem(
                          categoriasCondicaoProduto?[index].url, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Widget para mostrar as imgens sem categoria.
  Widget _buildImagens() {
    return controller.solicitacao.imagens!.first.categoria == null
        ? Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 20,
                        ),
                        child: SelectableText(
                          'Imagens',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 200,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              controller.solicitacao.imagens?.length ?? 0,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: 1,
                            );
                          },
                          itemBuilder: (context, index) {
                            //verifica a categoria da imagem
                            return controller.solicitacao.imagens?[index]
                                        .categoria ==
                                    null
                                ? _buildPreviewImagem(
                                    controller.solicitacao.imagens?[index].url,
                                    index)
                                : Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _buildDigitalizacoes() {
    return controller.solicitacao.digitalizacoes!.length > 0
        ? Container(
            margin: EdgeInsets.only(
              top: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 12,
                    bottom: 20,
                  ),
                  child: TextComponent(
                    'Digitalizações',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.solicitacao.digitalizacoes!.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: InputComponent(
                            label: 'Descrição',
                            initialValue: controller
                                .solicitacao.digitalizacoes![index].descricao,
                            readOnly: true,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: 16,
                            ),
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: FittedBox(
                                child: FloatingActionButton(
                                  heroTag:
                                      'btn_${index}_visualizar_imagem_digitalizacao',
                                  backgroundColor: secundaryColor,
                                  onPressed: () async {
                                    String? imageURL = await controller
                                        .montarURLImagem(controller.solicitacao
                                            .digitalizacoes![index].url);

                                    await controller.abrirLinkImagem(imageURL);
                                  },
                                  child: Icon(
                                    Icons.image_search,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _buildPreviewImagem(String? url, int index) {
    String? imageURL = controller.montarURLImagem(url);

    if (imageURL == null) {
      return Container();
    }

    // Caso esteja rodando na Web, é necessário uma configuração extra para o preview
    if (kIsWeb) {
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        imageURL,
        (int viewId) => html.ImageElement()
          ..src = imageURL
          ..style.width = '100%'
          ..style.objectFit = 'cover'
          ..style.height = '100%',
      );

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: HtmlElementView(
              viewType: imageURL,
            ),
          ),
          Container(
            padding: EdgeInsets.all(6),
            width: 56,
            height: 56,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: 'btn_${index}_visualizar_imagem',
                backgroundColor: secundaryColor,
                onPressed: () async {
                  await controller.abrirLinkImagem(imageURL);
                },
                child: Icon(
                  Icons.image_search,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.network(
            imageURL,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: EdgeInsets.all(6),
          width: 56,
          height: 56,
          child: FittedBox(
            child: FloatingActionButton(
              heroTag: 'btn_${index}_visualizar_imagem',
              backgroundColor: secundaryColor,
              onPressed: () async {
                await controller.abrirLinkImagem(imageURL);
              },
              child: Icon(
                Icons.image_search,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideos(String? url) {
    String? videoUrl = controller.montarURLvideo(url);

    if (controller.solicitacao.caminhoVideo == null) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.only(
        top: 24,
      ),
      width: 200,
      height: 60,
      child: ButtonComponent(
        onPressed: () async {
          await controller.abrirLinkVideo(videoUrl);
        },
        text: 'Ver video',
      ),
    );
  }

  Widget _buildBotoesPrincipais(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 24,
      ),
      child: Obx(
        () => controller.carregandoAtualizacaoSolicitacao.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 8,
                      right: 8,
                    ),
                    child: LoadingComponent(),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonComponent(
                    color: primaryColor,
                    colorHover: primaryColorHover,
                    onPressed: () {
                      Get.delete<SolicitacaoOSDetalheController>();
                      Get.toNamed('/solicitacao-os');
                    },
                    text: 'Voltar',
                  ),
                  controller.usuarioAprovador.value &&
                          controller.solicitacao.situacao == 1
                      ? Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              ButtonComponent(
                                color: vermelhoColor,
                                colorHover: vermelhoColorHover,
                                onPressed: () {
                                  exibirModalReprovacao(
                                    context,
                                    aprovacao: false,
                                  );
                                },
                                text: 'Reprovar',
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              ButtonComponent(
                                onPressed: () {
                                  _showModalConfirmacao(context,
                                      aprovacao: true);
                                },
                                text: 'Aprovar',
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }

  void _showModalConfirmacao(BuildContext context, {required bool aprovacao}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Aviso'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Antes de aprovar essa solicitação, será\nnecessário preencher os campos abaixo.\n'),
                  ],
                ),
                Column(
                  verticalDirection: VerticalDirection.down,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: EdgeInsets.only(bottom: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Obx(() {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SelectableText(
                                'Condições do Produto',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<
                                      SolicitacaoOsClassificacaoProdutoEnum>(
                                    value:
                                        controller.classificacaoProduto.value,
                                    hint: Text('Condições do Produto'),
                                    onChanged:
                                        (SolicitacaoOsClassificacaoProdutoEnum?
                                            sucata) {
                                      if (sucata != null) {
                                        controller.classificacaoProduto.value =
                                            sucata;
                                      }
                                    },
                                    items: SolicitacaoOsClassificacaoProdutoEnum
                                        .values
                                        .map<
                                                DropdownMenuItem<
                                                    SolicitacaoOsClassificacaoProdutoEnum>>(
                                            (value) {
                                      return DropdownMenuItem<
                                          SolicitacaoOsClassificacaoProdutoEnum>(
                                        value: value,
                                        child: Text(value.name),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputComponent(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        label: "Obervações adicionais",
                        onChanged: (value) {
                          if (value != null) {
                            controller.solicitacao.observacaoAprovacao =
                                value.toString();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (controller.solicitacao.observacaoAprovacao !=
                            null) {
                          controller.solicitacao.observacaoAprovacao =
                              null; //reseta a variavel
                        }
                        if (controller.classificacaoProduto.value != null) {
                          controller.classificacaoProduto.value = null;
                        }
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar"),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    TextButton(
                      onPressed: () async {
                        if (controller.classificacaoProduto.value == null) {
                          Notificacao.snackBar('Informe a condição do produto!',
                              tipoNotificacao: TipoNotificacaoEnum.error);
                          return;
                        }
                        if (controller.solicitacao.observacaoAprovacao ==
                            null) {
                          Notificacao.snackBar('Informe uma observação!',
                              tipoNotificacao: TipoNotificacaoEnum.error);
                          return;
                        }
                        if (controller.solicitacao.observacaoAprovacao
                                .toString()
                                .length <
                            5) {
                          Notificacao.snackBar(
                              'A observação deve ter pelo menos 5 caracteres!',
                              tipoNotificacao: TipoNotificacaoEnum.error);
                          return;
                        }
                        Navigator.pop(context);
                        if (await controller.atualizarSolicitacao(
                          aprovacao: aprovacao,
                        )) {
                          // Get.delete<SolicitacaoOSDetalheController>();
                          // Get.offAllNamed('/solicitacao-os');
                          Get.back();
                        }
                      },
                      child: Text('Confirmar'),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void exibirModalReprovacao(BuildContext context,
      {required bool aprovacao}) async {
    controller.buscarMotivosReprovacaoSolicitacaoOs();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Aviso'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Antes de reprovar essa solicitação será\nnecessário informar o motivo da recusa.\n'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SelectableText(
                      'Motivo',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: EdgeInsets.only(bottom: 24),
                      child: Obx(() => !controller
                              .carregandoMotivosReprovacao.value
                          ? DropdownSearch<MotivoReprovacaoSolicitacaoOsModel>(
                              mode: Mode.MENU,
                              items: controller.motivosReprovacao,
                              isFilteredOnline: false,
                              showSearchBox: false,
                              itemAsString: (MotivoReprovacaoSolicitacaoOsModel?
                                      motivo) =>
                                  motivo!.descricaoMotivo.toString(),
                              onChanged:
                                  (MotivoReprovacaoSolicitacaoOsModel? motivo) {
                                if (motivo != null) {
                                  controller.solicitacao.idMotivoReprovacao =
                                      motivo.idMotivoReprovacaoSolicitacaoOs;
                                }
                              },
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  contentPadding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10),
                                  border: InputBorder.none,
                                  labelText: 'Pesquisar por motivo',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                                style: const TextStyle(color: Colors.black),
                              ),
                              dropdownSearchDecoration: InputDecoration(
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                // labelText: 'Motivo da reprovação',
                              ),
                              emptyBuilder: (context, value) {
                                return Center(
                                  child: TextComponent(
                                    'Nenhum motivo encontrado',
                                    textAlign: TextAlign.center,
                                    color: Colors.grey.shade400,
                                  ),
                                );
                              },
                              dropDownButton: const Icon(
                                Icons.expand_more_rounded,
                                color: Colors.grey,
                              ),
                              popupBackgroundColor: Colors.white,
                              showAsSuffixIcons: true,
                            )
                          : LoadingComponent()),
                    ),
                  ],
                ),
                InputComponent(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  label: "Obervações adicionais",
                  onChanged: (value) {
                    controller.solicitacao.observacaoReprovacao =
                        value.toString();
                  },
                ),
                Obx(
                  () => !controller.carregandoMotivosReprovacao.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancelar"),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            TextButton(
                              onPressed: () async {
                                if (controller.solicitacao.idMotivoReprovacao ==
                                    null) {
                                  Notificacao.snackBar(
                                      'Informe o motivo da reprovação!',
                                      tipoNotificacao:
                                          TipoNotificacaoEnum.error);
                                  return;
                                }
                                Navigator.pop(context);
                                if (await controller.atualizarSolicitacao(
                                  aprovacao: aprovacao,
                                )) {
                                  // Get.delete<SolicitacaoOSDetalheController>();
                                  // Get.offAllNamed('/solicitacao-os');
                                  Get.back();
                                }
                              },
                              child: Text('Confirmar'),
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
              ],
            ),
          );
        });
  }

  Widget _buildMotivoReprovacaoSolicitacaoOs() {
    return controller.solicitacao.situacao == 3
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 32,
                  bottom: 20,
                ),
                child: TextComponent(
                  'Reprovação',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  InputComponent(
                    label: 'Motivo',
                    initialValue: controller.solicitacao
                        .motivoReprovacaoSolicitacaoOs?.descricaoMotivo,
                    readOnly: true,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  InputComponent(
                    label: 'Observações adicionais',
                    maxLines: 5,
                    initialValue:
                        controller.solicitacao.observacaoReprovacao != null
                            ? controller.solicitacao.observacaoReprovacao
                            : '-',
                    readOnly: true,
                  ),
                ],
              ),
            ],
          )
        : Container();
  }

  Widget _buildMotivoAprovacaoSolicitacaoOs() {
    return controller.solicitacao.situacao == 2
        ? Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 32,
                    bottom: 20,
                  ),
                  child: TextComponent(
                    'Aprovação',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InputComponent(
                        label: 'Observações adicionais',
                        maxLines: 5,
                        initialValue:
                            controller.solicitacao.observacaoAprovacao != null
                                ? controller.solicitacao.observacaoAprovacao
                                : '-',
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputComponent(
                        label: 'Classificação Produto',
                        initialValue:
                            controller.solicitacao.classificacaoProduto != null
                                ? controller.aux.value
                                : '-',
                        readOnly: true,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        : Container();
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
        child: Obx(
          () => !controller.carregandoSolicitacao.value
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCamposIniciais(),
                      _buildCamposNotaFiscalVenda(),
                      _buildCamposNotaFiscalTroca(),
                      _buildProduto(),
                      _buildDefeitos(),
                      _buildChecklist(),
                      _buildCamposObservacoesAdicionais(),
                      _buildImagens(),
                      _buildCategoriaNumeroSerie(),
                      _buildCategoriaCondicaProduto(),
                      _buildCategoriaDefeito(),
                      _buildVideos(controller.solicitacao.caminhoVideo),
                      _buildDigitalizacoes(),
                      _buildMotivoReprovacaoSolicitacaoOs(),
                      _buildMotivoAprovacaoSolicitacaoOs(),
                      _buildBotoesPrincipais(context),
                    ],
                  ),
                )
              : Center(
                  child: LoadingComponent(),
                ),
        ),
      ),
    );
  }
}
