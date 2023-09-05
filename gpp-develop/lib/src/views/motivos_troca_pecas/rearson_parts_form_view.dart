import 'package:flutter/material.dart';

class RearsonPartsFormView extends StatefulWidget {
  const RearsonPartsFormView({Key? key}) : super(key: key);

  @override
  _RearsonPartsFormViewState createState() => _RearsonPartsFormViewState();
}

class _RearsonPartsFormViewState extends State<RearsonPartsFormView> {
  var contador = 0;

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    return Column(
      children: [
        Container(
          color: Colors.blue,
          height: media.size.height * 0.7,
        )
      ],
    );

    // return LayoutBuilder(builder:(context, constraints) {

    //   if(constraints.maxWidth < 600){
    //     return Container(child: Text("Resposivo"),);
    //   }

    // return Container(
    //   color: Colors.red,
    //   child: Column(
    //     children: [
    //       Container(
    //         color: Colors.green,
    //         child: Row(children: [
    //           Text('Cadastrar Motivo'),
    //         ],),
    //       ),
    //        Container(
    //         color: Colors.blue,
    //         child: Row(children: [
    //           Text('Cadastrar Motivo'),
    //         ],),
    //       ),
    //        Container(
    //         color: Colors.yellow,
    //         child: Row(children: [
    //           Expanded(
    //             child: Container(
    //               color: Colors.pink,
    //               child: Column(
    //                 children: [
    //                   Text('Cadastrar Motivo')
    //                 ],
    //               ),
    //             ),
    //           ),
    //            Expanded(
    //              child: Container(
    //                color: Colors.indigo,
    //                child: Column(
    //                 children: [
    //                   Text('Cadastrar Motivo')
    //                 ],
    //                          ),
    //              ),
    //            ),
    //         ],),
    //       ),

    //     ],
    //   ),
    // );
    // },);
  }
}
