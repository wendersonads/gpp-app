import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/utils/dispositivo.dart';

class DropdownButtonFormFieldComponent extends StatelessWidget {
  final dynamic value;
  final List<DropdownMenuItem> items;
  final Widget? hint;
  final Function onChanged;
  final String? hintText;
  final String? label;
  final Color? color;
  final Function? validator;
  DropdownButtonFormFieldComponent(
      {Key? key,
      this.value,
      required this.items,
      this.hint,
      required this.onChanged,
      this.hintText,
      this.label,
      this.color,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          label != null
              ? Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: SelectableText(
                    label!,
                    style: textStyleTexto,
                  ),
                )
              : Container()
        ]),
        Container(
          height: !Dispositivo.mobile(context.width) ? 100 : 80,
          child: Container(
            child: DropdownButtonFormField<dynamic>(
              icon: Visibility(
                visible: true,
                child: Icon(Icons.arrow_drop_down),
              ),
              value: value,
              validator: (value) {
                if (validator != null) {
                  return validator!(value);
                }
                return null;
              },
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12 * context.textScaleFactor,
                  letterSpacing: 0.15,
                  height: 2,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: EdgeInsets.only(top: 5, bottom: 10, left: 10),
                  hintStyle: TextStyle(color: color ?? Colors.grey.shade400)),
              hint: hint,
              items: items,
              onChanged: (value) => onChanged(value),
            ),
          ),
        ),
      ],
    );
  }
}
