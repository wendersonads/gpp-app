import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/pecas_controller/peca_controller.dart';
import 'package:gpp/src/controllers/pecas_controller/pecas_grupo_controller.dart';
import 'package:gpp/src/controllers/pecas_controller/pecas_linha_controller.dart';
import 'package:gpp/src/controllers/pecas_controller/produto_controller.dart';
import 'package:gpp/src/models/pecas_model/pecas_especie_model.dart';
import 'package:gpp/src/models/pecas_model/pecas_grupo_model.dart';
import 'package:gpp/src/models/pecas_model/pecas_linha_model.dart';
import 'package:gpp/src/models/pecas_model/pecas_material_model.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/pecas/und_medida.dart';
import 'package:gpp/src/views/pecas/unidade.dart';

// ignore: must_be_immutable
class PecasEditAndView extends StatefulWidget {
  PecasModel? pecasEditPopup;
  bool? enabled;

  PecasEditAndView({this.pecasEditPopup, this.enabled});

  @override
  _PecasEditAndViewState createState() => _PecasEditAndViewState();
}

class _PecasEditAndViewState extends State<PecasEditAndView> {
  PecaController _pecasController = PecaController();
  PecasLinhaController _pecasLinhaController = PecasLinhaController();
  PecasGrupoController _pecasGrupoController = PecasGrupoController();
  ProdutoController _produtoController = ProdutoController();

  final txtIdProduto = TextEditingController();
  final txtNomeProduto = TextEditingController();
  final txtIdFornecedor = TextEditingController();
  final txtNomeFornecedor = TextEditingController();

  final txtIdLinha = TextEditingController();
  final txtIdEspecie = TextEditingController();
  final txtIdGrupo = TextEditingController();
  final txtIdMaterial = TextEditingController();

  PecasLinhaModel _selectedLinha = PecasLinhaModel(id_peca_linha: 1, linha: '', situacao: 1);
  PecasEspecieModel _selectedEspecie = PecasEspecieModel(id_peca_especie: 1, especie: '', situacao: 1);
  List<PecasEspecieModel> _pecasEspecieModel = [PecasEspecieModel(id_peca_especie: 1, especie: '', id_peca_linha: 1)];

  PecasGrupoModel _selectedGrupo = PecasGrupoModel(id_peca_grupo_material: 1, grupo: '', situacao: 1);
  PecasMaterialModel _selectedMaterial = PecasMaterialModel(id_peca_material_fabricacao: 1, material: '', situacao: 1);
  List<PecasMaterialModel> _pecasMaterialModel = [
    PecasMaterialModel(id_peca_material_fabricacao: 1, material: '', sigla: '', situacao: 1)
  ];

  UnidadeTipo? _selectedUnidadeTipo = UnidadeTipo.Unidade;
  UnidadeMedida? _selectedUnidadeMedida = UnidadeMedida.Centimetros;

  PecasModel? pecasEditPopup;

  buscaProduto(String codigo) async {
    await _produtoController.buscar(codigo);

    txtNomeProduto.text = _produtoController.produto.resumida.toString();
    txtIdFornecedor.text = _produtoController.produto.fornecedores!.first.idFornecedor.toString();
    txtNomeFornecedor.text = _produtoController.produto.fornecedores!.first.cliente!.nome.toString();
  }

  buscarLinhaEspecie(String codigo) async {
    await _pecasLinhaController.buscarEspecieVinculada(codigo);

    await _pecasLinhaController.buscarTodos();

    // print(await _pecasLinhaController.buscarEspecieVinculada(codigo));
  }

  editar(context) async {
    try {
      if (await _pecasController.editar()) {
        Notificacao.snackBar("Peça editada com sucesso!");
        Navigator.pop(context);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  EditarProdutoPeca(context) async {
    try {
      // _pecasController.produtoPecaModel.id_peca = _pecasModelInserido!.id_peca;

      if (await _pecasController.editarProdutoPeca()) {
        Notificacao.snackBar("Produto peça cadastrado com sucesso!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  @override
  void initState() {
    pecasEditPopup = widget.pecasEditPopup;
    if (pecasEditPopup != null) {
      _pecasController.pecasModel = pecasEditPopup!;
      txtIdProduto.text = _pecasController.pecasModel.produto_peca![0].id_produto.toString();
      buscaProduto(txtIdProduto.text);
    }

    if (_pecasController.pecasModel.pecasEspecieModel != null) {
      _selectedLinha = _pecasController.pecasModel.pecasEspecieModel!.linha!;
      txtIdLinha.text = _selectedLinha.id_peca_linha.toString();
      _selectedEspecie = _pecasController.pecasModel.pecasEspecieModel!;
      txtIdEspecie.text = _selectedEspecie.id_peca_especie.toString();
    }

    if (_pecasController.pecasModel.pecasMaterialModel != null) {
      _selectedGrupo = _pecasController.pecasModel.pecasMaterialModel!.grupo_material!;
      txtIdGrupo.text = _selectedGrupo.id_peca_grupo_material.toString();
      _selectedMaterial = _pecasController.pecasModel.pecasMaterialModel!;
      txtIdMaterial.text = _selectedMaterial.id_peca_material_fabricacao.toString();
    }

    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              Icon(widget.enabled == true ? Icons.edit : Icons.visibility),
              Padding(padding: EdgeInsets.only(right: 12)),
              TitleComponent(widget.enabled == true ? 'Editar Peças' : 'Visualizar Peças'),
            ],
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      controller: txtIdProduto,
                      keyboardType: TextInputType.number,
                      enabled: widget.enabled,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (value) {
                        _pecasController.produtoPecaModel.id_produto = int.parse(value);
                        _pecasController.produtoPecaModel.idProdutoPeca =
                            _pecasController.pecasModel.produto_peca![0].idProdutoPeca;

                        _pecasController.produtoPecaModel.peca?.id_peca = _pecasController.pecasModel.id_peca;
                      },
                      decoration: InputDecoration(
                        hintText: 'ID',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            await buscaProduto(txtIdProduto.text);

                            // _pecasController.produtoPecaModel.id_produto = int.parse(txtIdProduto.text);
                          },
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                // Fim Produto
                Flexible(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      controller: txtNomeProduto,
                      enabled: false,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nome Produto',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 30)),
                Flexible(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      controller: txtIdFornecedor,
                      enabled: false,
                      onChanged: (value) {
                        // _pecasController.pecasModel.id_fornecedor = int.parse(value);
                      },
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'ID',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Flexible(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      controller: txtNomeFornecedor,
                      enabled: false,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nome Fornecedor',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                      ),
                    ),
                  ),
                ),
                // Fim Fornecedor
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Row(
              children: [
                Flexible(
                  flex: 6,
                  child: InputComponent(
                    label: 'Descrição da Peça',
                    enable: widget.enabled,
                    initialValue: pecasEditPopup == null
                        ? ''
                        : _pecasController.pecasModel.descricao == null
                            ? ''
                            : _pecasController.pecasModel.descricao.toString(),
                    onChanged: (value) {
                      _pecasController.pecasModel.descricao = value;
                      _pecasController.pecasModel.volumes = "1";
                      _pecasController.pecasModel.active = 1;
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 30)),
                Flexible(
                  flex: 1,
                  child: InputComponent(
                    label: 'Quantidade',
                    enable: widget.enabled,
                    initialValue: pecasEditPopup == null
                        ? ''
                        : _pecasController.pecasModel.produto_peca == null
                            ? ''
                            : _pecasController.pecasModel.produto_peca![0].quantidadePorProduto.toString(),
                    onChanged: (value) {
                      _pecasController.produtoPecaModel.quantidadePorProduto = int.parse(value);
                    },
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: InputComponent(
                    label: 'Número',
                    enable: widget.enabled,
                    initialValue: pecasEditPopup == null
                        ? ''
                        : _pecasController.pecasModel.numero == null
                            ? ''
                            : _pecasController.pecasModel.numero.toString(),
                    onChanged: (value) {
                      _pecasController.pecasModel.numero = value;
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 30)),
                Flexible(
                  flex: 1,
                  child: InputComponent(
                    enable: widget.enabled,
                    label: 'Código de Fabrica',
                    initialValue: pecasEditPopup == null
                        ? ''
                        : _pecasController.pecasModel.codigo_fabrica == null
                            ? ''
                            : _pecasController.pecasModel.codigo_fabrica.toString(),
                    onChanged: (value) {
                      _pecasController.pecasModel.codigo_fabrica = value;
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 30)),
                Flexible(
                  flex: 1,
                  child: InputComponent(
                    label: 'Custo R\$',
                    enable: widget.enabled,
                    initialValue: pecasEditPopup == null
                        ? ''
                        : _pecasController.pecasModel.custo == null
                            ? ''
                            : _pecasController.pecasModel.custo.toString(),
                    onChanged: (value) {
                      _pecasController.pecasModel.custo = double.parse(value);
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 30)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextComponent('Unidade'),
                    Padding(padding: EdgeInsets.only(top: 6)),
                    Container(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IgnorePointer(
                        ignoring: !widget.enabled!,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<UnidadeTipo>(
                            value: UnidadeTipo.values[_selectedUnidadeTipo!.index],
                            onChanged: (UnidadeTipo? value) {
                              setState(() {
                                _selectedUnidadeTipo = value;

                                _pecasController.pecasModel.unidade = value!.index;
                              });
                            },
                            items: UnidadeTipo.values.map((UnidadeTipo? unidadeTipo) {
                              return DropdownMenuItem<UnidadeTipo>(value: unidadeTipo, child: Text(unidadeTipo!.name));
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Row(
              children: [
                Flexible(
                  child: InputComponent(
                    label: 'Largura',
                    enable: widget.enabled,
                    initialValue: pecasEditPopup == null
                        ? ''
                        : _pecasController.pecasModel.largura == null
                            ? ''
                            : _pecasController.pecasModel.largura.toString(),
                    onChanged: (value) {
                      _pecasController.pecasModel.largura = double.parse(value);
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 30)),
                Flexible(
                  child: InputComponent(
                    label: 'Altura',
                    enable: widget.enabled,
                    initialValue: pecasEditPopup == null
                        ? ''
                        : _pecasController.pecasModel.altura == null
                            ? ''
                            : _pecasController.pecasModel.altura.toString(),
                    onChanged: (value) {
                      _pecasController.pecasModel.altura = double.parse(value);
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 30)),
                Flexible(
                  child: InputComponent(
                    label: 'Profundidade',
                    enable: widget.enabled,
                    initialValue: pecasEditPopup == null
                        ? ''
                        : _pecasController.pecasModel.profundidade == null
                            ? ''
                            : _pecasController.pecasModel.profundidade.toString(),
                    onChanged: (value) {
                      _pecasController.pecasModel.profundidade = double.parse(value);
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
                      child: IgnorePointer(
                        ignoring: !widget.enabled!,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<UnidadeMedida>(
                            value: UnidadeMedida.values[_selectedUnidadeMedida!.index],
                            onChanged: (UnidadeMedida? value) {
                              setState(() {
                                _selectedUnidadeMedida = value;

                                _pecasController.pecasModel.unidade_medida = value!.index;
                              });
                            },
                            items: UnidadeMedida.values.map((UnidadeMedida? unidadeMedida) {
                              return DropdownMenuItem<UnidadeMedida>(value: unidadeMedida, child: Text(unidadeMedida!.name));
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextComponent('Linha'),
                      Padding(padding: EdgeInsets.only(top: 6)),
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                controller: txtIdLinha,
                                enabled: false,
                                onChanged: (value) {
                                  // _pecasController.pecasModel.id_fornecedor = int.parse(value);
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'ID',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Flexible(
                            flex: 5,
                            child: Container(
                              width: 600,
                              height: 48,
                              child: FutureBuilder(
                                future: _pecasLinhaController.buscarTodos(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return Text("Sem Conexão");
                                    case ConnectionState.active:
                                    case ConnectionState.waiting:
                                      return Center(child: new CircularProgressIndicator());
                                    case ConnectionState.done:
                                      return Container(
                                        padding: EdgeInsets.only(left: 12, right: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: IgnorePointer(
                                          ignoring: !widget.enabled!,
                                          child: DropdownSearch<PecasLinhaModel?>(
                                            mode: Mode.DIALOG,
                                            showSearchBox: true,
                                            items: snapshot.data,
                                            itemAsString: (PecasLinhaModel? value) => value!.linha!.toUpperCase(),
                                            onChanged: (value) {
                                              _selectedLinha = value!;
                                              txtIdLinha.text = value.id_peca_linha.toString();

                                              setState(() {
                                                _pecasEspecieModel = value.especie!;
                                              });
                                              // _pecasLinhaController.pecasLinhaModel.id_peca_linha = value!.id_peca_linha;
                                            },
                                            dropdownSearchDecoration: InputDecoration(
                                              enabledBorder: InputBorder.none,
                                            ),
                                            dropDownButton: Icon(
                                              Icons.arrow_drop_down_rounded,
                                              color: Colors.black,
                                            ),
                                            showAsSuffixIcons: true,
                                            selectedItem: _selectedLinha,
                                          ),
                                        ),
                                      );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 30)),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextComponent('Espécie'),
                      Padding(padding: EdgeInsets.only(top: 6)),
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                controller: txtIdEspecie,
                                enabled: false,
                                onChanged: (value) {
                                  // _pecasController.pecasModel.id_fornecedor = int.parse(value);
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'ID',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Flexible(
                            flex: 5,
                            child: Container(
                              width: 600,
                              height: 48,
                              padding: EdgeInsets.only(left: 12, right: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: IgnorePointer(
                                ignoring: !widget.enabled!,
                                child: DropdownSearch<PecasEspecieModel?>(
                                  mode: Mode.DIALOG,
                                  showSearchBox: true,
                                  items: _pecasEspecieModel,
                                  itemAsString: (PecasEspecieModel? value) => value!.especie!.toUpperCase(),
                                  onChanged: (value) {
                                    txtIdEspecie.text = value!.id_peca_especie.toString();

                                    _pecasController.pecasModel.id_peca_especie = value.id_peca_especie;
                                  },
                                  dropdownSearchDecoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                  ),
                                  dropDownButton: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.black,
                                  ),
                                  showAsSuffixIcons: true,
                                  selectedItem: _selectedEspecie,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Grupo e Material
                Padding(padding: EdgeInsets.only(right: 30)),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextComponent('Grupo'),
                      Padding(padding: EdgeInsets.only(top: 6)),
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                controller: txtIdGrupo,
                                enabled: false,
                                onChanged: (value) {
                                  // _pecasController.pecasModel.id_fornecedor = int.parse(value);
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'ID',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Flexible(
                            flex: 5,
                            child: Container(
                              width: 600,
                              height: 48,
                              child: FutureBuilder(
                                future: _pecasGrupoController.buscarTodos(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return Text("there is no connection");
                                    case ConnectionState.active:
                                    case ConnectionState.waiting:
                                      return Center(child: new CircularProgressIndicator());
                                    case ConnectionState.done:
                                      return Container(
                                        padding: EdgeInsets.only(left: 12, right: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: IgnorePointer(
                                          ignoring: !widget.enabled!,
                                          child: DropdownSearch<PecasGrupoModel?>(
                                            mode: Mode.DIALOG,
                                            showSearchBox: true,
                                            items: snapshot.data,
                                            itemAsString: (PecasGrupoModel? value) => value!.grupo!.toUpperCase(),
                                            onChanged: (value) {
                                              _selectedGrupo = value!;
                                              txtIdGrupo.text = value.id_peca_grupo_material.toString();

                                              setState(() {
                                                _pecasMaterialModel = value.material_fabricacao!;
                                              });
                                            },
                                            dropdownSearchDecoration: InputDecoration(
                                              enabledBorder: InputBorder.none,
                                            ),
                                            dropDownButton: Icon(
                                              Icons.arrow_drop_down_rounded,
                                              color: Colors.black,
                                            ),
                                            showAsSuffixIcons: true,
                                            selectedItem: _selectedGrupo,
                                          ),
                                        ),
                                      );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 30)),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextComponent('Material'),
                      Padding(padding: EdgeInsets.only(top: 6)),
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                controller: txtIdMaterial,
                                enabled: false,
                                onChanged: (value) {
                                  // _pecasController.pecasModel.id_fornecedor = int.parse(value);
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'ID',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Flexible(
                            flex: 5,
                            child: Container(
                              width: 600,
                              height: 48,
                              padding: EdgeInsets.only(left: 12, right: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: IgnorePointer(
                                ignoring: !widget.enabled!,
                                child: DropdownSearch<PecasMaterialModel?>(
                                  mode: Mode.DIALOG,
                                  showSearchBox: true,
                                  items: _pecasMaterialModel,
                                  itemAsString: (PecasMaterialModel? value) => value!.material!.toUpperCase(),
                                  onChanged: (value) {
                                    txtIdMaterial.text = value!.id_peca_material_fabricacao.toString();

                                    _pecasController.pecasModel.id_peca_material_fabricacao =
                                        value.id_peca_material_fabricacao.toString();
                                  },
                                  dropdownSearchDecoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                  ),
                                  dropDownButton: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.black,
                                  ),
                                  showAsSuffixIcons: true,
                                  selectedItem: _selectedMaterial,
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
            Padding(padding: EdgeInsets.only(top: 30)),
            widget.enabled == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonComponent(
                        color: secundaryColor,
                        colorHover: secundaryColorHover,
                        onPressed: () async {
                          await editar(context);
                          await EditarProdutoPeca(context);
                        },
                        text: 'Editar',
                      ),
                      Padding(padding: EdgeInsets.only(right: 20)),
                      ButtonComponent(
                        color: vermelhoColor,
                        colorHover: vermelhoColorHover,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: 'Cancelar',
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ],
    );
  }
}
