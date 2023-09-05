// import 'package:flutter/material.dart';

// import 'package:gpp/src/controllers/notify_controller.dart';
// import 'package:gpp/src/controllers/subfuncionalities_controller.dart';
// import 'package:gpp/src/models/subfuncionalities_model.dart';
// import 'package:gpp/src/repositories/subfuncionalities_repository.dart';
// import 'package:gpp/src/shared/repositories/styles.dart';
// import 'package:gpp/src/shared/services/gpp_api.dart';

// // ignore: must_be_immutable
// class SubFuncionalitiesFormUpdateView extends StatefulWidget {
//   SubFuncionalitiesModel subFuncionalitie;

//   SubFuncionalitiesFormUpdateView({
//     Key? key,
//     required this.subFuncionalitie,
//   }) : super(key: key);

//   @override
//   _SubFuncionalitiesFormUpdateViewState createState() =>
//       _SubFuncionalitiesFormUpdateViewState();
// }

// class _SubFuncionalitiesFormUpdateViewState
//     extends State<SubFuncionalitiesFormUpdateView> {
//   SubFuncionalitiesController _controlller = SubFuncionalitiesController(
//       repository: SubFuncionalitiesRepository(api: gppApi));

//   handleUpdate(context, SubFuncionalitiesModel subFuncionalitie) async {
//     NotifyController notify = NotifyController(context: context);
//     try {
//       if (await _controlller.update(subFuncionalitie)) {
//         notify.sucess("Funcionalidade atualizada!");
//         Navigator.pushReplacementNamed(context, 'funcionalitie_lists');
//       }
//     } catch (e) {
//       notify.error(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//         key: _controlller.formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               TextFormField(
//                 initialValue: widget.subFuncionalitie.name,
//                 maxLength: 255,
//                 onChanged: (value) {
//                   setState(() {
//                     widget.subFuncionalitie.name = value;
//                   });
//                 },
//                 validator: (value) => _controlller.validateInput(value),
//                 keyboardType: TextInputType.number,
//                 style: textStyle(
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                     fontSize: 14,
//                     height: 1.8),
//                 decoration: inputDecoration(
//                     'Funcionalidade', const Icon(Icons.view_list)),
//               ),
//               TextFormField(
//                 initialValue: widget.subFuncionalitie.icon,
//                 maxLength: 255,
//                 onChanged: (value) {
//                   setState(() {
//                     widget.subFuncionalitie.icon = value;
//                   });
//                 },
//                 validator: (value) => _controlller.validateInput(value),
//                 keyboardType: TextInputType.number,
//                 style: textStyle(
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                     fontSize: 14,
//                     height: 1.8),
//                 decoration:
//                     inputDecoration('Icon', const Icon(Icons.account_box)),
//               ),
//               TextFormField(
//                 initialValue: widget.subFuncionalitie.route,
//                 maxLength: 255,
//                 onChanged: (value) {
//                   setState(() {
//                     widget.subFuncionalitie.route = value;
//                   });
//                 },
//                 validator: (value) => _controlller.validateInput(value),
//                 keyboardType: TextInputType.number,
//                 style: textStyle(
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                     fontSize: 14,
//                     height: 1.8),
//                 decoration:
//                     inputDecoration('Rota', const Icon(Icons.view_list)),
//               ),
//               Row(
//                 children: [
//                   Radio(
//                       value: true,
//                       groupValue: widget.subFuncionalitie.active,
//                       onChanged: (bool? value) {
//                         setState(() {
//                           widget.subFuncionalitie.active = value;
//                         });
//                       }),
//                   SizedBox(
//                     width: 12,
//                   ),
//                   Text("Habilitado"),
//                   Radio(
//                       value: false,
//                       groupValue: widget.subFuncionalitie.active,
//                       onChanged: (bool? value) {
//                         setState(() {
//                           widget.subFuncionalitie.active = value;
//                         });
//                       }),
//                   SizedBox(
//                     width: 12,
//                   ),
//                   Text("Desabilitado"),
//                 ],
//               ),
//               SizedBox(
//                 height: 12,
//               ),
//               Row(
//                 children: [
//                   ElevatedButton(
//                       style: buttonStyle,
//                       onPressed: () =>
//                           handleUpdate(context, widget.subFuncionalitie),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Text('Atualizar',
//                             style: textStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700)),
//                       )),
//                 ],
//               )
//             ],
//           ),
//         ));
//   }
// }
