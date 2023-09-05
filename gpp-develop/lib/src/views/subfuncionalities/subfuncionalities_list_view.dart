// import 'package:flutter/material.dart';
// import 'package:gpp/src/controllers/notify_controller.dart';
// import 'package:gpp/src/controllers/responsive_controller.dart';
// import 'package:gpp/src/controllers/subfuncionalities_controller.dart';
// import 'package:gpp/src/models/funcionalitie_model.dart';
// import 'package:gpp/src/models/subfuncionalities_model.dart';
// import 'package:gpp/src/repositories/subfuncionalities_repository.dart';
// import 'package:gpp/src/shared/enumeration/subfuncionalities_enum.dart';
// import 'package:gpp/src/shared/repositories/styles.dart';
// import 'package:gpp/src/shared/services/gpp_api.dart';
// import 'package:gpp/src/views/loading_view.dart';

// // ignore: must_be_immutable
// class SubFuncionalitiesListView extends StatefulWidget {
//   FuncionalitieModel funcionalitie;

//   SubFuncionalitiesListView({Key? key, required this.funcionalitie})
//       : super(key: key);

//   @override
//   State<SubFuncionalitiesListView> createState() =>
//       _SubFuncionalitiesListViewState();
// }

// class _SubFuncionalitiesListViewState extends State<SubFuncionalitiesListView> {
//   late final SubFuncionalitiesController _controller =
//       SubFuncionalitiesController(
//           repository: SubFuncionalitiesRepository(api: gppApi));
//   final ResponsiveController _responsive = ResponsiveController();

//   fetchSubFuncionalities() async {
//     setState(() {
//       _controller.state = SubFuncionalitiesEnum.loading;
//     });

//     await _controller.fetch(widget.funcionalitie);

//     setState(() {
//       _controller.state = SubFuncionalitiesEnum.change;
//     });
//   }

//   handleDelete(context, SubFuncionalitiesModel subFuncionalitie) async {
//     NotifyController notify = NotifyController(context: context);
//     try {
//       if (await notify.alert("você deseja excluir essa subfuncionalidade?")) {
//         if (await _controller.delete(subFuncionalitie)) {
//           notify.sucess("Funcionalidade excluída!");
//           fetchSubFuncionalities();
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
//     fetchSubFuncionalities();
//   }

//   Widget _buildList(List<SubFuncionalitiesModel> subFuncionalities) {
//     Widget widget = LayoutBuilder(
//       builder: (context, constraints) {
//         if (_responsive.isMobile(constraints.maxWidth)) {
//           return ListView.builder(
//               itemCount: subFuncionalities.length,
//               itemBuilder: (context, index) {
//                 return _buildListItem(subFuncionalities, index, context);
//               });
//         }

//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                       child: Text('Foto',
//                           style: textStyle(
//                               color: Colors.grey.shade400,
//                               fontWeight: FontWeight.w700))),
//                   Expanded(
//                     flex: 2,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text('Nome',
//                             style: textStyle(
//                                 color: Colors.grey.shade400,
//                                 fontWeight: FontWeight.w700)),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Center(
//                         child: Text('Status',
//                             style: textStyle(
//                                 color: Colors.grey.shade400,
//                                 fontWeight: FontWeight.w700))),
//                   ),
//                   Expanded(
//                     child: Center(
//                         child: Text('Ação',
//                             style: textStyle(
//                                 color: Colors.grey.shade400,
//                                 fontWeight: FontWeight.w700))),
//                   )
//                 ],
//               ),
//             ),
//             const Divider(),
//             Expanded(
//               child: ListView.builder(
//                   itemCount: subFuncionalities.length,
//                   itemBuilder: (context, index) {
//                     return _buildListItem(subFuncionalities, index, context);
//                   }),
//             )
//           ],
//         );
//       },
//     );

//     return Container(color: Colors.white, child: widget);
//   }

//   Widget _buildListItem(List<SubFuncionalitiesModel> subFuncionalities,
//       int index, BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // if (_responsive.isMobile(constraints.maxWidth)) {
//         //   return Padding(
//         //     padding: const EdgeInsets.symmetric(vertical: 8.0),
//         //     child: Container(
//         //       decoration: BoxDecoration(
//         //           border: Border(
//         //               left: BorderSide(
//         //                   color: users[index].active == "1"
//         //                       ? secundaryColor
//         //                       : Colors.grey.shade400,
//         //                   width: 4))),
//         //       child: Padding(
//         //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         //         child: Column(
//         //           children: [
//         //             Row(
//         //               crossAxisAlignment: CrossAxisAlignment.start,
//         //               children: [
//         //                 SizedBox(
//         //                     height: 50,
//         //                     width: 50,
//         //                     child: ClipRRect(
//         //                       borderRadius: BorderRadius.circular(10),
//         //                       child: Image.network(
//         //                           'https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/female/68.png'),
//         //                     )),
//         //                 const SizedBox(
//         //                   width: 12,
//         //                 ),
//         //                 Column(
//         //                   mainAxisAlignment: MainAxisAlignment.start,
//         //                   crossAxisAlignment: CrossAxisAlignment.start,
//         //                   children: [
//         //                     Text(
//         //                       users[index].name!,
//         //                       style: textStyle(
//         //                           color: Colors.black,
//         //                           fontWeight: FontWeight.w700),
//         //                     ),
//         //                     const SizedBox(
//         //                       height: 6,
//         //                     ),
//         //                     users[index].departement != null
//         //                         ? Text(
//         //                             users[index].departement!,
//         //                             style: textStyle(
//         //                                 color: Colors.grey.shade400,
//         //                                 fontWeight: FontWeight.w700),
//         //                           )
//         //                         : Text('',
//         //                             style: textStyle(
//         //                                 color: Colors.black,
//         //                                 fontWeight: FontWeight.w700))
//         //                   ],
//         //                 )
//         //               ],
//         //             ),
//         //             const SizedBox(
//         //               height: 12,
//         //             ),
//         //             Row(
//         //               children: [
//         //                 IconButton(
//         //                   icon: Icon(
//         //                     Icons.edit,
//         //                     color: Colors.grey.shade400,
//         //                   ),
//         //                   onPressed: () => {
//         //                     Navigator.pushNamed(context, '/user_detail',
//         //                         arguments: users[index])
//         //                   },
//         //                 ),
//         //                 IconButton(
//         //                   icon: Icon(
//         //                     Icons.delete,
//         //                     color: Colors.grey.shade400,
//         //                   ),
//         //                   onPressed: () => {
//         //                     // Navigator.pushNamed(context, '/user_detail',
//         //                     //     arguments: users[index])
//         //                   },
//         //                 ),
//         //               ],
//         //             ),
//         //           ],
//         //         ),
//         //       ),
//         //     ),
//         //   );
//         // }

//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                         height: 50,
//                         width: 50,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.network(
//                               'https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/female/68.png'),
//                         )),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Text(
//                   subFuncionalities[index].name!,
//                   style: textStyle(
//                       color: Colors.black, fontWeight: FontWeight.w700),
//                 ),
//               ),
//               Expanded(
//                   child: Container(
//                 height: 10,
//                 width: 10,
//                 decoration: BoxDecoration(
//                     color: subFuncionalities[index].active!
//                         ? secundaryColor
//                         : Colors.grey.shade400,
//                     shape: BoxShape.circle),
//               )),
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         Icons.edit,
//                         color: Colors.grey.shade400,
//                       ),
//                       onPressed: () => {
//                         Navigator.pushNamed(
//                             context, '/subfuncionalities_update',
//                             arguments: subFuncionalities[index])
//                       },
//                     ),
//                     IconButton(
//                         icon: Icon(
//                           Icons.delete,
//                           color: Colors.grey.shade400,
//                         ),
//                         onPressed: () =>
//                             handleDelete(context, subFuncionalities[index])),
//                     IconButton(
//                         icon: Icon(
//                           Icons.list,
//                           color: Colors.grey.shade400,
//                         ),
//                         onPressed: () {
//                           // Navigator.pushNamed(
//                           //     context, '/funcionalities_detail',
//                           //     arguments: subFuncionalities[index]);
//                         }),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   _buildState() {
//     switch (_controller.state) {
//       case SubFuncionalitiesEnum.loading:
//         return const LoadingView();

//       case SubFuncionalitiesEnum.change:
//         return _buildList(_controller.subFuncionalities);
//       case SubFuncionalitiesEnum.notChange:
//         return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 24.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Subfuncionalidades',
//                   style: textStyle(fontSize: 18, fontWeight: FontWeight.w700),
//                 ),
//                 ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         shadowColor: Colors.transparent,
//                         elevation: 0,
//                         primary: primaryColor),
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/subfuncionalities_create',
//                           arguments: widget.funcionalitie);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Text('Cadastrar',
//                           style: textStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700)),
//                     ))
//               ],
//             ),
//           ),
//           Expanded(child: _buildState())
//         ],
//       ),
//     );
//   }
// }
