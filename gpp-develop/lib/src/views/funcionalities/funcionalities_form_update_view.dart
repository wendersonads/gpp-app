// import 'package:flutter/material.dart';

// import 'package:gpp/src/controllers/funcionalities_controller.dart';
// import 'package:gpp/src/controllers/notify_controller.dart';
// import 'package:gpp/src/models/FuncionalidadeModel.dart';
// import 'package:gpp/src/shared/repositories/styles.dart';

// // ignore: must_be_immutable
// class FuncionalitieFormUpdateView extends StatefulWidget {
//   FuncionalidadeModel funcionalidade;

//   FuncionalitieFormUpdateView({
//     Key? key,
//     required this.funcionalidade,
//   }) : super(key: key);

//   @override
//   _FuncionalitieFormUpdateViewState createState() =>
//       _FuncionalitieFormUpdateViewState();
// }

// class _FuncionalitieFormUpdateViewState
//     extends State<FuncionalitieFormUpdateView> {
//   FuncionalitiesController _controlller = FuncionalitiesController();

//   handleUpdate(context, FuncionalidadeModel funcionalitie) async {
//     NotifyController notify = NotifyController(context: context);
//     try {
//       if (await _controlller.update()) {
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
//                 initialValue: widget.funcionalidade.nome,
//                 maxLength: 255,
//                 onChanged: (value) {
//                   setState(() {
//                     widget.funcionalidade.nome = value;
//                   });
//                 },
//                 validator: (value) => _controlller.validate(value),
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
//                 initialValue: widget.funcionalidade.icone,
//                 maxLength: 255,
//                 onChanged: (value) {
//                   setState(() {
//                     widget.funcionalidade.icone = value;
//                   });
//                 },
//                 validator: (value) => _controlller.validate(value),
//                 keyboardType: TextInputType.number,
//                 style: textStyle(
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                     fontSize: 14,
//                     height: 1.8),
//                 decoration:
//                     inputDecoration('Icon', const Icon(Icons.account_box)),
//               ),
//               Row(
//                 children: [
//                   Radio(
//                       value: true,
//                       groupValue: widget.funcionalidade.situacao,
//                       onChanged: (bool? value) {
//                         setState(() {
//                           widget.funcionalidade.situacao = value;
//                         });
//                       }),
//                   SizedBox(
//                     width: 12,
//                   ),
//                   Text("Habilitado"),
//                   Radio(
//                       value: false,
//                       groupValue: widget.funcionalidade.situacao,
//                       onChanged: (bool? value) {
//                         setState(() {
//                           widget.funcionalidade.situacao = value;
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
//                           handleUpdate(context, widget.funcionalidade),
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
