import 'package:auth_migration/shared/components/styles.dart';
import 'package:flutter/material.dart';


class CheckboxComponent extends StatelessWidget {
  final bool value;
  final Function onChanged;
  CheckboxComponent({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        activeColor: primaryColor,
        checkColor: Colors.white,
        value: value,
        onChanged: (value) => onChanged(value));
  }
}
