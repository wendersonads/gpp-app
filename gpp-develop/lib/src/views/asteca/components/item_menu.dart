import 'package:flutter/material.dart';

class ItemMenu extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final String data;
  const ItemMenu({
    Key? key,
    required this.color,
    required this.borderColor,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          border: Border(
            left: BorderSide(
              color: borderColor,
              width: 7.0,
            ),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
            child: Text(
              data,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                letterSpacing: 0.15,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
