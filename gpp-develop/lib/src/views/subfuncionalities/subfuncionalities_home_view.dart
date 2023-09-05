// import 'package:flutter/material.dart';
// import 'package:gpp/src/models/funcionalitie_model.dart';
// import 'package:gpp/src/models/subfuncionalities_model.dart';
// import 'package:gpp/src/views/subfuncionalities/subfuncionalities_form_update_view.dart';
// import 'package:gpp/src/views/subfuncionalities/subfuncionalities_list_view.dart';
// import 'package:gpp/src/views/subfuncionalities/subfuncionatilies_form_create_view.dart';

// // ignore: must_be_immutable
// class SubFuncionalitiesHomeView extends StatefulWidget {
//   FuncionalitieModel funcionalitie;
//   SubFuncionalitiesHomeView({Key? key, required this.funcionalitie})
//       : super(key: key);

//   @override
//   State<SubFuncionalitiesHomeView> createState() =>
//       _SubFuncionalitiesHomeViewState();
// }

// class _SubFuncionalitiesHomeViewState extends State<SubFuncionalitiesHomeView> {
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       onGenerateRoute: (settings) {
//         var route = settings.name;
//         Widget page;
//         switch (route) {
//           case '/subfuncionalities_create':
//             final funcionalitie = settings.arguments as FuncionalitieModel;
//             page = SubFuncionalitiesFormCreateView(
//               funcionalitie: funcionalitie,
//             );

//             break;

//           case '/subfuncionalities_update':
//             final subFuncionalitie =
//                 settings.arguments as SubFuncionalitiesModel;
//             page = SubFuncionalitiesFormUpdateView(
//               subFuncionalitie: subFuncionalitie,
//             );

//             break;

//           default:
//             page =
//                 SubFuncionalitiesListView(funcionalitie: widget.funcionalitie);
//             break;
//         }

//         return MaterialPageRoute(
//             builder: (context) => page, settings: settings);
//       },
//     );
//   }
// }
