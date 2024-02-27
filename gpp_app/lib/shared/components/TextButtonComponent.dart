import 'package:flutter/material.dart';
import 'styles.dart';

import 'TextComponent.dart';

class TextButtonComponent extends StatefulWidget {
  final Function onPressed;
  final String text;
  TextButtonComponent({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  State<TextButtonComponent> createState() => _TextButtonComponentState();
}

class _TextButtonComponentState extends State<TextButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          widget.onPressed();
        },
        child: TextComponent(
          widget.text,
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 0.20,
        ));
  }
}
