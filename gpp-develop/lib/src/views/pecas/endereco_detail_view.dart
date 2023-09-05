// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gpp/src/controllers/enderecamento_controller.dart';

// import 'package:gpp/src/controllers/pecas_controller/peca_enderecamento_controller.dart';
// import 'package:gpp/src/controllers/pecas_controller/peca_estoque_controller.dart';
// import 'package:gpp/src/models/corredor_enderecamento_model.dart';
// import 'package:gpp/src/models/estante_enderecamento_model.dart';

// import 'package:gpp/src/models/pecas_model/pecas_estoque_model.dart';
// import 'package:gpp/src/models/piso_enderecamento_model.dart';
// import 'package:gpp/src/models/prateleira_enderecamento_model.dart';
// import 'package:gpp/src/shared/components/ButtonComponent.dart';
// import 'package:gpp/src/shared/components/TitleComponent.dart';
// import 'package:gpp/src/shared/services/auth.dart';
// import 'package:gpp/src/utils/notificacao.dart';

// import '../../models/box_enderecamento_model.dart';

// // ignore: must_be_immutable
// class EnderecoDetailView extends StatefulWidget {
//   PecasEstoqueModel? pecaEstoque;

//   EnderecoDetailView({this.pecaEstoque});

//   @override
//   _EnderecoDetailViewState createState() => _EnderecoDetailViewState();
// }

// class _EnderecoDetailViewState extends State<EnderecoDetailView> {
//   PecasEstoqueModel? pecaEstoque;

//   late EnderecamentoController enderecamentoController;
//   late PecaEstoqueController _pecasEstoqueController;
//   late PecaEnderecamentoController _pecaEnderecamentoController;

//   TextEditingController _controllerIdPeca = new TextEditingController();
//   TextEditingController _controllerNomePeca = new TextEditingController();
//   TextEditingController _controllerEnderecoPeca = new TextEditingController();

//   PisoEnderecamentoModel? _pisoSelected;
//   CorredorEnderecamentoModel? _corredorSelected;
//   PrateleiraEnderecamentoModel? _prateleiraSelected;
//   EstanteEnderecamentoModel? _estanteSelected;
//   BoxEnderecamentoModel? _boxSelected;

//   @override
//   void initState() {
//     pecaEstoque = widget.pecaEstoque;
//     enderecamentoController = EnderecamentoController();
//     _pecaEnderecamentoController = PecaEnderecamentoController();
//     if (pecaEstoque!.id_peca_estoque == null)
//       _pecasEstoqueController = PecaEstoqueController();
//     else {
//       _controllerIdPeca.text =
//           pecaEstoque!.pecasModel!.id_peca.toString();
//       _controllerNomePeca.text =
//           pecaEstoque!.pecasModel!.descricao ?? '';
//       _pisoSelected =
//           pecaEstoque!.box?.prateleira?.estante?.corredor?.piso;
//       _corredorSelected = pecaEstoque!.box?.prateleira?.estante?.corredor;
//       _prateleiraSelected = pecaEstoque!.box?.prateleira;
//       _estanteSelected = pecaEstoque!.box?.prateleira?.estante;
//       _boxSelected = pecaEstoque!.box;
//     }

//     _controllerEnderecoPeca.text = pecaEstoque!.endereco!;

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Padding(
//         padding: EdgeInsets.only(top: 16, bottom: 16),
//         child: Row(
//           children: [
//             Padding(padding: EdgeInsets.only(left: 20)),
//             Icon(pecaEstoque!.id_peca_estoque == null
//                 ? Icons.location_on_outlined
//                 : Icons.sync_outlined),
//             Padding(padding: EdgeInsets.only(right: 12)),
//             TitleComponent(pecaEstoque!.id_peca_estoque == null
//                 ? 'Endereçar Peça'
//                 : 'Transferir Peça'),
//             new Spacer(),
//             pecaEstoque!.box == null
//                 ? Container()
//                 : IconButton(
//               onPressed: () async {

//                 try {
//                   if (await Notificacao.confirmacao(
//                       'Deseja remover o endereçamento da peça (${pecaEstoque!.pecasModel!.descricao}) localizado no endereço: ${pecaEstoque!.endereco}?')) {
//                     pecaEstoque?.box = null;
//                     pecaEstoque?.id_box = null;
//                     if (await _pecaEnderecamentoController
//                         .alterar(pecaEstoque!)) {
//                       Notificacao
//                           .snackBar
//                           ("Endereçamento excluído com sucesso!");
//                       Navigator.pop(context);
//                     }
//                   }
//                 } catch (e) {
//                   Notificacao.snackBar(e.toString());
//                   Navigator.pop(context);
//                 }
//               },
//               icon: Icon(Icons.delete_outlined),
//               tooltip: 'Remover Endereçamento',
//               color: Colors.red,
//             )
//           ],
//         ),
//       ),
//       Divider(),
//       Padding(padding: EdgeInsets.only(bottom: 20)),
//       Column(
//         children: [
//           Row(
//             children: [
//               const Padding(padding: EdgeInsets.only(right: 5)),
//               Flexible(
//                 flex: 1,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: TextFormField(
//                     controller: _controllerIdPeca,
//                     keyboardType: TextInputType.number,
//                     enabled: pecaEstoque!.id_peca_estoque == null
//                         ? true
//                         : false,
//                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                     ),
//                     decoration: InputDecoration(
//                         hintText: 'ID',
//                         labelText: 'ID',
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.only(
//                             top: 15, bottom: 10, left: 10),
//                         suffixIcon: IconButton(
//                           onPressed: () async {
//                             if (_controllerIdPeca.text == '') {
//                               _controllerNomePeca.text = '';
//                             } else {
//                               buscarPeca(_controllerIdPeca.text);
//                             }
//                           },
//                           icon: const Icon(Icons.search),
//                         )),
//                   ),
//                 ),
//               ),
//               const Padding(padding: EdgeInsets.only(right: 10)),
//               Flexible(
//                 flex: 5,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: TextFormField(
//                     controller: _controllerNomePeca,
//                     enabled: false,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                     ),
//                     decoration: InputDecoration(
//                       hintText: 'Nome Peça',
//                       labelText: 'Nome Peça',
//                       border: InputBorder.none,
//                       contentPadding:
//                       const EdgeInsets.only(top: 15, bottom: 10, left: 10),
//                     ),
//                   ),
//                 ),
//               ),
//               const Padding(padding: EdgeInsets.only(right: 10)),
//               Flexible(
//                 flex: 1,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: TextFormField(
//                     controller: _controllerEnderecoPeca,
//                     enabled: false,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                     ),
//                     decoration: InputDecoration(
//                       hintText: 'Endereço Atual',
//                       labelText: 'Endereço Atual',
//                       border: InputBorder.none,
//                       contentPadding:
//                       const EdgeInsets.only(top: 15, bottom: 10, left: 10),
//                     ),
//                   ),
//                 ),
//               ),
//               // Fim Fornecedor
//               const Padding(padding: EdgeInsets.only(right: 5)),
//             ],
//           ),
//           const Padding(padding: EdgeInsets.only(bottom: 10)),
//           pecaEstoque!.id_peca_estoque == null
//               ? Container()
//               : Row(
//             children: [
//               const Padding(padding: EdgeInsets.only(left: 5)),
//               Flexible(
//                   flex: 1,
//                   child: FutureBuilder(
//                       future: enderecamentoController
//                           .buscarTodos(getFilial().id_filial!),
//                       builder: (context, AsyncSnapshot snapshot) {
//                         switch (snapshot.connectionState) {
//                           case ConnectionState.none:
//                             return Text("Sem conexão!");
//                           case ConnectionState.active:
//                           case ConnectionState.waiting:
//                             return Center(
//                                 child: new CircularProgressIndicator());
//                           case ConnectionState.done:
//                             return Container(
//                               padding: const EdgeInsets.only(
//                                   left: 12, right: 12),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade200,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child:
//                               DropdownSearch<PisoEnderecamentoModel>(
//                                 mode: Mode.MENU,
//                                 enabled: pecaEstoque!.box == null
//                                     ? true
//                                     : false,
//                                 showSearchBox: true,
//                                 items: snapshot.data,
//                                 itemAsString: (PisoEnderecamentoModel?
//                                 value) =>
//                                 value?.id_filial == null
//                                     ? value!.desc_piso!.toUpperCase()
//                                     : value!.desc_piso!
//                                     .toUpperCase() +
//                                     " (" +
//                                     value.id_filial.toString() +
//                                     ")",
//                                 onChanged: (value) {
//                                   setState(() {
//                                     zerarCampos();
//                                     _pisoSelected = value;
//                                     pecaEstoque!
//                                         .box
//                                         ?.prateleira
//                                         ?.estante
//                                         ?.corredor
//                                         ?.piso = _pisoSelected;
//                                   });
//                                 },
//                                 dropdownSearchDecoration: InputDecoration(
//                                     enabledBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     hintText: "Selecione o Piso:",
//                                     labelText: "Piso"),
//                                 dropDownButton: Icon(
//                                   Icons.arrow_drop_down_rounded,
//                                   color: Colors.black,
//                                 ),
//                                 showAsSuffixIcons: true,
//                                 selectedItem: _pisoSelected,
//                                 showClearButton: true,
//                                 clearButton: IconButton(
//                                   icon: Icon(Icons.clear),
//                                   onPressed: () {
//                                     zerarCampos();
//                                   },
//                                 ),
//                                 emptyBuilder: (context, searchEntry) =>
//                                     Center(
//                                         child: Text(
//                                             'Nenhum piso encontrado!')),
//                               ),
//                             );
//                         }
//                       })),
//               const Padding(padding: EdgeInsets.only(right: 10)),
//               Flexible(
//                   flex: 1,
//                   child: FutureBuilder(
//                       future: enderecamentoController.buscarCorredor(
//                           _pisoSelected?.id_piso.toString() ?? ''),
//                       builder: (context, AsyncSnapshot snapshot) {
//                         switch (snapshot.connectionState) {
//                           case ConnectionState.none:
//                             return Text("Sem conexão!");
//                           case ConnectionState.active:
//                           case ConnectionState.waiting:
//                             return Center(
//                                 child: new CircularProgressIndicator());
//                           case ConnectionState.done:
//                             return Container(
//                               padding:
//                               EdgeInsets.only(left: 12, right: 12),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade200,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: DropdownSearch<
//                                   CorredorEnderecamentoModel>(
//                                 mode: Mode.MENU,
//                                 showSearchBox: true,
//                                 items: snapshot.data,
//                                 itemAsString:
//                                     (CorredorEnderecamentoModel? value) =>
//                                     value!.desc_corredor!
//                                         .toUpperCase(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     zerarCorredor();
//                                     _corredorSelected = value;
//                                     //pecaEnderecamento!.box!.prateleira!.estante!.corredor!.id_corredor = value?.id_corredor;
//                                     //pecaEnderecamento!.box!.prateleira!.estante!.corredor!.desc_corredor = value?.desc_corredor;
//                                   });
//                                 },
//                                 dropdownSearchDecoration: InputDecoration(
//                                     enabledBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     hintText: "Selecione o Corredor:",
//                                     labelText: "Corredor"),
//                                 dropDownButton: Icon(
//                                   Icons.arrow_drop_down_rounded,
//                                   color: Colors.black,
//                                 ),
//                                 showAsSuffixIcons: true,
//                                 selectedItem: _corredorSelected,
//                                 showClearButton: true,
//                                 clearButton: IconButton(
//                                   icon: Icon(Icons.clear),
//                                   onPressed: () {
//                                     zerarCorredor();
//                                   },
//                                 ),
//                                 emptyBuilder: (context, searchEntry) =>
//                                     Center(
//                                         child: _corredorSelected == null
//                                             ? Text('Selecione um Piso!')
//                                             : Text(
//                                             'Corredor não encontrado!')),
//                               ),
//                             );
//                         }
//                       })),
//               const Padding(padding: EdgeInsets.only(right: 10)),
//               Flexible(
//                   flex: 1,
//                   child: FutureBuilder(
//                       future: enderecamentoController.buscarEstante(
//                           _corredorSelected?.id_corredor.toString() ??
//                               ''),
//                       builder: (context, AsyncSnapshot snapshot) {
//                         switch (snapshot.connectionState) {
//                           case ConnectionState.none:
//                             return Text("Sem conexão!");
//                           case ConnectionState.active:
//                           case ConnectionState.waiting:
//                             return Center(
//                                 child: new CircularProgressIndicator());
//                           case ConnectionState.done:
//                             return Container(
//                               padding:
//                               EdgeInsets.only(left: 12, right: 12),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade200,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: DropdownSearch<
//                                   EstanteEnderecamentoModel>(
//                                 mode: Mode.MENU,
//                                 showSearchBox: true,
//                                 items: snapshot.data,
//                                 itemAsString:
//                                     (EstanteEnderecamentoModel? value) =>
//                                     value!.desc_estante!
//                                         .toUpperCase(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     zerarPrateleira();
//                                     _estanteSelected = value;
//                                     // pecaEnderecamento!.box!.prateleira!.estante!.id_estante = value?.id_estante;
//                                     // pecaEnderecamento!.box!.prateleira!.estante!.desc_estante = value?.desc_estante;
//                                   });
//                                 },
//                                 dropdownSearchDecoration: InputDecoration(
//                                     enabledBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     hintText: "Selecione a Estante:",
//                                     labelText: "Estante"),
//                                 dropDownButton: Icon(
//                                   Icons.arrow_drop_down_rounded,
//                                   color: Colors.black,
//                                 ),
//                                 showAsSuffixIcons: true,
//                                 selectedItem: _estanteSelected,
//                                 showClearButton: true,
//                                 clearButton: IconButton(
//                                   icon: Icon(Icons.clear),
//                                   onPressed: () {
//                                     zerarEstante();
//                                   },
//                                 ),
//                                 emptyBuilder: (context, searchEntry) =>
//                                     Center(
//                                         child: _estanteSelected == null
//                                             ? Text(
//                                             'Selecione um Corredor!')
//                                             : Text(
//                                             'Estante não encontrado!')),
//                               ),
//                             );
//                         }
//                       })),
//               const Padding(padding: EdgeInsets.only(right: 10)),
//               Flexible(
//                   flex: 1,
//                   child: FutureBuilder(
//                       future: enderecamentoController.buscarPrateleira(
//                           _estanteSelected?.id_estante.toString() ?? ''),
//                       builder: (context, AsyncSnapshot snapshot) {
//                         switch (snapshot.connectionState) {
//                           case ConnectionState.none:
//                             return Text("Sem conexão!");
//                           case ConnectionState.active:
//                           case ConnectionState.waiting:
//                             return Center(
//                                 child: new CircularProgressIndicator());
//                           case ConnectionState.done:
//                             return Container(
//                               padding:
//                               EdgeInsets.only(left: 12, right: 12),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade200,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: DropdownSearch<
//                                   PrateleiraEnderecamentoModel>(
//                                 mode: Mode.MENU,
//                                 showSearchBox: true,
//                                 items: snapshot.data,
//                                 itemAsString:
//                                     (PrateleiraEnderecamentoModel?
//                                 value) =>
//                                     value!.desc_prateleira!
//                                         .toUpperCase(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     zerarPrateleira();
//                                     _prateleiraSelected = value;
//                                     //pecaEnderecamento!.box!.prateleira!.id_prateleira = value?.id_prateleira;
//                                     //pecaEnderecamento!.box!.prateleira!.desc_prateleira = value?.desc_prateleira;
//                                   });
//                                 },
//                                 dropdownSearchDecoration: InputDecoration(
//                                     enabledBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     hintText: "Selecione a Prateleira:",
//                                     labelText: "Prateleira"),
//                                 dropDownButton: Icon(
//                                   Icons.arrow_drop_down_rounded,
//                                   color: Colors.black,
//                                 ),
//                                 showAsSuffixIcons: true,
//                                 selectedItem: _prateleiraSelected,
//                                 showClearButton: true,
//                                 clearButton: IconButton(
//                                   icon: Icon(Icons.clear),
//                                   onPressed: () {
//                                     zerarPrateleira();
//                                   },
//                                 ),
//                                 emptyBuilder: (context, searchEntry) =>
//                                     Center(
//                                         child: _estanteSelected == null
//                                             ? Text(
//                                             'Selecione uma Estante!')
//                                             : Text(
//                                             'Prateleira não encontrado!')),
//                               ),
//                             );
//                         }
//                       })),
//               const Padding(padding: EdgeInsets.only(right: 10)),
//               Flexible(
//                   flex: 1,
//                   child: FutureBuilder(
//                       future: enderecamentoController.buscarBox(
//                           _prateleiraSelected?.id_prateleira.toString() ??
//                               ''),
//                       builder: (context, AsyncSnapshot snapshot) {
//                         switch (snapshot.connectionState) {
//                           case ConnectionState.none:
//                             return Text("Sem conexão!");
//                           case ConnectionState.active:
//                           case ConnectionState.waiting:
//                             return Center(
//                                 child: new CircularProgressIndicator());
//                           case ConnectionState.done:
//                             return Container(
//                                 padding:
//                                 EdgeInsets.only(left: 12, right: 12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade200,
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: DropdownSearch<
//                                     BoxEnderecamentoModel>(
//                                     mode: Mode.MENU,
//                                     showSearchBox: true,
//                                     items: snapshot.data,
//                                     itemAsString:
//                                         (BoxEnderecamentoModel? value) =>
//                                         value!.desc_box!
//                                             .toUpperCase(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         zerarBox();
//                                         _boxSelected = value;
//                                         pecaEstoque!.box?.id_box =
//                                             value?.id_box;
//                                         pecaEstoque!.box?.desc_box =
//                                             value?.desc_box;
//                                         pecaEstoque!.id_box =
//                                             value!.id_box;
//                                       });
//                                     },
//                                     dropdownSearchDecoration:
//                                     InputDecoration(
//                                         enabledBorder:
//                                         InputBorder.none,
//                                         disabledBorder:
//                                         InputBorder.none,
//                                         hintText: "Selecione o Box:",
//                                         labelText: "Box"),
//                                     dropDownButton: Icon(
//                                       Icons.arrow_drop_down_rounded,
//                                       color: Colors.black,
//                                     ),
//                                     showAsSuffixIcons: true,
//                                     selectedItem: _boxSelected,
//                                     showClearButton: true,
//                                     clearButton: IconButton(
//                                       icon: Icon(Icons.clear),
//                                       onPressed: () {
//                                         zerarBox();
//                                       },
//                                     ),
//                                     emptyBuilder: (context,
//                                         searchEntry) =>
//                                         Center(
//                                           child: DropdownSearch<
//                                               BoxEnderecamentoModel>(
//                                             mode: Mode.MENU,
//                                             showSearchBox: true,
//                                             items: snapshot.data,
//                                             itemAsString:
//                                                 (BoxEnderecamentoModel?
//                                             value) =>
//                                                 value!.desc_box!
//                                                     .toUpperCase(),
//                                             onChanged: (value) {
//                                               setState(() {
//                                                 zerarBox();
//                                                 _boxSelected = value;
//                                                 pecaEstoque!.box!.id_box =
//                                                     value?.id_box;
//                                                 pecaEstoque!
//                                                     .box!.desc_box =
//                                                     value?.desc_box;
//                                                 pecaEstoque!
//                                                     .id_box =
//                                                     value!.id_box;
//                                               });
//                                             },
//                                             dropdownSearchDecoration:
//                                             InputDecoration(
//                                                 enabledBorder:
//                                                 InputBorder.none,
//                                                 disabledBorder:
//                                                 InputBorder.none,
//                                                 hintText:
//                                                 "Selecione o Box:",
//                                                 labelText: "Box"),
//                                             dropDownButton: Icon(
//                                               Icons
//                                                   .arrow_drop_down_rounded,
//                                               color: Colors.black,
//                                             ),
//                                             showAsSuffixIcons: true,
//                                             selectedItem: _boxSelected,
//                                             showClearButton: true,
//                                             clearButton: IconButton(
//                                               icon: Icon(Icons.clear),
//                                               onPressed: () {
//                                                 zerarBox();
//                                               },
//                                             ),
//                                             emptyBuilder: (context,
//                                                 searchEntry) =>
//                                                 Center(
//                                                     child: _prateleiraSelected ==
//                                                         null
//                                                         ? Text(
//                                                         'Selecione uma Prateleira!')
//                                                         : Text(
//                                                         'Box não encontrado!')),
//                                           ),
//                                         )));
//                         }
//                       })),
//             ],
//           ),
//           Padding(padding: EdgeInsets.only(bottom: 10)),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Row(
//                 children: [
//                   ButtonComponent(
//                     onPressed: () async {

//                       if (pecaEstoque!.id_box == null) {
//                         Notificacao.snackBar(
//                             "É necessário informar para qual box a peça será transferida!");
//                       } else {
//                         try {
//                           if (await _pecaEnderecamentoController
//                               .alterar(pecaEstoque!)) {
//                             Notificacao.snackBar("Peça endereçada com sucesso!");
//                           }
//                         } catch (e) {
//                           Notificacao.snackBar(e.toString());
//                         }
//                         Navigator.pop(context);
//                       }
//                     },
//                     text: 'Salvar',
//                   ),
//                   Padding(padding: EdgeInsets.only(right: 20)),
//                   ButtonComponent(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     text: 'Cancelar',
//                     color: Colors.red,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     ]);
//   }

//   buscarPeca(String id) async {
//     pecaEstoque = await _pecasEstoqueController.buscarEstoque(id,
//         pecaEstoque!.box!.prateleira!.estante!.corredor!.piso!.id_filial);
//     _controllerNomePeca.text = pecaEstoque?.pecasModel?.descricao ?? '';
//   }

//   zerarCampos() {
//     //_pisoSelected = null;
//     zerarCorredor();
//   }

//   zerarCorredor() {
//     setState(() {
//       _corredorSelected = null;
//     });
//     zerarEstante();
//   }

//   zerarEstante() {
//     setState(() {
//       _estanteSelected = null;
//     });
//     zerarPrateleira();
//   }

//   zerarPrateleira() {
//     setState(() {
//       _prateleiraSelected = null;
//     });
//     zerarBox();
//   }

//   zerarBox() {
//     setState(() {
//       _boxSelected = null;
//       pecaEstoque!.id_box = null;
//     });
//   }
// }
