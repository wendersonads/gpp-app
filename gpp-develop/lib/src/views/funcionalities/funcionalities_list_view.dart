// import 'package:flutter/material.dart';
// import 'package:gpp/src/controllers/funcionalities_controller.dart';
// import 'package:gpp/src/controllers/notify_controller.dart';
// import 'package:gpp/src/controllers/responsive_controller.dart';
// import 'package:gpp/src/models/FuncionalidadeModel.dart';
// import 'package:gpp/src/shared/components/ButtonComponent.dart';

// import 'package:gpp/src/shared/components/status_component.dart';
// import 'package:gpp/src/shared/components/TextComponent.dart';
// import 'package:gpp/src/shared/components/TitleComponent.dart';
// import 'package:gpp/src/shared/enumeration/funcionalities_enum.dart';
// import 'package:gpp/src/shared/repositories/styles.dart';
// import 'package:gpp/src/shared/components/loading_view.dart';

// class FuncionalitiesListView extends StatefulWidget {
//   const FuncionalitiesListView({Key? key}) : super(key: key);

//   @override
//   _FuncionalitiesListViewState createState() => _FuncionalitiesListViewState();
// }

// class _FuncionalitiesListViewState extends State<FuncionalitiesListView> {
//   FuncionalitiesController _controlller = FuncionalitiesController();
//   final ResponsiveController _responsive = ResponsiveController();

//   fetchFuncionalities() async {
//     setState(() {
//       _controlller.state = FuncionalitiesEnum.loading;
//     });

//     await _controlller.fetchAll();

//     setState(() {
//       _controlller.state = FuncionalitiesEnum.change;
//     });
//   }

//   handleDelete(context, FuncionalidadeModel funcionalitie) async {
//     NotifyController notify = NotifyController(context: context);
//     try {
//       if (await notify
//           .confirmacao("você deseja excluir essa funcionalidade?")) {
//         if (await _controlller.delete(funcionalitie)) {
//           notify.sucess("Funcionalidade excluída!");
//           fetchFuncionalities();
//         }
//       }
//     } catch (e) {
//       notify.error(e.toString());
//     }
//   }

//   @override
//   void initState() {
//     // ignore: todo
//     // TODO: implement initState
//     super.initState();
//     fetchFuncionalities();
//   }

//   Widget _buildList(List<FuncionalidadeModel> funcionalities) {
//     Widget widget = LayoutBuilder(
//       builder: (context, constraints) {
//         if (_responsive.isMobile(constraints.maxWidth)) {
//           return Container(
//             height: 360,
//             child: ListView.builder(
//                 itemCount: funcionalities.length,
//                 itemBuilder: (context, index) {
//                   return _buildListItem(funcionalities, index, context);
//                 }),
//           );
//         }

//         return Column(
//           children: [
//             Divider(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 //  CheckboxComponent(),
//                 Expanded(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       TextComponent('Nome'),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: TextComponent('Status'),
//                 ),
//                 Expanded(
//                   child: TextComponent('Opções'),
//                 ),
//               ],
//             ),
//             const Divider(),
//             Container(
//               height: 500,
//               child: ListView.builder(
//                   itemCount: funcionalities.length,
//                   itemBuilder: (context, index) {
//                     return _buildListItem(funcionalities, index, context);
//                   }),
//             )
//           ],
//         );
//       },
//     );

//     return Container(color: Colors.white, child: widget);
//   }

//   Widget _buildListItem(List<FuncionalidadeModel> funcionalities, int index,
//       BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (_responsive.isMobile(constraints.maxWidth)) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                     offset: Offset(0, 3), // changes position of shadow
//                   ),
//                 ],
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     topRight: Radius.circular(10),
//                     bottomLeft: Radius.circular(10),
//                     bottomRight: Radius.circular(10)),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           funcionalities[index].nome ?? '',
//                           style: textStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           funcionalities[index].nome ?? '',
//                           style: textStyle(color: Colors.grey.shade400),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         StatusComponent(
//                             status: funcionalities[index].situacao!),
//                         IconButton(
//                           icon: Icon(
//                             Icons.edit,
//                             color: Colors.grey.shade400,
//                           ),
//                           onPressed: () => {print("teste")},
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }

//         return Container(
//           color: (index % 2) == 0 ? Colors.white : Colors.grey.shade50,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               vertical: 8.0,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 //  CheckboxComponent(),
//                 Expanded(
//                   child: TextComponent(
//                     funcionalities[index].nome!,
//                   ),
//                 ),
//                 Expanded(
//                     child: Row(
//                   children: [
//                     StatusComponent(status: funcionalities[index].situacao!),
//                   ],
//                 )),
//                 Expanded(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           Icons.add,
//                           color: Colors.grey.shade400,
//                         ),
//                         onPressed: () => {
//                           Navigator.pushNamed(
//                               context,
//                               '/subfuncionalities/' +
//                                   funcionalities[index]
//                                       .idFuncionalidade
//                                       .toString())
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(
//                           Icons.edit,
//                           color: Colors.grey.shade400,
//                         ),
//                         onPressed: () => {
//                           Navigator.pushNamed(
//                               context,
//                               '/funcionalities/' +
//                                   funcionalities[index]
//                                       .idFuncionalidade
//                                       .toString())
//                         },
//                       ),
//                       IconButton(
//                           icon: Icon(
//                             Icons.delete,
//                             color: Colors.grey.shade400,
//                           ),
//                           onPressed: () =>
//                               handleDelete(context, funcionalities[index])),
//                       IconButton(
//                           icon: Icon(
//                             Icons.list,
//                             color: Colors.grey.shade400,
//                           ),
//                           onPressed: () {
//                             Navigator.pushNamed(
//                                 context,
//                                 '/funcionalities/' +
//                                     funcionalities[index]
//                                         .idFuncionalidade
//                                         .toString());
//                           }),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   _buildState() {
//     switch (_controlller.state) {
//       case FuncionalitiesEnum.loading:
//         return const LoadingComponent();

//       case FuncionalitiesEnum.change:
//         return _buildList(_controlller.funcionalities);
//       case FuncionalitiesEnum.notChange:
//         return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TitleComponent(
//                   'Funcionalidades',
//                 ),
//                 ButtonComponent(
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/funcionalities/register');
//                     },
//                     icon: Icon(Icons.add, color: Colors.white),
//                     text: 'Adicionar')
//               ],
//             ),
//           ),
//           _buildState(),
//         ],
//       ),
//     );
//   }
// }
