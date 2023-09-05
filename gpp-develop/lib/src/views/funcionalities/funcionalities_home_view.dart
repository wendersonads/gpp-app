// import 'package:flutter/material.dart';
// import 'package:gpp/src/models/funcionalitie_model.dart';
// import 'package:gpp/src/views/funcionalities/funcionalities_detail_view.dart';

// import 'package:gpp/src/views/funcionalities/funcionalities_form_update_view.dart';
// import 'package:gpp/src/views/funcionalities/funcionalities_list_view.dart';

// class FuncionalitiesHomeView extends StatefulWidget {
//   const FuncionalitiesHomeView({Key? key}) : super(key: key);

//   @override
//   _FuncionalitiesHomeViewState createState() => _FuncionalitiesHomeViewState();
// }

// class _FuncionalitiesHomeViewState extends State<FuncionalitiesHomeView> {
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       onGenerateRoute: (settings) {
//         var route = settings.name;
//         Widget page;
//         switch (route) {
//           case '/funcionalities_update':
//             final funcionalitie = settings.arguments as FuncionalitieModel;
//             page = FuncionalitieFormUpdateView(
//               funcionalitie: funcionalitie,
//             );
//             break;
//           case '/funcionalities_create':
//             //page = FuncionalitieFormCreateView();
//             break;
//           case '/funcionalities_detail':
//             final funcionalitie = settings.arguments as FuncionalitieModel;
//             page = FuncionalitiesDetailView(
//               funcionalitie: funcionalitie,
//             );

//             break;

//           default:
//             page = FuncionalitiesListView();
//             break;
//         }

//         return MaterialPageRoute(
//             builder: (context) => page, settings: settings);
//       },
//     );

//     // return Padding(
//     //   padding: const EdgeInsets.all(16.0),
//     //   child: Column(
//     //     children: [
//     //       Row(
//     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //         children: [
//     //           Text(
//     //             'Funcionalidades',
//     //             style: textStyle(fontSize: 18, fontWeight: FontWeight.w700),
//     //           ),
//     //           ElevatedButton(
//     //               style: ElevatedButton.styleFrom(
//     //                   shadowColor: Colors.transparent,
//     //                   elevation: 0,
//     //                   primary: primaryColor),
//     //               onPressed: () {
//     //                 Navigator.pushNamed(context, '/funcionalitie_create');
//     //               },
//     //               child: Padding(
//     //                 padding: const EdgeInsets.all(12.0),
//     //                 child: Text('Cadastrar',
//     //                     style: textStyle(
//     //                         color: Colors.white, fontWeight: FontWeight.w700)),
//     //               ))
//     //         ],
//     //       ),
//     //       SizedBox(
//     //         height: 24,
//     //       ),
//     //       Expanded(child: FuncionalitiesListView())
//     //     ],
//     //   ),
//     // );
//   }
// }
