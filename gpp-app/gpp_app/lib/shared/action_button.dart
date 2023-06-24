import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton(
      {super.key, required this.text, required this.buttonAction});

  final String text;
  final Function() buttonAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25, top: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => buttonAction(),
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(30, 40),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: const Color.fromARGB(255, 0, 197, 0),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255)),
        child: Text(text),
      ),
    );
  }
}
