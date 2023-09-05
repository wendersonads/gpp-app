// import 'package:flutter/material.dart';
// import 'package:gpp/src/shared/components/titleComponent.dart';
// import 'package:gpp/src/shared/repositories/styles.dart';
// import 'package:gpp/src/views/asteca/components/item_menu.dart';
// import 'peca_enderecamento_detail_view.dart';

// class MenuEnderecamentoPecaView extends StatefulWidget {
//   const MenuEnderecamentoPecaView({Key? key}) : super(key: key);

//   @override
//   _MenuEnderecamentoPecaViewState createState() => _MenuEnderecamentoPecaViewState();
// }

// class _MenuEnderecamentoPecaViewState extends State<MenuEnderecamentoPecaView> {
//   int selected = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: _pecasMenu(),
//         ),
//         Padding(padding: EdgeInsets.only(left: 20)),
//         Expanded(
//           flex: 4,
//           child: Column(
//             children: [
//               _enderecamentoPecasNavigator(),
//             ],
//           ),
//         ),
//         Padding(padding: EdgeInsets.only(left: 20)),
//       ],
//     );
//   }

//   _pecasMenu() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 20, top: 10),
//           child: const TitleComponent(
//             'Cadastros',
//           ),
//         ),
//         Divider(),
//         Row(
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selected = 1;
//                   });
//                 },
//                 child: ItemMenu(
//                   color: selected == 1 ? Colors.grey.shade50 : Colors.transparent,
//                   borderColor: selected == 1 ? secundaryColor : Colors.transparent,
//                   data: 'Lista Enderecamento',
//                 ),
//               ),
//             ),
//           ],
//         ),
//         /*Row(
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selected = 2;
//                   });
//                 },
//                 child: ItemMenu(
//                   color: selected == 2 ? Colors.grey.shade50 : Colors.transparent,
//                   borderColor: selected == 2 ? secundaryColor : Colors.transparent,
//                   data: 'Cores',
//                 ),
//               ),
//             ),
//           ],
//         ),*/
//       ],
//     );
//   }

//   _enderecamentoPecasNavigator() {
//     switch (selected) {
//       case 1:
//         return PecaEnderecamentoDetailView();
//       case 2:
//         //return CoresDetailView();
//     }
//   }
// }
