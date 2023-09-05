import 'package:flutter/material.dart';

class CorredorFormView extends StatefulWidget {
  const CorredorFormView({Key? key}) : super(key: key);

  @override
  CorredorFormViewState createState() => CorredorFormViewState();
}

class CorredorFormViewState extends State<CorredorFormView> {
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
  }
}
