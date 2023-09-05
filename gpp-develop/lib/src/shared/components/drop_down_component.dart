import 'package:flutter/material.dart';

import 'package:gpp/src/shared/components/TextComponent.dart';

class DropDownComponent extends StatelessWidget {
  final String? label;
  final Icon? icon;
  final String? hintText;
  final Function? onChanged;
  final List<DropdownMenuItem<dynamic>> items;
  const DropDownComponent({
    Key? key,
    this.label,
    this.icon,
    this.hintText,
    this.onChanged,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null ? TextComponent(label!) : Container(),
        label != null
            ? SizedBox(
                height: 8,
              )
            : Container(),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5)),
          child: DropdownButtonFormField<dynamic>(
            isExpanded: true,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16 * media.textScaleFactor,
                letterSpacing: 0.15,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(top: 15, bottom: 10, left: 10, right: 10),
                hintText: hintText,
                prefixIcon: icon,
                hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16 * media.textScaleFactor,
                    letterSpacing: 0.15,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500),
                border: InputBorder.none),
            items: items,
            onChanged: (value) => onChanged!(value),
          ),
        ),
      ],
    );
  }
}
