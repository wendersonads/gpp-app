// import 'package:flutter/material.dart';
// import 'package:gpp/src/controllers/notify_controller.dart';
// import 'package:gpp/src/controllers/subfuncionalities_controller.dart';
// import 'package:gpp/src/models/funcionalitie_model.dart';

// import 'package:gpp/src/repositories/subfuncionalities_repository.dart';
// import 'package:gpp/src/shared/repositories/styles.dart';
// import 'package:gpp/src/shared/services/gpp_api.dart';

// // ignore: must_be_immutable
// class SubFuncionalitiesFormCreateView extends StatefulWidget {
//   FuncionalitieModel funcionalitie;

//   SubFuncionalitiesFormCreateView({Key? key, required this.funcionalitie})
//       : super(key: key);

//   @override
//   _SubFuncionalitiesFormCreateViewState createState() =>
//       _SubFuncionalitiesFormCreateViewState();
// }

// class _SubFuncionalitiesFormCreateViewState
//     extends State<SubFuncionalitiesFormCreateView> {
//   SubFuncionalitiesController _controller = SubFuncionalitiesController(
//       repository: SubFuncionalitiesRepository(api: gppApi));

//   handleCreate(context) async {
//     NotifyController nofity = NotifyController(context: context);
//     try {
//       if (await _controller.create(widget.funcionalitie)) {
//         //Realiza notificação

//         nofity.sucess("Funcionalidade cadastrada!");
//         Navigator.pushReplacementNamed(context, '/funcionalities');
//       }
//     } catch (e) {
//       nofity.error(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//         key: _controller.formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               TextFormField(
//                 maxLength: 255,
//                 onSaved: (value) => _controller.setSubFuncionalitieName(value),
//                 validator: (value) => _controller.validateInput(value),
//                 keyboardType: TextInputType.number,
//                 style: textStyle(
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                     fontSize: 14,
//                     height: 1.8),
//                 decoration: inputDecoration(
//                     'Subfuncionalidade', const Icon(Icons.view_list)),
//               ),
//               TextFormField(
//                 maxLength: 255,
//                 onSaved: (value) => _controller.setSubFuncionalitieIcon(value),
//                 validator: (value) => _controller.validateInput(value),
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
//                 maxLength: 255,
//                 onSaved: (value) => _controller.setSubFuncionalitieRoute(value),
//                 validator: (value) => _controller.validateInput(value),
//                 keyboardType: TextInputType.number,
//                 style: textStyle(
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                     fontSize: 14,
//                     height: 1.8),
//                 decoration:
//                     inputDecoration('Rota', const Icon(Icons.account_box)),
//               ),
//               Row(
//                 children: [
//                   Radio(
//                       value: true,
//                       groupValue: _controller.subFuncionalitie.active,
//                       onChanged: (value) {
//                         setState(() {
//                           _controller.setSubFuncionalitieActive(value);
//                         });
//                       }),
//                   SizedBox(
//                     width: 12,
//                   ),
//                   Text("Habilitado"),
//                   Radio(
//                       value: false,
//                       groupValue: _controller.subFuncionalitie.active,
//                       onChanged: (value) {
//                         setState(() {
//                           _controller.setSubFuncionalitieActive(value);
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
//                       onPressed: () => handleCreate(context),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Text('Cadastrar',
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
