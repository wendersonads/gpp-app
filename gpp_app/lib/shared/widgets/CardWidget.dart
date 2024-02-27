import 'package:flutter/material.dart';

import '../components/styles.dart';


class CardWidget extends StatefulWidget {
  final Widget widget;
  final Color? color;
  const CardWidget({
    Key? key,
    required this.widget,
    this.color,
  }) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool _onHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (value) {
        setState(() {
          _onHover = true;
        });
      },
      onExit: (value) {
        setState(() {
          _onHover = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: _onHover ? Colors.grey.shade50 : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 2,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
          border: Border(
            left: BorderSide(
              color: widget.color ?? secundaryColor,
              width: 7.0,
            ),
          ),
        ),
        child: widget.widget,
      ),
    );
  }
}
