/*import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/enderecamento_controller.dart';
import 'package:gpp/src/controllers/pecas_controller/fornecedor_controller.dart';
import 'package:gpp/src/controllers/pecas_controller/peca_enderecamento_controller.dart';
import 'package:gpp/src/controllers/pecas_controller/peca_controller.dart';
import 'package:gpp/src/controllers/pecas_controller/produto_controller.dart';

import 'package:gpp/src/models/box_enderecamento_model.dart';
import 'package:gpp/src/models/corredor_enderecamento_model.dart';
import 'package:gpp/src/models/estante_enderecamento_model.dart';
import 'package:gpp/src/models/filial/filial_model.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/models/piso_enderecamento_model.dart';
import 'package:gpp/src/models/prateleira_enderecamento_model.dart';
import 'package:gpp/src/shared/components/ButtonComponentExpanded.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:flutter/services.dart';
import 'package:gpp/src/shared/services/auth.dart';
import 'package:gpp/src/views/pecas/endereco_detail_view.dart';
import 'package:gpp/src/views/pecas/pop_up_editar.dart';

class PecaEnderecamentoDetailView extends StatefulWidget {
  const PecaEnderecamentoDetailView({Key? key}) : super(key: key);

  @override
  _PecaEnderecamentoDetailViewState createState() => _PecaEnderecamentoDetailViewState();
}

class _PecaEnderecamentoDetailViewState extends State<PecaEnderecamentoDetailView> {
  late PecaEnderecamentoController pecaEnderecamentoController;
  late EnderecamentoController enderecamentoController;
  late PecaController _pecasController;
  late ProdutoController _produtoController;
  PecasModel? peca;

  TextEditingController _controllerIdFilial = new TextEditingController();
  TextEditingController _controllerNomeFilial = new TextEditingController();

  TextEditingController _controllerIdFornecedor = new TextEditingController();
  TextEditingController _controllerNomeFornecedor = new TextEditingController();

  TextEditingController _controllerIdProduto = new TextEditingController();
  TextEditingController _controllerNomeProduto = new TextEditingController();

  TextEditingController _controllerIdPeca = new TextEditingController();
  TextEditingController _controllerNomePeca = new TextEditingController();

  TextEditingController _controllerCorredor = new TextEditingController();
  TextEditingController _controllerPrateleira = new TextEditingController();
  TextEditingController _controllerEstante = new TextEditingController();
  TextEditingController _controllerBox = new TextEditingController();
  FilialModel? filialModel;

  bool disponivel = false;
  bool reservado = false;
  bool transferencia = false;
  bool? endereco;

  int? id_filial, id_fornecedor, id_produto, id_peca;

  PisoEnderecamentoModel? _pisoSelected;
  CorredorEnderecamentoModel? _corredorSelected;
  PrateleiraEnderecamentoModel? _prateleiraSelected;
  EstanteEnderecamentoModel? _estanteSelected;
  BoxEnderecamentoModel? _boxSelected;

  bool abrirFiltro = false;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              const Icon(Icons.add_box),
              const Padding(padding: EdgeInsets.only(right: 12)),
              const TitleComponent('Endereçar Peças'),
              new Spacer(),
              ButtonComponent(
                  icon: Icon(Icons.tune, color: Colors.white),
                  color: secundaryColor,
                  onPressed: () {
                    setState(() {
                      abrirFiltro = !abrirFiltro;
                    });
                  },
                  text: 'Gerenciar filtros'),
              const Padding(padding: EdgeInsets.only(right: 5)),
            ],
          ),
        ),
        const Divider(),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        Container(
          height: abrirFiltro ? null : 0,
          child: Column(children: [
            Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    labelText: 'Informação de Peças',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Column(children: [
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
                              controller: _controllerIdFilial,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Filial',
                                labelText: 'Filial',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                                suffixIcon: IconButton(
                                  onPressed: () async {},
                                  icon: Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        // Fim Produto
                        Flexible(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              controller: _controllerNomeFilial,
                              enabled: false,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Nome Filial',
                                labelText: 'Nome Filial',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 20)),
                        Flexible(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              controller: _controllerIdFornecedor,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                  hintText: 'ID',
                                  labelText: 'ID',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (_controllerIdFornecedor.text == '') {
                                        limparFieldsPeca();
                                      } else {
                                        buscarFornecedor(_controllerIdFornecedor.text);
                                      }
                                    },
                                    icon: Icon(Icons.search),
                                  )),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        Flexible(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              controller: _controllerNomeFornecedor,
                              enabled: false,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Nome Fornecedor',
                                labelText: 'Nome Fornecedor',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                              ),
                            ),
                          ),
                        ),
                        // Fim Fornecedor
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
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
                              controller: _controllerIdProduto,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'ID',
                                labelText: 'ID',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 10),
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    if (_controllerIdProduto.text == '') {
                                      limparFieldsPeca();
                                    } else {
                                      buscarProduto(_controllerIdProduto.text);
                                    }
                                  },
                                  icon: const Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        // Fim Produto
                        Flexible(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              controller: _controllerNomeProduto,
                              enabled: false,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Nome Produto',
                                labelText: 'Nome Produto',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 10),
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 20)),
                        Flexible(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              controller: _controllerIdPeca,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                  hintText: 'ID',
                                  labelText: 'ID',
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 10),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (_controllerIdPeca.text == '') {
                                        limparFieldsPeca();
                                      } else {
                                        buscarPeca(_controllerIdPeca.text);
                                      }
                                    },
                                    icon: const Icon(Icons.search),
                                  )),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        Flexible(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              controller: _controllerNomePeca,
                              enabled: false,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Nome Peça',
                                labelText: 'Nome Peça',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 10),
                              ),
                            ),
                          ),
                        ),
                        // Fim Fornecedor
                      ],
                    ),
                  ]),
                )),
            Container(
              padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        //width: 300,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            labelText: 'Endereço Resumido',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Row(children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                    controller: _controllerCorredor,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        if (_controllerCorredor.text == '') _controllerEstante.text = '';
                                      });
                                    }),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 5)),
                            Text('-'),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            Flexible(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                    enabled: _controllerCorredor.text == '' ? false : true,
                                    controller: _controllerEstante,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        if (_controllerEstante.text == '') _controllerPrateleira.text = '';
                                      });
                                    }),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 5)),
                            Text('-'),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            Flexible(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                    enabled: _controllerEstante.text == '' ? false : true,
                                    controller: _controllerPrateleira,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        if (_controllerPrateleira.text == '') _controllerBox.text = '';
                                      });
                                    }),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 5)),
                            Text('-'),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            Flexible(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                    enabled: _controllerPrateleira.text == '' ? false : true,
                                    controller: _controllerBox,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {});
                                    }),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(right: 5)),
                      Flexible(
                        flex: 4,
                        //width: 900,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                            labelText: 'Disponibilidade',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: ListTile(
                                  title: const Text('Disponível'),
                                  leading: Checkbox(
                                    value: disponivel,
                                    onChanged: (value) {
                                      setState(() {
                                        disponivel = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: ListTile(
                                  title: const Text('Reservado'),
                                  leading: Checkbox(
                                    value: reservado,
                                    onChanged: (value) {
                                      setState(() {
                                        reservado = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: ListTile(
                                  title: const Text('Transferência'),
                                  leading: Checkbox(
                                    value: transferencia,
                                    onChanged: (value) {
                                      setState(() {
                                        transferencia = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(right: 5)),
                      Flexible(
                        flex: 2,
                        //width: 900,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                            labelText: 'Endereçado?',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: ListTile(
                                  title: const Text('Sim'),
                                  leading: Radio(
                                    groupValue: endereco,
                                    value: true,
                                    onChanged: (value) {
                                      setState(() {
                                        endereco = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: ListTile(
                                  title: const Text('Não'),
                                  leading: Radio(
                                    groupValue: endereco,
                                    value: false,
                                    onChanged: (value) {
                                      setState(() {
                                        endereco = false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
        Column(
          children: [
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 5)),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownSearch<PisoEnderecamentoModel>(
                      mode: Mode.MENU,
                      showSearchBox: true,
                      items: enderecamentoController.listaPiso,
                      itemAsString: (PisoEnderecamentoModel? value) => value?.id_filial == null
                          ? value!.desc_piso!.toUpperCase()
                          : value!.desc_piso!.toUpperCase() + " (" + value.id_filial.toString() + ")",
                      onChanged: (value) {
                        setState(() {
                          limparCorredor();
                          _pisoSelected = value!;
                          buscarCorredor();
                        });
                      },
                      dropdownSearchDecoration:
                          InputDecoration(enabledBorder: InputBorder.none, hintText: "Selecione o Piso:", labelText: "Piso"),
                      dropDownButton: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Colors.black,
                      ),
                      showAsSuffixIcons: true,
                      selectedItem: _pisoSelected,
                      showClearButton: true,
                      clearButton: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          limparFieldsLoc();
                        },
                      ),
                      emptyBuilder: (context, searchEntry) => Center(child: Text('Nenhum piso encontrado!')),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                Flexible(
                    flex: 1,
                    child: FutureBuilder(
                        future: enderecamentoController.buscarCorredor(_pisoSelected?.id_piso.toString() ?? ''),
                        builder: (context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Text("Sem conexão!");
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
                                child: DropdownSearch<CorredorEnderecamentoModel>(
                                  mode: Mode.MENU,
                                  showSearchBox: true,
                                  items: snapshot.data,
                                  itemAsString: (CorredorEnderecamentoModel? value) => value!.desc_corredor!.toUpperCase(),
                                  onChanged: (value) {
                                    setState(() {
                                      limparEstante();
                                      _corredorSelected = value!;
                                    });
                                  },
                                  dropdownSearchDecoration: InputDecoration(
                                      enabledBorder: InputBorder.none, hintText: "Selecione o Corredor:", labelText: "Corredor"),
                                  dropDownButton: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.black,
                                  ),
                                  showAsSuffixIcons: true,
                                  selectedItem: _corredorSelected,
                                  showClearButton: true,
                                  clearButton: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      limparCorredor();
                                    },
                                  ),
                                  emptyBuilder: (context, searchEntry) => Center(
                                      child:
                                          _pisoSelected == null ? Text('Selecione um Piso!') : Text('Corredor não encontrado!')),
                                ),
                              );
                          }
                        })),
                const Padding(padding: EdgeInsets.only(right: 10)),
                Flexible(
                    flex: 1,
                    child: FutureBuilder(
                        future: enderecamentoController.buscarEstante(_corredorSelected?.id_corredor.toString() ?? ''),
                        builder: (context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Text("Sem conexão!");
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
                                child: DropdownSearch<EstanteEnderecamentoModel>(
                                  mode: Mode.MENU,
                                  showSearchBox: true,
                                  items: snapshot.data,
                                  itemAsString: (EstanteEnderecamentoModel? value) => value!.desc_estante!.toUpperCase(),
                                  onChanged: (value) {
                                    setState(() {
                                      limparPrateleira();
                                      _estanteSelected = value!;
                                    });
                                  },
                                  dropdownSearchDecoration: InputDecoration(
                                      enabledBorder: InputBorder.none, hintText: "Selecione a Estante:", labelText: "Estante"),
                                  dropDownButton: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.black,
                                  ),
                                  showAsSuffixIcons: true,
                                  selectedItem: _estanteSelected,
                                  showClearButton: true,
                                  clearButton: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      limparEstante();
                                    },
                                  ),
                                  emptyBuilder: (context, searchEntry) => Center(
                                      child: _corredorSelected == null
                                          ? Text('Selecione um Corredor!')
                                          : Text('Estante não encontrado!')),
                                ),
                              );
                          }
                        })),
                const Padding(padding: EdgeInsets.only(right: 10)),
                Flexible(
                    flex: 1,
                    child: FutureBuilder(
                        future: enderecamentoController.buscarPrateleira(_estanteSelected?.id_estante.toString() ?? ''),
                        builder: (context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Text("Sem conexão!");
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
                                child: DropdownSearch<PrateleiraEnderecamentoModel>(
                                  mode: Mode.MENU,
                                  showSearchBox: true,
                                  items: snapshot.data,
                                  itemAsString: (PrateleiraEnderecamentoModel? value) => value!.desc_prateleira!.toUpperCase(),
                                  onChanged: (value) {
                                    setState(() {
                                      limparBox();
                                      _prateleiraSelected = value!;
                                    });
                                  },
                                  dropdownSearchDecoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      hintText: "Selecione a Prateleira:",
                                      labelText: "Prateleira"),
                                  dropDownButton: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.black,
                                  ),
                                  showAsSuffixIcons: true,
                                  selectedItem: _prateleiraSelected,
                                  showClearButton: true,
                                  clearButton: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      limparPrateleira();
                                    },
                                  ),
                                  emptyBuilder: (context, searchEntry) => Center(
                                      child: _estanteSelected == null
                                          ? Text('Selecione uma Estante!')
                                          : Text('Prateleira não encontrado!')),
                                ),
                              );
                          }
                        })),
                const Padding(padding: EdgeInsets.only(right: 10)),
                Flexible(
                    flex: 1,
                    child: FutureBuilder(
                        future: enderecamentoController.buscarBox(_prateleiraSelected?.id_prateleira.toString() ?? ''),
                        builder: (context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Text("Sem conexão!");
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
                                child: DropdownSearch<BoxEnderecamentoModel>(
                                  mode: Mode.MENU,
                                  showSearchBox: true,
                                  items: snapshot.data,
                                  itemAsString: (BoxEnderecamentoModel? value) => value!.desc_box!.toUpperCase(),
                                  onChanged: (value) {
                                    setState(() {
                                      _boxSelected = value!;
                                    });
                                  },
                                  dropdownSearchDecoration: InputDecoration(
                                      enabledBorder: InputBorder.none, hintText: "Selecione o Box:", labelText: "Box"),
                                  dropDownButton: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.black,
                                  ),
                                  showAsSuffixIcons: true,
                                  selectedItem: _boxSelected,
                                  showClearButton: true,
                                  clearButton: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      limparBox();
                                    },
                                  ),
                                  emptyBuilder: (context, searchEntry) => Center(
                                      child: _prateleiraSelected == null
                                          ? Text('Selecione uma Prateleira!')
                                          : Text('Box não encontrado!')),
                                ),
                              );
                          }
                        })),
                const Padding(padding: EdgeInsets.only(right: 5)),
              ],
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(padding: EdgeInsets.only(left: 5)),
            Flexible(
              child: ButtonComponentExpanded(
                  onPressed: () async {
                    setState(() {
                      abrirFiltro = false;
                      id_filial = _controllerIdFilial.text != '' ? int.parse(_controllerIdFilial.text) : null;
                      id_fornecedor = _controllerIdFornecedor.text != '' ? int.parse(_controllerIdFornecedor.text) : null;
                      id_produto = _controllerIdProduto.text != '' ? int.parse(_controllerIdProduto.text) : null;
                      id_peca = _controllerIdPeca.text != '' ? int.parse(_controllerIdPeca.text) : null;
                    });
                    consultarEnderecamento();
                  },
                  text: 'Pesquisar'),
            ),
            const Padding(padding: EdgeInsets.only(right: 5)),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 30)),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 32,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const TitleComponent('Endereços'),
                  ],
                ),
                Row(
                  children: [
                    ButtonComponent(
                        color: primaryColor,
                        onPressed: () {
                          limparFields();
                        },
                        text: 'Limpar Filtros')
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: const TextComponent(
                    'Filial',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: const TextComponent(
                    'Piso',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: const TextComponent('Endereço'),
                ),
                Expanded(
                  child: const TextComponent(
                    'Medida Box',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: const TextComponent(
                    'Cod. Peça',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: const TextComponent('Descrição Peça'),
                ),
                Expanded(
                  flex: 2,
                  child: const TextComponent('Fornecedor'),
                ),
                Expanded(
                  child: const TextComponent(
                    'Disp.',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: const TextComponent(
                    'Reserv.',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: const TextComponent(
                    'Ações',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Container(
            height: media.height / 2,
            child: ListView.builder(
              primary: false,
              itemCount: pecaEnderecamentoController.pecas_enderecamento.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Padding(padding: EdgeInsets.only(left: 10)),
                      // CheckboxComponent(),
                      Expanded(
                        child: Text(
                          pecaEnderecamentoController.pecas_enderecamento[index].peca_estoque == null
                              ? pecaEnderecamentoController
                                  .pecas_enderecamento[index].box!.prateleira!.estante!.corredor!.piso!.id_filial
                                  .toString()
                              : pecaEnderecamentoController.pecas_enderecamento[index].peca_estoque!.filial.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          pecaEnderecamentoController.pecas_enderecamento[index].descPiso ?? '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          pecaEnderecamentoController.pecas_enderecamento[index].endereco,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          pecaEnderecamentoController.pecas_enderecamento[index].box?.calcularMedida() ?? '-',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          pecaEnderecamentoController.pecas_enderecamento[index].peca_estoque?.pecasModel?.id_peca.toString() ??
                              '-',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                            pecaEnderecamentoController.pecas_enderecamento[index].peca_estoque?.pecasModel?.descricao ?? '-'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(pecaEnderecamentoController.pecas_enderecamento[index].nomeFornecedor ?? '-'),
                      ),
                      Expanded(
                        child: Text(
                          pecaEnderecamentoController.pecas_enderecamento[index].peca_estoque?.saldo_disponivel.toString() ?? '-',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          pecaEnderecamentoController.pecas_enderecamento[index].peca_estoque?.saldo_reservado.toString() ?? '-',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: IconButton(
                                tooltip: pecaEnderecamentoController.pecas_enderecamento[index].id_peca_estoque == null
                                    ? 'Endereçar Peça'
                                    : 'Transferir Peça',
                                icon: Icon(
                                  pecaEnderecamentoController.pecas_enderecamento[index].id_peca_estoque == null
                                      ? Icons.location_on_outlined
                                      : Icons.sync_outlined,
                                  color: Colors.grey.shade400,
                                ),
                                onPressed: () async {
                                  await PopUpEditar.popUpPeca(
                                      context,
                                      EnderecoDetailView(
                                          pecaEnderecamento: pecaEnderecamentoController.pecas_enderecamento[index]));
                                  setState(() {});
                                },
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                tooltip: 'Etiqueta',
                                icon: Icon(
                                  Icons.local_offer_outlined,
                                  color: Colors.grey.shade400,
                                ),
                                onPressed: () => {
                                  //PopUpEditar.popUpPeca(context,EnderecoDetailView(pecaEnderecamento: pecaEnderecamentoController.pecas_enderecamento[index]))
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            height: media.height * 0.10,
            width: media.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextComponent('Total de páginas: ' + pecaEnderecamentoController.pagina.total.toString()),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.first_page),
                        onPressed: () {
                          setState(() {
                            pecaEnderecamentoController.pagina.atual = 1;
                          });

                          //buscarTodas();
                        }),
                    IconButton(
                        icon: const Icon(
                          Icons.navigate_before_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            if (pecaEnderecamentoController.pagina.atual > 1) {
                              pecaEnderecamentoController.pagina.atual = pecaEnderecamentoController.pagina.atual - 1;
                              //buscarTodas();
                            }
                          });
                        }),
                    TextComponent(pecaEnderecamentoController.pagina.atual.toString()),
                    IconButton(
                        icon: Icon(Icons.navigate_next_rounded),
                        onPressed: () {
                          setState(() {
                            if (pecaEnderecamentoController.pagina.atual != pecaEnderecamentoController.pagina.total) {
                              pecaEnderecamentoController.pagina.atual = pecaEnderecamentoController.pagina.atual + 1;
                            }
                          });

                          //buscarTodas();
                        }),
                    IconButton(
                        icon: Icon(Icons.last_page),
                        onPressed: () {
                          setState(() {
                            pecaEnderecamentoController.pagina.atual = pecaEnderecamentoController.pagina.total;
                          });

                          //buscarTodas();
                        }),
                  ],
                )
              ],
            ),
          )
        ])
      ]),
    );
  }

  @override
  void initState() {
    filialModel = getFilial().filial;
    _controllerIdFilial.text = filialModel?.id_filial.toString() ?? '';
    _controllerNomeFilial.text = filialModel?.sigla ?? '';

    pecaEnderecamentoController = PecaEnderecamentoController();
    enderecamentoController = EnderecamentoController();
    _pecasController = PecaController();
    _produtoController = ProdutoController();

    buscarPisos();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  limparFieldsLoc() {
    _controllerCorredor.clear();
    _controllerEstante.clear();
    _controllerPrateleira.clear();
    _controllerBox.clear();
    setState(() {
      _pisoSelected = null;
    });
    limparCorredor();
  }

  limparCorredor() {
    setState(() {
      _corredorSelected = null;
      enderecamentoController.listaCorredor = [];
    });
    limparEstante();
  }

  limparEstante() {
    setState(() {
      _estanteSelected = null;
      enderecamentoController.listaEstante = [];
    });

    limparPrateleira();
  }

  limparPrateleira() {
    setState(() {
      _prateleiraSelected = null;
      enderecamentoController.listaPrateleira = [];
    });
    limparBox();
  }

  limparBox() {
    setState(() {
      _boxSelected = null;
      enderecamentoController.listaBox = [];
    });
  }

  limparFieldsPeca() {
    _controllerIdFornecedor.clear();
    _controllerNomeFornecedor.clear();

    _controllerIdProduto.clear();
    _controllerNomeProduto.clear();

    _controllerIdPeca.clear();
    _controllerNomePeca.clear();

    id_fornecedor = null;
    id_produto = null;
    id_peca = null;
  }

  limparFields() {
    limparFieldsPeca();
    limparFieldsLoc();
  }

  buscarPeca(String id) async {
    peca = await _pecasController.buscar(id);
    _controllerNomePeca.text = peca?.descricao ?? '';
    if (peca?.produto_peca?[0].idProdutoPeca != null) buscarProduto(peca!.produto_peca![0].idProdutoPeca.toString());
  }

  buscarProduto(String id) async {
    await _produtoController.buscar(id);
    _controllerNomeProduto.text = _produtoController.produto.resumida ?? '';
    _controllerIdProduto.text = _produtoController.produto.idProduto.toString();
    buscarFornecedor(_produtoController.produto.fornecedores!.first.idFornecedor.toString());
  }

  buscarFornecedor(String id) async {
    FornecedorController _fornecedorController = FornecedorController();
    await _fornecedorController.buscar(id);
    _controllerNomeFornecedor.text = _fornecedorController.fornecedorModel.cliente?.nome ?? '';
    _controllerIdFornecedor.text = _fornecedorController.fornecedorModel.idFornecedor.toString();
  }

  consultarEnderecamento() async {
    setState(() {
      pecaEnderecamentoController.isLoading = true;
    });
    await pecaEnderecamentoController
        .buscarTodos(
            pecaEnderecamentoController.pagina.atual,
            id_filial,
            id_fornecedor,
            id_produto,
            id_peca,
            _pisoSelected?.id_piso,
            _corredorSelected?.id_corredor,
            _estanteSelected?.id_estante,
            _prateleiraSelected?.id_prateleira,
            _boxSelected?.id_box)
        .then((value) => setState(() {
              pecaEnderecamentoController.isLoading = false;
            }));
  }

  buscarPisos() async {
    enderecamentoController.listaPiso = await enderecamentoController.buscarTodos(getFilial().id_filial!);

    setState(() {});
  }

  buscarCorredor() async {
    setState(() {
      enderecamentoController.isLoaded = true;
    });
    enderecamentoController.listaCorredor = await enderecamentoController.buscarCorredor(_pisoSelected!.id_piso.toString());
    setState(() {
      enderecamentoController.isLoaded = false;
    });
  }
}
*/