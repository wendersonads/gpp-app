import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/models/produto/produto_model.dart';
import 'package:gpp/src/models/produto_peca_model.dart';
import 'package:gpp/src/repositories/pecas_repository/produto_repositoy.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';

import '../../../shared/components/CheckboxComponent.dart';
import '../../../shared/components/InputComponent.dart';

class ProdutoDetalheController extends GetxController {
  late int id;
  TextEditingController? pesquisar;
  var count = 0;
  var carregando = true.obs;
  var carregandoProdutoPecas = true.obs;
  var carregandoImportacaoPecas = false.obs;
  late ProdutoRepository produtoRepository;
  late List<ProdutoModel> produtos;
  late List<ProdutoPecaModel> produtoPecas;
  late List<ItemPeca> itensPeca;
  late MaskFormatter maskFormatter;
  late GlobalKey<FormState> formKey;
  int marcados = 0;
  late ProdutoModel produto;
  var etapa = 1.obs;
  late ProdutoRepository repositoryProduto;

  ProdutoDetalheController(int id) {
    pesquisar = TextEditingController();
    produtoRepository = ProdutoRepository();
    produtos = <ProdutoModel>[].obs;
    produtoPecas = <ProdutoPecaModel>[].obs;
    itensPeca = [];
    formKey = GlobalKey<FormState>();
    maskFormatter = MaskFormatter();
    this.id = id;
    produto = ProdutoModel();
    repositoryProduto = ProdutoRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    await buscarProduto();
    await buscarProdutoPecas();
  }

  @override
  void onClose() {
    super.onClose();
  }

  buscarProduto() async {
    try {
      carregando(true);
      this.produto = await produtoRepository.buscarProduto(this.id);
    } finally {
      carregando(false);
    }
  }

  buscarProdutoPecas() async {
    try {
      carregandoProdutoPecas(true);
      this.produtoPecas = await produtoRepository.buscarProdutoPecas(this.id, pesquisar: this.pesquisar?.text);
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoProdutoPecas(false);
      update();
    }
  }

  deletarProdutoPeca(idProduto, idPeca) async {
    try {
      if (await produtoRepository.deletarProdutoPeca(idProduto, idPeca)) {
        buscarProdutoPecas();
        Notificacao.snackBar('Peça excluida com sucesso');
      }
    } catch (e) {}
  }

  selecionarTodos(bool value) {
    if (value) {
      marcados = itensPeca.length;
    } else {
      marcados = 0;
    }
    for (var itemPeca in itensPeca) {
      itemPeca.marcado = value;
    }
    update();
  }

  selecionar(index, value) {
    if (value) {
      marcados++;
    } else {
      marcados--;
    }
    itensPeca[index].marcado = value;
    update();
  }

  void importarPecas(int idProduto) async {
    FilePickerResult? arquivo =
        await FilePicker.platform.pickFiles(allowedExtensions: ['csv'], type: FileType.custom, allowMultiple: false);

    if (arquivo != null) {
      //importado
      extrairDadosCSV(arquivo);
      preVisualizarArquivo(idProduto);
    } else {
      //não importado
    }
  }

  void downloadTemplate(int idProduto) {
    repositoryProduto.downloadTemplate(idProduto);
  }

  void extrairDadosCSV(arquivo) {
    try {
      //Decodifica em bytes para utf8
      final bytes = utf8.decode(arquivo.files.first.bytes);
      List<List<dynamic>> dados = const CsvToListConverter().convert(bytes);
      //Limpa a lista de itens de peças
      itensPeca.clear();
      marcados = 0;

      for (var dado in dados.skip(1)) {
        marcados++;

        /** 
     * Falta adicionar a cor e qtd
     */
        itensPeca.add(ItemPeca(
            marcado: true,
            produtoPeca: new ProdutoPecaModel(
              quantidadePorProduto: int.tryParse(dado.elementAt(3).toString()),
              peca: new PecasModel(
                codigo_fabrica: dado.elementAt(0).toString(), //Descrição
                volumes: dado.elementAt(1).toString(), // Volumes
                descricao: dado.elementAt(2).toString(),
                profundidade: double.tryParse(dado.elementAt(4).toString()),
                altura: double.tryParse(dado.elementAt(5).toString()), // Altura
                largura: double.tryParse(
                  dado.elementAt(6).toString(),
                ),
                cor: dado.elementAt(7).toString(),
                // Largura
              ),
            )));
      }
    } catch (e) {}
  }

  inserirProdutoPecas(int idProduto) async {
    try {
      if (await Notificacao.confirmacao('Gostaria de importar ${marcados} peças ?')) {
        gerarListaProdutoPeca();

        carregandoImportacaoPecas(true);
        if (await produtoRepository.inserirProdutoPecas(idProduto, gerarListaProdutoPeca())) {
          buscarProdutoPecas();
          Get.back();

          Notificacao.snackBar('Peças importadas com sucesso');
        }
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoImportacaoPecas(false);
    }
  }

  gerarListaProdutoPeca() {
    List<ProdutoPecaModel> produtoPecas = [];
    itensPeca.forEach((itemPeca) async {
      //Se o item estiver marcado, realiza a inserção
      if (itemPeca.marcado) {
        produtoPecas.add(itemPeca.produtoPeca);
      }
    });

    return ProdutoModel(produtoPecas: produtoPecas);
  }

  preVisualizarArquivo(idProduto) async {
    Get.dialog(AlertDialog(
      content: Container(
        height: Get.height * 0.8,
        width: Get.width * 0.8,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    Icon(
                      Icons.upload_file_rounded,
                      size: 32,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    TitleComponent('Importar peças')
                  ],
                ),
              ),
              Row(children: [
                GetBuilder<ProdutoDetalheController>(
                  builder: (_) => CheckboxComponent(
                    value: marcados == itensPeca.length,
                    onChanged: (bool value) {
                      selecionarTodos(value);
                    },
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextComponent(
                    'Código de fábrica',
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextComponent(
                    'Volumes',
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextComponent(
                    'Descrição',
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextComponent(
                    'Quantidade de peças por produto',
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextComponent(
                    'Comprimento',
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextComponent(
                    'Altura',
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextComponent(
                    'Largura',
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextComponent(
                    'Cor',
                  ),
                ),
              ]),
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView.builder(
                    itemCount: itensPeca.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GetBuilder<ProdutoDetalheController>(
                                  builder: (_) => CheckboxComponent(
                                      value: itensPeca[index].marcado, onChanged: (bool value) => selecionar(index, value))),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                  initialValue: itensPeca[index].produtoPeca.peca!.codigo_fabrica.toString(),
                                  onSaved: (value) {
                                    itensPeca[index].produtoPeca.peca!.codigo_fabrica = value;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                  initialValue: itensPeca[index].produtoPeca.peca!.volumes.toString(),
                                  onSaved: (value) {
                                    itensPeca[index].produtoPeca.peca!.volumes = value;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                  onSaved: (value) {
                                    itensPeca[index].produtoPeca.peca!.descricao = value;
                                  },
                                  initialValue: itensPeca[index].produtoPeca.peca!.descricao.toString(),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                  initialValue: itensPeca[index].produtoPeca.quantidadePorProduto?.toString() ?? '',
                                  onSaved: (value) {
                                    itensPeca[index].produtoPeca.quantidadePorProduto = int.tryParse(value);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                  initialValue: maskFormatter
                                      .medida(value: itensPeca[index].produtoPeca.peca!.profundidade.toString())
                                      .getMaskedText(),
                                  inputFormatter: [maskFormatter.medida()],
                                  onSaved: (value) {
                                    itensPeca[index].produtoPeca.peca!.profundidade =
                                        double.tryParse(UtilBrasilFields.removeCaracteres(value ?? ''));
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                  initialValue: maskFormatter
                                      .medida(value: itensPeca[index].produtoPeca.peca!.altura.toString())
                                      .getMaskedText(),
                                  inputFormatter: [maskFormatter.medida()],
                                  onSaved: (value) {
                                    itensPeca[index].produtoPeca.peca!.largura =
                                        double.tryParse(UtilBrasilFields.removeCaracteres(value ?? ''));
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                  initialValue: maskFormatter
                                      .medida(value: itensPeca[index].produtoPeca.peca!.largura.toString())
                                      .getMaskedText(),
                                  inputFormatter: [maskFormatter.medida()],
                                  onSaved: (value) {
                                    itensPeca[index].produtoPeca.peca!.largura =
                                        double.tryParse(UtilBrasilFields.removeCaracteres(value ?? ''));
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: InputComponent(
                                initialValue: itensPeca[index].produtoPeca.peca!.cor,
                                onSaved: (value) {
                                  itensPeca[index].produtoPeca.peca!.cor = value; //Cor
                                },
                              )),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Obx(
                () => !carregandoImportacaoPecas.value
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GetBuilder<ProdutoDetalheController>(
                                builder: (_) => TextComponent('Total de peças selecionadas: ${marcados}')),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ButtonComponent(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  text: 'Cancelar',
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                ButtonComponent(
                                    onPressed: () {
                                      //formKey save
                                      formKey.currentState!.save();

                                      inserirProdutoPecas(idProduto);
                                    },
                                    text: 'Importar peças'),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Container(margin: EdgeInsets.symmetric(horizontal: 8), child: LoadingComponent()),
                          TextComponent('Importando peças...'),
                        ]),
                      ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class ItemPeca {
  bool marcado = false;
  late ProdutoPecaModel produtoPeca;
  ItemPeca({required this.marcado, required this.produtoPeca});
}
