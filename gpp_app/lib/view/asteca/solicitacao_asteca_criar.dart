import 'package:auth_migration/domain/model/motivo_pecas_model.dart';
import 'package:auth_migration/domain/service/solicitacao_asteca_service.dart';
import 'package:auth_migration/shared/components/InputComponent.dart';
import 'package:auth_migration/shared/components/LoadingComponent.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:auth_migration/shared/components/TextComponent.dart';
import 'package:auth_migration/shared/components/CheckboxComponent.dart';
import 'package:auth_migration/shared/widgets/CardWidget.dart';
import 'package:auth_migration/shared/widgets/NavBarWidget.dart';
import 'package:auth_migration/widgets/sidebar_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/model/asteca_motivo_model.dart';
import '../../domain/model/enumeradores/tipo_asteca_enum.dart';
import '../../shared/components/ButtonComponent.dart';
import '../../shared/components/TitleComponent.dart';
import '../../shared/components/button_acao_widget.dart';
import '../../shared/components/evento_status_widget.dart';
import '../../shared/components/styles.dart';

class SolicitacaoAstecaCriar extends StatelessWidget {
  SolicitacaoAstecaCriar({Key? key}) : super(key: key);
  final controller = Get.put(SolicitacaoAstecaService());

  Widget _camposIniciais(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TextComponent('Criar Asteca'),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: TextComponent(
                'ID Produto',
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                // margin: EdgeInsets.only(bottom: 5),
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5)),
                child: InputComponent(
                  controller: controller.txtIdProduto,
                  keyboardType: TextInputType.number,
                  hintText: 'ID',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (controller.txtIdProduto.text == null ||
                          controller.txtIdProduto.text == '') {
                        Notificacao.snackBar(
                          'Digite o ID do produto!',
                          tipoNotificacao: TipoNotificacaoEnum.error,
                        );
                      } else {
                        final houveErro =
                            await controller.notasFiscaisPorProduto(
                                controller.txtIdProduto.text);
                        if (houveErro) {
                          modalListaNotasFiscais(context);
                        }
                      }
                    },
                    icon: const Icon(Icons.arrow_right_alt_outlined),
                  ),
                  inputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      Notificacao.snackBar('Infomar o produto é obrigatório',
                          tipoNotificacao: TipoNotificacaoEnum.error);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
                child: TextComponent(
              'Produto',
              textAlign: TextAlign.start,
            ))
          ],
        ),
        Row(
          children: [
            Obx(() {
              if (controller.notaFiscalSelecionada.value == null) {
                return Expanded(
                    child: InputComponent(
                  readOnly: true,
                ));
              }
              return Expanded(
                  child: InputComponent(
                hintText: controller.notaFiscalSelecionada.value?.descricao
                    .toString(),
                readOnly: true,
                decoration: InputDecoration(),
              ));
            }),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SelectableText(
                    'Motivo',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Obx(
                      () => !controller.carregandoMotivoCriacaoAsteca.value
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: DropdownSearch<AstecaMotivo>(
                                dropdownSearchDecoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                isFilteredOnline: true,
                                showSearchBox: true,
                                hint: 'Motivo',
                                mode: Mode.MENU,
                                items: controller.motivosCriacaoAstecaList,
                                itemAsString: (AstecaMotivo? motivos) =>
                                    motivos!.denominacao.toString(),
                                onChanged: (value) {
                                  controller.motivoCriacaoAsteca.value = value!;
                                },
                                onSaved: (value) {
                                  controller.pedidoAsteca.value
                                      .motivoCriacaoAsteca = value;
                                },
                              ),
                            )
                          : const LoadingComponent(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(children: [
          Expanded(
            child: Obx(
              () {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SelectableText(
                        'Atendimento',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<TipoAstecaEnum>(
                            value: controller.tipoAstecaEnum.value,
                            hint: const Text('Atendimento'),
                            onChanged: (value) {
                              controller.tipoAstecaEnum.value = value;
                            },
                            items: TipoAstecaEnum.values
                                .map<DropdownMenuItem<TipoAstecaEnum>>(
                                    (status) {
                              return DropdownMenuItem<TipoAstecaEnum>(
                                value: status,
                                child: Text(status.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ]),
        Row(
          children: [
            const Icon(
              Icons.article,
              size: 32,
            ),
            const SizedBox(
              width: 8,
            ),
            const TitleComponent('Nota Fiscal'),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          color: Colors.grey.shade200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: const TextComponent(
                  'NF',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: const TextComponent(
                  'Série',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 2,
                child: const TextComponent(
                  'Dt Emissão',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: const TextComponent(
                  'Desc',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: const TextComponent(
                  'Fornec',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          color: Colors.white,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (controller.notaFiscalSelecionada.value == null) {
                  return SizedBox.shrink();
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                          controller.notaFiscalSelecionada.value!.numDocFiscal
                              .toString(),
                          style: textStyle(
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                    Expanded(
                      child: Text(
                          controller.notaFiscalSelecionada.value!.serieDocFiscal
                              .toString(),
                          style: textStyle(
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                    Expanded(
                      flex: 2,
                      child: SelectableText(
                        DateFormat('dd/MM/yyyy').format(DateTime.parse(
                            controller
                                .notaFiscalSelecionada.value!.dataEmissao!)),
                      ),
                    ),
                    Expanded(
                      child: Text(
                          controller.notaFiscalSelecionada.value!.descricao
                              .toString(),
                          overflow: TextOverflow.ellipsis,
                          style: textStyle(
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                    Expanded(
                      child: Text(
                          controller.notaFiscalSelecionada.value!.fornecedor
                              .toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: textStyle(
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Widget _tabelaPecasAsteca(BuildContext context) {
    return Obx(
      () => controller.idNotaFiscalSelecionada.value != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.handyman_rounded,
                          size: 32,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 150,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          controller.carregando.value != false
                              ? const EventoStatusWidget(
                                  color: Colors.pink,
                                  texto: 'Atendimento finalizado')
                              : controller.carregando.value != true
                                  ? Obx(
                                      () => !controller.carregando.value
                                          ? ButtonComponent(
                                              color: primaryColor,
                                              colorHover: primaryColorHover,
                                              onPressed: () {
                                                _showProdutos(context);
                                                controller.estoquePecasProduto(
                                                    controller
                                                        .txtIdProduto.text);
                                                //  controller
                                                //      .buscarMotivosPecaCriarAsteca();
                                              },
                                              text: 'Adicionar peças',
                                            )
                                          : const LoadingComponent(),
                                    )
                                  : const LoadingComponent(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.40,
                  child: controller.pedidoAsteca.value.itensAsteca != null
                      ? ListView.builder(
                          itemCount: controller
                                  .pedidoAsteca.value.itensAsteca?.length ??
                              controller.itemSolicitacaoCricaoAsteca.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: GetBuilder<SolicitacaoAstecaService>(
                                id: 'listadePecaSelecionada',
                                builder: (_) {
                                  _.quantidade.add(new TextEditingController(
                                      text: 1.toString()));
                                  return Card(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: _.statusSaldoPeca(index),
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey.shade100),
                                              left: BorderSide(
                                                  color: Colors.grey.shade100),
                                              bottom: BorderSide(
                                                  color: Colors.grey.shade100),
                                              right: BorderSide(
                                                  color:
                                                      Colors.grey.shade100))),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Expanded(
                                                child: TextComponent(
                                                  'ID',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: SelectableText(
                                                    '${_.pedidoAsteca.value.itensAsteca![index].pecaEstoque?.peca?.idPeca}'),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            children: [
                                              const Expanded(
                                                child: TextComponent(
                                                  'Nome',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: SelectableText(
                                                  '${_.pedidoAsteca.value.itensAsteca![index].pecaEstoque?.peca?.descricao}',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            children: [
                                              const Expanded(
                                                child: TextComponent(
                                                  'Nº Peças',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: SelectableText(
                                                    '${_.itemSolicitacaoCricaoAsteca[index].pecaEstoque?.peca?.numero}'),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            children: [
                                              const Expanded(
                                                child: TextComponent(
                                                  'Valor R\$',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: SelectableText(
                                                    '${_.pedidoAsteca.value.itensAsteca?[index].pecaEstoque?.peca?.custo ?? 0.00}'),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            children: [
                                              const Expanded(
                                                child: TextComponent(
                                                  'Subtotal R\$',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: SelectableText('R\$: ' +
                                                    '${((_.pedidoAsteca.value.itensAsteca?[index].quantidade ?? 0) * (_.pedidoAsteca.value.itensAsteca?[index].pecaEstoque?.peca?.custo ?? 0))}'),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            children: [
                                              const Expanded(
                                                child: TextComponent(
                                                  'Saldo',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: SelectableText(
                                                    '${_.pedidoAsteca.value.itensAsteca![index].pecaEstoque?.saldoDisponivel}'),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          const TextComponent(
                                            'Quantidade',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                color: Colors.red,
                                                onPressed: () {
                                                  controller
                                                      .removerQuantidade(index);
                                                  _.buildSituacaoEstoque(index);
                                                },
                                                icon: const Icon(
                                                  Icons.remove_circle_outlined,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: InputComponent(
                                                  key: UniqueKey(),
                                                  maxLines: 1,
                                                  controller:
                                                      _.quantidade[index],
                                                  inputFormatter: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  onChanged: (value) {},
                                                  onFieldSubmitted: (value) {},
                                                ),
                                              ),
                                              IconButton(
                                                color: Colors.green,
                                                onPressed: () {
                                                  controller
                                                      .adicionarQuantidade(
                                                          index);
                                                  _.buildSituacaoEstoque(index);
                                                },
                                                icon: const Icon(
                                                  Icons.add_circle_outlined,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      controller
                                                          .removerPeca(index);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.redAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10),
                                                        child: Icon(
                                                          Icons.delete_rounded,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          })
                      : Container(),
                ),
              ],
            )
          : Container(),
    );
  }

  Widget _buildBotaoPrincipal(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 64,
          child: ButtonComponent(
            color: Colors.red,
            onPressed: () {
              Get.offAllNamed('/home');
            },
            text: 'Fechar',
          ),
        ),
        const SizedBox(
          width: 150,
        ),
        Obx(() => controller.pedidoAsteca.value.itensAsteca != null
            ? Expanded(
                child: SizedBox(
                  child: ButtonComponent(
                    color: primaryColor,
                    onPressed: () async {
                      if (await controller.salvarAsteca()) {
                        Get.offAllNamed('/astecas');
                      }
                    },
                    text: 'Criar Asteca',
                  ),
                ),
              )
            : Container()),
      ],
    );
  }

  void _showProdutos(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.settings,
                size: 32,
              ),
              SizedBox(
                width: 12,
              ),
              TitleComponent('Peças'),
            ],
          ),
          content: Container(
            width: Get.width * 0.8,
            height: Get.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: TextComponent(
                    'Selecione um ou mais peças para realizar a manutenção do Produto',
                    letterSpacing: 0.15,
                    fontSize: 16,
                  ),
                ),
                Form(
                  child: Column(
                    children: [
                      InputComponent(
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        hintText: 'Descrição do produto',
                        onSaved: (value) {},
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ButtonComponent(
                        color: secundaryColor,
                        colorHover: secundaryColorHover,
                        icon: Icon(Icons.search, color: Colors.white),
                        onPressed: () async {
                          controller.estoquePecasProduto(
                              controller.txtIdProduto.text);
                        },
                        text: 'Pesquisar',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => !controller.carregandoEstoquePecas.value
                      ? Expanded(
                          child: ListView.separated(
                            itemCount: controller.pecasEstoque.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: GetBuilder<SolicitacaoAstecaService>(
                                  id: 'modalListaPecas',
                                  builder: (_) {
                                    return CardWidget(
                                      widget: Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const TextComponent(
                                                    'ID: ',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                                  Expanded(
                                                    child: TextComponent(
                                                      controller
                                                          .pecaSelecionada[
                                                              index]
                                                          .produtoPeca
                                                          .idPecaEstoque
                                                          .toString(),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  const TextComponent(
                                                    'Cod.Fábrica: ',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${controller.pecaSelecionada[index].produtoPeca.peca?.codigoFabrica}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const TextComponent(
                                                    'N° Peças: ',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                                  TextComponent(
                                                    '${controller.pecaSelecionada[index].produtoPeca.peca?.numero}',
                                                  ),
                                                  const Expanded(
                                                      child: SizedBox(
                                                    width: 2,
                                                  )),
                                                  const TextComponent(
                                                    'Valor R\$: ',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  TextComponent(
                                                    '${controller.pecaSelecionada[index].produtoPeca.peca?.custo}',
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const TextComponent(
                                                    'Nome: ',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        '${controller.pecaSelecionada[index].produtoPeca.peca?.descricao.toString().capitalize}',
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CheckboxComponent(
                                                  value: _
                                                      .pecaSelecionada[index]
                                                      .marcado,
                                                  onChanged: (bool value) {
                                                    _.checkBoxListaPeca(
                                                        value, index);
                                                  }),
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
                              return const SizedBox(
                                height: 8,
                              );
                            },
                          ),
                        )
                      : Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 18),
                            child: const LoadingComponent(),
                          ),
                        ),
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
                          Get.back();
                        },
                        text: 'Cancelar',
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ButtonComponent(
                        onPressed: () {
                          controller.adicionarPecaSelecionadas();
                          Get.back();
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

  void modalListaNotasFiscais(BuildContext context) {
    final controller = Get.put(SolicitacaoAstecaService());
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(
                          textAlign: TextAlign.center,
                          'Relações de Notas Fiscais:',
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InputComponent(
                            controller: controller.txtIdDocumento,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onFieldSubmitted: () async {
                              if (controller.txtIdDocumento.text == null ||
                                  controller.txtIdDocumento.text == '') {
                                Notificacao.snackBar('Campo obrigatório!',
                                    tipoNotificacao: TipoNotificacaoEnum.error);
                              } else {
                                await controller.buscarNotaModal(
                                    controller.txtIdProduto.text,
                                    controller.txtIdDocumento.text);
                              }
                            },
                            hintText: 'Buscar',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 80,
                          child: ButtonComponent(
                            onPressed: () async {
                              if (controller.txtIdDocumento.text == null ||
                                  controller.txtIdDocumento.text == '') {
                                Notificacao.snackBar('Campo obrigatório!',
                                    tipoNotificacao: TipoNotificacaoEnum.error);
                              } else {
                                await controller.buscarNotaModal(
                                    controller.txtIdProduto.text,
                                    controller.txtIdDocumento.text);
                              }
                            },
                            text: 'Buscar',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(
                  () => !controller.carregandoNotasFiscais.value
                      ? SizedBox(
                          height: Get.height / 2,
                          width: Get.width,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.documentosFiscais.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.selecionarNotaFiscal(
                                        controller.documentosFiscais[index]);
                                  },
                                  child: GetBuilder<SolicitacaoAstecaService>(
                                    builder: (_) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color:
                                              _.idNotaFiscalSelecionada.value ==
                                                      _.documentosFiscais[index]
                                                          .idDocumentoFiscal
                                                  ? const Color.fromRGBO(
                                                      24, 2, 153, 0.2)
                                                  : Colors.white,
                                          border: Border.all(
                                            width: 1,
                                            color: _.idNotaFiscalSelecionada
                                                        .value ==
                                                    _.documentosFiscais[index]
                                                        .idDocumentoFiscal
                                                ? primaryColor
                                                : const Color.fromRGBO(
                                                    238, 238, 238, 1),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: CardWidget(
                                            widget: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const TextComponent(
                                                    'NF',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  TextComponent(
                                                    '${controller.documentosFiscais[index].idDocumentoFiscal}',
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const TextComponent(
                                                    'Série',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  TextComponent(
                                                    '${controller.documentosFiscais[index].serieDocFiscal}',
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const TextComponent(
                                                    'Dt. Emissão',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  TextComponent('',
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Expanded(
                                                      child: TextComponent(
                                                    'Desc',
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    controller
                                                        .documentosFiscais[
                                                            index]
                                                        .descricao
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12),
                                                  )),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Expanded(
                                                      child: TextComponent(
                                                    'Fornecedor',
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    controller
                                                        .documentosFiscais[
                                                            index]
                                                        .fornecedor
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12),
                                                  )),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const TextComponent(
                                                    'Ação',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  ButtonAcaoWidget(detalhe: () {
                                                    var idDocumentoFiscal =
                                                        controller
                                                            .documentosFiscais[
                                                                index]
                                                            .idDocumentoFiscal;
                                                    // if (numeromaxguias < 1) {
                                                    //   var Url =
                                                    //       html.window.location;
                                                    //   html.window.open(
                                                    //       Url.toString()
                                                    //               .split('#')[0] +
                                                    //           '/#/astecas/itens-nf/' +
                                                    //           idDocumentoFiscal
                                                    //               .toString(),
                                                    //       'new tab');
                                                    //   numeromaxguias++;
                                                    // } else {
                                                    //   Notificacao.snackBar(
                                                    //       'Já existe uma guia aberta!',
                                                    //       tipoNotificacao:
                                                    //           TipoNotificacaoEnum
                                                    //               .error);
                                                    // }
                                                  })
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                      );
                                    },
                                  ),
                                );
                              }),
                        )
                      : const LoadingComponent(),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonComponent(
                        color: Colors.red,
                        onPressed: () {
                          controller.confirmarSelecaoNotaFiscal(tipoSelecao: 0);
                          controller.carregandoNotasFiscais.value = false;
                          Get.back();
                        },
                        text: 'Cancelar',
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ButtonComponent(
                        color: const Color.fromRGBO(4, 4, 145, 1),
                        onPressed: () {
                          if (controller.idNotaFiscalSelecionada.value ==
                              null) {
                            Notificacao.snackBar('Nota Fiscal não selecionada',
                                tipoNotificacao: TipoNotificacaoEnum.error);
                            return;
                          }
                          controller.confirmarSelecaoNotaFiscal(tipoSelecao: 1);
                          Get.back();
                        },
                        text: 'Confirmar',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarWidget(),
      drawer: const Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _camposIniciais(context),
                              _tabelaPecasAsteca(context),
                              // _buildCamposImagensNumeroSerie(context),
                              // _buildCamposImagensCondicaoProduto(),
                              // _buildCamposImagensDefeitos(),
                              // _buildCamposVideo(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildBotaoPrincipal(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
